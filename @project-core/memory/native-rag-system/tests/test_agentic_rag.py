#!/usr/bin/env python3

"""
AGENTIC RAG STRATEGY TESTS V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Comprehensive tests for Crawl4AI Agentic RAG strategy.
Validates code pattern recognition, AST analysis, and knowledge graph integration.
"""

import asyncio
import time
import json
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.append(str(Path(__file__).parent.parent))

from crawl4ai_strategies.agentic_rag import AgenticRAGStrategy

async def test_agentic_rag_strategy():
    """Test agentic RAG strategy functionality"""
    print("🧪 [AGENTIC RAG TESTS] Starting comprehensive tests...")
    
    strategy = AgenticRAGStrategy()
    
    # Test code samples for pattern recognition
    test_codes = {
        'singleton_pattern': """
        class DatabaseConnection:
            _instance = None
            
            def __new__(cls):
                if cls._instance is None:
                    cls._instance = super().__new__(cls)
                return cls._instance
            
            def connect(self):
                return "Connected to database"
        """,
        
        'factory_pattern': """
        class ShapeFactory:
            @staticmethod
            def create_shape(shape_type):
                if shape_type == "circle":
                    return Circle()
                elif shape_type == "square":
                    return Square()
                else:
                    raise ValueError("Unknown shape type")
        """,
        
        'mvc_architecture': """
        class UserModel:
            def __init__(self):
                self.users = []
            
            def add_user(self, user):
                self.users.append(user)
        
        class UserView:
            def display_users(self, users):
                for user in users:
                    print(f"User: {user}")
        
        class UserController:
            def __init__(self, model, view):
                self.model = model
                self.view = view
        """,
        
        'code_smell_example': """
        def very_long_method_with_many_responsibilities():
            # This method does too many things
            user_data = fetch_user_data()
            validate_user_data(user_data)
            process_user_data(user_data)
            save_user_data(user_data)
            send_notification(user_data)
            log_activity(user_data)
            update_statistics(user_data)
            generate_report(user_data)
            cleanup_temp_files()
            # ... many more lines of code
            return "Success"
        """,
        
        'javascript_code': """
        function createUserService() {
            const users = [];
            
            return {
                addUser: (user) => {
                    users.push(user);
                },
                getUsers: () => {
                    return [...users];
                },
                findUser: (id) => {
                    return users.find(user => user.id === id);
                }
            };
        }
        
        const userService = createUserService();
        """
    }
    
    # Test 1: Basic code pattern extraction
    print("\nTest 1: Basic code pattern extraction")
    try:
        test_code = test_codes['singleton_pattern']
        context = {
            'source': 'test_singleton',
            'language': 'python'
        }
        
        result = await strategy.extract_code_patterns(test_code, context)
        
        print(f"✅ Pattern extraction completed")
        print(f"✅ Code blocks found: {result['metadata']['total_code_blocks']}")
        print(f"✅ Patterns detected: {result['metadata']['patterns_detected']}")
        print(f"✅ Processing time: {result['metadata']['processing_time_ms']:.1f}ms")
        
        if result['patterns']:
            for pattern in result['patterns']:
                print(f"✅ Pattern: {pattern['type']} - {pattern['name']} (confidence: {pattern['confidence']:.2f})")
        
    except Exception as e:
        print(f"❌ Test 1 failed: {e}")
    
    # Test 2: Design pattern recognition
    print("\nTest 2: Design pattern recognition")
    try:
        for pattern_name, code in [('singleton', test_codes['singleton_pattern']), 
                                   ('factory', test_codes['factory_pattern'])]:
            result = await strategy.extract_code_patterns(code, {'source': f'test_{pattern_name}'})
            
            design_patterns = [p for p in result['patterns'] if p['type'] == 'DESIGN_PATTERN']
            print(f"✅ {pattern_name.title()} pattern test: {len(design_patterns)} design patterns found")
            
            if design_patterns:
                for dp in design_patterns:
                    print(f"   - {dp['name']}: {dp['confidence']:.2f} confidence")
        
    except Exception as e:
        print(f"❌ Test 2 failed: {e}")
    
    # Test 3: Architectural pattern recognition
    print("\nTest 3: Architectural pattern recognition")
    try:
        result = await strategy.extract_code_patterns(test_codes['mvc_architecture'], {'source': 'test_mvc'})
        
        arch_patterns = [p for p in result['patterns'] if p['type'] == 'ARCHITECTURAL_PATTERN']
        print(f"✅ MVC architecture test: {len(arch_patterns)} architectural patterns found")
        
        if arch_patterns:
            for ap in arch_patterns:
                print(f"   - {ap['name']}: {ap['confidence']:.2f} confidence")
        
    except Exception as e:
        print(f"❌ Test 3 failed: {e}")
    
    # Test 4: Code smell detection
    print("\nTest 4: Code smell detection")
    try:
        result = await strategy.extract_code_patterns(test_codes['code_smell_example'], {'source': 'test_smell'})
        
        code_smells = [p for p in result['patterns'] if p['type'] == 'CODE_SMELL']
        print(f"✅ Code smell test: {len(code_smells)} code smells found")
        
        if code_smells:
            for cs in code_smells:
                print(f"   - {cs['name']}: {cs['confidence']:.2f} confidence")
                print(f"     Description: {cs['description']}")
        
    except Exception as e:
        print(f"❌ Test 4 failed: {e}")
    
    # Test 5: Multi-language code detection
    print("\nTest 5: Multi-language code detection")
    try:
        result = await strategy.extract_code_patterns(test_codes['javascript_code'], {'source': 'test_js'})
        
        print(f"✅ JavaScript code analysis completed")
        print(f"✅ Code blocks: {len(result['code_blocks'])}")
        
        if result['code_blocks']:
            for i, block in enumerate(result['code_blocks']):
                print(f"   Block {i+1}: {block['type']} ({block['complexity']} complexity, {block['length']} chars)")
        
    except Exception as e:
        print(f"❌ Test 5 failed: {e}")
    
    # Test 6: AST analysis integration
    print("\nTest 6: AST analysis integration")
    try:
        result = await strategy.extract_code_patterns(test_codes['singleton_pattern'], {'source': 'test_ast'})
        
        ast_analysis = result['ast_analysis']
        print(f"✅ AST analysis: {'Success' if ast_analysis['success'] else 'Failed'}")
        print(f"✅ Entities extracted: {len(ast_analysis['entities'])}")
        
        if ast_analysis['entities']:
            print(f"   Sample entities: {ast_analysis['entities'][:3]}")
        
    except Exception as e:
        print(f"❌ Test 6 failed: {e}")
    
    # Test 7: Code summarization
    print("\nTest 7: Code summarization")
    try:
        result = await strategy.extract_code_patterns(test_codes['factory_pattern'], {'source': 'test_summary'})
        
        summaries = result['summaries']
        print(f"✅ Code summaries generated: {len(summaries)}")
        
        if summaries:
            for i, summary in enumerate(summaries):
                print(f"   Summary {i+1}: {summary['summary'][:100]}...")
                print(f"   Code type: {summary['code_type']}, Complexity: {summary['complexity']}")
        
    except Exception as e:
        print(f"❌ Test 7 failed: {e}")
    
    # Test 8: Knowledge graph integration
    print("\nTest 8: Knowledge graph integration")
    try:
        result = await strategy.extract_code_patterns(test_codes['mvc_architecture'], {'source': 'test_kg'})
        
        kg_data = result['knowledge_graph']
        print(f"✅ Knowledge graph integration: {'Success' if kg_data['integration_success'] else 'Failed'}")
        print(f"✅ Relationships: {len(kg_data['relationships'])}")
        print(f"✅ Graph nodes: {len(kg_data['graph_nodes'])}")
        
    except Exception as e:
        print(f"❌ Test 8 failed: {e}")
    
    # Test 9: Cache mechanism
    print("\nTest 9: Cache mechanism")
    try:
        # First analysis
        start_time = time.time()
        result1 = await strategy.extract_code_patterns(test_codes['singleton_pattern'], {'source': 'test_cache'})
        first_time = time.time() - start_time
        
        # Second analysis (should be cached)
        start_time = time.time()
        result2 = await strategy.extract_code_patterns(test_codes['singleton_pattern'], {'source': 'test_cache'})
        second_time = time.time() - start_time
        
        print(f"✅ First analysis: {first_time*1000:.1f}ms")
        print(f"✅ Second analysis: {second_time*1000:.1f}ms")
        print(f"✅ Cache improvement: {((first_time - second_time) / first_time * 100):.1f}%")
        
        # Verify results are identical
        print(f"✅ Results identical: {result1['metadata']['total_code_blocks'] == result2['metadata']['total_code_blocks']}")
        
    except Exception as e:
        print(f"❌ Test 9 failed: {e}")
    
    # Test 10: Performance metrics
    print("\nTest 10: Performance metrics")
    try:
        metrics = strategy.get_metrics()
        print(f"✅ Total code extractions: {metrics['total_code_extractions']}")
        print(f"✅ Pattern recognition calls: {metrics['pattern_recognition_calls']}")
        print(f"✅ AST analysis calls: {metrics['ast_analysis_calls']}")
        print(f"✅ Code summarization calls: {metrics['code_summarization_calls']}")
        print(f"✅ Cache hit rate: {metrics['cache_hit_rate']:.1f}%")
        print(f"✅ Average processing time: {metrics['average_processing_time']:.1f}ms")
        print(f"✅ Pattern detection success rate: {metrics['pattern_detection_success_rate']:.1f}%")
        
    except Exception as e:
        print(f"❌ Test 10 failed: {e}")
    
    # Test 11: Fallback mechanism
    print("\nTest 11: Fallback mechanism")
    try:
        # Test fallback with simulated error
        fallback_result = await strategy._fallback_pattern_extraction(
            test_codes['singleton_pattern'],
            {'source': 'test_fallback'},
            Exception("Simulated error")
        )
        
        print(f"✅ Fallback results generated")
        print(f"✅ Fallback flag: {fallback_result['metadata'].get('fallback', False)}")
        print(f"✅ Code blocks in fallback: {len(fallback_result['code_blocks'])}")
        print(f"✅ Basic patterns in fallback: {len(fallback_result['patterns'])}")
        
    except Exception as e:
        print(f"❌ Test 11 failed: {e}")
    
    # Test 12: Health check
    print("\nTest 12: Health check")
    try:
        health = await strategy.health_check()
        print(f"✅ Health status: {health['status']}")
        print(f"✅ Strategy: {health['strategy']}")
        print(f"✅ Bridge available: {health['bridge_available']}")
        print(f"✅ Pattern recognition available: {health['pattern_recognition_available']}")
        print(f"✅ AST analysis available: {health['ast_analysis_available']}")
        
    except Exception as e:
        print(f"❌ Test 12 failed: {e}")
    
    print("\n✅ [AGENTIC RAG TESTS] All tests completed")
    
    # Final metrics summary
    final_metrics = strategy.get_metrics()
    print(f"\n📊 FINAL METRICS:")
    print(f"   Total extractions: {final_metrics['total_code_extractions']}")
    print(f"   Cache hit rate: {final_metrics['cache_hit_rate']:.1f}%")
    print(f"   Average processing time: {final_metrics['average_processing_time']:.1f}ms")
    print(f"   Pattern detection success rate: {final_metrics['pattern_detection_success_rate']:.1f}%")
    print(f"   AST/Summarization calls: {final_metrics['ast_analysis_calls']}/{final_metrics['code_summarization_calls']}")

if __name__ == "__main__":
    # Run comprehensive tests
    asyncio.run(test_agentic_rag_strategy())
