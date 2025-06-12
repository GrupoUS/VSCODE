#!/usr/bin/env python3
"""
🔧 LOGGER UTILITIES - VIBECODE SYSTEM V4.0

Módulo centralizado para configuração de logging padronizada.
Extraído dos scripts consolidados para reutilização.

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import logging
import sys
from pathlib import Path
from typing import Optional
from datetime import datetime


def setup_logging(
    name: str,
    level: str = "INFO",
    log_file: Optional[str] = None,
    console: bool = True,
    format_style: str = "standard"
) -> logging.Logger:
    """
    Configura logging padronizado para scripts VIBECODE.
    
    Args:
        name: Nome do logger (geralmente __name__)
        level: Nível de logging (DEBUG, INFO, WARNING, ERROR)
        log_file: Arquivo de log opcional
        console: Se deve exibir no console
        format_style: Estilo do formato (standard, detailed, minimal)
    
    Returns:
        Logger configurado
    """
    logger = logging.getLogger(name)
    
    # Limpar handlers existentes
    for handler in logger.handlers[:]:
        logger.removeHandler(handler)
    
    # Configurar nível
    logger.setLevel(getattr(logging, level.upper()))
    
    # Definir formatos
    formats = {
        "standard": "%(asctime)s - %(levelname)s - %(message)s",
        "detailed": "%(asctime)s - %(name)s - %(levelname)s - %(funcName)s:%(lineno)d - %(message)s",
        "minimal": "%(levelname)s - %(message)s"
    }
    
    formatter = logging.Formatter(formats.get(format_style, formats["standard"]))
    
    # Handler para console
    if console:
        console_handler = logging.StreamHandler(sys.stdout)
        console_handler.setFormatter(formatter)
        logger.addHandler(console_handler)
    
    # Handler para arquivo
    if log_file:
        log_path = Path(log_file)
        log_path.parent.mkdir(parents=True, exist_ok=True)
        
        file_handler = logging.FileHandler(log_path, encoding='utf-8')
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)
    
    return logger


def get_default_log_file(script_name: str) -> str:
    """
    Gera caminho padrão para arquivo de log.
    
    Args:
        script_name: Nome do script
    
    Returns:
        Caminho do arquivo de log
    """
    timestamp = datetime.now().strftime("%Y%m%d")
    log_name = f"{script_name}_{timestamp}.log"
    return str(Path("@project-core/logs") / log_name)


def log_execution_start(logger: logging.Logger, script_name: str, args: dict = None):
    """
    Log padronizado de início de execução.
    
    Args:
        logger: Logger configurado
        script_name: Nome do script
        args: Argumentos do script
    """
    logger.info(f"🚀 Iniciando {script_name}...")
    if args:
        logger.info(f"📋 Argumentos: {args}")


def log_execution_end(logger: logging.Logger, script_name: str, success: bool = True, duration: float = None):
    """
    Log padronizado de fim de execução.
    
    Args:
        logger: Logger configurado
        script_name: Nome do script
        success: Se a execução foi bem-sucedida
        duration: Duração da execução em segundos
    """
    status = "✅ Concluído" if success else "❌ Falhou"
    message = f"{status}: {script_name}"
    
    if duration is not None:
        message += f" (duração: {duration:.2f}s)"
    
    if success:
        logger.info(message)
    else:
        logger.error(message)


def log_step(logger: logging.Logger, step_name: str, status: str = "start"):
    """
    Log padronizado de etapas de execução.
    
    Args:
        logger: Logger configurado
        step_name: Nome da etapa
        status: Status (start, success, error, warning)
    """
    icons = {
        "start": "🔄",
        "success": "✅",
        "error": "❌",
        "warning": "⚠️",
        "info": "ℹ️"
    }
    
    icon = icons.get(status, "📋")
    message = f"{icon} {step_name}"
    
    if status == "start":
        logger.info(message)
    elif status == "success":
        logger.info(message)
    elif status == "error":
        logger.error(message)
    elif status == "warning":
        logger.warning(message)
    else:
        logger.info(message)


class ProgressLogger:
    """
    Logger para progresso de operações longas.
    """
    
    def __init__(self, logger: logging.Logger, total_items: int, operation_name: str):
        self.logger = logger
        self.total_items = total_items
        self.operation_name = operation_name
        self.current_item = 0
        self.start_time = datetime.now()
    
    def update(self, increment: int = 1, item_name: str = None):
        """
        Atualiza o progresso.
        
        Args:
            increment: Incremento no progresso
            item_name: Nome do item atual
        """
        self.current_item += increment
        percentage = (self.current_item / self.total_items) * 100
        
        message = f"📊 {self.operation_name}: {self.current_item}/{self.total_items} ({percentage:.1f}%)"
        if item_name:
            message += f" - {item_name}"
        
        self.logger.info(message)
    
    def finish(self):
        """
        Finaliza o progresso.
        """
        duration = (datetime.now() - self.start_time).total_seconds()
        self.logger.info(f"✅ {self.operation_name} concluído em {duration:.2f}s")


# Configurações padrão para scripts VIBECODE
VIBECODE_LOG_CONFIG = {
    "level": "INFO",
    "format_style": "standard",
    "console": True
}


def get_vibecode_logger(script_name: str, **kwargs) -> logging.Logger:
    """
    Cria logger com configurações padrão VIBECODE.
    
    Args:
        script_name: Nome do script
        **kwargs: Configurações adicionais
    
    Returns:
        Logger configurado
    """
    config = VIBECODE_LOG_CONFIG.copy()
    config.update(kwargs)
    
    # Gerar arquivo de log automático se não especificado
    if "log_file" not in config:
        config["log_file"] = get_default_log_file(script_name)
    
    return setup_logging(script_name, **config)


# Exemplo de uso:
if __name__ == "__main__":
    # Teste do módulo
    logger = get_vibecode_logger("test_logger")
    
    log_execution_start(logger, "test_script", {"arg1": "value1"})
    log_step(logger, "Iniciando teste", "start")
    log_step(logger, "Teste bem-sucedido", "success")
    log_execution_end(logger, "test_script", True, 1.5)
    
    print("✅ Logger utils testado com sucesso!")
