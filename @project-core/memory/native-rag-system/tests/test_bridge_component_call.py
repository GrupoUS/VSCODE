#!/usr/bin/env python3

"""
BRIDGE COMPONENT CALL TEST V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Teste específico para chamadas de componentes JavaScript via bridge.
"""

import asyncio
import sys
from pathlib import Path

# Add parent directory for imports
sys.path.append(str(Path(__file__).parent.parent))

from integration.js_bridge import JavaScriptBridge

async def test_component_calls():
    """Test specific component calls"""
    print("🧪 [BRIDGE COMPONENT TEST] Testing component calls...")
    
    bridge = JavaScriptBridge()
    
    # Test 1: Embedding Service
    print("\n📋 Test 1: Embedding Service")
    try:
        result = await bridge.call_js_component(
            'embedding_service', 
            'generateContextualEmbedding', 
            ['test content', {}]
        )
        print(f"✅ Embedding service result: {type(result)}")
        if isinstance(result, dict):
            print(f"   Model: {result.get('model', 'N/A')}")
            print(f"   Dimensions: {result.get('dimensions', 'N/A')}")
            print(f"   Embedding length: {len(result.get('embedding', []))}")
        else:
            print(f"   Raw result: {str(result)[:200]}...")
    except Exception as error:
        print(f"❌ Embedding service failed: {error}")
    
    # Test 2: Knowledge Graph
    print("\n📋 Test 2: Knowledge Graph")
    try:
        result = await bridge.call_js_component(
            'knowledge_graph', 
            'extractEntities', 
            ['test content with React and JavaScript']
        )
        print(f"✅ Knowledge graph result: {type(result)}")
        if isinstance(result, list):
            print(f"   Entities extracted: {len(result)}")
            for entity in result[:3]:  # Show first 3
                print(f"   - {entity.get('name', 'N/A')} ({entity.get('type', 'N/A')})")
        else:
            print(f"   Raw result: {str(result)[:200]}...")
    except Exception as error:
        print(f"❌ Knowledge graph failed: {error}")
    
    # Test 3: Bridge Metrics
    print("\n📊 Bridge Metrics:")
    metrics = bridge.get_metrics()
    for key, value in metrics.items():
        print(f"   {key}: {value}")
    
    return bridge

if __name__ == "__main__":
    asyncio.run(test_component_calls())
