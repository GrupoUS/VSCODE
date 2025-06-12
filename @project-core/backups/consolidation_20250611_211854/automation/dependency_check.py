#!/usr/bin/env python3
"""
===============================================================================
DEPENDENCY CHECK SCRIPT - GRUPO US VIBECODE SYSTEM V4.0
===============================================================================
Verifica vulnerabilidades e atualizações de dependências
Author: Augment Agent - Security & Maintenance System (Python Migration)
Date: 2025-01-27
===============================================================================
"""

import argparse
import json
import subprocess
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from loguru import logger
from rich.console import Console
from rich.table import Table

# Initialize rich console
console = Console()


def log_status(message: str, status_type: str = "info") -> None:
    """Log status message with appropriate color."""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    if status_type == "success":
        console.print(f"[{timestamp}] {message}", style="green")
        logger.success(message)
    elif status_type == "warning":
        console.print(f"[{timestamp}] {message}", style="yellow")
        logger.warning(message)
    elif status_type == "error":
        console.print(f"[{timestamp}] {message}", style="red")
        logger.error(message)
    else:
        console.print(f"[{timestamp}] {message}", style="cyan")
        logger.info(message)


def test_package_managers() -> Dict[str, bool]:
    """Test available package managers."""
    log_status("Verificando gerenciadores de pacotes...", "info")

    managers = {
        "npm": False,
        "yarn": False,
        "pnpm": False
    }

    # Check npm
    try:
        result = subprocess.run(["npm", "--version"],
                              capture_output=True, text=True, check=False)
        if result.returncode == 0:
            managers["npm"] = True
            log_status(f"  ✅ npm: {result.stdout.strip()}", "success")
    except FileNotFoundError:
        log_status("  ❌ npm não encontrado", "warning")

    # Check yarn
    try:
        result = subprocess.run(["yarn", "--version"],
                              capture_output=True, text=True, check=False)
        if result.returncode == 0:
            managers["yarn"] = True
            log_status(f"  ✅ yarn: {result.stdout.strip()}", "success")
    except FileNotFoundError:
        log_status("  ❌ yarn não encontrado", "warning")

    # Check pnpm
    try:
        result = subprocess.run(["pnpm", "--version"],
                              capture_output=True, text=True, check=False)
        if result.returncode == 0:
            managers["pnpm"] = True
            log_status(f"  ✅ pnpm: {result.stdout.strip()}", "success")
    except FileNotFoundError:
        log_status("  ❌ pnpm não encontrado", "warning")

    return managers


def test_security_vulnerabilities(package_managers: Dict[str, bool]) -> Dict[str, int]:
    """Test for security vulnerabilities."""
    log_status("=== VERIFICANDO VULNERABILIDADES DE SEGURANÇA ===", "info")

    vulnerabilities = {
        "found": 0,
        "critical": 0,
        "high": 0,
        "moderate": 0,
        "low": 0
    }

    if package_managers["npm"] and Path("package.json").exists():
        log_status("Executando npm audit...", "info")

        try:
            result = subprocess.run(["npm", "audit", "--json"],
                                  capture_output=True, text=True, check=False)

            if result.returncode != 0 and result.stdout:
                # npm audit returns non-zero when vulnerabilities are found
                audit_data = json.loads(result.stdout)

                if "metadata" in audit_data and "vulnerabilities" in audit_data["metadata"]:
                    vuln_data = audit_data["metadata"]["vulnerabilities"]
                    vulnerabilities["found"] = vuln_data.get("total", 0)
                    vulnerabilities["critical"] = vuln_data.get("critical", 0)
                    vulnerabilities["high"] = vuln_data.get("high", 0)
                    vulnerabilities["moderate"] = vuln_data.get("moderate", 0)
                    vulnerabilities["low"] = vuln_data.get("low", 0)

                    log_status("Vulnerabilidades encontradas:", "warning")
                    log_status(f"  🔴 Critical: {vulnerabilities['critical']}", "error")
                    log_status(f"  🟠 High: {vulnerabilities['high']}", "warning")
                    log_status(f"  🟡 Moderate: {vulnerabilities['moderate']}", "warning")
                    log_status(f"  🟢 Low: {vulnerabilities['low']}", "info")
            else:
                log_status("✅ Nenhuma vulnerabilidade encontrada", "success")

        except (subprocess.SubprocessError, json.JSONDecodeError) as e:
            log_status(f"Erro ao executar npm audit: {e}", "error")

    return vulnerabilities


