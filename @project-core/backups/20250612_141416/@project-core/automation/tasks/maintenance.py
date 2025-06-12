#!/usr/bin/env python3
"""
🧹 MAINTENANCE MANAGER - VIBECODE SYSTEM V4.0

Consolidação de todos os scripts de backup e limpeza:
- smart-backup-system-v4.ps1, backup-monitoring-system.ps1
- backup-system-validator-v4.ps1, consolidate-backups.ps1
- safe-cleanup-with-dryrun.ps1, project-core-cleanup-phase2.ps1
- comprehensive-file-consolidation-scanner.ps1, targeted-optimization-executor.ps1

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import os
import sys
import shutil
import glob
from pathlib import Path
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Tuple

# Importar helpers VIBECODE V4.0
try:
    # Adicionar caminho dos helpers ao sys.path
    sys.path.insert(0, str(Path(__file__).parent.parent))
    from helpers.core.logger_utils import get_vibecode_logger, log_execution_start, log_execution_end, log_step
    from helpers.core.argument_parser import create_maintenance_parser
    from helpers.system.path_utils import VibeCodePaths, get_directory_size, find_files_by_age
    from helpers.system.backup_utils import BackupManager
    from helpers.data.json_utils import safe_load_json, safe_save_json, create_report_json
    HELPERS_AVAILABLE = True
except ImportError as e:
    # Fallback para compatibilidade
    import logging
    import argparse
    import json
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    logger = logging.getLogger(__name__)
    HELPERS_AVAILABLE = False
    print(f"⚠️ Helpers não disponíveis (usando fallback): {e}")

# Configurar logger
if HELPERS_AVAILABLE:
    logger = get_vibecode_logger("maintenance")
else:
    logger = logging.getLogger(__name__)

class MaintenanceManager:
    """Gerenciador consolidado de manutenção VIBECODE V4.0."""

    def __init__(self, project_root: str = None):
        # Usar helper de paths se disponível
        if HELPERS_AVAILABLE:
            self.paths = VibeCodePaths(project_root)
            self.project_root = self.paths.project_root
            self.project_core = self.paths.project_core
            self.backups_dir = self.paths.backups_path
            self.logs_dir = self.paths.logs_path
            self.critical_files = [str(p.relative_to(self.project_root)) for p in self.paths.get_critical_files()]

            # Inicializar BackupManager com configurações VIBECODE
            self.backup_manager = BackupManager(self.backups_dir)
            self.backup_manager.config.update({
                "max_backups": 5,
                "compression": "zip",
                "size_limit_mb": 100
            })
        else:
            # Fallback para compatibilidade
            self.project_root = Path(project_root) if project_root else Path.cwd()
            self.project_core = self.project_root / "@project-core"
            self.backups_dir = self.project_core / "backups"
            self.logs_dir = self.project_core / "logs"

            # Arquivos críticos protegidos
            self.critical_files = [
                "@project-core/memory/master_rule.md",
                "@project-core/memory/self_correction_log.md",
                "@project-core/memory/global-standards.md",
                "@project-core/rules/00-vibecode-system-v4-master.md"
            ]
            self.backup_manager = None

        # Configurações de manutenção
        self.config = {
            "max_backup_size_mb": 100,
            "max_total_backups_gb": 1,
            "backup_retention_days": 30,
            "log_retention_days": 7,
            "cache_retention_days": 3
        }

        # Padrões de exclusão para backup (mantido para compatibilidade)
        self.exclusion_patterns = [
            "*/backups/*", "*/backup/*", "*/.backup/*",  # Previne recursão
            "*/node_modules/*", "*/.git/*", "*/.next/*",  # Diretórios grandes
            "*/dist/*", "*/build/*", "*/.cache/*",        # Artefatos de build
            "*/__pycache__/*", "*.pyc", "*.pyo",          # Cache Python
            "*.tmp", "*.temp", "*.log"                     # Arquivos temporários
        ]

    def create_backup(self, source_path: str = None, backup_name: str = None,
                     dry_run: bool = False) -> bool:
        """
        Cria backup inteligente com proteção contra recursão.
        Equivalente a: smart-backup-system-v4.ps1
        """
        log_step(logger, "💾 Iniciando sistema de backup inteligente...")

        source = Path(source_path) if source_path else self.project_core

        if dry_run:
            if HELPERS_AVAILABLE:
                size_mb, _ = get_directory_size(source)
                size_mb = size_mb / (1024 * 1024)
            else:
                size_mb = self._estimate_backup_size(source)
            logger.info(f"🔍 DRY RUN: Backup seria criado ({size_mb:.2f}MB)")
            return size_mb < self.config["max_backup_size_mb"]

        # Verificar proteção de arquivos críticos
        if not self._verify_critical_files():
            logger.error("❌ Arquivos críticos ausentes - backup abortado")
            return False

        # Usar BackupManager se disponível
        if HELPERS_AVAILABLE and self.backup_manager:
            try:
                backup_path = self.backup_manager.create_backup(
                    source=source,
                    backup_name=backup_name,
                    exclude_patterns=self.exclusion_patterns
                )

                if backup_path:
                    # Criar metadados adicionais VIBECODE
                    metadata = create_report_json(
                        title="VIBECODE Backup Report",
                        data={
                            "source": str(source),
                            "backup_path": str(backup_path),
                            "exclusion_patterns": self.exclusion_patterns,
                            "critical_files_verified": True
                        }
                    )

                    metadata_file = backup_path.parent / f"{backup_path.name}_vibecode_metadata.json"
                    safe_save_json(metadata, metadata_file)

                    logger.info(f"✅ Backup criado com BackupManager: {backup_path}")
                    return True
                else:
                    logger.error("❌ BackupManager falhou ao criar backup")
                    return False

            except Exception as e:
                logger.error(f"❌ Erro no BackupManager: {e}")
                # Fallback para método manual
                return self._create_backup_manual(source, backup_name)
        else:
            # Fallback para método manual
            return self._create_backup_manual(source, backup_name)

    def monitor_backups(self, auto_cleanup: bool = False) -> Dict[str, any]:
        """
        Monitora sistema de backups e detecta problemas.
        Equivalente a: backup-monitoring-system.ps1
        """
        log_step(logger, "📊 Monitorando sistema de backups...")

        # Usar BackupManager se disponível
        if HELPERS_AVAILABLE and self.backup_manager:
            try:
                # Obter estatísticas do BackupManager
                stats = self.backup_manager.get_backup_stats()
                backups_list = self.backup_manager.list_backups()

                # Detectar problemas usando configurações VIBECODE
                issues = []
                total_size_gb = stats["total_size_mb"] / 1024

                if total_size_gb > self.config["max_total_backups_gb"]:
                    issues.append(f"Total de backups excede limite: {total_size_gb:.2f}GB > {self.config['max_total_backups_gb']}GB")

                # Detectar backups antigos
                cutoff_date = datetime.now() - timedelta(days=self.config["backup_retention_days"])
                old_backups = [b["name"] for b in backups_list if b["created"] < cutoff_date]

                if old_backups:
                    issues.append(f"{len(old_backups)} backups antigos encontrados")

                # Auto-limpeza se solicitada
                if auto_cleanup and old_backups:
                    log_step(logger, "🧹 Executando limpeza automática com BackupManager...")
                    removed = self.backup_manager.cleanup_old_backups(
                        max_age_days=self.config["backup_retention_days"],
                        max_count=self.backup_manager.config["max_backups"]
                    )
                    logger.info(f"✅ {len(removed)} backups removidos automaticamente")

                status = {
                    "status": "healthy" if not issues else "issues_detected",
                    "total_size_gb": round(total_size_gb, 2),
                    "backup_count": stats["total_backups"],
                    "issues": issues,
                    "old_backups": old_backups,
                    "using_backup_manager": True
                }

                logger.info(f"📊 Status (BackupManager): {status['backup_count']} backups, {status['total_size_gb']}GB")
                return status

            except Exception as e:
                logger.warning(f"⚠️ Erro no BackupManager, usando fallback: {e}")
                # Fallback para método manual

        # Método manual (fallback)
        return self._monitor_backups_manual(auto_cleanup)

    def validate_backups(self) -> Dict[str, bool]:
        """
        Valida integridade dos backups existentes.
        Equivalente a: backup-system-validator-v4.ps1
        """
        logger.info("🔍 Validando integridade dos backups...")

        if not self.backups_dir.exists():
            logger.warning("⚠️ Nenhum backup para validar")
            return {}

        results = {}
        backups = [d for d in self.backups_dir.iterdir() if d.is_dir()]

        for backup in backups:
            logger.info(f"🔍 Validando backup: {backup.name}")

            # Verificar metadados
            metadata_file = backup / "backup_metadata.json"
            if not metadata_file.exists():
                results[backup.name] = False
                logger.error(f"❌ Metadados ausentes: {backup.name}")
                continue

            try:
                with open(metadata_file, 'r') as f:
                    metadata = json.load(f)

                # Verificar contagem de arquivos
                actual_files = len(list(backup.rglob("*"))) - 1  # -1 para excluir metadata
                expected_files = metadata.get("files_count", 0)

                if actual_files != expected_files:
                    results[backup.name] = False
                    logger.error(f"❌ Contagem de arquivos incorreta: {backup.name} ({actual_files} != {expected_files})")
                    continue

                # Verificar arquivos críticos
                critical_found = 0
                for critical_file in self.critical_files:
                    file_name = Path(critical_file).name
                    if list(backup.rglob(file_name)):
                        critical_found += 1

                if critical_found < len(self.critical_files) // 2:  # Pelo menos metade
                    results[backup.name] = False
                    logger.error(f"❌ Poucos arquivos críticos: {backup.name}")
                    continue

                results[backup.name] = True
                logger.info(f"✅ Backup válido: {backup.name}")

            except Exception as e:
                results[backup.name] = False
                logger.error(f"❌ Erro na validação de {backup.name}: {e}")

        return results

    def consolidate_backups(self, dry_run: bool = False) -> bool:
        """
        Consolida backups antigos para economizar espaço.
        Equivalente a: consolidate-backups.ps1
        """
        logger.info("📦 Consolidando backups...")

        if not self.backups_dir.exists():
            logger.warning("⚠️ Nenhum backup para consolidar")
            return True

        backups = sorted([d for d in self.backups_dir.iterdir() if d.is_dir()],
                        key=lambda x: x.stat().st_mtime)

        if len(backups) <= 3:  # Manter pelo menos 3 backups
            logger.info("📦 Poucos backups, consolidação não necessária")
            return True

        # Consolidar backups antigos (manter apenas os 3 mais recentes)
        backups_to_remove = backups[:-3]

        if dry_run:
            logger.info(f"🔍 DRY RUN: {len(backups_to_remove)} backups seriam removidos")
            for backup in backups_to_remove:
                logger.info(f"  - {backup.name}")
            return True

        # Remover backups antigos
        removed_count = 0
        for backup in backups_to_remove:
            try:
                shutil.rmtree(backup)
                removed_count += 1
                logger.info(f"🗑️ Backup removido: {backup.name}")
            except Exception as e:
                logger.error(f"❌ Erro ao remover {backup.name}: {e}")

        logger.info(f"✅ Consolidação concluída: {removed_count} backups removidos")
        return removed_count > 0

    def cleanup_system(self, target: str = None, dry_run: bool = False) -> Dict[str, int]:
        """
        Limpeza segura do sistema com proteção de arquivos críticos.
        Equivalente a: safe-cleanup-with-dryrun.ps1, project-core-cleanup-phase2.ps1
        """
        logger.info("🧹 Iniciando limpeza segura do sistema...")

        # Verificar proteção de arquivos críticos
        if not self._verify_critical_files():
            logger.error("❌ Arquivos críticos ausentes - limpeza abortada")
            return {}

        target_path = Path(target) if target else self.project_core
        results = {
            "logs_cleaned": 0,
            "cache_cleaned": 0,
            "temp_files_cleaned": 0,
            "old_backups_cleaned": 0
        }

        # Limpeza de logs antigos
        results["logs_cleaned"] = self._cleanup_logs(dry_run)

        # Limpeza de cache
        results["cache_cleaned"] = self._cleanup_cache(target_path, dry_run)

        # Limpeza de arquivos temporários
        results["temp_files_cleaned"] = self._cleanup_temp_files(target_path, dry_run)

        # Limpeza de backups antigos
        results["old_backups_cleaned"] = self._cleanup_old_backups_by_age(dry_run)

        total_cleaned = sum(results.values())
        logger.info(f"✅ Limpeza concluída: {total_cleaned} itens processados")

        return results

    def scan_consolidation_opportunities(self) -> Dict[str, List[str]]:
        """
        Escaneia oportunidades de consolidação de arquivos.
        Equivalente a: comprehensive-file-consolidation-scanner.ps1
        """
        logger.info("🔍 Escaneando oportunidades de consolidação...")

        opportunities = {
            "duplicate_scripts": [],
            "similar_configs": [],
            "redundant_docs": [],
            "unused_files": []
        }

        # Detectar scripts duplicados
        script_patterns = ["*.ps1", "*.py", "*.js"]
        for pattern in script_patterns:
            scripts = list(self.project_core.rglob(pattern))
            script_names = {}

            for script in scripts:
                name = script.stem
                if name in script_names:
                    opportunities["duplicate_scripts"].append(f"{name}: {script} vs {script_names[name]}")
                else:
                    script_names[name] = script

        # Detectar configurações similares
        config_files = list(self.project_core.rglob("*.json")) + list(self.project_core.rglob("*.yml"))
        for config in config_files:
            if "config" in config.name.lower() or "settings" in config.name.lower():
                opportunities["similar_configs"].append(str(config))

        # Detectar documentação redundante
        doc_files = list(self.project_core.rglob("*.md"))
        readme_files = [f for f in doc_files if "readme" in f.name.lower()]
        if len(readme_files) > 3:
            opportunities["redundant_docs"] = [str(f) for f in readme_files[3:]]

        logger.info(f"🔍 Oportunidades encontradas: {sum(len(v) for v in opportunities.values())}")
        return opportunities

    def _verify_critical_files(self) -> bool:
        """Verifica se arquivos críticos existem."""
        missing_files = []
        for file_path in self.critical_files:
            full_path = self.project_root / file_path
            if not full_path.exists():
                missing_files.append(file_path)

        if missing_files:
            logger.error(f"❌ Arquivos críticos ausentes: {missing_files}")
            return False

        return True

    def _estimate_backup_size(self, source_path: Path) -> float:
        """Estima tamanho do backup em MB."""
        total_size = 0
        file_count = 0

        for item in source_path.rglob("*"):
            if item.is_file() and not self._should_exclude(item):
                total_size += item.stat().st_size
                file_count += 1

        size_mb = total_size / (1024 * 1024)
        logger.info(f"📊 Estimativa: {file_count} arquivos, {size_mb:.2f}MB")
        return size_mb

    def _should_exclude(self, file_path: Path) -> bool:
        """Verifica se arquivo deve ser excluído do backup."""
        file_str = str(file_path)
        for pattern in self.exclusion_patterns:
            if self._match_pattern(file_str, pattern):
                return True
        return False

    def _match_pattern(self, file_str: str, pattern: str) -> bool:
        """Verifica se arquivo corresponde ao padrão de exclusão."""
        import fnmatch
        return fnmatch.fnmatch(file_str, pattern)

    def _copy_with_exclusions(self, source: Path, dest: Path) -> int:
        """Copia arquivos aplicando padrões de exclusão."""
        copied_count = 0

        for item in source.rglob("*"):
            if item.is_file() and not self._should_exclude(item):
                relative_path = item.relative_to(source)
                dest_path = dest / relative_path
                dest_path.parent.mkdir(parents=True, exist_ok=True)

                try:
                    shutil.copy2(item, dest_path)
                    copied_count += 1
                except Exception as e:
                    logger.warning(f"⚠️ Erro ao copiar {item}: {e}")

        return copied_count

    def _create_backup_manual(self, source: Path, backup_name: str = None) -> bool:
        """Método manual de backup como fallback."""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_name = backup_name or f"backup_{timestamp}"
        backup_path = self.backups_dir / backup_name

        # Estimar tamanho do backup
        estimated_size_mb = self._estimate_backup_size(source)
        if estimated_size_mb > self.config["max_backup_size_mb"]:
            logger.error(f"❌ Backup muito grande: {estimated_size_mb}MB > {self.config['max_backup_size_mb']}MB")
            return False

        # Criar backup
        try:
            self.backups_dir.mkdir(exist_ok=True)
            backup_path.mkdir(exist_ok=True)

            # Copiar arquivos com exclusões
            copied_files = self._copy_with_exclusions(source, backup_path)

            # Criar metadados do backup
            metadata = {
                "timestamp": timestamp,
                "source": str(source),
                "files_count": copied_files,
                "size_mb": round(self._get_directory_size(backup_path) / (1024 * 1024), 2),
                "exclusion_patterns": self.exclusion_patterns
            }

            metadata_file = backup_path / "backup_metadata.json"
            if HELPERS_AVAILABLE:
                safe_save_json(metadata, metadata_file)
            else:
                import json
                with open(metadata_file, 'w') as f:
                    json.dump(metadata, f, indent=2)

            logger.info(f"✅ Backup manual criado: {backup_path} ({metadata['files_count']} arquivos, {metadata['size_mb']}MB)")
            return True

        except Exception as e:
            logger.error(f"❌ Erro ao criar backup manual: {e}")
            return False

    def _get_directory_size(self, path: Path) -> int:
        """Calcula tamanho total de um diretório."""
        if HELPERS_AVAILABLE:
            size, _ = get_directory_size(path)
            return size
        else:
            # Fallback manual
            total_size = 0
            for item in path.rglob("*"):
                if item.is_file():
                    total_size += item.stat().st_size
            return total_size

    def _cleanup_logs(self, dry_run: bool = False) -> int:
        """Limpa logs antigos."""
        if not self.logs_dir.exists():
            return 0

        cutoff_date = datetime.now() - timedelta(days=self.config["log_retention_days"])
        cleaned_count = 0

        for log_file in self.logs_dir.glob("*.log"):
            if datetime.fromtimestamp(log_file.stat().st_mtime) < cutoff_date:
                if not dry_run:
                    log_file.unlink()
                cleaned_count += 1
                logger.info(f"🗑️ Log removido: {log_file.name}")

        return cleaned_count

    def _cleanup_cache(self, target_path: Path, dry_run: bool = False) -> int:
        """Limpa arquivos de cache."""
        cache_patterns = ["__pycache__", ".cache", "node_modules/.cache", ".next/cache"]
        cleaned_count = 0

        for pattern in cache_patterns:
            for cache_dir in target_path.rglob(pattern):
                if cache_dir.is_dir():
                    if not dry_run:
                        shutil.rmtree(cache_dir)
                    cleaned_count += 1
                    logger.info(f"🗑️ Cache removido: {cache_dir}")

        return cleaned_count

    def _cleanup_temp_files(self, target_path: Path, dry_run: bool = False) -> int:
        """Limpa arquivos temporários."""
        temp_patterns = ["*.tmp", "*.temp", "*.bak", "*.old"]
        cleaned_count = 0

        for pattern in temp_patterns:
            for temp_file in target_path.rglob(pattern):
                if temp_file.is_file():
                    if not dry_run:
                        temp_file.unlink()
                    cleaned_count += 1
                    logger.info(f"🗑️ Arquivo temporário removido: {temp_file.name}")

        return cleaned_count

    def _cleanup_old_backups(self, backup_names: List[str]) -> int:
        """Remove backups específicos."""
        cleaned_count = 0
        for backup_name in backup_names:
            backup_path = self.backups_dir / backup_name
            if backup_path.exists():
                shutil.rmtree(backup_path)
                cleaned_count += 1
                logger.info(f"🗑️ Backup antigo removido: {backup_name}")
        return cleaned_count

    def _cleanup_old_backups_by_age(self, dry_run: bool = False) -> int:
        """Remove backups por idade."""
        if not self.backups_dir.exists():
            return 0

        cutoff_date = datetime.now() - timedelta(days=self.config["backup_retention_days"])
        cleaned_count = 0

        for backup in self.backups_dir.iterdir():
            if backup.is_dir():
                backup_time = datetime.fromtimestamp(backup.stat().st_mtime)
                if backup_time < cutoff_date:
                    if not dry_run:
                        shutil.rmtree(backup)
                    cleaned_count += 1
                    logger.info(f"🗑️ Backup antigo removido: {backup.name}")

        return cleaned_count

    def _monitor_backups_manual(self, auto_cleanup: bool = False) -> Dict[str, any]:
        """Método manual de monitoramento como fallback."""
        if not self.backups_dir.exists():
            logger.warning("⚠️ Diretório de backups não existe")
            return {"status": "no_backup_dir", "total_size_gb": 0, "backup_count": 0}

        # Analisar backups existentes
        backups = list(self.backups_dir.iterdir())
        total_size = sum(self._get_directory_size(backup) for backup in backups if backup.is_dir())
        total_size_gb = total_size / (1024 * 1024 * 1024)

        # Detectar problemas
        issues = []
        if total_size_gb > self.config["max_total_backups_gb"]:
            issues.append(f"Total de backups excede limite: {total_size_gb:.2f}GB > {self.config['max_total_backups_gb']}GB")

        # Detectar backups antigos
        cutoff_date = datetime.now() - timedelta(days=self.config["backup_retention_days"])
        old_backups = []

        for backup in backups:
            if backup.is_dir():
                backup_time = datetime.fromtimestamp(backup.stat().st_mtime)
                if backup_time < cutoff_date:
                    old_backups.append(backup.name)

        if old_backups:
            issues.append(f"{len(old_backups)} backups antigos encontrados")

        # Auto-limpeza se solicitada
        if auto_cleanup and (issues or old_backups):
            logger.info("🧹 Executando limpeza automática manual...")
            self._cleanup_old_backups(old_backups)

        status = {
            "status": "healthy" if not issues else "issues_detected",
            "total_size_gb": round(total_size_gb, 2),
            "backup_count": len(backups),
            "issues": issues,
            "old_backups": old_backups,
            "using_backup_manager": False
        }

        logger.info(f"📊 Status (manual): {status['backup_count']} backups, {status['total_size_gb']}GB")
        return status

def main():
    """Função principal do Maintenance Manager."""
    # Usar helper de argument parser se disponível
    if HELPERS_AVAILABLE:
        # Criar parser customizado para maintenance
        from helpers.core.argument_parser import VibeCodeArgumentParser
        parser = VibeCodeArgumentParser("maintenance", 'VIBECODE Maintenance Manager V4.0')

        # Adicionar argumentos específicos de manutenção
        parser.add_custom_argument('--backup', action='store_true', help='Criar backup do sistema')
        parser.add_custom_argument('--cleanup', action='store_true', help='Executar limpeza do sistema')
        parser.add_custom_argument('--consolidate', action='store_true', help='Consolidar backups antigos')
        parser.add_custom_argument('--monitor', action='store_true', help='Monitorar sistema de backups')
        parser.add_custom_argument('--validate', action='store_true', help='Validar integridade dos backups')
        parser.add_custom_argument('--scan', action='store_true', help='Escanear oportunidades de consolidação')
        parser.add_custom_argument('--target', type=str, help='Caminho específico para operações')
        parser.add_custom_argument('--backup-name', type=str, help='Nome personalizado para backup')
        parser.add_custom_argument('--auto-cleanup', action='store_true', help='Limpeza automática durante monitoramento')
        parser.add_custom_argument('--project-root', type=str, help='Caminho raiz do projeto')

        args = parser.parse_args()

        # Log de início de execução
        log_execution_start(logger, "maintenance", vars(args))
    else:
        # Fallback para parser manual
        import argparse
        parser = argparse.ArgumentParser(description='VIBECODE Maintenance Manager V4.0')
        parser.add_argument('--backup', action='store_true', help='Criar backup do sistema')
        parser.add_argument('--cleanup', action='store_true', help='Executar limpeza do sistema')
        parser.add_argument('--consolidate', action='store_true', help='Consolidar backups antigos')
        parser.add_argument('--monitor', action='store_true', help='Monitorar sistema de backups')
        parser.add_argument('--validate', action='store_true', help='Validar integridade dos backups')
        parser.add_argument('--scan', action='store_true', help='Escanear oportunidades de consolidação')
        parser.add_argument('--dry-run', action='store_true', help='Executar sem fazer alterações')
        parser.add_argument('--target', type=str, help='Caminho específico para operações')
        parser.add_argument('--backup-name', type=str, help='Nome personalizado para backup')
        parser.add_argument('--auto-cleanup', action='store_true', help='Limpeza automática durante monitoramento')
        parser.add_argument('--project-root', type=str, help='Caminho raiz do projeto')
        args = parser.parse_args()

    start_time = datetime.now()

    # Inicializar manager
    manager = MaintenanceManager(args.project_root)

    success = True

    # Executar ações solicitadas
    if args.backup:
        success &= manager.create_backup(args.target, args.backup_name, args.dry_run)

    if args.cleanup:
        results = manager.cleanup_system(args.target, args.dry_run)
        success &= sum(results.values()) > 0

    if args.consolidate:
        success &= manager.consolidate_backups(args.dry_run)

    if args.monitor:
        status = manager.monitor_backups(args.auto_cleanup)
        print(f"📊 Status dos Backups: {status['status']}")
        print(f"📦 {status['backup_count']} backups, {status['total_size_gb']}GB")

    if args.validate:
        results = manager.validate_backups()
        valid_count = sum(results.values())
        total_count = len(results)
        print(f"✅ {valid_count}/{total_count} backups válidos")

    if args.scan:
        opportunities = manager.scan_consolidation_opportunities()
        total_opportunities = sum(len(v) for v in opportunities.values())
        print(f"🔍 {total_opportunities} oportunidades de consolidação encontradas")

    # Se nenhuma ação especificada, mostrar help
    if not any([args.backup, args.cleanup, args.consolidate, args.monitor,
               args.validate, args.scan]):
        parser.print_help()
        return 0

    # Log de fim de execução
    if HELPERS_AVAILABLE:
        duration = (datetime.now() - start_time).total_seconds()
        log_execution_end(logger, "maintenance", success, duration)

    return 0 if success else 1

if __name__ == "__main__":
    sys.exit(main())
