#!/usr/bin/env python3
"""
📊 MONITOR MANAGER - VIBECODE SYSTEM V4.0

Consolidação de todos os scripts de monitoramento:
- structure-integrity-monitor.ps1, simple-structure-monitor.ps1
- real-time-validation-monitor.ps1, weekly-integrity-scheduler.ps1
- performance-optimization-script.ps1, optimization-opportunity-scanner.ps1
- learning-metrics.ps1, sync-monitor.ps1
- validate-optimized-memory.ps1, validate-sync.ps1

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import os
import sys
import json
import time
import psutil
from pathlib import Path
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Tuple

# Importar helpers VIBECODE V4.0
try:
    # Adicionar caminho dos helpers ao sys.path
    sys.path.insert(0, str(Path(__file__).parent.parent))
    from helpers.core.logger_utils import get_vibecode_logger, log_execution_start, log_execution_end, log_step
    from helpers.core.argument_parser import create_monitor_parser
    from helpers.system.path_utils import VibeCodePaths, get_directory_size, find_files_by_age
    from helpers.system.process_utils import run_git_command, check_git_status
    HELPERS_AVAILABLE = True
except ImportError as e:
    # Fallback para compatibilidade
    import logging
    import argparse
    import subprocess
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    logger = logging.getLogger(__name__)
    HELPERS_AVAILABLE = False
    print(f"⚠️ Helpers não disponíveis (usando fallback): {e}")

# Configurar logger
if HELPERS_AVAILABLE:
    logger = get_vibecode_logger("monitor")
else:
    logger = logging.getLogger(__name__)

class MonitorManager:
    """Gerenciador consolidado de monitoramento VIBECODE V4.0."""

    def __init__(self, project_root: str = None):
        # Usar helper de paths se disponível
        if HELPERS_AVAILABLE:
            self.paths = VibeCodePaths(project_root)
            self.project_root = self.paths.project_root
            self.project_core = self.paths.project_core
            self.logs_dir = self.paths.logs_path
            self.reports_dir = self.paths.reports_path
            self.critical_directories = [str(p.relative_to(self.project_root)) for p in self.paths.get_critical_directories()]
            self.critical_files = [str(p.relative_to(self.project_root)) for p in self.paths.get_critical_files()]
        else:
            # Fallback para compatibilidade
            self.project_root = Path(project_root) if project_root else Path.cwd()
            self.project_core = self.project_root / "@project-core"
            self.logs_dir = self.project_core / "logs"
            self.reports_dir = self.project_core / "reports"

            # Criar diretórios se não existirem
            self.logs_dir.mkdir(exist_ok=True)
            self.reports_dir.mkdir(exist_ok=True)

            # Estruturas críticas para monitoramento
            self.critical_directories = [
                "@project-core/memory",
                "@project-core/rules",
                "@project-core/automation",
                "@project-core/configs"
            ]

            self.critical_files = [
                "@project-core/memory/master_rule.md",
                "@project-core/memory/self_correction_log.md",
                "@project-core/memory/global-standards.md"
            ]

        # Configurações de monitoramento
        self.config = {
            "structure_check_interval": 300,  # 5 minutos
            "performance_check_interval": 600,  # 10 minutos
            "sync_check_interval": 900,  # 15 minutos
            "memory_threshold_mb": 1000,
            "cpu_threshold_percent": 80,
            "disk_threshold_percent": 90
        }

    def monitor_structure(self, continuous: bool = False, interval: int = 300) -> Dict[str, any]:
        """
        Monitora integridade da estrutura do projeto.
        Equivalente a: structure-integrity-monitor.ps1, simple-structure-monitor.ps1
        """
        logger.info("🏗️ Iniciando monitoramento de estrutura...")

        def check_structure():
            violations = []
            timestamp = datetime.now()

            # Verificar diretórios críticos
            for directory in self.critical_directories:
                dir_path = self.project_root / directory
                if not dir_path.exists():
                    violations.append({
                        "type": "missing_directory",
                        "path": directory,
                        "severity": "critical",
                        "timestamp": timestamp.isoformat()
                    })
                elif not any(dir_path.iterdir()):
                    violations.append({
                        "type": "empty_directory",
                        "path": directory,
                        "severity": "warning",
                        "timestamp": timestamp.isoformat()
                    })

            # Verificar arquivos críticos
            for file_path in self.critical_files:
                full_path = self.project_root / file_path
                if not full_path.exists():
                    violations.append({
                        "type": "missing_file",
                        "path": file_path,
                        "severity": "critical",
                        "timestamp": timestamp.isoformat()
                    })
                elif full_path.stat().st_size == 0:
                    violations.append({
                        "type": "empty_file",
                        "path": file_path,
                        "severity": "warning",
                        "timestamp": timestamp.isoformat()
                    })

            # Verificar duplicatas aninhadas
            nested_duplicates = self._check_nested_duplicates()
            violations.extend(nested_duplicates)

            return violations

        if continuous:
            logger.info(f"🔄 Monitoramento contínuo ativado (intervalo: {interval}s)")
            while True:
                violations = check_structure()
                self._log_violations(violations, "structure")

                if violations:
                    critical_violations = [v for v in violations if v["severity"] == "critical"]
                    if critical_violations:
                        logger.error(f"🚨 {len(critical_violations)} violações críticas detectadas")
                        self._trigger_auto_correction(critical_violations)

                time.sleep(interval)
        else:
            violations = check_structure()
            self._log_violations(violations, "structure")

            return {
                "timestamp": datetime.now().isoformat(),
                "violations_count": len(violations),
                "critical_violations": len([v for v in violations if v["severity"] == "critical"]),
                "violations": violations,
                "status": "healthy" if not violations else "issues_detected"
            }

    def monitor_performance(self, continuous: bool = False, interval: int = 600) -> Dict[str, any]:
        """
        Monitora performance do sistema.
        Equivalente a: performance-optimization-script.ps1
        """
        logger.info("📈 Iniciando monitoramento de performance...")

        def check_performance():
            # Métricas do sistema
            cpu_percent = psutil.cpu_percent(interval=1)
            memory = psutil.virtual_memory()
            disk = psutil.disk_usage(str(self.project_root))

            # Métricas do projeto
            project_size = self._get_project_size()
            script_count = self._count_scripts()

            metrics = {
                "timestamp": datetime.now().isoformat(),
                "system": {
                    "cpu_percent": cpu_percent,
                    "memory_percent": memory.percent,
                    "memory_used_mb": memory.used / (1024 * 1024),
                    "disk_percent": (disk.used / disk.total) * 100,
                    "disk_free_gb": disk.free / (1024 * 1024 * 1024)
                },
                "project": {
                    "size_mb": project_size,
                    "script_count": script_count,
                    "automation_scripts": len(list((self.project_core / "automation").glob("*.py")))
                }
            }

            # Detectar problemas de performance
            issues = []
            if cpu_percent > self.config["cpu_threshold_percent"]:
                issues.append(f"CPU usage high: {cpu_percent}%")

            if memory.percent > self.config["memory_threshold_mb"]:
                issues.append(f"Memory usage high: {memory.percent}%")

            if (disk.used / disk.total) * 100 > self.config["disk_threshold_percent"]:
                issues.append(f"Disk usage high: {(disk.used / disk.total) * 100:.1f}%")

            metrics["issues"] = issues
            metrics["status"] = "healthy" if not issues else "performance_issues"

            return metrics

        if continuous:
            logger.info(f"📊 Monitoramento contínuo de performance ativado (intervalo: {interval}s)")
            while True:
                metrics = check_performance()
                self._log_performance_metrics(metrics)

                if metrics["issues"]:
                    logger.warning(f"⚠️ Problemas de performance: {', '.join(metrics['issues'])}")

                time.sleep(interval)
        else:
            return check_performance()

    def monitor_sync(self, continuous: bool = False, interval: int = 900) -> Dict[str, any]:
        """
        Monitora status de sincronização Git.
        Equivalente a: sync-monitor.ps1, validate-sync.ps1
        """
        logger.info("🔄 Iniciando monitoramento de sincronização...")

        def check_sync_status():
            projects = ["@neonpro", "@aegiswallet", "@harmoniza-facil-agendas", "."]
            sync_status = {}

            for project in projects:
                project_path = self.project_root / project if project != "." else self.project_root

                if not (project_path / ".git").exists():
                    sync_status[project] = {"status": "not_git_repo", "details": "Not a Git repository"}
                    continue

                try:
                    if HELPERS_AVAILABLE:
                        # Usar helper de Git
                        is_clean, changed_files = check_git_status(project_path)
                        has_changes = not is_clean

                        # Verificar commits não enviados
                        result = run_git_command(['log', '@{u}..HEAD', '--oneline'], cwd=project_path)
                        unpushed_commits = len(result.stdout.strip().split('\n')) if result.stdout.strip() else 0

                        # Verificar branch atual
                        result = run_git_command(['branch', '--show-current'], cwd=project_path)
                        current_branch = result.stdout.strip()
                    else:
                        # Fallback para subprocess
                        import subprocess
                        result = subprocess.run(['git', 'status', '--porcelain'],
                                              capture_output=True, text=True, cwd=project_path)
                        has_changes = bool(result.stdout.strip())

                        result = subprocess.run(['git', 'log', '@{u}..HEAD', '--oneline'],
                                              capture_output=True, text=True, cwd=project_path)
                        unpushed_commits = len(result.stdout.strip().split('\n')) if result.stdout.strip() else 0

                        result = subprocess.run(['git', 'branch', '--show-current'],
                                              capture_output=True, text=True, cwd=project_path)
                        current_branch = result.stdout.strip()

                    sync_status[project] = {
                        "status": "synced" if not has_changes and unpushed_commits == 0 else "needs_sync",
                        "has_changes": has_changes,
                        "unpushed_commits": unpushed_commits,
                        "current_branch": current_branch,
                        "details": f"Branch: {current_branch}, Changes: {has_changes}, Unpushed: {unpushed_commits}"
                    }

                except subprocess.CalledProcessError as e:
                    sync_status[project] = {"status": "error", "details": f"Git error: {e}"}

            return {
                "timestamp": datetime.now().isoformat(),
                "projects": sync_status,
                "needs_sync": [p for p, s in sync_status.items() if s["status"] == "needs_sync"],
                "total_projects": len(sync_status),
                "synced_projects": len([s for s in sync_status.values() if s["status"] == "synced"])
            }

        if continuous:
            logger.info(f"🔄 Monitoramento contínuo de sync ativado (intervalo: {interval}s)")
            while True:
                status = check_sync_status()
                self._log_sync_status(status)

                if status["needs_sync"]:
                    logger.warning(f"⚠️ Projetos precisam de sync: {', '.join(status['needs_sync'])}")

                time.sleep(interval)
        else:
            return check_sync_status()

    def scan_optimization_opportunities(self) -> Dict[str, List[str]]:
        """
        Escaneia oportunidades de otimização.
        Equivalente a: optimization-opportunity-scanner.ps1
        """
        logger.info("🔍 Escaneando oportunidades de otimização...")

        opportunities = {
            "large_files": [],
            "duplicate_dependencies": [],
            "unused_scripts": [],
            "performance_bottlenecks": [],
            "memory_optimizations": []
        }

        # Detectar arquivos grandes (>10MB)
        for file_path in self.project_root.rglob("*"):
            if file_path.is_file():
                size_mb = file_path.stat().st_size / (1024 * 1024)
                if size_mb > 10:
                    opportunities["large_files"].append(f"{file_path}: {size_mb:.1f}MB")

        # Detectar dependências duplicadas
        package_files = list(self.project_root.rglob("package.json")) + list(self.project_root.rglob("requirements.txt"))
        if len(package_files) > 1:
            opportunities["duplicate_dependencies"] = [str(f) for f in package_files]

        # Detectar scripts não utilizados (sem execução recente)
        cutoff_time = datetime.now() - timedelta(days=30)
        for script in self.project_core.rglob("*.ps1"):
            if datetime.fromtimestamp(script.stat().st_atime) < cutoff_time:
                opportunities["unused_scripts"].append(str(script))

        # Detectar gargalos de performance
        automation_dir = self.project_core / "automation"
        if automation_dir.exists():
            script_count = len(list(automation_dir.glob("*.ps1")))
            if script_count > 20:
                opportunities["performance_bottlenecks"].append(f"Too many PowerShell scripts: {script_count}")

        # Detectar oportunidades de otimização de memória
        memory_files = list((self.project_core / "memory").rglob("*.md"))
        total_memory_size = sum(f.stat().st_size for f in memory_files) / (1024 * 1024)
        if total_memory_size > 50:  # >50MB
            opportunities["memory_optimizations"].append(f"Large memory files: {total_memory_size:.1f}MB")

        total_opportunities = sum(len(v) for v in opportunities.values())
        logger.info(f"🔍 {total_opportunities} oportunidades de otimização encontradas")

        return opportunities

    def validate_memory_optimization(self) -> Dict[str, bool]:
        """
        Valida otimizações de memória.
        Equivalente a: validate-optimized-memory.ps1
        """
        logger.info("🧠 Validando otimizações de memória...")

        results = {}
        memory_dir = self.project_core / "memory"

        if not memory_dir.exists():
            results["memory_dir_exists"] = False
            return results

        results["memory_dir_exists"] = True

        # Verificar arquivos de memória
        memory_files = ["master_rule.md", "self_correction_log.md", "global-standards.md"]
        for file_name in memory_files:
            file_path = memory_dir / file_name
            results[f"memory_{file_name}"] = file_path.exists() and file_path.stat().st_size > 100

        # Verificar otimização de tamanho
        total_size = sum(f.stat().st_size for f in memory_dir.rglob("*") if f.is_file())
        results["memory_size_optimized"] = total_size < 100 * 1024 * 1024  # <100MB

        # Verificar estrutura otimizada
        subdirs = [d for d in memory_dir.iterdir() if d.is_dir()]
        results["memory_structure_optimized"] = len(subdirs) < 10  # <10 subdiretórios

        return results

    def generate_learning_metrics(self) -> Dict[str, any]:
        """
        Gera métricas de aprendizado do sistema.
        Equivalente a: learning-metrics.ps1
        """
        logger.info("📚 Gerando métricas de aprendizado...")

        # Analisar self_correction_log.md
        log_file = self.project_core / "memory" / "self_correction_log.md"
        metrics = {
            "timestamp": datetime.now().isoformat(),
            "learning_entries": 0,
            "error_patterns": 0,
            "success_patterns": 0,
            "recent_learnings": 0
        }

        if log_file.exists():
            content = log_file.read_text()

            # Contar entradas de aprendizado
            metrics["learning_entries"] = content.count("##")
            metrics["error_patterns"] = content.count("❌") + content.count("ERROR")
            metrics["success_patterns"] = content.count("✅") + content.count("SUCCESS")

            # Contar aprendizados recentes (últimos 7 dias)
            recent_date = (datetime.now() - timedelta(days=7)).strftime("%Y-%m-%d")
            metrics["recent_learnings"] = content.count(recent_date)

        # Analisar scripts Python vs PowerShell
        python_scripts = len(list(self.project_core.rglob("*.py")))
        powershell_scripts = len(list(self.project_core.rglob("*.ps1")))

        metrics["migration_progress"] = {
            "python_scripts": python_scripts,
            "powershell_scripts": powershell_scripts,
            "migration_ratio": python_scripts / (python_scripts + powershell_scripts) if (python_scripts + powershell_scripts) > 0 else 0
        }

        return metrics

    def _check_nested_duplicates(self) -> List[Dict]:
        """Verifica duplicatas aninhadas."""
        violations = []
        forbidden_patterns = [
            "@project-core/@project-core",
            "@project-core/memory/@project-core",
            "@project-core/*/memory/@project-core"
        ]

        for pattern in forbidden_patterns:
            pattern_path = self.project_root / pattern
            if pattern_path.exists():
                violations.append({
                    "type": "nested_duplicate",
                    "path": pattern,
                    "severity": "critical",
                    "timestamp": datetime.now().isoformat()
                })

        return violations

    def _get_project_size(self) -> float:
        """Calcula tamanho total do projeto em MB."""
        if HELPERS_AVAILABLE:
            total_size, _ = get_directory_size(self.project_root)
            return total_size / (1024 * 1024)
        else:
            # Fallback
            total_size = 0
            for file_path in self.project_root.rglob("*"):
                if file_path.is_file():
                    total_size += file_path.stat().st_size
            return total_size / (1024 * 1024)

    def _count_scripts(self) -> int:
        """Conta total de scripts no projeto."""
        extensions = ["*.py", "*.ps1", "*.js", "*.ts"]
        total_scripts = 0
        for ext in extensions:
            total_scripts += len(list(self.project_root.rglob(ext)))
        return total_scripts

    def _log_violations(self, violations: List[Dict], monitor_type: str):
        """Registra violações em log."""
        if violations:
            log_file = self.logs_dir / f"{monitor_type}_violations_{datetime.now().strftime('%Y%m%d')}.log"
            with open(log_file, 'a') as f:
                for violation in violations:
                    f.write(f"{violation['timestamp']} - {violation['severity'].upper()}: {violation['type']} at {violation['path']}\n")

    def _log_performance_metrics(self, metrics: Dict):
        """Registra métricas de performance."""
        log_file = self.logs_dir / f"performance_metrics_{datetime.now().strftime('%Y%m%d')}.log"
        with open(log_file, 'a') as f:
            f.write(f"{metrics['timestamp']} - CPU: {metrics['system']['cpu_percent']}%, "
                   f"Memory: {metrics['system']['memory_percent']}%, "
                   f"Disk: {metrics['system']['disk_percent']:.1f}%\n")

    def _log_sync_status(self, status: Dict):
        """Registra status de sincronização."""
        log_file = self.logs_dir / f"sync_status_{datetime.now().strftime('%Y%m%d')}.log"
        with open(log_file, 'a') as f:
            f.write(f"{status['timestamp']} - Synced: {status['synced_projects']}/{status['total_projects']}, "
                   f"Needs sync: {len(status['needs_sync'])}\n")

    def _trigger_auto_correction(self, violations: List[Dict]):
        """Dispara correção automática para violações críticas."""
        logger.info("🔧 Disparando correção automática...")

        for violation in violations:
            if violation["type"] == "missing_directory":
                dir_path = self.project_root / violation["path"]
                dir_path.mkdir(parents=True, exist_ok=True)
                logger.info(f"✅ Diretório criado: {violation['path']}")

            elif violation["type"] == "missing_file":
                file_path = self.project_root / violation["path"]
                file_path.parent.mkdir(parents=True, exist_ok=True)
                file_path.write_text(f"# {file_path.name}\n\nArquivo criado automaticamente pelo Monitor Manager.\n")
                logger.info(f"✅ Arquivo criado: {violation['path']}")

def main():
    """Função principal do Monitor Manager."""
    # Usar helper de argument parser se disponível
    if HELPERS_AVAILABLE:
        parser = create_monitor_parser()
        # Adicionar argumentos específicos não cobertos pelo helper
        parser.add_custom_argument('--scan-optimization', action='store_true', help='Escanear oportunidades de otimização')
        parser.add_custom_argument('--validate-memory', action='store_true', help='Validar otimizações de memória')
        parser.add_custom_argument('--learning-metrics', action='store_true', help='Gerar métricas de aprendizado')
        parser.add_custom_argument('--project-root', type=str, help='Caminho raiz do projeto')
        args = parser.parse_args()

        # Log de início de execução
        log_execution_start(logger, "monitor", vars(args))
    else:
        # Fallback para parser manual
        import argparse
        parser = argparse.ArgumentParser(description='VIBECODE Monitor Manager V4.0')
        parser.add_argument('--type', choices=['structure', 'performance', 'sync'],
                           default='structure', help='Tipo de monitoramento')
        parser.add_argument('--continuous', action='store_true',
                           help='Monitoramento contínuo')
        parser.add_argument('--interval', type=int, default=300,
                           help='Intervalo de monitoramento em segundos')
        parser.add_argument('--scan-optimization', action='store_true',
                           help='Escanear oportunidades de otimização')
        parser.add_argument('--validate-memory', action='store_true',
                           help='Validar otimizações de memória')
        parser.add_argument('--learning-metrics', action='store_true',
                           help='Gerar métricas de aprendizado')
        parser.add_argument('--project-root', type=str,
                           help='Caminho raiz do projeto')
        args = parser.parse_args()

    start_time = datetime.now()

    # Inicializar manager
    manager = MonitorManager(args.project_root)

    # Executar ações solicitadas
    if args.scan_optimization:
        opportunities = manager.scan_optimization_opportunities()
        total = sum(len(v) for v in opportunities.values())
        print(f"🔍 {total} oportunidades de otimização encontradas")
        for category, items in opportunities.items():
            if items:
                print(f"  {category}: {len(items)} itens")

    if args.validate_memory:
        results = manager.validate_memory_optimization()
        valid_count = sum(results.values())
        total_count = len(results)
        print(f"🧠 Validação de memória: {valid_count}/{total_count} verificações passaram")

    if args.learning_metrics:
        metrics = manager.generate_learning_metrics()
        print(f"📚 Métricas de aprendizado:")
        print(f"  Entradas: {metrics['learning_entries']}")
        print(f"  Progresso de migração: {metrics['migration_progress']['migration_ratio']:.1%}")

    if args.type == 'structure':
        result = manager.monitor_structure(args.continuous, args.interval)
        if not args.continuous:
            print(f"🏗️ Estrutura: {result['status']} ({result['violations_count']} violações)")

    elif args.type == 'performance':
        result = manager.monitor_performance(args.continuous, args.interval)
        if not args.continuous:
            print(f"📈 Performance: {result['status']}")
            print(f"  CPU: {result['system']['cpu_percent']}%")
            print(f"  Memory: {result['system']['memory_percent']}%")

    elif args.type == 'sync':
        result = manager.monitor_sync(args.continuous, args.interval)
        if not args.continuous:
            print(f"🔄 Sync: {result['synced_projects']}/{result['total_projects']} projetos sincronizados")

    # Log de fim de execução
    if HELPERS_AVAILABLE:
        duration = (datetime.now() - start_time).total_seconds()
        log_execution_end(logger, "monitor", True, duration)

    return 0

if __name__ == "__main__":
    sys.exit(main())
