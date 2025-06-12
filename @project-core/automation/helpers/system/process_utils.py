#!/usr/bin/env python3
"""
🔧 PROCESS UTILITIES - VIBECODE SYSTEM V4.0

Módulo centralizado para execução de processos e comandos.
Extraído dos scripts consolidados para reutilização.

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import subprocess
import sys
import os
from pathlib import Path
from typing import Dict, List, Optional, Tuple, Union
import logging
from datetime import datetime


class ProcessResult:
    """Resultado de execução de processo."""
    
    def __init__(self, returncode: int, stdout: str, stderr: str, duration: float):
        self.returncode = returncode
        self.stdout = stdout
        self.stderr = stderr
        self.duration = duration
        self.success = returncode == 0
    
    def __str__(self):
        status = "✅ SUCCESS" if self.success else "❌ FAILED"
        return f"{status} (code: {self.returncode}, duration: {self.duration:.2f}s)"


def run_command(
    command: Union[str, List[str]],
    cwd: Optional[Union[str, Path]] = None,
    timeout: Optional[int] = None,
    capture_output: bool = True,
    shell: bool = False,
    env: Optional[Dict[str, str]] = None,
    input_text: Optional[str] = None,
    encoding: str = 'utf-8'
) -> ProcessResult:
    """
    Executa comando com configurações padronizadas.
    
    Args:
        command: Comando a ser executado
        cwd: Diretório de trabalho
        timeout: Timeout em segundos
        capture_output: Capturar stdout/stderr
        shell: Usar shell
        env: Variáveis de ambiente
        input_text: Texto de entrada
        encoding: Codificação de texto
    
    Returns:
        ProcessResult com resultado da execução
    """
    start_time = datetime.now()
    
    try:
        # Preparar comando
        if isinstance(command, str) and not shell:
            command = command.split()
        
        # Preparar ambiente
        process_env = os.environ.copy()
        if env:
            process_env.update(env)
        
        # Executar processo
        result = subprocess.run(
            command,
            cwd=str(cwd) if cwd else None,
            timeout=timeout,
            capture_output=capture_output,
            shell=shell,
            env=process_env,
            input=input_text,
            text=True,
            encoding=encoding
        )
        
        duration = (datetime.now() - start_time).total_seconds()
        
        return ProcessResult(
            returncode=result.returncode,
            stdout=result.stdout or "",
            stderr=result.stderr or "",
            duration=duration
        )
        
    except subprocess.TimeoutExpired:
        duration = (datetime.now() - start_time).total_seconds()
        return ProcessResult(
            returncode=-1,
            stdout="",
            stderr=f"Command timed out after {timeout}s",
            duration=duration
        )
    
    except Exception as e:
        duration = (datetime.now() - start_time).total_seconds()
        return ProcessResult(
            returncode=-2,
            stdout="",
            stderr=f"Error executing command: {e}",
            duration=duration
        )


def run_python_script(
    script_path: Union[str, Path],
    args: Optional[List[str]] = None,
    cwd: Optional[Union[str, Path]] = None,
    timeout: Optional[int] = None,
    use_venv: bool = True
) -> ProcessResult:
    """
    Executa script Python com configurações VIBECODE.
    
    Args:
        script_path: Caminho do script
        args: Argumentos do script
        cwd: Diretório de trabalho
        timeout: Timeout em segundos
        use_venv: Usar ambiente virtual se disponível
    
    Returns:
        ProcessResult com resultado da execução
    """
    # Determinar executável Python
    python_exe = sys.executable
    
    if use_venv:
        # Tentar usar Python do ambiente virtual
        venv_python = Path("@project-core/venv/Scripts/python.exe")
        if venv_python.exists():
            python_exe = str(venv_python)
    
    # Construir comando
    command = [python_exe, str(script_path)]
    if args:
        command.extend(args)
    
    return run_command(command, cwd=cwd, timeout=timeout)


def run_git_command(
    git_args: List[str],
    cwd: Optional[Union[str, Path]] = None,
    timeout: int = 30
) -> ProcessResult:
    """
    Executa comando Git com configurações padronizadas.
    
    Args:
        git_args: Argumentos do Git
        cwd: Diretório de trabalho
        timeout: Timeout em segundos
    
    Returns:
        ProcessResult com resultado da execução
    """
    command = ["git"] + git_args
    return run_command(command, cwd=cwd, timeout=timeout)


def check_git_status(cwd: Optional[Union[str, Path]] = None) -> Tuple[bool, List[str]]:
    """
    Verifica status do repositório Git.
    
    Args:
        cwd: Diretório de trabalho
    
    Returns:
        Tupla (is_clean, changed_files)
    """
    result = run_git_command(["status", "--porcelain"], cwd=cwd)
    
    if not result.success:
        return False, []
    
    changed_files = [line.strip() for line in result.stdout.splitlines() if line.strip()]
    is_clean = len(changed_files) == 0
    
    return is_clean, changed_files


def git_add_commit_push(
    files: Optional[List[str]] = None,
    commit_message: str = "Automated commit",
    cwd: Optional[Union[str, Path]] = None,
    push: bool = True
) -> ProcessResult:
    """
    Executa sequência Git: add, commit, push.
    
    Args:
        files: Arquivos específicos (None para todos)
        commit_message: Mensagem do commit
        cwd: Diretório de trabalho
        push: Fazer push após commit
    
    Returns:
        ProcessResult do último comando executado
    """
    # Add
    if files:
        add_result = run_git_command(["add"] + files, cwd=cwd)
    else:
        add_result = run_git_command(["add", "."], cwd=cwd)
    
    if not add_result.success:
        return add_result
    
    # Commit
    commit_result = run_git_command(["commit", "-m", commit_message], cwd=cwd)
    if not commit_result.success:
        return commit_result
    
    # Push (se solicitado)
    if push:
        push_result = run_git_command(["push"], cwd=cwd)
        return push_result
    
    return commit_result


def run_powershell_command(
    command: str,
    cwd: Optional[Union[str, Path]] = None,
    timeout: Optional[int] = None
) -> ProcessResult:
    """
    Executa comando PowerShell.
    
    Args:
        command: Comando PowerShell
        cwd: Diretório de trabalho
        timeout: Timeout em segundos
    
    Returns:
        ProcessResult com resultado da execução
    """
    ps_command = ["powershell", "-Command", command]
    return run_command(ps_command, cwd=cwd, timeout=timeout, shell=False)


def run_batch_command(
    command: str,
    cwd: Optional[Union[str, Path]] = None,
    timeout: Optional[int] = None
) -> ProcessResult:
    """
    Executa comando Batch/CMD.
    
    Args:
        command: Comando Batch
        cwd: Diretório de trabalho
        timeout: Timeout em segundos
    
    Returns:
        ProcessResult com resultado da execução
    """
    return run_command(command, cwd=cwd, timeout=timeout, shell=True)


def check_command_available(command: str) -> bool:
    """
    Verifica se comando está disponível no sistema.
    
    Args:
        command: Nome do comando
    
    Returns:
        True se disponível
    """
    try:
        result = run_command([command, "--version"], timeout=5)
        return result.success
    except:
        try:
            result = run_command(["which", command], timeout=5)
            return result.success
        except:
            return False


def get_system_info() -> Dict[str, str]:
    """
    Obtém informações do sistema.
    
    Returns:
        Dicionário com informações do sistema
    """
    import platform
    
    info = {
        "system": platform.system(),
        "release": platform.release(),
        "version": platform.version(),
        "machine": platform.machine(),
        "processor": platform.processor(),
        "python_version": platform.python_version(),
        "python_executable": sys.executable
    }
    
    # Verificar comandos disponíveis
    commands = ["git", "python", "pip", "powershell", "cmd"]
    for cmd in commands:
        info[f"{cmd}_available"] = str(check_command_available(cmd))
    
    return info


def run_with_retry(
    func,
    max_retries: int = 3,
    delay: float = 1.0,
    backoff: float = 2.0,
    exceptions: Tuple = (Exception,)
) -> any:
    """
    Executa função com retry automático.
    
    Args:
        func: Função a ser executada
        max_retries: Número máximo de tentativas
        delay: Delay inicial entre tentativas
        backoff: Multiplicador do delay
        exceptions: Exceções que acionam retry
    
    Returns:
        Resultado da função
    """
    import time
    
    last_exception = None
    current_delay = delay
    
    for attempt in range(max_retries + 1):
        try:
            return func()
        except exceptions as e:
            last_exception = e
            if attempt < max_retries:
                time.sleep(current_delay)
                current_delay *= backoff
            else:
                raise last_exception


class ProcessMonitor:
    """Monitor de processos em execução."""
    
    def __init__(self):
        self.processes = {}
    
    def start_background_process(
        self,
        name: str,
        command: Union[str, List[str]],
        cwd: Optional[Union[str, Path]] = None
    ) -> subprocess.Popen:
        """
        Inicia processo em background.
        
        Args:
            name: Nome do processo
            command: Comando a ser executado
            cwd: Diretório de trabalho
        
        Returns:
            Objeto Popen do processo
        """
        if isinstance(command, str):
            command = command.split()
        
        process = subprocess.Popen(
            command,
            cwd=str(cwd) if cwd else None,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        
        self.processes[name] = process
        return process
    
    def stop_process(self, name: str, timeout: int = 10) -> bool:
        """
        Para processo por nome.
        
        Args:
            name: Nome do processo
            timeout: Timeout para terminar
        
        Returns:
            True se parado com sucesso
        """
        if name not in self.processes:
            return False
        
        process = self.processes[name]
        
        try:
            process.terminate()
            process.wait(timeout=timeout)
            del self.processes[name]
            return True
        except subprocess.TimeoutExpired:
            process.kill()
            del self.processes[name]
            return True
        except:
            return False
    
    def get_process_status(self, name: str) -> Optional[str]:
        """
        Obtém status do processo.
        
        Args:
            name: Nome do processo
        
        Returns:
            Status do processo ou None
        """
        if name not in self.processes:
            return None
        
        process = self.processes[name]
        
        if process.poll() is None:
            return "running"
        else:
            return f"finished (code: {process.returncode})"


# Instância global para conveniência
process_monitor = ProcessMonitor()


# Exemplo de uso:
if __name__ == "__main__":
    # Teste do módulo
    print("🧪 Testando process utils...")
    
    # Teste comando simples
    result = run_command(["python", "--version"])
    print(f"✅ Python version: {result}")
    
    # Teste Git
    git_result = run_git_command(["status", "--porcelain"])
    print(f"✅ Git status: {git_result}")
    
    # Teste informações do sistema
    info = get_system_info()
    print(f"✅ Sistema: {info['system']} {info['release']}")
    
    print("✅ Process utils testado com sucesso!")
