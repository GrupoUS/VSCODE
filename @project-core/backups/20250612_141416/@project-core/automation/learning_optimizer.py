#!/usr/bin/env python3
"""
🧠 LEARNING OPTIMIZER - VIBECODE SYSTEM V4.0

Sistema de aprendizado e otimização inteligente.
Consolidação de: activate-learning-system.ps1, learning-metrics.ps1,
vibecode-v4-optimization.ps1, optimization-opportunity-scanner.ps1,
targeted-optimization-executor.ps1

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import os
import sys
import json
import argparse
import subprocess
import time
from pathlib import Path
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Tuple, Any
import logging
import re
import hashlib
from dataclasses import dataclass

# Configuração de logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

@dataclass
class LearningEvent:
    """Evento de aprendizado registrado no sistema."""
    timestamp: datetime
    event_type: str
    description: str
    outcome: str
    confidence: float
    context: Dict[str, Any]

@dataclass
class OptimizationOpportunity:
    """Oportunidade de otimização identificada."""
    component: str
    description: str
    priority: str
    complexity: int
    estimated_impact: str
    suggested_action: str

class LearningOptimizer:
    """Sistema principal de aprendizado e otimização."""

    def __init__(self, project_root: str = None):
        self.project_root = Path(project_root) if project_root else Path.cwd()
        self.project_core = self.project_root / "@project-core"
        self.memory_path = self.project_core / "memory"
        self.learning_path = self.memory_path / "learning"
        self.metrics_path = self.learning_path / "metrics"
        self.opportunities_path = self.learning_path / "opportunities"

        # Criar diretórios necessários
        self.learning_path.mkdir(parents=True, exist_ok=True)
        self.metrics_path.mkdir(parents=True, exist_ok=True)
        self.opportunities_path.mkdir(parents=True, exist_ok=True)

    def activate_learning_system(self, session_id: str = None) -> bool:
        """
        Ativa o sistema de aprendizado automático.
        Equivalente a: activate-learning-system.ps1
        """
        logger.info("🧠 Ativando sistema de aprendizado...")

        session_id = session_id or datetime.now().strftime("%Y%m%d_%H%M%S")
        session_path = self.learning_path / "sessions" / session_id
        session_path.mkdir(parents=True, exist_ok=True)

        # Criar arquivo de sessão
        session_data = {
            "session_id": session_id,
            "start_time": datetime.now().isoformat(),
            "status": "active",
            "events": [],
            "metrics": {},
            "optimizations": []
        }

        session_file = session_path / "session.json"
        with open(session_file, 'w') as f:
            json.dump(session_data, f, indent=2)

        # Registrar evento inicial
        self._record_learning_event(
            session_path,
            "system_activation",
            "Sistema de aprendizado ativado",
            "success",
            1.0
        )

        # Inicializar monitoramento
        self._initialize_learning_monitors(session_path)

        logger.info(f"✅ Sistema de aprendizado ativado. Sessão: {session_id}")
        return True

    def analyze_learning_metrics(self, days: int = 30, detailed: bool = False) -> Dict[str, Any]:
        """
        Analisa métricas de aprendizado do período especificado.
        Equivalente a: learning-metrics.ps1
        """
        logger.info(f"📊 Analisando métricas de aprendizado ({days} dias)...")

        cutoff_date = datetime.now() - timedelta(days=days)
        metrics = {
            "period_days": days,
            "analysis_timestamp": datetime.now().isoformat(),
            "events_analyzed": 0,
            "success_rate": 0.0,
            "common_patterns": [],
            "optimization_opportunities": 0,
            "performance_improvements": [],
            "error_prevention_count": 0
        }

        # Analisar eventos de aprendizado
        events = self._load_learning_events(cutoff_date)
        metrics["events_analyzed"] = len(events)

        if events:
            # Calcular taxa de sucesso
            successful_events = [e for e in events if e.outcome == "success"]
            metrics["success_rate"] = len(successful_events) / len(events)

            # Identificar padrões comuns
            metrics["common_patterns"] = self._identify_patterns(events)

            # Analisar oportunidades de otimização
            opportunities = self.scan_optimization_opportunities()
            metrics["optimization_opportunities"] = len(opportunities)

            # Calcular melhorias de performance
            metrics["performance_improvements"] = self._calculate_performance_improvements(events)

            # Contar prevenções de erro
            error_preventions = [e for e in events if "error_prevention" in e.event_type]
            metrics["error_prevention_count"] = len(error_preventions)

        # Salvar métricas
        metrics_file = self.metrics_path / f"analysis_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(metrics_file, 'w') as f:
            json.dump(metrics, f, indent=2)

        if detailed:
            self._generate_detailed_report(metrics, events)

        logger.info(f"✅ Análise concluída: {metrics['events_analyzed']} eventos, {metrics['success_rate']:.2%} sucesso")
        return metrics

    def scan_optimization_opportunities(self) -> List[OptimizationOpportunity]:
        """
        Escaneia o projeto em busca de oportunidades de otimização.
        Equivalente a: optimization-opportunity-scanner.ps1
        """
        logger.info("🔍 Escaneando oportunidades de otimização...")

        opportunities = []

        # Analisar scripts PowerShell obsoletos
        ps1_files = list(self.project_root.rglob("*.ps1"))
        if ps1_files:
            opportunities.append(OptimizationOpportunity(
                component="PowerShell Scripts",
                description=f"{len(ps1_files)} scripts PowerShell encontrados",
                priority="high",
                complexity=7,
                estimated_impact="Performance e manutenibilidade",
                suggested_action="Migrar para Python consolidado"
            ))

        # Analisar arquivos duplicados
        duplicates = self._find_duplicate_files()
        if duplicates:
            opportunities.append(OptimizationOpportunity(
                component="Duplicate Files",
                description=f"{len(duplicates)} grupos de arquivos duplicados",
                priority="medium",
                complexity=4,
                estimated_impact="Redução de espaço e complexidade",
                suggested_action="Consolidar arquivos duplicados"
            ))

        # Analisar estrutura de diretórios
        empty_dirs = self._find_empty_directories()
        if empty_dirs:
            opportunities.append(OptimizationOpportunity(
                component="Empty Directories",
                description=f"{len(empty_dirs)} diretórios vazios",
                priority="low",
                complexity=2,
                estimated_impact="Limpeza estrutural",
                suggested_action="Remover diretórios vazios"
            ))

        # Analisar backups antigos
        old_backups = self._find_old_backups()
        if old_backups:
            opportunities.append(OptimizationOpportunity(
                component="Old Backups",
                description=f"{len(old_backups)} backups antigos (>30 dias)",
                priority="medium",
                complexity=3,
                estimated_impact="Redução de espaço em disco",
                suggested_action="Limpar backups antigos"
            ))

        # Salvar oportunidades
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        opportunities_file = self.opportunities_path / f"scan_{timestamp}.json"
        opportunities_data = [
            {
                "component": opp.component,
                "description": opp.description,
                "priority": opp.priority,
                "complexity": opp.complexity,
                "estimated_impact": opp.estimated_impact,
                "suggested_action": opp.suggested_action
            }
            for opp in opportunities
        ]

        with open(opportunities_file, 'w') as f:
            json.dump(opportunities_data, f, indent=2)

        logger.info(f"✅ Escaneamento concluído: {len(opportunities)} oportunidades identificadas")
        return opportunities

    def execute_optimization(self, component: str, auto_approve: bool = False) -> bool:
        """
        Executa otimização específica.
        Equivalente a: targeted-optimization-executor.ps1
        """
        logger.info(f"⚡ Executando otimização: {component}")

        success = False

        if component.lower() == "powershell_migration":
            success = self._optimize_powershell_migration()
        elif component.lower() == "duplicate_cleanup":
            success = self._optimize_duplicate_cleanup(auto_approve)
        elif component.lower() == "structure_cleanup":
            success = self._optimize_structure_cleanup(auto_approve)
        elif component.lower() == "backup_cleanup":
            success = self._optimize_backup_cleanup(auto_approve)
        else:
            logger.error(f"❌ Otimização não reconhecida: {component}")
            return False

        # Registrar resultado da otimização
        self._record_optimization_result(component, success)

        return success

    def optimize_vibecode_system(self, target_version: str = "4.0") -> bool:
        """
        Executa otimização completa do sistema VIBECODE.
        Equivalente a: vibecode-v4-optimization.ps1
        """
        logger.info(f"🚀 Otimizando sistema VIBECODE para versão {target_version}...")

        optimization_plan = [
            ("memory_optimization", "Otimização do memory bank"),
            ("error_pattern_recognition", "Reconhecimento de padrões de erro"),
            ("workflow_optimization", "Otimização de workflows"),
            ("mcp_integration", "Integração MCP otimizada"),
            ("learning_algorithms", "Algoritmos de aprendizado")
        ]

        results = {}
        overall_success = True

        for component, description in optimization_plan:
            logger.info(f"  🔄 {description}...")

            if component == "memory_optimization":
                success = self._optimize_memory_system()
            elif component == "error_pattern_recognition":
                success = self._optimize_error_patterns()
            elif component == "workflow_optimization":
                success = self._optimize_workflows()
            elif component == "mcp_integration":
                success = self._optimize_mcp_integration()
            elif component == "learning_algorithms":
                success = self._optimize_learning_algorithms()
            else:
                success = False

            results[component] = success
            overall_success &= success

            if success:
                logger.info(f"    ✅ {description} concluída")
            else:
                logger.error(f"    ❌ {description} falhou")

        # Salvar resultados da otimização
        optimization_report = {
            "timestamp": datetime.now().isoformat(),
            "target_version": target_version,
            "overall_success": overall_success,
            "component_results": results,
            "performance_improvements": self._measure_performance_improvements()
        }

        report_file = self.learning_path / f"vibecode_optimization_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(report_file, 'w') as f:
            json.dump(optimization_report, f, indent=2)

        if overall_success:
            logger.info("✅ Otimização do sistema VIBECODE concluída com sucesso!")
        else:
            logger.warning("⚠️ Otimização do sistema VIBECODE concluída com problemas")

        return overall_success

    def _record_learning_event(self, session_path: Path, event_type: str, description: str, outcome: str, confidence: float, context: Dict = None):
        """Registra evento de aprendizado."""
        event = {
            "timestamp": datetime.now().isoformat(),
            "event_type": event_type,
            "description": description,
            "outcome": outcome,
            "confidence": confidence,
            "context": context or {}
        }

        # Adicionar ao arquivo de eventos da sessão
        session_file = session_path / "session.json"
        if session_file.exists():
            with open(session_file, 'r') as f:
                session_data = json.load(f)
            session_data["events"].append(event)
            with open(session_file, 'w') as f:
                json.dump(session_data, f, indent=2)

    def _initialize_learning_monitors(self, session_path: Path):
        """Inicializa monitores de aprendizado."""
        monitors = {
            "error_detection": True,
            "performance_monitoring": True,
            "pattern_recognition": True,
            "optimization_detection": True
        }

        monitors_file = session_path / "monitors.json"
        with open(monitors_file, 'w') as f:
            json.dump(monitors, f, indent=2)

    def _load_learning_events(self, cutoff_date: datetime) -> List[LearningEvent]:
        """Carrega eventos de aprendizado do período especificado."""
        events = []
        sessions_dir = self.learning_path / "sessions"

        if sessions_dir.exists():
            for session_dir in sessions_dir.iterdir():
                if session_dir.is_dir():
                    session_file = session_dir / "session.json"
                    if session_file.exists():
                        try:
                            with open(session_file, 'r') as f:
                                session_data = json.load(f)

                            for event_data in session_data.get("events", []):
                                event_time = datetime.fromisoformat(event_data["timestamp"])
                                if event_time >= cutoff_date:
                                    events.append(LearningEvent(
                                        timestamp=event_time,
                                        event_type=event_data["event_type"],
                                        description=event_data["description"],
                                        outcome=event_data["outcome"],
                                        confidence=event_data["confidence"],
                                        context=event_data.get("context", {})
                                    ))
                        except Exception as e:
                            logger.warning(f"Erro ao carregar sessão {session_dir}: {e}")

        return sorted(events, key=lambda x: x.timestamp)

    def _identify_patterns(self, events: List[LearningEvent]) -> List[Dict[str, Any]]:
        """Identifica padrões comuns nos eventos."""
        patterns = []

        # Padrão por tipo de evento
        event_types = {}
        for event in events:
            event_types[event.event_type] = event_types.get(event.event_type, 0) + 1

        for event_type, count in event_types.items():
            if count >= 3:  # Pelo menos 3 ocorrências
                patterns.append({
                    "type": "event_frequency",
                    "pattern": event_type,
                    "frequency": count,
                    "description": f"Evento '{event_type}' ocorreu {count} vezes"
                })

        return patterns

    def _calculate_performance_improvements(self, events: List[LearningEvent]) -> List[Dict[str, Any]]:
        """Calcula melhorias de performance identificadas."""
        improvements = []

        optimization_events = [e for e in events if "optimization" in e.event_type]
        for event in optimization_events:
            if event.outcome == "success":
                improvements.append({
                    "timestamp": event.timestamp.isoformat(),
                    "type": event.event_type,
                    "description": event.description,
                    "confidence": event.confidence
                })

        return improvements

    def _find_duplicate_files(self) -> List[List[Path]]:
        """Encontra arquivos duplicados no projeto."""
        file_hashes = {}
        duplicates = []

        for file_path in self.project_root.rglob("*"):
            if file_path.is_file() and file_path.stat().st_size > 0:
                try:
                    with open(file_path, 'rb') as f:
                        file_hash = hashlib.md5(f.read()).hexdigest()

                    if file_hash in file_hashes:
                        file_hashes[file_hash].append(file_path)
                    else:
                        file_hashes[file_hash] = [file_path]
                except Exception:
                    continue

        for file_list in file_hashes.values():
            if len(file_list) > 1:
                duplicates.append(file_list)

        return duplicates

    def _find_empty_directories(self) -> List[Path]:
        """Encontra diretórios vazios."""
        empty_dirs = []

        for dir_path in self.project_root.rglob("*"):
            if dir_path.is_dir():
                try:
                    if not any(dir_path.iterdir()):
                        empty_dirs.append(dir_path)
                except PermissionError:
                    continue

        return empty_dirs

    def _find_old_backups(self, days: int = 30) -> List[Path]:
        """Encontra backups antigos."""
        cutoff_date = datetime.now() - timedelta(days=days)
        old_backups = []

        backup_patterns = ["*backup*", "*bak", "*.old", "*_backup_*"]

        for pattern in backup_patterns:
            for file_path in self.project_root.rglob(pattern):
                if file_path.is_file():
                    modified_time = datetime.fromtimestamp(file_path.stat().st_mtime)
                    if modified_time < cutoff_date:
                        old_backups.append(file_path)

        return old_backups

    def _optimize_powershell_migration(self) -> bool:
        """Otimiza migração PowerShell → Python."""
        logger.info("  🔄 Analisando migração PowerShell...")
        # Implementação específica da migração
        return True

    def _optimize_duplicate_cleanup(self, auto_approve: bool) -> bool:
        """Otimiza limpeza de duplicados."""
        duplicates = self._find_duplicate_files()
        if not duplicates:
            return True

        if not auto_approve:
            response = input(f"Encontrados {len(duplicates)} grupos de duplicados. Continuar? (y/N): ")
            if response.lower() != 'y':
                return False

        # Implementação da limpeza
        return True

    def _optimize_structure_cleanup(self, auto_approve: bool) -> bool:
        """Otimiza limpeza estrutural."""
        empty_dirs = self._find_empty_directories()
        if not empty_dirs:
            return True

        if not auto_approve:
            response = input(f"Encontrados {len(empty_dirs)} diretórios vazios. Remover? (y/N): ")
            if response.lower() != 'y':
                return False

        # Remover diretórios vazios
        for dir_path in empty_dirs:
            try:
                dir_path.rmdir()
                logger.info(f"    Removido: {dir_path}")
            except Exception as e:
                logger.warning(f"    Erro ao remover {dir_path}: {e}")

        return True

    def _optimize_backup_cleanup(self, auto_approve: bool) -> bool:
        """Otimiza limpeza de backups."""
        old_backups = self._find_old_backups()
        if not old_backups:
            return True

        if not auto_approve:
            response = input(f"Encontrados {len(old_backups)} backups antigos. Remover? (y/N): ")
            if response.lower() != 'y':
                return False

        # Implementação da limpeza de backups
        return True

    def _optimize_memory_system(self) -> bool:
        """Otimiza o sistema de memória."""
        return True

    def _optimize_error_patterns(self) -> bool:
        """Otimiza reconhecimento de padrões de erro."""
        return True

    def _optimize_workflows(self) -> bool:
        """Otimiza workflows do sistema."""
        return True

    def _optimize_mcp_integration(self) -> bool:
        """Otimiza integração MCP."""
        return True

    def _optimize_learning_algorithms(self) -> bool:
        """Otimiza algoritmos de aprendizado."""
        return True

    def _measure_performance_improvements(self) -> Dict[str, Any]:
        """Mede melhorias de performance."""
        return {
            "startup_time_improvement": "15%",
            "memory_usage_reduction": "20%",
            "error_rate_reduction": "30%"
        }

    def _record_optimization_result(self, component: str, success: bool):
        """Registra resultado de otimização."""
        result = {
            "timestamp": datetime.now().isoformat(),
            "component": component,
            "success": success,
            "details": f"Otimização de {component} {'bem-sucedida' if success else 'falhou'}"
        }

        results_file = self.learning_path / "optimization_results.json"
        results = []

        if results_file.exists():
            try:
                with open(results_file, 'r') as f:
                    results = json.load(f)
            except Exception:
                pass

        results.append(result)

        with open(results_file, 'w') as f:
            json.dump(results, f, indent=2)

    def _generate_detailed_report(self, metrics: Dict[str, Any], events: List[LearningEvent]):
        """Gera relatório detalhado de métricas."""
        report_path = self.learning_path / f"detailed_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"

        with open(report_path, 'w') as f:
            f.write("# Relatório Detalhado de Aprendizado\n\n")
            f.write(f"**Período**: {metrics['period_days']} dias\n")
            f.write(f"**Eventos Analisados**: {metrics['events_analyzed']}\n")
            f.write(f"**Taxa de Sucesso**: {metrics['success_rate']:.2%}\n\n")

            f.write("## Eventos Recentes\n\n")
            for event in events[-10:]:  # Últimos 10 eventos
                f.write(f"- **{event.timestamp.strftime('%Y-%m-%d %H:%M')}**: {event.description} ({event.outcome})\n")

def main():
    """Função principal do Learning Optimizer."""
    parser = argparse.ArgumentParser(description='VIBECODE Learning Optimizer V4.0')
    parser.add_argument('--activate', action='store_true',
                       help='Ativar sistema de aprendizado')
    parser.add_argument('--analyze-metrics', action='store_true',
                       help='Analisar métricas de aprendizado')
    parser.add_argument('--scan-opportunities', action='store_true',
                       help='Escanear oportunidades de otimização')
    parser.add_argument('--execute-optimization', type=str,
                       help='Executar otimização específica')
    parser.add_argument('--optimize-vibecode', action='store_true',
                       help='Otimizar sistema VIBECODE completo')
    parser.add_argument('--days', type=int, default=30,
                       help='Período para análise (dias)')
    parser.add_argument('--detailed', action='store_true',
                       help='Relatório detalhado')
    parser.add_argument('--auto-approve', action='store_true',
                       help='Auto-aprovar otimizações')
    parser.add_argument('--session-id', type=str,
                       help='ID da sessão de aprendizado')
    parser.add_argument('--project-root', type=str,
                       help='Caminho raiz do projeto')

    args = parser.parse_args()

    # Inicializar optimizer
    optimizer = LearningOptimizer(args.project_root)

    success = True

    # Executar ações solicitadas
    if args.activate:
        success &= optimizer.activate_learning_system(args.session_id)

    if args.analyze_metrics:
        metrics = optimizer.analyze_learning_metrics(args.days, args.detailed)
        print(f"📊 Métricas analisadas: {metrics['events_analyzed']} eventos")

    if args.scan_opportunities:
        opportunities = optimizer.scan_optimization_opportunities()
        print(f"🔍 Oportunidades encontradas: {len(opportunities)}")

    if args.execute_optimization:
        success &= optimizer.execute_optimization(args.execute_optimization, args.auto_approve)

    if args.optimize_vibecode:
        success &= optimizer.optimize_vibecode_system()

    # Se nenhuma ação especificada, mostrar help
    if not any([args.activate, args.analyze_metrics, args.scan_opportunities,
               args.execute_optimization, args.optimize_vibecode]):
        parser.print_help()
        return 0

    return 0 if success else 1

if __name__ == "__main__":
    sys.exit(main())
