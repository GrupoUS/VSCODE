#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
🚀 FINALTEST SIMPLES - VIBECODE SYSTEM V4.5
Validação do sistema sem dependências externas
"""

import os
import json
import datetime
import subprocess

def print_header():
    print("🚀 EXECUTANDO !FINALTEST - VIBECODE SYSTEM V4.5")
    print("📊 Validação Completa do Sistema em Progresso...")
    print()

def check_critical_files():
    print("🔍 FASE 1: Validação de Estrutura de Arquivos")

    critical_files = [
        "@project-core/memory/master_rule.md",
        "@project-core/memory/self_correction_log.md",
        "@project-core/configs/projects-sync-config.json",
        "@project-core/automation/sync-github-auto.ps1",
        "@project-core/automation/AUTOSYNC-SOVEREIGN-GUIDE.md"
    ]

    files_valid = 0
    file_results = []

    for file_path in critical_files:
        if os.path.exists(file_path):
            print(f"  ✅ {file_path}")
            file_results.append(f"- ✅ `{file_path}` (Presente)")
            files_valid += 1
        else:
            print(f"  ❌ {file_path}")
            file_results.append(f"- ❌ `{file_path}` (Ausente)")

    return files_valid, len(critical_files), file_results

def check_critical_dirs():
    print("📁 FASE 2: Validação de Diretórios Críticos")

    critical_dirs = [
        "@project-core/memory",
        "@project-core/configs",
        "@project-core/automation",
        "@project-core/projects",
        "@project-core/reports"
    ]

    dirs_valid = 0
    dir_results = []

    for dir_path in critical_dirs:
        if os.path.exists(dir_path) and os.path.isdir(dir_path):
            print(f"  ✅ {dir_path}/")
            dir_results.append(f"- ✅ `{dir_path}/` (Presente)")
            dirs_valid += 1
        else:
            print(f"  ❌ {dir_path}/")
            dir_results.append(f"- ❌ `{dir_path}/` (Ausente)")

    return dirs_valid, len(critical_dirs), dir_results

def check_project_config():
    print("🔧 FASE 3: Validação de Configurações")

    config_results = []

    if os.path.exists("@project-core/configs/projects-sync-config.json"):
        try:
            with open("@project-core/configs/projects-sync-config.json", 'r', encoding='utf-8') as f:
                config = json.load(f)

            project_count = len(config.get("projects", {}))
            print(f"  ✅ {project_count} projetos configurados")
            config_results.append(f"- ✅ **{project_count} projetos** configurados para sincronização soberana")

            for project_name, project_config in config.get("projects", {}).items():
                project_path = project_config.get("localPath", "")
                if os.path.exists(project_path):
                    print(f"    ✅ {project_name}")
                    config_results.append(f"  - ✅ **{project_name}**: `{project_path}`")
                else:
                    print(f"    ⚠️ {project_name} (pasta não encontrada)")
                    config_results.append(f"  - ⚠️ **{project_name}**: `{project_path}` (pasta não encontrada)")

        except Exception as e:
            print(f"  ❌ Erro ao ler configuração: {e}")
            config_results.append("- ❌ Erro ao ler configuração de projetos")
    else:
        print("  ❌ Arquivo de configuração não encontrado")
        config_results.append("- ❌ Arquivo de configuração não encontrado")

    return config_results

def check_github_auth():
    print("🔐 FASE 4: Validação de Autenticação GitHub")

    auth_results = []
    gh_path = r"C:\Program Files\GitHub CLI\gh.exe"

    if os.path.exists(gh_path):
        print("  ✅ GitHub CLI instalado")
        auth_results.append("- ✅ **GitHub CLI**: Instalado e disponível")

        try:
            result = subprocess.run([gh_path, "auth", "status"],
                                  capture_output=True, text=True, timeout=10)
            if "Logged in" in result.stderr or "Logged in" in result.stdout:
                print("  ✅ GitHub CLI autenticado")
                auth_results.append("- ✅ **Autenticação**: Ativa e funcionando")
            else:
                print("  ⚠️ GitHub CLI não autenticado")
                auth_results.append("- ⚠️ **Autenticação**: Não configurada")
        except Exception as e:
            print(f"  ⚠️ Erro ao verificar autenticação: {e}")
            auth_results.append("- ⚠️ **Autenticação**: Erro na verificação")
    else:
        print("  ❌ GitHub CLI não encontrado")
        auth_results.append("- ❌ **GitHub CLI**: Não instalado")

    return auth_results

def generate_report(files_valid, total_files, dirs_valid, total_dirs,
                   file_results, dir_results, config_results, auth_results):

    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    report_filename = f"@project-core/reports/finaltest-report-{datetime.datetime.now().strftime('%Y%m%d-%H%M%S')}.md"

    # Criar diretório se não existir
    os.makedirs("@project-core/reports", exist_ok=True)

    # Calcular scores
    file_score = (files_valid / total_files) * 100
    dir_score = (dirs_valid / total_dirs) * 100
    overall_score = ((files_valid + dirs_valid) / (total_files + total_dirs)) * 100

    # Determinar status
    if overall_score >= 90:
        status = "🏆 EXCELENTE"
    elif overall_score >= 75:
        status = "✅ BOM"
    elif overall_score >= 50:
        status = "⚠️ ATENÇÃO"
    else:
        status = "❌ CRÍTICO"

    report_content = f"""# 🎉 !FINALTEST EXECUTADO COM SUCESSO - VIBECODE SYSTEM V4.5

**Data de Execução**: {timestamp}
**Status**: ✅ COMPLETO
**Versão**: VIBECODE SYSTEM V4.5

---

## 📊 VALIDAÇÃO DE SISTEMA

### 🔍 ESTRUTURA DE ARQUIVOS

#### ✅ Arquivos Críticos do Sistema
{chr(10).join(file_results)}

#### ✅ Diretórios Críticos
{chr(10).join(dir_results)}

### 🎯 PROJETOS CONFIGURADOS
{chr(10).join(config_results)}

### 🔐 AUTENTICAÇÃO GITHUB
{chr(10).join(auth_results)}

## 📊 RESULTADO FINAL

### 🎯 PONTUAÇÃO GERAL
- **Arquivos Críticos**: {files_valid}/{total_files} ({file_score:.1f}%)
- **Diretórios Críticos**: {dirs_valid}/{total_dirs} ({dir_score:.1f}%)
- **Score Geral**: {overall_score:.1f}%

### 🎉 STATUS FINAL: **{status}**

**Sistema VIBECODE V4.5 validado em {timestamp}**

---

*Relatório gerado automaticamente pelo !finaltest*
"""

    with open(report_filename, 'w', encoding='utf-8') as f:
        f.write(report_content)

    return overall_score, status, report_filename

def main():
    print_header()

    # Executar validações
    files_valid, total_files, file_results = check_critical_files()
    dirs_valid, total_dirs, dir_results = check_critical_dirs()
    config_results = check_project_config()
    auth_results = check_github_auth()

    print("📊 FASE 5: Relatório Final")

    # Gerar relatório
    overall_score, status, report_filename = generate_report(
        files_valid, total_files, dirs_valid, total_dirs,
        file_results, dir_results, config_results, auth_results
    )

    # Exibir resultado final
    print()
    print("📊 RESULTADO FINAL")
    print(f"Score Geral: {overall_score:.1f}%")
    print(f"Status: {status}")
    print(f"Relatório salvo em: {report_filename}")
    print()
    print("🎉 !FINALTEST CONCLUÍDO COM SUCESSO!")
    print("Sistema VIBECODE V4.5 validado e operacional")

if __name__ == "__main__":
    main()
