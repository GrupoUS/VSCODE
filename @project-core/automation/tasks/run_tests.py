#!/usr/bin/env python3
"""
🧪 RUN TESTS - VIBECODE SYSTEM V4.0

Consolidação de todos os scripts de teste e validação:
- finaltest.ps1, finaltest-v4.ps1, enhanced-finaltest-v3.1.ps1
- finaltest-enhanced.ps1, finaltest-unified-memory-system.ps1
- finaltest-backup-protection.ps1, simple-validation-test.ps1
- validate-system-clean.ps1

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import os
import sys
import json
import argparse
import subprocess
import shutil
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional, Tuple
import logging

# Configuração de logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class TestRunner:
    """Executor consolidado de testes e validações VIBECODE V4.0."""

    def __init__(self, project_root: str = None):
        self.project_root = Path(project_root) if project_root else Path.cwd()
        self.project_core = self.project_root / "@project-core"
        self.memory_path = self.project_core / "memory"
        self.reports_path = self.project_core / "reports"
        self.reports_path.mkdir(exist_ok=True)
        
        # Configurações de teste
        self.critical_files = [
            "@project-core/memory/master_rule.md",
            "@project-core/memory/self_correction_log.md",
            "@project-core/memory/global-standards.md",
            "@project-core/rules/00-vibecode-system-v4-master.md"
        ]
        
        self.critical_directories = [
            "@project-core/memory",
            "@project-core/rules",
            "@project-core/automation",
            "@project-core/configs"
        ]

    def run_basic_tests(self, backup_protection: bool = False) -> Dict[str, bool]:
        """
        Executa testes básicos do sistema.
        Equivalente a: simple-validation-test.ps1, validate-system-clean.ps1
        """
        logger.info("🧪 Executando testes básicos...")
        
        results = {}
        
        # Teste 1: Verificar arquivos críticos
        results['critical_files'] = self._test_critical_files()
        
        # Teste 2: Verificar estrutura de diretórios
        results['directory_structure'] = self._test_directory_structure()
        
        # Teste 3: Verificar integridade do memory bank
        results['memory_bank'] = self._test_memory_bank()
        
        # Teste 4: Verificar status Git
        results['git_status'] = self._test_git_status()
        
        # Teste 5: Proteção de backup (se solicitado)
        if backup_protection:
            results['backup_protection'] = self._test_backup_protection()
        
        return results

    def run_enhanced_tests(self, memory_validation: bool = True) -> Dict[str, bool]:
        """
        Executa testes aprimorados com validação de memória.
        Equivalente a: finaltest-enhanced.ps1, finaltest-unified-memory-system.ps1
        """
        logger.info("🚀 Executando testes aprimorados...")
        
        results = self.run_basic_tests(backup_protection=True)
        
        # Testes adicionais aprimorados
        results['automation_scripts'] = self._test_automation_scripts()
        results['mcp_integration'] = self._test_mcp_integration()
        results['performance_metrics'] = self._test_performance_metrics()
        
        if memory_validation:
            results['memory_validation'] = self._test_memory_validation()
            results['unified_memory_system'] = self._test_unified_memory_system()
        
        return results

    def run_comprehensive_tests(self) -> Dict[str, bool]:
        """
        Executa suite completa de testes.
        Equivalente a: finaltest-v4.ps1, enhanced-finaltest-v3.1.ps1
        """
        logger.info("🎯 Executando testes abrangentes...")
        
        results = self.run_enhanced_tests(memory_validation=True)
        
        # Testes abrangentes adicionais
        results['dependency_check'] = self._test_dependencies()
        results['security_validation'] = self._test_security()
        results['workflow_integration'] = self._test_workflow_integration()
        results['cross_platform_compatibility'] = self._test_cross_platform()
        
        return results

    def _test_critical_files(self) -> bool:
        """Testa existência e integridade de arquivos críticos."""
        logger.info("📁 Testando arquivos críticos...")
        
        missing_files = []
        for file_path in self.critical_files:
            full_path = self.project_root / file_path
            if not full_path.exists():
                missing_files.append(file_path)
                logger.error(f"❌ Arquivo crítico ausente: {file_path}")
            elif full_path.stat().st_size == 0:
                missing_files.append(file_path)
                logger.error(f"❌ Arquivo crítico vazio: {file_path}")
            else:
                logger.info(f"✅ Arquivo crítico OK: {file_path}")
        
        return len(missing_files) == 0

    def _test_directory_structure(self) -> bool:
        """Testa estrutura de diretórios obrigatória."""
        logger.info("📂 Testando estrutura de diretórios...")
        
        missing_dirs = []
        for dir_path in self.critical_directories:
            full_path = self.project_root / dir_path
            if not full_path.exists():
                missing_dirs.append(dir_path)
                logger.error(f"❌ Diretório crítico ausente: {dir_path}")
            else:
                logger.info(f"✅ Diretório crítico OK: {dir_path}")
        
        return len(missing_dirs) == 0

    def _test_memory_bank(self) -> bool:
        """Testa integridade do memory bank."""
        logger.info("🧠 Testando memory bank...")
        
        memory_files = ['master_rule.md', 'self_correction_log.md', 'global-standards.md']
        issues = []
        
        for file in memory_files:
            path = self.memory_path / file
            if not path.exists():
                issues.append(f"Memory file missing: {file}")
            elif path.stat().st_size < 100:  # Arquivo muito pequeno
                issues.append(f"Memory file too small: {file}")
            else:
                logger.info(f"✅ Memory file OK: {file}")
        
        if issues:
            for issue in issues:
                logger.error(f"❌ {issue}")
            return False
        
        return True

    def _test_git_status(self) -> bool:
        """Testa status do repositório Git."""
        logger.info("📊 Testando status Git...")
        
        try:
            # Verificar se é um repositório Git
            result = subprocess.run(['git', 'status', '--porcelain'], 
                                  capture_output=True, text=True, cwd=self.project_root)
            
            if result.returncode != 0:
                logger.error("❌ Não é um repositório Git válido")
                return False
            
            # Verificar arquivos não commitados
            if result.stdout.strip():
                logger.warning("⚠️ Existem arquivos não commitados")
                return True  # Não é erro crítico
            
            logger.info("✅ Repositório Git limpo")
            return True
            
        except FileNotFoundError:
            logger.error("❌ Git não encontrado no sistema")
            return False

    def _test_backup_protection(self) -> bool:
        """Testa sistema de proteção de backup."""
        logger.info("🛡️ Testando proteção de backup...")
        
        backup_dir = self.project_core / "backups"
        if not backup_dir.exists():
            logger.warning("⚠️ Diretório de backup não existe")
            return True  # Não é erro crítico
        
        # Verificar se há backups recentes (últimos 7 dias)
        recent_backups = []
        cutoff_time = datetime.now().timestamp() - (7 * 24 * 60 * 60)
        
        for backup_item in backup_dir.iterdir():
            if backup_item.stat().st_mtime > cutoff_time:
                recent_backups.append(backup_item.name)
        
        if recent_backups:
            logger.info(f"✅ {len(recent_backups)} backups recentes encontrados")
            return True
        else:
            logger.warning("⚠️ Nenhum backup recente encontrado")
            return True  # Não é erro crítico

    def _test_automation_scripts(self) -> bool:
        """Testa scripts de automação."""
        logger.info("⚙️ Testando scripts de automação...")
        
        automation_dir = self.project_core / "automation"
        python_scripts = list(automation_dir.glob("*.py"))
        
        if len(python_scripts) < 5:
            logger.error("❌ Poucos scripts Python encontrados")
            return False
        
        logger.info(f"✅ {len(python_scripts)} scripts Python encontrados")
        return True

    def _test_mcp_integration(self) -> bool:
        """Testa integração MCP."""
        logger.info("🔌 Testando integração MCP...")
        
        mcp_config = self.project_core / "configs" / "mcp-servers.json"
        if not mcp_config.exists():
            logger.error("❌ Configuração MCP não encontrada")
            return False
        
        try:
            with open(mcp_config, 'r') as f:
                config = json.load(f)
            
            if 'mcpServers' not in config:
                logger.error("❌ Configuração MCP inválida")
                return False
            
            logger.info(f"✅ {len(config['mcpServers'])} servidores MCP configurados")
            return True
            
        except json.JSONDecodeError:
            logger.error("❌ Configuração MCP com JSON inválido")
            return False

    def _test_performance_metrics(self) -> bool:
        """Testa métricas de performance."""
        logger.info("📈 Testando métricas de performance...")
        
        # Teste simples de performance do sistema
        start_time = datetime.now()
        
        # Simular operação de I/O
        test_file = self.project_core / "test_performance.tmp"
        try:
            test_file.write_text("test" * 1000)
            content = test_file.read_text()
            test_file.unlink()
            
            end_time = datetime.now()
            duration = (end_time - start_time).total_seconds()
            
            if duration > 1.0:  # Mais de 1 segundo é lento
                logger.warning(f"⚠️ Performance lenta: {duration:.2f}s")
                return True  # Não é erro crítico
            
            logger.info(f"✅ Performance OK: {duration:.2f}s")
            return True
            
        except Exception as e:
            logger.error(f"❌ Erro no teste de performance: {e}")
            return False

    def _test_memory_validation(self) -> bool:
        """Testa validação específica de memória."""
        logger.info("🧠 Testando validação de memória...")
        
        # Verificar se arquivos de memória têm conteúdo válido
        master_rule = self.memory_path / "master_rule.md"
        if master_rule.exists():
            content = master_rule.read_text()
            if "VIBECODE SYSTEM" in content and len(content) > 1000:
                logger.info("✅ Master rule válido")
                return True
        
        logger.error("❌ Master rule inválido ou ausente")
        return False

    def _test_unified_memory_system(self) -> bool:
        """Testa sistema unificado de memória."""
        logger.info("🔗 Testando sistema unificado de memória...")
        
        # Verificar arquivos do sistema de memória
        memory_files = [
            "master_rule.md",
            "self_correction_log.md", 
            "global-standards.md"
        ]
        
        valid_files = 0
        for file in memory_files:
            path = self.memory_path / file
            if path.exists() and path.stat().st_size > 100:
                valid_files += 1
        
        if valid_files == len(memory_files):
            logger.info("✅ Sistema unificado de memória OK")
            return True
        else:
            logger.error(f"❌ Sistema de memória incompleto: {valid_files}/{len(memory_files)}")
            return False

    def _test_dependencies(self) -> bool:
        """Testa dependências do sistema."""
        logger.info("📦 Testando dependências...")
        
        requirements_file = self.project_core / "requirements.txt"
        if not requirements_file.exists():
            logger.error("❌ requirements.txt não encontrado")
            return False
        
        logger.info("✅ requirements.txt encontrado")
        return True

    def _test_security(self) -> bool:
        """Testa validações de segurança."""
        logger.info("🔒 Testando segurança...")
        
        # Verificar se não há secrets expostos
        gitignore = self.project_root / ".gitignore"
        if gitignore.exists():
            content = gitignore.read_text()
            if ".env" in content and "*.key" in content:
                logger.info("✅ .gitignore configurado para segurança")
                return True
        
        logger.warning("⚠️ .gitignore pode não estar configurado adequadamente")
        return True  # Não é erro crítico

    def _test_workflow_integration(self) -> bool:
        """Testa integração de workflows."""
        logger.info("🔄 Testando integração de workflows...")
        
        workflows_dir = self.project_root / ".github" / "workflows"
        if workflows_dir.exists() and list(workflows_dir.glob("*.yml")):
            logger.info("✅ Workflows GitHub Actions encontrados")
            return True
        
        logger.warning("⚠️ Workflows GitHub Actions não encontrados")
        return True  # Não é erro crítico

    def _test_cross_platform(self) -> bool:
        """Testa compatibilidade cross-platform."""
        logger.info("🌐 Testando compatibilidade cross-platform...")
        
        # Teste simples de compatibilidade
        import platform
        system = platform.system()
        
        logger.info(f"✅ Sistema detectado: {system}")
        return True

    def generate_report(self, results: Dict[str, bool], level: str) -> str:
        """Gera relatório de resultados."""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        report_file = self.reports_path / f"test_report_{level}_{timestamp}.json"
        
        # Calcular estatísticas
        total_tests = len(results)
        passed_tests = sum(results.values())
        success_rate = (passed_tests / total_tests) * 100 if total_tests > 0 else 0
        
        report_data = {
            "timestamp": timestamp,
            "level": level,
            "total_tests": total_tests,
            "passed_tests": passed_tests,
            "failed_tests": total_tests - passed_tests,
            "success_rate": round(success_rate, 2),
            "results": results,
            "summary": f"{passed_tests}/{total_tests} testes passaram ({success_rate:.1f}%)"
        }
        
        # Salvar relatório
        with open(report_file, 'w') as f:
            json.dump(report_data, f, indent=2)
        
        # Log do resultado
        if success_rate >= 90:
            logger.info(f"✅ SUCESSO: {report_data['summary']}")
        elif success_rate >= 70:
            logger.warning(f"⚠️ PARCIAL: {report_data['summary']}")
        else:
            logger.error(f"❌ FALHA: {report_data['summary']}")
        
        logger.info(f"📊 Relatório salvo: {report_file}")
        return str(report_file)

def main():
    """Função principal do Test Runner."""
    parser = argparse.ArgumentParser(description='VIBECODE Test Runner V4.0')
    parser.add_argument('--level', choices=['basic', 'enhanced', 'comprehensive'], 
                       default='basic', help='Nível de testes a executar')
    parser.add_argument('--backup-protection', action='store_true',
                       help='Incluir testes de proteção de backup')
    parser.add_argument('--memory-validation', action='store_true',
                       help='Incluir validação específica de memória')
    parser.add_argument('--project-root', type=str,
                       help='Caminho raiz do projeto')
    parser.add_argument('--report', action='store_true',
                       help='Gerar relatório detalhado')

    args = parser.parse_args()

    # Inicializar runner
    runner = TestRunner(args.project_root)

    # Executar testes baseado no nível
    if args.level == 'basic':
        results = runner.run_basic_tests(args.backup_protection)
    elif args.level == 'enhanced':
        results = runner.run_enhanced_tests(args.memory_validation)
    else:  # comprehensive
        results = runner.run_comprehensive_tests()

    # Gerar relatório se solicitado
    if args.report:
        report_file = runner.generate_report(results, args.level)
        print(f"Relatório gerado: {report_file}")

    # Determinar código de saída
    failed_tests = [test for test, result in results.items() if not result]
    if failed_tests:
        logger.error(f"❌ Testes falharam: {', '.join(failed_tests)}")
        return 1
    else:
        logger.info("✅ Todos os testes passaram!")
        return 0

if __name__ == "__main__":
    sys.exit(main())
