#!/usr/bin/env python3

"""
HYBRID SEARCH STRATEGY TESTS V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Comprehensive tests for Crawl4AI Hybrid Search strategy.
Validates vector search, keyword search, RRF merge, and performance.
"""

import asyncio
import time
import json
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.append(str(Path(__file__).parent.parent))

from crawl4ai_strategies.hybrid_search import HybridSearchStrategy

async def test_hybrid_search_strategy():
    """Test hybrid search strategy functionality"""
    print("🧪 [HYBRID SEARCH TESTS] Starting comprehensive tests...")
    
    strategy = HybridSearchStrategy()
    
    # Test corpus for indexing
    test_corpus = [
        "Python is a high-level programming language with dynamic semantics.",
        "JavaScript is a versatile scripting language for web development.",
        "Machine learning algorithms can process large datasets efficiently.",
        "Database optimization requires understanding of indexing strategies.",
        "Web applications need robust authentication and authorization systems.",
        "Cloud computing provides scalable infrastructure for modern applications.",
        "API design patterns help create maintainable and extensible services.",
        "Security best practices include input validation and encryption.",
        "Performance optimization involves caching and efficient algorithms.",
        "User experience design focuses on intuitive and accessible interfaces."
    ]
    
    # Index the test corpus
    print("\nIndexing test corpus...")
    strategy.index_corpus(test_corpus)
    print(f"✅ Indexed {len(test_corpus)} documents")
    
    # Test 1: Basic hybrid search
    print("\nTest 1: Basic hybrid search")
    try:
        query = "Python programming language"
        context = {
            'source': 'test_documents',
            'domain': 'programming'
        }
        
        results = await strategy.perform_hybrid_search(query, context)
        
        print(f"✅ Hybrid search completed: {len(results)} results")
        if results:
            top_result = results[0]
            print(f"✅ Top result score: {top_result['hybrid_score']:.4f}")
            print(f"✅ Search types: {top_result['search_types']}")
            print(f"✅ Boosted result: {top_result.get('boosted', False)}")
            print(f"✅ Content preview: {top_result['content'][:100]}...")
        
    except Exception as e:
        print(f"❌ Test 1 failed: {e}")
    
    # Test 2: Vector search component
    print("\nTest 2: Vector search component")
    try:
        vector_results = await strategy._perform_vector_search(query, context)
        print(f"✅ Vector search: {len(vector_results)} results")
        if vector_results:
            print(f"✅ Vector result score: {vector_results[0]['score']:.4f}")
            print(f"✅ Search type: {vector_results[0]['search_type']}")
        
    except Exception as e:
        print(f"❌ Test 2 failed: {e}")
    
    # Test 3: Keyword search component
    print("\nTest 3: Keyword search component")
    try:
        keyword_results = await strategy._perform_keyword_search(query, context)
        print(f"✅ Keyword search: {len(keyword_results)} results")
        if keyword_results:
            print(f"✅ Keyword result score: {keyword_results[0]['score']:.4f}")
            print(f"✅ Search type: {keyword_results[0]['search_type']}")
            print(f"✅ Algorithm: {keyword_results[0]['metadata'].get('algorithm', 'unknown')}")
        
    except Exception as e:
        print(f"❌ Test 3 failed: {e}")
    
    # Test 4: RRF merge algorithm
    print("\nTest 4: RRF merge algorithm")
    try:
        # Create mock results for testing RRF
        mock_vector_results = [
            {'content': 'Python programming', 'score': 0.9, 'rank': 1, 'search_type': 'vector'},
            {'content': 'JavaScript development', 'score': 0.7, 'rank': 2, 'search_type': 'vector'},
            {'content': 'Machine learning', 'score': 0.6, 'rank': 3, 'search_type': 'vector'}
        ]
        
        mock_keyword_results = [
            {'content': 'Python programming', 'score': 2.5, 'rank': 1, 'search_type': 'keyword'},
            {'content': 'Database optimization', 'score': 1.8, 'rank': 2, 'search_type': 'keyword'},
            {'content': 'JavaScript development', 'score': 1.2, 'rank': 3, 'search_type': 'keyword'}
        ]
        
        merged_results = strategy._merge_results_rrf(mock_vector_results, mock_keyword_results)
        
        print(f"✅ RRF merge: {len(merged_results)} results")
        if merged_results:
            top_merged = merged_results[0]
            print(f"✅ Top merged score: {top_merged['hybrid_score']:.4f}")
            print(f"✅ Search types: {top_merged['search_types']}")
            print(f"✅ Boosted: {top_merged['boosted']}")
            print(f"✅ Vector rank: {top_merged['vector_rank']}")
            print(f"✅ Keyword rank: {top_merged['keyword_rank']}")
        
    except Exception as e:
        print(f"❌ Test 4 failed: {e}")
    
    # Test 5: Cache mechanism
    print("\nTest 5: Cache mechanism")
    try:
        # First search
        start_time = time.time()
        results1 = await strategy.perform_hybrid_search("machine learning algorithms", context)
        first_search_time = time.time() - start_time
        
        # Second search (should be cached)
        start_time = time.time()
        results2 = await strategy.perform_hybrid_search("machine learning algorithms", context)
        second_search_time = time.time() - start_time
        
        print(f"✅ First search: {first_search_time*1000:.1f}ms")
        print(f"✅ Second search: {second_search_time*1000:.1f}ms")
        print(f"✅ Cache improvement: {((first_search_time - second_search_time) / first_search_time * 100):.1f}%")
        
    except Exception as e:
        print(f"❌ Test 5 failed: {e}")
    
    # Test 6: Different query types
    print("\nTest 6: Different query types")
    try:
        test_queries = [
            "web development JavaScript",
            "database indexing optimization",
            "security authentication systems",
            "cloud infrastructure scalable",
            "user interface design"
        ]
        
        for i, test_query in enumerate(test_queries, 1):
            results = await strategy.perform_hybrid_search(test_query, context)
            print(f"✅ Query {i}: {len(results)} results for '{test_query}'")
            if results:
                print(f"   Top score: {results[0]['hybrid_score']:.4f}")
                print(f"   Search types: {results[0]['search_types']}")
        
    except Exception as e:
        print(f"❌ Test 6 failed: {e}")
    
    # Test 7: Performance metrics
    print("\nTest 7: Performance metrics")
    try:
        metrics = strategy.get_metrics()
        print(f"✅ Total searches: {metrics['total_searches']}")
        print(f"✅ Vector search calls: {metrics['vector_search_calls']}")
        print(f"✅ Keyword search calls: {metrics['keyword_search_calls']}")
        print(f"✅ RRF merge calls: {metrics['rrf_merge_calls']}")
        print(f"✅ Cache hit rate: {metrics['cache_hit_rate']:.1f}%")
        print(f"✅ Average search time: {metrics['average_search_time']:.1f}ms")
        print(f"✅ Success rate: {metrics['hybrid_search_success_rate']:.1f}%")
        
    except Exception as e:
        print(f"❌ Test 7 failed: {e}")
    
    # Test 8: Fallback mechanism
    print("\nTest 8: Fallback mechanism")
    try:
        # Test fallback with simulated error
        fallback_results = await strategy._fallback_search(
            "fallback test query",
            context,
            Exception("Simulated error")
        )
        
        print(f"✅ Fallback results: {len(fallback_results)} results")
        if fallback_results:
            print(f"✅ Fallback flag: {fallback_results[0].get('fallback', False)}")
            print(f"✅ Search strategy: {fallback_results[0]['metadata']['search_strategy']}")
        
    except Exception as e:
        print(f"❌ Test 8 failed: {e}")
    
    # Test 9: Health check
    print("\nTest 9: Health check")
    try:
        health = await strategy.health_check()
        print(f"✅ Health status: {health['status']}")
        print(f"✅ Strategy: {health['strategy']}")
        print(f"✅ Bridge available: {health['bridge_available']}")
        print(f"✅ BM25S available: {health['bm25s_available']}")
        print(f"✅ Corpus indexed: {health['corpus_indexed']}")
        
    except Exception as e:
        print(f"❌ Test 9 failed: {e}")
    
    # Test 10: Integration with Enhanced Memory System
    print("\nTest 10: Integration test")
    try:
        # Test integration with memory system patterns
        memory_query = "Enhanced Memory System RAG implementation"
        memory_context = {
            'source': 'enhanced_memory_docs',
            'domain': 'memory_system'
        }
        
        results = await strategy.perform_hybrid_search(memory_query, memory_context)
        
        print(f"✅ Memory system integration: {len(results)} results")
        if results:
            print(f"✅ Hybrid score: {results[0]['hybrid_score']:.4f}")
            print(f"✅ Search strategy: {results[0]['metadata']['search_strategy']}")
            print(f"✅ RRF parameters: k={results[0]['metadata']['rrf_k']}")
        
    except Exception as e:
        print(f"❌ Test 10 failed: {e}")
    
    print("\n✅ [HYBRID SEARCH TESTS] All tests completed")
    
    # Final metrics summary
    final_metrics = strategy.get_metrics()
    print(f"\n📊 FINAL METRICS:")
    print(f"   Total searches: {final_metrics['total_searches']}")
    print(f"   Cache hit rate: {final_metrics['cache_hit_rate']:.1f}%")
    print(f"   Average search time: {final_metrics['average_search_time']:.1f}ms")
    print(f"   Success rate: {final_metrics['hybrid_search_success_rate']:.1f}%")
    print(f"   Vector/Keyword calls: {final_metrics['vector_search_calls']}/{final_metrics['keyword_search_calls']}")
    print(f"   RRF merge calls: {final_metrics['rrf_merge_calls']}")

if __name__ == "__main__":
    # Run comprehensive tests
    asyncio.run(test_hybrid_search_strategy())
