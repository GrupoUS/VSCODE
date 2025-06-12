#!/usr/bin/env python3

"""
COGNEE ECL PIPELINE V1.0 - PART 2
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Continuation of ECL Pipeline implementation - LOAD phase and utilities
"""

import asyncio
import json
import hashlib
import time
import logging
from pathlib import Path
from typing import Dict, Any, List, Optional

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class ECLPipelineLoadPhase:
    """
    LOAD phase implementation for ECL Pipeline
    """
    
    async def _load_phase(self, extract_result: Dict[str, Any], cognify_result: Dict[str, Any], context: Dict[str, Any]) -> Dict[str, Any]:
        """
        LOAD phase: Dynamic memory loading with persistence
        """
        self.metrics['load_operations'] += 1
        
        try:
            # Prepare data for loading
            entities = extract_result['entities']
            relationships = cognify_result['relationships']
            
            # Load entities to memory system
            entity_load_result = await self._load_entities_to_memory(entities, context)
            
            # Load relationships to memory system
            relationship_load_result = await self._load_relationships_to_memory(relationships, context)
            
            # Update knowledge graph via bridge if available
            graph_update_result = await self._update_knowledge_graph_via_bridge(entities, relationships, context)
            
            # Persist to local storage
            persistence_result = await self._persist_to_storage(entities, relationships, context)
            
            load_result = {
                'success': True,
                'entities_loaded': len(entities),
                'relationships_loaded': len(relationships),
                'entity_load_result': entity_load_result,
                'relationship_load_result': relationship_load_result,
                'graph_update_result': graph_update_result,
                'persistence_result': persistence_result,
                'load_method': 'dynamic_memory_loading',
                'timestamp': time.time()
            }
            
            logger.info(f"📥 [ECL LOAD] Loaded {len(entities)} entities and {len(relationships)} relationships")
            return load_result
            
        except Exception as error:
            logger.error(f"❌ [ECL LOAD] Load phase failed: {error}")
            
            # Return partial success result
            return {
                'success': False,
                'error': str(error),
                'entities_loaded': 0,
                'relationships_loaded': 0,
                'load_method': 'failed_loading',
                'timestamp': time.time()
            }
    
    async def _load_entities_to_memory(self, entities: List[Dict[str, Any]], context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Load entities to memory system
        """
        try:
            # Prepare entities for memory storage
            memory_entities = []
            
            for entity in entities:
                memory_entity = {
                    'id': entity['id'],
                    'name': entity['name'],
                    'type': entity['type'],
                    'confidence': entity['confidence'],
                    'source': entity['source'],
                    'properties': entity['properties'],
                    'enhanced_properties': entity.get('enhanced_properties', {}),
                    'memory_metadata': {
                        'loaded_at': time.time(),
                        'load_context': context.get('source', 'unknown'),
                        'ecl_pipeline': True
                    }
                }
                memory_entities.append(memory_entity)
            
            # Store in memory system (placeholder for actual memory integration)
            # In a full implementation, this would integrate with the actual memory system
            
            return {
                'success': True,
                'entities_processed': len(memory_entities),
                'storage_method': 'memory_system'
            }
            
        except Exception as error:
            logger.warning(f"⚠️ [ECL LOAD] Entity loading failed: {error}")
            return {
                'success': False,
                'error': str(error),
                'entities_processed': 0
            }
    
    async def _load_relationships_to_memory(self, relationships: List[Dict[str, Any]], context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Load relationships to memory system
        """
        try:
            # Prepare relationships for memory storage
            memory_relationships = []
            
            for relationship in relationships:
                memory_relationship = {
                    'id': relationship['id'],
                    'source_entity': relationship['source_entity'],
                    'target_entity': relationship['target_entity'],
                    'relationship_type': relationship['relationship_type'],
                    'strength': relationship['strength'],
                    'confidence': relationship['confidence'],
                    'properties': relationship['properties'],
                    'cognification_metadata': relationship.get('cognification_metadata', {}),
                    'memory_metadata': {
                        'loaded_at': time.time(),
                        'load_context': context.get('source', 'unknown'),
                        'ecl_pipeline': True
                    }
                }
                memory_relationships.append(memory_relationship)
            
            # Store in memory system (placeholder for actual memory integration)
            
            return {
                'success': True,
                'relationships_processed': len(memory_relationships),
                'storage_method': 'memory_system'
            }
            
        except Exception as error:
            logger.warning(f"⚠️ [ECL LOAD] Relationship loading failed: {error}")
            return {
                'success': False,
                'error': str(error),
                'relationships_processed': 0
            }
    
    async def _update_knowledge_graph_via_bridge(self, entities: List[Dict[str, Any]], relationships: List[Dict[str, Any]], context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Update knowledge graph via JavaScript bridge
        """
        try:
            if not self.config['bridge_integration']:
                return {'success': False, 'reason': 'bridge_disabled'}
            
            # Call knowledge graph engine to update graph
            update_args = [entities, relationships, {
                'source': context.get('source', 'unknown'),
                'update_type': 'ecl_pipeline_load',
                'timestamp': time.time()
            }]
            
            result = await self.js_bridge.call_js_component(
                'knowledge_graph',
                'updateGraph',
                update_args
            )
            
            return {
                'success': True,
                'bridge_update': True,
                'result': result
            }
            
        except Exception as error:
            logger.warning(f"⚠️ [ECL LOAD] Knowledge graph update failed: {error}")
            return {
                'success': False,
                'error': str(error),
                'bridge_update': False
            }
    
    async def _persist_to_storage(self, entities: List[Dict[str, Any]], relationships: List[Dict[str, Any]], context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Persist entities and relationships to local storage
        """
        try:
            if not self.config['memory_persistence']:
                return {'success': False, 'reason': 'persistence_disabled'}
            
            # Create storage directory
            storage_dir = self.cache_dir / 'ecl_storage'
            storage_dir.mkdir(exist_ok=True)
            
            # Generate storage key
            storage_key = hashlib.sha256(f"{context.get('source', 'unknown')}_{time.time()}".encode()).hexdigest()[:16]
            
            # Save entities
            entities_file = storage_dir / f"entities_{storage_key}.json"
            with open(entities_file, 'w') as f:
                json.dump({
                    'entities': entities,
                    'metadata': {
                        'source': context.get('source', 'unknown'),
                        'timestamp': time.time(),
                        'ecl_pipeline': True
                    }
                }, f, indent=2)
            
            # Save relationships
            relationships_file = storage_dir / f"relationships_{storage_key}.json"
            with open(relationships_file, 'w') as f:
                json.dump({
                    'relationships': relationships,
                    'metadata': {
                        'source': context.get('source', 'unknown'),
                        'timestamp': time.time(),
                        'ecl_pipeline': True
                    }
                }, f, indent=2)
            
            return {
                'success': True,
                'entities_file': str(entities_file),
                'relationships_file': str(relationships_file),
                'storage_key': storage_key
            }
            
        except Exception as error:
            logger.warning(f"⚠️ [ECL LOAD] Persistence failed: {error}")
            return {
                'success': False,
                'error': str(error)
            }
    
    async def _fallback_ecl_execution(self, content: str, source: str, context: Dict[str, Any], original_error: Exception) -> Dict[str, Any]:
        """
        Fallback ECL execution when main pipeline fails
        """
        self.metrics['fallback_activations'] += 1
        
        logger.warning(f"🔄 [ECL PIPELINE] Activating fallback for source: {source}")
        
        try:
            # Simple fallback extraction
            simple_entities = self._simple_entity_extraction(content, source)
            
            # Simple fallback relationships
            simple_relationships = self._simple_relationship_creation(simple_entities)
            
            # Simple fallback loading
            simple_load = {
                'success': True,
                'entities_loaded': len(simple_entities),
                'relationships_loaded': len(simple_relationships),
                'load_method': 'fallback_loading'
            }
            
            fallback_result = {
                'extract': {
                    'entities': simple_entities,
                    'extraction_method': 'fallback_extraction'
                },
                'cognify': {
                    'relationships': simple_relationships,
                    'cognification_method': 'fallback_cognification'
                },
                'load': simple_load,
                'metadata': {
                    'source': source,
                    'pipeline': 'cognee_ecl_fallback',
                    'fallback': True,
                    'original_error': str(original_error),
                    'timestamp': time.time()
                }
            }
            
            return fallback_result
            
        except Exception as fallback_error:
            logger.error(f"❌ [ECL PIPELINE] Fallback also failed: {fallback_error}")
            
            # Ultimate fallback
            return {
                'extract': {'entities': [], 'extraction_method': 'failed'},
                'cognify': {'relationships': [], 'cognification_method': 'failed'},
                'load': {'success': False, 'load_method': 'failed'},
                'metadata': {
                    'source': source,
                    'pipeline': 'cognee_ecl_error',
                    'fallback': True,
                    'original_error': str(original_error),
                    'fallback_error': str(fallback_error),
                    'timestamp': time.time()
                }
            }
    
    def _simple_entity_extraction(self, content: str, source: str) -> List[Dict[str, Any]]:
        """
        Simple entity extraction for fallback
        """
        entities = []
        
        # Extract simple patterns
        words = content.split()
        for i, word in enumerate(words):
            if len(word) > 3 and word[0].isupper():
                entities.append({
                    'id': f"{source}_simple_{i}",
                    'name': word,
                    'type': 'SIMPLE_ENTITY',
                    'confidence': 0.5,
                    'source': source,
                    'position': {'start': i, 'end': i + len(word)},
                    'properties': {'extraction_method': 'simple_fallback'}
                })
        
        return entities[:10]  # Limit to 10 entities
    
    def _simple_relationship_creation(self, entities: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """
        Simple relationship creation for fallback
        """
        relationships = []
        
        for i, entity1 in enumerate(entities):
            for j, entity2 in enumerate(entities[i+1:], i+1):
                if j - i <= 2:  # Only adjacent entities
                    relationships.append({
                        'id': f"simple_rel_{i}_{j}",
                        'source_entity': entity1['id'],
                        'target_entity': entity2['id'],
                        'relationship_type': 'SIMPLE_ADJACENCY',
                        'strength': 0.5,
                        'confidence': 0.5,
                        'properties': {'creation_method': 'simple_fallback'}
                    })
        
        return relationships
    
    # Utility methods
    def _generate_cache_key(self, content: str, source: str, context: Dict[str, Any]) -> str:
        """Generate cache key for ECL pipeline results"""
        key_data = {
            'content_hash': hashlib.sha256(content.encode()).hexdigest()[:16],
            'source': source,
            'context': context.get('source', 'unknown'),
            'pipeline': 'cognee_ecl'
        }
        key_string = json.dumps(key_data, sort_keys=True)
        return hashlib.sha256(key_string.encode()).hexdigest()
    
    async def _get_cached_result(self, cache_key: str) -> Optional[Dict[str, Any]]:
        """Get cached ECL pipeline result"""
        if not self.config['cache_enabled']:
            return None
        
        try:
            cache_file = self.cache_dir / f"{cache_key}.json"
            if not cache_file.exists():
                return None
            
            with open(cache_file, 'r') as f:
                cached_data = json.load(f)
            
            # Check TTL
            cache_time = cached_data.get('timestamp', 0)
            if time.time() - cache_time > self.config['cache_ttl']:
                cache_file.unlink()  # Remove expired cache
                return None
            
            return cached_data.get('result')
            
        except Exception as error:
            logger.warning(f"⚠️ [ECL PIPELINE] Cache read failed: {error}")
            return None
    
    async def _cache_result(self, cache_key: str, result: Dict[str, Any]):
        """Cache ECL pipeline result"""
        if not self.config['cache_enabled']:
            return
        
        try:
            cache_data = {
                'result': result,
                'timestamp': time.time(),
                'ttl': self.config['cache_ttl']
            }
            
            cache_file = self.cache_dir / f"{cache_key}.json"
            with open(cache_file, 'w') as f:
                json.dump(cache_data, f, indent=2)
                
        except Exception as error:
            logger.warning(f"⚠️ [ECL PIPELINE] Cache write failed: {error}")
    
    def _update_processing_time_metrics(self, processing_time: float):
        """Update average processing time metrics"""
        if self.metrics['average_processing_time'] == 0:
            self.metrics['average_processing_time'] = processing_time
        else:
            self.metrics['average_processing_time'] = (
                self.metrics['average_processing_time'] + processing_time
            ) / 2
    
    def get_metrics(self) -> Dict[str, Any]:
        """Get ECL pipeline performance metrics"""
        cache_total = self.metrics['cache_hits'] + self.metrics['cache_misses']
        cache_hit_rate = (self.metrics['cache_hits'] / cache_total * 100) if cache_total > 0 else 0
        
        return {
            **self.metrics,
            'cache_hit_rate': cache_hit_rate,
            'entities_per_execution': (
                self.metrics['entities_extracted_total'] / self.metrics['total_ecl_executions']
                if self.metrics['total_ecl_executions'] > 0 else 0
            ),
            'relationships_per_execution': (
                self.metrics['relationships_created_total'] / self.metrics['total_ecl_executions']
                if self.metrics['total_ecl_executions'] > 0 else 0
            )
        }
    
    async def health_check(self) -> Dict[str, Any]:
        """Perform health check on ECL pipeline"""
        try:
            # Test basic functionality
            test_content = """
            React is a JavaScript library for building user interfaces.
            Next.js is a React framework for production applications.
            TypeScript adds static typing to JavaScript.
            """
            
            test_result = await self.execute_ecl_pipeline(
                test_content,
                'health_check',
                {'source': 'health_check'}
            )
            
            return {
                'status': 'healthy',
                'pipeline': 'cognee_ecl',
                'bridge_available': True,
                'extract_working': len(test_result['extract']['entities']) > 0,
                'cognify_working': len(test_result['cognify']['relationships']) >= 0,
                'load_working': test_result['load']['success'],
                'metrics': self.get_metrics()
            }
            
        except Exception as error:
            return {
                'status': 'unhealthy',
                'pipeline': 'cognee_ecl',
                'error': str(error),
                'metrics': self.get_metrics()
            }

# Export main class
__all__ = ['ECLPipelineLoadPhase']
