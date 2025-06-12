#!/usr/bin/env python3

"""
MONITORING INTEGRATION V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Integração do sistema de monitoring com componentes existentes do Native RAG System.
Instrumenta automaticamente os componentes para coleta de métricas de performance.
"""

import asyncio
import time
import functools
import logging
from typing import Dict, Any, Callable, Optional
from pathlib import Path
import sys

# Add parent directory for imports
sys.path.append(str(Path(__file__).parent.parent))

from monitoring.production_monitor import production_monitor, record_performance_metric

logger = logging.getLogger(__name__)

class MonitoringIntegration:
    """
    Sistema de integração de monitoring com componentes existentes
    """
    
    def __init__(self):
        self.is_enabled = False
        self.instrumented_components = set()
        
        logger.info("🔧 [MONITORING INTEGRATION] Monitoring integration initialized")
    
    async def enable_monitoring(self):
        """Enable monitoring integration"""
        self.is_enabled = True
        
        # Start production monitor
        monitor_task = asyncio.create_task(production_monitor.start_monitoring())
        
        # Instrument existing components
        await self._instrument_components()
        
        logger.info("✅ [MONITORING INTEGRATION] Monitoring integration enabled")
        return monitor_task
    
    async def disable_monitoring(self):
        """Disable monitoring integration"""
        self.is_enabled = False
        await production_monitor.stop_monitoring()
        logger.info("🛑 [MONITORING INTEGRATION] Monitoring integration disabled")
    
    async def _instrument_components(self):
        """Instrument existing components with monitoring"""
        try:
            # Instrument JavaScript Bridge
            await self._instrument_js_bridge()
            
            # Instrument Memory Coordinator
            await self._instrument_memory_coordinator()
            
            # Instrument Crosscheck System
            await self._instrument_crosscheck_system()
            
            # Instrument Crawl4AI Strategies
            await self._instrument_crawl4ai_strategies()
            
            # Instrument ECL Pipeline
            await self._instrument_ecl_pipeline()
            
            logger.info(f"✅ [MONITORING INTEGRATION] Instrumented {len(self.instrumented_components)} components")
            
        except Exception as error:
            logger.error(f"❌ [MONITORING INTEGRATION] Instrumentation failed: {error}")
    
    async def _instrument_js_bridge(self):
        """Instrument JavaScript Bridge with monitoring"""
        try:
            from integration.js_bridge import JavaScriptBridge
            
            # Monkey patch the call_js_component method
            original_method = JavaScriptBridge.call_js_component
            
            async def monitored_call_js_component(self, component: str, method: str, args: list):
                start_time = time.time()
                
                try:
                    result = await original_method(self, component, method, args)
                    execution_time = (time.time() - start_time) * 1000
                    
                    # Record metrics
                    if monitoring_integration.is_enabled:
                        await record_performance_metric(
                            f'{component}_time',
                            execution_time,
                            'ms',
                            'js_bridge'
                        )
                        
                        # Record bridge reuse rate
                        metrics = self.get_metrics()
                        total_calls = metrics.get('total_calls', 0)
                        fallback_count = metrics.get('fallback_count', 0)
                        
                        if total_calls > 0:
                            reuse_rate = ((total_calls - fallback_count) / total_calls) * 100
                            await record_performance_metric(
                                'bridge_reuse_rate',
                                reuse_rate,
                                '%',
                                'js_bridge'
                            )
                    
                    return result
                    
                except Exception as error:
                    execution_time = (time.time() - start_time) * 1000
                    
                    if monitoring_integration.is_enabled:
                        await record_performance_metric(
                            f'{component}_error_time',
                            execution_time,
                            'ms',
                            'js_bridge'
                        )
                    
                    raise
            
            JavaScriptBridge.call_js_component = monitored_call_js_component
            self.instrumented_components.add('js_bridge')
            
            logger.info("✅ [MONITORING INTEGRATION] JavaScript Bridge instrumented")
            
        except Exception as error:
            logger.error(f"❌ [MONITORING INTEGRATION] JS Bridge instrumentation failed: {error}")
    
    async def _instrument_memory_coordinator(self):
        """Instrument Memory Coordinator with monitoring"""
        try:
            from central_hub.memory_coordinator import CentralMemoryCoordinator
            
            # Monkey patch the coordinate_memory_consultation method
            original_method = CentralMemoryCoordinator.coordinate_memory_consultation
            
            async def monitored_coordinate_memory_consultation(self, query: str, context: Dict[str, Any]):
                start_time = time.time()
                
                try:
                    result = await original_method(self, query, context)
                    execution_time = (time.time() - start_time) * 1000
                    
                    # Record metrics
                    if monitoring_integration.is_enabled:
                        await record_performance_metric(
                            'memory_consultation_speed',
                            execution_time,
                            'ms',
                            'memory_coordinator'
                        )
                    
                    return result
                    
                except Exception as error:
                    execution_time = (time.time() - start_time) * 1000
                    
                    if monitoring_integration.is_enabled:
                        await record_performance_metric(
                            'memory_consultation_error_time',
                            execution_time,
                            'ms',
                            'memory_coordinator'
                        )
                    
                    raise
            
            CentralMemoryCoordinator.coordinate_memory_consultation = monitored_coordinate_memory_consultation
            self.instrumented_components.add('memory_coordinator')
            
            logger.info("✅ [MONITORING INTEGRATION] Memory Coordinator instrumented")
            
        except Exception as error:
            logger.error(f"❌ [MONITORING INTEGRATION] Memory Coordinator instrumentation failed: {error}")
    
    async def _instrument_crosscheck_system(self):
        """Instrument Crosscheck System with monitoring"""
        try:
            from central_hub.crosscheck_system import IntelligentCrosscheckSystem
            
            # Monkey patch the analyze_new_information method
            original_method = IntelligentCrosscheckSystem.analyze_new_information
            
            async def monitored_analyze_new_information(self, new_info: str, similar_memories: list, context: Dict[str, Any] = None):
                start_time = time.time()
                
                try:
                    result = await original_method(self, new_info, similar_memories, context)
                    execution_time = (time.time() - start_time) * 1000
                    
                    # Record metrics
                    if monitoring_integration.is_enabled:
                        await record_performance_metric(
                            'crosscheck_analysis_time',
                            execution_time,
                            'ms',
                            'crosscheck_system'
                        )
                    
                    return result
                    
                except Exception as error:
                    execution_time = (time.time() - start_time) * 1000
                    
                    if monitoring_integration.is_enabled:
                        await record_performance_metric(
                            'crosscheck_analysis_error_time',
                            execution_time,
                            'ms',
                            'crosscheck_system'
                        )
                    
                    raise
            
            IntelligentCrosscheckSystem.analyze_new_information = monitored_analyze_new_information
            self.instrumented_components.add('crosscheck_system')
            
            logger.info("✅ [MONITORING INTEGRATION] Crosscheck System instrumented")
            
        except Exception as error:
            logger.error(f"❌ [MONITORING INTEGRATION] Crosscheck System instrumentation failed: {error}")
    
    async def _instrument_crawl4ai_strategies(self):
        """Instrument Crawl4AI Strategies with monitoring"""
        try:
            # Instrument Contextual Embeddings Strategy
            from crawl4ai_strategies.contextual_embeddings import ContextualEmbeddingsStrategy
            
            original_method = ContextualEmbeddingsStrategy.generate_contextual_embeddings
            
            async def monitored_generate_contextual_embeddings(self, content: str, context: Dict[str, Any]):
                start_time = time.time()
                
                try:
                    result = await original_method(self, content, context)
                    execution_time = (time.time() - start_time) * 1000
                    
                    if monitoring_integration.is_enabled:
                        await record_performance_metric(
                            'contextual_embeddings_time',
                            execution_time,
                            'ms',
                            'crawl4ai_strategies'
                        )
                    
                    return result
                    
                except Exception as error:
                    execution_time = (time.time() - start_time) * 1000
                    
                    if monitoring_integration.is_enabled:
                        await record_performance_metric(
                            'contextual_embeddings_error_time',
                            execution_time,
                            'ms',
                            'crawl4ai_strategies'
                        )
                    
                    raise
            
            ContextualEmbeddingsStrategy.generate_contextual_embeddings = monitored_generate_contextual_embeddings
            self.instrumented_components.add('crawl4ai_strategies')
            
            logger.info("✅ [MONITORING INTEGRATION] Crawl4AI Strategies instrumented")
            
        except Exception as error:
            logger.error(f"❌ [MONITORING INTEGRATION] Crawl4AI Strategies instrumentation failed: {error}")
    
    async def _instrument_ecl_pipeline(self):
        """Instrument ECL Pipeline with monitoring"""
        try:
            from cognee_ecl_pipeline.ecl_pipeline import CogneeECLPipeline
            
            # Monkey patch the execute_ecl_pipeline method
            original_method = CogneeECLPipeline.execute_ecl_pipeline
            
            async def monitored_execute_ecl_pipeline(self, content: str, pipeline_id: str, context: Dict[str, Any]):
                start_time = time.time()
                
                try:
                    result = await original_method(self, content, pipeline_id, context)
                    execution_time = (time.time() - start_time) * 1000
                    
                    # Record metrics
                    if monitoring_integration.is_enabled:
                        await record_performance_metric(
                            'ecl_pipeline_performance',
                            execution_time,
                            'ms',
                            'ecl_pipeline'
                        )
                    
                    return result
                    
                except Exception as error:
                    execution_time = (time.time() - start_time) * 1000
                    
                    if monitoring_integration.is_enabled:
                        await record_performance_metric(
                            'ecl_pipeline_error_time',
                            execution_time,
                            'ms',
                            'ecl_pipeline'
                        )
                    
                    raise
            
            CogneeECLPipeline.execute_ecl_pipeline = monitored_execute_ecl_pipeline
            self.instrumented_components.add('ecl_pipeline')
            
            logger.info("✅ [MONITORING INTEGRATION] ECL Pipeline instrumented")
            
        except Exception as error:
            logger.error(f"❌ [MONITORING INTEGRATION] ECL Pipeline instrumentation failed: {error}")
    
    async def record_api_reduction_metric(self, before_count: int, after_count: int):
        """Record API reduction metric"""
        if not self.is_enabled:
            return
        
        reduction_rate = ((before_count - after_count) / before_count) * 100 if before_count > 0 else 0
        
        await record_performance_metric(
            'api_reduction_rate',
            reduction_rate,
            '%',
            'system'
        )
    
    async def record_success_rate_metric(self, successful_operations: int, total_operations: int):
        """Record success rate metric"""
        if not self.is_enabled:
            return
        
        success_rate = (successful_operations / total_operations) * 100 if total_operations > 0 else 0
        
        await record_performance_metric(
            'success_rate',
            success_rate,
            '%',
            'system'
        )
    
    async def record_error_rate_metric(self, error_count: int, total_operations: int):
        """Record error rate metric"""
        if not self.is_enabled:
            return
        
        error_rate = (error_count / total_operations) * 100 if total_operations > 0 else 0
        
        await record_performance_metric(
            'error_rate',
            error_rate,
            '%',
            'system'
        )
    
    async def get_monitoring_status(self) -> Dict[str, Any]:
        """Get monitoring integration status"""
        monitor_status = await production_monitor.get_monitoring_status()
        
        return {
            'integration_enabled': self.is_enabled,
            'instrumented_components': list(self.instrumented_components),
            'monitor_status': monitor_status
        }