def test_outdated_packages(package_managers: Dict[str, bool]) -> List[Dict[str, str]]:
    """Test for outdated packages."""
    log_status("=== VERIFICANDO PACOTES DESATUALIZADOS ===", "info")

    outdated_packages = []

    if package_managers["npm"] and Path("package.json").exists():
        log_status("Verificando pacotes npm desatualizados...", "info")

        try:
            result = subprocess.run(["npm", "outdated", "--json"],
                                  capture_output=True, text=True, check=False)

            if result.stdout:
                outdated_data = json.loads(result.stdout)

                for package_name, package_info in outdated_data.items():
                    outdated_packages.append({
                        "name": package_name,
                        "current": package_info.get("current", "unknown"),
                        "wanted": package_info.get("wanted", "unknown"),
                        "latest": package_info.get("latest", "unknown"),
                        "type": package_info.get("type", "dependency")
                    })

                log_status(f"Pacotes desatualizados encontrados: {len(outdated_packages)}", "warning")
                for pkg in outdated_packages:
                    log_status(f"  📦 {pkg['name']}: {pkg['current']} → {pkg['latest']}", "info")
            else:
                log_status("✅ Todos os pacotes estão atualizados", "success")

        except (subprocess.SubprocessError, json.JSONDecodeError) as e:
            log_status(f"Erro ao verificar pacotes desatualizados: {e}", "error")

    return outdated_packages


def repair_security_vulnerabilities(package_managers: Dict[str, bool],
                                   vulnerabilities: Dict[str, int]) -> bool:
    """Repair security vulnerabilities."""
    if vulnerabilities["found"] == 0:
        log_status("Nenhuma vulnerabilidade para corrigir", "info")
        return True

    log_status("=== CORRIGINDO VULNERABILIDADES ===", "info")

    if package_managers["npm"]:
        try:
            log_status("Executando npm audit fix...", "info")
            result = subprocess.run(["npm", "audit", "fix"],
                                  capture_output=True, text=True, check=False)

            if result.returncode == 0:
                log_status("✅ Vulnerabilidades corrigidas com sucesso", "success")
                return True
            else:
                log_status("⚠️ Algumas vulnerabilidades podem precisar de correção manual", "warning")
                log_status("Tente: npm audit fix --force (cuidado!)", "info")
                return False

        except subprocess.SubprocessError as e:
            log_status(f"Erro ao corrigir vulnerabilidades: {e}", "error")
            return False

    return False


def update_dependencies(package_managers: Dict[str, bool],
                       outdated_packages: List[Dict[str, str]],
                       security_only: bool) -> bool:
    """Update dependencies."""
    if not outdated_packages:
        log_status("Nenhum pacote para atualizar", "info")
        return True

    log_status("=== ATUALIZANDO DEPENDÊNCIAS ===", "info")

    if security_only:
        log_status("Modo somente segurança - atualizando apenas correções críticas", "warning")

    if package_managers["npm"]:
        try:
            if security_only:
                log_status("Atualizando patches de segurança...", "info")
                result = subprocess.run(["npm", "update", "--save"],
                                      capture_output=True, text=True, check=False)
            else:
                log_status("Atualizando todos os pacotes...", "info")
                result = subprocess.run(["npm", "update"],
                                      capture_output=True, text=True, check=False)

            if result.returncode == 0:
                log_status("✅ Dependências atualizadas com sucesso", "success")
                return True
            else:
                log_status("❌ Erro ao atualizar dependências", "error")
                if result.stderr:
                    console.print(result.stderr, style="red")
                return False

        except subprocess.SubprocessError as e:
            log_status(f"Erro ao atualizar dependências: {e}", "error")
            return False

    return False


