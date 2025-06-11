#!/usr/bin/env python3

"""
CONTEXTUAL EMBEDDINGS STRATEGY TESTS V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Comprehensive tests for Crawl4AI Contextual Embeddings strategy.
Validates context generation, embedding enhancement, and performance.
"""

import asyncio
import time
import json
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.append(str(Path(__file__).parent.parent))

from crawl4ai_strategies.contextual_embeddings import ContextualEmbeddingsStrategy

async def test_contextual_embeddings_strategy():
    """Test contextual embeddings strategy functionality"""
    print("🧪 [CONTEXTUAL EMBEDDINGS TESTS] Starting comprehensive tests...")
    
    strategy = ContextualEmbeddingsStrategy()
    
    # Test 1: Basic contextual embedding generation
    print("\nTest 1: Basic contextual embedding generation")
    try:
        test_content = "This is a function that processes user authentication in a web application."
        test_context = {
            'document': 'Web Application Security Guide: This document covers authentication, authorization, session management, and security best practices for web applications.',
            'source': 'security_documentation',
            'position': 1
        }
        
        result = await strategy.generate_contextual_embeddings(test_content, test_context)
        
        print(f"✅ Embedding generated: {len(result['embedding'])} dimensions")
        print(f"✅ Context enhanced: {result['metadata']['context_enhanced']}")
        print(f"✅ Processing time: {result['metadata']['processing_time_ms']:.1f}ms")
        print(f"✅ Strategy: {result['metadata']['strategy']}")
        
    except Exception as e:
        print(f"❌ Test 1 failed: {e}")
    
    # Test 2: Cache mechanism
    print("\nTest 2: Cache mechanism")
    try:
        # First call
        start_time = time.time()
        result1 = await strategy.generate_contextual_embeddings(test_content, test_context)
        first_call_time = time.time() - start_time
        
        # Second call (should be cached)
        start_time = time.time()
        result2 = await strategy.generate_contextual_embeddings(test_content, test_context)
        second_call_time = time.time() - start_time
        
        print(f"✅ First call: {first_call_time*1000:.1f}ms")
        print(f"✅ Second call: {second_call_time*1000:.1f}ms")
        print(f"✅ Cache improvement: {((first_call_time - second_call_time) / first_call_time * 100):.1f}%")
        
    except Exception as e:
        print(f"❌ Test 2 failed: {e}")
    
    # Test 3: Context enhancement quality
    print("\nTest 3: Context enhancement quality")
    try:
        # Test with different content types
        test_cases = [
            {
                'content': 'async function authenticateUser(username, password) { return jwt.sign(payload, secret); }',
                'document': 'JavaScript Authentication Library Documentation',
                'source': 'js_docs'
            },
            {
                'content': 'The database connection pool should be configured with a maximum of 20 connections.',
                'document': 'Database Performance Optimization Guide',
                'source': 'db_docs'
            },
            {
                'content': 'Use HTTPS for all API endpoints to ensure data encryption in transit.',
                'document': 'API Security Best Practices',
                'source': 'api_docs'
            }
        ]
        
        for i, test_case in enumerate(test_cases, 1):
            result = await strategy.generate_contextual_embeddings(
                test_case['content'],
                {
                    'document': test_case['document'],
                    'source': test_case['source']
                }
            )
            
            print(f"✅ Test case {i}: {len(result['embedding'])} dimensions")
            print(f"   Enhanced content length: {len(result['enhanced_content'])} chars")
            print(f"   Context: {result['enriched_context'][:100]}...")
            
    except Exception as e:
        print(f"❌ Test 3 failed: {e}")
    
    # Test 4: Performance metrics
    print("\nTest 4: Performance metrics")
    try:
        metrics = strategy.get_metrics()
        print(f"✅ Total chunks processed: {metrics['total_chunks_processed']}")
        print(f"✅ Cache hit rate: {metrics['cache_hit_rate']:.1f}%")
        print(f"✅ Average processing time: {metrics['average_processing_time']:.1f}ms")
        print(f"✅ Context generation calls: {metrics['context_generation_calls']}")
        print(f"✅ Embedding generation calls: {metrics['embedding_generation_calls']}")
        
    except Exception as e:
        print(f"❌ Test 4 failed: {e}")
    
    # Test 5: Fallback mechanism
    print("\nTest 5: Fallback mechanism")
    try:
        # Test with invalid context to trigger fallback
        result = await strategy._fallback_embedding_generation(
            "test content",
            {'source': 'fallback_test'},
            Exception("Simulated error")
        )
        
        print(f"✅ Fallback result: {len(result['embedding'])} dimensions")
        print(f"✅ Fallback flag: {result['metadata']['fallback']}")
        print(f"✅ Strategy: {result['metadata']['strategy']}")
        
    except Exception as e:
        print(f"❌ Test 5 failed: {e}")
    
    # Test 6: Health check
    print("\nTest 6: Health check")
    try:
        health = await strategy.health_check()
        print(f"✅ Health status: {health['status']}")
        print(f"✅ Strategy: {health['strategy']}")
        print(f"✅ Bridge available: {health['bridge_available']}")
        
    except Exception as e:
        print(f"❌ Test 6 failed: {e}")
    
    # Test 7: Integration with Enhanced Memory System
    print("\nTest 7: Integration test")
    try:
        # Test integration with memory system patterns
        memory_content = "The Enhanced Memory System V4.0 uses RAG with contextual embeddings for improved retrieval."
        memory_context = {
            'document': 'Enhanced Memory System V4.0 Documentation: Advanced RAG implementation with multiple strategies.',
            'source': 'enhanced_memory_docs',
            'domain': 'memory_system'
        }
        
        result = await strategy.generate_contextual_embeddings(memory_content, memory_context)
        
        print(f"✅ Memory system integration: {result['metadata']['context_enhanced']}")
        print(f"✅ Enhanced content preview: {result['enhanced_content'][:150]}...")
        
    except Exception as e:
        print(f"❌ Test 7 failed: {e}")
    
    print("\n✅ [CONTEXTUAL EMBEDDINGS TESTS] All tests completed")
    
    # Final metrics summary
    final_metrics = strategy.get_metrics()
    print(f"\n📊 FINAL METRICS:")
    print(f"   Total chunks processed: {final_metrics['total_chunks_processed']}")
    print(f"   Cache hit rate: {final_metrics['cache_hit_rate']:.1f}%")
    print(f"   Average processing time: {final_metrics['average_processing_time']:.1f}ms")
    print(f"   Success rate: {final_metrics['context_enhancement_success_rate']:.1f}%")

if __name__ == "__main__":
    # Run comprehensive tests
    asyncio.run(test_contextual_embeddings_strategy())
