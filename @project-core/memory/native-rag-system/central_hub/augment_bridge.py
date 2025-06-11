#!/usr/bin/env python3

"""
AUGMENT MEMORIES BRIDGE V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Native Python bridge for integration with Augment VS Code extension memory system.
Implements reading, parsing, and synchronization of 91 lines of structured preferences
from Augment Memories, with total priority given to Augment system as requested.

Features:
- Non-intrusive synchronization with Augment Memories
- Real-time monitoring of preference changes
- Structured parsing of 91 preference lines
- Bidirectional sync with project-core memory
- Backup and recovery system
- Integration with Central Memory Coordinator
"""

import asyncio
import json
import hashlib
import time
import logging
import os
import re
from pathlib import Path
from typing import Dict, Any, List, Optional, Tuple
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import sys

# Add parent directory for imports
sys.path.append(str(Path(__file__).parent.parent))

from integration.js_bridge import JavaScriptBridge

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class AugmentMemoriesHandler(FileSystemEventHandler):
    """File system event handler for Augment Memories changes"""
    
    def __init__(self, bridge):
        self.bridge = bridge
        self.last_modified = 0
        self.debounce_delay = 2  # 2 seconds debounce
    
    def on_modified(self, event):
        if not event.is_directory and event.src_path == str(self.bridge.augment_path):
            current_time = time.time()
            if current_time - self.last_modified > self.debounce_delay:
                self.last_modified = current_time
                logger.info(f"🔄 [AUGMENT BRIDGE] Detected changes in Augment Memories")
                asyncio.create_task(self.bridge.handle_augment_change())

