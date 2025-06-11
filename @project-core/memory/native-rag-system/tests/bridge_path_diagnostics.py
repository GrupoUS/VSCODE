#!/usr/bin/env python3

"""
BRIDGE PATH DIAGNOSTICS V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Diagnóstico completo dos paths JavaScript para resolver bridge reuse rate.
Identifica problemas de path e cria soluções para melhorar performance.
"""

import asyncio
import json
import logging
import os
import subprocess
import time
from pathlib import Path
from typing import Dict, Any, List
import sys

# Add parent directory for imports
sys.path.append(str(Path(__file__).parent.parent))

from integration.js_bridge import JavaScriptBridge

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class BridgePathDiagnostics:
    """
    Diagnóstico completo dos paths JavaScript para bridge pattern
    """
    
    def __init__(self):
        self.js_bridge = JavaScriptBridge()
        self.memory_dir = Path.cwd() / '@project-core' / 'memory'
        
        # Expected JavaScript components
        self.expected_components = {
            'embedding_service': './rag-enhanced/contextual-embeddings/embedding-service.js',
            'knowledge_graph': './rag-enhanced/knowledge-graph/knowledge-graph-foundation.js',
            'consultation_optimization': './protocols/consultation-optimization.js'
        }
        
        # Test results
        self.diagnostics_results = {
            'path_analysis': {},
            'file_existence': {},
            'node_js_availability': False,
            'component_loading': {},
            'method_testing': {},
            'performance_metrics': {},
            'recommendations': []
        }
        
        logger.info("🔍 [BRIDGE DIAGNOSTICS] Bridge Path Diagnostics initialized")
    
    async def run_complete_diagnostics(self):
        """Execute complete bridge path diagnostics"""
        print("🚀 [BRIDGE DIAGNOSTICS] Starting Complete Bridge Path Diagnostics...")
        
        start_time = time.time()
        
        try:
            # Phase 1: Path Analysis
            await self._analyze_paths()
            
            # Phase 2: File Existence Check
            await self._check_file_existence()
            
            # Phase 3: Node.js Availability
            await self._check_node_js_availability()
            
            # Phase 4: Component Loading Test
            await self._test_component_loading()
            
            # Phase 5: Method Testing
            await self._test_component_methods()
            
            # Phase 6: Performance Analysis
            await self._analyze_performance()
            
            # Phase 7: Generate Recommendations
            await self._generate_recommendations()
            
            # Generate final report
            total_time = time.time() - start_time
            await self._generate_diagnostics_report(total_time)
            
            print(f"\n✅ [BRIDGE DIAGNOSTICS] Complete diagnostics finished in {total_time:.2f}s")
            return self.diagnostics_results
            
        except Exception as error:
            print(f"❌ [BRIDGE DIAGNOSTICS] Diagnostics failed: {error}")
            self.diagnostics_results['error'] = str(error)
            return self.diagnostics_results
    
    async def _analyze_paths(self):
        """Analyze JavaScript component paths"""
        print("\n📋 Phase 1: Path Analysis")
        
        try:
            for component_name, relative_path in self.expected_components.items():
                # Calculate absolute path
                absolute_path = self.memory_dir / relative_path
                
                # Normalize path
                normalized_path = str(absolute_path).replace('\\', '/')
                
                # Check if path exists
                path_exists = absolute_path.exists()
                
                # Store analysis
                self.diagnostics_results['path_analysis'][component_name] = {
                    'relative_path': relative_path,
                    'absolute_path': str(absolute_path),
                    'normalized_path': normalized_path,
                    'path_exists': path_exists,
                    'memory_dir': str(self.memory_dir)
                }
                
                print(f"  📁 {component_name}:")
                print(f"     Relative: {relative_path}")
                print(f"     Absolute: {absolute_path}")
                print(f"     Exists: {'✅' if path_exists else '❌'}")
            
            print(f"✅ Path Analysis completed")
            
        except Exception as error:
            print(f"❌ Path Analysis failed: {error}")
            self.diagnostics_results['path_analysis']['error'] = str(error)
    
    async def _check_file_existence(self):
        """Check if JavaScript files exist and are readable"""
        print("\n📂 Phase 2: File Existence Check")
        
        try:
            for component_name, relative_path in self.expected_components.items():
                file_path = self.memory_dir / relative_path
                
                file_info = {
                    'exists': file_path.exists(),
                    'is_file': file_path.is_file() if file_path.exists() else False,
                    'is_readable': os.access(file_path, os.R_OK) if file_path.exists() else False,
                    'size_bytes': file_path.stat().st_size if file_path.exists() else 0,
                    'permissions': oct(file_path.stat().st_mode)[-3:] if file_path.exists() else 'N/A'
                }
                
                # Try to read first few lines
                if file_info['exists'] and file_info['is_readable']:
                    try:
                        with open(file_path, 'r', encoding='utf-8') as f:
                            first_lines = [f.readline().strip() for _ in range(3)]
                            file_info['first_lines'] = first_lines
                            file_info['appears_valid'] = any('module.exports' in line or 'class' in line for line in first_lines)
                    except Exception as read_error:
                        file_info['read_error'] = str(read_error)
                
                self.diagnostics_results['file_existence'][component_name] = file_info
                
                print(f"  📄 {component_name}:")
                print(f"     Exists: {'✅' if file_info['exists'] else '❌'}")
                print(f"     Readable: {'✅' if file_info['is_readable'] else '❌'}")
                print(f"     Size: {file_info['size_bytes']} bytes")
                if file_info.get('appears_valid'):
                    print(f"     Valid JS: ✅")
            
            print(f"✅ File Existence Check completed")
            
        except Exception as error:
            print(f"❌ File Existence Check failed: {error}")
            self.diagnostics_results['file_existence']['error'] = str(error)
    
    async def _check_node_js_availability(self):
        """Check Node.js availability and version"""
        print("\n🟢 Phase 3: Node.js Availability")
        
        try:
            # Test Node.js availability
            result = subprocess.run(['node', '--version'], capture_output=True, text=True, timeout=10)
            
            if result.returncode == 0:
                node_version = result.stdout.strip()
                self.diagnostics_results['node_js_availability'] = True
                print(f"  ✅ Node.js available: {node_version}")
                
                # Test basic JavaScript execution
                test_js = "console.log(JSON.stringify({success: true, message: 'Node.js working'}));"
                test_result = subprocess.run(['node', '-e', test_js], capture_output=True, text=True, timeout=10)
                
                if test_result.returncode == 0:
                    print(f"  ✅ JavaScript execution working")
                    self.diagnostics_results['node_js_execution'] = True
                else:
                    print(f"  ❌ JavaScript execution failed: {test_result.stderr}")
                    self.diagnostics_results['node_js_execution'] = False
            else:
                print(f"  ❌ Node.js not available: {result.stderr}")
                self.diagnostics_results['node_js_availability'] = False
            
        except subprocess.TimeoutExpired:
            print(f"  ❌ Node.js check timed out")
            self.diagnostics_results['node_js_availability'] = False
        except FileNotFoundError:
            print(f"  ❌ Node.js not found in PATH")
            self.diagnostics_results['node_js_availability'] = False
        except Exception as error:
            print(f"  ❌ Node.js check failed: {error}")
            self.diagnostics_results['node_js_availability'] = False
    
    async def _test_component_loading(self):
        """Test loading of JavaScript components"""
        print("\n🔧 Phase 4: Component Loading Test")
        
        try:
            for component_name, relative_path in self.expected_components.items():
                component_path = self.memory_dir / relative_path
                
                if not component_path.exists():
                    self.diagnostics_results['component_loading'][component_name] = {
                        'loadable': False,
                        'error': 'File does not exist'
                    }
                    print(f"  ❌ {component_name}: File does not exist")
                    continue
                
                # Test component loading with Node.js
                test_js = f"""
                try {{
                    const component = require('{str(component_path).replace(chr(92), '/')}');
                    console.log(JSON.stringify({{
                        success: true,
                        componentType: typeof component,
                        isFunction: typeof component === 'function',
                        isObject: typeof component === 'object',
                        hasConstructor: component && typeof component.constructor === 'function',
                        methods: component && typeof component === 'object' ? Object.getOwnPropertyNames(component) : []
                    }}));
                }} catch (error) {{
                    console.log(JSON.stringify({{
                        success: false,
                        error: error.message,
                        stack: error.stack
                    }}));
                }}
                """
                
                try:
                    result = subprocess.run(
                        ['node', '-e', test_js],
                        capture_output=True,
                        text=True,
                        timeout=15,
                        cwd=self.memory_dir
                    )
                    
                    if result.returncode == 0 and result.stdout.strip():
                        try:
                            load_result = json.loads(result.stdout.strip())
                            self.diagnostics_results['component_loading'][component_name] = load_result
                            
                            if load_result.get('success'):
                                print(f"  ✅ {component_name}: Loaded successfully")
                                print(f"     Type: {load_result.get('componentType')}")
                                if load_result.get('methods'):
                                    print(f"     Methods: {load_result.get('methods')[:5]}")  # Show first 5 methods
                            else:
                                print(f"  ❌ {component_name}: Load failed - {load_result.get('error')}")
                        except json.JSONDecodeError:
                            print(f"  ❌ {component_name}: Invalid JSON response")
                            self.diagnostics_results['component_loading'][component_name] = {
                                'loadable': False,
                                'error': 'Invalid JSON response',
                                'raw_output': result.stdout
                            }
                    else:
                        print(f"  ❌ {component_name}: Node.js execution failed")
                        print(f"     Error: {result.stderr}")
                        self.diagnostics_results['component_loading'][component_name] = {
                            'loadable': False,
                            'error': result.stderr,
                            'returncode': result.returncode
                        }
                
                except subprocess.TimeoutExpired:
                    print(f"  ❌ {component_name}: Loading test timed out")
                    self.diagnostics_results['component_loading'][component_name] = {
                        'loadable': False,
                        'error': 'Timeout'
                    }
                except Exception as load_error:
                    print(f"  ❌ {component_name}: Loading test failed - {load_error}")
                    self.diagnostics_results['component_loading'][component_name] = {
                        'loadable': False,
                        'error': str(load_error)
                    }
            
            print(f"✅ Component Loading Test completed")
            
        except Exception as error:
            print(f"❌ Component Loading Test failed: {error}")
            self.diagnostics_results['component_loading']['error'] = str(error)
    
    async def _test_component_methods(self):
        """Test specific methods on loaded components"""
        print("\n🧪 Phase 5: Method Testing")
        
        try:
            # Test embedding service
            if self.diagnostics_results['component_loading'].get('embedding_service', {}).get('success'):
                await self._test_embedding_service_methods()
            
            # Test knowledge graph
            if self.diagnostics_results['component_loading'].get('knowledge_graph', {}).get('success'):
                await self._test_knowledge_graph_methods()
            
            print(f"✅ Method Testing completed")
            
        except Exception as error:
            print(f"❌ Method Testing failed: {error}")
            self.diagnostics_results['method_testing']['error'] = str(error)
    
    async def _test_embedding_service_methods(self):
        """Test embedding service methods"""
        try:
            component_path = self.memory_dir / self.expected_components['embedding_service']
            
            test_js = f"""
            try {{
                const EmbeddingService = require('{str(component_path).replace(chr(92), '/')}');
                const service = new EmbeddingService();
                
                // Test generateContextualEmbedding method
                service.generateContextualEmbedding('test content', {{}})
                    .then(result => {{
                        console.log(JSON.stringify({{
                            success: true,
                            method: 'generateContextualEmbedding',
                            resultType: typeof result,
                            hasEmbedding: result && result.embedding !== undefined,
                            embeddingLength: result && result.embedding ? result.embedding.length : 0
                        }}));
                    }})
                    .catch(error => {{
                        console.log(JSON.stringify({{
                            success: false,
                            method: 'generateContextualEmbedding',
                            error: error.message
                        }}));
                    }});
            }} catch (error) {{
                console.log(JSON.stringify({{
                    success: false,
                    error: error.message
                }}));
            }}
            """
            
            result = subprocess.run(
                ['node', '-e', test_js],
                capture_output=True,
                text=True,
                timeout=20,
                cwd=self.memory_dir
            )
            
            if result.returncode == 0 and result.stdout.strip():
                method_result = json.loads(result.stdout.strip())
                self.diagnostics_results['method_testing']['embedding_service'] = method_result
                
                if method_result.get('success'):
                    print(f"  ✅ embedding_service.generateContextualEmbedding: Working")
                    print(f"     Embedding length: {method_result.get('embeddingLength')}")
                else:
                    print(f"  ❌ embedding_service.generateContextualEmbedding: {method_result.get('error')}")
            else:
                print(f"  ❌ embedding_service method test failed: {result.stderr}")
                
        except Exception as error:
            print(f"  ❌ Embedding service method test failed: {error}")
    
    async def _test_knowledge_graph_methods(self):
        """Test knowledge graph methods"""
        try:
            component_path = self.memory_dir / self.expected_components['knowledge_graph']
            
            test_js = f"""
            try {{
                const KnowledgeGraph = require('{str(component_path).replace(chr(92), '/')}');
                const graph = new KnowledgeGraph();
                
                // Test extractEntities method
                const entities = await graph.extractEntities('test content with React and JavaScript');
                
                console.log(JSON.stringify({{
                    success: true,
                    method: 'extractEntities',
                    entitiesCount: entities ? entities.length : 0,
                    hasEntities: entities && entities.length > 0
                }}));
            }} catch (error) {{
                console.log(JSON.stringify({{
                    success: false,
                    method: 'extractEntities',
                    error: error.message
                }}));
            }}
            """
            
            result = subprocess.run(
                ['node', '-e', test_js],
                capture_output=True,
                text=True,
                timeout=20,
                cwd=self.memory_dir
            )
            
            if result.returncode == 0 and result.stdout.strip():
                method_result = json.loads(result.stdout.strip())
                self.diagnostics_results['method_testing']['knowledge_graph'] = method_result
                
                if method_result.get('success'):
                    print(f"  ✅ knowledge_graph.extractEntities: Working")
                    print(f"     Entities extracted: {method_result.get('entitiesCount')}")
                else:
                    print(f"  ❌ knowledge_graph.extractEntities: {method_result.get('error')}")
            else:
                print(f"  ❌ knowledge_graph method test failed: {result.stderr}")
                
        except Exception as error:
            print(f"  ❌ Knowledge graph method test failed: {error}")
    
    async def _analyze_performance(self):
        """Analyze bridge performance with current setup"""
        print("\n⚡ Phase 6: Performance Analysis")
        
        try:
            # Test current bridge performance
            start_time = time.time()
            
            # Test bridge health check
            health_result = await self.js_bridge.health_check()
            health_time = (time.time() - start_time) * 1000
            
            # Test component calls
            call_times = []
            for component in ['embedding_service', 'knowledge_graph']:
                try:
                    call_start = time.time()
                    await self.js_bridge.call_js_component(component, 'test', [])
                    call_time = (time.time() - call_start) * 1000
                    call_times.append(call_time)
                except:
                    call_times.append(-1)  # Failed call
            
            # Get bridge metrics
            bridge_metrics = self.js_bridge.get_metrics()
            
            self.diagnostics_results['performance_metrics'] = {
                'health_check_time_ms': health_time,
                'health_status': health_result.get('status'),
                'component_call_times_ms': call_times,
                'bridge_metrics': bridge_metrics,
                'fallback_rate': bridge_metrics.get('fallback_count', 0) / max(bridge_metrics.get('total_calls', 1), 1) * 100
            }
            
            print(f"  📊 Health check: {health_time:.1f}ms - {health_result.get('status')}")
            print(f"  📊 Component calls: {[f'{t:.1f}ms' if t > 0 else 'Failed' for t in call_times]}")
            print(f"  📊 Fallback rate: {self.diagnostics_results['performance_metrics']['fallback_rate']:.1f}%")
            
            print(f"✅ Performance Analysis completed")
            
        except Exception as error:
            print(f"❌ Performance Analysis failed: {error}")
            self.diagnostics_results['performance_metrics']['error'] = str(error)
    
    async def _generate_recommendations(self):
        """Generate recommendations based on diagnostics"""
        print("\n💡 Phase 7: Generating Recommendations")
        
        recommendations = []
        
        # Check Node.js availability
        if not self.diagnostics_results.get('node_js_availability'):
            recommendations.append({
                'priority': 'HIGH',
                'issue': 'Node.js not available',
                'solution': 'Install Node.js or ensure it is in PATH',
                'impact': 'Bridge pattern cannot function without Node.js'
            })
        
        # Check file existence
        missing_files = []
        for component, file_info in self.diagnostics_results.get('file_existence', {}).items():
            if isinstance(file_info, dict) and not file_info.get('exists'):
                missing_files.append(component)
        
        if missing_files:
            recommendations.append({
                'priority': 'HIGH',
                'issue': f'Missing JavaScript files: {missing_files}',
                'solution': 'Create missing JavaScript component files',
                'impact': 'Components cannot be loaded, forcing fallback mode'
            })
        
        # Check component loading
        failed_loads = []
        for component, load_info in self.diagnostics_results.get('component_loading', {}).items():
            if isinstance(load_info, dict) and not load_info.get('success'):
                failed_loads.append(component)
        
        if failed_loads:
            recommendations.append({
                'priority': 'MEDIUM',
                'issue': f'Component loading failed: {failed_loads}',
                'solution': 'Fix JavaScript syntax or dependency issues',
                'impact': 'Components load but may have runtime errors'
            })
        
        # Check performance
        fallback_rate = self.diagnostics_results.get('performance_metrics', {}).get('fallback_rate', 100)
        if fallback_rate > 50:
            recommendations.append({
                'priority': 'MEDIUM',
                'issue': f'High fallback rate: {fallback_rate:.1f}%',
                'solution': 'Fix component loading and method calling issues',
                'impact': 'Bridge reuse rate is low, performance not optimal'
            })
        
        # Success case
        if not recommendations:
            recommendations.append({
                'priority': 'INFO',
                'issue': 'No critical issues found',
                'solution': 'System appears to be working correctly',
                'impact': 'Bridge pattern should be functioning optimally'
            })
        
        self.diagnostics_results['recommendations'] = recommendations
        
        for rec in recommendations:
            priority_icon = {'HIGH': '🔴', 'MEDIUM': '🟡', 'LOW': '🟢', 'INFO': 'ℹ️'}.get(rec['priority'], '❓')
            print(f"  {priority_icon} {rec['priority']}: {rec['issue']}")
            print(f"     Solution: {rec['solution']}")
            print(f"     Impact: {rec['impact']}")
        
        print(f"✅ Recommendations generated")
    
    async def _generate_diagnostics_report(self, total_time: float):
        """Generate final diagnostics report"""
        print("\n📊 BRIDGE PATH DIAGNOSTICS REPORT")
        
        # Summary
        node_js_ok = self.diagnostics_results.get('node_js_availability', False)
        files_exist = all(
            info.get('exists', False) 
            for info in self.diagnostics_results.get('file_existence', {}).values()
            if isinstance(info, dict)
        )
        components_load = all(
            info.get('success', False)
            for info in self.diagnostics_results.get('component_loading', {}).values()
            if isinstance(info, dict)
        )
        
        print(f"📈 Summary:")
        print(f"   Node.js Available: {'✅' if node_js_ok else '❌'}")
        print(f"   Files Exist: {'✅' if files_exist else '❌'}")
        print(f"   Components Load: {'✅' if components_load else '❌'}")
        print(f"   Execution Time: {total_time:.2f}s")
        
        # Performance metrics
        perf = self.diagnostics_results.get('performance_metrics', {})
        if perf:
            print(f"\n⚡ Performance:")
            print(f"   Health Check: {perf.get('health_check_time_ms', 'N/A')}ms")
            print(f"   Fallback Rate: {perf.get('fallback_rate', 'N/A')}%")
        
        # Recommendations count
        recommendations = self.diagnostics_results.get('recommendations', [])
        high_priority = len([r for r in recommendations if r.get('priority') == 'HIGH'])
        medium_priority = len([r for r in recommendations if r.get('priority') == 'MEDIUM'])
        
        print(f"\n💡 Recommendations:")
        print(f"   High Priority: {high_priority}")
        print(f"   Medium Priority: {medium_priority}")
        
        # Store final results
        self.diagnostics_results['summary'] = {
            'node_js_available': node_js_ok,
            'files_exist': files_exist,
            'components_load': components_load,
            'execution_time': total_time,
            'high_priority_issues': high_priority,
            'medium_priority_issues': medium_priority
        }

async def main():
    """Run bridge path diagnostics"""
    diagnostics = BridgePathDiagnostics()
    results = await diagnostics.run_complete_diagnostics()
    
    # Save results to file
    results_file = Path(__file__).parent / 'bridge_diagnostics_results.json'
    with open(results_file, 'w') as f:
        json.dump(results, f, indent=2, default=str)
    
    print(f"\n💾 Results saved to: {results_file}")
    return results

if __name__ == "__main__":
    asyncio.run(main())
