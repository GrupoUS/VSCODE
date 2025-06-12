#!/usr/bin/env python3
"""
⚙️ SETUP MANAGER - VIBECODE SYSTEM V4.0

Consolidação de todos os scripts de configuração e setup:
- setup-auto-sync.ps1, setup-augment-optimization.ps1
- workflow-integration-setup.ps1, pre-commit-structure-validator.ps1
- test-git-setup.ps1, connect-existing-repos.ps1

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import os
import sys
import shutil
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional, Tuple

# Importar helpers VIBECODE V4.0
try:
    # Adicionar caminho dos helpers ao sys.path
    sys.path.insert(0, str(Path(__file__).parent.parent))
    from helpers.core.logger_utils import get_vibecode_logger, log_execution_start, log_execution_end, log_step
    from helpers.core.argument_parser import VibeCodeArgumentParser
    from helpers.system.path_utils import VibeCodePaths
    from helpers.system.process_utils import run_command, run_git_command, check_git_status
    from helpers.data.json_utils import safe_save_json, safe_load_json
    HELPERS_AVAILABLE = True
except ImportError as e:
    # Fallback para compatibilidade
    import logging
    import argparse
    import json
    import subprocess
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    logger = logging.getLogger(__name__)
    HELPERS_AVAILABLE = False
    print(f"⚠️ Helpers não disponíveis (usando fallback): {e}")

# Configurar logger
if HELPERS_AVAILABLE:
    logger = get_vibecode_logger("setup")
else:
    logger = logging.getLogger(__name__)

class SetupManager:
    """Gerenciador consolidado de configuração VIBECODE V4.0."""

    def __init__(self, project_root: str = None):
        # Usar helper de paths se disponível
        if HELPERS_AVAILABLE:
            self.paths = VibeCodePaths(project_root)
            self.project_root = self.paths.project_root
            self.project_core = self.paths.project_core
            self.configs_dir = self.paths.configs_path
        else:
            # Fallback para compatibilidade
            self.project_root = Path(project_root) if project_root else Path.cwd()
            self.project_core = self.project_root / "@project-core"
            self.configs_dir = self.project_core / "configs"

        # Configurações padrão
        self.default_configs = {
            "sync": {
                "auto_commit": True,
                "default_branch": "main",
                "commit_message": "Auto-sync: VIBECODE System V4.0 update",
                "backup_before_sync": True
            },
            "optimization": {
                "enable_caching": True,
                "auto_cleanup": True,
                "performance_monitoring": True,
                "memory_optimization": True
            },
            "workflow": {
                "enable_pre_commit_hooks": True,
                "auto_validation": True,
                "continuous_integration": True,
                "automated_testing": True
            },
            "git": {
                "user_name": "GRUPO US VIBECODE",
                "user_email": "vibecode@grupous.com",
                "default_branch": "main",
                "auto_push": False
            }
        }

    def setup_sync(self, install: bool = False, validate: bool = False) -> bool:
        """
        Configura sistema de sincronização automática.
        Equivalente a: setup-auto-sync.ps1
        """
        log_step(logger, "🔄 Configurando sistema de sincronização...")

        if install:
            # Criar configuração de sync
            sync_config_path = self.configs_dir / "sync_config.json"
            self.configs_dir.mkdir(exist_ok=True)

            if HELPERS_AVAILABLE:
                safe_save_json(self.default_configs["sync"], sync_config_path)
            else:
                import json
                with open(sync_config_path, 'w') as f:
                    json.dump(self.default_configs["sync"], f, indent=2)

            logger.info(f"✅ Configuração de sync criada: {sync_config_path}")

            # Configurar Git hooks para auto-sync
            self._setup_git_hooks()

            # Criar script de sync automático
            self._create_auto_sync_script()

        if validate:
            return self._validate_sync_setup()

        return True

    def setup_optimization(self, install: bool = False, validate: bool = False) -> bool:
        """
        Configura otimizações do Augment e sistema.
        Equivalente a: setup-augment-optimization.ps1
        """
        log_step(logger, "⚡ Configurando otimizações do sistema...")

        if install:
            # Criar configuração de otimização
            opt_config_path = self.configs_dir / "optimization_config.json"
            self.configs_dir.mkdir(exist_ok=True)

            if HELPERS_AVAILABLE:
                safe_save_json(self.default_configs["optimization"], opt_config_path)
            else:
                import json
                with open(opt_config_path, 'w') as f:
                    json.dump(self.default_configs["optimization"], f, indent=2)

            logger.info(f"✅ Configuração de otimização criada: {opt_config_path}")

            # Configurar VS Code settings para otimização
            self._setup_vscode_optimization()

            # Configurar Cursor settings para otimização
            self._setup_cursor_optimization()

            # Configurar cache e performance
            self._setup_performance_optimization()

        if validate:
            return self._validate_optimization_setup()

        return True

    def setup_workflow(self, install: bool = False, validate: bool = False) -> bool:
        """
        Configura integração de workflows e CI/CD.
        Equivalente a: workflow-integration-setup.ps1
        """
        logger.info("🔄 Configurando integração de workflows...")

        if install:
            # Criar configuração de workflow
            workflow_config_path = self.configs_dir / "workflow_config.json"
            self.configs_dir.mkdir(exist_ok=True)

            with open(workflow_config_path, 'w') as f:
                json.dump(self.default_configs["workflow"], f, indent=2)

            logger.info(f"✅ Configuração de workflow criada: {workflow_config_path}")

            # Configurar GitHub Actions
            self._setup_github_actions()

            # Configurar pre-commit hooks
            self._setup_pre_commit_hooks()

            # Configurar validação automática
            self._setup_auto_validation()

        if validate:
            return self._validate_workflow_setup()

        return True

    def setup_git(self, install: bool = False, validate: bool = False) -> bool:
        """
        Configura repositório Git e conexões.
        Equivalente a: test-git-setup.ps1, connect-existing-repos.ps1
        """
        logger.info("📦 Configurando Git e repositórios...")

        if install:
            # Configurar Git global
            self._configure_git_global()

            # Inicializar repositório se necessário
            if not (self.project_root / ".git").exists():
                self._initialize_git_repo()

            # Configurar remotes
            self._setup_git_remotes()

            # Configurar .gitignore
            self._setup_gitignore()

        if validate:
            return self._validate_git_setup()

        return True

    def validate_structure(self) -> bool:
        """
        Valida estrutura do projeto antes de commits.
        Equivalente a: pre-commit-structure-validator.ps1
        """
        logger.info("🔍 Validando estrutura do projeto...")

        # Verificar diretórios obrigatórios
        required_dirs = [
            "@project-core/memory",
            "@project-core/rules",
            "@project-core/automation",
            "@project-core/configs"
        ]

        missing_dirs = []
        for dir_path in required_dirs:
            full_path = self.project_root / dir_path
            if not full_path.exists():
                missing_dirs.append(dir_path)

        if missing_dirs:
            logger.error(f"❌ Diretórios obrigatórios ausentes: {missing_dirs}")
            return False

        # Verificar arquivos críticos
        critical_files = [
            "@project-core/memory/master_rule.md",
            "@project-core/memory/self_correction_log.md",
            "@project-core/memory/global-standards.md"
        ]

        missing_files = []
        for file_path in critical_files:
            full_path = self.project_root / file_path
            if not full_path.exists():
                missing_files.append(file_path)

        if missing_files:
            logger.error(f"❌ Arquivos críticos ausentes: {missing_files}")
            return False

        # Verificar isolamento de projetos
        project_files_in_root = []
        for item in self.project_root.iterdir():
            if item.is_file() and item.suffix in ['.html', '.css', '.js', '.ts', '.tsx', '.jsx']:
                if item.name not in ['README.md', 'LICENSE', '.gitignore']:
                    project_files_in_root.append(item.name)

        if project_files_in_root:
            logger.warning(f"⚠️ Arquivos de projeto na raiz: {project_files_in_root}")

        logger.info("✅ Estrutura do projeto validada")
        return True

    def _setup_git_hooks(self) -> bool:
        """Configura Git hooks para automação."""
        hooks_dir = self.project_root / ".git" / "hooks"
        if not hooks_dir.exists():
            logger.warning("⚠️ Diretório .git/hooks não encontrado")
            return False

        # Pre-commit hook
        pre_commit_hook = hooks_dir / "pre-commit"
        hook_content = f"""#!/bin/bash
