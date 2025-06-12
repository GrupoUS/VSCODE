#!/usr/bin/env python3
"""
🐍 VIRTUAL ENVIRONMENT ACTIVATOR - VIBECODE SYSTEM V4.0

Script para ativar automaticamente o ambiente virtual do projeto.
Resolve problemas de dependências e conflitos de pacotes.

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import os
import sys
import subprocess
from pathlib import Path
import logging

# Configuração de logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def get_project_root():
    """Detecta a raiz do projeto."""
    current = Path(__file__).parent
    while current != current.parent:
        if (current / "@project-core").exists():
            return current
        current = current.parent
    return Path.cwd()

def check_virtual_environment():
    """Verifica se o ambiente virtual existe e está configurado."""
    project_root = get_project_root()
    venv_path = project_root / "@project-core" / "venv"

    if not venv_path.exists():
        logger.error("❌ Ambiente virtual não encontrado")
        return False, venv_path

    python_exe = venv_path / "Scripts" / "python.exe"
    if not python_exe.exists():
        logger.error("❌ Executável Python não encontrado no ambiente virtual")
        return False, venv_path

    logger.info("✅ Ambiente virtual encontrado")
    return True, venv_path

def create_virtual_environment():
    """Cria o ambiente virtual se não existir."""
    project_root = get_project_root()
    venv_path = project_root / "@project-core" / "venv"

    logger.info("🔧 Criando ambiente virtual...")

    try:
        subprocess.run([sys.executable, "-m", "venv", str(venv_path)], check=True)
        logger.info("✅ Ambiente virtual criado com sucesso")
        return True, venv_path
    except subprocess.CalledProcessError as e:
        logger.error(f"❌ Erro ao criar ambiente virtual: {e}")
        return False, venv_path

def install_dependencies(venv_path):
    """Instala dependências no ambiente virtual."""
    project_root = get_project_root()
    requirements_file = project_root / "@project-core" / "requirements.txt"

    if not requirements_file.exists():
        logger.warning("⚠️ Arquivo requirements.txt não encontrado")
        return True

    python_exe = venv_path / "Scripts" / "python.exe"
    pip_exe = venv_path / "Scripts" / "pip.exe"

    logger.info("📦 Instalando dependências...")

    try:
        # Atualizar pip primeiro
        subprocess.run([str(python_exe), "-m", "pip", "install", "--upgrade", "pip"], check=True)

        # Instalar dependências
        subprocess.run([str(pip_exe), "install", "-r", str(requirements_file)], check=True)

        logger.info("✅ Dependências instaladas com sucesso")
        return True
    except subprocess.CalledProcessError as e:
        logger.error(f"❌ Erro ao instalar dependências: {e}")
        return False

def activate_environment():
    """Ativa o ambiente virtual."""
    exists, venv_path = check_virtual_environment()

    if not exists:
        logger.info("🔧 Ambiente virtual não existe, criando...")
        created, venv_path = create_virtual_environment()
        if not created:
            return False

        # Instalar dependências
        if not install_dependencies(venv_path):
            return False

    # Configurar variáveis de ambiente
    python_exe = venv_path / "Scripts" / "python.exe"
    scripts_dir = venv_path / "Scripts"

    # Atualizar PATH
    current_path = os.environ.get("PATH", "")
    if str(scripts_dir) not in current_path:
        os.environ["PATH"] = f"{scripts_dir}{os.pathsep}{current_path}"

    # Configurar VIRTUAL_ENV
    os.environ["VIRTUAL_ENV"] = str(venv_path)

    # Remover PYTHONHOME se existir
    if "PYTHONHOME" in os.environ:
        del os.environ["PYTHONHOME"]

    logger.info(f"✅ Ambiente virtual ativado: {venv_path}")
    logger.info(f"🐍 Python: {python_exe}")

    return True

def verify_installation():
    """Verifica se a instalação está funcionando."""
    try:
        import psutil
        import requests
        import yaml
        logger.info("✅ Dependências principais verificadas")
        return True
    except ImportError as e:
        logger.error(f"❌ Dependência ausente: {e}")
        return False

def generate_activation_script():
    """Gera script de ativação para uso manual."""
    project_root = get_project_root()
    venv_path = project_root / "@project-core" / "venv"

    # Script PowerShell
    ps_script = project_root / "@project-core" / "activate_venv.ps1"
    ps_content = f"""# VIBECODE SYSTEM V4.0 - Virtual Environment Activator
# Gerado automaticamente

$VenvPath = "{venv_path}"
$ActivateScript = "$VenvPath\\Scripts\\Activate.ps1"

if (Test-Path $ActivateScript) {{
    Write-Host "🐍 Ativando ambiente virtual VIBECODE..." -ForegroundColor Green
    & $ActivateScript
    Write-Host "✅ Ambiente virtual ativado!" -ForegroundColor Green
}} else {{
    Write-Host "❌ Ambiente virtual não encontrado em: $VenvPath" -ForegroundColor Red
    Write-Host "Execute: python @project-core/automation/tasks/activate_venv.py" -ForegroundColor Yellow
}}
"""

    with open(ps_script, 'w', encoding='utf-8') as f:
        f.write(ps_content)

    # Script Batch
    bat_script = project_root / "@project-core" / "activate_venv.bat"
    bat_content = f"""@echo off
REM VIBECODE SYSTEM V4.0 - Virtual Environment Activator
REM Gerado automaticamente

set VENV_PATH={venv_path}
set ACTIVATE_SCRIPT=%VENV_PATH%\\Scripts\\activate.bat

if exist "%ACTIVATE_SCRIPT%" (
    echo [PYTHON] Ativando ambiente virtual VIBECODE...
    call "%ACTIVATE_SCRIPT%"
    echo [SUCCESS] Ambiente virtual ativado!
) else (
    echo [ERROR] Ambiente virtual nao encontrado em: %VENV_PATH%
    echo Execute: python @project-core/automation/tasks/activate_venv.py
)
"""

    with open(bat_script, 'w', encoding='utf-8') as f:
        f.write(bat_content)

    logger.info("✅ Scripts de ativação gerados")
    logger.info(f"  PowerShell: {ps_script}")
    logger.info(f"  Batch: {bat_script}")

def main():
    """Função principal."""
    logger.info("🚀 VIBECODE Virtual Environment Activator V4.0")

    # Ativar ambiente virtual
    if not activate_environment():
        logger.error("❌ Falha ao ativar ambiente virtual")
        return 1

    # Verificar instalação
    if not verify_installation():
        logger.error("❌ Falha na verificação de dependências")
        return 1

    # Gerar scripts de ativação
    generate_activation_script()

    logger.info("🎯 Ambiente virtual configurado com sucesso!")
    logger.info("💡 Para ativar manualmente:")
    logger.info("   PowerShell: .\\@project-core\\activate_venv.ps1")
    logger.info("   Batch: .\\@project-core\\activate_venv.bat")
    logger.info("   Python: python @project-core/automation/tasks/activate_venv.py")

    return 0

if __name__ == "__main__":
    sys.exit(main())
