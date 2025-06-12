#!/usr/bin/env python3

"""
PRODUCTION MONITORING SYSTEM V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Sistema de monitoring de produção em tempo real para Native RAG System V1.0.
Inclui dashboard de métricas, alertas de performance, logging estruturado e baselines.
"""

import asyncio
import json
import time
import logging
from datetime import datetime, timedelta
from pathlib import Path
from typing import Dict, Any, List, Optional
from dataclasses import dataclass, asdict
import threading
import queue
import statistics

# Configure structured logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

@dataclass
class PerformanceMetric:
    """Performance metric data structure"""
    timestamp: str
    metric_name: str
    value: float
    unit: str
    component: str
    status: str  # 'normal', 'warning', 'critical'
    threshold_exceeded: bool = False

@dataclass
class SystemAlert:
    """System alert data structure"""
    timestamp: str
    alert_type: str  # 'performance', 'error', 'threshold'
    severity: str    # 'low', 'medium', 'high', 'critical'
    component: str
    message: str
    metric_value: Optional[float] = None
    threshold_value: Optional[float] = None

class ProductionMonitor:
    """
    Sistema de monitoring de produção em tempo real
    """
    
    def __init__(self):
        self.monitoring_dir = Path(__file__).parent
        self.metrics_file = self.monitoring_dir / 'metrics_log.jsonl'
        self.alerts_file = self.monitoring_dir / 'alerts_log.jsonl'
        self.dashboard_file = self.monitoring_dir / 'dashboard_data.json'
        
        # Performance baselines (from FASE 1 results)
        self.baselines = {
            'bridge_reuse_rate': {'target': 85, 'warning': 70, 'critical': 50},
            'api_reduction_rate': {'target': 25, 'warning': 20, 'critical': 15},
            'memory_consultation_speed': {'target': 100, 'warning': 200, 'critical': 500},  # ms
            'crosscheck_analysis_time': {'target': 50, 'warning': 100, 'critical': 200},   # ms
            'ecl_pipeline_performance': {'target': 100, 'warning': 200, 'critical': 400},  # ms
            'embedding_service_time': {'target': 200, 'warning': 300, 'critical': 500},    # ms
            'knowledge_graph_time': {'target': 100, 'warning': 150, 'critical': 300},      # ms
            'success_rate': {'target': 90, 'warning': 80, 'critical': 70},                 # %
            'error_rate': {'target': 5, 'warning': 10, 'critical': 20}                     # %
        }
        
        # Monitoring state
        self.is_monitoring = False
        self.metrics_queue = queue.Queue()
        self.alerts_queue = queue.Queue()
        self.current_metrics = {}
        self.alert_history = []
        
        # Performance tracking
        self.metric_history = {metric: [] for metric in self.baselines.keys()}
        self.monitoring_start_time = None
        
        logger.info("🔍 [PRODUCTION MONITOR] Production monitoring system initialized")
    
    async def start_monitoring(self):
        """Start production monitoring"""
        print("🚀 [PRODUCTION MONITOR] Starting production monitoring...")
        
        self.is_monitoring = True
        self.monitoring_start_time = datetime.now()
        
        # Create monitoring directory if it doesn't exist
        self.monitoring_dir.mkdir(exist_ok=True)
        
        # Start monitoring tasks
        monitoring_tasks = [
            asyncio.create_task(self._metrics_collector()),
            asyncio.create_task(self._alert_processor()),
            asyncio.create_task(self._dashboard_updater()),
            asyncio.create_task(self._performance_analyzer())
        ]
        
        print("✅ [PRODUCTION MONITOR] Monitoring started successfully")
        print(f"📊 Dashboard available at: {self.dashboard_file}")
        print(f"📈 Metrics logged to: {self.metrics_file}")
        print(f"🚨 Alerts logged to: {self.alerts_file}")
        
        try:
            await asyncio.gather(*monitoring_tasks)
        except KeyboardInterrupt:
            print("\n🛑 [PRODUCTION MONITOR] Monitoring stopped by user")
        finally:
            await self.stop_monitoring()
    
    async def stop_monitoring(self):
        """Stop production monitoring"""
        self.is_monitoring = False
        print("🛑 [PRODUCTION MONITOR] Production monitoring stopped")
    
    async def record_metric(self, metric_name: str, value: float, unit: str, component: str):
        """Record a performance metric"""
        if not self.is_monitoring:
            return
        
        # Determine status based on baselines
        status = self._evaluate_metric_status(metric_name, value)
        threshold_exceeded = status in ['warning', 'critical']
        
        metric = PerformanceMetric(
            timestamp=datetime.now().isoformat(),
            metric_name=metric_name,
            value=value,
            unit=unit,
            component=component,
            status=status,
            threshold_exceeded=threshold_exceeded
        )
        
        # Add to queue for processing
        self.metrics_queue.put(metric)
        
        # Update current metrics
        self.current_metrics[metric_name] = metric
        
        # Add to history
        if metric_name in self.metric_history:
            self.metric_history[metric_name].append({
                'timestamp': metric.timestamp,
                'value': value,
                'status': status
            })
            
            # Keep only last 100 entries
            if len(self.metric_history[metric_name]) > 100:
                self.metric_history[metric_name] = self.metric_history[metric_name][-100:]
        
        # Generate alert if threshold exceeded
        if threshold_exceeded:
            await self._generate_alert(metric)
    
    def _evaluate_metric_status(self, metric_name: str, value: float) -> str:
        """Evaluate metric status against baselines"""
        if metric_name not in self.baselines:
            return 'normal'
        
        baseline = self.baselines[metric_name]
        
        # For rates and percentages (higher is better)
        if metric_name in ['bridge_reuse_rate', 'api_reduction_rate', 'success_rate']:
            if value >= baseline['target']:
                return 'normal'
            elif value >= baseline['warning']:
                return 'warning'
            else:
                return 'critical'
        
        # For times and error rates (lower is better)
        else:
            if value <= baseline['target']:
                return 'normal'
            elif value <= baseline['warning']:
                return 'warning'
            else:
                return 'critical'
    
    async def _generate_alert(self, metric: PerformanceMetric):
        """Generate alert for threshold exceeded"""
        baseline = self.baselines.get(metric.metric_name, {})
        
        severity = 'medium' if metric.status == 'warning' else 'high'
        threshold_value = baseline.get('warning' if metric.status == 'warning' else 'critical')
        
        alert = SystemAlert(
            timestamp=datetime.now().isoformat(),
            alert_type='threshold',
            severity=severity,
            component=metric.component,
            message=f"{metric.metric_name} exceeded {metric.status} threshold: {metric.value}{metric.unit}",
            metric_value=metric.value,
            threshold_value=threshold_value
        )
        
        self.alerts_queue.put(alert)
        self.alert_history.append(alert)
        
        # Keep only last 50 alerts
        if len(self.alert_history) > 50:
            self.alert_history = self.alert_history[-50:]
        
        logger.warning(f"🚨 [ALERT] {alert.message}")
    
    async def _metrics_collector(self):
        """Collect and log metrics"""
        while self.is_monitoring:
            try:
                # Process metrics queue
                while not self.metrics_queue.empty():
                    metric = self.metrics_queue.get_nowait()
                    
                    # Log to file
                    with open(self.metrics_file, 'a') as f:
                        f.write(json.dumps(asdict(metric)) + '\n')
                
                await asyncio.sleep(1)  # Check every second
                
            except Exception as error:
                logger.error(f"❌ [METRICS COLLECTOR] Error: {error}")
                await asyncio.sleep(5)
    
    async def _alert_processor(self):
        """Process and log alerts"""
        while self.is_monitoring:
            try:
                # Process alerts queue
                while not self.alerts_queue.empty():
                    alert = self.alerts_queue.get_nowait()
                    
                    # Log to file
                    with open(self.alerts_file, 'a') as f:
                        f.write(json.dumps(asdict(alert)) + '\n')
                    
                    # Print critical alerts immediately
                    if alert.severity == 'high':
                        print(f"🚨 CRITICAL ALERT: {alert.message}")
                
                await asyncio.sleep(2)  # Check every 2 seconds
                
            except Exception as error:
                logger.error(f"❌ [ALERT PROCESSOR] Error: {error}")
                await asyncio.sleep(5)
    
    async def _dashboard_updater(self):
        """Update dashboard data"""
        while self.is_monitoring:
            try:
                # Calculate dashboard metrics
                dashboard_data = await self._generate_dashboard_data()
                
                # Save to file
                with open(self.dashboard_file, 'w') as f:
                    json.dump(dashboard_data, f, indent=2, default=str)
                
                await asyncio.sleep(10)  # Update every 10 seconds
                
            except Exception as error:
                logger.error(f"❌ [DASHBOARD UPDATER] Error: {error}")
                await asyncio.sleep(10)
    
    async def _performance_analyzer(self):
        """Analyze performance trends"""
        while self.is_monitoring:
            try:
                # Analyze trends every 30 seconds
                await self._analyze_performance_trends()
                await asyncio.sleep(30)
                
            except Exception as error:
                logger.error(f"❌ [PERFORMANCE ANALYZER] Error: {error}")
                await asyncio.sleep(30)
    
    async def _generate_dashboard_data(self) -> Dict[str, Any]:
        """Generate dashboard data"""
        current_time = datetime.now()
        uptime = (current_time - self.monitoring_start_time).total_seconds() if self.monitoring_start_time else 0
        
        # Calculate summary statistics
        summary_stats = {}
        for metric_name, history in self.metric_history.items():
            if history:
                values = [entry['value'] for entry in history[-10:]]  # Last 10 values
                summary_stats[metric_name] = {
                    'current': values[-1] if values else 0,
                    'average': statistics.mean(values) if values else 0,
                    'min': min(values) if values else 0,
                    'max': max(values) if values else 0,
                    'trend': 'stable'  # Could implement trend analysis
                }
        
        # Count alerts by severity
        recent_alerts = [a for a in self.alert_history if 
                        datetime.fromisoformat(a.timestamp) > current_time - timedelta(hours=1)]
        
        alert_counts = {
            'total': len(recent_alerts),
            'critical': len([a for a in recent_alerts if a.severity == 'high']),
            'warning': len([a for a in recent_alerts if a.severity == 'medium']),
            'low': len([a for a in recent_alerts if a.severity == 'low'])
        }
        
        return {
            'timestamp': current_time.isoformat(),
            'uptime_seconds': uptime,
            'system_status': self._calculate_system_status(),
            'current_metrics': {name: asdict(metric) for name, metric in self.current_metrics.items()},
            'summary_statistics': summary_stats,
            'alert_counts': alert_counts,
            'recent_alerts': [asdict(a) for a in self.alert_history[-5:]],  # Last 5 alerts
            'baselines': self.baselines,
            'monitoring_config': {
                'metrics_tracked': len(self.baselines),
                'update_interval': '10s',
                'retention_period': '100 entries per metric'
            }
        }
    
    def _calculate_system_status(self) -> str:
        """Calculate overall system status"""
        if not self.current_metrics:
            return 'unknown'
        
        critical_count = sum(1 for metric in self.current_metrics.values() if metric.status == 'critical')
        warning_count = sum(1 for metric in self.current_metrics.values() if metric.status == 'warning')
        
        if critical_count > 0:
            return 'critical'
        elif warning_count > 0:
            return 'warning'
        else:
            return 'healthy'
    
    async def _analyze_performance_trends(self):
        """Analyze performance trends and generate insights"""
        # This could be expanded with more sophisticated trend analysis
        for metric_name, history in self.metric_history.items():
            if len(history) >= 5:
                recent_values = [entry['value'] for entry in history[-5:]]
                
                # Simple trend detection
                if len(set(recent_values)) == 1:
                    trend = 'stable'
                elif recent_values[-1] > recent_values[0]:
                    trend = 'increasing'
                else:
                    trend = 'decreasing'
                
                # Could generate trend alerts here
                logger.debug(f"📈 [TREND] {metric_name}: {trend}")
    
    async def get_monitoring_status(self) -> Dict[str, Any]:
        """Get current monitoring status"""
        return {
            'is_monitoring': self.is_monitoring,
            'uptime': (datetime.now() - self.monitoring_start_time).total_seconds() if self.monitoring_start_time else 0,
            'metrics_tracked': len(self.current_metrics),
            'alerts_generated': len(self.alert_history),
            'system_status': self._calculate_system_status()
        }

