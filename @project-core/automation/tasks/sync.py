#!/usr/bin/env python3
"""
🔄 SYNC MANAGER - VIBECODE SYSTEM V4.0

Consolidação de todos os scripts de sincronização Git:
- sync-github-auto.ps1, sync-github-force.ps1, sync-all-repos.ps1
- sync-main-repo.ps1, sync-existing-only.ps1, sync-unified-environment.ps1
- auto-push.ps1, auto-sync.ps1, quick-push.ps1, final-push.ps1
- push-all-projects.ps1, execute-push-now.ps1

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

class SyncManager:
    """Gerenciador consolidado de sincronização Git VIBECODE V4.0."""

    def __init__(self, project_root: str = None):
        self.project_root = Path(project_root) if project_root else Path.cwd()
        self.project_core = self.project_root / "@project-core"
        
        # Projetos conhecidos
        self.known_projects = [
            "@neonpro",
            "@aegiswallet", 
            "@harmoniza-facil-agendas",
            "@project-core"
        ]
        
        # Configurações de sync
        self.sync_config = {
            "default_branch": "main",
            "auto_commit_message": "Auto-sync: VIBECODE System V4.0 update",
            "force_push_warning": True,
            "backup_before_force": True
        }

    def sync_all(self, force: bool = False, auto_push: bool = False, 
                 projects: List[str] = None) -> Dict[str, bool]:
        """
        Sincroniza todos os repositórios ou projetos específicos.
        Equivalente a: sync-all-repos.ps1, sync-github-auto.ps1
        """
        logger.info("🔄 Iniciando sincronização completa...")
        
        target_projects = projects if projects else self.known_projects
        results = {}
        
        for project in target_projects:
            project_path = self.project_root / project
            if project_path.exists():
                logger.info(f"📁 Sincronizando projeto: {project}")
                results[project] = self._sync_project(project_path, force, auto_push)
            else:
                logger.warning(f"⚠️ Projeto não encontrado: {project}")
                results[project] = False
        
        return results

    def sync_specific(self, target: str, force: bool = False, 
                     auto_push: bool = False) -> bool:
        """
        Sincroniza um projeto específico.
        Equivalente a: sync-main-repo.ps1, sync-existing-only.ps1
        """
        logger.info(f"🎯 Sincronizando projeto específico: {target}")
        
        if target == "main":
            target_path = self.project_root
        else:
            target_path = self.project_root / target
        
        if not target_path.exists():
            logger.error(f"❌ Projeto não encontrado: {target}")
            return False
        
        return self._sync_project(target_path, force, auto_push)

    def sync_existing_only(self, auto_push: bool = False) -> Dict[str, bool]:
        """
        Sincroniza apenas projetos que já existem localmente.
        Equivalente a: sync-existing-only.ps1
        """
        logger.info("📂 Sincronizando apenas projetos existentes...")
        
        results = {}
        existing_projects = []
        
        # Detectar projetos existentes
        for project in self.known_projects:
            project_path = self.project_root / project
            if project_path.exists() and self._is_git_repo(project_path):
                existing_projects.append(project)
        
        logger.info(f"📋 Projetos existentes encontrados: {len(existing_projects)}")
        
        for project in existing_projects:
            project_path = self.project_root / project
            logger.info(f"🔄 Sincronizando: {project}")
            results[project] = self._sync_project(project_path, False, auto_push)
        
        return results

    def force_sync(self, target: str = "all", backup: bool = True) -> Dict[str, bool]:
        """
        Sincronização forçada com backup opcional.
        Equivalente a: sync-github-force.ps1
        """
        logger.warning("⚠️ SINCRONIZAÇÃO FORÇADA INICIADA")
        
        if backup:
            logger.info("💾 Criando backup antes da sincronização forçada...")
            self._create_backup()
        
        if target == "all":
            return self.sync_all(force=True, auto_push=True)
        else:
            result = self.sync_specific(target, force=True, auto_push=True)
            return {target: result}

    def quick_push(self, message: str = None) -> bool:
        """
        Push rápido do repositório atual.
        Equivalente a: quick-push.ps1, auto-push.ps1
        """
        logger.info("⚡ Executando push rápido...")
        
        commit_message = message or self.sync_config["auto_commit_message"]
        
        try:
            # Add all changes
            subprocess.run(['git', 'add', '.'], check=True, cwd=self.project_root)
            
            # Commit changes
            subprocess.run(['git', 'commit', '-m', commit_message], 
                          check=True, cwd=self.project_root)
            
            # Push to remote
            subprocess.run(['git', 'push'], check=True, cwd=self.project_root)
            
            logger.info("✅ Push rápido concluído com sucesso")
            return True
            
        except subprocess.CalledProcessError as e:
            logger.error(f"❌ Erro no push rápido: {e}")
            return False

    def final_push(self, projects: List[str] = None) -> Dict[str, bool]:
        """
        Push final para múltiplos projetos.
        Equivalente a: final-push.ps1, push-all-projects.ps1
        """
        logger.info("🏁 Executando push final...")
        
        target_projects = projects if projects else self.known_projects
        results = {}
        
        for project in target_projects:
            project_path = self.project_root / project
            if project_path.exists() and self._is_git_repo(project_path):
                logger.info(f"📤 Push final para: {project}")
                results[project] = self._push_project(project_path)
            else:
                logger.warning(f"⚠️ Projeto ignorado (não é repo Git): {project}")
                results[project] = False
        
        return results

    def sync_unified_environment(self) -> bool:
        """
        Sincroniza ambiente unificado de desenvolvimento.
        Equivalente a: sync-unified-environment.ps1
        """
        logger.info("🔗 Sincronizando ambiente unificado...")
        
        # Sincronizar configurações
        config_sync = self._sync_configurations()
        
        # Sincronizar repositório principal
        main_sync = self._sync_project(self.project_root, False, False)
        
        # Sincronizar projetos
        projects_sync = self.sync_existing_only()
        
        # Verificar se todos foram bem-sucedidos
        all_success = config_sync and main_sync and all(projects_sync.values())
        
        if all_success:
            logger.info("✅ Ambiente unificado sincronizado com sucesso")
        else:
            logger.error("❌ Falhas na sincronização do ambiente unificado")
        
        return all_success

    def _sync_project(self, project_path: Path, force: bool = False, 
                     auto_push: bool = False) -> bool:
        """Sincroniza um projeto específico."""
        if not self._is_git_repo(project_path):
            logger.error(f"❌ Não é um repositório Git: {project_path}")
            return False
        
        try:
            # Fetch latest changes
            subprocess.run(['git', 'fetch'], check=True, cwd=project_path)
            
            # Check for uncommitted changes
            result = subprocess.run(['git', 'status', '--porcelain'], 
                                  capture_output=True, text=True, cwd=project_path)
            
            has_changes = bool(result.stdout.strip())
            
            if has_changes:
                if auto_push:
                    # Auto-commit changes
                    subprocess.run(['git', 'add', '.'], check=True, cwd=project_path)
                    subprocess.run(['git', 'commit', '-m', self.sync_config["auto_commit_message"]], 
                                  check=True, cwd=project_path)
                else:
                    logger.warning(f"⚠️ Alterações não commitadas em: {project_path.name}")
            
            # Pull latest changes
            if force:
                subprocess.run(['git', 'reset', '--hard', 'HEAD'], check=True, cwd=project_path)
                subprocess.run(['git', 'pull', '--force'], check=True, cwd=project_path)
            else:
                subprocess.run(['git', 'pull'], check=True, cwd=project_path)
            
            # Push if auto_push is enabled and there are local commits
            if auto_push:
                subprocess.run(['git', 'push'], check=True, cwd=project_path)
            
            logger.info(f"✅ Projeto sincronizado: {project_path.name}")
            return True
            
        except subprocess.CalledProcessError as e:
            logger.error(f"❌ Erro na sincronização de {project_path.name}: {e}")
            return False

    def _push_project(self, project_path: Path) -> bool:
        """Executa push em um projeto específico."""
        try:
            # Check if there are commits to push
            result = subprocess.run(['git', 'log', '@{u}..HEAD', '--oneline'], 
                                  capture_output=True, text=True, cwd=project_path)
            
            if not result.stdout.strip():
                logger.info(f"📭 Nenhum commit para push em: {project_path.name}")
                return True
            
            # Push commits
            subprocess.run(['git', 'push'], check=True, cwd=project_path)
            logger.info(f"✅ Push concluído: {project_path.name}")
            return True
            
        except subprocess.CalledProcessError as e:
            logger.error(f"❌ Erro no push de {project_path.name}: {e}")
            return False

    def _is_git_repo(self, path: Path) -> bool:
        """Verifica se o diretório é um repositório Git."""
        git_dir = path / ".git"
        return git_dir.exists()

    def _create_backup(self) -> bool:
        """Cria backup antes de operações destrutivas."""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_dir = self.project_core / "backups" / f"sync_backup_{timestamp}"
        
        try:
            backup_dir.mkdir(parents=True, exist_ok=True)
            
            # Backup critical files
            critical_files = [
                "master_rule.md",
                "@project-core/memory/self_correction_log.md",
                "@project-core/memory/global-standards.md"
            ]
            
            for file_path in critical_files:
                source = self.project_root / file_path
                if source.exists():
                    dest = backup_dir / source.name
                    shutil.copy2(source, dest)
            
            logger.info(f"💾 Backup criado: {backup_dir}")
            return True
            
        except Exception as e:
            logger.error(f"❌ Erro ao criar backup: {e}")
            return False

    def _sync_configurations(self) -> bool:
        """Sincroniza configurações do ambiente."""
        logger.info("⚙️ Sincronizando configurações...")
        
        config_files = [
            ".vscode/settings.json",
            ".cursorrules",
            "@project-core/configs/mcp-servers.json"
        ]
        
        success_count = 0
        for config_file in config_files:
            config_path = self.project_root / config_file
            if config_path.exists():
                success_count += 1
                logger.info(f"✅ Configuração encontrada: {config_file}")
            else:
                logger.warning(f"⚠️ Configuração ausente: {config_file}")
        
        return success_count >= len(config_files) // 2  # Pelo menos metade deve existir

    def get_sync_status(self) -> Dict[str, Dict[str, str]]:
        """Obtém status de sincronização de todos os projetos."""
        logger.info("📊 Verificando status de sincronização...")
        
        status = {}
        
        for project in self.known_projects:
            project_path = self.project_root / project
            if project_path.exists() and self._is_git_repo(project_path):
                status[project] = self._get_project_status(project_path)
            else:
                status[project] = {"status": "not_found", "branch": "N/A", "commits": "N/A"}
        
        return status

    def _get_project_status(self, project_path: Path) -> Dict[str, str]:
        """Obtém status de um projeto específico."""
        try:
            # Get current branch
            branch_result = subprocess.run(['git', 'branch', '--show-current'], 
                                         capture_output=True, text=True, cwd=project_path)
            current_branch = branch_result.stdout.strip()
            
            # Get uncommitted changes
            status_result = subprocess.run(['git', 'status', '--porcelain'], 
                                         capture_output=True, text=True, cwd=project_path)
            has_changes = bool(status_result.stdout.strip())
            
            # Get commits ahead/behind
            ahead_result = subprocess.run(['git', 'log', '@{u}..HEAD', '--oneline'], 
                                        capture_output=True, text=True, cwd=project_path)
            commits_ahead = len(ahead_result.stdout.strip().split('\n')) if ahead_result.stdout.strip() else 0
            
            status_text = "clean"
            if has_changes:
                status_text = "modified"
            if commits_ahead > 0:
                status_text += f", {commits_ahead} ahead"
            
            return {
                "status": status_text,
                "branch": current_branch,
                "commits": str(commits_ahead)
            }
            
        except subprocess.CalledProcessError:
            return {"status": "error", "branch": "unknown", "commits": "unknown"}

def main():
    """Função principal do Sync Manager."""
    parser = argparse.ArgumentParser(description='VIBECODE Sync Manager V4.0')
    parser.add_argument('--target', choices=['all', 'specific', 'existing'], 
                       default='all', help='Alvo da sincronização')
    parser.add_argument('--force', action='store_true',
                       help='Forçar sincronização (sobrescrever alterações locais)')
    parser.add_argument('--auto-push', action='store_true',
                       help='Push automático após sincronização')
    parser.add_argument('--projects', nargs='+',
                       help='Lista de projetos específicos para sincronizar')
    parser.add_argument('--quick-push', action='store_true',
                       help='Executar push rápido do repositório atual')
    parser.add_argument('--final-push', action='store_true',
                       help='Executar push final em todos os projetos')
    parser.add_argument('--unified', action='store_true',
                       help='Sincronizar ambiente unificado')
    parser.add_argument('--status', action='store_true',
                       help='Mostrar status de sincronização')
    parser.add_argument('--message', type=str,
                       help='Mensagem de commit personalizada')
    parser.add_argument('--project-root', type=str,
                       help='Caminho raiz do projeto')

    args = parser.parse_args()

    # Inicializar manager
    manager = SyncManager(args.project_root)

    success = True

    # Executar ações solicitadas
    if args.status:
        status = manager.get_sync_status()
        print("\n📊 Status de Sincronização:")
        for project, info in status.items():
            print(f"  {project}: {info['status']} (branch: {info['branch']})")
        return 0

    if args.quick_push:
        success &= manager.quick_push(args.message)

    if args.final_push:
        results = manager.final_push(args.projects)
        success &= all(results.values())

    if args.unified:
        success &= manager.sync_unified_environment()

    if args.target == 'all':
        results = manager.sync_all(args.force, args.auto_push, args.projects)
        success &= all(results.values())
    elif args.target == 'existing':
        results = manager.sync_existing_only(args.auto_push)
        success &= all(results.values())
    elif args.target == 'specific' and args.projects:
        for project in args.projects:
            success &= manager.sync_specific(project, args.force, args.auto_push)

    # Se nenhuma ação especificada, mostrar help
    if not any([args.quick_push, args.final_push, args.unified, args.status,
               args.target != 'all' or args.projects]):
        parser.print_help()
        return 0

    return 0 if success else 1

if __name__ == "__main__":
    sys.exit(main())
