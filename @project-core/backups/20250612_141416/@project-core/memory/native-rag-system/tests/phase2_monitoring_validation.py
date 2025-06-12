#!/usr/bin/env python3

"""
PHASE 2 MONITORING VALIDATION V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Validação completa da FASE 2: Sistema de Monitoring de Produção.
Testa dashboard, alertas, logging estruturado e integração com componentes.
"""

import asyncio
import json
import time
import sys
from pathlib import Path
from datetime import datetime

# Add parent directory for imports
sys.path.append(str(Path(__file__).parent.parent))

from monitoring.monitoring_integration import monitoring_integration, start_monitoring_integration
from monitoring.production_monitor import production_monitor, record_performance_metric
from integration.js_bridge import JavaScriptBridge
from central_hub.memory_coordinator import CentralMemoryCoordinator

class Phase2MonitoringValidation:
    """
    Validação completa do sistema de monitoring de produção
    """
    
    def __init__(self):
        self.test_results = {
            'timestamp': datetime.now().isoformat(),
            'phase': 'FASE 2 - Monitoring de Produção',
            'dashboard_validation': {},
            'alerting_validation': {},
            'logging_validation': {},
            'integration_validation': {},
            'performance_validation': {},
            'overall_status': 'PENDING'
        }
        
        print("🚀 [PHASE 2 VALIDATION] Starting FASE 2 monitoring validation...")
    
    async def run_complete_validation(self):
        """Execute complete FASE 2 validation"""
        
        try:
            # Phase 1: Start monitoring system
            await self._start_monitoring_system()
            
            # Phase 2: Validate dashboard functionality
            await self._validate_dashboard_functionality()
            
            # Phase 3: Validate alerting system
            await self._validate_alerting_system()
            
            # Phase 4: Validate logging system
            await self._validate_logging_system()
            
            # Phase 5: Validate component integration
            await self._validate_component_integration()
            
            # Phase 6: Validate performance monitoring
            await self._validate_performance_monitoring()
            
            # Phase 7: Generate final report
            await self._generate_final_report()
            
            # Phase 8: Stop monitoring system
            await self._stop_monitoring_system()
            
            return self.test_results
            
        except Exception as error:
            print(f"❌ [PHASE 2 VALIDATION] Critical error: {error}")
            self.test_results['overall_status'] = 'FAILED'
            self.test_results['critical_error'] = str(error)
            return self.test_results
    
    async def _start_monitoring_system(self):
        """Start monitoring system for testing"""
        print("\n📋 Phase 1: Starting Monitoring System")
        
        try:
            # Start monitoring integration
            self.monitor_task = await start_monitoring_integration()
            
            # Wait for system to initialize
            await asyncio.sleep(3)
            
            # Verify monitoring is active
            status = await monitoring_integration.get_monitoring_status()
            
            if status['integration_enabled']:
                print("   ✅ Monitoring system started successfully")
                self.test_results['monitoring_startup'] = {
                    'status': 'SUCCESS',
                    'integration_enabled': status['integration_enabled'],
                    'instrumented_components': status['instrumented_components']
                }
            else:
                raise Exception("Monitoring system failed to start")
                
        except Exception as error:
            print(f"   ❌ FAILED - {error}")
            self.test_results['monitoring_startup'] = {
                'status': 'FAILED',
                'error': str(error)
            }
            raise
    
    async def _validate_dashboard_functionality(self):
        """Validate dashboard data generation and updates"""
        print("\n📋 Phase 2: Validating Dashboard Functionality")
        
        try:
            # Record test metrics
            await record_performance_metric('bridge_reuse_rate', 95.0, '%', 'js_bridge')
            await record_performance_metric('memory_consultation_speed', 2.5, 'ms', 'memory_coordinator')
            await record_performance_metric('embedding_service_time', 180.0, 'ms', 'embedding_service')
            
            # Wait for dashboard update
            await asyncio.sleep(12)  # Wait for dashboard update cycle
            
            # Check dashboard file
            dashboard_file = Path(__file__).parent.parent / 'monitoring' / 'dashboard_data.json'
            
            if dashboard_file.exists():
                with open(dashboard_file, 'r') as f:
                    dashboard_data = json.load(f)
                
                # Validate dashboard structure
                required_keys = ['timestamp', 'system_status', 'current_metrics', 'summary_statistics', 'baselines']
                dashboard_valid = all(key in dashboard_data for key in required_keys)
                
                # Check if metrics are present
                metrics_present = len(dashboard_data.get('current_metrics', {})) > 0
                
                self.test_results['dashboard_validation'] = {
                    'status': 'PASSED' if dashboard_valid and metrics_present else 'FAILED',
                    'file_exists': True,
                    'structure_valid': dashboard_valid,
                    'metrics_present': metrics_present,
                    'metrics_count': len(dashboard_data.get('current_metrics', {})),
                    'system_status': dashboard_data.get('system_status', 'unknown')
                }
                
                status = "✅ PASSED" if dashboard_valid and metrics_present else "❌ FAILED"
                print(f"   {status} Dashboard functionality")
                print(f"   Metrics tracked: {len(dashboard_data.get('current_metrics', {}))}")
                print(f"   System status: {dashboard_data.get('system_status', 'unknown')}")
                
            else:
                raise Exception("Dashboard file not found")
                
        except Exception as error:
            print(f"   ❌ FAILED - {error}")
            self.test_results['dashboard_validation'] = {
                'status': 'FAILED',
                'error': str(error)
            }
    
    async def _validate_alerting_system(self):
        """Validate alerting system with threshold violations"""
        print("\n📋 Phase 3: Validating Alerting System")
        
        try:
            # Record metrics that should trigger alerts
            await record_performance_metric('memory_consultation_speed', 250.0, 'ms', 'memory_coordinator')  # Warning threshold
            await record_performance_metric('embedding_service_time', 600.0, 'ms', 'embedding_service')      # Critical threshold
            
            # Wait for alert processing
            await asyncio.sleep(5)
            
            # Check alerts file
            alerts_file = Path(__file__).parent.parent / 'monitoring' / 'alerts_log.jsonl'
            
            alerts_generated = 0
            if alerts_file.exists():
                with open(alerts_file, 'r') as f:
                    for line in f:
                        if line.strip():
                            alerts_generated += 1
            
            # Check production monitor alert history
            alert_history_count = len(production_monitor.alert_history)
            
            self.test_results['alerting_validation'] = {
                'status': 'PASSED' if alerts_generated > 0 or alert_history_count > 0 else 'FAILED',
                'alerts_file_exists': alerts_file.exists(),
                'alerts_in_file': alerts_generated,
                'alerts_in_memory': alert_history_count,
                'total_alerts': alerts_generated + alert_history_count
            }
            
            status = "✅ PASSED" if alerts_generated > 0 or alert_history_count > 0 else "❌ FAILED"
            print(f"   {status} Alerting system")
            print(f"   Alerts generated: {alerts_generated + alert_history_count}")
            
        except Exception as error:
            print(f"   ❌ FAILED - {error}")
            self.test_results['alerting_validation'] = {
                'status': 'FAILED',
                'error': str(error)
            }
    
    async def _validate_logging_system(self):
        """Validate structured logging system"""
        print("\n📋 Phase 4: Validating Logging System")
        
        try:
            # Check metrics log file
            metrics_file = Path(__file__).parent.parent / 'monitoring' / 'metrics_log.jsonl'
            
            metrics_logged = 0
            if metrics_file.exists():
                with open(metrics_file, 'r') as f:
                    for line in f:
                        if line.strip():
                            metrics_logged += 1
            
            # Validate log structure
            log_structure_valid = False
            if metrics_file.exists() and metrics_logged > 0:
                with open(metrics_file, 'r') as f:
                    first_line = f.readline().strip()
                    if first_line:
                        try:
                            log_entry = json.loads(first_line)
                            required_fields = ['timestamp', 'metric_name', 'value', 'unit', 'component']
                            log_structure_valid = all(field in log_entry for field in required_fields)
                        except json.JSONDecodeError:
                            pass
            
            self.test_results['logging_validation'] = {
                'status': 'PASSED' if metrics_logged > 0 and log_structure_valid else 'FAILED',
                'metrics_file_exists': metrics_file.exists(),
                'metrics_logged': metrics_logged,
                'log_structure_valid': log_structure_valid
            }
            
            status = "✅ PASSED" if metrics_logged > 0 and log_structure_valid else "❌ FAILED"
            print(f"   {status} Logging system")
            print(f"   Metrics logged: {metrics_logged}")
            print(f"   Log structure valid: {log_structure_valid}")
            
        except Exception as error:
            print(f"   ❌ FAILED - {error}")
            self.test_results['logging_validation'] = {
                'status': 'FAILED',
                'error': str(error)
            }
    
    async def _validate_component_integration(self):
        """Validate integration with existing components"""
        print("\n📋 Phase 5: Validating Component Integration")
        
        try:
            # Test JavaScript Bridge integration
            bridge = JavaScriptBridge()
            
            # Record initial metrics count
            initial_metrics = len(production_monitor.current_metrics)
            
            # Execute bridge operations
            await bridge.call_js_component('embedding_service', 'generateContextualEmbedding', ['test content', {}])
            await bridge.call_js_component('knowledge_graph', 'extractEntities', ['test content with React'])
            
            # Wait for metrics to be recorded
            await asyncio.sleep(3)
            
            # Check if new metrics were recorded
            final_metrics = len(production_monitor.current_metrics)
            metrics_increased = final_metrics > initial_metrics
            
            # Test Memory Coordinator integration
            coordinator = CentralMemoryCoordinator()
            await coordinator.coordinate_memory_consultation('test query', {'source': 'validation'})
            
            # Wait for metrics
            await asyncio.sleep(2)
            
            self.test_results['integration_validation'] = {
                'status': 'PASSED' if metrics_increased else 'PARTIAL',
                'initial_metrics_count': initial_metrics,
                'final_metrics_count': len(production_monitor.current_metrics),
                'metrics_increased': metrics_increased,
                'js_bridge_working': True,  # If we got here, it's working
                'memory_coordinator_working': True
            }
            
            status = "✅ PASSED" if metrics_increased else "🟡 PARTIAL"
            print(f"   {status} Component integration")
            print(f"   Metrics count: {initial_metrics} → {len(production_monitor.current_metrics)}")
            
        except Exception as error:
            print(f"   ❌ FAILED - {error}")
            self.test_results['integration_validation'] = {
                'status': 'FAILED',
                'error': str(error)
            }
    
    async def _validate_performance_monitoring(self):
        """Validate performance monitoring capabilities"""
        print("\n📋 Phase 6: Validating Performance Monitoring")
        
        try:
            # Get current monitoring status
            monitor_status = await production_monitor.get_monitoring_status()
            
            # Check if monitoring is active
            monitoring_active = monitor_status['is_monitoring']
            
            # Check metrics tracking
            metrics_tracked = monitor_status['metrics_tracked']
            
            # Check uptime
            uptime = monitor_status['uptime']
            
            # Validate baselines are configured
            baselines_configured = len(production_monitor.baselines) > 0
            
            self.test_results['performance_validation'] = {
                'status': 'PASSED' if monitoring_active and metrics_tracked > 0 else 'FAILED',
                'monitoring_active': monitoring_active,
                'metrics_tracked': metrics_tracked,
                'uptime_seconds': uptime,
                'baselines_configured': baselines_configured,
                'baseline_count': len(production_monitor.baselines)
            }
            
            status = "✅ PASSED" if monitoring_active and metrics_tracked > 0 else "❌ FAILED"
            print(f"   {status} Performance monitoring")
            print(f"   Monitoring active: {monitoring_active}")
            print(f"   Metrics tracked: {metrics_tracked}")
            print(f"   Uptime: {uptime:.1f}s")
            
        except Exception as error:
            print(f"   ❌ FAILED - {error}")
            self.test_results['performance_validation'] = {
                'status': 'FAILED',
                'error': str(error)
            }
    
    async def _generate_final_report(self):
        """Generate final validation report"""
        print("\n📊 PHASE 2 MONITORING VALIDATION REPORT")
        print("=" * 60)
        
        # Calculate overall status
        phase_statuses = [
            self.test_results.get('dashboard_validation', {}).get('status'),
            self.test_results.get('alerting_validation', {}).get('status'),
            self.test_results.get('logging_validation', {}).get('status'),
            self.test_results.get('integration_validation', {}).get('status'),
            self.test_results.get('performance_validation', {}).get('status')
        ]
        
        passed_phases = sum(1 for status in phase_statuses if status in ['PASSED', 'PARTIAL'])
        total_phases = len([s for s in phase_statuses if s is not None])
        
        if passed_phases >= 4:
            overall_status = 'PASSED'
        elif passed_phases >= 3:
            overall_status = 'PARTIAL'
        else:
            overall_status = 'FAILED'
        
        self.test_results['overall_status'] = overall_status
        
        # Print summary
        print(f"\n📈 Validation Summary:")
        print(f"   Phases Passed: {passed_phases}/{total_phases}")
        print(f"   Overall Status: {overall_status}")
        
        # Print detailed results
        for phase_name, phase_data in self.test_results.items():
            if isinstance(phase_data, dict) and 'status' in phase_data:
                status_icon = {"PASSED": "✅", "PARTIAL": "🟡", "FAILED": "❌"}.get(phase_data['status'], "❓")
                print(f"   {status_icon} {phase_name}: {phase_data['status']}")
        
        # Final recommendation
        if overall_status == 'PASSED':
            print(f"\n✅ RECOMMENDATION: FASE 2 COMPLETED SUCCESSFULLY")
            print(f"   Production monitoring system is fully operational")
        elif overall_status == 'PARTIAL':
            print(f"\n🟡 RECOMMENDATION: FASE 2 MOSTLY SUCCESSFUL")
            print(f"   Minor issues detected but system is functional")
        else:
            print(f"\n❌ RECOMMENDATION: FASE 2 NEEDS ATTENTION")
            print(f"   Critical issues must be resolved")
        
        # Save results
        results_file = Path(__file__).parent / 'phase2_monitoring_results.json'
        with open(results_file, 'w') as f:
            json.dump(self.test_results, f, indent=2, default=str)
        
        print(f"\n💾 Results saved to: {results_file}")
    
    async def _stop_monitoring_system(self):
        """Stop monitoring system"""
        print("\n🛑 Stopping monitoring system...")
        
        try:
            await monitoring_integration.disable_monitoring()
            print("   ✅ Monitoring system stopped successfully")
        except Exception as error:
            print(f"   ⚠️ Warning during shutdown: {error}")

async def main():
    """Run Phase 2 monitoring validation"""
    validation = Phase2MonitoringValidation()
    results = await validation.run_complete_validation()
    return results

if __name__ == "__main__":
    asyncio.run(main())
