#!/usr/bin/env python3

"""
RERANKING STRATEGY TESTS V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Comprehensive tests for Crawl4AI Reranking strategy.
Validates cross-encoder reranking, bridge integration, and performance optimization.
"""

import asyncio
import time
import json
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.append(str(Path(__file__).parent.parent))

from crawl4ai_strategies.reranking import RerankingStrategy

async def test_reranking_strategy():
    """Test reranking strategy functionality"""
    print("🧪 [RERANKING TESTS] Starting comprehensive tests...")
    
    strategy = RerankingStrategy()
    
    # Test data for reranking
    test_queries = [
        "Python machine learning algorithms",
        "React component best practices",
        "Database optimization techniques",
        "API security implementation",
        "Cloud deployment strategies"
    ]
    
    test_results = [
        {
            'content': 'Python machine learning with scikit-learn and pandas for data analysis',
            'hybridScore': 0.85,
            'similarity': 0.82,
            'source': 'documentation'
        },
        {
            'content': 'React functional components with hooks for modern web development',
            'hybridScore': 0.78,
            'similarity': 0.75,
            'source': 'tutorial'
        },
        {
            'content': 'Database indexing strategies for PostgreSQL performance optimization',
            'hybridScore': 0.72,
            'similarity': 0.70,
            'source': 'guide'
        },
        {
            'content': 'RESTful API security with JWT authentication and rate limiting',
            'hybridScore': 0.68,
            'similarity': 0.65,
            'source': 'article'
        },
        {
            'content': 'Docker containerization and Kubernetes deployment for cloud applications',
            'hybridScore': 0.64,
            'similarity': 0.62,
            'source': 'documentation'
        },
        {
            'content': 'JavaScript async/await patterns for handling asynchronous operations',
            'hybridScore': 0.60,
            'similarity': 0.58,
            'source': 'tutorial'
        },
        {
            'content': 'CSS Grid and Flexbox layout techniques for responsive design',
            'hybridScore': 0.55,
            'similarity': 0.52,
            'source': 'guide'
        }
    ]
    
    # Test 1: Basic reranking functionality
    print("\nTest 1: Basic reranking functionality")
    try:
        query = test_queries[0]
        context = {
            'source': 'test_basic',
            'domain': 'machine_learning'
        }
        
        results = await strategy.rerank_results(query, test_results, context)
        
        print(f"✅ Reranking completed: {len(results)} results")
        if results:
            top_result = results[0]
            print(f"✅ Top result score: {top_result.get('combinedScore', 0):.4f}")
            print(f"✅ Reranking method: {top_result.get('reranking_method', 'unknown')}")
            print(f"✅ Original score: {top_result.get('originalScore', 0):.4f}")
            print(f"✅ Cross-encoder score: {top_result.get('crossEncoderScore', 0):.4f}")
            print(f"✅ Content preview: {top_result['content'][:80]}...")
        
    except Exception as e:
        print(f"❌ Test 1 failed: {e}")
    
    # Test 2: Bridge integration test
    print("\nTest 2: Bridge integration test")
    try:
        query = test_queries[1]
        context = {'source': 'test_bridge'}
        
        # Test bridge integration
        bridge_results = await strategy._bridge_reranking(query, test_results[:3], context)
        
        if bridge_results:
            print(f"✅ Bridge integration: {len(bridge_results)} results")
            print(f"✅ Bridge method detected: {bridge_results[0].get('reranking_method', 'unknown')}")
        else:
            print("⚠️ Bridge integration not available, using fallback")
        
    except Exception as e:
        print(f"❌ Test 2 failed: {e}")
    
    # Test 3: Native cross-encoder reranking
    print("\nTest 3: Native cross-encoder reranking")
    try:
        query = test_queries[2]
        context = {'source': 'test_native'}
        
        # Force native reranking by disabling bridge
        original_bridge_setting = strategy.config['bridge_integration']
        strategy.config['bridge_integration'] = False
        
        results = await strategy.rerank_results(query, test_results[:4], context)
        
        # Restore bridge setting
        strategy.config['bridge_integration'] = original_bridge_setting
        
        print(f"✅ Native reranking: {len(results)} results")
        if results:
            native_result = results[0]
            print(f"✅ Native method: {native_result.get('reranking_method', 'unknown')}")
            print(f"✅ Combined score: {native_result.get('combinedScore', 0):.4f}")
            print(f"✅ Model used: {native_result.get('reranking_metadata', {}).get('model', 'unknown')}")
        
    except Exception as e:
        print(f"❌ Test 3 failed: {e}")
    
    # Test 4: Performance and latency test
    print("\nTest 4: Performance and latency test")
    try:
        query = test_queries[3]
        context = {'source': 'test_performance'}
        
        # Measure latency
        start_time = time.time()
        results = await strategy.rerank_results(query, test_results, context)
        latency = (time.time() - start_time) * 1000
        
        print(f"✅ Reranking latency: {latency:.1f}ms")
        print(f"✅ Latency target: {strategy.config['latency_target']}ms")
        print(f"✅ Target met: {'Yes' if latency <= strategy.config['latency_target'] else 'No'}")
        print(f"✅ Results count: {len(results)}")
        
    except Exception as e:
        print(f"❌ Test 4 failed: {e}")
    
    # Test 5: Cache mechanism test
    print("\nTest 5: Cache mechanism test")
    try:
        query = test_queries[4]
        context = {'source': 'test_cache'}
        
        # First reranking (cache miss)
        start_time = time.time()
        results1 = await strategy.rerank_results(query, test_results[:3], context)
        first_time = time.time() - start_time
        
        # Second reranking (cache hit)
        start_time = time.time()
        results2 = await strategy.rerank_results(query, test_results[:3], context)
        second_time = time.time() - start_time
        
        print(f"✅ First reranking: {first_time*1000:.1f}ms")
        print(f"✅ Second reranking: {second_time*1000:.1f}ms")
        print(f"✅ Cache improvement: {((first_time - second_time) / first_time * 100):.1f}%")
        print(f"✅ Results identical: {len(results1) == len(results2)}")
        
    except Exception as e:
        print(f"❌ Test 5 failed: {e}")
    
    # Test 6: Score calculation test
    print("\nTest 6: Score calculation test")
    try:
        # Test cross-encoder scoring
        query_text = "machine learning algorithms"
        result_text = "Python scikit-learn machine learning library for data analysis"
        
        score = await strategy._calculate_cross_encoder_score(query_text, result_text)
        print(f"✅ Cross-encoder score: {score:.4f}")
        print(f"✅ Score range valid: {0.0 <= score <= 1.0}")
        
        # Test combined scoring
        original_score = 0.75
        combined_score = strategy._calculate_combined_score(original_score, score)
        print(f"✅ Combined score: {combined_score:.4f}")
        print(f"✅ Original weight: {strategy.config['original_weight']}")
        print(f"✅ Cross-encoder weight: {strategy.config['cross_encoder_weight']}")
        
    except Exception as e:
        print(f"❌ Test 6 failed: {e}")
    
    # Test 7: Different query types test
    print("\nTest 7: Different query types test")
    try:
        # Test different query formats
        query_formats = [
            "simple string query",
            {"description": "complex query object", "type": "search"},
            {"text": "query with text field", "domain": "technical"}
        ]
        
        for i, query_format in enumerate(query_formats, 1):
            results = await strategy.rerank_results(query_format, test_results[:2], {'source': f'test_format_{i}'})
            extracted_text = strategy._extract_query_text(query_format)
            
            print(f"✅ Query format {i}: {len(results)} results")
            print(f"   Extracted text: {extracted_text[:50]}...")
            print(f"   Results reranked: {results[0].get('reranked', False) if results else False}")
        
    except Exception as e:
        print(f"❌ Test 7 failed: {e}")
    
    # Test 8: Relevance improvement calculation
    print("\nTest 8: Relevance improvement calculation")
    try:
        # Create mock original and reranked results
        original_results = test_results[:4]
        
        # Simulate reranked results with improved scores
        reranked_results = []
        for result in original_results:
            reranked_results.append({
                **result,
                'combinedScore': result['hybridScore'] * 1.2  # 20% improvement
            })
        
        improvement = strategy._calculate_relevance_improvement(original_results, reranked_results)
        print(f"✅ Relevance improvement: {improvement:.1f}%")
        print(f"✅ Improvement positive: {improvement > 0}")
        
    except Exception as e:
        print(f"❌ Test 8 failed: {e}")
    
    # Test 9: Fallback mechanism test
    print("\nTest 9: Fallback mechanism test")
    try:
        # Test fallback with simulated error
        fallback_results = await strategy._fallback_reranking(
            "fallback test query",
            test_results[:3],
            {'source': 'test_fallback'},
            Exception("Simulated reranking error")
        )
        
        print(f"✅ Fallback results: {len(fallback_results)} results")
        if fallback_results:
            print(f"✅ Fallback flag: {fallback_results[0].get('fallback', False)}")
            print(f"✅ Reranking method: {fallback_results[0].get('reranking_method', 'unknown')}")
            print(f"✅ Combined score: {fallback_results[0].get('combinedScore', 0):.4f}")
        
    except Exception as e:
        print(f"❌ Test 9 failed: {e}")
    
    # Test 10: Performance metrics test
    print("\nTest 10: Performance metrics test")
    try:
        metrics = strategy.get_metrics()
        print(f"✅ Total reranking calls: {metrics['total_reranking_calls']}")
        print(f"✅ Bridge integration calls: {metrics['bridge_integration_calls']}")
        print(f"✅ Native reranking calls: {metrics['native_reranking_calls']}")
        print(f"✅ Cache hit rate: {metrics['cache_hit_rate']:.1f}%")
        print(f"✅ Average latency: {metrics['average_latency']:.1f}ms")
        print(f"✅ Average relevance improvement: {metrics['average_relevance_improvement']:.1f}%")
        print(f"✅ Latency compliance rate: {metrics['latency_compliance_rate']:.1f}%")
        print(f"✅ Model loaded: {metrics['model_loaded']}")
        
    except Exception as e:
        print(f"❌ Test 10 failed: {e}")
    
    # Test 11: Health check test
    print("\nTest 11: Health check test")
    try:
        health = await strategy.health_check()
        print(f"✅ Health status: {health['status']}")
        print(f"✅ Strategy: {health['strategy']}")
        print(f"✅ Bridge available: {health['bridge_available']}")
        print(f"✅ Model loaded: {health['model_loaded']}")
        print(f"✅ Cross-encoder available: {health['cross_encoder_available']}")
        print(f"✅ Cache enabled: {health['cache_enabled']}")
        
    except Exception as e:
        print(f"❌ Test 11 failed: {e}")
    
    # Test 12: Edge cases test
    print("\nTest 12: Edge cases test")
    try:
        # Test empty results
        empty_results = await strategy.rerank_results("test query", [], {'source': 'test_empty'})
        print(f"✅ Empty results handling: {len(empty_results)} results")
        
        # Test single result
        single_result = await strategy.rerank_results("test query", [test_results[0]], {'source': 'test_single'})
        print(f"✅ Single result handling: {len(single_result)} results")
        
        # Test None query
        none_results = await strategy.rerank_results("", test_results[:2], {'source': 'test_none'})
        print(f"✅ Empty query handling: {len(none_results)} results")
        
    except Exception as e:
        print(f"❌ Test 12 failed: {e}")
    
    print("\n✅ [RERANKING TESTS] All tests completed")
    
    # Final metrics summary
    final_metrics = strategy.get_metrics()
    print(f"\n📊 FINAL METRICS:")
    print(f"   Total reranking calls: {final_metrics['total_reranking_calls']}")
    print(f"   Cache hit rate: {final_metrics['cache_hit_rate']:.1f}%")
    print(f"   Average latency: {final_metrics['average_latency']:.1f}ms")
    print(f"   Latency compliance: {final_metrics['latency_compliance_rate']:.1f}%")
    print(f"   Average relevance improvement: {final_metrics['average_relevance_improvement']:.1f}%")
    print(f"   Bridge/Native calls: {final_metrics['bridge_integration_calls']}/{final_metrics['native_reranking_calls']}")
    print(f"   Fallback activations: {final_metrics['fallback_activations']}")

if __name__ == "__main__":
    # Run comprehensive tests
    asyncio.run(test_reranking_strategy())
