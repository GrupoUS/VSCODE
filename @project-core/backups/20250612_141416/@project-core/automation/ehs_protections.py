#!/usr/bin/env python3
"""
🛡️ EHS PROTECTIONS - PROTOCOLO EHS V1
GRUPO US VIBECODE SYSTEM V4.0

Sistema de proteções específicas contra padrões de erro conhecidos.
Integra com PCPE (P.C.P.E. ML + Prevention Integration System) e
estende MaintenanceManager com safeguards EHS.

Proteções Implementadas:
- Anti-Aggressive Cleanup (baseado em self_correction_log.md)
- Insufficient Safeguards Prevention
- Incremental Testing e Rollback Capabilities
- Integração com PCPE para detecção de comandos destrutivos

Autor: GRUPO US - VIBECODE SYSTEM V4.0
Data: 2025-01-27
"""

import sys
import json
import logging
import subprocess
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional, Tuple
from dataclasses import dataclass
import tempfile
import shutil

# Configuração de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('@project-core/logs/ehs_protections.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

@dataclass
class OperationContext:
    """Contexto de uma operação para análise de segurança"""
    operation_type: str  # "cleanup", "backup", "modification", "deletion"
    target_path: str
    command: str
    parameters: Dict[str, Any]
    dry_run: bool = False
    force: bool = False

@dataclass
class SafetyValidationResult:
    """Resultado da validação de segurança"""
    safe: bool
    risk_level: str  # "MINIMAL", "LOW", "MEDIUM", "HIGH", "CRITICAL"
    warnings: List[str]
    errors: List[str]
    suggestions: List[str]
    pcpe_analysis: Optional[Dict[str, Any]] = None

