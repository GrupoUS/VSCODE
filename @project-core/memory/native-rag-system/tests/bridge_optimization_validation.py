#!/usr/bin/env python3

"""
BRIDGE OPTIMIZATION VALIDATION V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Validação final das otimizações do bridge pattern para FASE 1.
"""

import asyncio
import json
import time
import sys
from pathlib import Path

# Add parent directory for imports
sys.path.append(str(Path(__file__).parent.parent))

from integration.js_bridge import JavaScriptBridge

async def validate_bridge_optimization():
    """Validate bridge optimization results"""
    print("🚀 [BRIDGE OPTIMIZATION VALIDATION] Starting validation...")
    
    # Create fresh bridge instance
    bridge = JavaScriptBridge()
    
    # Test metrics
    test_results = {
        'before_optimization': {
            'bridge_reuse_rate': 0,
            'fallback_rate': 100,
            'success_rate': 0,
            'components_working': 0
        },
        'after_optimization': {
            'bridge_reuse_rate': 0,
            'fallback_rate': 0,
            'success_rate': 0,
            'components_working': 0
        },
        'performance_improvement': {},
        'target_achievement': {}
    }
    
    print(f"\n📁 Bridge Configuration:")
    print(f"   Memory dir: {bridge.memory_dir}")
    print(f"   Components: {list(bridge.js_components.keys())}")
    
    # Test 1: Embedding Service Performance
    print(f"\n📋 Test 1: Embedding Service Performance")
    embedding_times = []
    embedding_successes = 0
    
    for i in range(3):
        try:
            start_time = time.time()
            result = await bridge.call_js_component(
                'embedding_service', 
                'generateContextualEmbedding', 
                [f'test content {i}', {}]
            )
            execution_time = (time.time() - start_time) * 1000
            embedding_times.append(execution_time)
            
            if isinstance(result, dict) and result.get('model') == 'text-embedding-3-large':
                embedding_successes += 1
                print(f"   ✅ Call {i+1}: {execution_time:.1f}ms - Model: {result.get('model')}")
            else:
                print(f"   ❌ Call {i+1}: {execution_time:.1f}ms - Fallback used")
                
        except Exception as error:
            print(f"   ❌ Call {i+1}: Failed - {error}")
    
    # Test 2: Knowledge Graph Performance
    print(f"\n📋 Test 2: Knowledge Graph Performance")
    kg_times = []
    kg_successes = 0
    
    for i in range(3):
        try:
            start_time = time.time()
            result = await bridge.call_js_component(
                'knowledge_graph', 
                'extractEntities', 
                [f'test content with React and JavaScript {i}']
            )
            execution_time = (time.time() - start_time) * 1000
            kg_times.append(execution_time)
            
            if isinstance(result, list) and len(result) > 0:
                kg_successes += 1
                print(f"   ✅ Call {i+1}: {execution_time:.1f}ms - Entities: {len(result)}")
            else:
                print(f"   ❌ Call {i+1}: {execution_time:.1f}ms - Fallback used")
                
        except Exception as error:
            print(f"   ❌ Call {i+1}: Failed - {error}")
    
    # Get final metrics
    final_metrics = bridge.get_metrics()
    
    # Calculate results
    total_calls = final_metrics.get('total_calls', 0)
    fallback_count = final_metrics.get('fallback_count', 0)
    success_rate = final_metrics.get('success_rate', 0)
    
    bridge_reuse_rate = ((total_calls - fallback_count) / total_calls * 100) if total_calls > 0 else 0
    fallback_rate = (fallback_count / total_calls * 100) if total_calls > 0 else 0
    
    # Update results
    test_results['after_optimization'] = {
        'bridge_reuse_rate': bridge_reuse_rate,
        'fallback_rate': fallback_rate,
        'success_rate': success_rate,
        'components_working': embedding_successes + kg_successes,
        'avg_embedding_time': sum(embedding_times) / len(embedding_times) if embedding_times else 0,
        'avg_kg_time': sum(kg_times) / len(kg_times) if kg_times else 0
    }
    
    # Performance improvement calculation
    test_results['performance_improvement'] = {
        'bridge_reuse_improvement': bridge_reuse_rate - test_results['before_optimization']['bridge_reuse_rate'],
        'fallback_reduction': test_results['before_optimization']['fallback_rate'] - fallback_rate,
        'success_rate_improvement': success_rate - test_results['before_optimization']['success_rate']
    }
    
    # Target achievement
    targets = {
        'bridge_reuse_rate': 85,  # Target ≥85%
        'fallback_rate': 15,      # Target ≤15%
        'success_rate': 90,       # Target ≥90%
        'avg_response_time': 100  # Target <100ms
    }
    
    avg_response_time = (
        test_results['after_optimization']['avg_embedding_time'] + 
        test_results['after_optimization']['avg_kg_time']
    ) / 2
    
    test_results['target_achievement'] = {
        'bridge_reuse_rate': {
            'target': targets['bridge_reuse_rate'],
            'achieved': bridge_reuse_rate,
            'met': bridge_reuse_rate >= targets['bridge_reuse_rate']
        },
        'fallback_rate': {
            'target': targets['fallback_rate'],
            'achieved': fallback_rate,
            'met': fallback_rate <= targets['fallback_rate']
        },
        'success_rate': {
            'target': targets['success_rate'],
            'achieved': success_rate,
            'met': success_rate >= targets['success_rate']
        },
        'avg_response_time': {
            'target': targets['avg_response_time'],
            'achieved': avg_response_time,
            'met': avg_response_time < targets['avg_response_time']
        }
    }
    
    # Generate report
    print(f"\n📊 BRIDGE OPTIMIZATION VALIDATION REPORT")
    print(f"=" * 60)
    
    print(f"\n📈 Performance Metrics:")
    print(f"   Bridge Reuse Rate: {bridge_reuse_rate:.1f}% (Target: ≥85%)")
    print(f"   Fallback Rate: {fallback_rate:.1f}% (Target: ≤15%)")
    print(f"   Success Rate: {success_rate:.1f}% (Target: ≥90%)")
    print(f"   Avg Response Time: {avg_response_time:.1f}ms (Target: <100ms)")
    
    print(f"\n🎯 Target Achievement:")
    for metric, data in test_results['target_achievement'].items():
        status = "✅" if data['met'] else "❌"
        print(f"   {status} {metric}: {data['achieved']:.1f} (Target: {data['target']})")
    
    print(f"\n📊 Improvement Summary:")
    improvements = test_results['performance_improvement']
    print(f"   Bridge Reuse: +{improvements['bridge_reuse_improvement']:.1f}%")
    print(f"   Fallback Reduction: -{improvements['fallback_reduction']:.1f}%")
    print(f"   Success Rate: +{improvements['success_rate_improvement']:.1f}%")
    
    print(f"\n🔧 Component Status:")
    print(f"   Embedding Service: {'✅ Working' if embedding_successes > 0 else '❌ Failed'}")
    print(f"   Knowledge Graph: {'✅ Working' if kg_successes > 0 else '❌ Failed'}")
    
    # Overall assessment
    targets_met = sum(1 for data in test_results['target_achievement'].values() if data['met'])
    total_targets = len(test_results['target_achievement'])
    
    print(f"\n🏆 OVERALL ASSESSMENT:")
    print(f"   Targets Met: {targets_met}/{total_targets}")
    
    if targets_met >= 3:
        print(f"   Status: ✅ OPTIMIZATION SUCCESSFUL")
        print(f"   Bridge pattern is now functioning optimally!")
    elif targets_met >= 2:
        print(f"   Status: 🟡 OPTIMIZATION PARTIAL")
        print(f"   Bridge pattern improved but needs fine-tuning")
    else:
        print(f"   Status: ❌ OPTIMIZATION NEEDS WORK")
        print(f"   Bridge pattern requires additional fixes")
    
    # Save results
    results_file = Path(__file__).parent / 'bridge_optimization_results.json'
    with open(results_file, 'w') as f:
        json.dump(test_results, f, indent=2, default=str)
    
    print(f"\n💾 Results saved to: {results_file}")
    
    return test_results

if __name__ == "__main__":
    asyncio.run(validate_bridge_optimization())
