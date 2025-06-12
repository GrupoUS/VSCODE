#!/usr/bin/env python3
"""
🔧 BACKUP UTILITIES - VIBECODE SYSTEM V4.0

Módulo centralizado para operações de backup e arquivamento.
Extraído dos scripts consolidados para reutilização.

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import shutil
import zipfile
import tarfile
from pathlib import Path
from datetime import datetime, timedelta
from typing import List, Dict, Optional, Union, Tuple
import fnmatch
import json


class BackupManager:
    """Gerenciador centralizado de backups VIBECODE."""
    
    def __init__(self, backup_dir: Union[str, Path] = "@project-core/backups"):
        self.backup_dir = Path(backup_dir)
        self.backup_dir.mkdir(parents=True, exist_ok=True)
        
        # Configurações padrão
        self.config = {
            "max_backups": 10,
            "compression": "zip",  # zip, tar, tar.gz
            "exclude_patterns": [
                "*.tmp", "*.log", "__pycache__", ".git",
                "node_modules", "venv", ".env"
            ],
            "size_limit_mb": 500
        }
    
    def create_backup(
        self,
        source: Union[str, Path],
        backup_name: Optional[str] = None,
        compression: Optional[str] = None,
        exclude_patterns: Optional[List[str]] = None
    ) -> Optional[Path]:
        """
        Cria backup de arquivo ou diretório.
        
        Args:
            source: Origem do backup
            backup_name: Nome do backup (auto-gerado se None)
            compression: Tipo de compressão
            exclude_patterns: Padrões de exclusão
        
        Returns:
            Caminho do backup criado ou None se falhar
        """
        source_path = Path(source)
        if not source_path.exists():
            return None
        
        # Gerar nome do backup
        if backup_name is None:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            backup_name = f"{source_path.name}_backup_{timestamp}"
        
        # Determinar tipo de compressão
        compression = compression or self.config["compression"]
        
        # Determinar padrões de exclusão
        exclude_patterns = exclude_patterns or self.config["exclude_patterns"]
        
        try:
            if compression == "zip":
                return self._create_zip_backup(source_path, backup_name, exclude_patterns)
            elif compression == "tar":
                return self._create_tar_backup(source_path, backup_name, exclude_patterns, False)
            elif compression == "tar.gz":
                return self._create_tar_backup(source_path, backup_name, exclude_patterns, True)
            else:
                # Backup sem compressão
                return self._create_copy_backup(source_path, backup_name, exclude_patterns)
        
        except Exception as e:
            print(f"❌ Erro ao criar backup: {e}")
            return None
    
    def _create_zip_backup(self, source: Path, backup_name: str, exclude_patterns: List[str]) -> Path:
        """Cria backup ZIP."""
        backup_file = self.backup_dir / f"{backup_name}.zip"
        
        with zipfile.ZipFile(backup_file, 'w', zipfile.ZIP_DEFLATED) as zipf:
            if source.is_file():
                zipf.write(source, source.name)
            else:
                for file_path in source.rglob("*"):
                    if file_path.is_file() and not self._should_exclude(file_path, exclude_patterns):
                        arcname = file_path.relative_to(source)
                        zipf.write(file_path, arcname)
        
        return backup_file
    
    def _create_tar_backup(self, source: Path, backup_name: str, exclude_patterns: List[str], compress: bool) -> Path:
        """Cria backup TAR."""
        extension = ".tar.gz" if compress else ".tar"
        backup_file = self.backup_dir / f"{backup_name}{extension}"
        mode = "w:gz" if compress else "w"
        
        with tarfile.open(backup_file, mode) as tar:
            if source.is_file():
                tar.add(source, arcname=source.name)
            else:
                for file_path in source.rglob("*"):
                    if file_path.is_file() and not self._should_exclude(file_path, exclude_patterns):
                        arcname = file_path.relative_to(source)
                        tar.add(file_path, arcname=str(arcname))
        
        return backup_file
    
    def _create_copy_backup(self, source: Path, backup_name: str, exclude_patterns: List[str]) -> Path:
        """Cria backup por cópia."""
        backup_path = self.backup_dir / backup_name
        
        if source.is_file():
            shutil.copy2(source, backup_path)
        else:
            shutil.copytree(
                source, backup_path,
                ignore=lambda dir, files: [f for f in files if self._should_exclude(Path(dir) / f, exclude_patterns)]
            )
        
        return backup_path
    
    def _should_exclude(self, file_path: Path, exclude_patterns: List[str]) -> bool:
        """Verifica se arquivo deve ser excluído."""
        for pattern in exclude_patterns:
            if fnmatch.fnmatch(file_path.name, pattern) or fnmatch.fnmatch(str(file_path), pattern):
                return True
        return False
    
    def list_backups(self, pattern: str = "*") -> List[Dict]:
        """
        Lista backups disponíveis.
        
        Args:
            pattern: Padrão de busca
        
        Returns:
            Lista de informações de backup
        """
        backups = []
        
        for backup_file in self.backup_dir.glob(pattern):
            if backup_file.is_file():
                stat = backup_file.stat()
                backups.append({
                    "name": backup_file.name,
                    "path": str(backup_file),
                    "size_mb": stat.st_size / (1024 * 1024),
                    "created": datetime.fromtimestamp(stat.st_ctime),
                    "modified": datetime.fromtimestamp(stat.st_mtime),
                    "type": self._get_backup_type(backup_file)
                })
        
        # Ordenar por data de criação (mais recente primeiro)
        backups.sort(key=lambda x: x["created"], reverse=True)
        return backups
    
    def _get_backup_type(self, backup_file: Path) -> str:
        """Determina tipo do backup."""
        if backup_file.suffix == ".zip":
            return "zip"
        elif backup_file.suffix == ".gz":
            return "tar.gz"
        elif backup_file.suffix == ".tar":
            return "tar"
        else:
            return "copy"
    
    def restore_backup(self, backup_name: str, restore_path: Union[str, Path]) -> bool:
        """
        Restaura backup.
        
        Args:
            backup_name: Nome do backup
            restore_path: Caminho de restauração
        
        Returns:
            True se bem-sucedido
        """
        backup_file = self.backup_dir / backup_name
        if not backup_file.exists():
            return False
        
        restore_path = Path(restore_path)
        restore_path.parent.mkdir(parents=True, exist_ok=True)
        
        try:
            if backup_file.suffix == ".zip":
                return self._restore_zip_backup(backup_file, restore_path)
            elif backup_file.suffix in [".tar", ".gz"]:
                return self._restore_tar_backup(backup_file, restore_path)
            else:
                # Backup de cópia
                if backup_file.is_file():
                    shutil.copy2(backup_file, restore_path)
                else:
                    shutil.copytree(backup_file, restore_path, dirs_exist_ok=True)
                return True
        
        except Exception as e:
            print(f"❌ Erro ao restaurar backup: {e}")
            return False
    
    def _restore_zip_backup(self, backup_file: Path, restore_path: Path) -> bool:
        """Restaura backup ZIP."""
        with zipfile.ZipFile(backup_file, 'r') as zipf:
            zipf.extractall(restore_path)
        return True
    
    def _restore_tar_backup(self, backup_file: Path, restore_path: Path) -> bool:
        """Restaura backup TAR."""
        mode = "r:gz" if backup_file.suffix == ".gz" else "r"
        with tarfile.open(backup_file, mode) as tar:
            tar.extractall(restore_path)
        return True
    
    def cleanup_old_backups(self, max_age_days: int = 30, max_count: Optional[int] = None) -> List[str]:
        """
        Remove backups antigos.
        
        Args:
            max_age_days: Idade máxima em dias
            max_count: Número máximo de backups (None = usar config)
        
        Returns:
            Lista de backups removidos
        """
        max_count = max_count or self.config["max_backups"]
        cutoff_date = datetime.now() - timedelta(days=max_age_days)
        
        backups = self.list_backups()
        removed = []
        
        # Remover por idade
        for backup in backups:
            if backup["created"] < cutoff_date:
                backup_path = Path(backup["path"])
                try:
                    if backup_path.is_file():
                        backup_path.unlink()
                    else:
                        shutil.rmtree(backup_path)
                    removed.append(backup["name"])
                except Exception as e:
                    print(f"⚠️ Erro ao remover backup {backup['name']}: {e}")
        
        # Remover por quantidade (manter apenas os mais recentes)
        remaining_backups = [b for b in backups if b["name"] not in removed]
        if len(remaining_backups) > max_count:
            excess_backups = remaining_backups[max_count:]
            for backup in excess_backups:
                backup_path = Path(backup["path"])
                try:
                    if backup_path.is_file():
                        backup_path.unlink()
                    else:
                        shutil.rmtree(backup_path)
                    removed.append(backup["name"])
                except Exception as e:
                    print(f"⚠️ Erro ao remover backup {backup['name']}: {e}")
        
        return removed
    
    def get_backup_stats(self) -> Dict:
        """
        Obtém estatísticas dos backups.
        
        Returns:
            Estatísticas dos backups
        """
        backups = self.list_backups()
        
        if not backups:
            return {
                "total_backups": 0,
                "total_size_mb": 0,
                "oldest_backup": None,
                "newest_backup": None,
                "average_size_mb": 0
            }
        
        total_size = sum(b["size_mb"] for b in backups)
        
        return {
            "total_backups": len(backups),
            "total_size_mb": round(total_size, 2),
            "oldest_backup": min(backups, key=lambda x: x["created"])["name"],
            "newest_backup": max(backups, key=lambda x: x["created"])["name"],
            "average_size_mb": round(total_size / len(backups), 2)
        }


# Instância global para conveniência
backup_manager = BackupManager()


# Exemplo de uso:
if __name__ == "__main__":
    # Teste do módulo
    manager = BackupManager()
    
    # Criar backup de teste
    test_file = Path("test_backup.txt")
    test_file.write_text("Conteúdo de teste para backup")
    
    backup_path = manager.create_backup(test_file, "test_backup")
    if backup_path:
        print(f"✅ Backup criado: {backup_path}")
        
        # Listar backups
        backups = manager.list_backups()
        print(f"✅ Backups encontrados: {len(backups)}")
        
        # Estatísticas
        stats = manager.get_backup_stats()
        print(f"✅ Estatísticas: {stats}")
        
        # Limpeza
        test_file.unlink(missing_ok=True)
        backup_path.unlink(missing_ok=True)
    
    print("✅ Backup utils testado com sucesso!")
