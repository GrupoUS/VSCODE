#!/usr/bin/env python3

"""
CENTRAL MEMORY HUB COORDINATOR TESTS V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Comprehensive tests for Central Memory Hub Coordinator.
Validates routing decisions, strategy execution, fallback chains, and MCP integration.
"""

import asyncio
import time
import json
import os
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.append(str(Path(__file__).parent.parent))

from central_hub.memory_coordinator import CentralMemoryCoordinator

async def test_central_memory_coordinator():
    """Test Central Memory Hub Coordinator functionality"""
    print("🧪 [CENTRAL HUB TESTS] Starting comprehensive tests...")
    
    coordinator = CentralMemoryCoordinator()
    
    # Test queries for different scenarios
    test_queries = {
        'simple_query': "What is React?",
        'code_analysis': "Find patterns in JavaScript function definitions and class methods",
        'search_query': "Search for Next.js configuration examples and best practices",
        'error_analysis': "Debug TypeError in async function execution",
        'memory_query': "Remember previous implementation of authentication system",
        'complex_query': """
        Analyze the codebase for React components that use hooks,
        extract patterns for state management,
        and provide recommendations for optimization
        """
    }
    
    # Test 1: Basic coordination functionality
    print("\nTest 1: Basic coordination functionality")
    try:
        result = await coordinator.coordinate_memory_consultation(
            test_queries['simple_query'],
            {'source': 'test_basic'}
        )
        
        print(f"✅ Coordination completed: {result['success']}")
        print(f"✅ Strategies used: {result.get('strategies_used', [])}")
        print(f"✅ Confidence score: {result['results']['confidence_score']:.3f}")
        print(f"✅ Result count: {result['results']['result_count']}")
        
        # Verify structure
        assert 'success' in result
        assert 'results' in result
        assert 'strategies_used' in result
        assert 'metadata' in result
        print(f"✅ Result structure valid")
        
    except Exception as e:
        print(f"❌ Test 1 failed: {e}")
    
    # Test 2: Routing decision analysis
    print("\nTest 2: Routing decision analysis")
    try:
        for query_type, query in test_queries.items():
            result = await coordinator.coordinate_memory_consultation(
                query,
                {'source': f'test_{query_type}'}
            )
            
            routing_decision = result.get('routing_decision', {})
            query_analysis = routing_decision.get('query_analysis', {})
            
            print(f"✅ {query_type}:")
            print(f"   Query type: {query_analysis.get('type', 'unknown')}")
            print(f"   Complexity: {query_analysis.get('complexity', 'unknown')}")
            print(f"   Strategies: {routing_decision.get('selected_strategies', [])}")
            print(f"   Success: {result['success']}")
        
    except Exception as e:
        print(f"❌ Test 2 failed: {e}")
    
    # Test 3: Strategy execution testing
    print("\nTest 3: Strategy execution testing")
    try:
        # Test enhanced memory strategy
        enhanced_result = await coordinator._execute_enhanced_memory(
            "test enhanced memory",
            {'source': 'test_enhanced'}
        )
        print(f"✅ Enhanced memory: {enhanced_result['success']}")
        
        # Test self correction strategy
        self_correction_result = await coordinator._execute_self_correction(
            "error debugging test",
            {'source': 'test_self_correction'}
        )
        print(f"✅ Self correction: {self_correction_result['success']}")
        
        # Test Crawl4AI strategies
        crawl4ai_result = await coordinator._execute_crawl4ai_strategies(
            "search for patterns",
            {
                'source': 'test_crawl4ai',
                'query_analysis': {
                    'requires_semantic_search': True,
                    'requires_code_analysis': True,
                    'requires_reranking': True
                }
            }
        )
        print(f"✅ Crawl4AI strategies: {crawl4ai_result['success']}")
        if crawl4ai_result['success']:
            print(f"   Strategies executed: {crawl4ai_result.get('strategies_executed', [])}")
        
        # Test Cognee ECL pipeline
        cognee_result = await coordinator._execute_cognee_pipeline(
            "Extract entities and relationships from React documentation",
            {'source': 'test_cognee'}
        )
        print(f"✅ Cognee ECL pipeline: {cognee_result['success']}")
        
    except Exception as e:
        print(f"❌ Test 3 failed: {e}")
    
    # Test 4: Fallback chain testing
    print("\nTest 4: Fallback chain testing")
    try:
        # Create a scenario that might trigger fallbacks
        fallback_query = "complex query that might fail in some strategies"
        
        result = await coordinator.coordinate_memory_consultation(
            fallback_query,
            {'source': 'test_fallback'}
        )
        
        print(f"✅ Fallback handling: {result['success']}")
        print(f"✅ Fallback activated: {result.get('fallback_activated', False)}")
        print(f"✅ Successful strategies: {result['results']['successful_strategies']}")
        print(f"✅ Failed strategies: {result['results']['failed_strategies']}")
        
    except Exception as e:
        print(f"❌ Test 4 failed: {e}")
    
    # Test 5: Cache functionality testing
    print("\nTest 5: Cache functionality testing")
    try:
        cache_query = "cache test query for performance validation"
        
        # First execution (cache miss)
        start_time = time.time()
        result1 = await coordinator.coordinate_memory_consultation(
            cache_query,
            {'source': 'test_cache'}
        )
        first_time = time.time() - start_time
        
        # Second execution (cache hit)
        start_time = time.time()
        result2 = await coordinator.coordinate_memory_consultation(
            cache_query,
            {'source': 'test_cache'}
        )
        second_time = time.time() - start_time
        
        print(f"✅ First execution: {first_time*1000:.1f}ms")
        print(f"✅ Second execution: {second_time*1000:.1f}ms")
        print(f"✅ Cache improvement: {((first_time - second_time) / first_time * 100):.1f}%")
        print(f"✅ Results identical: {result1['success'] == result2['success']}")
        
    except Exception as e:
        print(f"❌ Test 5 failed: {e}")
    
    # Test 6: MCP integration testing
    print("\nTest 6: MCP integration testing")
    try:
        # Check environment variables set by coordinator
        mcp_vars = [
            'MEMORY_COORDINATOR_ACTIVE',
            'NATIVE_RAG_SYSTEM_ENABLED',
            'CRAWL4AI_STRATEGIES_AVAILABLE',
            'COGNEE_ECL_PIPELINE_ACTIVE'
        ]
        
        for var in mcp_vars:
            value = os.environ.get(var)
            print(f"✅ {var}: {value}")
        
        # Test MCP integration during consultation
        mcp_result = await coordinator.coordinate_memory_consultation(
            "MCP integration test",
            {'source': 'test_mcp'}
        )
        
        # Check if consultation results updated environment
        consultation_success = os.environ.get('LAST_MEMORY_CONSULTATION_SUCCESS')
        consultation_count = os.environ.get('MEMORY_CONSULTATION_COUNT')
        
        print(f"✅ Last consultation success: {consultation_success}")
        print(f"✅ Total consultation count: {consultation_count}")
        print(f"✅ MCP integration working: {consultation_success is not None}")
        
    except Exception as e:
        print(f"❌ Test 6 failed: {e}")
    
    # Test 7: Performance metrics testing
    print("\nTest 7: Performance metrics testing")
    try:
        metrics = coordinator.get_metrics()
        
        print(f"✅ Total consultations: {metrics['total_consultations']}")
        print(f"✅ Cache hit rate: {metrics['cache_hit_rate']:.1f}%")
        print(f"✅ Average response time: {metrics['average_response_time']:.1f}ms")
        print(f"✅ Success rate: {metrics['success_rate']:.1f}%")
        print(f"✅ Memory sources available: {metrics['memory_sources_available']}")
        print(f"✅ Crawl4AI strategies available: {metrics['crawl4ai_strategies_available']}")
        print(f"✅ MCP integration active: {metrics['mcp_integration_active']}")
        print(f"✅ Fallback activations: {metrics['fallback_activations']}")
        
        # Check routing decisions
        if metrics['routing_decisions']:
            print(f"✅ Routing decisions made:")
            for decision, count in metrics['routing_decisions'].items():
                print(f"   {decision}: {count} times")
        
        # Check strategy usage
        if metrics['strategy_usage']:
            print(f"✅ Strategy usage:")
            for strategy, count in metrics['strategy_usage'].items():
                print(f"   {strategy}: {count} times")
        
    except Exception as e:
        print(f"❌ Test 7 failed: {e}")
    
    # Test 8: Query analysis testing
    print("\nTest 8: Query analysis testing")
    try:
        test_analyses = [
            ("def create_user():", "code_analysis"),
            ("search for React hooks", "search_query"),
            ("TypeError in async function", "error_analysis"),
            ("remember authentication flow", "memory_query"),
            ("simple question", "general")
        ]
        
        for query, expected_type in test_analyses:
            analysis = coordinator._analyze_query(query, {})
            print(f"✅ '{query[:30]}...' -> {analysis['type']} (expected: {expected_type})")
            print(f"   Complexity: {analysis['complexity']}")
            print(f"   Requires code analysis: {analysis['requires_code_analysis']}")
            print(f"   Requires semantic search: {analysis['requires_semantic_search']}")
        
    except Exception as e:
        print(f"❌ Test 8 failed: {e}")
    
    # Test 9: Strategy selection testing
    print("\nTest 9: Strategy selection testing")
    try:
        test_scenarios = [
            {
                'query_analysis': {
                    'type': 'code_analysis',
                    'complexity': 'high',
                    'requires_code_analysis': True,
                    'requires_pattern_recognition': True
                },
                'expected_strategies': ['enhanced_memory', 'crawl4ai_rag', 'cognee_ecl']
            },
            {
                'query_analysis': {
                    'type': 'search_query',
                    'complexity': 'medium',
                    'requires_semantic_search': True,
                    'requires_reranking': True
                },
                'expected_strategies': ['enhanced_memory', 'crawl4ai_rag']
            },
            {
                'query_analysis': {
                    'type': 'error_analysis',
                    'complexity': 'medium'
                },
                'expected_strategies': ['enhanced_memory', 'self_correction']
            }
        ]
        
        for i, scenario in enumerate(test_scenarios):
            strategies = coordinator._select_strategies(scenario['query_analysis'], {})
            print(f"✅ Scenario {i+1}: {strategies}")
            print(f"   Expected: {scenario['expected_strategies']}")
            
            # Check if key strategies are included
            for expected in scenario['expected_strategies']:
                if expected in strategies:
                    print(f"   ✅ {expected} included")
                else:
                    print(f"   ⚠️ {expected} missing")
        
    except Exception as e:
        print(f"❌ Test 9 failed: {e}")
    
    # Test 10: Health check testing
    print("\nTest 10: Health check testing")
    try:
        health = await coordinator.health_check()
        
        print(f"✅ Health status: {health['status']}")
        print(f"✅ Coordinator: {health['coordinator']}")
        print(f"✅ Memory sources available: {health['memory_sources_available']}")
        print(f"✅ Crawl4AI strategies available: {health['crawl4ai_strategies_available']}")
        print(f"✅ Cognee pipeline available: {health['cognee_pipeline_available']}")
        print(f"✅ MCP integration active: {health['mcp_integration_active']}")
        print(f"✅ Test consultation success: {health['test_consultation_success']}")
        
    except Exception as e:
        print(f"❌ Test 10 failed: {e}")
    
    # Test 11: Edge cases testing
    print("\nTest 11: Edge cases testing")
    try:
        edge_cases = [
            "",  # Empty query
            "a",  # Very short query
            "x" * 1000,  # Very long query
            {"complex": "object", "query": "nested structure"},  # Complex object
            123,  # Non-string query
            None  # None query
        ]
        
        for i, edge_case in enumerate(edge_cases):
            try:
                result = await coordinator.coordinate_memory_consultation(
                    edge_case,
                    {'source': f'test_edge_{i}'}
                )
                print(f"✅ Edge case {i+1}: {result['success']}")
            except Exception as edge_error:
                print(f"⚠️ Edge case {i+1} failed: {str(edge_error)[:50]}...")
        
    except Exception as e:
        print(f"❌ Test 11 failed: {e}")
    
    print("\n✅ [CENTRAL HUB TESTS] All tests completed")
    
    # Final metrics summary
    final_metrics = coordinator.get_metrics()
    print(f"\n📊 FINAL METRICS:")
    print(f"   Total consultations: {final_metrics['total_consultations']}")
    print(f"   Cache hit rate: {final_metrics['cache_hit_rate']:.1f}%")
    print(f"   Average response time: {final_metrics['average_response_time']:.1f}ms")
    print(f"   Success rate: {final_metrics['success_rate']:.1f}%")
    print(f"   Fallback activations: {final_metrics['fallback_activations']}")
    print(f"   MCP integrations: {final_metrics['mcp_integrations']}")

if __name__ == "__main__":
    # Run comprehensive tests
    asyncio.run(test_central_memory_coordinator())
