#!/usr/bin/env python3
"""
🧹 SYSTEM CLEANUP - VIBECODE SYSTEM V4.0

Limpeza e manutenção do sistema de forma segura.
Consolidação de: safe-cleanup-with-dryrun.ps1, consolidate-backups.ps1,
cache_cleanup.py, project-core-cleanup-phase2.ps1

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import os
import sys
import json
import argparse
import shutil
import time
from pathlib import Path
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Tuple, Set
import logging
import hashlib

# Configuração de logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class SystemCleanup:
    """Sistema principal de limpeza e manutenção."""

    def __init__(self, project_root: str = None):
        self.project_root = Path(project_root) if project_root else Path.cwd()
        self.project_core = self.project_root / "@project-core"
        self.cleanup_log = self.project_core / "logs" / "cleanup.log"
        self.staging_area = self.project_root / "_cleanup_staging"

        # Criar diretórios necessários
        self.cleanup_log.parent.mkdir(parents=True, exist_ok=True)

        # Arquivos/diretórios protegidos (nunca deletar)
        self.protected_paths = {
            ".git",
            ".gitignore",
            ".cursorrules",
            "README.md",
            "LICENSE",
            "@project-core/memory/master_rule.md",
            "@project-core/memory/self_correction_log.md",
            "@project-core/memory/global-standards.md",
            "@project-core/automation/architecture_manager.py",
            "@project-core/automation/learning_optimizer.py",
            "@project-core/automation/sync_manager.py",
            "@project-core/automation/system_cleanup.py",
            "@project-core/automation/validation_suite.py",
            "@project-core/automation/auto_backup.py",
            "@project-core/automation/dependency_check.py"
        }

    def safe_cleanup_with_dryrun(self, file_patterns: List[str], dry_run: bool = True,
                                test_batch_size: int = 5) -> Dict[str, Any]:
        """
        Limpeza segura com dry-run e testes em lote.
        Equivalente a: safe-cleanup-with-dryrun.ps1
        """
        logger.info("🧹 Iniciando limpeza segura com dry-run...")

        results = {
            "dry_run": dry_run,
            "patterns": file_patterns,
            "files_found": [],
            "files_deleted": [],
            "files_protected": [],
            "errors": [],
            "total_size_freed": 0
        }

        try:
            # Encontrar arquivos correspondentes aos padrões
            matching_files = self._find_matching_files(file_patterns)
            results["files_found"] = [str(f) for f in matching_files]

            logger.info(f"📋 Encontrados {len(matching_files)} arquivos para limpeza")

            if not matching_files:
                logger.info("ℹ️ Nenhum arquivo encontrado para limpeza")
                return results

            # Verificar arquivos protegidos
            protected_files = []
            safe_files = []

            for file_path in matching_files:
                if self._is_protected(file_path):
                    protected_files.append(file_path)
                    results["files_protected"].append(str(file_path))
                else:
                    safe_files.append(file_path)

            if protected_files:
                logger.warning(f"🛡️ {len(protected_files)} arquivos protegidos não serão removidos:")
                for pf in protected_files[:5]:  # Mostrar apenas os primeiros 5
                    logger.warning(f"    - {pf}")
                if len(protected_files) > 5:
                    logger.warning(f"    ... e mais {len(protected_files) - 5} arquivos")

            if not safe_files:
                logger.info("ℹ️ Nenhum arquivo seguro para remoção")
                return results

            # Executar limpeza (dry-run ou real)
            if dry_run:
                logger.info(f"🔍 DRY-RUN: {len(safe_files)} arquivos seriam removidos:")
                total_size = 0
                for file_path in safe_files[:10]:  # Mostrar apenas os primeiros 10
                    size = file_path.stat().st_size if file_path.exists() else 0
                    total_size += size
                    logger.info(f"    - {file_path} ({self._format_size(size)})")

                if len(safe_files) > 10:
                    logger.info(f"    ... e mais {len(safe_files) - 10} arquivos")

                # Calcular tamanho total
                for file_path in safe_files[10:]:
                    if file_path.exists():
                        total_size += file_path.stat().st_size

                logger.info(f"💾 Espaço total que seria liberado: {self._format_size(total_size)}")
                results["total_size_freed"] = total_size
            else:
                # Limpeza real em lotes
                logger.info(f"🗑️ Removendo {len(safe_files)} arquivos em lotes de {test_batch_size}...")

                for i in range(0, len(safe_files), test_batch_size):
                    batch = safe_files[i:i + test_batch_size]
                    logger.info(f"  📦 Processando lote {i//test_batch_size + 1}: {len(batch)} arquivos")

                    for file_path in batch:
                        try:
                            if file_path.exists():
                                size = file_path.stat().st_size
                                if file_path.is_file():
                                    file_path.unlink()
                                elif file_path.is_dir():
                                    shutil.rmtree(file_path)

                                results["files_deleted"].append(str(file_path))
                                results["total_size_freed"] += size
                                logger.debug(f"    ✅ Removido: {file_path}")

                        except Exception as e:
                            error_msg = f"Erro ao remover {file_path}: {e}"
                            results["errors"].append(error_msg)
                            logger.error(f"    ❌ {error_msg}")

                    # Pausa entre lotes para verificação
                    if i + test_batch_size < len(safe_files):
                        time.sleep(1)

                logger.info(f"✅ Limpeza concluída: {len(results['files_deleted'])} arquivos removidos")
                logger.info(f"💾 Espaço liberado: {self._format_size(results['total_size_freed'])}")

        except Exception as e:
            error_msg = f"Erro na limpeza segura: {e}"
            results["errors"].append(error_msg)
            logger.error(f"❌ {error_msg}")

        # Registrar resultado
        self._log_cleanup_event("safe_cleanup", results)
        return results

    def consolidate_backups(self, max_age_days: int = 30, keep_count: int = 5) -> Dict[str, Any]:
        """
        Consolida e limpa backups antigos.
        Equivalente a: consolidate-backups.ps1
        """
        logger.info("📦 Consolidando backups...")

        results = {
            "backups_found": 0,
            "backups_removed": 0,
            "backups_kept": 0,
            "space_freed": 0,
            "errors": []
        }

        try:
            # Encontrar diretórios de backup
            backup_patterns = [
                "*backup*",
                "*_backup_*",
                "backup_*",
                "*bak",
                "*.backup",
                "@project-core/backups/*"
            ]

            backup_paths = []
            for pattern in backup_patterns:
                backup_paths.extend(self.project_root.glob(pattern))
                backup_paths.extend(self.project_root.rglob(pattern))

            # Remover duplicatas e ordenar por data de modificação
            unique_backups = list(set(backup_paths))
            backup_info = []

            for backup_path in unique_backups:
                if backup_path.exists():
                    stat = backup_path.stat()
                    backup_info.append({
                        "path": backup_path,
                        "modified": datetime.fromtimestamp(stat.st_mtime),
                        "size": self._get_path_size(backup_path)
                    })

            # Ordenar por data (mais recente primeiro)
            backup_info.sort(key=lambda x: x["modified"], reverse=True)
            results["backups_found"] = len(backup_info)

            if not backup_info:
                logger.info("ℹ️ Nenhum backup encontrado")
                return results

            logger.info(f"📋 Encontrados {len(backup_info)} backups")

            # Determinar quais backups manter
            cutoff_date = datetime.now() - timedelta(days=max_age_days)
            backups_to_keep = []
            backups_to_remove = []

            for i, backup in enumerate(backup_info):
                # Manter os mais recentes (até keep_count) independente da idade
                if i < keep_count:
                    backups_to_keep.append(backup)
                # Remover backups muito antigos
                elif backup["modified"] < cutoff_date:
                    backups_to_remove.append(backup)
                else:
                    backups_to_keep.append(backup)

            logger.info(f"✅ Manter: {len(backups_to_keep)} backups")
            logger.info(f"🗑️ Remover: {len(backups_to_remove)} backups antigos")

            # Remover backups antigos
            for backup in backups_to_remove:
                try:
                    backup_path = backup["path"]
                    size = backup["size"]

                    if backup_path.is_file():
                        backup_path.unlink()
                    elif backup_path.is_dir():
                        shutil.rmtree(backup_path)

                    results["backups_removed"] += 1
                    results["space_freed"] += size
                    logger.info(f"    ✅ Removido: {backup_path.name} ({self._format_size(size)})")

                except Exception as e:
                    error_msg = f"Erro ao remover backup {backup_path}: {e}"
                    results["errors"].append(error_msg)
                    logger.error(f"    ❌ {error_msg}")

            results["backups_kept"] = len(backups_to_keep)

            logger.info(f"📊 Consolidação concluída:")
            logger.info(f"    ✅ Backups mantidos: {results['backups_kept']}")
            logger.info(f"    🗑️ Backups removidos: {results['backups_removed']}")
            logger.info(f"    💾 Espaço liberado: {self._format_size(results['space_freed'])}")

        except Exception as e:
            error_msg = f"Erro na consolidação de backups: {e}"
            results["errors"].append(error_msg)
            logger.error(f"❌ {error_msg}")

        self._log_cleanup_event("consolidate_backups", results)
        return results

    def cleanup_cache(self, aggressive: bool = False) -> Dict[str, Any]:
        """
        Limpeza de cache do sistema.
        Integração do cache_cleanup.py existente
        """
        logger.info("🧽 Limpando cache do sistema...")

        results = {
            "cache_dirs_cleaned": 0,
            "cache_files_removed": 0,
            "space_freed": 0,
            "errors": []
        }

        try:
            # Diretórios de cache comuns
            cache_patterns = [
                "**/__pycache__",
                "**/.pytest_cache",
                "**/node_modules/.cache",
                "**/.cache",
                "**/cache",
                "**/*.pyc",
                "**/*.pyo",
                "**/dist",
                "**/build"
            ]

            if aggressive:
                cache_patterns.extend([
                    "**/node_modules",
                    "**/.venv",
                    "**/venv"
                ])

            for pattern in cache_patterns:
                cache_paths = list(self.project_root.rglob(pattern))

                for cache_path in cache_paths:
                    if not self._is_protected(cache_path) and cache_path.exists():
                        try:
                            size = self._get_path_size(cache_path)

                            if cache_path.is_file():
                                cache_path.unlink()
                                results["cache_files_removed"] += 1
                            elif cache_path.is_dir():
                                shutil.rmtree(cache_path)
                                results["cache_dirs_cleaned"] += 1

                            results["space_freed"] += size
                            logger.debug(f"    ✅ Removido cache: {cache_path}")

                        except Exception as e:
                            error_msg = f"Erro ao limpar cache {cache_path}: {e}"
                            results["errors"].append(error_msg)
                            logger.warning(f"    ⚠️ {error_msg}")

            logger.info(f"✅ Limpeza de cache concluída:")
            logger.info(f"    📁 Diretórios limpos: {results['cache_dirs_cleaned']}")
            logger.info(f"    📄 Arquivos removidos: {results['cache_files_removed']}")
            logger.info(f"    💾 Espaço liberado: {self._format_size(results['space_freed'])}")

        except Exception as e:
            error_msg = f"Erro na limpeza de cache: {e}"
            results["errors"].append(error_msg)
            logger.error(f"❌ {error_msg}")

        self._log_cleanup_event("cleanup_cache", results)
        return results

    def cleanup_project_core(self, phase: int = 2, dry_run: bool = True) -> Dict[str, Any]:
        """
        Limpeza específica do @project-core.
        Equivalente a: project-core-cleanup-phase2.ps1
        """
        logger.info(f"🏗️ Limpeza @project-core (Fase {phase})...")

        results = {
            "phase": phase,
            "dry_run": dry_run,
            "directories_cleaned": 0,
            "files_removed": 0,
            "space_freed": 0,
            "errors": []
        }

        try:
            cleanup_targets = []

            if phase == 1:
                # Fase 1: Limpeza básica
                cleanup_targets = [
                    "@project-core/logs/old_*",
                    "@project-core/cache/*",
                    "@project-core/temp/*"
                ]
            elif phase == 2:
                # Fase 2: Limpeza intermediária
                cleanup_targets = [
                    "@project-core/backups/consolidation_*",
                    "@project-core/memory/archives/*",
                    "@project-core/reports/old_*",
                    "@project-core/automation/*backup*"
                ]
            elif phase == 3:
                # Fase 3: Limpeza avançada (cuidado!)
                cleanup_targets = [
                    "@project-core/memory/deprecated/*",
                    "@project-core/tools/unused/*",
                    "@project-core/configs/old_*"
                ]

            for target_pattern in cleanup_targets:
                target_paths = list(self.project_root.glob(target_pattern))

                for target_path in target_paths:
                    if not self._is_protected(target_path) and target_path.exists():
                        try:
                            size = self._get_path_size(target_path)

                            if dry_run:
                                logger.info(f"    🔍 DRY-RUN: removeria {target_path} ({self._format_size(size)})")
                                results["space_freed"] += size
                                if target_path.is_dir():
                                    results["directories_cleaned"] += 1
                                else:
                                    results["files_removed"] += 1
                            else:
                                if target_path.is_file():
                                    target_path.unlink()
                                    results["files_removed"] += 1
                                elif target_path.is_dir():
                                    shutil.rmtree(target_path)
                                    results["directories_cleaned"] += 1

                                results["space_freed"] += size
                                logger.info(f"    ✅ Removido: {target_path}")

                        except Exception as e:
                            error_msg = f"Erro ao processar {target_path}: {e}"
                            results["errors"].append(error_msg)
                            logger.error(f"    ❌ {error_msg}")

            action = "seria liberado" if dry_run else "liberado"
            logger.info(f"✅ Limpeza @project-core (Fase {phase}) concluída:")
            logger.info(f"    📁 Diretórios: {results['directories_cleaned']}")
            logger.info(f"    📄 Arquivos: {results['files_removed']}")
            logger.info(f"    💾 Espaço {action}: {self._format_size(results['space_freed'])}")

        except Exception as e:
            error_msg = f"Erro na limpeza @project-core: {e}"
            results["errors"].append(error_msg)
            logger.error(f"❌ {error_msg}")

        self._log_cleanup_event("cleanup_project_core", results)
        return results

    def _find_matching_files(self, patterns: List[str]) -> List[Path]:
        """Encontra arquivos que correspondem aos padrões."""
        matching_files = []

        for pattern in patterns:
            # Busca global no projeto
            matches = list(self.project_root.rglob(pattern))
            matching_files.extend(matches)

        # Remover duplicatas mantendo ordem
        seen = set()
        unique_files = []
        for file_path in matching_files:
            if file_path not in seen:
                seen.add(file_path)
                unique_files.append(file_path)

        return unique_files

    def _is_protected(self, path: Path) -> bool:
        """Verifica se um caminho está protegido."""
        # Converter para caminho relativo
        try:
            rel_path = path.relative_to(self.project_root)
            rel_path_str = str(rel_path).replace("\\", "/")

            # Verificar proteções específicas
            for protected in self.protected_paths:
                if rel_path_str == protected or rel_path_str.startswith(protected + "/"):
                    return True

            # Verificar extensões críticas
            if path.suffix in ['.cursorrules', '.gitignore', '.md', '.py'] and path.name in [
                'README.md', 'LICENSE', 'master_rule.md', 'self_correction_log.md',
                'global-standards.md', 'architecture_manager.py', 'learning_optimizer.py',
                'sync_manager.py', 'system_cleanup.py', 'validation_suite.py'
            ]:
                return True

            return False

        except ValueError:
            # Caminho fora do projeto
            return True

    def _get_path_size(self, path: Path) -> int:
        """Calcula o tamanho total de um caminho."""
        if path.is_file():
            return path.stat().st_size
        elif path.is_dir():
            total_size = 0
            try:
                for item in path.rglob("*"):
                    if item.is_file():
                        total_size += item.stat().st_size
            except PermissionError:
                pass
            return total_size
        return 0

    def _format_size(self, size_bytes: int) -> str:
        """Formata tamanho em bytes para formato legível."""
        for unit in ['B', 'KB', 'MB', 'GB']:
            if size_bytes < 1024:
                return f"{size_bytes:.1f} {unit}"
            size_bytes /= 1024
        return f"{size_bytes:.1f} TB"

    def _log_cleanup_event(self, event_type: str, results: Dict):
        """Registra evento de limpeza."""
        log_entry = {
            "timestamp": datetime.now().isoformat(),
            "event_type": event_type,
            "results": results
        }

        try:
            with open(self.cleanup_log, 'a') as f:
                f.write(json.dumps(log_entry) + '\n')
        except Exception:
            pass  # Log não crítico

def main():
    """Função principal do System Cleanup."""
    parser = argparse.ArgumentParser(description='VIBECODE System Cleanup V4.0')
    parser.add_argument('--safe-cleanup', action='store_true',
                       help='Limpeza segura com dry-run')
    parser.add_argument('--consolidate-backups', action='store_true',
                       help='Consolidar e limpar backups antigos')
    parser.add_argument('--cleanup-cache', action='store_true',
                       help='Limpar cache do sistema')
    parser.add_argument('--cleanup-project-core', action='store_true',
                       help='Limpeza específica do @project-core')
    parser.add_argument('--patterns', nargs='+',
                       help='Padrões de arquivos para limpeza',
                       default=['*backup*', '*temp*', '*.tmp'])
    parser.add_argument('--max-age-days', type=int, default=30,
                       help='Idade máxima para backups (dias)')
    parser.add_argument('--keep-count', type=int, default=5,
                       help='Número de backups recentes para manter')
    parser.add_argument('--batch-size', type=int, default=5,
                       help='Tamanho do lote para limpeza')
    parser.add_argument('--phase', type=int, default=2, choices=[1, 2, 3],
                       help='Fase de limpeza do project-core')
    parser.add_argument('--dry-run', action='store_true',
                       help='Executar sem fazer alterações')
    parser.add_argument('--aggressive', action='store_true',
                       help='Limpeza agressiva (inclui node_modules, venv)')
    parser.add_argument('--project-root', type=str,
                       help='Caminho raiz do projeto')

    args = parser.parse_args()

    # Inicializar cleanup
    cleanup = SystemCleanup(args.project_root)

    success = True

    # Executar ações solicitadas
    if args.safe_cleanup:
        results = cleanup.safe_cleanup_with_dryrun(args.patterns, args.dry_run, args.batch_size)
        print(f"🧹 Arquivos encontrados: {len(results['files_found'])}")
        print(f"🗑️ Arquivos {'seriam removidos' if args.dry_run else 'removidos'}: {len(results['files_deleted'])}")
        success &= len(results['errors']) == 0

    if args.consolidate_backups:
        results = cleanup.consolidate_backups(args.max_age_days, args.keep_count)
        print(f"📦 Backups consolidados: {results['backups_removed']} removidos, {results['backups_kept']} mantidos")
        success &= len(results['errors']) == 0

    if args.cleanup_cache:
        results = cleanup.cleanup_cache(args.aggressive)
        print(f"🧽 Cache limpo: {results['cache_dirs_cleaned']} diretórios, {results['cache_files_removed']} arquivos")
        success &= len(results['errors']) == 0

    if args.cleanup_project_core:
        results = cleanup.cleanup_project_core(args.phase, args.dry_run)
        print(f"🏗️ Project-core (Fase {args.phase}): {results['directories_cleaned']} dirs, {results['files_removed']} arquivos")
        success &= len(results['errors']) == 0

    # Se nenhuma ação especificada, mostrar help
    if not any([args.safe_cleanup, args.consolidate_backups, args.cleanup_cache, args.cleanup_project_core]):
        parser.print_help()
        return 0

    return 0 if success else 1

if __name__ == "__main__":
    sys.exit(main())