class EHSProtections:
    """
    Sistema de Proteções EHS V1 - Prevenção de Padrões de Erro Conhecidos

    Implementa proteções específicas baseadas na análise do self_correction_log.md:
    1. Anti-Aggressive Cleanup
    2. Insufficient Safeguards Prevention
    3. Incremental Testing
    4. Rollback Capabilities
    """

    def __init__(self, project_root: str = None):
        self.project_root = Path(project_root) if project_root else Path.cwd()
        self.project_core = self.project_root / "@project-core"

        # Carregar padrões de erro conhecidos
        self.known_error_patterns = self._load_known_error_patterns()

        # Configuração de proteções EHS
        self.protection_config = {
            "whitelist_protection": True,
            "staging_area_required": True,
            "incremental_testing": True,
            "rollback_capabilities": True,
            "pcpe_integration": True,
            "max_files_per_operation": 100,
            "require_confirmation_threshold": 50
        }

        # Diretórios protegidos (baseado no Protocolo EHS V1)
        self.protected_directories = [
            "@project-core/",
            "@project-core/projects/",
            "@project-core/memory/",
            "@project-core/configs/",
            "@project-core/automation/",
            "@project-core/rules/"
        ]

        # Arquivos críticos que nunca devem ser removidos
        self.critical_files = [
            "@project-core/memory/master_rule.md",
            "@project-core/memory/self_correction_log.md",
            "@project-core/memory/global-standards.md",
            "@project-core/rules/00-protocolo-ehs-v1.md",
            "@project-core/configs/mcp-master-unified.json"
        ]

        # Padrões agressivos detectados no self_correction_log.md
        self.aggressive_patterns = [
            "rm -rf *",
            "Remove-Item * -Recurse -Force",
            "del /s /q *",
            "*.* -Recurse",
            "/* -Force",
            "cleanup_all",
            "delete_everything"
        ]

        logger.info("EHS Protections V1 initialized")
        logger.info(f"Protected directories: {len(self.protected_directories)}")
        logger.info(f"Critical files: {len(self.critical_files)}")

    def _load_known_error_patterns(self) -> List[Dict[str, str]]:
        """Carrega padrões de erro conhecidos do self_correction_log.md"""
        patterns = []
        self_correction_log = self.project_core / "memory" / "self_correction_log.md"

        if not self_correction_log.exists():
            logger.warning("self_correction_log.md not found - using default patterns")
            return self._get_default_error_patterns()

        try:
            with open(self_correction_log, 'r', encoding='utf-8') as f:
                content = f.read().lower()

            # Extrair padrões específicos baseados na análise real
            if "aggressive cleanup failure" in content:
                patterns.append({
                    "pattern": "aggressive_cleanup",
                    "description": "Limpeza muito agressiva causou perda de arquivos críticos",
                    "prevention": "Whitelist protection + staging area required"
                })

            if "overly aggressive patterns" in content:
                patterns.append({
                    "pattern": "overly_aggressive_wildcards",
                    "description": "Wildcards que removeram arquivos essenciais",
                    "prevention": "Pattern validation + incremental testing"
                })

            if "insufficient safeguards" in content:
                patterns.append({
                    "pattern": "insufficient_safeguards",
                    "description": "Falta de whitelist para proteção",
                    "prevention": "Mandatory whitelist validation"
                })

            if "no incremental testing" in content:
                patterns.append({
                    "pattern": "no_incremental_testing",
                    "description": "Operações destrutivas sem testes graduais",
                    "prevention": "Incremental testing + rollback plan"
                })

            logger.info(f"Loaded {len(patterns)} known error patterns from self_correction_log.md")
            return patterns

        except Exception as e:
            logger.error(f"Error loading error patterns: {e}")
            return self._get_default_error_patterns()

    def _get_default_error_patterns(self) -> List[Dict[str, str]]:
        """Retorna padrões de erro padrão se não conseguir carregar do log"""
        return [
            {
                "pattern": "aggressive_cleanup",
                "description": "Operações de limpeza muito agressivas",
                "prevention": "Whitelist protection + dry-run first"
            },
            {
                "pattern": "insufficient_safeguards",
                "description": "Operações sem proteções adequadas",
                "prevention": "Mandatory validation + confirmation"
            }
        ]

    def validate_operation_safety(self, operation: OperationContext) -> SafetyValidationResult:
        """
        Valida segurança de uma operação com múltiplas camadas de proteção

        Camadas de validação:
        1. PCPE Integration - Detecção de comandos destrutivos
        2. Pattern Analysis - Análise de padrões agressivos
        3. Whitelist Protection - Validação de diretórios protegidos
        4. Critical Files Protection - Proteção de arquivos críticos
        5. Incremental Testing - Validação gradual
        """
        logger.info(f"Validating operation safety: {operation.operation_type} on {operation.target_path}")

        warnings = []
        errors = []
        suggestions = []
        risk_level = "MINIMAL"

        # CAMADA 1: Integração PCPE para detecção de comandos destrutivos
        pcpe_analysis = self._integrate_with_pcpe(operation)
        if pcpe_analysis and pcpe_analysis.get('risk_level') in ['HIGH', 'CRITICAL']:
            risk_level = pcpe_analysis['risk_level']
            errors.append(f"PCPE detected high-risk command: {operation.command}")
            suggestions.append("Use PCPE-approved alternative or manual supervision")

        # CAMADA 2: Análise de padrões agressivos
        aggressive_risk = self._analyze_aggressive_patterns(operation)
        if aggressive_risk['detected']:
            risk_level = max(risk_level, "HIGH", key=self._risk_level_priority)
            errors.extend(aggressive_risk['errors'])
            suggestions.extend(aggressive_risk['suggestions'])

        # CAMADA 3: Proteção de whitelist
        whitelist_risk = self._validate_whitelist_protection(operation)
        if whitelist_risk['violations']:
            risk_level = max(risk_level, "MEDIUM", key=self._risk_level_priority)
            warnings.extend(whitelist_risk['warnings'])
            suggestions.extend(whitelist_risk['suggestions'])

        # CAMADA 4: Proteção de arquivos críticos
        critical_risk = self._validate_critical_files_protection(operation)
        if critical_risk['at_risk']:
            risk_level = "CRITICAL"
            errors.extend(critical_risk['errors'])
            suggestions.append("Operation blocked - critical files at risk")

        # CAMADA 5: Validação de teste incremental
        incremental_risk = self._validate_incremental_testing(operation)
        if incremental_risk['required'] and not incremental_risk['available']:
            risk_level = max(risk_level, "MEDIUM", key=self._risk_level_priority)
            warnings.append("Incremental testing recommended for this operation")
            suggestions.append("Enable dry-run mode first")

        # Determinar se operação é segura
        safe = risk_level in ["MINIMAL", "LOW"] and len(errors) == 0

        result = SafetyValidationResult(
            safe=safe,
            risk_level=risk_level,
            warnings=warnings,
            errors=errors,
            suggestions=suggestions,
            pcpe_analysis=pcpe_analysis
        )

        logger.info(f"Safety validation result: {risk_level} risk, safe={safe}")
        return result

    def _integrate_with_pcpe(self, operation: OperationContext) -> Optional[Dict[str, Any]]:
        """Integra com sistema PCPE para análise de comandos destrutivos"""
        if not self.protection_config['pcpe_integration']:
            return None

        pcpe_script = self.project_core / "tools" / "scripts" / "pcpe-ml-prevention-integration.js"

        if not pcpe_script.exists():
            logger.warning("PCPE script not found - skipping PCPE integration")
            return None

        try:
            # Simular integração PCPE (na prática executaria o script Node.js)
            # Por simplicidade, implementamos a lógica de detecção aqui

            command_lower = operation.command.lower()
            risk_score = 0.1  # Risco mínimo padrão

            # Detectar comandos destrutivos
            destructive_keywords = ['rm -rf', 'remove-item', 'del /s', 'delete', 'cleanup']
            for keyword in destructive_keywords:
                if keyword in command_lower:
                    risk_score += 0.3

            # Detectar wildcards perigosos
            dangerous_wildcards = ['*.*', '/*', '\\*', 'all', 'everything']
            for wildcard in dangerous_wildcards:
                if wildcard in command_lower:
                    risk_score += 0.4

            # Determinar nível de risco
            if risk_score >= 0.95:
                risk_level = "CRITICAL"
            elif risk_score >= 0.8:
                risk_level = "HIGH"
            elif risk_score >= 0.6:
                risk_level = "MEDIUM"
            elif risk_score >= 0.3:
                risk_level = "LOW"
            else:
                risk_level = "MINIMAL"

            return {
                'risk_score': risk_score,
                'risk_level': risk_level,
                'analysis': f'Command analysis completed - {risk_level} risk detected',
                'suggestions': ['Use dry-run mode', 'Verify target paths', 'Enable incremental testing']
            }

        except Exception as e:
            logger.error(f"PCPE integration failed: {e}")
            return None

    def _analyze_aggressive_patterns(self, operation: OperationContext) -> Dict[str, Any]:
        """Analisa padrões agressivos baseados em self_correction_log.md"""
        result = {
            'detected': False,
            'patterns_found': [],
            'errors': [],
            'suggestions': []
        }

        command_lower = operation.command.lower()

        # Verificar padrões agressivos conhecidos
        for pattern in self.aggressive_patterns:
            if pattern.lower() in command_lower:
                result['detected'] = True
                result['patterns_found'].append(pattern)
                result['errors'].append(f"Aggressive pattern detected: {pattern}")

        # Verificar wildcards perigosos em operações de limpeza
        if operation.operation_type == "cleanup":
            dangerous_wildcards = ["*.*", "/*", "\\*"]
            for wildcard in dangerous_wildcards:
                if wildcard in operation.command:
                    result['detected'] = True
                    result['patterns_found'].append(f"dangerous_wildcard: {wildcard}")
                    result['errors'].append(f"Dangerous wildcard in cleanup: {wildcard}")

        if result['detected']:
            result['suggestions'].extend([
                "Use specific file patterns instead of wildcards",
                "Enable dry-run mode first",
                "Implement staging area for testing",
                "Add incremental testing"
            ])

        return result

    def _validate_whitelist_protection(self, operation: OperationContext) -> Dict[str, Any]:
        """Valida proteção de whitelist para diretórios protegidos"""
        result = {
            'violations': [],
            'warnings': [],
            'suggestions': []
        }

        target_path = Path(operation.target_path)

        # Verificar se operação afeta diretórios protegidos
        for protected_dir in self.protected_directories:
            protected_path = self.project_root / protected_dir

            try:
                # Verificar se target está dentro de diretório protegido
                if target_path.is_relative_to(protected_path) or str(target_path).startswith(str(protected_path)):
                    result['violations'].append(protected_dir)
                    result['warnings'].append(f"Operation affects protected directory: {protected_dir}")
            except (ValueError, OSError):
                # Ignorar erros de path comparison
                continue

        if result['violations']:
            result['suggestions'].extend([
                "Verify operation is necessary in protected directories",
                "Use staging area for testing",
                "Enable incremental testing",
                "Consider alternative approaches"
            ])

        return result

    def _validate_critical_files_protection(self, operation: OperationContext) -> Dict[str, Any]:
        """Valida proteção de arquivos críticos"""
        result = {
            'at_risk': False,
            'critical_files_affected': [],
            'errors': []
        }

        target_path = Path(operation.target_path)

        # Verificar se operação afeta arquivos críticos
        for critical_file in self.critical_files:
            critical_path = self.project_root / critical_file

            try:
                # Verificar se arquivo crítico está no caminho da operação
                if (target_path == critical_path or
                    str(critical_path).startswith(str(target_path)) or
                    critical_file in operation.command):

                    result['at_risk'] = True
                    result['critical_files_affected'].append(critical_file)
                    result['errors'].append(f"Critical file at risk: {critical_file}")
            except (ValueError, OSError):
                continue

        return result

    def _validate_incremental_testing(self, operation: OperationContext) -> Dict[str, Any]:
        """Valida se teste incremental é necessário e disponível"""
        result = {
            'required': False,
            'available': False,
            'recommendations': []
        }

        # Operações que requerem teste incremental
        high_risk_operations = ["cleanup", "deletion", "modification"]

        if operation.operation_type in high_risk_operations:
            result['required'] = True

            # Verificar se dry-run está disponível
            if operation.dry_run:
                result['available'] = True
            else:
                result['recommendations'].append("Enable dry-run mode for incremental testing")

        # Verificar se operação afeta muitos arquivos
        if "target_file_count" in operation.parameters:
            file_count = operation.parameters["target_file_count"]
            if file_count > self.protection_config["require_confirmation_threshold"]:
                result['required'] = True
                result['recommendations'].append(f"Operation affects {file_count} files - incremental testing recommended")

        return result

    def _risk_level_priority(self, risk_level: str) -> int:
        """Retorna prioridade numérica do nível de risco para comparação"""
        priorities = {
            "MINIMAL": 1,
            "LOW": 2,
            "MEDIUM": 3,
            "HIGH": 4,
            "CRITICAL": 5
        }
        return priorities.get(risk_level, 1)

    def create_staging_area(self, operation: OperationContext) -> Optional[str]:
        """Cria área de staging para teste seguro de operações"""
        try:
            # Criar diretório temporário para staging
            staging_dir = tempfile.mkdtemp(prefix="ehs_staging_", dir=self.project_core / "temp")
            staging_path = Path(staging_dir)

            logger.info(f"Created staging area: {staging_path}")

            # Copiar arquivos relevantes para staging se necessário
            if operation.operation_type in ["cleanup", "modification"]:
                target_path = Path(operation.target_path)
                if target_path.exists() and target_path.is_dir():
                    # Copiar estrutura de diretório (apenas alguns arquivos para teste)
                    sample_files = list(target_path.rglob("*"))[:10]  # Limitar a 10 arquivos

                    for file_path in sample_files:
                        if file_path.is_file():
                            relative_path = file_path.relative_to(target_path)
                            staging_file = staging_path / relative_path
                            staging_file.parent.mkdir(parents=True, exist_ok=True)
                            shutil.copy2(file_path, staging_file)

            return str(staging_path)

        except Exception as e:
            logger.error(f"Failed to create staging area: {e}")
            return None

    def cleanup_staging_area(self, staging_path: str) -> bool:
        """Remove área de staging após uso"""
        try:
            if staging_path and Path(staging_path).exists():
                shutil.rmtree(staging_path)
                logger.info(f"Cleaned up staging area: {staging_path}")
                return True
        except Exception as e:
            logger.error(f"Failed to cleanup staging area: {e}")
        return False

    def create_rollback_plan(self, operation: OperationContext) -> Dict[str, Any]:
        """Cria plano de rollback para operação"""
        rollback_plan = {
            'operation_id': f"ehs_{datetime.now().strftime('%Y%m%d_%H%M%S')}",
            'original_operation': operation.operation_type,
            'target_path': operation.target_path,
            'backup_created': False,
            'backup_path': None,
            'rollback_commands': [],
            'timestamp': datetime.now().isoformat()
        }

        try:
            # Criar backup antes da operação se necessário
            if operation.operation_type in ["cleanup", "deletion", "modification"]:
                backup_path = self._create_operation_backup(operation)
                if backup_path:
                    rollback_plan['backup_created'] = True
                    rollback_plan['backup_path'] = backup_path
                    rollback_plan['rollback_commands'].append(f"Restore from backup: {backup_path}")

            logger.info(f"Rollback plan created: {rollback_plan['operation_id']}")
            return rollback_plan

        except Exception as e:
            logger.error(f"Failed to create rollback plan: {e}")
            rollback_plan['error'] = str(e)
            return rollback_plan

    def _create_operation_backup(self, operation: OperationContext) -> Optional[str]:
        """Cria backup específico para uma operação"""
        try:
            backup_dir = self.project_core / "backups" / "ehs_operation_backups"
            backup_dir.mkdir(parents=True, exist_ok=True)

            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            backup_name = f"ehs_backup_{operation.operation_type}_{timestamp}"
            backup_path = backup_dir / backup_name

            target_path = Path(operation.target_path)
            if target_path.exists():
                if target_path.is_file():
                    shutil.copy2(target_path, backup_path)
                else:
                    shutil.copytree(target_path, backup_path, ignore_dangling_symlinks=True)

                logger.info(f"Operation backup created: {backup_path}")
                return str(backup_path)

        except Exception as e:
            logger.error(f"Failed to create operation backup: {e}")

        return None

