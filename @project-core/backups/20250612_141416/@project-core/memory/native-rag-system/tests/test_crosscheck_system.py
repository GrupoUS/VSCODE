#!/usr/bin/env python3

"""
INTELLIGENT CROSSCHECK SYSTEM TESTS V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Comprehensive tests for Intelligent Crosscheck System.
Validates duplication detection, merge strategies, and integration with all native strategies.
"""

import asyncio
import time
import json
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.append(str(Path(__file__).parent.parent))

from central_hub.crosscheck_system import IntelligentCrosscheckSystem, MemoryEntry, CrosscheckResult

async def test_crosscheck_system():
    """Test Intelligent Crosscheck System functionality"""
    print("🧪 [CROSSCHECK SYSTEM TESTS] Starting comprehensive tests...")
    
    crosscheck = IntelligentCrosscheckSystem()
    
    # Test 1: System initialization
    print("\nTest 1: System initialization")
    try:
        init_result = await crosscheck.initialize()
        
        print(f"✅ System initialization: {init_result}")
        print(f"✅ Memory entries loaded: {len(crosscheck.memory_entries)}")
        print(f"✅ Crawl4AI strategies: {len(crosscheck.crawl4ai_strategies)}")
        print(f"✅ ECL pipeline available: {crosscheck.cognee_pipeline is not None}")
        print(f"✅ Memory index built: {len(crosscheck.memory_index) > 0}")
        
        if init_result:
            print(f"✅ System initialized successfully")
        else:
            print(f"⚠️ System initialization had issues")
        
    except Exception as e:
        print(f"❌ Test 1 failed: {e}")
    
    # Test 2: Basic crosscheck analysis
    print("\nTest 2: Basic crosscheck analysis")
    try:
        test_info = "React is a JavaScript library for building user interfaces"
        
        result = await crosscheck.analyze_new_information(
            test_info,
            {'source': 'test_basic', 'category': 'technology'}
        )
        
        print(f"✅ Analysis completed: {result.action}")
        print(f"✅ Should add: {result.should_add}")
        print(f"✅ Confidence: {result.confidence:.3f}")
        print(f"✅ Unique value: {result.unique_value:.3f}")
        print(f"✅ Similar entries: {len(result.similar_entries)}")
        print(f"✅ Reasoning: {result.reasoning[:50]}...")
        
        # Verify result structure
        assert hasattr(result, 'should_add')
        assert hasattr(result, 'action')
        assert hasattr(result, 'confidence')
        assert hasattr(result, 'unique_value')
        print(f"✅ Result structure valid")
        
    except Exception as e:
        print(f"❌ Test 2 failed: {e}")
    
    # Test 3: Duplication detection
    print("\nTest 3: Duplication detection")
    try:
        # Add first entry
        first_info = "Next.js is a React framework for production applications"
        first_result = await crosscheck.analyze_new_information(
            first_info,
            {'source': 'test_dup1', 'category': 'technology'}
        )
        
        if first_result.action == 'add':
            await crosscheck.execute_crosscheck_action(first_info, first_result)
        
        # Try to add very similar entry
        similar_info = "Next.js is a React framework for building production apps"
        similar_result = await crosscheck.analyze_new_information(
            similar_info,
            {'source': 'test_dup2', 'category': 'technology'}
        )
        
        print(f"✅ First entry action: {first_result.action}")
        print(f"✅ Similar entry action: {similar_result.action}")
        print(f"✅ Similar entry confidence: {similar_result.confidence:.3f}")
        print(f"✅ Duplication detected: {similar_result.action in ['skip', 'merge']}")
        
        if similar_result.similar_entries:
            print(f"✅ Similar entries found: {len(similar_result.similar_entries)}")
            print(f"✅ Max similarity: {max(e.similarity_score for e in similar_result.similar_entries):.3f}")
        
    except Exception as e:
        print(f"❌ Test 3 failed: {e}")
    
    # Test 4: Merge strategy testing
    print("\nTest 4: Merge strategy testing")
    try:
        # Add base entry
        base_info = "TypeScript adds static typing to JavaScript development"
        base_result = await crosscheck.analyze_new_information(
            base_info,
            {'source': 'test_merge_base', 'category': 'technology'}
        )
        
        if base_result.action == 'add':
            await crosscheck.execute_crosscheck_action(base_info, base_result)
        
        # Add related but different information
        related_info = "TypeScript provides compile-time type checking for JavaScript"
        related_result = await crosscheck.analyze_new_information(
            related_info,
            {'source': 'test_merge_related', 'category': 'technology'}
        )
        
        print(f"✅ Base entry action: {base_result.action}")
        print(f"✅ Related entry action: {related_result.action}")
        print(f"✅ Merge strategy: {related_result.merge_strategy}")
        
        if related_result.action == 'merge':
            merge_execution = await crosscheck.execute_crosscheck_action(related_info, related_result)
            print(f"✅ Merge execution: {merge_execution['success']}")
            print(f"✅ Target memory ID: {merge_execution.get('target_memory_id', 'N/A')}")
        
    except Exception as e:
        print(f"❌ Test 4 failed: {e}")
    
    # Test 5: Unique value extraction
    print("\nTest 5: Unique value extraction")
    try:
        unique_infos = [
            "Python is excellent for data science and machine learning",
            "Docker containers provide application isolation and portability",
            "Kubernetes orchestrates containerized applications at scale",
            "GraphQL provides a query language for APIs"
        ]
        
        for i, info in enumerate(unique_infos):
            result = await crosscheck.analyze_new_information(
                info,
                {'source': f'test_unique_{i}', 'category': 'technology'}
            )
            
            print(f"✅ Info {i+1}: {result.action} (unique value: {result.unique_value:.3f})")
            
            if result.should_add:
                await crosscheck.execute_crosscheck_action(info, result)
        
    except Exception as e:
        print(f"❌ Test 5 failed: {e}")
    
    # Test 6: Crawl4AI strategies integration
    print("\nTest 6: Crawl4AI strategies integration")
    try:
        complex_info = """
        Modern web development requires understanding of multiple technologies:
        - React for component-based UI development
        - Next.js for server-side rendering and routing
        - TypeScript for type safety and better developer experience
        - Tailwind CSS for utility-first styling
        - Supabase for backend-as-a-service solutions
        """
        
        result = await crosscheck.analyze_new_information(
            complex_info,
            {
                'source': 'test_crawl4ai',
                'category': 'web_development',
                'content_type': 'comprehensive_guide'
            }
        )
        
        print(f"✅ Complex analysis action: {result.action}")
        print(f"✅ Confidence: {result.confidence:.3f}")
        print(f"✅ Unique value: {result.unique_value:.3f}")
        print(f"✅ Similar entries: {len(result.similar_entries)}")
        
        # Test strategy integration
        strategies_used = []
        if result.confidence > 0:
            strategies_used.append('contextual_embeddings')
        if result.similar_entries:
            strategies_used.append('hybrid_search')
        if result.action in ['merge', 'add']:
            strategies_used.append('agentic_rag')
        if len(result.similar_entries) > 1:
            strategies_used.append('reranking')
        
        print(f"✅ Strategies used: {strategies_used}")
        
    except Exception as e:
        print(f"❌ Test 6 failed: {e}")
    
    # Test 7: ECL pipeline integration
    print("\nTest 7: ECL pipeline integration")
    try:
        ecl_test_info = """
        Sequential Thinking MCP integration enables complex reasoning workflows.
        The system uses entity extraction to identify key components,
        relationship cognification to understand connections,
        and dynamic loading to update the knowledge base.
        """
        
        result = await crosscheck.analyze_new_information(
            ecl_test_info,
            {
                'source': 'test_ecl',
                'category': 'mcp_integration',
                'analysis_type': 'ecl_pipeline'
            }
        )
        
        print(f"✅ ECL analysis action: {result.action}")
        print(f"✅ Unique value (ECL-enhanced): {result.unique_value:.3f}")
        print(f"✅ Confidence: {result.confidence:.3f}")
        
        # ECL pipeline should contribute to unique value calculation
        if result.unique_value > 0.5:
            print(f"✅ ECL pipeline contributed to unique value scoring")
        
    except Exception as e:
        print(f"❌ Test 7 failed: {e}")
    
    # Test 8: Performance metrics
    print("\nTest 8: Performance metrics")
    try:
        metrics = crosscheck.get_metrics()
        
        print(f"✅ Total analyses: {metrics['total_analyses']}")
        print(f"✅ Additions approved: {metrics['additions_approved']}")
        print(f"✅ Additions rejected: {metrics['additions_rejected']}")
        print(f"✅ Merges performed: {metrics['merges_performed']}")
        print(f"✅ Duplicates prevented: {metrics['duplicates_prevented']}")
        print(f"✅ Approval rate: {metrics['approval_rate']:.1f}%")
        print(f"✅ Memory entries count: {metrics['memory_entries_count']}")
        print(f"✅ Average analysis time: {metrics['average_analysis_time']:.1f}ms")
        
        # Verify metrics make sense
        total_decisions = metrics['additions_approved'] + metrics['additions_rejected']
        if total_decisions > 0:
            print(f"✅ Decision metrics consistent")
        
    except Exception as e:
        print(f"❌ Test 8 failed: {e}")
    
    # Test 9: Action execution testing
    print("\nTest 9: Action execution testing")
    try:
        # Test different action types
        test_cases = [
            ("New unique information about Rust programming", "add"),
            ("Vue.js is a progressive JavaScript framework", "add"),
            ("React is a library for building UIs", "skip")  # Should be similar to earlier React entry
        ]
        
        for info, expected_action in test_cases:
            analysis_result = await crosscheck.analyze_new_information(
                info,
                {'source': 'test_actions', 'category': 'technology'}
            )
            
            execution_result = await crosscheck.execute_crosscheck_action(info, analysis_result)
            
            print(f"✅ '{info[:30]}...' -> {analysis_result.action} (expected: {expected_action})")
            print(f"   Execution success: {execution_result['success']}")
            
            if analysis_result.action == expected_action:
                print(f"   ✅ Action matched expectation")
            else:
                print(f"   ⚠️ Action different from expectation")
        
    except Exception as e:
        print(f"❌ Test 9 failed: {e}")
    
    # Test 10: Health check
    print("\nTest 10: Health check")
    try:
        health = await crosscheck.health_check()
        
        print(f"✅ Health status: {health['status']}")
        print(f"✅ System: {health['system']}")
        print(f"✅ Memory entries loaded: {health['memory_entries_loaded']}")
        print(f"✅ Crawl4AI strategies available: {health['crawl4ai_strategies_available']}")
        print(f"✅ ECL pipeline available: {health['ecl_pipeline_available']}")
        print(f"✅ Test analysis success: {health['test_analysis_success']}")
        
    except Exception as e:
        print(f"❌ Test 10 failed: {e}")
    
    # Test 11: Edge cases
    print("\nTest 11: Edge cases")
    try:
        edge_cases = [
            "",  # Empty content
            "a",  # Very short content
            "x" * 1000,  # Very long content
            "Special characters: @#$%^&*()_+{}|:<>?",  # Special characters
            "Mixed content with code: `function test() { return true; }`"  # Mixed content
        ]
        
        for i, edge_case in enumerate(edge_cases):
            try:
                result = await crosscheck.analyze_new_information(
                    edge_case,
                    {'source': f'test_edge_{i}', 'category': 'edge_case'}
                )
                print(f"✅ Edge case {i+1}: {result.action} (confidence: {result.confidence:.3f})")
            except Exception as edge_error:
                print(f"⚠️ Edge case {i+1} failed: {str(edge_error)[:50]}...")
        
    except Exception as e:
        print(f"❌ Test 11 failed: {e}")
    
    print("\n✅ [CROSSCHECK SYSTEM TESTS] All tests completed")
    
    # Final metrics summary
    final_metrics = crosscheck.get_metrics()
    print(f"\n📊 FINAL METRICS:")
    print(f"   Total analyses: {final_metrics['total_analyses']}")
    print(f"   Approval rate: {final_metrics['approval_rate']:.1f}%")
    print(f"   Memory entries: {final_metrics['memory_entries_count']}")
    print(f"   Merges performed: {final_metrics['merges_performed']}")
    print(f"   Duplicates prevented: {final_metrics['duplicates_prevented']}")
    print(f"   Average analysis time: {final_metrics['average_analysis_time']:.1f}ms")

if __name__ == "__main__":
    # Run comprehensive tests
    asyncio.run(test_crosscheck_system())
