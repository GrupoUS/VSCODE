#!/usr/bin/env python3
"""
🛠️ COMMON UTILITIES - VIBECODE SYSTEM V4.0

Utilitários compartilhados para todos os scripts consolidados.

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import os
import json
import logging
import subprocess
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional, Any

def setup_logging(level: str = "INFO", log_file: Optional[str] = None) -> logging.Logger:
    """Configura logging padrão para scripts VIBECODE."""
    log_level = getattr(logging, level.upper(), logging.INFO)
    
    # Formato padrão
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    
    # Logger principal
    logger = logging.getLogger('vibecode')
    logger.setLevel(log_level)
    
    # Console handler
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)
    
    # File handler se especificado
    if log_file:
        file_handler = logging.FileHandler(log_file)
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)
    
    return logger

def load_config(config_path: str = None) -> Dict[str, Any]:
    """Carrega configuração dos scripts."""
    if not config_path:
        project_root = get_project_root()
        config_path = project_root / "@project-core/automation/config/script_config.json"
    
    try:
        with open(config_path, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        return get_default_config()
    except json.JSONDecodeError as e:
        raise ValueError(f"Erro ao carregar configuração: {e}")

def get_default_config() -> Dict[str, Any]:
    """Retorna configuração padrão."""
    return {
        "global_settings": {
            "project_root": ".",
            "project_core": "@project-core",
            "log_level": "INFO"
        },
        "critical_files": [
            "@project-core/memory/master_rule.md",
            "@project-core/memory/self_correction_log.md",
            "@project-core/memory/global-standards.md"
        ],
        "critical_directories": [
            "@project-core/memory",
            "@project-core/rules",
            "@project-core/automation",
            "@project-core/configs"
        ]
    }

def get_project_root() -> Path:
    """Detecta automaticamente a raiz do projeto."""
    current = Path.cwd()
    
    # Procurar por indicadores de raiz do projeto
    indicators = [".git", "@project-core", "master_rule.md"]
    
    while current != current.parent:
        for indicator in indicators:
            if (current / indicator).exists():
                return current
        current = current.parent
    
    # Se não encontrar, usar diretório atual
    return Path.cwd()

def verify_critical_files(project_root: Path = None) -> List[str]:
    """Verifica existência de arquivos críticos."""
    if not project_root:
        project_root = get_project_root()
    
    config = load_config()
    critical_files = config.get("critical_files", [])
    
    missing_files = []
    for file_path in critical_files:
        full_path = project_root / file_path
        if not full_path.exists():
            missing_files.append(file_path)
        elif full_path.stat().st_size == 0:
            missing_files.append(f"{file_path} (empty)")
    
    return missing_files

def verify_critical_directories(project_root: Path = None) -> List[str]:
    """Verifica existência de diretórios críticos."""
    if not project_root:
        project_root = get_project_root()
    
    config = load_config()
    critical_dirs = config.get("critical_directories", [])
    
    missing_dirs = []
    for dir_path in critical_dirs:
        full_path = project_root / dir_path
        if not full_path.exists():
            missing_dirs.append(dir_path)
    
    return missing_dirs

def run_command(command: List[str], cwd: Path = None, capture_output: bool = True) -> subprocess.CompletedProcess:
    """Executa comando com tratamento de erro padrão."""
    try:
        result = subprocess.run(
            command,
            cwd=cwd,
            capture_output=capture_output,
            text=True,
            check=True
        )
        return result
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"Comando falhou: {' '.join(command)}\nErro: {e.stderr}")

def is_git_repo(path: Path) -> bool:
    """Verifica se o diretório é um repositório Git."""
    return (path / ".git").exists()

def get_git_status(repo_path: Path) -> Dict[str, Any]:
    """Obtém status detalhado do repositório Git."""
    if not is_git_repo(repo_path):
        return {"is_git_repo": False}
    
    try:
        # Status de arquivos
        status_result = run_command(['git', 'status', '--porcelain'], cwd=repo_path)
        has_changes = bool(status_result.stdout.strip())
        
        # Branch atual
        branch_result = run_command(['git', 'branch', '--show-current'], cwd=repo_path)
        current_branch = branch_result.stdout.strip()
        
        # Commits não enviados
        try:
            ahead_result = run_command(['git', 'log', '@{u}..HEAD', '--oneline'], cwd=repo_path)
            commits_ahead = len(ahead_result.stdout.strip().split('\n')) if ahead_result.stdout.strip() else 0
        except:
            commits_ahead = 0
        
        return {
            "is_git_repo": True,
            "has_changes": has_changes,
            "current_branch": current_branch,
            "commits_ahead": commits_ahead,
            "status": "clean" if not has_changes and commits_ahead == 0 else "needs_attention"
        }
    
    except Exception as e:
        return {"is_git_repo": True, "error": str(e)}

def create_timestamped_backup(source_path: Path, backup_dir: Path, name_prefix: str = "backup") -> Path:
    """Cria backup com timestamp."""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_name = f"{name_prefix}_{timestamp}"
    backup_path = backup_dir / backup_name
    
    backup_dir.mkdir(parents=True, exist_ok=True)
    backup_path.mkdir(exist_ok=True)
    
    return backup_path

def get_directory_size(path: Path) -> int:
    """Calcula tamanho total de um diretório em bytes."""
    total_size = 0
    for item in path.rglob("*"):
        if item.is_file():
            try:
                total_size += item.stat().st_size
            except (OSError, FileNotFoundError):
                # Ignorar arquivos inacessíveis
                pass
    return total_size

def format_size(size_bytes: int) -> str:
    """Formata tamanho em bytes para formato legível."""
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if size_bytes < 1024.0:
            return f"{size_bytes:.1f} {unit}"
        size_bytes /= 1024.0
    return f"{size_bytes:.1f} PB"

def save_json_report(data: Dict[str, Any], output_path: Path, pretty: bool = True) -> bool:
    """Salva relatório em formato JSON."""
    try:
        output_path.parent.mkdir(parents=True, exist_ok=True)
        
        with open(output_path, 'w') as f:
            if pretty:
                json.dump(data, f, indent=2, default=str)
            else:
                json.dump(data, f, default=str)
        
        return True
    except Exception as e:
        logging.error(f"Erro ao salvar relatório: {e}")
        return False

def cleanup_old_files(directory: Path, pattern: str, days_old: int) -> int:
    """Remove arquivos antigos baseado em padrão e idade."""
    if not directory.exists():
        return 0
    
    cutoff_time = datetime.now().timestamp() - (days_old * 24 * 60 * 60)
    removed_count = 0
    
    for file_path in directory.glob(pattern):
        if file_path.is_file() and file_path.stat().st_mtime < cutoff_time:
            try:
                file_path.unlink()
                removed_count += 1
            except OSError:
                # Ignorar arquivos que não podem ser removidos
                pass
    
    return removed_count

def validate_json_file(file_path: Path) -> bool:
    """Valida se arquivo JSON é válido."""
    try:
        with open(file_path, 'r') as f:
            json.load(f)
        return True
    except (json.JSONDecodeError, FileNotFoundError):
        return False

def get_system_info() -> Dict[str, Any]:
    """Obtém informações básicas do sistema."""
    import platform
    import psutil
    
    return {
        "platform": platform.system(),
        "platform_version": platform.version(),
        "python_version": platform.python_version(),
        "cpu_count": psutil.cpu_count(),
        "memory_total_gb": round(psutil.virtual_memory().total / (1024**3), 2),
        "disk_total_gb": round(psutil.disk_usage('.').total / (1024**3), 2)
    }

def create_progress_indicator(total: int, current: int, width: int = 50) -> str:
    """Cria indicador de progresso visual."""
    if total == 0:
        return "[" + "=" * width + "] 100%"
    
    progress = current / total
    filled_width = int(width * progress)
    bar = "=" * filled_width + "-" * (width - filled_width)
    percentage = int(progress * 100)
    
    return f"[{bar}] {percentage}% ({current}/{total})"

# Constantes úteis
VIBECODE_VERSION = "4.0"
DEFAULT_ENCODING = "utf-8"
TIMESTAMP_FORMAT = "%Y-%m-%d %H:%M:%S"
DATE_FORMAT = "%Y-%m-%d"

# Emojis para logging consistente
EMOJIS = {
    "success": "✅",
    "error": "❌", 
    "warning": "⚠️",
    "info": "ℹ️",
    "processing": "🔄",
    "cleanup": "🧹",
    "backup": "💾",
    "sync": "🔄",
    "test": "🧪",
    "monitor": "📊",
    "setup": "⚙️"
}
