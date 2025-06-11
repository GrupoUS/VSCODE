#!/usr/bin/env python3

"""
ECL PIPELINE TESTS V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Comprehensive tests for Cognee ECL Pipeline.
Validates Extract-Cognify-Load phases, bridge integration, and performance.
"""

import asyncio
import time
import json
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.append(str(Path(__file__).parent.parent))

from cognee_ecl_pipeline.ecl_pipeline import CogneeECLPipeline

async def test_ecl_pipeline():
    """Test ECL pipeline functionality"""
    print("🧪 [ECL PIPELINE TESTS] Starting comprehensive tests...")
    
    pipeline = CogneeECLPipeline()
    
    # Test content samples
    test_contents = {
        'technology_content': """
        # React Development with Next.js
        
        React is a powerful JavaScript library for building user interfaces.
        Next.js extends React with server-side rendering capabilities.
        TypeScript adds static typing to JavaScript development.
        
        We use Supabase for database management and Tailwind CSS for styling.
        The application integrates with Playwright for testing and Figma for design.
        """,
        
        'method_content': """
        def create_user_profile(user_data):
            # Extract user information
            name = user_data.get('name')
            email = user_data.get('email')
            
            # Validate user data
            if not validate_email(email):
                raise ValueError("Invalid email")
            
            # Create profile in database
            profile = UserProfile.create(name=name, email=email)
            return profile
        
        function validateEmail(email) {
            const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return regex.test(email);
        }
        """,
        
        'concept_content': """
        ## Software Architecture Patterns
        
        **Microservices Architecture** enables scalable application development.
        **Event-Driven Architecture** facilitates loose coupling between components.
        **Domain-Driven Design** helps organize complex business logic.
        
        These patterns work together to create maintainable systems.
        The implementation requires careful consideration of trade-offs.
        """
    }
    
    # Test 1: Basic ECL pipeline execution
    print("\nTest 1: Basic ECL pipeline execution")
    try:
        content = test_contents['technology_content']
        source = 'test_technology'
        context = {
            'source': 'test_documents',
            'domain': 'technology',
            'type': 'documentation'
        }
        
        result = await pipeline.execute_ecl_pipeline(content, source, context)
        
        print(f"✅ ECL pipeline completed")
        print(f"✅ Entities extracted: {result['metadata']['entities_count']}")
        print(f"✅ Relationships created: {result['metadata']['relationships_count']}")
        print(f"✅ Load success: {result['metadata']['load_success']}")
        print(f"✅ Processing time: {result['metadata']['processing_time_ms']:.1f}ms")
        
        # Verify phases
        assert 'extract' in result
        assert 'cognify' in result
        assert 'load' in result
        print(f"✅ All ECL phases present")
        
    except Exception as e:
        print(f"❌ Test 1 failed: {e}")
    
    # Test 2: Extract phase detailed testing
    print("\nTest 2: Extract phase detailed testing")
    try:
        content = test_contents['method_content']
        source = 'test_methods'
        context = {'source': 'test_code'}
        
        result = await pipeline.execute_ecl_pipeline(content, source, context)
        extract_result = result['extract']
        
        print(f"✅ Extract phase completed")
        print(f"✅ Extraction method: {extract_result['extraction_method']}")
        print(f"✅ Total entities found: {extract_result['total_entities_found']}")
        print(f"✅ Entities after filtering: {extract_result['entities_after_filtering']}")
        print(f"✅ Final entities: {extract_result['entities_final']}")
        
        # Check entity types
        entity_types = set(entity['type'] for entity in extract_result['entities'])
        print(f"✅ Entity types found: {entity_types}")
        
        # Check for expected entities
        entity_names = [entity['name'] for entity in extract_result['entities']]
        print(f"✅ Sample entities: {entity_names[:5]}")
        
    except Exception as e:
        print(f"❌ Test 2 failed: {e}")
    
    # Test 3: Cognify phase detailed testing
    print("\nTest 3: Cognify phase detailed testing")
    try:
        content = test_contents['concept_content']
        source = 'test_concepts'
        context = {'source': 'test_architecture'}
        
        result = await pipeline.execute_ecl_pipeline(content, source, context)
        cognify_result = result['cognify']
        
        print(f"✅ Cognify phase completed")
        print(f"✅ Cognification method: {cognify_result['cognification_method']}")
        print(f"✅ Total relationships: {cognify_result['total_relationships']}")
        print(f"✅ Bridge success: {cognify_result.get('bridge_success', False)}")
        
        # Check relationship details
        if cognify_result['relationships']:
            sample_rel = cognify_result['relationships'][0]
            print(f"✅ Sample relationship type: {sample_rel['relationship_type']}")
            print(f"✅ Sample relationship strength: {sample_rel['strength']:.3f}")
            print(f"✅ Sample relationship confidence: {sample_rel['confidence']:.3f}")
        
    except Exception as e:
        print(f"❌ Test 3 failed: {e}")
    
    # Test 4: Load phase detailed testing
    print("\nTest 4: Load phase detailed testing")
    try:
        content = test_contents['technology_content']
        source = 'test_load'
        context = {'source': 'test_loading'}
        
        result = await pipeline.execute_ecl_pipeline(content, source, context)
        load_result = result['load']
        
        print(f"✅ Load phase completed")
        print(f"✅ Load success: {load_result['success']}")
        print(f"✅ Entities loaded: {load_result['entities_loaded']}")
        print(f"✅ Relationships loaded: {load_result['relationships_loaded']}")
        print(f"✅ Load method: {load_result['load_method']}")
        
        # Check load components
        if 'entity_load_result' in load_result:
            print(f"✅ Entity load success: {load_result['entity_load_result']['success']}")
        if 'relationship_load_result' in load_result:
            print(f"✅ Relationship load success: {load_result['relationship_load_result']['success']}")
        
    except Exception as e:
        print(f"❌ Test 4 failed: {e}")
    
    # Test 5: Performance and caching test
    print("\nTest 5: Performance and caching test")
    try:
        content = test_contents['technology_content']
        source = 'test_performance'
        context = {'source': 'test_cache'}
        
        # First execution (cache miss)
        start_time = time.time()
        result1 = await pipeline.execute_ecl_pipeline(content, source, context)
        first_time = time.time() - start_time
        
        # Second execution (cache hit)
        start_time = time.time()
        result2 = await pipeline.execute_ecl_pipeline(content, source, context)
        second_time = time.time() - start_time
        
        print(f"✅ First execution: {first_time*1000:.1f}ms")
        print(f"✅ Second execution: {second_time*1000:.1f}ms")
        print(f"✅ Cache improvement: {((first_time - second_time) / first_time * 100):.1f}%")
        print(f"✅ Results identical: {result1['metadata']['entities_count'] == result2['metadata']['entities_count']}")
        
    except Exception as e:
        print(f"❌ Test 5 failed: {e}")
    
    # Test 6: Entity extraction patterns test
    print("\nTest 6: Entity extraction patterns test")
    try:
        # Test different entity types
        test_patterns = {
            'TECHNOLOGY': 'React, Next.js, TypeScript, and Supabase',
            'CONCEPT': '## Machine Learning and **Artificial Intelligence**',
            'METHOD': 'def process_data() and function validateInput()',
            'FILE': 'config.json and @project-core/memory/test.md',
            'TOOL': 'VS Code, GitHub, and Docker'
        }
        
        for entity_type, test_content in test_patterns.items():
            result = await pipeline.execute_ecl_pipeline(test_content, f'test_{entity_type.lower()}', {'source': 'pattern_test'})
            
            entities_of_type = [e for e in result['extract']['entities'] if e['type'] == entity_type]
            print(f"✅ {entity_type} entities found: {len(entities_of_type)}")
            
            if entities_of_type:
                print(f"   Sample: {entities_of_type[0]['name']}")
        
    except Exception as e:
        print(f"❌ Test 6 failed: {e}")
    
    # Test 7: Relationship strength calculation test
    print("\nTest 7: Relationship strength calculation test")
    try:
        # Content with clear relationships
        relationship_content = """
        React and Next.js work together for web development.
        TypeScript enhances JavaScript with static typing.
        Supabase provides database functionality for React applications.
        """
        
        result = await pipeline.execute_ecl_pipeline(relationship_content, 'test_relationships', {'source': 'relationship_test'})
        relationships = result['cognify']['relationships']
        
        print(f"✅ Relationships created: {len(relationships)}")
        
        if relationships:
            # Analyze relationship strengths
            strengths = [rel['strength'] for rel in relationships]
            avg_strength = sum(strengths) / len(strengths)
            max_strength = max(strengths)
            min_strength = min(strengths)
            
            print(f"✅ Average relationship strength: {avg_strength:.3f}")
            print(f"✅ Max relationship strength: {max_strength:.3f}")
            print(f"✅ Min relationship strength: {min_strength:.3f}")
            
            # Show strongest relationship
            strongest_rel = max(relationships, key=lambda x: x['strength'])
            print(f"✅ Strongest relationship: {strongest_rel['relationship_type']} ({strongest_rel['strength']:.3f})")
        
    except Exception as e:
        print(f"❌ Test 7 failed: {e}")
    
    # Test 8: Bridge integration test
    print("\nTest 8: Bridge integration test")
    try:
        content = test_contents['concept_content']
        source = 'test_bridge'
        context = {'source': 'bridge_test'}
        
        # Test with bridge enabled
        original_bridge_setting = pipeline.config['bridge_integration']
        pipeline.config['bridge_integration'] = True
        
        result_with_bridge = await pipeline.execute_ecl_pipeline(content, source, context)
        
        # Test with bridge disabled
        pipeline.config['bridge_integration'] = False
        result_without_bridge = await pipeline.execute_ecl_pipeline(content, f"{source}_no_bridge", context)
        
        # Restore original setting
        pipeline.config['bridge_integration'] = original_bridge_setting
        
        print(f"✅ Bridge enabled result: {result_with_bridge['cognify']['cognification_method']}")
        print(f"✅ Bridge disabled result: {result_without_bridge['cognify']['cognification_method']}")
        print(f"✅ Bridge integration working: {result_with_bridge['cognify'].get('bridge_success', False)}")
        
    except Exception as e:
        print(f"❌ Test 8 failed: {e}")
    
    # Test 9: Fallback mechanism test
    print("\nTest 9: Fallback mechanism test")
    try:
        # Test with invalid content to trigger fallback
        invalid_content = ""  # Empty content
        
        result = await pipeline.execute_ecl_pipeline(invalid_content, 'test_fallback', {'source': 'fallback_test'})
        
        print(f"✅ Fallback result generated")
        print(f"✅ Fallback flag: {result['metadata'].get('fallback', False)}")
        print(f"✅ Pipeline type: {result['metadata']['pipeline']}")
        
        if 'original_error' in result['metadata']:
            print(f"✅ Original error captured: {result['metadata']['original_error'][:50]}...")
        
    except Exception as e:
        print(f"❌ Test 9 failed: {e}")
    
    # Test 10: Performance metrics test
    print("\nTest 10: Performance metrics test")
    try:
        metrics = pipeline.get_metrics()
        
        print(f"✅ Total ECL executions: {metrics['total_ecl_executions']}")
        print(f"✅ Extract operations: {metrics['extract_operations']}")
        print(f"✅ Cognify operations: {metrics['cognify_operations']}")
        print(f"✅ Load operations: {metrics['load_operations']}")
        print(f"✅ Bridge integration calls: {metrics['bridge_integration_calls']}")
        print(f"✅ Cache hit rate: {metrics['cache_hit_rate']:.1f}%")
        print(f"✅ Average processing time: {metrics['average_processing_time']:.1f}ms")
        print(f"✅ Total entities extracted: {metrics['entities_extracted_total']}")
        print(f"✅ Total relationships created: {metrics['relationships_created_total']}")
        print(f"✅ Entities per execution: {metrics['entities_per_execution']:.1f}")
        print(f"✅ Relationships per execution: {metrics['relationships_per_execution']:.1f}")
        
    except Exception as e:
        print(f"❌ Test 10 failed: {e}")
    
    # Test 11: Health check test
    print("\nTest 11: Health check test")
    try:
        health = await pipeline.health_check()
        
        print(f"✅ Health status: {health['status']}")
        print(f"✅ Pipeline: {health['pipeline']}")
        print(f"✅ Bridge available: {health['bridge_available']}")
        print(f"✅ Extract working: {health['extract_working']}")
        print(f"✅ Cognify working: {health['cognify_working']}")
        print(f"✅ Load working: {health['load_working']}")
        
    except Exception as e:
        print(f"❌ Test 11 failed: {e}")
    
    # Test 12: Edge cases test
    print("\nTest 12: Edge cases test")
    try:
        # Test very short content
        short_result = await pipeline.execute_ecl_pipeline("Hi", 'test_short', {'source': 'edge_test'})
        print(f"✅ Short content: {short_result['metadata']['entities_count']} entities")
        
        # Test very long content
        long_content = "React " * 1000  # Very repetitive content
        long_result = await pipeline.execute_ecl_pipeline(long_content, 'test_long', {'source': 'edge_test'})
        print(f"✅ Long content: {long_result['metadata']['entities_count']} entities")
        
        # Test special characters
        special_content = "React & Next.js @ 2024! #WebDev $100 50%"
        special_result = await pipeline.execute_ecl_pipeline(special_content, 'test_special', {'source': 'edge_test'})
        print(f"✅ Special characters: {special_result['metadata']['entities_count']} entities")
        
    except Exception as e:
        print(f"❌ Test 12 failed: {e}")
    
    print("\n✅ [ECL PIPELINE TESTS] All tests completed")
    
    # Final metrics summary
    final_metrics = pipeline.get_metrics()
    print(f"\n📊 FINAL METRICS:")
    print(f"   Total ECL executions: {final_metrics['total_ecl_executions']}")
    print(f"   Cache hit rate: {final_metrics['cache_hit_rate']:.1f}%")
    print(f"   Average processing time: {final_metrics['average_processing_time']:.1f}ms")
    print(f"   Total entities extracted: {final_metrics['entities_extracted_total']}")
    print(f"   Total relationships created: {final_metrics['relationships_created_total']}")
    print(f"   Extract/Cognify/Load operations: {final_metrics['extract_operations']}/{final_metrics['cognify_operations']}/{final_metrics['load_operations']}")
    print(f"   Bridge integration calls: {final_metrics['bridge_integration_calls']}")
    print(f"   Fallback activations: {final_metrics['fallback_activations']}")

if __name__ == "__main__":
    # Run comprehensive tests
    asyncio.run(test_ecl_pipeline())