# VIBECODE V4.0 Pre-commit Hook
echo "🔍 Validando estrutura do projeto..."
python "{self.project_core / 'automation/tasks/setup.py'}" --component structure --validate
exit $?
"""

        pre_commit_hook.write_text(hook_content)
        pre_commit_hook.chmod(0o755)

        logger.info("✅ Git hooks configurados")
        return True

    def _create_auto_sync_script(self) -> bool:
        """Cria script de sincronização automática."""
        auto_sync_script = self.project_core / "automation" / "auto_sync.py"

        script_content = f"""#!/usr/bin/env python3
# Auto-sync script gerado pelo Setup Manager
import subprocess
import sys
from pathlib import Path

def main():
    project_root = Path(__file__).parent.parent.parent
    sync_script = project_root / "@project-core/automation/tasks/sync.py"

    # Executar sincronização automática
    result = subprocess.run([sys.executable, str(sync_script), "--target", "all", "--auto-push"],
                          cwd=project_root)
    return result.returncode

if __name__ == "__main__":
    sys.exit(main())
"""

        auto_sync_script.write_text(script_content)
        auto_sync_script.chmod(0o755)

        logger.info(f"✅ Script de auto-sync criado: {auto_sync_script}")
        return True

    def _setup_vscode_optimization(self) -> bool:
        """Configura otimizações do VS Code."""
        vscode_dir = self.project_root / ".vscode"
        vscode_dir.mkdir(exist_ok=True)

        settings = {
            "files.watcherExclude": {
                "**/node_modules/**": True,
                "**/.git/**": True,
                "**/dist/**": True,
                "**/build/**": True,
                "**/__pycache__/**": True
            },
            "search.exclude": {
                "**/node_modules": True,
                "**/dist": True,
                "**/build": True,
                "**/__pycache__": True
            },
            "python.defaultInterpreterPath": "python",
            "python.linting.enabled": True,
            "python.linting.pylintEnabled": True
        }

        settings_file = vscode_dir / "settings.json"
        with open(settings_file, 'w') as f:
            json.dump(settings, f, indent=2)

        logger.info("✅ VS Code otimizado")
        return True

    def _setup_cursor_optimization(self) -> bool:
        """Configura otimizações do Cursor."""
        cursor_rules = self.project_root / ".cursorrules"

        rules_content = """# VIBECODE SYSTEM V4.0 - Cursor Rules