class EHSMaintenanceExtension:
    """
    Extensão do MaintenanceManager com proteções EHS

    Estende o cleanup_system() com validações de segurança EHS
    """

    def __init__(self, maintenance_manager, ehs_protections: EHSProtections):
        self.maintenance_manager = maintenance_manager
        self.ehs_protections = ehs_protections
        logger.info("EHS Maintenance Extension initialized")

    def enhanced_cleanup_system(self, target: Optional[str] = None, dry_run: bool = False,
                               force: bool = False) -> Dict[str, Any]:
        """
        Cleanup system com proteções EHS integradas

        Adiciona validações de segurança antes de executar limpeza
        """
        logger.info("Starting EHS-enhanced cleanup system...")

        # Criar contexto da operação
        operation = OperationContext(
            operation_type="cleanup",
            target_path=target or str(self.maintenance_manager.project_core),
            command=f"cleanup_system(target={target}, dry_run={dry_run})",
            parameters={"dry_run": dry_run, "force": force},
            dry_run=dry_run,
            force=force
        )

        # FASE 1: Validação de segurança EHS
        safety_result = self.ehs_protections.validate_operation_safety(operation)

        if not safety_result.safe and not force:
            logger.error("EHS Safety validation failed - cleanup blocked")
            return {
                'success': False,
                'blocked_by_ehs': True,
                'safety_result': safety_result.__dict__,
                'message': 'Cleanup blocked by EHS protections'
            }

        # FASE 2: Criar staging area se necessário
        staging_path = None
        if safety_result.risk_level in ["MEDIUM", "HIGH"] and not dry_run:
            staging_path = self.ehs_protections.create_staging_area(operation)
            if staging_path:
                logger.info(f"Testing cleanup in staging area: {staging_path}")
                # Executar teste em staging primeiro
                test_result = self._test_cleanup_in_staging(staging_path, operation)
                if not test_result['success']:
                    self.ehs_protections.cleanup_staging_area(staging_path)
                    return {
                        'success': False,
                        'staging_test_failed': True,
                        'test_result': test_result,
                        'message': 'Cleanup failed staging test'
                    }

        # FASE 3: Criar plano de rollback
        rollback_plan = None
        if not dry_run and safety_result.risk_level in ["MEDIUM", "HIGH", "CRITICAL"]:
            rollback_plan = self.ehs_protections.create_rollback_plan(operation)

        # FASE 4: Executar cleanup original com monitoramento
        try:
            cleanup_result = self.maintenance_manager.cleanup_system(target, dry_run)

            # Adicionar informações EHS ao resultado
            enhanced_result = {
                'success': True,
                'cleanup_result': cleanup_result,
                'ehs_validation': safety_result.__dict__,
                'staging_used': staging_path is not None,
                'rollback_plan': rollback_plan,
                'total_cleaned': sum(cleanup_result.values()) if cleanup_result else 0
            }

            logger.info(f"EHS-enhanced cleanup completed successfully")
            return enhanced_result

        except Exception as e:
            logger.error(f"EHS-enhanced cleanup failed: {e}")
            return {
                'success': False,
                'error': str(e),
                'ehs_validation': safety_result.__dict__,
                'rollback_plan': rollback_plan
            }

        finally:
            # Limpeza de staging area
            if staging_path:
                self.ehs_protections.cleanup_staging_area(staging_path)

    def _test_cleanup_in_staging(self, staging_path: str, operation: OperationContext) -> Dict[str, Any]:
        """Testa operação de cleanup em staging area"""
        try:
            # Simular cleanup em staging (implementação simplificada)
            # operation parameter usado para logging e contexto
            logger.info(f"Testing {operation.operation_type} in staging: {staging_path}")
            staging_dir = Path(staging_path)

            # Contar arquivos antes
            files_before = len(list(staging_dir.rglob("*")))

            # Simular limpeza (remover alguns arquivos temporários)
            temp_files = list(staging_dir.rglob("*.tmp")) + list(staging_dir.rglob("*.temp"))
            removed_count = 0

            for temp_file in temp_files[:5]:  # Limitar teste
                if temp_file.is_file():
                    temp_file.unlink()
                    removed_count += 1

            files_after = len(list(staging_dir.rglob("*")))

            return {
                'success': True,
                'files_before': files_before,
                'files_after': files_after,
                'files_removed': removed_count,
                'test_safe': removed_count < files_before * 0.1  # Máximo 10% removido
            }

        except Exception as e:
            return {
                'success': False,
                'error': str(e)
            }