# Global monitoring integration instance
monitoring_integration = MonitoringIntegration()

async def start_monitoring_integration():
    """Start monitoring integration (convenience function)"""
    return await monitoring_integration.enable_monitoring()

async def stop_monitoring_integration():
    """Stop monitoring integration (convenience function)"""
    await monitoring_integration.disable_monitoring()

async def record_api_reduction(before_count: int, after_count: int):
    """Record API reduction metric (convenience function)"""
    await monitoring_integration.record_api_reduction_metric(before_count, after_count)

async def record_success_rate(successful: int, total: int):
    """Record success rate metric (convenience function)"""
    await monitoring_integration.record_success_rate_metric(successful, total)

async def record_error_rate(errors: int, total: int):
    """Record error rate metric (convenience function)"""
    await monitoring_integration.record_error_rate_metric(errors, total)

if __name__ == "__main__":
    async def main():
        print("🚀 [MONITORING INTEGRATION] Starting monitoring integration test...")
        
        # Start monitoring integration
        monitor_task = await start_monitoring_integration()
        
        print("✅ [MONITORING INTEGRATION] Integration started")
        print("🔍 [MONITORING INTEGRATION] Monitoring for 60 seconds...")
        
        # Monitor for 60 seconds
        await asyncio.sleep(60)
        
        # Stop monitoring
        await stop_monitoring_integration()
        
        print("🛑 [MONITORING INTEGRATION] Integration stopped")
    
    asyncio.run(main())
