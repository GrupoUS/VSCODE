#!/usr/bin/env python3

"""
NODE.JS DIRECT TEST V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Teste direto do Node.js para diagnosticar problemas de comunicação.
"""

import asyncio
import subprocess
import json
from pathlib import Path

async def test_nodejs_direct():
    """Test Node.js execution directly"""
    print("🟢 [NODE.JS DIRECT TEST] Testing Node.js execution...")
    
    memory_dir = Path(__file__).parent.parent.parent
    component_path = memory_dir / 'rag-enhanced/contextual-embeddings/embedding-service.js'
    
    print(f"📁 Memory dir: {memory_dir}")
    print(f"📄 Component path: {component_path}")
    print(f"📄 Component exists: {component_path.exists()}")
    
    # Test 1: Simple Node.js execution
    print("\n📋 Test 1: Simple Node.js execution")
    simple_js = "console.log(JSON.stringify({success: true, message: 'Hello from Node.js'}));"
    
    try:
        result = subprocess.run(
            ['node', '-e', simple_js],
            capture_output=True,
            text=True,
            timeout=10
        )
        print(f"✅ Simple test - Return code: {result.returncode}")
        print(f"✅ Simple test - Stdout: {result.stdout}")
        print(f"✅ Simple test - Stderr: {result.stderr}")
    except Exception as error:
        print(f"❌ Simple test failed: {error}")
    
    # Test 2: Component loading test
    print("\n📋 Test 2: Component loading test")
    component_js = f"""
    try {{
        const EmbeddingService = require('{str(component_path).replace(chr(92), '/')}');
        console.log(JSON.stringify({{
            success: true,
            componentLoaded: true,
            componentType: typeof EmbeddingService
        }}));
    }} catch (error) {{
        console.log(JSON.stringify({{
            success: false,
            error: error.message,
            stack: error.stack
        }}));
    }}
    """
    
    try:
        result = subprocess.run(
            ['node', '-e', component_js],
            capture_output=True,
            text=True,
            timeout=15,
            cwd=memory_dir
        )
        print(f"✅ Component loading - Return code: {result.returncode}")
        print(f"✅ Component loading - Stdout: {result.stdout}")
        print(f"✅ Component loading - Stderr: {result.stderr}")
        
        if result.stdout.strip():
            try:
                parsed = json.loads(result.stdout.strip())
                print(f"✅ Parsed JSON: {parsed}")
            except json.JSONDecodeError as e:
                print(f"❌ JSON parse error: {e}")
                print(f"   Raw stdout: {repr(result.stdout)}")
    except Exception as error:
        print(f"❌ Component loading test failed: {error}")
    
    # Test 3: Method execution test
    print("\n📋 Test 3: Method execution test")
    method_js = f"""
    try {{
        const EmbeddingService = require('{str(component_path).replace(chr(92), '/')}');
        const service = new EmbeddingService();
        
        // Call the method
        service.generateContextualEmbedding('test content', {{}})
            .then(result => {{
                console.log(JSON.stringify({{
                    success: true,
                    methodCalled: true,
                    resultType: typeof result,
                    hasEmbedding: result && result.embedding !== undefined
                }}));
            }})
            .catch(error => {{
                console.log(JSON.stringify({{
                    success: false,
                    methodError: error.message
                }}));
            }});
    }} catch (error) {{
        console.log(JSON.stringify({{
            success: false,
            error: error.message
        }}));
    }}
    """
    
    try:
        result = subprocess.run(
            ['node', '-e', method_js],
            capture_output=True,
            text=True,
            timeout=20,
            cwd=memory_dir
        )
        print(f"✅ Method execution - Return code: {result.returncode}")
        print(f"✅ Method execution - Stdout: {result.stdout}")
        print(f"✅ Method execution - Stderr: {result.stderr}")
        
        if result.stdout.strip():
            try:
                parsed = json.loads(result.stdout.strip())
                print(f"✅ Parsed JSON: {parsed}")
            except json.JSONDecodeError as e:
                print(f"❌ JSON parse error: {e}")
                print(f"   Raw stdout: {repr(result.stdout)}")
    except Exception as error:
        print(f"❌ Method execution test failed: {error}")
    
    # Test 4: Bridge-style execution test
    print("\n📋 Test 4: Bridge-style execution test")
    bridge_js = f"""
    const component = require('{str(component_path).replace(chr(92), '/')}');
    const method = 'generateContextualEmbedding';
    const args = ['test content', {{}}];
    
    async function executeMethod() {{
        try {{
            let instance;
            
            // Handle different component types
            if (typeof component === 'function') {{
                instance = new component();
            }} else if (typeof component === 'object') {{
                instance = component;
            }} else {{
                throw new Error('Invalid component type');
            }}
            
            // Call the method
            let result;
            if (typeof instance[method] === 'function') {{
                result = await instance[method](...args);
            }} else {{
                throw new Error(`Method ${{method}} not found`);
            }}
            
            // Return structured result
            console.log(JSON.stringify({{
                success: true,
                result: result,
                timestamp: new Date().toISOString(),
                component: 'embedding_service',
                method: 'generateContextualEmbedding'
            }}));
            
        }} catch (error) {{
            console.log(JSON.stringify({{
                success: false,
                error: error.message,
                stack: error.stack,
                timestamp: new Date().toISOString(),
                component: 'embedding_service',
                method: 'generateContextualEmbedding'
            }}));
        }}
    }}
    
    executeMethod();
    """
    
    try:
        result = subprocess.run(
            ['node', '-e', bridge_js],
            capture_output=True,
            text=True,
            timeout=25,
            cwd=memory_dir
        )
        print(f"✅ Bridge-style - Return code: {result.returncode}")
        print(f"✅ Bridge-style - Stdout length: {len(result.stdout)}")
        print(f"✅ Bridge-style - Stderr: {result.stderr}")
        
        if result.stdout.strip():
            # Try to find JSON in the output
            lines = result.stdout.strip().split('\n')
            for i, line in enumerate(lines):
                print(f"   Line {i+1}: {repr(line)}")
                if line.strip().startswith('{'):
                    try:
                        parsed = json.loads(line.strip())
                        print(f"✅ Found valid JSON on line {i+1}: {parsed.get('success', 'N/A')}")
                        if parsed.get('success') and parsed.get('result'):
                            result_data = parsed['result']
                            print(f"   Model: {result_data.get('model', 'N/A')}")
                            print(f"   Dimensions: {result_data.get('dimensions', 'N/A')}")
                        break
                    except json.JSONDecodeError:
                        continue
        else:
            print("❌ No stdout output")
    except Exception as error:
        print(f"❌ Bridge-style test failed: {error}")

if __name__ == "__main__":
    asyncio.run(test_nodejs_direct())
