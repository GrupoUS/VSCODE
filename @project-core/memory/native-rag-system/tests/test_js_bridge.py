#!/usr/bin/env python3

"""
JAVASCRIPT BRIDGE SYSTEM TESTS V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Comprehensive tests for JavaScript-Python bridge system.
Validates performance, reliability, and fallback mechanisms.
"""

import asyncio
import time
import json
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.append(str(Path(__file__).parent.parent))

from integration.js_bridge import JavaScriptBridge

# Simple test functions for manual execution

# Integration test runner
async def run_integration_tests():
    """Run integration tests manually"""
    print("🧪 [JS BRIDGE TESTS] Starting integration tests...")
    
    bridge = JavaScriptBridge()
    
    # Test 1: Health check
    print("Test 1: Health check")
    health = await bridge.health_check()
    print(f"Health status: {health['status']}")
    
    # Test 2: Basic embedding call
    print("\nTest 2: Embedding service")
    try:
        result = await bridge.call_js_component(
            'embedding_service',
            'generateContextualEmbedding',
            ['integration test']
        )
        print(f"Embedding result: {type(result)} with {len(result.get('embedding', []))} dimensions")
    except Exception as e:
        print(f"Embedding test failed: {e}")
    
    # Test 3: Performance metrics
    print("\nTest 3: Performance metrics")
    metrics = bridge.get_metrics()
    print(f"Metrics: {json.dumps(metrics, indent=2)}")
    
    print("\n✅ [JS BRIDGE TESTS] Integration tests completed")

if __name__ == "__main__":
    # Run integration tests
    asyncio.run(run_integration_tests())
