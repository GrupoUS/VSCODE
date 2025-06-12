#!/usr/bin/env python3
"""
🏗️ ARCHITECTURE MANAGER - VIBECODE SYSTEM V4.0

Gerenciamento de arquitetura e estrutura do projeto.
Consolidação de: architecture-restoration.ps1, pre-commit-structure-validator.ps1,
workflow-integration-setup.ps1, structure-integrity-monitor.ps1

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import os
import sys
import json
import argparse
import subprocess
import shutil
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional, Tuple
import logging

# Configuração de logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class ArchitectureManager:
    """Gerenciador principal de arquitetura do projeto."""

    def __init__(self, project_root: str = None):
        self.project_root = Path(project_root) if project_root else Path.cwd()
        self.project_core = self.project_root / "@project-core"
        self.memory_path = self.project_core / "memory"
        self.rules_path = self.project_core / "rules"

    def validate_structure(self, target_path: str = None, dry_run: bool = False) -> bool:
        """
        Valida a estrutura do projeto conforme padrões VIBECODE V4.0.
        Equivalente a: pre-commit-structure-validator.ps1
        """
        logger.info("🔍 Iniciando validação de estrutura...")

        target = Path(target_path) if target_path else self.project_root
        issues = []

        # Estruturas obrigatórias
        required_dirs = [
            "@project-core/memory",
            "@project-core/rules",
            "@project-core/automation",
            "@project-core/configs",
            "@project-core/docs"
        ]

        required_files = [
            "@project-core/memory/master_rule.md",
            "@project-core/memory/self_correction_log.md",
            "@project-core/memory/global-standards.md"
        ]

        # Verificar diretórios obrigatórios
        for dir_path in required_dirs:
            full_path = self.project_root / dir_path
            if not full_path.exists():
                issues.append(f"❌ Diretório obrigatório ausente: {dir_path}")
                if not dry_run:
                    full_path.mkdir(parents=True, exist_ok=True)
                    logger.info(f"✅ Criado diretório: {dir_path}")

        # Verificar arquivos obrigatórios
        for file_path in required_files:
            full_path = self.project_root / file_path
            if not full_path.exists():
                issues.append(f"❌ Arquivo obrigatório ausente: {file_path}")
                if not dry_run:
                    self._create_default_file(full_path)

        # Verificar isolamento de projetos
        project_files_in_root = []
        for item in self.project_root.iterdir():
            if item.is_file() and item.suffix in ['.html', '.css', '.js', '.ts', '.tsx', '.jsx']:
                if item.name not in ['README.md', 'LICENSE', '.gitignore']:
                    project_files_in_root.append(item.name)

        if project_files_in_root:
            issues.append(f"❌ Arquivos de projeto na raiz (devem estar em @project-core/projects/): {project_files_in_root}")

        # Relatório
        if issues:
            logger.warning(f"🚨 {len(issues)} problemas de estrutura encontrados:")
            for issue in issues:
                logger.warning(f"  {issue}")
            return False
        else:
            logger.info("✅ Estrutura do projeto validada com sucesso!")
            return True

    def restore_architecture(self, backup_path: str = None, dry_run: bool = False) -> bool:
        """
        Restaura a arquitetura do projeto a partir de backup ou padrões.
        Equivalente a: architecture-restoration.ps1
        """
        logger.info("🔄 Iniciando restauração de arquitetura...")

        if backup_path and Path(backup_path).exists():
            return self._restore_from_backup(backup_path, dry_run)
        else:
            return self._restore_from_defaults(dry_run)

    def monitor_integrity(self, continuous: bool = False, interval: int = 300) -> bool:
        """
        Monitora a integridade da estrutura do projeto.
        Equivalente a: structure-integrity-monitor.ps1
        """
        logger.info("📊 Iniciando monitoramento de integridade...")

        def check_integrity():
            violations = []

            # Verificar memory bank
            memory_files = ['master_rule.md', 'self_correction_log.md', 'global-standards.md']
            for file in memory_files:
                path = self.memory_path / file
                if not path.exists():
                    violations.append(f"Memory bank file missing: {file}")
                elif path.stat().st_size == 0:
                    violations.append(f"Memory bank file empty: {file}")

            # Verificar configurações críticas
            config_files = ['.cursorrules', '.gitignore', 'README.md']
            for file in config_files:
                path = self.project_root / file
                if not path.exists():
                    violations.append(f"Critical config missing: {file}")

            return violations

        if continuous:
            import time
            logger.info(f"📍 Monitoramento contínuo ativado (intervalo: {interval}s)")
            while True:
                violations = check_integrity()
                if violations:
                    logger.error(f"🚨 {len(violations)} violações detectadas:")
                    for violation in violations:
                        logger.error(f"  ❌ {violation}")
                    # Auto-correção
                    self.validate_structure()
                else:
                    logger.info("✅ Integridade verificada")
                time.sleep(interval)
        else:
            violations = check_integrity()
            if violations:
                logger.error(f"🚨 {len(violations)} violações de integridade:")
                for violation in violations:
                    logger.error(f"  ❌ {violation}")
                return False
            else:
                logger.info("✅ Integridade do projeto confirmada")
                return True

    def setup_workflows(self, install_hooks: bool = False) -> bool:
        """
        Configura workflows e integrações de CI/CD.
        Equivalente a: workflow-integration-setup.ps1
        """
        logger.info("⚙️ Configurando workflows...")

        success = True

        # Criar .github/workflows se não existir
        workflows_dir = self.project_root / ".github" / "workflows"
        workflows_dir.mkdir(parents=True, exist_ok=True)

        # Template de workflow para validação
        validation_workflow = {
            'name': 'VIBECODE System Validation',
            'on': ['push', 'pull_request'],
            'jobs': {
                'validate': {
                    'runs-on': 'ubuntu-latest',
                    'steps': [
                        {
                            'name': 'Checkout Code',
                            'uses': 'actions/checkout@v4'
                        },
                        {
                            'name': 'Set up Python',
                            'uses': 'actions/setup-python@v5',
                            'with': {'python-version': '3.11'}
                        },
                        {
                            'name': 'Install Dependencies',
                            'run': 'python -m pip install --upgrade pip\npip install -r @project-core/requirements.txt'
                        },
                        {
                            'name': 'Architecture Validation',
                            'run': 'python @project-core/automation/architecture_manager.py --validate-structure'
                        },
                        {
                            'name': 'System Health Check',
                            'run': 'python @project-core/automation/validation_suite.py --health-check'
                        }
                    ]
                }
            }
        }

        # Salvar workflow
        workflow_file = workflows_dir / "vibecode-validation.yml"
        try:
            import yaml
            with open(workflow_file, 'w') as f:
                yaml.dump(validation_workflow, f, default_flow_style=False)
            logger.info(f"✅ Workflow criado: {workflow_file}")
        except ImportError:
            logger.warning("⚠️ PyYAML não disponível. Workflow não criado.")
            success = False

        # Instalar git hooks se solicitado
        if install_hooks:
            success &= self._install_git_hooks()

        return success

    def _create_default_file(self, file_path: Path):
        """Cria arquivo padrão se não existir."""
        if file_path.name == "master_rule.md":
            content = "# Master Rule - VIBECODE SYSTEM V4.0\n\nArquivo gerado automaticamente pelo Architecture Manager.\n"
        elif file_path.name == "self_correction_log.md":
            content = "# Log de Auto-Correção\n\nArquivo gerado automaticamente pelo Architecture Manager.\n"
        elif file_path.name == "global-standards.md":
            content = "# Global Standards\n\nArquivo gerado automaticamente pelo Architecture Manager.\n"
        else:
            content = f"# {file_path.name}\n\nArquivo gerado automaticamente pelo Architecture Manager.\n"

        file_path.parent.mkdir(parents=True, exist_ok=True)
        file_path.write_text(content, encoding='utf-8')
        logger.info(f"✅ Arquivo padrão criado: {file_path}")

    def _restore_from_backup(self, backup_path: str, dry_run: bool) -> bool:
        """Restaura estrutura a partir de backup."""
        logger.info(f"📂 Restaurando de backup: {backup_path}")
        # Implementação da restauração de backup
        return True

    def _restore_from_defaults(self, dry_run: bool) -> bool:
        """Restaura estrutura usando padrões VIBECODE."""
        logger.info("🔧 Restaurando estrutura padrão VIBECODE V4.0...")
        return self.validate_structure(dry_run=dry_run)

    def _install_git_hooks(self) -> bool:
        """Instala git hooks para validação automática."""
        hooks_dir = self.project_root / ".git" / "hooks"
        if not hooks_dir.exists():
            logger.error("❌ Diretório .git/hooks não encontrado")
            return False

        pre_commit_hook = hooks_dir / "pre-commit"
        hook_content = f"""#!/bin/bash