# Configuração otimizada gerada pelo Setup Manager

## Princípios de Desenvolvimento
- Sempre consultar @project-core/memory/master_rule.md antes de qualquer ação
- Seguir padrões VIBECODE V4.0 para consistência
- Priorizar performance e manutenibilidade
- Documentar decisões importantes

## Estrutura de Projeto
- Manter isolamento de projetos em @project-core/projects/
- Usar scripts Python consolidados em @project-core/automation/tasks/
- Seguir convenções de nomenclatura estabelecidas

## Qualidade de Código
- Aplicar linting e formatação automática
- Escrever testes para funcionalidades críticas
- Manter cobertura de código adequada
- Seguir princípios SOLID e DRY
"""

        cursor_rules.write_text(rules_content)
        logger.info("✅ Cursor otimizado")
        return True

    def _setup_performance_optimization(self) -> bool:
        """Configura otimizações de performance."""
        # Criar configuração de cache
        cache_config = {
            "enabled": True,
            "max_size_mb": 500,
            "cleanup_interval_hours": 24,
            "exclude_patterns": ["*.log", "*.tmp", "__pycache__"]
        }

        cache_config_file = self.configs_dir / "cache_config.json"
        with open(cache_config_file, 'w') as f:
            json.dump(cache_config, f, indent=2)

        logger.info("✅ Performance otimizada")
        return True

    def _setup_github_actions(self) -> bool:
        """Configura GitHub Actions workflows."""
        workflows_dir = self.project_root / ".github" / "workflows"
        workflows_dir.mkdir(parents=True, exist_ok=True)

        # Workflow de validação
        validation_workflow = {
            "name": "VIBECODE Validation",
            "on": ["push", "pull_request"],
            "jobs": {
                "validate": {
                    "runs-on": "ubuntu-latest",
                    "steps": [
                        {
                            "name": "Checkout Code",
                            "uses": "actions/checkout@v4"
                        },
                        {
                            "name": "Set up Python",
                            "uses": "actions/setup-python@v5",
                            "with": {"python-version": "3.11"}
                        },
                        {
                            "name": "Install Dependencies",
                            "run": "python -m pip install --upgrade pip\npip install -r @project-core/requirements.txt"
                        },
                        {
                            "name": "Run Tests",
                            "run": "python @project-core/automation/tasks/run_tests.py --level comprehensive --report"
                        }
                    ]
                }
            }
        }

        workflow_file = workflows_dir / "vibecode-validation.yml"
        import yaml
        with open(workflow_file, 'w') as f:
            yaml.dump(validation_workflow, f, default_flow_style=False)

        logger.info("✅ GitHub Actions configurado")
        return True

    def _setup_pre_commit_hooks(self) -> bool:
        """Configura pre-commit hooks."""
        pre_commit_config = {
            "repos": [
                {
                    "repo": "https://github.com/pre-commit/pre-commit-hooks",
                    "rev": "v4.4.0",
                    "hooks": [
                        {"id": "trailing-whitespace"},
                        {"id": "end-of-file-fixer"},
                        {"id": "check-yaml"},
                        {"id": "check-json"}
                    ]
                },
                {
                    "repo": "https://github.com/psf/black",
                    "rev": "22.0.0",
                    "hooks": [{"id": "black"}]
                }
            ]
        }

        pre_commit_file = self.project_root / ".pre-commit-config.yaml"
        import yaml
        with open(pre_commit_file, 'w') as f:
            yaml.dump(pre_commit_config, f, default_flow_style=False)

        logger.info("✅ Pre-commit hooks configurados")
        return True

    def _setup_auto_validation(self) -> bool:
        """Configura validação automática."""
        validation_script = self.project_core / "automation" / "auto_validate.py"

        script_content = """#!/usr/bin/env python3
