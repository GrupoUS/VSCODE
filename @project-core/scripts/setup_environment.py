#!/usr/bin/env python3
"""
🚀 GRUPO US VIBECODE SYSTEM V4.0 - Python Environment Setup Script

Este script automatiza a configuração do ambiente de desenvolvimento Python
para garantir consistência entre todos os desenvolvedores.

Autor: GRUPO US VIBECODE SYSTEM
Versão: 1.0.0
Data: 2025-01-27
"""

import os
import sys
import subprocess
import venv
from pathlib import Path


class PythonEnvironmentSetup:
    """Classe para configuração automatizada do ambiente Python"""

    def __init__(self):
        # Detectar se estamos executando de dentro de @project-core ou não
        current_dir = Path.cwd()
        if current_dir.name == "@project-core":
            self.project_root = current_dir
        else:
            self.project_root = current_dir / "@project-core"

        self.venv_path = self.project_root / ".venv"
        self.requirements_file = self.project_root / "requirements.txt"
        self.env_example_file = self.project_root / ".env.example"

    def print_header(self):
        """Exibe cabeçalho do script"""
        print("=" * 80)
        print("🚀 GRUPO US VIBECODE SYSTEM V4.0")
        print("   Python Environment Setup Script")
        print("=" * 80)
        print()

    def check_existing_venv(self):
        """Verifica se ambiente virtual já existe"""
        if self.venv_path.exists():
            print("⚠️  AVISO: Ambiente virtual já existe!")
            print(f"   Localização: {self.venv_path}")
            print()
            print("✅ O ambiente virtual já está configurado.")
            print("   Se precisar recriar, remova a pasta .venv manualmente e execute novamente.")
            return True
        return False

    def create_virtual_environment(self):
        """Cria novo ambiente virtual"""
        print("📦 Criando ambiente virtual...")
        print(f"   Localização: {self.venv_path}")

        try:
            venv.create(self.venv_path, with_pip=True)
            print("✅ Ambiente virtual criado com sucesso!")
            return True
        except Exception as e:
            print(f"❌ Erro ao criar ambiente virtual: {e}")
            return False

    def get_pip_executable(self):
        """Retorna o caminho do executável pip no ambiente virtual"""
        if sys.platform == "win32":
            return self.venv_path / "Scripts" / "pip.exe"
        else:
            return self.venv_path / "bin" / "pip"

    def get_python_executable(self):
        """Retorna o caminho do executável Python no ambiente virtual"""
        if sys.platform == "win32":
            return self.venv_path / "Scripts" / "python.exe"
        else:
            return self.venv_path / "bin" / "python"

    def install_dependencies(self):
        """Instala dependências do requirements.txt"""
        if not self.requirements_file.exists():
            print("⚠️  Arquivo requirements.txt não encontrado!")
            print(f"   Esperado em: {self.requirements_file}")
            return False

        print("📥 Instalando dependências...")
        print(f"   Arquivo: {self.requirements_file}")

        pip_executable = self.get_pip_executable()

        try:
            result = subprocess.run([
                str(pip_executable),
                "install",
                "-r",
                str(self.requirements_file)
            ], check=True, capture_output=True, text=True)

            print("✅ Dependências instaladas com sucesso!")
            return True

        except subprocess.CalledProcessError as e:
            print(f"❌ Erro ao instalar dependências: {e}")
            print(f"   Output: {e.stdout}")
            print(f"   Error: {e.stderr}")
            return False

    def create_env_example(self):
        """Cria arquivo .env.example"""
        env_content = """# Variáveis de Ambiente - GRUPO US VIBECODE SYSTEM V4.0
# Copie este arquivo para .env e preencha com seus valores

# Database Configuration
DATABASE_URL="sua_string_de_conexao_aqui"

# API Keys
API_KEY="sua_api_key_aqui"
OPENAI_API_KEY="sua_openai_api_key_aqui"
ANTHROPIC_API_KEY="sua_anthropic_api_key_aqui"

# Security
SECRET_KEY="sua_secret_key_aqui"
JWT_SECRET="seu_jwt_secret_aqui"

# Environment
ENVIRONMENT="development"
DEBUG="true"

# External Services
GITHUB_TOKEN="seu_github_token_aqui"
SUPABASE_URL="sua_supabase_url_aqui"
SUPABASE_ANON_KEY="sua_supabase_anon_key_aqui"

# Application Settings
APP_NAME="GRUPO US VIBECODE SYSTEM"
APP_VERSION="4.0.0"
"""

        try:
            with open(self.env_example_file, 'w', encoding='utf-8') as f:
                f.write(env_content)
            print(f"✅ Arquivo .env.example criado: {self.env_example_file}")
            return True
        except Exception as e:
            print(f"❌ Erro ao criar .env.example: {e}")
            return False

    def print_activation_instructions(self):
        """Exibe instruções de ativação do ambiente"""
        print()
        print("🎯 PRÓXIMOS PASSOS:")
        print("=" * 50)
        print()

        # Instruções específicas do sistema operacional
        if sys.platform == "win32":
            activation_cmd = f"{self.venv_path}\\Scripts\\activate"
            python_cmd = f"{self.venv_path}\\Scripts\\python.exe"
        else:
            activation_cmd = f"source {self.venv_path}/bin/activate"
            python_cmd = f"{self.venv_path}/bin/python"

        print("1. 📋 Configure as variáveis de ambiente:")
        print(f"   cp {self.env_example_file} {self.project_root}/.env")
        print("   # Edite o arquivo .env com seus valores reais")
        print()

        print("2. 🔄 Ative o ambiente virtual:")
        print(f"   {activation_cmd}")
        print()

        print("3. 🐍 Use Python do ambiente virtual:")
        print(f"   {python_cmd} seu_script.py")
        print()

        print("4. 📦 Para instalar novas dependências:")
        print(f"   {self.get_pip_executable()} install nome_do_pacote")
        print()

        print("✅ AMBIENTE PYTHON CONFIGURADO COM SUCESSO!")
        print("   Ambiente virtual: .venv/")
        print("   Dependências: Instaladas")
        print("   Arquivo exemplo: .env.example")
        print()

    def run_setup(self):
        """Executa o setup completo do ambiente"""
        self.print_header()

        # Verificar se ambiente já existe
        if self.check_existing_venv():
            return True

        # Criar ambiente virtual
        if not self.create_virtual_environment():
            return False

        # Instalar dependências
        if not self.install_dependencies():
            print("⚠️  Ambiente criado, mas falha na instalação de dependências")

        # Criar arquivo .env.example
        self.create_env_example()

        # Exibir instruções
        self.print_activation_instructions()

        return True


def main():
    """Função principal"""
    setup = PythonEnvironmentSetup()

    try:
        success = setup.run_setup()
        sys.exit(0 if success else 1)

    except KeyboardInterrupt:
        print("\n⚠️  Setup cancelado pelo usuário.")
        sys.exit(1)

    except Exception as e:
        print(f"\n❌ Erro inesperado: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
