#!/usr/bin/env python3

"""
BRIDGE PATH FIX TEST V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Teste direto para verificar e corrigir paths do bridge JavaScript.
"""

import asyncio
import sys
from pathlib import Path

# Add parent directory for imports
sys.path.append(str(Path(__file__).parent.parent))

from integration.js_bridge import JavaScriptBridge

async def test_bridge_paths():
    """Test bridge paths directly"""
    print("🔍 [BRIDGE PATH TEST] Testing bridge paths...")
    
    # Create new bridge instance
    bridge = JavaScriptBridge()
    
    print(f"📁 Memory dir: {bridge.memory_dir}")
    print(f"📁 Cache dir: {bridge.cache_dir}")
    print(f"📁 Memory dir exists: {bridge.memory_dir.exists()}")
    
    # Check JavaScript component paths
    for component, relative_path in bridge.js_components.items():
        full_path = bridge.memory_dir / relative_path
        print(f"📄 {component}:")
        print(f"   Relative: {relative_path}")
        print(f"   Full: {full_path}")
        print(f"   Exists: {full_path.exists()}")
        
        if full_path.exists():
            print(f"   ✅ File found!")
        else:
            print(f"   ❌ File not found")
    
    # Test health check
    health = await bridge.health_check()
    print(f"\n🏥 Health check: {health}")
    
    return bridge

if __name__ == "__main__":
    asyncio.run(test_bridge_paths())
