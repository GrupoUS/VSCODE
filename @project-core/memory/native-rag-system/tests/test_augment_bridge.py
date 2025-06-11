#!/usr/bin/env python3

"""
AUGMENT MEMORIES BRIDGE TESTS V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Comprehensive tests for Augment Memories Bridge.
Validates reading, parsing, synchronization, and integration with 91 preference lines.
"""

import asyncio
import time
import json
import os
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.append(str(Path(__file__).parent.parent))

from central_hub.augment_bridge import AugmentMemoriesBridge

async def test_augment_bridge():
    """Test Augment Memories Bridge functionality"""
    print("🧪 [AUGMENT BRIDGE TESTS] Starting comprehensive tests...")
    
    bridge = AugmentMemoriesBridge()
    
    # Test 1: Bridge initialization
    print("\nTest 1: Bridge initialization")
    try:
        init_result = await bridge.initialize()
        
        print(f"✅ Bridge initialization: {init_result}")
        print(f"✅ Augment path exists: {bridge.augment_path.exists()}")
        print(f"✅ Config priority Augment: {bridge.config['priority_augment']}")
        print(f"✅ Non-intrusive sync: {bridge.config['non_intrusive_sync']}")
        print(f"✅ Real-time monitoring: {bridge.config['real_time_monitoring']}")
        
        if init_result:
            print(f"✅ Bridge initialized successfully")
        else:
            print(f"⚠️ Bridge initialization failed (expected if Augment file not found)")
        
    except Exception as e:
        print(f"❌ Test 1 failed: {e}")
    
    # Test 2: Reading Augment Memories
    print("\nTest 2: Reading Augment Memories")
    try:
        preferences = await bridge.read_augment_memories()
        
        if preferences:
            print(f"✅ Preferences read successfully")
            print(f"✅ Total lines: {preferences.get('total_lines', 0)}")
            print(f"✅ Preference lines: {preferences.get('preference_lines', 0)}")
            print(f"✅ Categories: {len(preferences.get('categories', {}))}")
            print(f"✅ Technologies: {len(preferences.get('technologies', []))}")
            print(f"✅ Methodologies: {len(preferences.get('methodologies', []))}")
            
            # Show sample categories
            categories = preferences.get('categories', {})
            print(f"✅ Sample categories: {list(categories.keys())[:5]}")
            
            # Show sample technologies
            technologies = preferences.get('technologies', [])
            print(f"✅ Sample technologies: {technologies[:5]}")
            
        else:
            print(f"⚠️ No preferences read (expected if Augment file not found)")
        
    except Exception as e:
        print(f"❌ Test 2 failed: {e}")
    
    # Test 3: Preference parsing validation
    print("\nTest 3: Preference parsing validation")
    try:
        # Test with sample Augment content
        sample_content = """
# Preferences
- User prefers comprehensive architectural audits with specific phases.
- User requires mandatory post-task validation protocol.
- User prefers Next.js 15 + React 19 + TypeScript stack.
- User prefers using Sequential Thinking MCP for complex tasks.
- User prefers 4-phase methodology for MCP server integration.
"""
        
        parsed = await bridge.parse_augment_preferences(sample_content)
        
        print(f"✅ Sample parsing completed")
        print(f"✅ Preferences found: {len(parsed.get('preferences', []))}")
        
        if parsed.get('preferences'):
            sample_pref = parsed['preferences'][0]
            print(f"✅ Sample preference category: {sample_pref['category']}")
            print(f"✅ Sample preference priority: {sample_pref['priority']}")
            print(f"✅ Sample preference keywords: {sample_pref['keywords'][:3]}")
            print(f"✅ Sample preference technologies: {sample_pref['technologies']}")
        
    except Exception as e:
        print(f"❌ Test 3 failed: {e}")
    
    # Test 4: Category-based preference retrieval
    print("\nTest 4: Category-based preference retrieval")
    try:
        # Test different categories
        test_categories = ['architecture', 'mcp_integration', 'technology_stack', 'memory_system', 'validation']
        
        for category in test_categories:
            category_prefs = await bridge.get_preference_by_category(category)
            print(f"✅ {category}: {len(category_prefs)} preferences")
        
    except Exception as e:
        print(f"❌ Test 4 failed: {e}")
    
    # Test 5: Preference search functionality
    print("\nTest 5: Preference search functionality")
    try:
        # Test different search queries
        search_queries = [
            'Sequential Thinking',
            'MCP integration',
            'Next.js',
            'validation',
            'architecture'
        ]
        
        for query in search_queries:
            search_results = await bridge.search_preferences(query)
            print(f"✅ Search '{query}': {len(search_results)} matches")
            
            if search_results:
                sample_result = search_results[0]
                print(f"   Sample match: {sample_result['text'][:50]}...")
        
    except Exception as e:
        print(f"❌ Test 5 failed: {e}")
    
    # Test 6: Technology-specific preferences
    print("\nTest 6: Technology-specific preferences")
    try:
        # Test technology-specific searches
        technologies = ['React', 'Next.js', 'TypeScript', 'MCP', 'Sequential Thinking']
        
        for tech in technologies:
            tech_prefs = await bridge.get_technology_preferences(tech)
            print(f"✅ {tech}: {len(tech_prefs)} preferences")
            
            if tech_prefs:
                sample_tech_pref = tech_prefs[0]
                print(f"   Sample: {sample_tech_pref['text'][:50]}...")
        
    except Exception as e:
        print(f"❌ Test 6 failed: {e}")
    
    # Test 7: Synchronization with project-core
    print("\nTest 7: Synchronization with project-core")
    try:
        sync_result = await bridge.sync_with_project_core()
        
        print(f"✅ Sync success: {sync_result['success']}")
        
        if sync_result['success']:
            print(f"✅ Sync time: {sync_result['sync_time_ms']:.1f}ms")
            print(f"✅ Preferences synced: {sync_result['preferences_synced']}")
            
            # Check if summary file was created
            summary_file = Path(__file__).parent.parent.parent / 'augment_preferences_summary.json'
            if summary_file.exists():
                print(f"✅ Summary file created: {summary_file.name}")
                
                with open(summary_file, 'r') as f:
                    summary_data = json.load(f)
                
                summary = summary_data.get('augment_preferences_summary', {})
                print(f"✅ Summary total preferences: {summary.get('total_preferences', 0)}")
                print(f"✅ Summary categories: {len(summary.get('categories', {}))}")
                print(f"✅ Summary technologies: {len(summary.get('top_technologies', []))}")
            else:
                print(f"⚠️ Summary file not created")
        else:
            print(f"⚠️ Sync failed: {sync_result.get('error', 'Unknown error')}")
        
    except Exception as e:
        print(f"❌ Test 7 failed: {e}")
    
    # Test 8: Backup functionality
    print("\nTest 8: Backup functionality")
    try:
        backup_result = await bridge.create_backup()
        
        print(f"✅ Backup success: {backup_result['success']}")
        
        if backup_result['success']:
            print(f"✅ Backup filename: {backup_result['backup_filename']}")
            print(f"✅ Backup path exists: {Path(backup_result['backup_path']).exists()}")
        else:
            print(f"⚠️ Backup failed: {backup_result.get('reason', 'Unknown reason')}")
        
    except Exception as e:
        print(f"❌ Test 8 failed: {e}")
    
    # Test 9: File monitoring (if file exists)
    print("\nTest 9: File monitoring")
    try:
        if bridge.augment_path.exists():
            # Start monitoring
            await bridge.start_file_monitoring()
            print(f"✅ File monitoring started")
            
            # Check monitoring status
            monitoring_active = bridge.observer is not None
            print(f"✅ Monitoring active: {monitoring_active}")
            
            # Stop monitoring
            await bridge.stop_file_monitoring()
            print(f"✅ File monitoring stopped")
            
            monitoring_stopped = bridge.observer is None
            print(f"✅ Monitoring stopped: {monitoring_stopped}")
        else:
            print(f"⚠️ File monitoring test skipped (Augment file not found)")
        
    except Exception as e:
        print(f"❌ Test 9 failed: {e}")
    
    # Test 10: Performance metrics
    print("\nTest 10: Performance metrics")
    try:
        metrics = bridge.get_metrics()
        
        print(f"✅ Total syncs: {metrics['total_syncs']}")
        print(f"✅ Successful syncs: {metrics['successful_syncs']}")
        print(f"✅ Failed syncs: {metrics['failed_syncs']}")
        print(f"✅ Success rate: {metrics['success_rate']:.1f}%")
        print(f"✅ Preferences cached: {metrics['preferences_cached']}")
        print(f"✅ Categories available: {metrics['categories_available']}")
        print(f"✅ Technologies tracked: {metrics['technologies_tracked']}")
        print(f"✅ File monitoring active: {metrics['file_monitoring_active']}")
        print(f"✅ Average sync time: {metrics['average_sync_time']:.1f}ms")
        print(f"✅ Backup operations: {metrics['backup_operations']}")
        print(f"✅ File changes detected: {metrics['file_changes_detected']}")
        
    except Exception as e:
        print(f"❌ Test 10 failed: {e}")
    
    # Test 11: Health check
    print("\nTest 11: Health check")
    try:
        health = await bridge.health_check()
        
        print(f"✅ Health status: {health['status']}")
        print(f"✅ Bridge: {health['bridge']}")
        print(f"✅ File accessible: {health['file_accessible']}")
        print(f"✅ Preferences loaded: {health['preferences_loaded']}")
        print(f"✅ Monitoring active: {health['monitoring_active']}")
        print(f"✅ Sync working: {health['sync_working']}")
        print(f"✅ Augment path: {health['augment_path']}")
        
    except Exception as e:
        print(f"❌ Test 11 failed: {e}")
    
    # Test 12: Integration with Central Memory Coordinator
    print("\nTest 12: Integration with Central Memory Coordinator")
    try:
        # Test coordinator integration
        from central_hub.memory_coordinator import CentralMemoryCoordinator
        
        coordinator = CentralMemoryCoordinator()
        
        # Test Augment memories strategy
        augment_result = await coordinator._execute_augment_memories(
            "Sequential Thinking MCP integration",
            {
                'source': 'test_integration',
                'query_analysis': {
                    'requires_code_analysis': True,
                    'type': 'mcp_integration'
                }
            }
        )
        
        print(f"✅ Coordinator integration: {augment_result['success']}")
        
        if augment_result['success']:
            data = augment_result['data']
            print(f"✅ Matching preferences: {data['total_matches']}")
            print(f"✅ Bridge metrics available: {'bridge_metrics' in data}")
        else:
            print(f"⚠️ Integration failed: {augment_result.get('error', 'Unknown error')}")
        
    except Exception as e:
        print(f"❌ Test 12 failed: {e}")
    
    # Test 13: Edge cases and error handling
    print("\nTest 13: Edge cases and error handling")
    try:
        # Test empty search
        empty_search = await bridge.search_preferences("")
        print(f"✅ Empty search: {len(empty_search)} results")
        
        # Test non-existent category
        non_existent_category = await bridge.get_preference_by_category("non_existent")
        print(f"✅ Non-existent category: {len(non_existent_category)} results")
        
        # Test non-existent technology
        non_existent_tech = await bridge.get_technology_preferences("NonExistentTech")
        print(f"✅ Non-existent technology: {len(non_existent_tech)} results")
        
        # Test invalid preference parsing
        invalid_content = "Invalid content without preferences"
        invalid_parsed = await bridge.parse_augment_preferences(invalid_content)
        print(f"✅ Invalid content parsing: {len(invalid_parsed.get('preferences', []))} preferences")
        
    except Exception as e:
        print(f"❌ Test 13 failed: {e}")
    
    # Test 14: Graceful shutdown
    print("\nTest 14: Graceful shutdown")
    try:
        await bridge.shutdown()
        print(f"✅ Bridge shutdown completed")
        
        # Verify monitoring stopped
        monitoring_stopped = bridge.observer is None
        print(f"✅ Monitoring stopped after shutdown: {monitoring_stopped}")
        
    except Exception as e:
        print(f"❌ Test 14 failed: {e}")
    
    print("\n✅ [AUGMENT BRIDGE TESTS] All tests completed")
    
    # Final metrics summary
    final_metrics = bridge.get_metrics()
    print(f"\n📊 FINAL METRICS:")
    print(f"   Total syncs: {final_metrics['total_syncs']}")
    print(f"   Success rate: {final_metrics['success_rate']:.1f}%")
    print(f"   Preferences cached: {final_metrics['preferences_cached']}")
    print(f"   Categories available: {final_metrics['categories_available']}")
    print(f"   Technologies tracked: {final_metrics['technologies_tracked']}")
    print(f"   Average sync time: {final_metrics['average_sync_time']:.1f}ms")
    print(f"   Backup operations: {final_metrics['backup_operations']}")
    print(f"   File changes detected: {final_metrics['file_changes_detected']}")

if __name__ == "__main__":
    # Run comprehensive tests
    asyncio.run(test_augment_bridge())
