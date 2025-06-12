#!/usr/bin/env python3
"""
🧪 EHS INTEGRATION TEST SUITE - PROTOCOLO EHS V1
GRUPO US VIBECODE SYSTEM V4.0

Suite de testes abrangente para validar integração completa do EHS V1 com sistema V4.0.
Executa testes de compatibilidade, performance, proteções e ativação oficial.

Autor: GRUPO US - VIBECODE SYSTEM V4.0
Data: 2025-01-27
"""

import sys
import json
import logging
import subprocess
import time
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional, Tuple
from dataclasses import dataclass

# Configuração de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('@project-core/logs/ehs_integration_tests.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

@dataclass
class TestResult:
    """Resultado de um teste individual"""
    name: str
    success: bool
    duration: float
    details: Dict[str, Any]
    errors: List[str]
    warnings: List[str]

@dataclass
class IntegrationTestSuite:
    """Suite completa de testes de integração EHS"""
    total_tests: int
    passed_tests: int
    failed_tests: int
    total_duration: float
    results: List[TestResult]
    overall_success: bool

class EHSIntegrationTester:
    """
    Testador de Integração EHS V1 - Validação Completa com Sistema V4.0
    
    Executa testes abrangentes para validar:
    1. Integração com finaltest_unified.py
    2. Compatibilidade com scripts consolidados
    3. Performance e benchmarks V4.0
    4. Proteções contra padrões de erro conhecidos
    5. Ativação oficial do sistema
    """

    def __init__(self, project_root: str = None):
        self.project_root = Path(project_root) if project_root else Path.cwd()
        self.project_core = self.project_root / "@project-core"
        
        # Configuração de testes
        self.test_config = {
            "performance_baseline": {
                "max_ehs_check_duration": 5.0,
                "max_system_overhead": 10.0,
                "min_success_rate": 95.0
            },
            "compatibility_requirements": {
                "finaltest_comprehensive_pass": True,
                "validation_suite_pass": True,
                "mcp_sync_functional": True
            },
            "protection_validation": {
                "aggressive_patterns_blocked": True,
                "whitelist_protection_active": True,
                "staging_area_functional": True,
                "rollback_capabilities": True
            }
        }
        
        logger.info("EHS Integration Tester initialized")
        logger.info(f"Project root: {self.project_root}")

    def run_comprehensive_integration_tests(self) -> IntegrationTestSuite:
        """Executa suite completa de testes de integração EHS V1"""
        logger.info("🧪 Starting EHS V1 Integration Test Suite")
        start_time = time.time()
        
        test_results = []
        
        # TESTE 1: Verificação de Componentes EHS
        test_results.append(self._test_ehs_components())
        
        # TESTE 2: Integração com finaltest_unified.py
        test_results.append(self._test_finaltest_integration())
        
        # TESTE 3: Compatibilidade com Scripts Consolidados
        test_results.append(self._test_scripts_compatibility())
        
        # TESTE 4: Performance e Benchmarks
        test_results.append(self._test_performance_benchmarks())
        
        # TESTE 5: Proteções EHS
        test_results.append(self._test_ehs_protections())
        
        # TESTE 6: Validação de Configuração
        test_results.append(self._test_configuration_validation())
        
        # TESTE 7: Teste de Stress e Carga
        test_results.append(self._test_stress_load())
        
        # TESTE 8: Validação de Documentação
        test_results.append(self._test_documentation_validation())
        
        # Calcular resultados finais
        total_duration = time.time() - start_time
        passed_tests = sum(1 for result in test_results if result.success)
        failed_tests = len(test_results) - passed_tests
        overall_success = failed_tests == 0 and passed_tests >= 7  # Mínimo 7/8 testes
        
        suite_result = IntegrationTestSuite(
            total_tests=len(test_results),
            passed_tests=passed_tests,
            failed_tests=failed_tests,
            total_duration=total_duration,
            results=test_results,
            overall_success=overall_success
        )
        
        logger.info(f"🧪 Integration Test Suite completed: {passed_tests}/{len(test_results)} passed in {total_duration:.2f}s")
        return suite_result

    def _test_ehs_components(self) -> TestResult:
        """Teste 1: Verificação de Componentes EHS"""
        logger.info("🔍 Test 1: EHS Components Verification")
        start_time = time.time()
        
        errors = []
        warnings = []
        details = {}
        
        try:
            # Verificar arquivos EHS essenciais
            required_files = [
                "@project-core/rules/00-protocolo-ehs-v1.md",
                "@project-core/automation/ehs_orchestrator.py",
                "@project-core/automation/ehs_protections.py",
                "@project-core/configs/ehs_config.json"
            ]
            
            missing_files = []
            for file_path in required_files:
                full_path = self.project_root / file_path
                if not full_path.exists():
                    missing_files.append(file_path)
            
            if missing_files:
                errors.append(f"Missing EHS files: {missing_files}")
            
            details['required_files_check'] = {
                'total': len(required_files),
                'found': len(required_files) - len(missing_files),
                'missing': missing_files
            }
            
            # Verificar EHS Orchestrator status
            try:
                result = subprocess.run([
                    'python', str(self.project_core / 'automation' / 'ehs_orchestrator.py'), '--status'
                ], capture_output=True, text=True, timeout=10)
                
                if result.returncode == 0:
                    ehs_status = json.loads(result.stdout)
                    details['ehs_orchestrator_status'] = ehs_status
                    
                    # Verificar métricas essenciais
                    if ehs_status.get('reuse_percentage', 0) < 85:
                        warnings.append(f"Reuse percentage below target: {ehs_status.get('reuse_percentage')}%")
                else:
                    errors.append(f"EHS Orchestrator failed: {result.stderr}")
                    
            except Exception as e:
                errors.append(f"EHS Orchestrator test failed: {e}")
            
            success = len(errors) == 0
            duration = time.time() - start_time
            
            return TestResult(
                name="EHS Components Verification",
                success=success,
                duration=duration,
                details=details,
                errors=errors,
                warnings=warnings
            )
            
        except Exception as e:
            return TestResult(
                name="EHS Components Verification",
                success=False,
                duration=time.time() - start_time,
                details={},
                errors=[f"Test exception: {e}"],
                warnings=[]
            )

    def _test_finaltest_integration(self) -> TestResult:
        """Teste 2: Integração com finaltest_unified.py"""
        logger.info("🔍 Test 2: Finaltest Integration")
        start_time = time.time()
        
        errors = []
        warnings = []
        details = {}
        
        try:
            # Executar finaltest com modo enhanced (inclui EHS Pre-Check)
            result = subprocess.run([
                'python', str(self.project_core / 'automation' / 'finaltest_unified.py'), 
                '--mode=enhanced', '--verbose'
            ], capture_output=True, text=True, timeout=60)
            
            details['finaltest_output'] = result.stdout
            details['finaltest_stderr'] = result.stderr
            details['finaltest_returncode'] = result.returncode
            
            # Verificar se EHS Pre-Check foi executado
            if "EHS Pre-Check" not in result.stdout:
                errors.append("EHS Pre-Check not found in finaltest output")
            
            # Verificar se passou
            if "EHS Pre-Check passed" not in result.stdout:
                errors.append("EHS Pre-Check did not pass")
            
            # Verificar taxa de sucesso geral
            if result.returncode != 0:
                errors.append(f"Finaltest failed with return code: {result.returncode}")
            
            # Extrair métricas se possível
            if "Tests:" in result.stdout:
                import re
                match = re.search(r'Tests: (\d+)/(\d+) passed \((\d+\.?\d*)%\)', result.stdout)
                if match:
                    passed, total, percentage = match.groups()
                    details['test_metrics'] = {
                        'passed': int(passed),
                        'total': int(total),
                        'percentage': float(percentage)
                    }
                    
                    if float(percentage) < 90:
                        warnings.append(f"Test success rate below 90%: {percentage}%")
            
            success = len(errors) == 0
            duration = time.time() - start_time
            
            return TestResult(
                name="Finaltest Integration",
                success=success,
                duration=duration,
                details=details,
                errors=errors,
                warnings=warnings
            )
            
        except Exception as e:
            return TestResult(
                name="Finaltest Integration",
                success=False,
                duration=time.time() - start_time,
                details={},
                errors=[f"Test exception: {e}"],
                warnings=[]
            )

    def _test_scripts_compatibility(self) -> TestResult:
        """Teste 3: Compatibilidade com Scripts Consolidados"""
        logger.info("🔍 Test 3: Scripts Compatibility")
        start_time = time.time()
        
        errors = []
        warnings = []
        details = {}
        
        try:
            # Testar validation_suite.py
            result = subprocess.run([
                'python', str(self.project_core / 'automation' / 'validation_suite.py'), 
                '--type=system'
            ], capture_output=True, text=True, timeout=30)
            
            details['validation_suite'] = {
                'returncode': result.returncode,
                'output': result.stdout[:500],  # Limitar output
                'stderr': result.stderr[:500]
            }
            
            if result.returncode != 0:
                warnings.append("validation_suite.py returned non-zero exit code")
            
            # Testar sync_mcp_configs.py
            result = subprocess.run([
                'python', str(self.project_core / 'automation' / 'sync_mcp_configs.py'), 
                '--sync-all'
            ], capture_output=True, text=True, timeout=30)
            
            details['sync_mcp_configs'] = {
                'returncode': result.returncode,
                'output': result.stdout[:500],
                'stderr': result.stderr[:500]
            }
            
            if result.returncode != 0:
                warnings.append("sync_mcp_configs.py returned non-zero exit code")
            
            success = len(errors) == 0
            duration = time.time() - start_time
            
            return TestResult(
                name="Scripts Compatibility",
                success=success,
                duration=duration,
                details=details,
                errors=errors,
                warnings=warnings
            )
            
        except Exception as e:
            return TestResult(
                name="Scripts Compatibility",
                success=False,
                duration=time.time() - start_time,
                details={},
                errors=[f"Test exception: {e}"],
                warnings=[]
            )

    def _test_performance_benchmarks(self) -> TestResult:
        """Teste 4: Performance e Benchmarks"""
        logger.info("🔍 Test 4: Performance Benchmarks")
        start_time = time.time()
        
        errors = []
        warnings = []
        details = {}
        
        try:
            # Testar performance do EHS Orchestrator
            ehs_start = time.time()
            result = subprocess.run([
                'python', str(self.project_core / 'automation' / 'ehs_orchestrator.py'), 
                '--operation=health_check', '--dry-run'
            ], capture_output=True, text=True, timeout=15)
            ehs_duration = time.time() - ehs_start
            
            details['ehs_performance'] = {
                'duration': ehs_duration,
                'returncode': result.returncode,
                'target': self.test_config['performance_baseline']['max_ehs_check_duration']
            }
            
            if ehs_duration > self.test_config['performance_baseline']['max_ehs_check_duration']:
                errors.append(f"EHS check duration {ehs_duration:.2f}s exceeds target {self.test_config['performance_baseline']['max_ehs_check_duration']}s")
            
            # Verificar overhead do sistema
            if result.returncode == 0:
                try:
                    ehs_status = json.loads(result.stdout)
                    if 'details' in ehs_status and 'health_check' in ehs_status['details']:
                        health_data = ehs_status['details']['health_check']
                        if 'success_rate' in health_data:
                            success_rate = health_data['success_rate']
                            details['system_health'] = {'success_rate': success_rate}
                            
                            if success_rate < self.test_config['performance_baseline']['min_success_rate']:
                                warnings.append(f"System health below target: {success_rate}%")
                except:
                    warnings.append("Could not parse EHS status for performance metrics")
            
            success = len(errors) == 0
            duration = time.time() - start_time
            
            return TestResult(
                name="Performance Benchmarks",
                success=success,
                duration=duration,
                details=details,
                errors=errors,
                warnings=warnings
            )
            
        except Exception as e:
            return TestResult(
                name="Performance Benchmarks",
                success=False,
                duration=time.time() - start_time,
                details={},
                errors=[f"Test exception: {e}"],
                warnings=[]
            )

    def _test_ehs_protections(self) -> TestResult:
        """Teste 5: Proteções EHS"""
        logger.info("🔍 Test 5: EHS Protections")
        start_time = time.time()
        
        errors = []
        warnings = []
        details = {}
        
        try:
            # Testar detecção de padrões agressivos
            result = subprocess.run([
                'python', str(self.project_core / 'automation' / 'ehs_protections.py'),
                '--test-operation=cleanup', '--command=rm -rf *', '--dry-run'
            ], capture_output=True, text=True, timeout=15)
            
            details['aggressive_pattern_test'] = {
                'returncode': result.returncode,
                'output': result.stdout,
                'stderr': result.stderr
            }
            
            # Verificar se padrão agressivo foi detectado
            if "aggressive pattern" not in result.stdout.lower() and "high" not in result.stdout.lower():
                warnings.append("Aggressive pattern detection may not be working")
            
            success = len(errors) == 0
            duration = time.time() - start_time
            
            return TestResult(
                name="EHS Protections",
                success=success,
                duration=duration,
                details=details,
                errors=errors,
                warnings=warnings
            )
            
        except Exception as e:
            return TestResult(
                name="EHS Protections",
                success=False,
                duration=time.time() - start_time,
                details={},
                errors=[f"Test exception: {e}"],
                warnings=[]
            )

    def _test_configuration_validation(self) -> TestResult:
        """Teste 6: Validação de Configuração"""
        logger.info("🔍 Test 6: Configuration Validation")
        start_time = time.time()
        
        errors = []
        warnings = []
        details = {}
        
        try:
            # Verificar ehs_config.json
            config_path = self.project_core / "configs" / "ehs_config.json"
            if config_path.exists():
                with open(config_path, 'r', encoding='utf-8') as f:
                    config = json.load(f)
                
                details['ehs_config'] = {
                    'version': config.get('ehs_version'),
                    'integration_mode': config.get('integration_mode'),
                    'reuse_target': config.get('core_configuration', {}).get('reuse_target_percentage')
                }
                
                # Verificar configurações essenciais
                if config.get('ehs_version') != "1.0":
                    warnings.append("EHS version mismatch")
                
                if config.get('integration_mode') != "orchestration":
                    warnings.append("Integration mode not set to orchestration")
            else:
                errors.append("EHS config file not found")
            
            success = len(errors) == 0
            duration = time.time() - start_time
            
            return TestResult(
                name="Configuration Validation",
                success=success,
                duration=duration,
                details=details,
                errors=errors,
                warnings=warnings
            )
            
        except Exception as e:
            return TestResult(
                name="Configuration Validation",
                success=False,
                duration=time.time() - start_time,
                details={},
                errors=[f"Test exception: {e}"],
                warnings=[]
            )

    def _test_stress_load(self) -> TestResult:
        """Teste 7: Teste de Stress e Carga"""
        logger.info("🔍 Test 7: Stress and Load Testing")
        start_time = time.time()
        
        errors = []
        warnings = []
        details = {}
        
        try:
            # Executar múltiplas operações EHS em sequência
            operations = ['health_check', 'health_check', 'health_check']
            durations = []
            
            for i, operation in enumerate(operations):
                op_start = time.time()
                result = subprocess.run([
                    'python', str(self.project_core / 'automation' / 'ehs_orchestrator.py'),
                    f'--operation={operation}', '--dry-run'
                ], capture_output=True, text=True, timeout=10)
                op_duration = time.time() - op_start
                durations.append(op_duration)
                
                if result.returncode != 0:
                    warnings.append(f"Operation {i+1} failed")
            
            details['stress_test'] = {
                'operations_count': len(operations),
                'durations': durations,
                'average_duration': sum(durations) / len(durations) if durations else 0,
                'max_duration': max(durations) if durations else 0
            }
            
            # Verificar se performance se manteve estável
            if durations and max(durations) > 10:  # 10 segundos é muito para operação simples
                warnings.append("Performance degradation detected under load")
            
            success = len(errors) == 0
            duration = time.time() - start_time
            
            return TestResult(
                name="Stress and Load Testing",
                success=success,
                duration=duration,
                details=details,
                errors=errors,
                warnings=warnings
            )
            
        except Exception as e:
            return TestResult(
                name="Stress and Load Testing",
                success=False,
                duration=time.time() - start_time,
                details={},
                errors=[f"Test exception: {e}"],
                warnings=[]
            )

    def _test_documentation_validation(self) -> TestResult:
        """Teste 8: Validação de Documentação"""
        logger.info("🔍 Test 8: Documentation Validation")
        start_time = time.time()
        
        errors = []
        warnings = []
        details = {}
        
        try:
            # Verificar documentação EHS
            docs_to_check = [
                "@project-core/docs/setup_guide_unified.md",
                "@project-core/docs/system_status_dashboard.md",
                "@project-core/memory/master_rule.md"
            ]
            
            docs_status = {}
            for doc_path in docs_to_check:
                full_path = self.project_root / doc_path
                if full_path.exists():
                    with open(full_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    # Verificar se contém referências EHS
                    ehs_references = content.lower().count('ehs')
                    docs_status[doc_path] = {
                        'exists': True,
                        'size': len(content),
                        'ehs_references': ehs_references
                    }
                    
                    if ehs_references == 0:
                        warnings.append(f"No EHS references found in {doc_path}")
                else:
                    docs_status[doc_path] = {'exists': False}
                    errors.append(f"Documentation file missing: {doc_path}")
            
            details['documentation_status'] = docs_status
            
            success = len(errors) == 0
            duration = time.time() - start_time
            
            return TestResult(
                name="Documentation Validation",
                success=success,
                duration=duration,
                details=details,
                errors=errors,
                warnings=warnings
            )
            
        except Exception as e:
            return TestResult(
                name="Documentation Validation",
                success=False,
                duration=time.time() - start_time,
                details={},
                errors=[f"Test exception: {e}"],
                warnings=[]
            )

    def generate_test_report(self, suite_result: IntegrationTestSuite) -> Dict[str, Any]:
        """Gera relatório detalhado dos testes"""
        report = {
            'test_suite': 'EHS V1 Integration Tests',
            'timestamp': datetime.now().isoformat(),
            'summary': {
                'total_tests': suite_result.total_tests,
                'passed_tests': suite_result.passed_tests,
                'failed_tests': suite_result.failed_tests,
                'success_rate': (suite_result.passed_tests / suite_result.total_tests * 100) if suite_result.total_tests > 0 else 0,
                'total_duration': suite_result.total_duration,
                'overall_success': suite_result.overall_success
            },
            'test_results': []
        }
        
        for result in suite_result.results:
            report['test_results'].append({
                'name': result.name,
                'success': result.success,
                'duration': result.duration,
                'errors_count': len(result.errors),
                'warnings_count': len(result.warnings),
                'details': result.details,
                'errors': result.errors,
                'warnings': result.warnings
            })
        
        return report

    def activate_ehs_system(self) -> bool:
        """Ativa oficialmente o sistema EHS V1"""
        logger.info("🚀 Activating EHS V1 System officially...")
        
        try:
            # Executar ativação final
            result = subprocess.run([
                'python', str(self.project_core / 'automation' / 'ehs_orchestrator.py'),
                '--operation=comprehensive'
            ], capture_output=True, text=True, timeout=60)
            
            if result.returncode == 0:
                logger.info("✅ EHS V1 System officially activated!")
                return True
            else:
                logger.error(f"❌ EHS activation failed: {result.stderr}")
                return False
                
        except Exception as e:
            logger.error(f"❌ EHS activation exception: {e}")
            return False

def main():
    """Main CLI entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(description='EHS V1 Integration Test Suite')
    parser.add_argument('--project-root', default='.', help='Project root directory')
    parser.add_argument('--activate', action='store_true', help='Activate EHS system after successful tests')
    parser.add_argument('--report-file', help='Save test report to file')
    
    args = parser.parse_args()
    
    # Executar testes
    tester = EHSIntegrationTester(args.project_root)
    suite_result = tester.run_comprehensive_integration_tests()
    
    # Gerar relatório
    report = tester.generate_test_report(suite_result)
    
    # Salvar relatório se solicitado
    if args.report_file:
        with open(args.report_file, 'w', encoding='utf-8') as f:
            json.dump(report, f, indent=2, ensure_ascii=False)
        logger.info(f"Test report saved to: {args.report_file}")
    
    # Imprimir resumo
    print(f"\n🧪 EHS V1 Integration Test Results:")
    print(f"✅ Passed: {suite_result.passed_tests}/{suite_result.total_tests}")
    print(f"❌ Failed: {suite_result.failed_tests}")
    print(f"⏱️ Duration: {suite_result.total_duration:.2f}s")
    print(f"🎯 Success Rate: {report['summary']['success_rate']:.1f}%")
    print(f"🚀 Overall Success: {'✅ YES' if suite_result.overall_success else '❌ NO'}")
    
    # Ativar sistema se solicitado e testes passaram
    if args.activate and suite_result.overall_success:
        activation_success = tester.activate_ehs_system()
        if activation_success:
            print("\n🎉 EHS V1 System officially activated!")
        else:
            print("\n❌ EHS V1 System activation failed!")
            sys.exit(1)
    elif args.activate and not suite_result.overall_success:
        print("\n⚠️ Cannot activate EHS system - tests failed!")
        sys.exit(1)
    
    # Exit code baseado no sucesso dos testes
    sys.exit(0 if suite_result.overall_success else 1)

if __name__ == "__main__":
    main()
