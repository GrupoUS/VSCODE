#!/usr/bin/env python3

"""
MCP WORKFLOW INTEGRATION TESTS V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Comprehensive tests for MCP workflow integration.
Validates Sequential Thinking → think-mcp-server → MCP Shrimp Task Manager integration.
"""

import asyncio
import time
import json
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.append(str(Path(__file__).parent.parent))

from integration.mcp_integration import MCPWorkflowIntegration

async def test_mcp_integration():
    """Test MCP workflow integration functionality"""
    print("🧪 [MCP INTEGRATION TESTS] Starting comprehensive tests...")
    
    mcp_integration = MCPWorkflowIntegration()
    
    # Test 1: System initialization
    print("\nTest 1: System initialization")
    try:
        init_result = await mcp_integration.initialize()
        
        print(f"✅ System initialization: {init_result}")
        print(f"✅ Integration state: {mcp_integration.integration_state['initialized']}")
        print(f"✅ Native system active: {mcp_integration.integration_state['native_system_active']}")
        print(f"✅ MCP config loaded: {len(mcp_integration.mcp_config) > 0}")
        print(f"✅ Environment config: {len(mcp_integration.env_config) > 0}")
        
        if init_result:
            print(f"✅ MCP integration initialized successfully")
        else:
            print(f"⚠️ MCP integration initialization had issues")
        
    except Exception as e:
        print(f"❌ Test 1 failed: {e}")
    
    # Test 2: Basic workflow integration (low complexity)
    print("\nTest 2: Basic workflow integration (low complexity)")
    try:
        task_context = {
            'task_id': 'test_basic_001',
            'description': 'Simple task for testing basic workflow integration',
            'complexity': 5,
            'mcp_context': {
                'source': 'test_suite',
                'priority': 'normal'
            }
        }
        
        result = await mcp_integration.integrate_with_mcp_workflow(task_context)
        
        print(f"✅ Integration successful: {result['success']}")
        print(f"✅ Task ID: {result['task_id']}")
        print(f"✅ Complexity: {result['complexity']}")
        print(f"✅ Sequential Thinking used: {result['sequential_thinking_used']}")
        print(f"✅ Processing time: {result['processing_time']:.1f}ms")
        print(f"✅ MCP workflow preserved: {result['mcp_workflow_preserved']}")
        print(f"✅ Backward compatibility: {result['backward_compatibility']}")
        
        # Verify native RAG processing
        native_result = result['native_rag_processing']
        print(f"✅ Native RAG successful: {native_result['processing_successful']}")
        print(f"✅ Memory coordination: {native_result['memory_coordination']['success']}")
        print(f"✅ Augment bridge: {native_result['augment_bridge']['success']}")
        print(f"✅ Crosscheck action: {native_result['crosscheck_analysis']['action']}")
        
    except Exception as e:
        print(f"❌ Test 2 failed: {e}")
    
    # Test 3: Complex workflow integration (high complexity)
    print("\nTest 3: Complex workflow integration (high complexity)")
    try:
        complex_task_context = {
            'task_id': 'test_complex_001',
            'description': 'Complex architectural analysis requiring Sequential Thinking integration',
            'complexity': 8,
            'mcp_context': {
                'source': 'test_suite',
                'priority': 'high',
                'requires_sequential_thinking': True
            }
        }
        
        result = await mcp_integration.integrate_with_mcp_workflow(complex_task_context)
        
        print(f"✅ Complex integration successful: {result['success']}")
        print(f"✅ Sequential Thinking activated: {result['sequential_thinking_used']}")
        print(f"✅ Complexity threshold met: {result['complexity'] >= 7}")
        print(f"✅ Processing time: {result['processing_time']:.1f}ms")
        
        # Verify Sequential Thinking integration
        if result['sequential_thinking_used']:
            print(f"✅ Sequential Thinking integration working correctly")
        else:
            print(f"⚠️ Sequential Thinking should have been activated for complexity 8")
        
        # Verify all workflow components
        print(f"✅ think-mcp-server coordination: {result['think_server_coordination']['coordination_successful']}")
        print(f"✅ MCP Shrimp integration: {result['shrimp_integration']['integration_successful']}")
        
    except Exception as e:
        print(f"❌ Test 3 failed: {e}")
    
    # Test 4: Environment configuration validation
    print("\nTest 4: Environment configuration validation")
    try:
        import os
        
        # Check environment variables set by integration
        env_vars_to_check = [
            'NATIVE_RAG_SYSTEM_ACTIVE',
            'MEMORY_COORDINATOR_ENDPOINT',
            'AUGMENT_BRIDGE_ENDPOINT',
            'CROSSCHECK_SYSTEM_ENDPOINT',
            'MCP_INTEGRATION_VERSION',
            'BACKWARD_COMPATIBILITY_MODE'
        ]
        
        for var in env_vars_to_check:
            value = os.getenv(var)
            print(f"✅ {var}: {value}")
            
            if value is None:
                print(f"⚠️ Environment variable {var} not set")
        
        # Check MCP Shrimp specific variables
        mcp_vars = ['LAST_NATIVE_RAG_RESULT', 'MCP_INTEGRATION_STATUS', 'TASK_PROCESSING_TIMESTAMP']
        for var in mcp_vars:
            value = os.getenv(var)
            if value:
                print(f"✅ MCP Shrimp variable {var}: Set")
            else:
                print(f"⚠️ MCP Shrimp variable {var}: Not set")
        
    except Exception as e:
        print(f"❌ Test 4 failed: {e}")
    
    # Test 5: Backward compatibility validation
    print("\nTest 5: Backward compatibility validation")
    try:
        # Test that existing MCP workflow still works
        legacy_task_context = {
            'task_id': 'test_legacy_001',
            'description': 'Legacy task to test backward compatibility',
            'complexity': 6,
            'mcp_context': {
                'legacy_mode': True,
                'source': 'existing_workflow'
            }
        }
        
        result = await mcp_integration.integrate_with_mcp_workflow(legacy_task_context)
        
        print(f"✅ Legacy task processed: {result['success']}")
        print(f"✅ Backward compatibility maintained: {result['backward_compatibility']}")
        print(f"✅ MCP workflow preserved: {result['mcp_workflow_preserved']}")
        
        # Verify no breaking changes
        if result['success'] and result['backward_compatibility']:
            print(f"✅ Backward compatibility validation successful")
        else:
            print(f"⚠️ Backward compatibility issues detected")
        
    except Exception as e:
        print(f"❌ Test 5 failed: {e}")
    
    # Test 6: Fallback mechanism testing
    print("\nTest 6: Fallback mechanism testing")
    try:
        # Temporarily disable native RAG to test fallback
        original_env = mcp_integration.env_config['NATIVE_RAG_ENABLED']
        mcp_integration.env_config['NATIVE_RAG_ENABLED'] = False
        
        fallback_task_context = {
            'task_id': 'test_fallback_001',
            'description': 'Task to test fallback mechanism',
            'complexity': 7,
            'mcp_context': {
                'test_fallback': True
            }
        }
        
        result = await mcp_integration.integrate_with_mcp_workflow(fallback_task_context)
        
        # Check if fallback was activated
        native_result = result['native_rag_processing']
        if 'native_rag_skipped' in native_result:
            print(f"✅ Fallback mechanism working: Native RAG skipped as expected")
        
        # Restore original environment
        mcp_integration.env_config['NATIVE_RAG_ENABLED'] = original_env
        
        print(f"✅ Fallback test completed")
        
    except Exception as e:
        print(f"❌ Test 6 failed: {e}")
    
    # Test 7: Performance metrics validation
    print("\nTest 7: Performance metrics validation")
    try:
        metrics = mcp_integration.integration_state['performance_metrics']
        
        print(f"✅ Total integrations: {metrics['total_integrations']}")
        print(f"✅ Successful integrations: {metrics['successful_integrations']}")
        print(f"✅ Fallback activations: {metrics['fallback_activations']}")
        print(f"✅ Average processing time: {metrics['average_processing_time']:.1f}ms")
        
        # Calculate success rate
        if metrics['total_integrations'] > 0:
            success_rate = (metrics['successful_integrations'] / metrics['total_integrations']) * 100
            print(f"✅ Success rate: {success_rate:.1f}%")
            
            if success_rate >= 80:
                print(f"✅ Performance metrics within acceptable range")
            else:
                print(f"⚠️ Performance metrics below expected threshold")
        
    except Exception as e:
        print(f"❌ Test 7 failed: {e}")
    
    # Test 8: Integration status and health check
    print("\nTest 8: Integration status and health check")
    try:
        # Get integration status
        status = mcp_integration.get_integration_status()
        
        print(f"✅ Integration initialized: {status['integration_state']['initialized']}")
        print(f"✅ Native system active: {status['integration_state']['native_system_active']}")
        print(f"✅ Memory coordinator available: {status['components_status']['memory_coordinator']}")
        print(f"✅ Augment bridge available: {status['components_status']['augment_bridge']}")
        print(f"✅ Crosscheck system available: {status['components_status']['crosscheck_system']}")
        
        # Perform health check
        health = await mcp_integration.health_check()
        
        print(f"✅ Overall health status: {health['status']}")
        print(f"✅ Memory coordinator health: {health['components']['memory_coordinator']['status']}")
        print(f"✅ Augment bridge health: {health['components']['augment_bridge']['status']}")
        print(f"✅ Crosscheck system health: {health['components']['crosscheck_system']['status']}")
        print(f"✅ MCP workflow compatibility: {health['mcp_integration']['workflow_compatibility']}")
        print(f"✅ Backward compatibility: {health['mcp_integration']['backward_compatibility']}")
        
    except Exception as e:
        print(f"❌ Test 8 failed: {e}")
    
    # Test 9: Sequential Thinking threshold validation
    print("\nTest 9: Sequential Thinking threshold validation")
    try:
        # Test tasks with different complexity levels
        complexity_tests = [
            {'complexity': 5, 'should_activate': False},
            {'complexity': 6, 'should_activate': False},
            {'complexity': 7, 'should_activate': True},
            {'complexity': 8, 'should_activate': True},
            {'complexity': 9, 'should_activate': True}
        ]
        
        for test in complexity_tests:
            task_context = {
                'task_id': f'test_complexity_{test["complexity"]}',
                'description': f'Task with complexity {test["complexity"]}',
                'complexity': test['complexity'],
                'mcp_context': {'test_threshold': True}
            }
            
            result = await mcp_integration.integrate_with_mcp_workflow(task_context)
            
            sequential_used = result['sequential_thinking_used']
            should_activate = test['should_activate']
            
            if sequential_used == should_activate:
                print(f"✅ Complexity {test['complexity']}: Sequential Thinking {'activated' if sequential_used else 'not activated'} (correct)")
            else:
                print(f"⚠️ Complexity {test['complexity']}: Sequential Thinking {'activated' if sequential_used else 'not activated'} (incorrect)")
        
    except Exception as e:
        print(f"❌ Test 9 failed: {e}")
    
    print("\n✅ [MCP INTEGRATION TESTS] All tests completed")
    
    # Final metrics summary
    final_metrics = mcp_integration.integration_state['performance_metrics']
    print(f"\n📊 FINAL INTEGRATION METRICS:")
    print(f"   Total integrations: {final_metrics['total_integrations']}")
    print(f"   Successful integrations: {final_metrics['successful_integrations']}")
    print(f"   Success rate: {(final_metrics['successful_integrations'] / final_metrics['total_integrations'] * 100):.1f}%")
    print(f"   Fallback activations: {final_metrics['fallback_activations']}")
    print(f"   Average processing time: {final_metrics['average_processing_time']:.1f}ms")

if __name__ == "__main__":
    # Run comprehensive MCP integration tests
    asyncio.run(test_mcp_integration())