# Global monitor instance
production_monitor = ProductionMonitor()

async def start_production_monitoring():
    """Start production monitoring (convenience function)"""
    await production_monitor.start_monitoring()

async def record_performance_metric(metric_name: str, value: float, unit: str, component: str):
    """Record performance metric (convenience function)"""
    await production_monitor.record_metric(metric_name, value, unit, component)

async def main():
    """Main function for testing monitoring system"""
    print("🚀 [PRODUCTION MONITOR] Starting monitoring system test...")

    # Start monitoring in background
    monitor_task = asyncio.create_task(production_monitor.start_monitoring())

    # Simulate some metrics for testing
    await asyncio.sleep(2)

    # Record test metrics
    await record_performance_metric('bridge_reuse_rate', 100.0, '%', 'js_bridge')
    await record_performance_metric('memory_consultation_speed', 1.4, 'ms', 'memory_coordinator')
    await record_performance_metric('embedding_service_time', 161.0, 'ms', 'embedding_service')
    await record_performance_metric('knowledge_graph_time', 74.7, 'ms', 'knowledge_graph')

    print("📊 [PRODUCTION MONITOR] Test metrics recorded")
    print("🔍 [PRODUCTION MONITOR] Monitoring for 30 seconds...")

    # Monitor for 30 seconds
    await asyncio.sleep(30)

    # Stop monitoring
    await production_monitor.stop_monitoring()

    # Show final status
    status = await production_monitor.get_monitoring_status()
    print(f"📈 [PRODUCTION MONITOR] Final status: {status}")

if __name__ == "__main__":
    asyncio.run(main())