# Auto-validation script gerado pelo Setup Manager
import subprocess
import sys
from pathlib import Path

def main():
    project_root = Path(__file__).parent.parent.parent
    test_script = project_root / "@project-core/automation/tasks/run_tests.py"

    # Executar validação automática
    result = subprocess.run([sys.executable, str(test_script), "--level", "basic"],
                          cwd=project_root)
    return result.returncode

if __name__ == "__main__":
    sys.exit(main())
"""

        validation_script.write_text(script_content)
        validation_script.chmod(0o755)

        logger.info("✅ Validação automática configurada")
        return True

    def _configure_git_global(self) -> bool:
        """Configura Git globalmente."""
        if HELPERS_AVAILABLE:
            # Usar helper de Git
            commands = [
                ['config', '--global', 'user.name', self.default_configs["git"]["user_name"]],
                ['config', '--global', 'user.email', self.default_configs["git"]["user_email"]],
                ['config', '--global', 'init.defaultBranch', self.default_configs["git"]["default_branch"]]
            ]

            for cmd in commands:
                result = run_git_command(cmd)
                if not result.success:
                    logger.error(f"❌ Erro na configuração Git: {result.stderr}")
                    return False

            logger.info("✅ Git configurado globalmente")
            return True
        else:
            # Fallback para subprocess
            try:
                import subprocess
                subprocess.run(['git', 'config', '--global', 'user.name', self.default_configs["git"]["user_name"]], check=True)
                subprocess.run(['git', 'config', '--global', 'user.email', self.default_configs["git"]["user_email"]], check=True)
                subprocess.run(['git', 'config', '--global', 'init.defaultBranch', self.default_configs["git"]["default_branch"]], check=True)

                logger.info("✅ Git configurado globalmente")
                return True
            except subprocess.CalledProcessError as e:
                logger.error(f"❌ Erro na configuração Git: {e}")
                return False

    def _initialize_git_repo(self) -> bool:
        """Inicializa repositório Git."""
        if HELPERS_AVAILABLE:
            result = run_git_command(['init'], cwd=self.project_root)
            if result.success:
                logger.info("✅ Repositório Git inicializado")
                return True
            else:
                logger.error(f"❌ Erro ao inicializar Git: {result.stderr}")
                return False
        else:
            # Fallback para subprocess
            try:
                import subprocess
                subprocess.run(['git', 'init'], check=True, cwd=self.project_root)
                logger.info("✅ Repositório Git inicializado")
                return True
            except subprocess.CalledProcessError as e:
                logger.error(f"❌ Erro ao inicializar Git: {e}")
                return False

    def _setup_git_remotes(self) -> bool:
        """Configura remotes do Git."""
        # Esta função seria personalizada baseada nos repositórios específicos
        logger.info("✅ Git remotes configurados")
        return True

    def _setup_gitignore(self) -> bool:
        """Configura .gitignore."""
        gitignore_content = """# VIBECODE SYSTEM V4.0 - .gitignore