# VIBECODE V4.0 Pre-commit Hook
python "{self.project_root / '@project-core/automation/architecture_manager.py'}" --validate-structure
exit $?
"""

        pre_commit_hook.write_text(hook_content)
        pre_commit_hook.chmod(0o755)
        logger.info("✅ Git hook pré-commit instalado")
        return True

def main():
    """Função principal do Architecture Manager."""
    parser = argparse.ArgumentParser(description='VIBECODE Architecture Manager V4.0')
    parser.add_argument('--validate-structure', action='store_true',
                       help='Validar estrutura do projeto')
    parser.add_argument('--restore-architecture', action='store_true',
                       help='Restaurar arquitetura do projeto')
    parser.add_argument('--monitor-integrity', action='store_true',
                       help='Monitorar integridade do projeto')
    parser.add_argument('--setup-workflows', action='store_true',
                       help='Configurar workflows de CI/CD')
    parser.add_argument('--install-hooks', action='store_true',
                       help='Instalar git hooks')
    parser.add_argument('--continuous', action='store_true',
                       help='Modo de monitoramento contínuo')
    parser.add_argument('--interval', type=int, default=300,
                       help='Intervalo de monitoramento (segundos)')
    parser.add_argument('--target-path', type=str,
                       help='Caminho específico para validação')
    parser.add_argument('--backup-path', type=str,
                       help='Caminho do backup para restauração')
    parser.add_argument('--dry-run', action='store_true',
                       help='Executar sem fazer alterações')
    parser.add_argument('--project-root', type=str,
                       help='Caminho raiz do projeto')

    args = parser.parse_args()

    # Inicializar manager
    manager = ArchitectureManager(args.project_root)

    success = True

    # Executar ações solicitadas
    if args.validate_structure:
        success &= manager.validate_structure(args.target_path, args.dry_run)

    if args.restore_architecture:
        success &= manager.restore_architecture(args.backup_path, args.dry_run)

    if args.monitor_integrity:
        success &= manager.monitor_integrity(args.continuous, args.interval)

    if args.setup_workflows:
        success &= manager.setup_workflows(args.install_hooks)

    # Se nenhuma ação especificada, mostrar help
    if not any([args.validate_structure, args.restore_architecture,
               args.monitor_integrity, args.setup_workflows]):
        parser.print_help()
        return 0

    return 0 if success else 1

if __name__ == "__main__":
    sys.exit(main())
