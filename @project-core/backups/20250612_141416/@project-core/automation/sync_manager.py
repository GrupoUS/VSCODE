#!/usr/bin/env python3
"""
🔄 SYNC MANAGER - VIBECODE SYSTEM V4.0

Centralização de sincronização com repositórios GitHub.
Consolidação de: sync-github-auto.ps1, sync-main-repo.ps1, sync-monitor.ps1,
sync-github-multi-projects.ps1, setup-auto-sync.ps1, prevent-unnecessary-branches.ps1

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import os
import sys
import json
import argparse
import subprocess
import time
from pathlib import Path
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Tuple
import logging
import re

# Configuração de logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class SyncManager:
    """Gerenciador principal de sincronização de repositórios."""

    def __init__(self, project_root: str = None):
        self.project_root = Path(project_root) if project_root else Path.cwd()
        self.config_file = self.project_root / "config.json"
        self.sync_log = self.project_root / "@project-core" / "logs" / "sync.log"
        self.projects_dir = self.project_root / "@project-core" / "projects"

        # Criar diretórios necessários
        self.sync_log.parent.mkdir(parents=True, exist_ok=True)

    def sync_github_auto(self, project_name: str = None, force: bool = False) -> bool:
        """
        Sincronização automática com GitHub.
        Equivalente a: sync-github-auto.ps1
        """
        logger.info("🔄 Iniciando sincronização automática com GitHub...")

        try:
            # Verificar se é um repositório git
            if not (self.project_root / ".git").exists():
                logger.error("❌ Não é um repositório Git")
                return False

            # Verificar mudanças
            result = subprocess.run(['git', 'status', '--porcelain'],
                                  cwd=self.project_root, capture_output=True, text=True)

            if result.stdout.strip() or force:
                # Há mudanças para sincronizar
                success = self._execute_sync_sequence(project_name)

                if success:
                    self._log_sync_event("sync_auto", "success", project_name)
                    logger.info("✅ Sincronização automática concluída com sucesso")
                else:
                    self._log_sync_event("sync_auto", "failure", project_name)
                    logger.error("❌ Falha na sincronização automática")

                return success
            else:
                logger.info("ℹ️ Nenhuma alteração para sincronizar")
                return True

        except Exception as e:
            logger.error(f"❌ Erro na sincronização automática: {e}")
            self._log_sync_event("sync_auto", "error", project_name, str(e))
            return False

    def sync_main_repo(self, commit_message: str = None) -> bool:
        """
        Sincronização do repositório principal.
        Equivalente a: sync-main-repo.ps1
        """
        logger.info("📦 Sincronizando repositório principal...")

        try:
            # Verificar branch atual
            result = subprocess.run(['git', 'branch', '--show-current'],
                                  cwd=self.project_root, capture_output=True, text=True)
            current_branch = result.stdout.strip()

            if current_branch != 'main':
                logger.warning(f"⚠️ Branch atual: {current_branch} (não é main)")

            # Executar sequência de sync
            commit_msg = commit_message or f"Auto-sync: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"

            commands = [
                ['git', 'add', '.'],
                ['git', 'commit', '-m', commit_msg],
                ['git', 'push', 'origin', current_branch]
            ]

            for cmd in commands:
                result = subprocess.run(cmd, cwd=self.project_root, capture_output=True, text=True)
                if result.returncode != 0:
                    # Se commit falhar por não haver mudanças, não é erro
                    if 'nothing to commit' not in result.stdout.lower():
                        logger.error(f"❌ Falha no comando: {' '.join(cmd)}")
                        logger.error(f"   Erro: {result.stderr}")
                        return False

            logger.info("✅ Repositório principal sincronizado")
            self._log_sync_event("sync_main", "success")
            return True

        except Exception as e:
            logger.error(f"❌ Erro na sincronização do repositório principal: {e}")
            self._log_sync_event("sync_main", "error", error_detail=str(e))
            return False

    def sync_multi_projects(self, project_list: List[str] = None) -> Dict[str, bool]:
        """
        Sincronização de múltiplos projetos.
        Equivalente a: sync-github-multi-projects.ps1
        """
        logger.info("🔄 Sincronizando múltiplos projetos...")

        results = {}

        # Se não especificado, sincronizar todos os projetos
        if not project_list:
            if self.projects_dir.exists():
                project_list = [p.name for p in self.projects_dir.iterdir() if p.is_dir()]
            else:
                logger.warning("⚠️ Diretório de projetos não encontrado")
                return results

        for project in project_list:
            logger.info(f"  🔄 Sincronizando projeto: {project}")

            project_path = self.projects_dir / project
            if not project_path.exists():
                logger.warning(f"    ⚠️ Projeto não encontrado: {project}")
                results[project] = False
                continue

            try:
                # Verificar se é um repositório git
                if (project_path / ".git").exists():
                    # Sincronizar projeto específico
                    result = subprocess.run(['git', 'status', '--porcelain'],
                                          cwd=project_path, capture_output=True, text=True)

                    if result.stdout.strip():
                        # Há mudanças
                        commit_msg = f"Auto-sync {project}: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
                        commands = [
                            ['git', 'add', '.'],
                            ['git', 'commit', '-m', commit_msg],
                            ['git', 'push']
                        ]

                        success = True
                        for cmd in commands:
                            result = subprocess.run(cmd, cwd=project_path, capture_output=True, text=True)
                            if result.returncode != 0 and 'nothing to commit' not in result.stdout.lower():
                                success = False
                                break

                        results[project] = success
                        if success:
                            logger.info(f"    ✅ {project} sincronizado")
                        else:
                            logger.error(f"    ❌ Falha na sincronização de {project}")
                    else:
                        results[project] = True
                        logger.info(f"    ℹ️ {project} sem alterações")
                else:
                    logger.warning(f"    ⚠️ {project} não é um repositório Git")
                    results[project] = False

            except Exception as e:
                logger.error(f"    ❌ Erro em {project}: {e}")
                results[project] = False

        # Resumo
        successful = sum(1 for success in results.values() if success)
        total = len(results)
        logger.info(f"📊 Sincronização multi-projetos: {successful}/{total} sucessos")

        self._log_sync_event("sync_multi", "completed", details=f"{successful}/{total}")
        return results

    def monitor_sync(self, interval: int = 300, continuous: bool = False) -> bool:
        """
        Monitora e executa sincronização automática.
        Equivalente a: sync-monitor.ps1
        """
        logger.info(f"👀 Iniciando monitoramento de sincronização (intervalo: {interval}s)")

        if continuous:
            try:
                while True:
                    logger.info("🔍 Verificando necessidade de sincronização...")

                    # Verificar mudanças
                    if self._has_changes():
                        logger.info("📝 Mudanças detectadas, iniciando sincronização...")
                        self.sync_github_auto()
                    else:
                        logger.info("✅ Nenhuma mudança detectada")

                    logger.info(f"⏱️ Aguardando {interval} segundos...")
                    time.sleep(interval)

            except KeyboardInterrupt:
                logger.info("⏹️ Monitoramento interrompido pelo usuário")
                return True
        else:
            # Verificação única
            return self._has_changes()

    def setup_auto_sync(self, enable: bool = True, interval: int = 300) -> bool:
        """
        Configura sincronização automática.
        Equivalente a: setup-auto-sync.ps1
        """
        logger.info("⚙️ Configurando sincronização automática...")

        config = self._load_config()

        config['auto_sync'] = {
            'enabled': enable,
            'interval': interval,
            'last_setup': datetime.now().isoformat()
        }

        if self._save_config(config):
            if enable:
                logger.info(f"✅ Sincronização automática habilitada (intervalo: {interval}s)")
            else:
                logger.info("✅ Sincronização automática desabilitada")
            return True
        else:
            logger.error("❌ Falha ao salvar configuração")
            return False

    def prevent_unnecessary_branches(self, check_only: bool = False) -> bool:
        """
        Previne criação de branches desnecessárias.
        Equivalente a: prevent-unnecessary-branches.ps1
        """
        logger.info("🚫 Verificando branches desnecessárias...")

        try:
            # Listar branches locais
            result = subprocess.run(['git', 'branch'], cwd=self.project_root,
                                  capture_output=True, text=True)

            branches = []
            for line in result.stdout.split('\n'):
                branch = line.strip().replace('*', '').strip()
                if branch and branch not in ['main', 'master', 'develop']:
                    branches.append(branch)

            if branches:
                logger.warning(f"⚠️ Encontradas {len(branches)} branches locais:")
                for branch in branches:
                    logger.warning(f"    - {branch}")

                if not check_only:
                    response = input("Deseja remover branches desnecessárias? (y/N): ")
                    if response.lower() == 'y':
                        for branch in branches:
                            try:
                                subprocess.run(['git', 'branch', '-d', branch],
                                             cwd=self.project_root, check=True)
                                logger.info(f"    ✅ Branch removida: {branch}")
                            except subprocess.CalledProcessError:
                                logger.warning(f"    ⚠️ Não foi possível remover: {branch}")

                return False  # Há branches desnecessárias
            else:
                logger.info("✅ Nenhuma branch desnecessária encontrada")
                return True

        except Exception as e:
            logger.error(f"❌ Erro ao verificar branches: {e}")
            return False

    def validate_sync(self, remote: str = "origin") -> bool:
        """
        Valida sincronização com repositório remoto.
        Equivalente a: validate-sync.ps1
        """
        logger.info("🔍 Validando sincronização...")

        try:
            # Verificar se remote existe
            result = subprocess.run(['git', 'remote', 'get-url', remote],
                                  cwd=self.project_root, capture_output=True, text=True)

            if result.returncode != 0:
                logger.error(f"❌ Remote '{remote}' não encontrado")
                return False

            remote_url = result.stdout.strip()
            logger.info(f"📡 Remote URL: {remote_url}")

            # Verificar diferenças com remote
            subprocess.run(['git', 'fetch', remote], cwd=self.project_root, check=True)

            result = subprocess.run(['git', 'status', '--porcelain', '-b'],
                                  cwd=self.project_root, capture_output=True, text=True)

            status_lines = result.stdout.split('\n')
            branch_status = status_lines[0] if status_lines else ""

            if '[ahead' in branch_status:
                logger.warning("⚠️ Branch local está à frente do remote")
                return False
            elif '[behind' in branch_status:
                logger.warning("⚠️ Branch local está atrás do remote")
                return False
            else:
                logger.info("✅ Sincronização validada - repositório atualizado")
                return True

        except Exception as e:
            logger.error(f"❌ Erro na validação: {e}")
            return False

    def _execute_sync_sequence(self, project_name: str = None) -> bool:
        """Executa sequência completa de sincronização."""
        try:
            # 1. Verificar status
            result = subprocess.run(['git', 'status', '--porcelain'],
                                  cwd=self.project_root, capture_output=True, text=True)

            if not result.stdout.strip():
                return True  # Nada para sincronizar

            # 2. Adicionar arquivos
            subprocess.run(['git', 'add', '.'], cwd=self.project_root, check=True)

            # 3. Commit
            commit_msg = f"Auto-sync {project_name or 'project'}: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
            subprocess.run(['git', 'commit', '-m', commit_msg], cwd=self.project_root, check=True)

            # 4. Push
            subprocess.run(['git', 'push'], cwd=self.project_root, check=True)

            return True

        except subprocess.CalledProcessError as e:
            logger.error(f"❌ Erro na sequência de sync: {e}")
            return False

    def _has_changes(self) -> bool:
        """Verifica se há mudanças para sincronizar."""
        try:
            result = subprocess.run(['git', 'status', '--porcelain'],
                                  cwd=self.project_root, capture_output=True, text=True)
            return bool(result.stdout.strip())
        except Exception:
            return False

    def _load_config(self) -> Dict:
        """Carrega configuração do arquivo."""
        if self.config_file.exists():
            try:
                with open(self.config_file, 'r') as f:
                    return json.load(f)
            except Exception:
                pass
        return {}

    def _save_config(self, config: Dict) -> bool:
        """Salva configuração no arquivo."""
        try:
            with open(self.config_file, 'w') as f:
                json.dump(config, f, indent=2)
            return True
        except Exception as e:
            logger.error(f"❌ Erro ao salvar config: {e}")
            return False

    def _log_sync_event(self, event_type: str, status: str, project: str = None, error_detail: str = None, details: str = None):
        """Registra evento de sincronização."""
        log_entry = {
            "timestamp": datetime.now().isoformat(),
            "event_type": event_type,
            "status": status,
            "project": project,
            "error_detail": error_detail,
            "details": details
        }

        try:
            with open(self.sync_log, 'a') as f:
                f.write(json.dumps(log_entry) + '\n')
        except Exception:
            pass  # Log não crítico

def main():
    """Função principal do Sync Manager."""
    parser = argparse.ArgumentParser(description='VIBECODE Sync Manager V4.0')
    parser.add_argument('--sync-auto', action='store_true',
                       help='Sincronização automática com GitHub')
    parser.add_argument('--sync-main', action='store_true',
                       help='Sincronizar repositório principal')
    parser.add_argument('--sync-multi', action='store_true',
                       help='Sincronizar múltiplos projetos')
    parser.add_argument('--monitor', action='store_true',
                       help='Monitorar e sincronizar automaticamente')
    parser.add_argument('--setup-auto', action='store_true',
                       help='Configurar sincronização automática')
    parser.add_argument('--prevent-branches', action='store_true',
                       help='Verificar/remover branches desnecessárias')
    parser.add_argument('--validate', action='store_true',
                       help='Validar sincronização com remote')
    parser.add_argument('--project-name', type=str,
                       help='Nome do projeto específico')
    parser.add_argument('--projects', nargs='+',
                       help='Lista de projetos para sincronizar')
    parser.add_argument('--commit-message', type=str,
                       help='Mensagem de commit personalizada')
    parser.add_argument('--interval', type=int, default=300,
                       help='Intervalo de monitoramento (segundos)')
    parser.add_argument('--continuous', action='store_true',
                       help='Monitoramento contínuo')
    parser.add_argument('--force', action='store_true',
                       help='Forçar sincronização mesmo sem mudanças')
    parser.add_argument('--disable-auto', action='store_true',
                       help='Desabilitar sincronização automática')
    parser.add_argument('--check-only', action='store_true',
                       help='Apenas verificar, não executar ações')
    parser.add_argument('--project-root', type=str,
                       help='Caminho raiz do projeto')

    args = parser.parse_args()

    # Inicializar manager
    manager = SyncManager(args.project_root)

    success = True

    # Executar ações solicitadas
    if args.sync_auto:
        success &= manager.sync_github_auto(args.project_name, args.force)

    if args.sync_main:
        success &= manager.sync_main_repo(args.commit_message)

    if args.sync_multi:
        results = manager.sync_multi_projects(args.projects)
        success &= all(results.values())
        print(f"📊 Projetos sincronizados: {sum(results.values())}/{len(results)}")

    if args.monitor:
        success &= manager.monitor_sync(args.interval, args.continuous)

    if args.setup_auto:
        enable = not args.disable_auto
        success &= manager.setup_auto_sync(enable, args.interval)

    if args.prevent_branches:
        success &= manager.prevent_unnecessary_branches(args.check_only)

    if args.validate:
        success &= manager.validate_sync()

    # Se nenhuma ação especificada, mostrar help
    if not any([args.sync_auto, args.sync_main, args.sync_multi, args.monitor,
               args.setup_auto, args.prevent_branches, args.validate]):
        parser.print_help()
        return 0

    return 0 if success else 1

if __name__ == "__main__":
    sys.exit(main())