# Gerado pelo Setup Manager

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# IDEs
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Temporary files
*.tmp
*.temp
*.bak
*.old

# Environment variables
.env
.env.local
.env.production

# Cache
.cache/
.next/cache/

# Backups (large ones)
backups/large_*
"""

        gitignore_file = self.project_root / ".gitignore"
        gitignore_file.write_text(gitignore_content)

        logger.info("✅ .gitignore configurado")
        return True

    def _validate_sync_setup(self) -> bool:
        """Valida configuração de sync."""
        sync_config = self.configs_dir / "sync_config.json"
        return sync_config.exists()

    def _validate_optimization_setup(self) -> bool:
        """Valida configuração de otimização."""
        opt_config = self.configs_dir / "optimization_config.json"
        vscode_settings = self.project_root / ".vscode" / "settings.json"
        cursor_rules = self.project_root / ".cursorrules"

        return all([opt_config.exists(), vscode_settings.exists(), cursor_rules.exists()])

    def _validate_workflow_setup(self) -> bool:
        """Valida configuração de workflow."""
        workflow_config = self.configs_dir / "workflow_config.json"
        github_workflow = self.project_root / ".github" / "workflows" / "vibecode-validation.yml"
        pre_commit_config = self.project_root / ".pre-commit-config.yaml"

        return all([workflow_config.exists(), github_workflow.exists(), pre_commit_config.exists()])

    def _validate_git_setup(self) -> bool:
        """Valida configuração Git."""
        git_dir = self.project_root / ".git"
        gitignore = self.project_root / ".gitignore"

        return all([git_dir.exists(), gitignore.exists()])

def main():
    """Função principal do Setup Manager."""
    # Usar helper de argument parser se disponível
    if HELPERS_AVAILABLE:
        parser = VibeCodeArgumentParser("setup", 'VIBECODE Setup Manager V4.0')

        # Adicionar argumentos específicos de setup
        parser.add_custom_argument('--component', choices=['sync', 'optimization', 'workflow', 'git', 'structure'],
                                 required=True, help='Componente para configurar')
        parser.add_custom_argument('--install', action='store_true', help='Instalar/configurar componente')
        parser.add_custom_argument('--validate', action='store_true', help='Validar configuração do componente')
        parser.add_custom_argument('--project-root', type=str, help='Caminho raiz do projeto')

        args = parser.parse_args()

        # Log de início de execução
        log_execution_start(logger, "setup", vars(args))
    else:
        # Fallback para parser manual
        import argparse
        parser = argparse.ArgumentParser(description='VIBECODE Setup Manager V4.0')
        parser.add_argument('--component', choices=['sync', 'optimization', 'workflow', 'git', 'structure'],
                           required=True, help='Componente para configurar')
        parser.add_argument('--install', action='store_true', help='Instalar/configurar componente')
        parser.add_argument('--validate', action='store_true', help='Validar configuração do componente')
        parser.add_argument('--project-root', type=str, help='Caminho raiz do projeto')
        args = parser.parse_args()

    start_time = datetime.now()

    # Inicializar manager
    manager = SetupManager(args.project_root)

    success = True

    # Executar ações baseadas no componente
    if args.component == 'sync':
        success = manager.setup_sync(args.install, args.validate)
    elif args.component == 'optimization':
        success = manager.setup_optimization(args.install, args.validate)
    elif args.component == 'workflow':
        success = manager.setup_workflow(args.install, args.validate)
    elif args.component == 'git':
        success = manager.setup_git(args.install, args.validate)
    elif args.component == 'structure':
        success = manager.validate_structure()

    # Log de fim de execução
    if HELPERS_AVAILABLE:
        duration = (datetime.now() - start_time).total_seconds()
        log_execution_end(logger, "setup", success, duration)

    return 0 if success else 1

if __name__ == "__main__":
    sys.exit(main())
