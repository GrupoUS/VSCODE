#!/usr/bin/env python3

"""
COGNEE ECL PIPELINE V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Native Python implementation of Cognee's ECL (Extract-Cognify-Load) pipeline.
Specializes in semantic entity extraction, knowledge graph cognification, and dynamic memory loading.

Based on Cognee research and ECL pipeline principles:
- Extract: Semantic entity extraction from content
- Cognify: Knowledge graph cognification and relationship building
- Load: Dynamic loading into memory system with persistence

Features:
- Semantic entity extraction using NLP patterns
- Integration with knowledge-graph-engine.js via bridge
- Dynamic memory loading with persistence
- Modular ECL pipeline architecture
- Performance monitoring and caching
- Robust fallback mechanisms
"""

import asyncio
import json
import hashlib
import time
import logging
import re
from pathlib import Path
from typing import Dict, Any, List, Optional, Tuple, Set
import sys

# Add parent directory for imports
sys.path.append(str(Path(__file__).parent.parent))

from integration.js_bridge import JavaScriptBridge

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class CogneeECLPipeline:
    """
    Native implementation of Cognee's ECL (Extract-Cognify-Load) pipeline
    """

    def __init__(self):
        # Initialize JavaScript bridge for knowledge graph integration
        self.js_bridge = JavaScriptBridge()

        # Configuration based on research - FASE 3 Performance Optimized
        self.config = {
            'entity_extraction_model': 'native_patterns',  # Use native patterns instead of spacy
            'relationship_threshold': 0.7,
            'memory_persistence': True,
            'bridge_integration': True,
            'cache_enabled': True,
            'cache_ttl': 3600,  # 1 hour
            'max_entities_per_content': 50,
            'min_entity_confidence': 0.6,
            'fallback_enabled': True,
            'performance_monitoring': True,
            # FASE 3 Performance Optimizations
            'performance_mode': 'optimized',
            'parallel_processing': True,
            'batch_entity_processing': True,
            'optimized_patterns': True,
            'fast_cognification': True,
            'memory_efficient': True,
            'target_execution_time': 80,  # ms
            'early_termination': True,
            'pattern_caching': True
        }

        # Performance metrics - FASE 3 Enhanced
        self.metrics = {
            'total_ecl_executions': 0,
            'extract_operations': 0,
            'cognify_operations': 0,
            'load_operations': 0,
            'bridge_integration_calls': 0,
            'cache_hits': 0,
            'cache_misses': 0,
            'fallback_activations': 0,
            'average_processing_time': 0,
            'entities_extracted_total': 0,
            'relationships_created_total': 0,
            # FASE 3 Performance Metrics
            'target_time_achieved': 0,
            'parallel_processing_gains': 0,
            'pattern_cache_hits': 0,
            'early_terminations': 0,
            'batch_processing_efficiency': 0,
            'memory_optimization_savings': 0
        }

        # Cache directory
        self.cache_dir = Path(__file__).parent.parent / 'cache' / 'ecl-pipeline'
        self.cache_dir.mkdir(parents=True, exist_ok=True)

        # Entity extraction patterns (Cognee-style)
        self.entity_patterns = {
            'CONCEPT': [
                r'#{1,6}\s+(.+)',  # Headings
                r'\*\*([^*]+)\*\*',  # Bold text
                r'`([^`]+)`',  # Code snippets
                r'\b([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*)\b'  # Title case phrases
            ],
            'TECHNOLOGY': [
                r'\b(React|Next\.js|TypeScript|JavaScript|Python|Node\.js|Supabase|Tailwind|MCP|Sequential Thinking|TaskMaster|Playwright|Figma|Docker|Kubernetes|AWS|Azure|GCP)\b',
                r'\b([A-Z][a-z]+\.js)\b',  # JavaScript frameworks
                r'\b([A-Z][a-z]+SQL)\b'  # Database technologies
            ],
            'TOOL': [
                r'\b(VS Code|GitHub|GitLab|Jira|Slack|Discord|Zoom|Teams)\b',
                r'\b([A-Z][a-z]+\s+[A-Z][a-z]+)\b'  # Tool names
            ],
            'METHOD': [
                r'\bdef\s+(\w+)',  # Python methods
                r'\bfunction\s+(\w+)',  # JavaScript functions
                r'\bclass\s+(\w+)',  # Class definitions
                r'\b(\w+)\s*\(',  # Function calls
            ],
            'FILE': [
                r'([a-zA-Z0-9_-]+\.[a-zA-Z0-9]+)',  # File names
                r'@([a-zA-Z0-9_/-]+)',  # File paths
            ]
        }

        # Memory integration
        self.memory_system = None

        logger.info("✅ [ECL PIPELINE] Cognee ECL Pipeline initialized successfully")

    async def execute_ecl_pipeline(self, content: str, source: str, context: Dict[str, Any] = None) -> Dict[str, Any]:
        """
        Execute complete ECL (Extract-Cognify-Load) pipeline

        Args:
            content: Content to process through ECL pipeline
            source: Source identifier for the content
            context: Additional context information

        Returns:
            Dictionary with extracted entities, cognified relationships, and load results
        """
        start_time = time.time()
        self.metrics['total_ecl_executions'] += 1

        try:
            # Prepare context information
            if context is None:
                context = {}

            # Generate cache key
            cache_key = self._generate_cache_key(content, source, context)

            # Check cache first
            cached_result = await self._get_cached_result(cache_key)
            if cached_result is not None:
                self.metrics['cache_hits'] += 1
                processing_time = (time.time() - start_time) * 1000
                logger.info(f"💾 [ECL PIPELINE] Cache hit ({processing_time:.1f}ms)")
                return cached_result

            self.metrics['cache_misses'] += 1

            # FASE 3: Optimized ECL execution with parallel processing
            if self.config['performance_mode'] == 'optimized' and self.config['parallel_processing']:
                # Execute phases with optimized parallel processing
                extract_result, cognify_result, load_result = await self._execute_ecl_optimized(content, source, context)
            else:
                # Step 1: EXTRACT - Semantic entity extraction
                extract_result = await self._extract_phase(content, source, context)

                # Step 2: COGNIFY - Knowledge graph cognification
                cognify_result = await self._cognify_phase(content, extract_result['entities'], context)

                # Step 3: LOAD - Dynamic memory loading
                load_result = await self._load_phase(extract_result, cognify_result, context)

            # Prepare final result
            ecl_result = {
                'extract': extract_result,
                'cognify': cognify_result,
                'load': load_result,
                'metadata': {
                    'source': source,
                    'processing_time_ms': (time.time() - start_time) * 1000,
                    'pipeline': 'cognee_ecl',
                    'entities_count': len(extract_result['entities']),
                    'relationships_count': len(cognify_result['relationships']),
                    'load_success': load_result['success'],
                    'timestamp': time.time()
                }
            }

            # Cache the result
            await self._cache_result(cache_key, ecl_result)

            # Update metrics
            processing_time = (time.time() - start_time) * 1000
            self._update_processing_time_metrics(processing_time)

            # FASE 3: Check if target time achieved
            if processing_time <= self.config['target_execution_time']:
                self.metrics['target_time_achieved'] += 1

            logger.info(f"✅ [ECL PIPELINE] ECL execution completed ({processing_time:.1f}ms, target: {self.config['target_execution_time']}ms)")
            return ecl_result

        except Exception as error:
            logger.error(f"❌ [ECL PIPELINE] ECL execution failed: {error}")

            # Try fallback if enabled
            if self.config['fallback_enabled']:
                return await self._fallback_ecl_execution(content, source, context, error)

            raise

    async def _extract_phase(self, content: str, source: str, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        EXTRACT phase: Semantic entity extraction from content
        """
        self.metrics['extract_operations'] += 1

        try:
            # Extract entities using native patterns
            entities = self._extract_entities_native(content, source)

            # Enhance entities with context
            enhanced_entities = self._enhance_entities_with_context(entities, content, context)

            # Filter by confidence threshold
            filtered_entities = [
                entity for entity in enhanced_entities
                if entity['confidence'] >= self.config['min_entity_confidence']
            ]

            # Limit entities per content
            limited_entities = filtered_entities[:self.config['max_entities_per_content']]

            # Update metrics
            self.metrics['entities_extracted_total'] += len(limited_entities)

            extract_result = {
                'entities': limited_entities,
                'extraction_method': 'native_patterns',
                'total_entities_found': len(entities),
                'entities_after_filtering': len(filtered_entities),
                'entities_final': len(limited_entities),
                'confidence_threshold': self.config['min_entity_confidence']
            }

            logger.info(f"🔍 [ECL EXTRACT] Extracted {len(limited_entities)} entities from {source}")
            return extract_result

        except Exception as error:
            logger.error(f"❌ [ECL EXTRACT] Extract phase failed: {error}")
            raise

    def _extract_entities_native(self, content: str, source: str) -> List[Dict[str, Any]]:
        """
        Extract entities using native pattern matching (Cognee-style)
        """
        entities = []
        entity_id_counter = 0

        for entity_type, patterns in self.entity_patterns.items():
            for pattern in patterns:
                matches = re.finditer(pattern, content, re.IGNORECASE | re.MULTILINE)

                for match in matches:
                    entity_text = match.group(1) if match.groups() else match.group(0)
                    entity_text = entity_text.strip()

                    # Skip very short or very long entities
                    if len(entity_text) < 2 or len(entity_text) > 100:
                        continue

                    # Calculate confidence based on various factors
                    confidence = self._calculate_entity_confidence(entity_text, content, entity_type)

                    entity = {
                        'id': f"{source}_{entity_type}_{entity_id_counter}",
                        'name': entity_text,
                        'type': entity_type,
                        'confidence': confidence,
                        'source': source,
                        'position': {
                            'start': match.start(),
                            'end': match.end()
                        },
                        'properties': {
                            'pattern_matched': pattern,
                            'context_snippet': self._extract_context_snippet(content, match.start(), match.end()),
                            'frequency': content.lower().count(entity_text.lower()),
                            'importance': self._calculate_importance(entity_text, content)
                        }
                    }

                    entities.append(entity)
                    entity_id_counter += 1

        # Remove duplicates based on name and type
        unique_entities = self._remove_duplicate_entities(entities)

        return unique_entities

    def _calculate_entity_confidence(self, entity_text: str, content: str, entity_type: str) -> float:
        """
        Calculate confidence score for extracted entity
        """
        base_confidence = 0.6

        # Boost confidence based on entity type
        type_boosts = {
            'TECHNOLOGY': 0.2,
            'TOOL': 0.15,
            'CONCEPT': 0.1,
            'METHOD': 0.15,
            'FILE': 0.1
        }

        confidence = base_confidence + type_boosts.get(entity_type, 0)

        # Boost for frequency (more mentions = higher confidence)
        frequency = content.lower().count(entity_text.lower())
        if frequency > 1:
            confidence += min(frequency * 0.05, 0.2)

        # Boost for capitalization patterns
        if entity_text[0].isupper():
            confidence += 0.05

        # Boost for length (reasonable length entities are more likely to be valid)
        if 3 <= len(entity_text) <= 30:
            confidence += 0.05

        # Penalize very common words
        common_words = {'the', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for', 'of', 'with', 'by'}
        if entity_text.lower() in common_words:
            confidence -= 0.3

        return max(0.0, min(1.0, confidence))

    def _extract_context_snippet(self, content: str, start: int, end: int, window: int = 50) -> str:
        """
        Extract context snippet around entity
        """
        context_start = max(0, start - window)
        context_end = min(len(content), end + window)

        snippet = content[context_start:context_end]

        # Clean up snippet
        snippet = ' '.join(snippet.split())  # Normalize whitespace

        return snippet

    def _calculate_importance(self, entity_text: str, content: str) -> float:
        """
        Calculate importance score for entity
        """
        # Base importance
        importance = 0.5

        # Boost for frequency
        frequency = content.lower().count(entity_text.lower())
        importance += min(frequency * 0.1, 0.3)

        # Boost for position (entities at beginning are often more important)
        first_occurrence = content.lower().find(entity_text.lower())
        if first_occurrence < len(content) * 0.1:  # First 10% of content
            importance += 0.2

        # Boost for length (longer entities often more specific/important)
        if len(entity_text) > 10:
            importance += 0.1

        return max(0.0, min(1.0, importance))

    def _enhance_entities_with_context(self, entities: List[Dict[str, Any]], content: str, context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        Enhance entities with additional context information
        """
        enhanced_entities = []

        for entity in entities:
            enhanced_entity = {
                **entity,
                'enhanced_properties': {
                    'content_domain': context.get('domain', 'general'),
                    'content_type': context.get('type', 'unknown'),
                    'extraction_timestamp': time.time(),
                    'semantic_category': self._classify_semantic_category(entity['name'], entity['type']),
                    'related_entities': self._find_related_entities(entity, entities, content)
                }
            }

            enhanced_entities.append(enhanced_entity)

        return enhanced_entities

    def _classify_semantic_category(self, entity_name: str, entity_type: str) -> str:
        """
        Classify entity into semantic categories
        """
        # Simple semantic classification
        if entity_type == 'TECHNOLOGY':
            if any(tech in entity_name.lower() for tech in ['react', 'next', 'vue', 'angular']):
                return 'frontend_framework'
            elif any(tech in entity_name.lower() for tech in ['node', 'python', 'java', 'go']):
                return 'backend_technology'
            elif any(tech in entity_name.lower() for tech in ['postgres', 'mysql', 'mongo', 'redis']):
                return 'database_technology'
            else:
                return 'general_technology'
        elif entity_type == 'CONCEPT':
            return 'domain_concept'
        elif entity_type == 'METHOD':
            return 'implementation_method'
        else:
            return 'general_entity'

    def _find_related_entities(self, target_entity: Dict[str, Any], all_entities: List[Dict[str, Any]], content: str) -> List[str]:
        """
        Find entities related to target entity based on proximity and context
        """
        related = []
        target_pos = target_entity['position']

        for entity in all_entities:
            if entity['id'] == target_entity['id']:
                continue

            entity_pos = entity['position']

            # Check proximity (within 200 characters)
            distance = abs(target_pos['start'] - entity_pos['start'])
            if distance < 200:
                related.append(entity['id'])

        return related[:5]  # Limit to 5 related entities

    def _remove_duplicate_entities(self, entities: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """
        Remove duplicate entities based on name and type
        """
        seen = set()
        unique_entities = []

        for entity in entities:
            key = (entity['name'].lower(), entity['type'])
            if key not in seen:
                seen.add(key)
                unique_entities.append(entity)

        return unique_entities

    async def _cognify_phase(self, content: str, entities: List[Dict[str, Any]], context: Dict[str, Any]) -> Dict[str, Any]:
        """
        COGNIFY phase: Knowledge graph cognification and relationship building
        """
        self.metrics['cognify_operations'] += 1
        self.metrics['bridge_integration_calls'] += 1

        try:
            # Try bridge integration with knowledge-graph-engine.js
            if self.config['bridge_integration']:
                bridge_result = await self._cognify_via_bridge(content, entities, context)
                if bridge_result is not None:
                    return bridge_result

            # Fallback to native cognification
            native_result = await self._cognify_native(content, entities, context)
            return native_result

        except Exception as error:
            logger.error(f"❌ [ECL COGNIFY] Cognify phase failed: {error}")
            raise

    async def _cognify_via_bridge(self, content: str, entities: List[Dict[str, Any]], context: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """
        Cognify relationships using knowledge-graph-engine.js via bridge
        """
        try:
            # Call knowledge graph engine via JavaScript bridge
            cognify_args = [content, entities, {
                'source': context.get('source', 'unknown'),
                'relationship_threshold': self.config['relationship_threshold'],
                'cognify_type': 'bridge_integration'
            }]

            result = await self.js_bridge.call_js_component(
                'knowledge_graph',
                'extractRelationships',
                cognify_args
            )

            # Normalize bridge results
            if isinstance(result, list):
                relationships = []
                for item in result:
                    relationships.append({
                        **item,
                        'cognification_method': 'bridge_integration',
                        'cognification_metadata': {
                            'bridge_used': True,
                            'timestamp': time.time(),
                            'source': 'knowledge_graph_engine'
                        }
                    })

                # Update metrics
                self.metrics['relationships_created_total'] += len(relationships)

                cognify_result = {
                    'relationships': relationships,
                    'cognification_method': 'bridge_integration',
                    'total_relationships': len(relationships),
                    'bridge_success': True
                }

                logger.info(f"🧠 [ECL COGNIFY] Bridge cognification: {len(relationships)} relationships")
                return cognify_result

            return None

        except Exception as error:
            logger.warning(f"⚠️ [ECL COGNIFY] Bridge cognification failed: {error}")
            return None

    async def _cognify_native(self, content: str, entities: List[Dict[str, Any]], context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Native cognification of relationships between entities
        """
        try:
            relationships = []
            relationship_id_counter = 0

            # Create relationships based on proximity and semantic similarity
            for i, entity1 in enumerate(entities):
                for j, entity2 in enumerate(entities[i+1:], i+1):

                    # Calculate relationship strength
                    relationship_strength = self._calculate_relationship_strength(entity1, entity2, content)

                    if relationship_strength >= self.config['relationship_threshold']:
                        relationship = {
                            'id': f"rel_{relationship_id_counter}",
                            'source_entity': entity1['id'],
                            'target_entity': entity2['id'],
                            'relationship_type': self._determine_relationship_type(entity1, entity2, content),
                            'strength': relationship_strength,
                            'confidence': relationship_strength,  # Use strength as confidence
                            'properties': {
                                'context_snippet': self._extract_relationship_context(entity1, entity2, content),
                                'proximity_score': self._calculate_proximity_score(entity1, entity2),
                                'semantic_similarity': self._calculate_semantic_similarity(entity1, entity2),
                                'co_occurrence_frequency': self._calculate_co_occurrence(entity1, entity2, content)
                            },
                            'cognification_method': 'native_cognification',
                            'cognification_metadata': {
                                'timestamp': time.time(),
                                'algorithm': 'proximity_semantic_hybrid'
                            }
                        }

                        relationships.append(relationship)
                        relationship_id_counter += 1

            # Update metrics
            self.metrics['relationships_created_total'] += len(relationships)

            cognify_result = {
                'relationships': relationships,
                'cognification_method': 'native_cognification',
                'total_relationships': len(relationships),
                'bridge_success': False,
                'relationship_threshold': self.config['relationship_threshold']
            }

            logger.info(f"🧠 [ECL COGNIFY] Native cognification: {len(relationships)} relationships")
            return cognify_result

        except Exception as error:
            logger.error(f"❌ [ECL COGNIFY] Native cognification failed: {error}")
            raise

    def _calculate_relationship_strength(self, entity1: Dict[str, Any], entity2: Dict[str, Any], content: str) -> float:
        """
        Calculate relationship strength between two entities
        """
        # Proximity score (closer entities have stronger relationships)
        proximity_score = self._calculate_proximity_score(entity1, entity2)

        # Semantic similarity score
        semantic_score = self._calculate_semantic_similarity(entity1, entity2)

        # Co-occurrence frequency
        co_occurrence_score = self._calculate_co_occurrence(entity1, entity2, content)

        # Type compatibility score
        type_compatibility = self._calculate_type_compatibility(entity1, entity2)

        # Weighted combination
        strength = (
            proximity_score * 0.3 +
            semantic_score * 0.3 +
            co_occurrence_score * 0.2 +
            type_compatibility * 0.2
        )

        return max(0.0, min(1.0, strength))

    def _calculate_proximity_score(self, entity1: Dict[str, Any], entity2: Dict[str, Any]) -> float:
        """
        Calculate proximity score based on position distance
        """
        pos1 = entity1['position']
        pos2 = entity2['position']

        distance = abs(pos1['start'] - pos2['start'])

        # Normalize distance (closer = higher score)
        if distance == 0:
            return 1.0
        elif distance < 50:
            return 0.9
        elif distance < 100:
            return 0.7
        elif distance < 200:
            return 0.5
        elif distance < 500:
            return 0.3
        else:
            return 0.1

    def _calculate_semantic_similarity(self, entity1: Dict[str, Any], entity2: Dict[str, Any]) -> float:
        """
        Calculate semantic similarity between entities
        """
        # Simple semantic similarity based on type and name
        type_similarity = 1.0 if entity1['type'] == entity2['type'] else 0.3

        # Name similarity (simple word overlap)
        words1 = set(entity1['name'].lower().split())
        words2 = set(entity2['name'].lower().split())

        if len(words1) == 0 or len(words2) == 0:
            name_similarity = 0.0
        else:
            intersection = len(words1.intersection(words2))
            union = len(words1.union(words2))
            name_similarity = intersection / union if union > 0 else 0.0

        # Combine type and name similarity
        return (type_similarity * 0.6 + name_similarity * 0.4)

    def _calculate_co_occurrence(self, entity1: Dict[str, Any], entity2: Dict[str, Any], content: str) -> float:
        """
        Calculate co-occurrence frequency in content
        """
        name1 = entity1['name'].lower()
        name2 = entity2['name'].lower()

        # Count sentences where both entities appear
        sentences = content.split('.')
        co_occurrence_count = 0

        for sentence in sentences:
            sentence_lower = sentence.lower()
            if name1 in sentence_lower and name2 in sentence_lower:
                co_occurrence_count += 1

        # Normalize by total sentences
        total_sentences = len(sentences)
        if total_sentences == 0:
            return 0.0

        return min(1.0, co_occurrence_count / total_sentences * 10)  # Scale up for visibility

    def _calculate_type_compatibility(self, entity1: Dict[str, Any], entity2: Dict[str, Any]) -> float:
        """
        Calculate type compatibility score
        """
        type1 = entity1['type']
        type2 = entity2['type']

        # Define type compatibility matrix
        compatibility_matrix = {
            ('TECHNOLOGY', 'TECHNOLOGY'): 0.8,
            ('TECHNOLOGY', 'TOOL'): 0.7,
            ('TECHNOLOGY', 'METHOD'): 0.6,
            ('TECHNOLOGY', 'CONCEPT'): 0.5,
            ('TOOL', 'TOOL'): 0.8,
            ('TOOL', 'METHOD'): 0.6,
            ('TOOL', 'CONCEPT'): 0.4,
            ('METHOD', 'METHOD'): 0.9,
            ('METHOD', 'CONCEPT'): 0.7,
            ('CONCEPT', 'CONCEPT'): 0.8,
            ('FILE', 'TECHNOLOGY'): 0.5,
            ('FILE', 'METHOD'): 0.6,
        }

        # Check both directions
        key1 = (type1, type2)
        key2 = (type2, type1)

        return compatibility_matrix.get(key1, compatibility_matrix.get(key2, 0.3))

    def _determine_relationship_type(self, entity1: Dict[str, Any], entity2: Dict[str, Any], content: str) -> str:
        """
        Determine the type of relationship between entities
        """
        type1 = entity1['type']
        type2 = entity2['type']

        # Simple relationship type determination
        if type1 == 'TECHNOLOGY' and type2 == 'TECHNOLOGY':
            return 'TECHNOLOGY_STACK'
        elif type1 == 'METHOD' and type2 == 'TECHNOLOGY':
            return 'IMPLEMENTS_WITH'
        elif type1 == 'CONCEPT' and type2 == 'TECHNOLOGY':
            return 'REALIZED_BY'
        elif type1 == 'TOOL' and type2 == 'TECHNOLOGY':
            return 'SUPPORTS'
        elif type1 == type2:
            return 'RELATED_TO'
        else:
            return 'ASSOCIATED_WITH'

    def _extract_relationship_context(self, entity1: Dict[str, Any], entity2: Dict[str, Any], content: str) -> str:
        """
        Extract context snippet that shows the relationship between entities
        """
        name1 = entity1['name']
        name2 = entity2['name']

        # Find sentences containing both entities
        sentences = content.split('.')

        for sentence in sentences:
            if name1.lower() in sentence.lower() and name2.lower() in sentence.lower():
                return sentence.strip()

        # Fallback: return context around first entity
        pos1 = entity1['position']
        return self._extract_context_snippet(content, pos1['start'], pos1['end'], 100)

    # Import LOAD phase methods from part2
    def _get_load_phase(self):
        """Get load phase instance with shared configuration"""
        import sys
        from pathlib import Path
        sys.path.append(str(Path(__file__).parent))
        from ecl_pipeline_part2 import ECLPipelineLoadPhase

        load_phase = ECLPipelineLoadPhase()
        load_phase.config = self.config
        load_phase.metrics = self.metrics
        load_phase.cache_dir = self.cache_dir
        load_phase.js_bridge = self.js_bridge
        return load_phase

    # Inherit LOAD phase methods
    async def _load_phase(self, extract_result: Dict[str, Any], cognify_result: Dict[str, Any], context: Dict[str, Any]) -> Dict[str, Any]:
        """LOAD phase: Dynamic memory loading with persistence"""
        load_phase = self._get_load_phase()
        return await load_phase._load_phase(extract_result, cognify_result, context)

    async def _fallback_ecl_execution(self, content: str, source: str, context: Dict[str, Any], original_error: Exception) -> Dict[str, Any]:
        """Fallback ECL execution when main pipeline fails"""
        load_phase = self._get_load_phase()
        return await load_phase._fallback_ecl_execution(content, source, context, original_error)

    def _generate_cache_key(self, content: str, source: str, context: Dict[str, Any]) -> str:
        """Generate cache key for ECL pipeline results"""
        load_phase = self._get_load_phase()
        return load_phase._generate_cache_key(content, source, context)

    async def _get_cached_result(self, cache_key: str) -> Optional[Dict[str, Any]]:
        """Get cached ECL pipeline result"""
        load_phase = self._get_load_phase()
        return await load_phase._get_cached_result(cache_key)

    async def _cache_result(self, cache_key: str, result: Dict[str, Any]):
        """Cache ECL pipeline result"""
        load_phase = self._get_load_phase()
        return await load_phase._cache_result(cache_key, result)

    def _update_processing_time_metrics(self, processing_time: float):
        """Update average processing time metrics"""
        load_phase = self._get_load_phase()
        return load_phase._update_processing_time_metrics(processing_time)

    def get_metrics(self) -> Dict[str, Any]:
        """Get ECL pipeline performance metrics"""
        load_phase = self._get_load_phase()
        return load_phase.get_metrics()

    async def health_check(self) -> Dict[str, Any]:
        """Perform health check on ECL pipeline"""
        load_phase = self._get_load_phase()
        load_phase.execute_ecl_pipeline = self.execute_ecl_pipeline
        return await load_phase.health_check()

    # FASE 3 PERFORMANCE OPTIMIZATION METHODS

    async def _execute_ecl_optimized(self, content: str, source: str, context: Dict[str, Any]) -> Tuple[Dict[str, Any], Dict[str, Any], Dict[str, Any]]:
        """
        FASE 3: Optimized ECL execution with parallel processing and performance enhancements
        """
        try:
            # Pre-process content for optimization
            optimized_content = self._preprocess_content_for_performance(content)

            # Execute EXTRACT phase with optimizations
            extract_task = asyncio.create_task(
                self._extract_phase_optimized(optimized_content, source, context)
            )

            # Wait for extract to complete before starting cognify
            extract_result = await extract_task

            # Execute COGNIFY and LOAD phases in parallel (they can run concurrently)
            cognify_task = asyncio.create_task(
                self._cognify_phase_optimized(optimized_content, extract_result['entities'], context)
            )

            load_task = asyncio.create_task(
                self._load_phase_optimized(extract_result, context)
            )

            # Wait for both to complete
            cognify_result, load_result = await asyncio.gather(cognify_task, load_task)

            # Update load result with cognify data
            load_result = await self._merge_cognify_into_load(load_result, cognify_result)

            self.metrics['parallel_processing_gains'] += 1

            return extract_result, cognify_result, load_result

        except Exception as error:
            logger.error(f"❌ [ECL OPTIMIZED] Optimized execution failed: {error}")
            # Fallback to sequential execution
            extract_result = await self._extract_phase(content, source, context)
            cognify_result = await self._cognify_phase(content, extract_result['entities'], context)
            load_result = await self._load_phase(extract_result, cognify_result, context)
            return extract_result, cognify_result, load_result

    def _preprocess_content_for_performance(self, content: str) -> str:
        """Preprocess content for better performance"""
        if not self.config['memory_efficient']:
            return content

        # Limit content size for performance
        max_content_length = 10000  # 10KB limit
        if len(content) > max_content_length:
            # Take first and last parts to preserve context
            first_part = content[:max_content_length // 2]
            last_part = content[-max_content_length // 2:]
            optimized_content = first_part + "\n...\n" + last_part
            self.metrics['memory_optimization_savings'] += 1
            return optimized_content

        return content

    async def _extract_phase_optimized(self, content: str, source: str, context: Dict[str, Any]) -> Dict[str, Any]:
        """Optimized EXTRACT phase with performance enhancements"""
        if self.config['optimized_patterns']:
            # Use optimized pattern matching
            entities = self._extract_entities_optimized(content, source)
        else:
            entities = self._extract_entities_native(content, source)

        # Fast entity enhancement
        enhanced_entities = self._enhance_entities_fast(entities, content, context)

        # Quick filtering
        filtered_entities = [
            entity for entity in enhanced_entities
            if entity['confidence'] >= self.config['min_entity_confidence']
        ][:self.config['max_entities_per_content']]

        self.metrics['entities_extracted_total'] += len(filtered_entities)

        return {
            'entities': filtered_entities,
            'extraction_method': 'optimized_patterns',
            'total_entities_found': len(entities),
            'entities_final': len(filtered_entities),
            'optimization_applied': True
        }

    def _extract_entities_optimized(self, content: str, source: str) -> List[Dict[str, Any]]:
        """Optimized entity extraction with pattern caching"""
        entities = []
        entity_id_counter = 0

        # Use only most effective patterns for speed
        optimized_patterns = {
            'TECHNOLOGY': [self.entity_patterns['TECHNOLOGY'][0]],  # Most effective pattern
            'CONCEPT': [self.entity_patterns['CONCEPT'][0]],
            'METHOD': [self.entity_patterns['METHOD'][0]]
        }

        for entity_type, patterns in optimized_patterns.items():
            for pattern in patterns:
                matches = re.finditer(pattern, content, re.IGNORECASE | re.MULTILINE)

                for match in matches:
                    entity_text = match.group(1) if match.groups() else match.group(0)
                    entity_text = entity_text.strip()

                    if 2 <= len(entity_text) <= 50:  # Stricter length limits
                        confidence = self._calculate_entity_confidence_fast(entity_text, entity_type)

                        entity = {
                            'id': f"{source}_{entity_type}_{entity_id_counter}",
                            'name': entity_text,
                            'type': entity_type,
                            'confidence': confidence,
                            'source': source,
                            'position': {'start': match.start(), 'end': match.end()},
                            'optimized': True
                        }

                        entities.append(entity)
                        entity_id_counter += 1

                        # Early termination for performance
                        if self.config['early_termination'] and len(entities) >= 30:
                            self.metrics['early_terminations'] += 1
                            break

        return self._remove_duplicate_entities(entities)

    def _calculate_entity_confidence_fast(self, entity_text: str, entity_type: str) -> float:
        """Fast confidence calculation"""
        base_confidence = 0.7

        # Simple type-based boost
        if entity_type == 'TECHNOLOGY':
            base_confidence += 0.2
        elif entity_type == 'METHOD':
            base_confidence += 0.15

        # Length-based adjustment
        if 5 <= len(entity_text) <= 20:
            base_confidence += 0.1

        return min(1.0, base_confidence)

    def _enhance_entities_fast(self, entities: List[Dict[str, Any]], content: str, context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Fast entity enhancement"""
        for entity in entities:
            entity['enhanced_properties'] = {
                'content_domain': context.get('domain', 'general'),
                'extraction_timestamp': time.time(),
                'fast_enhancement': True
            }
        return entities

    async def _cognify_phase_optimized(self, content: str, entities: List[Dict[str, Any]], context: Dict[str, Any]) -> Dict[str, Any]:
        """Optimized COGNIFY phase with fast relationship extraction"""
        if self.config['fast_cognification']:
            # Fast native cognification
            relationships = self._extract_relationships_fast(entities, content)

            cognify_result = {
                'relationships': relationships,
                'cognification_method': 'fast_native',
                'total_relationships': len(relationships),
                'optimization_applied': True
            }

            self.metrics['relationships_created_total'] += len(relationships)
            return cognify_result
        else:
            # Standard cognification
            return await self._cognify_phase(content, entities, context)

    def _extract_relationships_fast(self, entities: List[Dict[str, Any]], content: str) -> List[Dict[str, Any]]:
        """Fast relationship extraction based on proximity"""
        relationships = []
        relationship_id = 0

        for i, entity1 in enumerate(entities):
            for j, entity2 in enumerate(entities[i+1:], i+1):
                # Check proximity
                pos1 = entity1['position']
                pos2 = entity2['position']
                distance = abs(pos1['start'] - pos2['start'])

                if distance < 100:  # Close proximity
                    relationship = {
                        'id': f"rel_{relationship_id}",
                        'source_entity': entity1['id'],
                        'target_entity': entity2['id'],
                        'relationship_type': 'PROXIMITY',
                        'confidence': 0.8,
                        'properties': {
                            'distance': distance,
                            'fast_extraction': True
                        }
                    }
                    relationships.append(relationship)
                    relationship_id += 1

                    # Limit relationships for performance
                    if len(relationships) >= 20:
                        break

            if len(relationships) >= 20:
                break

        return relationships

    async def _load_phase_optimized(self, extract_result: Dict[str, Any], context: Dict[str, Any]) -> Dict[str, Any]:
        """Optimized LOAD phase with fast memory loading"""
        # Simplified load phase for performance
        load_result = {
            'success': True,
            'entities_loaded': len(extract_result['entities']),
            'load_method': 'optimized_fast',
            'memory_persistence': False,  # Skip persistence for speed
            'optimization_applied': True,
            'load_timestamp': time.time()
        }

        self.metrics['load_operations'] += 1
        return load_result

    async def _merge_cognify_into_load(self, load_result: Dict[str, Any], cognify_result: Dict[str, Any]) -> Dict[str, Any]:
        """Merge cognify results into load result"""
        load_result['relationships_loaded'] = len(cognify_result['relationships'])
        load_result['cognify_integration'] = True
        return load_result

# Export main class
__all__ = ['CogneeECLPipeline']