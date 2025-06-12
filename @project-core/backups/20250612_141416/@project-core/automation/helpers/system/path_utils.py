#!/usr/bin/env python3
"""
🔧 PATH UTILITIES - VIBECODE SYSTEM V4.0

Módulo centralizado para operações de Path e filesystem.
Extraído dos scripts consolidados para reutilização.

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import os
import shutil
from pathlib import Path
from typing import List, Dict, Optional, Tuple, Union
from datetime import datetime
import fnmatch


class VibeCodePaths:
    """
    Gerenciador centralizado de caminhos do projeto VIBECODE.
    """
    
    def __init__(self, project_root: Optional[Union[str, Path]] = None):
        self.project_root = Path(project_root) if project_root else self._detect_project_root()
        self.project_core = self.project_root / "@project-core"
        
        # Caminhos principais
        self.memory_path = self.project_core / "memory"
        self.rules_path = self.project_core / "rules"
        self.automation_path = self.project_core / "automation"
        self.configs_path = self.project_core / "configs"
        self.reports_path = self.project_core / "reports"
        self.logs_path = self.project_core / "logs"
        self.backups_path = self.project_core / "backups"
        self.venv_path = self.project_core / "venv"
        
        # Criar diretórios se não existirem
        self._ensure_directories()
    
    def _detect_project_root(self) -> Path:
        """Detecta automaticamente a raiz do projeto."""
        current = Path.cwd()
        while current != current.parent:
            if (current / "@project-core").exists():
                return current
            current = current.parent
        return Path.cwd()
    
    def _ensure_directories(self):
        """Garante que diretórios essenciais existam."""
        essential_dirs = [
            self.reports_path,
            self.logs_path,
            self.backups_path
        ]
        
        for directory in essential_dirs:
            directory.mkdir(parents=True, exist_ok=True)
    
    def get_critical_files(self) -> List[Path]:
        """Retorna lista de arquivos críticos do sistema."""
        return [
            self.memory_path / "master_rule.md",
            self.memory_path / "self_correction_log.md",
            self.memory_path / "global-standards.md",
            self.rules_path / "00-vibecode-system-v4-master.md"
        ]
    
    def get_critical_directories(self) -> List[Path]:
        """Retorna lista de diretórios críticos do sistema."""
        return [
            self.memory_path,
            self.rules_path,
            self.automation_path,
            self.configs_path
        ]


def safe_path_operation(func):
    """Decorator para operações seguras de path."""
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except (OSError, PermissionError, FileNotFoundError) as e:
            print(f"❌ Erro na operação de path: {e}")
            return None
    return wrapper


@safe_path_operation
def ensure_directory(path: Union[str, Path], parents: bool = True) -> bool:
    """
    Garante que um diretório existe.
    
    Args:
        path: Caminho do diretório
        parents: Criar diretórios pais se necessário
    
    Returns:
        True se bem-sucedido
    """
    Path(path).mkdir(parents=parents, exist_ok=True)
    return True


@safe_path_operation
def safe_copy(src: Union[str, Path], dst: Union[str, Path], preserve_metadata: bool = True) -> bool:
    """
    Copia arquivo ou diretório com segurança.
    
    Args:
        src: Origem
        dst: Destino
        preserve_metadata: Preservar metadados
    
    Returns:
        True se bem-sucedido
    """
    src_path = Path(src)
    dst_path = Path(dst)
    
    # Garantir que diretório de destino existe
    dst_path.parent.mkdir(parents=True, exist_ok=True)
    
    if src_path.is_file():
        if preserve_metadata:
            shutil.copy2(src_path, dst_path)
        else:
            shutil.copy(src_path, dst_path)
    elif src_path.is_dir():
        shutil.copytree(src_path, dst_path, dirs_exist_ok=True)
    
    return True


@safe_path_operation
def safe_move(src: Union[str, Path], dst: Union[str, Path]) -> bool:
    """
    Move arquivo ou diretório com segurança.
    
    Args:
        src: Origem
        dst: Destino
    
    Returns:
        True se bem-sucedido
    """
    src_path = Path(src)
    dst_path = Path(dst)
    
    # Garantir que diretório de destino existe
    dst_path.parent.mkdir(parents=True, exist_ok=True)
    
    shutil.move(str(src_path), str(dst_path))
    return True


@safe_path_operation
def safe_delete(path: Union[str, Path], recursive: bool = False) -> bool:
    """
    Remove arquivo ou diretório com segurança.
    
    Args:
        path: Caminho a ser removido
        recursive: Remover recursivamente
    
    Returns:
        True se bem-sucedido
    """
    path_obj = Path(path)
    
    if not path_obj.exists():
        return True
    
    if path_obj.is_file():
        path_obj.unlink()
    elif path_obj.is_dir() and recursive:
        shutil.rmtree(path_obj)
    elif path_obj.is_dir():
        path_obj.rmdir()  # Só remove se vazio
    
    return True


def get_directory_size(path: Union[str, Path]) -> Tuple[int, int]:
    """
    Calcula tamanho de diretório.
    
    Args:
        path: Caminho do diretório
    
    Returns:
        Tupla (tamanho_bytes, número_arquivos)
    """
    total_size = 0
    file_count = 0
    
    for dirpath, dirnames, filenames in os.walk(path):
        for filename in filenames:
            filepath = os.path.join(dirpath, filename)
            try:
                total_size += os.path.getsize(filepath)
                file_count += 1
            except (OSError, FileNotFoundError):
                pass
    
    return total_size, file_count


def find_files_by_pattern(directory: Union[str, Path], pattern: str, recursive: bool = True) -> List[Path]:
    """
    Encontra arquivos por padrão.
    
    Args:
        directory: Diretório de busca
        pattern: Padrão de busca (ex: "*.py", "test_*")
        recursive: Busca recursiva
    
    Returns:
        Lista de arquivos encontrados
    """
    directory = Path(directory)
    
    if recursive:
        return list(directory.rglob(pattern))
    else:
        return list(directory.glob(pattern))


def find_files_by_age(directory: Union[str, Path], days_old: int, older: bool = True) -> List[Path]:
    """
    Encontra arquivos por idade.
    
    Args:
        directory: Diretório de busca
        days_old: Idade em dias
        older: True para arquivos mais antigos, False para mais novos
    
    Returns:
        Lista de arquivos encontrados
    """
    directory = Path(directory)
    cutoff_time = datetime.now().timestamp() - (days_old * 24 * 60 * 60)
    found_files = []
    
    for file_path in directory.rglob("*"):
        if file_path.is_file():
            file_time = file_path.stat().st_mtime
            if (older and file_time < cutoff_time) or (not older and file_time > cutoff_time):
                found_files.append(file_path)
    
    return found_files


def filter_files_by_size(files: List[Path], min_size: int = 0, max_size: Optional[int] = None) -> List[Path]:
    """
    Filtra arquivos por tamanho.
    
    Args:
        files: Lista de arquivos
        min_size: Tamanho mínimo em bytes
        max_size: Tamanho máximo em bytes (None = sem limite)
    
    Returns:
        Lista de arquivos filtrados
    """
    filtered = []
    
    for file_path in files:
        if file_path.is_file():
            size = file_path.stat().st_size
            if size >= min_size and (max_size is None or size <= max_size):
                filtered.append(file_path)
    
    return filtered


def exclude_patterns(files: List[Path], exclude_patterns: List[str]) -> List[Path]:
    """
    Exclui arquivos baseado em padrões.
    
    Args:
        files: Lista de arquivos
        exclude_patterns: Padrões de exclusão
    
    Returns:
        Lista de arquivos filtrados
    """
    filtered = []
    
    for file_path in files:
        excluded = False
        for pattern in exclude_patterns:
            if fnmatch.fnmatch(file_path.name, pattern) or fnmatch.fnmatch(str(file_path), pattern):
                excluded = True
                break
        
        if not excluded:
            filtered.append(file_path)
    
    return filtered


def create_timestamped_backup_name(base_name: str, extension: str = "") -> str:
    """
    Cria nome de backup com timestamp.
    
    Args:
        base_name: Nome base
        extension: Extensão do arquivo
    
    Returns:
        Nome com timestamp
    """
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    if extension and not extension.startswith('.'):
        extension = f".{extension}"
    
    return f"{base_name}_{timestamp}{extension}"


def get_relative_path(path: Union[str, Path], base: Union[str, Path]) -> str:
    """
    Obtém caminho relativo.
    
    Args:
        path: Caminho absoluto
        base: Caminho base
    
    Returns:
        Caminho relativo
    """
    try:
        return str(Path(path).relative_to(Path(base)))
    except ValueError:
        return str(path)


# Instância global para conveniência
vibecode_paths = VibeCodePaths()


# Exemplo de uso:
if __name__ == "__main__":
    # Teste do módulo
    paths = VibeCodePaths()
    
    print(f"✅ Projeto root: {paths.project_root}")
    print(f"✅ Project core: {paths.project_core}")
    print(f"✅ Arquivos críticos: {len(paths.get_critical_files())}")
    print(f"✅ Diretórios críticos: {len(paths.get_critical_directories())}")
    
    # Teste de operações
    test_dir = paths.reports_path / "test"
    ensure_directory(test_dir)
    print(f"✅ Diretório teste criado: {test_dir}")
    
    print("✅ Path utils testado com sucesso!")