def main():
    """Função principal para teste do EHS Protections"""
    import argparse

    parser = argparse.ArgumentParser(description='EHS Protections V1 - VIBECODE SYSTEM V4.0')
    parser.add_argument('--test-operation', choices=['cleanup', 'backup', 'modification', 'deletion'],
                       help='Test operation safety validation')
    parser.add_argument('--target-path', default='@project-core/temp',
                       help='Target path for operation')
    parser.add_argument('--command', default='test_command',
                       help='Command to analyze')
    parser.add_argument('--dry-run', action='store_true',
                       help='Enable dry-run mode')

    args = parser.parse_args()

    # Inicializar EHS Protections
    ehs_protections = EHSProtections()

    if args.test_operation:
        # Testar validação de operação
        operation = OperationContext(
            operation_type=args.test_operation,
            target_path=args.target_path,
            command=args.command,
            parameters={},
            dry_run=args.dry_run
        )

        result = ehs_protections.validate_operation_safety(operation)
        print(json.dumps(result.__dict__, indent=2))
    else:
        # Mostrar status das proteções
        status = {
            'ehs_protections_active': True,
            'protected_directories': len(ehs_protections.protected_directories),
            'critical_files': len(ehs_protections.critical_files),
            'known_error_patterns': len(ehs_protections.known_error_patterns),
            'aggressive_patterns': len(ehs_protections.aggressive_patterns)
        }
        print(json.dumps(status, indent=2))

if __name__ == "__main__":
    main()