def generate_dependency_report(vulnerabilities: Dict[str, int],
                             outdated_packages: List[Dict[str, str]]) -> Optional[str]:
    """Generate dependency report."""
    log_status("Gerando relatório de dependências...", "info")

    try:
        reports_dir = Path("reports")
        reports_dir.mkdir(exist_ok=True)

        timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        report_path = reports_dir / f"dependency-check-{timestamp}.md"

        package_details = ""
        if outdated_packages:
            package_details = "\n".join([
                f"- **{pkg['name']}**: {pkg['current']} → {pkg['latest']}"
                for pkg in outdated_packages
            ])
        else:
            package_details = "- All packages are up to date"

        security_recommendation = (
            "Run 'npm audit fix' to resolve vulnerabilities"
            if vulnerabilities["found"] > 0
            else "No security issues found"
        )

        update_recommendation = (
            "Consider updating outdated packages"
            if outdated_packages
            else "All packages are current"
        )

        report_content = f"""# Dependency Check Report
**Generated**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## Security Vulnerabilities
- **Total**: {vulnerabilities['found']}
- **Critical**: {vulnerabilities['critical']}
- **High**: {vulnerabilities['high']}
- **Moderate**: {vulnerabilities['moderate']}
- **Low**: {vulnerabilities['low']}

## Outdated Packages
- **Total Outdated**: {len(outdated_packages)}

### Package Details
{package_details}

## Recommendations
1. **Security**: {security_recommendation}
2. **Updates**: {update_recommendation}
3. **Monitoring**: Set up automated dependency checking in CI/CD
4. **Review**: Regular security audits (weekly recommended)

---
*Generated by Dependency Check System - GRUPO US VIBECODE SYSTEM V4.0*
"""

        report_path.write_text(report_content, encoding='utf-8')
        log_status(f"Relatório gerado: {report_path}", "success")

        return str(report_path)

    except Exception as e:
        log_status(f"Erro ao gerar relatório: {e}", "error")
        return None


def main() -> int:
    """Main execution function."""
    parser = argparse.ArgumentParser(
        description="Dependency check script for GRUPO US VIBECODE SYSTEM V4.0"
    )
    parser.add_argument("--fix", action="store_true",
                       help="Corrige automaticamente vulnerabilidades de segurança")
    parser.add_argument("--update-all", action="store_true",
                       help="Atualiza todos os pacotes desatualizados")
    parser.add_argument("--security-only", action="store_true",
                       help="Atualiza apenas correções de segurança (usado com --update-all)")

    args = parser.parse_args()

    # Setup logging
    logger.remove()
    logger.add(sys.stderr, level="INFO")

    try:
        log_status("🔍 DEPENDENCY CHECK - GRUPO US VIBECODE SYSTEM V4.0", "info")
        log_status("================================================================", "info")

        # Step 1: Check package managers
        package_managers = test_package_managers()

        if not any(package_managers.values()):
            log_status("❌ Nenhum gerenciador de pacotes encontrado", "error")
            return 1

        # Step 2: Check for vulnerabilities
        vulnerabilities = test_security_vulnerabilities(package_managers)

        # Step 3: Check for outdated packages
        outdated_packages = test_outdated_packages(package_managers)

        # Step 4: Fix vulnerabilities if requested
        if args.fix and vulnerabilities["found"] > 0:
            repair_security_vulnerabilities(package_managers, vulnerabilities)

        # Step 5: Update dependencies if requested
        if args.update_all and outdated_packages:
            update_dependencies(package_managers, outdated_packages, args.security_only)

        # Step 6: Generate report
        generate_dependency_report(vulnerabilities, outdated_packages)

        # Final assessment
        critical_issues = vulnerabilities["critical"] + vulnerabilities["high"]

        log_status("================================================================", "info")

        if critical_issues == 0 and not outdated_packages:
            log_status("🎉 DEPENDENCY CHECK PASSED!", "success")
            log_status("Todas as dependências estão seguras e atualizadas", "success")
            return 0
        elif critical_issues == 0:
            log_status("⚠️ DEPENDENCY CHECK - MINOR ISSUES", "warning")
            log_status(f"{len(outdated_packages)} pacotes desatualizados encontrados", "warning")
            return 0
        else:
            log_status("❌ DEPENDENCY CHECK - CRITICAL ISSUES", "error")
            log_status(f"{critical_issues} vulnerabilidades críticas/altas encontradas", "error")
            return 1

    except Exception as e:
        log_status(f"Dependency check failed: {e}", "error")
        logger.exception("Detailed error information:")
        return 1


if __name__ == "__main__":
    sys.exit(main())