class AugmentMemoriesBridge:
    """
    Native bridge for Augment VS Code extension memory system integration
    """
    
    def __init__(self):
        # Augment Memories file path
        self.augment_path = Path("User/workspaceStorage/f93728a73b8802154d6c1bd441b921c0/Augment.vscode-augment/Augment-Memories")
        
        # Configuration with total Augment priority
        self.config = {
            'priority_augment': True,  # Total priority to Augment system
            'sync_interval': 300,  # 5 minutes automatic sync
            'backup_enabled': True,
            'backup_retention_days': 30,
            'non_intrusive_sync': True,
            'real_time_monitoring': True,
            'preference_parsing': True,
            'bidirectional_sync': True
        }
        
        # JavaScript bridge for integration
        self.js_bridge = JavaScriptBridge()
        
        # Parsed preferences cache
        self.preferences_cache = {}
        self.last_sync_time = 0
        self.last_file_hash = ""
        
        # File monitoring
        self.observer = None
        self.file_handler = None
        
        # Backup directory
        self.backup_dir = Path(__file__).parent.parent / 'backups' / 'augment_memories'
        self.backup_dir.mkdir(parents=True, exist_ok=True)
        
        # Performance metrics
        self.metrics = {
            'total_syncs': 0,
            'successful_syncs': 0,
            'failed_syncs': 0,
            'preferences_parsed': 0,
            'file_changes_detected': 0,
            'backup_operations': 0,
            'average_sync_time': 0,
            'last_sync_timestamp': 0
        }
        
        logger.info("✅ [AUGMENT BRIDGE] Augment Memories Bridge initialized successfully")
    
    async def initialize(self):
        """Initialize the Augment Memories Bridge"""
        try:
            # Verify Augment Memories file exists
            if not self.augment_path.exists():
                logger.warning(f"⚠️ [AUGMENT BRIDGE] Augment Memories file not found: {self.augment_path}")
                return False
            
            # Initial read and parse
            await self.read_augment_memories()
            
            # Start real-time monitoring if enabled
            if self.config['real_time_monitoring']:
                await self.start_file_monitoring()
            
            # Create initial backup
            if self.config['backup_enabled']:
                await self.create_backup()
            
            logger.info("✅ [AUGMENT BRIDGE] Bridge initialization completed")
            return True
            
        except Exception as error:
            logger.error(f"❌ [AUGMENT BRIDGE] Initialization failed: {error}")
            return False
    
    async def read_augment_memories(self) -> Dict[str, Any]:
        """
        Read and parse 91 lines of structured preferences from Augment Memories
        """
        try:
            if not self.augment_path.exists():
                logger.warning(f"⚠️ [AUGMENT BRIDGE] Augment Memories file not found")
                return {}
            
            # Read file content
            with open(self.augment_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Calculate file hash for change detection
            current_hash = hashlib.sha256(content.encode()).hexdigest()
            
            # Check if file has changed
            if current_hash == self.last_file_hash:
                logger.info(f"💾 [AUGMENT BRIDGE] No changes detected in Augment Memories")
                return self.preferences_cache
            
            self.last_file_hash = current_hash
            
            # Parse preferences
            parsed_preferences = await self.parse_augment_preferences(content)
            
            # Update cache
            self.preferences_cache = parsed_preferences
            self.metrics['preferences_parsed'] = len(parsed_preferences.get('preferences', []))
            
            logger.info(f"📖 [AUGMENT BRIDGE] Read {self.metrics['preferences_parsed']} preferences from Augment Memories")
            return parsed_preferences
            
        except Exception as error:
            logger.error(f"❌ [AUGMENT BRIDGE] Failed to read Augment Memories: {error}")
            return {}
    
    async def parse_augment_preferences(self, content: str) -> Dict[str, Any]:
        """
        Parse Augment Memories content into structured preferences
        """
        try:
            lines = content.split('\n')
            preferences = []
            
            # Parse preference lines (starting with "- User prefers")
            preference_pattern = r'^- User prefers (.+)$'
            requirement_pattern = r'^- User requires (.+)$'
            
            for line_num, line in enumerate(lines, 1):
                line = line.strip()
                
                # Skip empty lines and comments
                if not line or line.startswith('#'):
                    continue
                
                # Parse user preferences
                pref_match = re.match(preference_pattern, line)
                req_match = re.match(requirement_pattern, line)
                
                if pref_match or req_match:
                    preference_text = pref_match.group(1) if pref_match else req_match.group(1)
                    preference_type = 'preference' if pref_match else 'requirement'
                    
                    # Extract key information from preference
                    preference_data = {
                        'line_number': line_num,
                        'type': preference_type,
                        'text': preference_text,
                        'category': self._categorize_preference(preference_text),
                        'priority': self._calculate_priority(preference_text),
                        'keywords': self._extract_keywords(preference_text),
                        'technologies': self._extract_technologies(preference_text),
                        'methodologies': self._extract_methodologies(preference_text),
                        'confidence_requirements': self._extract_confidence_requirements(preference_text)
                    }
                    
                    preferences.append(preference_data)
            
            # Create structured result
            parsed_result = {
                'total_lines': len(lines),
                'preference_lines': len(preferences),
                'preferences': preferences,
                'categories': self._group_by_category(preferences),
                'technologies': self._extract_all_technologies(preferences),
                'methodologies': self._extract_all_methodologies(preferences),
                'parsing_metadata': {
                    'parsed_at': time.time(),
                    'file_hash': self.last_file_hash,
                    'parser_version': '1.0'
                }
            }
            
            logger.info(f"🔍 [AUGMENT BRIDGE] Parsed {len(preferences)} preferences into {len(parsed_result['categories'])} categories")
            return parsed_result
            
        except Exception as error:
            logger.error(f"❌ [AUGMENT BRIDGE] Preference parsing failed: {error}")
            return {}
    
    def _categorize_preference(self, preference_text: str) -> str:
        """Categorize preference based on content"""
        text_lower = preference_text.lower()
        
        if any(keyword in text_lower for keyword in ['architectural', 'architecture', 'phase', 'methodology']):
            return 'architecture'
        elif any(keyword in text_lower for keyword in ['mcp', 'sequential thinking', 'task manager']):
            return 'mcp_integration'
        elif any(keyword in text_lower for keyword in ['taskmaster', 'task-master']):
            return 'taskmaster'
        elif any(keyword in text_lower for keyword in ['memory', 'learning', 'knowledge']):
            return 'memory_system'
        elif any(keyword in text_lower for keyword in ['validation', 'testing', 'verification']):
            return 'validation'
        elif any(keyword in text_lower for keyword in ['performance', 'optimization', 'improvement']):
            return 'performance'
        elif any(keyword in text_lower for keyword in ['security', 'api key', 'secret']):
            return 'security'
        elif any(keyword in text_lower for keyword in ['next.js', 'react', 'typescript', 'supabase']):
            return 'technology_stack'
        else:
            return 'general'
    
    def _calculate_priority(self, preference_text: str) -> int:
        """Calculate priority score for preference (1-10)"""
        priority = 5  # Default priority
        
        text_lower = preference_text.lower()
        
        # High priority indicators
        if any(keyword in text_lower for keyword in ['mandatory', 'requires', 'critical', 'essential']):
            priority += 3
        elif any(keyword in text_lower for keyword in ['prefers', 'systematic', 'comprehensive']):
            priority += 1
        
        # Technology-specific priorities
        if any(keyword in text_lower for keyword in ['sequential thinking', 'mcp', 'augment']):
            priority += 2
        
        # Confidence requirements
        if '≥8/10' in preference_text or '8/10' in preference_text:
            priority += 1
        
        return min(10, max(1, priority))
    
    def _extract_keywords(self, preference_text: str) -> List[str]:
        """Extract key terms from preference text"""
        # Common technical keywords
        keywords = []
        
        keyword_patterns = [
            r'\b(phase|methodology|protocol|system|integration|optimization)\b',
            r'\b(validation|testing|verification|audit|analysis)\b',
            r'\b(performance|improvement|enhancement|reduction)\b',
            r'\b(memory|learning|knowledge|documentation)\b'
        ]
        
        for pattern in keyword_patterns:
            matches = re.findall(pattern, preference_text.lower())
            keywords.extend(matches)
        
        return list(set(keywords))
    
    def _extract_technologies(self, preference_text: str) -> List[str]:
        """Extract technology names from preference text"""
        technologies = []
        
        tech_patterns = [
            r'\b(Next\.js|React|TypeScript|JavaScript|Python|Node\.js)\b',
            r'\b(Supabase|Tailwind|MCP|Sequential Thinking|TaskMaster)\b',
            r'\b(Playwright|Figma|Docker|Kubernetes|AWS|Azure|GCP)\b',
            r'\b(OpenRouter|Gemini|Claude|Augment|VS Code)\b'
        ]
        
        for pattern in tech_patterns:
            matches = re.findall(pattern, preference_text, re.IGNORECASE)
            technologies.extend(matches)
        
        return list(set(technologies))
    
    def _extract_methodologies(self, preference_text: str) -> List[str]:
        """Extract methodology names from preference text"""
        methodologies = []
        
        method_patterns = [
            r'(\d+-phase\s+\w+)',
            r'(systematic\s+\w+\s+methodology)',
            r'(comprehensive\s+\w+\s+protocol)',
            r'(structured\s+\w+\s+approach)'
        ]
        
        for pattern in method_patterns:
            matches = re.findall(pattern, preference_text.lower())
            methodologies.extend(matches)
        
        return list(set(methodologies))
    
    def _extract_confidence_requirements(self, preference_text: str) -> Optional[str]:
        """Extract confidence requirements from preference text"""
        confidence_pattern = r'(≥?\s*\d+/10|confidence\s+≥?\s*\d+)'
        match = re.search(confidence_pattern, preference_text)
        return match.group(1) if match else None
    
    def _group_by_category(self, preferences: List[Dict[str, Any]]) -> Dict[str, List[Dict[str, Any]]]:
        """Group preferences by category"""
        categories = {}
        for pref in preferences:
            category = pref['category']
            if category not in categories:
                categories[category] = []
            categories[category].append(pref)
        return categories
    
    def _extract_all_technologies(self, preferences: List[Dict[str, Any]]) -> List[str]:
        """Extract all unique technologies from preferences"""
        all_technologies = []
        for pref in preferences:
            all_technologies.extend(pref['technologies'])
        return list(set(all_technologies))
    
    def _extract_all_methodologies(self, preferences: List[Dict[str, Any]]) -> List[str]:
        """Extract all unique methodologies from preferences"""
        all_methodologies = []
        for pref in preferences:
            all_methodologies.extend(pref['methodologies'])
        return list(set(all_methodologies))
    
    async def sync_with_project_core(self) -> Dict[str, Any]:
        """
        Bidirectional synchronization with project-core memory system
        Priority: Augment system has total priority as requested
        """
        start_time = time.time()
        self.metrics['total_syncs'] += 1
        
        try:
            # Read latest Augment preferences (Augment has priority)
            augment_preferences = await self.read_augment_memories()
            
            if not augment_preferences:
                logger.warning(f"⚠️ [AUGMENT BRIDGE] No Augment preferences to sync")
                self.metrics['failed_syncs'] += 1
                return {'success': False, 'reason': 'no_augment_preferences'}
            
            # Sync with Central Memory Coordinator
            sync_result = await self._sync_with_coordinator(augment_preferences)
            
            # Update project-core memory with Augment preferences (non-intrusive)
            if self.config['non_intrusive_sync']:
                project_sync_result = await self._update_project_core_memory(augment_preferences)
                sync_result['project_core_sync'] = project_sync_result
            
            # Update metrics
            sync_time = (time.time() - start_time) * 1000
            self._update_sync_metrics(sync_time, True)
            
            logger.info(f"✅ [AUGMENT BRIDGE] Sync completed successfully ({sync_time:.1f}ms)")
            return {
                'success': True,
                'sync_time_ms': sync_time,
                'preferences_synced': len(augment_preferences.get('preferences', [])),
                'sync_result': sync_result
            }
            
        except Exception as error:
            sync_time = (time.time() - start_time) * 1000
            self._update_sync_metrics(sync_time, False)
            logger.error(f"❌ [AUGMENT BRIDGE] Sync failed: {error}")
            return {
                'success': False,
                'error': str(error),
                'sync_time_ms': sync_time
            }
    
    async def _sync_with_coordinator(self, augment_preferences: Dict[str, Any]) -> Dict[str, Any]:
        """Sync with Central Memory Coordinator"""
        try:
            # Import coordinator here to avoid circular imports
            from .memory_coordinator import CentralMemoryCoordinator
            
            coordinator = CentralMemoryCoordinator()
            
            # Create sync context
            sync_context = {
                'source': 'augment_bridge',
                'sync_type': 'augment_preferences',
                'priority': 'augment_total_priority',
                'preferences_count': len(augment_preferences.get('preferences', [])),
                'categories': list(augment_preferences.get('categories', {}).keys()),
                'technologies': augment_preferences.get('technologies', []),
                'methodologies': augment_preferences.get('methodologies', [])
            }
            
            # Coordinate memory consultation with Augment preferences
            coordination_result = await coordinator.coordinate_memory_consultation(
                f"Sync Augment preferences: {len(augment_preferences.get('preferences', []))} preferences",
                sync_context
            )
            
            return {
                'coordinator_sync': True,
                'coordination_result': coordination_result,
                'preferences_integrated': True
            }
            
        except Exception as error:
            logger.warning(f"⚠️ [AUGMENT BRIDGE] Coordinator sync failed: {error}")
            return {
                'coordinator_sync': False,
                'error': str(error)
            }
    
    async def _update_project_core_memory(self, augment_preferences: Dict[str, Any]) -> Dict[str, Any]:
        """Update project-core memory with Augment preferences (non-intrusive)"""
        try:
            # Create Augment preferences summary for project-core
            preferences_summary = {
                'augment_preferences_summary': {
                    'total_preferences': len(augment_preferences.get('preferences', [])),
                    'categories': augment_preferences.get('categories', {}),
                    'top_technologies': augment_preferences.get('technologies', [])[:10],
                    'key_methodologies': augment_preferences.get('methodologies', [])[:5],
                    'last_sync': time.time(),
                    'sync_source': 'augment_bridge'
                }
            }
            
            # Save to project-core memory (non-intrusive file)
            summary_file = Path(__file__).parent.parent.parent / 'augment_preferences_summary.json'
            with open(summary_file, 'w') as f:
                json.dump(preferences_summary, f, indent=2)
            
            return {
                'project_core_updated': True,
                'summary_file': str(summary_file),
                'non_intrusive': True
            }
            
        except Exception as error:
            logger.warning(f"⚠️ [AUGMENT BRIDGE] Project-core update failed: {error}")
            return {
                'project_core_updated': False,
                'error': str(error)
            }

    async def start_file_monitoring(self):
        """Start real-time monitoring of Augment Memories file"""
        try:
            if self.observer is not None:
                logger.info(f"🔄 [AUGMENT BRIDGE] File monitoring already active")
                return

            # Create file system event handler
            self.file_handler = AugmentMemoriesHandler(self)

            # Create observer and watch directory
            self.observer = Observer()
            watch_directory = self.augment_path.parent
            self.observer.schedule(self.file_handler, str(watch_directory), recursive=False)

            # Start monitoring
            self.observer.start()

            logger.info(f"👁️ [AUGMENT BRIDGE] Real-time file monitoring started for {self.augment_path}")

        except Exception as error:
            logger.error(f"❌ [AUGMENT BRIDGE] File monitoring failed to start: {error}")

    async def stop_file_monitoring(self):
        """Stop real-time monitoring of Augment Memories file"""
        try:
            if self.observer is not None:
                self.observer.stop()
                self.observer.join()
                self.observer = None
                self.file_handler = None
                logger.info(f"🛑 [AUGMENT BRIDGE] File monitoring stopped")
        except Exception as error:
            logger.error(f"❌ [AUGMENT BRIDGE] Failed to stop file monitoring: {error}")

    async def handle_augment_change(self):
        """Handle detected changes in Augment Memories file"""
        try:
            self.metrics['file_changes_detected'] += 1

            logger.info(f"🔄 [AUGMENT BRIDGE] Processing Augment Memories change...")

            # Create backup before processing changes
            if self.config['backup_enabled']:
                await self.create_backup()

            # Re-read and sync preferences
            sync_result = await self.sync_with_project_core()

            if sync_result['success']:
                logger.info(f"✅ [AUGMENT BRIDGE] Change processed successfully")
            else:
                logger.warning(f"⚠️ [AUGMENT BRIDGE] Change processing failed: {sync_result.get('error', 'Unknown error')}")

        except Exception as error:
            logger.error(f"❌ [AUGMENT BRIDGE] Failed to handle Augment change: {error}")

    async def create_backup(self) -> Dict[str, Any]:
        """Create backup of Augment Memories file"""
        try:
            if not self.augment_path.exists():
                return {'success': False, 'reason': 'source_file_not_found'}

            # Generate backup filename with timestamp
            timestamp = time.strftime("%Y%m%d_%H%M%S")
            backup_filename = f"augment_memories_backup_{timestamp}.txt"
            backup_path = self.backup_dir / backup_filename

            # Copy file to backup location
            with open(self.augment_path, 'r', encoding='utf-8') as source:
                content = source.read()

            with open(backup_path, 'w', encoding='utf-8') as backup:
                backup.write(content)

            # Update metrics
            self.metrics['backup_operations'] += 1

            # Clean old backups
            await self._cleanup_old_backups()

            logger.info(f"💾 [AUGMENT BRIDGE] Backup created: {backup_filename}")
            return {
                'success': True,
                'backup_path': str(backup_path),
                'backup_filename': backup_filename
            }

        except Exception as error:
            logger.error(f"❌ [AUGMENT BRIDGE] Backup creation failed: {error}")
            return {
                'success': False,
                'error': str(error)
            }

    async def _cleanup_old_backups(self):
        """Clean up old backup files based on retention policy"""
        try:
            if not self.config['backup_enabled']:
                return

            retention_seconds = self.config['backup_retention_days'] * 24 * 3600
            current_time = time.time()

            for backup_file in self.backup_dir.glob("augment_memories_backup_*.txt"):
                file_age = current_time - backup_file.stat().st_mtime
                if file_age > retention_seconds:
                    backup_file.unlink()
                    logger.info(f"🗑️ [AUGMENT BRIDGE] Removed old backup: {backup_file.name}")

        except Exception as error:
            logger.warning(f"⚠️ [AUGMENT BRIDGE] Backup cleanup failed: {error}")

    async def get_preference_by_category(self, category: str) -> List[Dict[str, Any]]:
        """Get preferences filtered by category"""
        try:
            if not self.preferences_cache:
                await self.read_augment_memories()

            categories = self.preferences_cache.get('categories', {})
            return categories.get(category, [])

        except Exception as error:
            logger.error(f"❌ [AUGMENT BRIDGE] Failed to get preferences by category: {error}")
            return []

    async def search_preferences(self, query: str) -> List[Dict[str, Any]]:
        """Search preferences by text content"""
        try:
            if not self.preferences_cache:
                await self.read_augment_memories()

            preferences = self.preferences_cache.get('preferences', [])
            query_lower = query.lower()

            matching_preferences = []
            for pref in preferences:
                if (query_lower in pref['text'].lower() or
                    any(keyword in query_lower for keyword in pref['keywords']) or
                    any(tech.lower() in query_lower for tech in pref['technologies'])):
                    matching_preferences.append(pref)

            return matching_preferences

        except Exception as error:
            logger.error(f"❌ [AUGMENT BRIDGE] Preference search failed: {error}")
            return []

    async def get_technology_preferences(self, technology: str) -> List[Dict[str, Any]]:
        """Get preferences related to specific technology"""
        try:
            if not self.preferences_cache:
                await self.read_augment_memories()

            preferences = self.preferences_cache.get('preferences', [])
            tech_lower = technology.lower()

            tech_preferences = []
            for pref in preferences:
                if any(tech.lower() == tech_lower for tech in pref['technologies']):
                    tech_preferences.append(pref)

            return tech_preferences

        except Exception as error:
            logger.error(f"❌ [AUGMENT BRIDGE] Technology preference search failed: {error}")
            return []

    def _update_sync_metrics(self, sync_time: float, success: bool):
        """Update synchronization metrics"""
        if success:
            self.metrics['successful_syncs'] += 1
        else:
            self.metrics['failed_syncs'] += 1

        # Update average sync time
        if self.metrics['average_sync_time'] == 0:
            self.metrics['average_sync_time'] = sync_time
        else:
            self.metrics['average_sync_time'] = (
                self.metrics['average_sync_time'] + sync_time
            ) / 2

        self.metrics['last_sync_timestamp'] = time.time()

    def get_metrics(self) -> Dict[str, Any]:
        """Get bridge performance metrics"""
        total_syncs = self.metrics['total_syncs']
        success_rate = (self.metrics['successful_syncs'] / total_syncs * 100) if total_syncs > 0 else 0

        return {
            **self.metrics,
            'success_rate': success_rate,
            'preferences_cached': len(self.preferences_cache.get('preferences', [])),
            'categories_available': len(self.preferences_cache.get('categories', {})),
            'technologies_tracked': len(self.preferences_cache.get('technologies', [])),
            'file_monitoring_active': self.observer is not None,
            'last_file_hash': self.last_file_hash[:16] if self.last_file_hash else None
        }

    async def health_check(self) -> Dict[str, Any]:
        """Perform health check on Augment bridge"""
        try:
            # Check file accessibility
            file_accessible = self.augment_path.exists()

            # Check if preferences are loaded
            preferences_loaded = len(self.preferences_cache.get('preferences', [])) > 0

            # Check file monitoring status
            monitoring_active = self.observer is not None

            # Test sync functionality
            if file_accessible:
                test_sync = await self.sync_with_project_core()
                sync_working = test_sync.get('success', False)
            else:
                sync_working = False

            status = 'healthy' if (file_accessible and preferences_loaded) else 'unhealthy'

            return {
                'status': status,
                'bridge': 'augment_memories',
                'file_accessible': file_accessible,
                'preferences_loaded': preferences_loaded,
                'monitoring_active': monitoring_active,
                'sync_working': sync_working,
                'augment_path': str(self.augment_path),
                'metrics': self.get_metrics()
            }

        except Exception as error:
            return {
                'status': 'unhealthy',
                'bridge': 'augment_memories',
                'error': str(error),
                'metrics': self.get_metrics()
            }

    async def shutdown(self):
        """Gracefully shutdown the bridge"""
        try:
            # Stop file monitoring
            await self.stop_file_monitoring()

            # Create final backup
            if self.config['backup_enabled']:
                await self.create_backup()

            logger.info(f"🛑 [AUGMENT BRIDGE] Bridge shutdown completed")

        except Exception as error:
            logger.error(f"❌ [AUGMENT BRIDGE] Shutdown failed: {error}")

    def get_bridge_status(self) -> Dict[str, Any]:
        """Get bridge status for compatibility with test suite"""
        try:
            # Check if bridge is accessible
            file_accessible = self.augment_path.exists()
            preferences_loaded = len(self.preferences) > 0
            monitoring_active = hasattr(self, 'file_monitor') and self.file_monitor is not None

            status = 'healthy' if (file_accessible and preferences_loaded) else 'unhealthy'

            return {
                'status': status,
                'bridge': 'augment_memories',
                'file_accessible': file_accessible,
                'preferences_loaded': preferences_loaded,
                'monitoring_active': monitoring_active,
                'augment_path': str(self.augment_path),
                'metrics': self.get_metrics()
            }

        except Exception as error:
            return {
                'status': 'unhealthy',
                'bridge': 'augment_memories',
                'error': str(error),
                'metrics': self.get_metrics()
            }

# Export main class
__all__ = ['AugmentMemoriesBridge']
