#!/usr/bin/env python3
"""
📦 ARCHIVE MANAGER - VIBECODE SYSTEM V4.0

Sistema inteligente de arquivamento e compactação para otimização de espaço.
Integrado com helpers VIBECODE para máxima eficiência.

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import sys
import shutil
import zipfile
from pathlib import Path
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Tuple

# Importar helpers VIBECODE V4.0
try:
    # Adicionar caminho dos helpers ao sys.path
    sys.path.insert(0, str(Path(__file__).parent.parent))
    from helpers.core.logger_utils import get_vibecode_logger, log_execution_start, log_execution_end, log_step
    from helpers.core.argument_parser import VibeCodeArgumentParser
    from helpers.system.path_utils import VibeCodePaths, get_directory_size, find_files_by_age
    from helpers.system.backup_utils import BackupManager
    from helpers.data.json_utils import safe_save_json, create_report_json
    HELPERS_AVAILABLE = True
except ImportError as e:
    # Fallback para compatibilidade
    import logging
    import argparse
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    logger = logging.getLogger(__name__)
    HELPERS_AVAILABLE = False
    print(f"⚠️ Helpers não disponíveis (usando fallback): {e}")

# Configurar logger
if HELPERS_AVAILABLE:
    logger = get_vibecode_logger("archive_manager")
else:
    logger = logging.getLogger(__name__)


class ArchiveManager:
    """Gerenciador inteligente de arquivamento VIBECODE V4.0."""

    def __init__(self, project_root: str = None):
        # Usar helper de paths se disponível
        if HELPERS_AVAILABLE:
            self.paths = VibeCodePaths(project_root)
            self.project_root = self.paths.project_root
            self.project_core = self.paths.project_core
            self.archive_dir = self.paths.project_core / "archives"
            self.logs_dir = self.paths.logs_path
            self.reports_dir = self.paths.reports_path
        else:
            # Fallback para compatibilidade
            self.project_root = Path(project_root) if project_root else Path.cwd()
            self.project_core = self.project_root / "@project-core"
            self.archive_dir = self.project_core / "archives"
            self.logs_dir = self.project_core / "logs"
            self.reports_dir = self.project_core / "reports"

        # Criar diretório de arquivos se não existir
        self.archive_dir.mkdir(exist_ok=True)

        # Configurações de arquivamento
        self.config = {
            "log_retention_days": 30,
            "report_retention_days": 90,
            "max_archive_size_mb": 50,
            "compression_level": 6,
            "auto_cleanup_enabled": True,
            "external_backup_path": "C:/Users/Admin/OneDrive/Documentos/VSCODE-BACKUP",
            "project_log_retention_days": 7  # Logs no projeto apenas 7 dias
        }

        # Configurar destino externo
        self.external_backup = Path(self.config["external_backup_path"])
        if HELPERS_AVAILABLE:
            # Criar estrutura externa se não existir
            try:
                self.external_backup.mkdir(parents=True, exist_ok=True)
                (self.external_backup / "logs").mkdir(exist_ok=True)
                (self.external_backup / "reports").mkdir(exist_ok=True)
                (self.external_backup / "backups").mkdir(exist_ok=True)
                (self.external_backup / "automation_backup").mkdir(exist_ok=True)
            except Exception as e:
                logger.warning(f"⚠️ Não foi possível criar estrutura externa: {e}")
                self.external_backup = None

    def archive_old_logs(self, days_old: int = None, dry_run: bool = False) -> Dict[str, any]:
        """
        Arquiva logs antigos em arquivo compactado.

        Args:
            days_old: Idade mínima dos logs (padrão: config)
            dry_run: Executar sem fazer alterações

        Returns:
            Resultado do arquivamento
        """
        log_step(logger, "📦 Arquivando logs antigos...")

        days_old = days_old or self.config["log_retention_days"]
        cutoff_date = datetime.now() - timedelta(days=days_old)

        if not self.logs_dir.exists():
            logger.warning("⚠️ Diretório de logs não existe")
            return {"status": "no_logs_dir", "archived_files": 0}

        # Encontrar logs antigos
        if HELPERS_AVAILABLE:
            old_logs = find_files_by_age(self.logs_dir, days_old, ["*.log", "*.txt"])
        else:
            old_logs = [f for f in self.logs_dir.rglob("*.log")
                       if datetime.fromtimestamp(f.stat().st_mtime) < cutoff_date]

        if not old_logs:
            logger.info("📦 Nenhum log antigo encontrado")
            return {"status": "no_old_logs", "archived_files": 0}

        if dry_run:
            logger.info(f"🔍 DRY RUN: {len(old_logs)} logs seriam arquivados")
            return {"status": "dry_run", "archived_files": len(old_logs)}

        # Criar arquivo compactado
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        archive_name = f"logs_archive_{timestamp}.zip"
        archive_path = self.archive_dir / archive_name

        try:
            archived_count = 0
            with zipfile.ZipFile(archive_path, 'w', zipfile.ZIP_DEFLATED,
                               compresslevel=self.config["compression_level"]) as zipf:

                for log_file in old_logs:
                    # Adicionar ao arquivo
                    arcname = log_file.relative_to(self.logs_dir)
                    zipf.write(log_file, arcname)
                    archived_count += 1

                    # Remover arquivo original
                    log_file.unlink()
                    logger.info(f"📦 Log arquivado: {log_file.name}")

            # Criar metadados do arquivo
            metadata = create_report_json(
                title="Log Archive Report",
                data={
                    "archive_path": str(archive_path),
                    "archived_files": archived_count,
                    "cutoff_date": cutoff_date.isoformat(),
                    "archive_size_mb": archive_path.stat().st_size / (1024 * 1024)
                }
            ) if HELPERS_AVAILABLE else {
                "archive_path": str(archive_path),
                "archived_files": archived_count,
                "cutoff_date": cutoff_date.isoformat()
            }

            metadata_file = self.archive_dir / f"{archive_name}.metadata.json"
            if HELPERS_AVAILABLE:
                safe_save_json(metadata, metadata_file)

            logger.info(f"✅ {archived_count} logs arquivados em {archive_name}")
            return {
                "status": "success",
                "archived_files": archived_count,
                "archive_path": str(archive_path),
                "archive_size_mb": round(archive_path.stat().st_size / (1024 * 1024), 2)
            }

        except Exception as e:
            logger.error(f"❌ Erro ao arquivar logs: {e}")
            return {"status": "error", "error": str(e), "archived_files": 0}

    def archive_old_reports(self, days_old: int = None, dry_run: bool = False) -> Dict[str, any]:
        """
        Arquiva relatórios antigos em arquivo compactado.

        Args:
            days_old: Idade mínima dos relatórios (padrão: config)
            dry_run: Executar sem fazer alterações

        Returns:
            Resultado do arquivamento
        """
        log_step(logger, "📊 Arquivando relatórios antigos...")

        days_old = days_old or self.config["report_retention_days"]
        cutoff_date = datetime.now() - timedelta(days=days_old)

        if not self.reports_dir.exists():
            logger.warning("⚠️ Diretório de relatórios não existe")
            return {"status": "no_reports_dir", "archived_files": 0}

        # Encontrar relatórios antigos
        if HELPERS_AVAILABLE:
            old_reports = find_files_by_age(self.reports_dir, days_old, ["*.json", "*.md", "*.txt"])
        else:
            old_reports = [f for f in self.reports_dir.rglob("*")
                          if f.is_file() and datetime.fromtimestamp(f.stat().st_mtime) < cutoff_date]

        if not old_reports:
            logger.info("📊 Nenhum relatório antigo encontrado")
            return {"status": "no_old_reports", "archived_files": 0}

        if dry_run:
            logger.info(f"🔍 DRY RUN: {len(old_reports)} relatórios seriam arquivados")
            return {"status": "dry_run", "archived_files": len(old_reports)}

        # Criar arquivo compactado
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        archive_name = f"reports_archive_{timestamp}.zip"
        archive_path = self.archive_dir / archive_name

        try:
            archived_count = 0
            with zipfile.ZipFile(archive_path, 'w', zipfile.ZIP_DEFLATED,
                               compresslevel=self.config["compression_level"]) as zipf:

                for report_file in old_reports:
                    # Adicionar ao arquivo
                    arcname = report_file.relative_to(self.reports_dir)
                    zipf.write(report_file, arcname)
                    archived_count += 1

                    # Remover arquivo original
                    report_file.unlink()
                    logger.info(f"📊 Relatório arquivado: {report_file.name}")

            logger.info(f"✅ {archived_count} relatórios arquivados em {archive_name}")
            return {
                "status": "success",
                "archived_files": archived_count,
                "archive_path": str(archive_path),
                "archive_size_mb": round(archive_path.stat().st_size / (1024 * 1024), 2)
            }

        except Exception as e:
            logger.error(f"❌ Erro ao arquivar relatórios: {e}")
            return {"status": "error", "error": str(e), "archived_files": 0}

    def cleanup_old_archives(self, days_old: int = 180, dry_run: bool = False) -> Dict[str, any]:
        """
        Remove arquivos antigos para economizar espaço.

        Args:
            days_old: Idade mínima dos arquivos (padrão: 180 dias)
            dry_run: Executar sem fazer alterações

        Returns:
            Resultado da limpeza
        """
        log_step(logger, "🧹 Limpando arquivos antigos...")

        cutoff_date = datetime.now() - timedelta(days=days_old)

        if not self.archive_dir.exists():
            logger.warning("⚠️ Diretório de arquivos não existe")
            return {"status": "no_archive_dir", "cleaned_files": 0}

        # Encontrar arquivos antigos
        old_archives = [f for f in self.archive_dir.rglob("*")
                       if f.is_file() and datetime.fromtimestamp(f.stat().st_mtime) < cutoff_date]

        if not old_archives:
            logger.info("🧹 Nenhum arquivo antigo encontrado")
            return {"status": "no_old_archives", "cleaned_files": 0}

        if dry_run:
            logger.info(f"🔍 DRY RUN: {len(old_archives)} arquivos seriam removidos")
            return {"status": "dry_run", "cleaned_files": len(old_archives)}

        # Remover arquivos antigos
        cleaned_count = 0
        total_size_freed = 0

        for archive_file in old_archives:
            try:
                file_size = archive_file.stat().st_size
                archive_file.unlink()
                cleaned_count += 1
                total_size_freed += file_size
                logger.info(f"🗑️ Arquivo removido: {archive_file.name}")
            except Exception as e:
                logger.warning(f"⚠️ Erro ao remover {archive_file.name}: {e}")

        logger.info(f"✅ {cleaned_count} arquivos removidos, {total_size_freed / (1024*1024):.2f}MB liberados")
        return {
            "status": "success",
            "cleaned_files": cleaned_count,
            "size_freed_mb": round(total_size_freed / (1024 * 1024), 2)
        }

    def get_archive_stats(self) -> Dict[str, any]:
        """
        Obtém estatísticas dos arquivos.

        Returns:
            Estatísticas dos arquivos
        """
        log_step(logger, "📊 Coletando estatísticas de arquivos...")

        if not self.archive_dir.exists():
            return {"total_archives": 0, "total_size_mb": 0}

        archives = list(self.archive_dir.rglob("*.zip"))
        total_size = sum(f.stat().st_size for f in archives)

        stats = {
            "total_archives": len(archives),
            "total_size_mb": round(total_size / (1024 * 1024), 2),
            "archive_dir": str(self.archive_dir),
            "oldest_archive": None,
            "newest_archive": None
        }

        if archives:
            oldest = min(archives, key=lambda x: x.stat().st_mtime)
            newest = max(archives, key=lambda x: x.stat().st_mtime)
            stats["oldest_archive"] = oldest.name
            stats["newest_archive"] = newest.name

        logger.info(f"📊 {stats['total_archives']} arquivos, {stats['total_size_mb']}MB total")
        return stats

    def validate_file_separation_policy(self) -> Dict[str, any]:
        """
        Valida a política de separação de arquivos.

        Returns:
            Resultado da validação
        """
        log_step(logger, "🔍 Validando política de separação de arquivos...")

        violations = []
        warnings = []

        # Verificar logs antigos no projeto
        if self.logs_dir.exists():
            cutoff_date = datetime.now() - timedelta(days=self.config["project_log_retention_days"])
            old_logs = [f for f in self.logs_dir.rglob("*.log")
                       if datetime.fromtimestamp(f.stat().st_mtime) < cutoff_date]

            if old_logs:
                violations.append(f"{len(old_logs)} logs antigos encontrados no projeto (>{self.config['project_log_retention_days']} dias)")

        # Verificar relatórios temporários
        if self.reports_dir.exists():
            temp_reports = list(self.reports_dir.glob("backup-*.json"))
            temp_reports.extend(self.reports_dir.glob("smart-backup-*.json"))
            temp_reports.extend(self.reports_dir.glob("test_report_*.json"))

            if len(temp_reports) > 1:  # Permitir apenas 1 relatório de teste recente
                violations.append(f"{len(temp_reports)} relatórios temporários encontrados no projeto")

        # Verificar tamanho total do projeto
        if HELPERS_AVAILABLE:
            total_size, _ = get_directory_size(self.project_root)
            size_mb = total_size / (1024 * 1024)

            if size_mb > 50:  # Limite de 50MB para GitHub
                warnings.append(f"Projeto muito grande: {size_mb:.1f}MB > 50MB")

        # Verificar se estrutura externa existe
        if self.external_backup and not self.external_backup.exists():
            warnings.append("Estrutura de backup externa não encontrada")

        status = "compliant" if not violations else "violations_found"
        if warnings and status == "compliant":
            status = "warnings_found"

        result = {
            "status": status,
            "violations": violations,
            "warnings": warnings,
            "project_size_mb": size_mb if HELPERS_AVAILABLE else 0,
            "external_backup_available": self.external_backup.exists() if self.external_backup else False
        }

        if violations:
            logger.warning(f"⚠️ {len(violations)} violações da política encontradas")
        elif warnings:
            logger.info(f"ℹ️ {len(warnings)} avisos encontrados")
        else:
            logger.info("✅ Política de separação de arquivos em compliance")

        return result

    def cleanup_project_for_github(self, dry_run: bool = False) -> Dict[str, any]:
        """
        Limpa projeto para otimizar para GitHub.

        Args:
            dry_run: Executar sem fazer alterações

        Returns:
            Resultado da limpeza
        """
        log_step(logger, "🧹 Limpando projeto para GitHub...")

        if dry_run:
            logger.info("🔍 DRY RUN: Simulando limpeza...")

        moved_files = []

        # Mover logs antigos para backup externo
        if self.logs_dir.exists() and self.external_backup:
            cutoff_date = datetime.now() - timedelta(days=self.config["project_log_retention_days"])
            old_logs = [f for f in self.logs_dir.rglob("*.log")
                       if datetime.fromtimestamp(f.stat().st_mtime) < cutoff_date]

            for log_file in old_logs:
                if not dry_run and self.external_backup:
                    dest = self.external_backup / "logs" / log_file.name
                    try:
                        shutil.move(str(log_file), str(dest))
                        moved_files.append(f"log: {log_file.name}")
                    except Exception as e:
                        logger.warning(f"⚠️ Erro ao mover {log_file.name}: {e}")
                else:
                    moved_files.append(f"log: {log_file.name} (dry-run)")

        # Mover relatórios temporários
        if self.reports_dir.exists() and self.external_backup:
            temp_reports = list(self.reports_dir.glob("backup-*.json"))
            temp_reports.extend(self.reports_dir.glob("smart-backup-*.json"))

            # Manter apenas o relatório de teste mais recente
            test_reports = list(self.reports_dir.glob("test_report_*.json"))
            if len(test_reports) > 1:
                test_reports.sort(key=lambda x: x.stat().st_mtime, reverse=True)
                temp_reports.extend(test_reports[1:])  # Mover todos exceto o mais recente

            for report in temp_reports:
                if not dry_run and self.external_backup:
                    dest = self.external_backup / "reports" / report.name
                    try:
                        shutil.move(str(report), str(dest))
                        moved_files.append(f"report: {report.name}")
                    except Exception as e:
                        logger.warning(f"⚠️ Erro ao mover {report.name}: {e}")
                else:
                    moved_files.append(f"report: {report.name} (dry-run)")

        result = {
            "status": "success" if not dry_run else "dry_run",
            "moved_files": len(moved_files),
            "files_list": moved_files,
            "external_backup_used": str(self.external_backup) if self.external_backup else None
        }

        if dry_run:
            logger.info(f"🔍 DRY RUN: {len(moved_files)} arquivos seriam movidos")
        else:
            logger.info(f"✅ {len(moved_files)} arquivos movidos para backup externo")

        return result


def main():
    """Função principal do Archive Manager."""
    # Usar helper de argument parser se disponível
    if HELPERS_AVAILABLE:
        parser = VibeCodeArgumentParser("archive_manager", 'VIBECODE Archive Manager V4.0')

        # Adicionar argumentos específicos de arquivamento
        parser.add_custom_argument('--archive-logs', action='store_true', help='Arquivar logs antigos')
        parser.add_custom_argument('--archive-reports', action='store_true', help='Arquivar relatórios antigos')
        parser.add_custom_argument('--cleanup-archives', action='store_true', help='Limpar arquivos antigos')
        parser.add_custom_argument('--stats', action='store_true', help='Mostrar estatísticas')
        parser.add_custom_argument('--validate-policy', action='store_true', help='Validar política de separação')
        parser.add_custom_argument('--cleanup-for-github', action='store_true', help='Limpar projeto para GitHub')
        parser.add_custom_argument('--days-old', type=int, help='Idade mínima em dias')
        parser.add_custom_argument('--project-root', type=str, help='Caminho raiz do projeto')

        args = parser.parse_args()

        # Log de início de execução
        log_execution_start(logger, "archive_manager", vars(args))
    else:
        # Fallback para parser manual
        import argparse
        parser = argparse.ArgumentParser(description='VIBECODE Archive Manager V4.0')
        parser.add_argument('--archive-logs', action='store_true', help='Arquivar logs antigos')
        parser.add_argument('--archive-reports', action='store_true', help='Arquivar relatórios antigos')
        parser.add_argument('--cleanup-archives', action='store_true', help='Limpar arquivos antigos')
        parser.add_argument('--stats', action='store_true', help='Mostrar estatísticas')
        parser.add_argument('--dry-run', action='store_true', help='Executar sem fazer alterações')
        parser.add_argument('--days-old', type=int, help='Idade mínima em dias')
        parser.add_argument('--project-root', type=str, help='Caminho raiz do projeto')
        args = parser.parse_args()

    start_time = datetime.now()

    # Inicializar manager
    manager = ArchiveManager(args.project_root)

    success = True

    # Executar ações solicitadas
    if args.archive_logs:
        result = manager.archive_old_logs(args.days_old, args.dry_run)
        print(f"📦 Logs: {result['status']} - {result['archived_files']} arquivos")
        success &= result['status'] in ['success', 'no_old_logs', 'dry_run']

    if args.archive_reports:
        result = manager.archive_old_reports(args.days_old, args.dry_run)
        print(f"📊 Relatórios: {result['status']} - {result['archived_files']} arquivos")
        success &= result['status'] in ['success', 'no_old_reports', 'dry_run']

    if args.cleanup_archives:
        result = manager.cleanup_old_archives(args.days_old or 180, args.dry_run)
        print(f"🧹 Limpeza: {result['status']} - {result['cleaned_files']} arquivos")
        success &= result['status'] in ['success', 'no_old_archives', 'dry_run']

    if args.stats:
        stats = manager.get_archive_stats()
        print(f"📊 Estatísticas: {stats['total_archives']} arquivos, {stats['total_size_mb']}MB")

    if args.validate_policy:
        result = manager.validate_file_separation_policy()
        print(f"📋 Status: {result['status']}")
        if result['violations']:
            print("❌ Violações:")
            for violation in result['violations']:
                print(f"  - {violation}")
        if result['warnings']:
            print("⚠️ Avisos:")
            for warning in result['warnings']:
                print(f"  - {warning}")

    if args.cleanup_for_github:
        result = manager.cleanup_project_for_github(dry_run=args.dry_run)
        print(f"🧹 Limpeza: {result['moved_files']} arquivos processados")
        if result['external_backup_used']:
            print(f"📁 Backup externo: {result['external_backup_used']}")

    # Se nenhuma ação especificada, mostrar help
    if not any([args.archive_logs, args.archive_reports, args.cleanup_archives, args.stats, args.validate_policy, args.cleanup_for_github]):
        parser.print_help()
        return 0

    # Log de fim de execução
    if HELPERS_AVAILABLE:
        duration = (datetime.now() - start_time).total_seconds()
        log_execution_end(logger, "archive_manager", success, duration)

    return 0 if success else 1


if __name__ == "__main__":
    import sys
    sys.exit(main())
