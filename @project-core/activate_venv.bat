@echo off
REM VIBECODE SYSTEM V4.0 - Virtual Environment Activator
REM Gerado automaticamente

set VENV_PATH=C:\Users\Admin\OneDrive\GRUPOUS\VSCODE\@project-core\venv
set ACTIVATE_SCRIPT=%VENV_PATH%\Scripts\activate.bat

if exist "%ACTIVATE_SCRIPT%" (
    echo [PYTHON] Ativando ambiente virtual VIBECODE...
    call "%ACTIVATE_SCRIPT%"
    echo [SUCCESS] Ambiente virtual ativado!
) else (
    echo [ERROR] Ambiente virtual nao encontrado em: %VENV_PATH%
    echo Execute: python @project-core/automation/tasks/activate_venv.py
)
