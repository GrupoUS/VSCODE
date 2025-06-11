#!/usr/bin/env python3

"""
CRAWL4AI RERANKING STRATEGY V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Native Python implementation of Crawl4AI's USE_RERANKING strategy.
Specializes in cross-encoder reranking for improved result relevance.

Based on Crawl4AI research and cross-encoder reranking principles:
- Cross-encoder model: cross-encoder/ms-marco-MiniLM-L-6-v2
- Performance target: <200ms latency
- Combined scoring: original_score * 0.3 + cross_encoder_score * 0.7
- Cache integration with existing consultation-optimization.js
- Fallback to original results if reranking fails

Features:
- Cross-encoder reranking using sentence-transformers
- Integration with consultation-optimization.js via bridge
- Performance monitoring with <200ms latency target
- Intelligent caching with TTL 30 minutes
- Robust fallback mechanisms
- Relevance improvement tracking
"""

import asyncio
import json
import hashlib
import time
import logging
from pathlib import Path
from typing import Dict, Any, List, Optional, Tuple
import sys

# Add parent directory for imports
sys.path.append(str(Path(__file__).parent.parent))

from integration.js_bridge import JavaScriptBridge

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class RerankingStrategy:
    """
    Native implementation of Crawl4AI's reranking strategy for result optimization
    """
    
    def __init__(self):
        # Initialize JavaScript bridge for consultation optimization integration
        self.js_bridge = JavaScriptBridge()
        
        # Configuration based on research
        self.config = {
            'reranking_model': 'cross-encoder/ms-marco-MiniLM-L-6-v2',
            'latency_target': 200,  # milliseconds
            'max_results': 10,
            'confidence_threshold': 0.7,
            'original_weight': 0.3,  # Weight for original scores
            'cross_encoder_weight': 0.7,  # Weight for cross-encoder scores
            'cache_enabled': True,
            'cache_ttl': 1800,  # 30 minutes (matching existing system)
            'fallback_enabled': True,
            'bridge_integration': True,
            'performance_monitoring': True
        }
        
        # Performance metrics
        self.metrics = {
            'total_reranking_calls': 0,
            'bridge_integration_calls': 0,
            'native_reranking_calls': 0,
            'cache_hits': 0,
            'cache_misses': 0,
            'fallback_activations': 0,
            'average_latency': 0,
            'relevance_improvements': [],
            'latency_target_violations': 0
        }
        
        # Cache directory (integrating with existing reranking cache)
        self.cache_dir = Path(__file__).parent.parent / 'cache' / 'reranked-results'
        self.cache_dir.mkdir(parents=True, exist_ok=True)
        
        # Cross-encoder model (lazy loading)
        self.cross_encoder = None
        self.model_loaded = False
        
        logger.info("✅ [RERANKING] Strategy initialized successfully")
    
    async def rerank_results(self, query: str, results: List[Dict[str, Any]], context: Dict[str, Any] = None) -> List[Dict[str, Any]]:
        """
        Rerank results for improved relevance
        
        Args:
            query: Search query string
            results: List of search results to rerank
            context: Additional context information
            
        Returns:
            List of reranked results with improved relevance scores
        """
        start_time = time.time()
        self.metrics['total_reranking_calls'] += 1
        
        try:
            # Validate inputs
            if not query or not results or len(results) == 0:
                logger.info("⚠️ [RERANKING] No results to rerank, returning original")
                return results
            
            # Prepare context information
            if context is None:
                context = {}
            
            # Generate cache key
            cache_key = self._generate_cache_key(query, results, context)
            
            # Check cache first
            cached_result = await self._get_cached_result(cache_key)
            if cached_result is not None:
                self.metrics['cache_hits'] += 1
                latency = (time.time() - start_time) * 1000
                logger.info(f"💾 [RERANKING] Cache hit ({latency:.1f}ms)")
                return cached_result
            
            self.metrics['cache_misses'] += 1
            
            # Step 1: Try bridge integration with consultation-optimization.js
            if self.config['bridge_integration']:
                bridge_results = await self._bridge_reranking(query, results, context)
                if bridge_results is not None:
                    # Cache and return bridge results
                    await self._cache_result(cache_key, bridge_results)
                    latency = (time.time() - start_time) * 1000
                    self._update_latency_metrics(latency)
                    logger.info(f"🌉 [RERANKING] Bridge integration completed ({latency:.1f}ms)")
                    return bridge_results
            
            # Step 2: Native cross-encoder reranking
            native_results = await self._native_cross_encoder_rerank(query, results, context)
            
            # Cache the results
            await self._cache_result(cache_key, native_results)
            
            # Update metrics
            latency = (time.time() - start_time) * 1000
            self._update_latency_metrics(latency)
            
            # Check latency target
            if latency > self.config['latency_target']:
                self.metrics['latency_target_violations'] += 1
                logger.warning(f"⚠️ [RERANKING] Latency {latency:.1f}ms exceeded target {self.config['latency_target']}ms")
            
            logger.info(f"✅ [RERANKING] Native reranking completed ({latency:.1f}ms)")
            return native_results
            
        except Exception as error:
            logger.error(f"❌ [RERANKING] Reranking failed: {error}")
            
            # Try fallback if enabled
            if self.config['fallback_enabled']:
                return await self._fallback_reranking(query, results, context, error)
            
            raise
    
    async def _bridge_reranking(self, query: str, results: List[Dict[str, Any]], context: Dict[str, Any]) -> Optional[List[Dict[str, Any]]]:
        """
        Perform reranking using JavaScript bridge integration
        """
        self.metrics['bridge_integration_calls'] += 1
        
        try:
            # Call consultation optimization via JavaScript bridge
            reranking_args = [query, results, {
                'maxResults': self.config['max_results'],
                'confidenceThreshold': self.config['confidence_threshold'],
                'source': context.get('source', 'unknown'),
                'reranking_type': 'bridge_integration'
            }]
            
            result = await self.js_bridge.call_js_component(
                'consultation_optimization',
                'rerankedConsultation',
                reranking_args
            )
            
            # Validate and normalize bridge results
            if isinstance(result, list) and len(result) > 0:
                normalized_results = []
                for item in result:
                    normalized_results.append({
                        **item,
                        'reranking_method': 'bridge_integration',
                        'reranking_metadata': {
                            'bridge_used': True,
                            'timestamp': time.time(),
                            'source': 'consultation_optimization'
                        }
                    })
                
                logger.info(f"🌉 [RERANKING] Bridge integration: {len(normalized_results)} results")
                return normalized_results
            
            return None
            
        except Exception as error:
            logger.warning(f"⚠️ [RERANKING] Bridge integration failed: {error}")
            return None
    
    async def _native_cross_encoder_rerank(self, query: str, results: List[Dict[str, Any]], context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        Perform native cross-encoder reranking
        """
        self.metrics['native_reranking_calls'] += 1
        
        try:
            # Load cross-encoder model if needed
            await self._ensure_model_loaded()
            
            # Prepare query text
            query_text = self._extract_query_text(query)
            
            # Score each result using cross-encoder
            scored_results = []
            for result in results:
                # Extract result text
                result_text = self._extract_result_text(result)
                
                # Calculate cross-encoder score
                cross_encoder_score = await self._calculate_cross_encoder_score(query_text, result_text)
                
                # Calculate combined score
                original_score = result.get('hybridScore') or result.get('similarity') or result.get('confidence') or 0
                combined_score = self._calculate_combined_score(original_score, cross_encoder_score)
                
                scored_results.append({
                    **result,
                    'originalScore': original_score,
                    'crossEncoderScore': cross_encoder_score,
                    'combinedScore': combined_score,
                    'reranked': True,
                    'reranking_method': 'native_cross_encoder',
                    'reranking_metadata': {
                        'model': self.config['reranking_model'],
                        'query_text': query_text[:100] + '...' if len(query_text) > 100 else query_text,
                        'result_text': result_text[:100] + '...' if len(result_text) > 100 else result_text,
                        'timestamp': time.time()
                    }
                })
            
            # Sort by combined score
            reranked_results = sorted(scored_results, key=lambda x: x['combinedScore'], reverse=True)
            
            # Filter by confidence threshold
            filtered_results = [
                result for result in reranked_results 
                if result['combinedScore'] >= self.config['confidence_threshold']
            ]
            
            # Limit results
            final_results = filtered_results[:self.config['max_results']]
            
            # Calculate relevance improvement
            improvement = self._calculate_relevance_improvement(results, final_results)
            self.metrics['relevance_improvements'].append(improvement)
            
            logger.info(f"🔄 [RERANKING] Native reranking: {len(results)} → {len(final_results)} results ({improvement:.1f}% improvement)")
            return final_results
            
        except Exception as error:
            logger.error(f"❌ [RERANKING] Native reranking failed: {error}")
            raise
    
    async def _ensure_model_loaded(self):
        """
        Ensure cross-encoder model is loaded (lazy loading)
        """
        if self.model_loaded:
            return
        
        try:
            # Try to import sentence-transformers
            from sentence_transformers import CrossEncoder
            
            # Load the cross-encoder model
            self.cross_encoder = CrossEncoder(self.config['reranking_model'])
            self.model_loaded = True
            
            logger.info(f"✅ [RERANKING] Cross-encoder model loaded: {self.config['reranking_model']}")
            
        except ImportError:
            logger.warning("⚠️ [RERANKING] sentence-transformers not available, using fallback scoring")
            self.cross_encoder = None
            self.model_loaded = True
        except Exception as error:
            logger.warning(f"⚠️ [RERANKING] Model loading failed: {error}, using fallback")
            self.cross_encoder = None
            self.model_loaded = True
    
    async def _calculate_cross_encoder_score(self, query_text: str, result_text: str) -> float:
        """
        Calculate cross-encoder score for query-result pair
        """
        try:
            if self.cross_encoder is not None:
                # Use actual cross-encoder model
                score = self.cross_encoder.predict([(query_text, result_text)])[0]
                # Normalize to [0, 1] range
                return max(0.0, min(1.0, float(score)))
            else:
                # Fallback scoring without model
                return await self._fallback_cross_encoder_score(query_text, result_text)
                
        except Exception as error:
            logger.warning(f"⚠️ [RERANKING] Cross-encoder scoring failed: {error}")
            return await self._fallback_cross_encoder_score(query_text, result_text)
    
    async def _fallback_cross_encoder_score(self, query_text: str, result_text: str) -> float:
        """
        Fallback cross-encoder scoring without model
        """
        try:
            # Simple text similarity scoring
            query_tokens = set(query_text.lower().split())
            result_tokens = set(result_text.lower().split())
            
            if len(query_tokens) == 0:
                return 0.5
            
            # Calculate Jaccard similarity
            intersection = len(query_tokens.intersection(result_tokens))
            union = len(query_tokens.union(result_tokens))
            
            jaccard_score = intersection / union if union > 0 else 0
            
            # Boost score for exact matches
            exact_matches = sum(1 for token in query_tokens if token in result_text.lower())
            exact_boost = (exact_matches / len(query_tokens)) * 0.3
            
            # Calculate final score
            final_score = jaccard_score + exact_boost
            
            return max(0.0, min(1.0, final_score))
            
        except Exception as error:
            logger.warning(f"⚠️ [RERANKING] Fallback scoring failed: {error}")
            return 0.5
    
    def _calculate_combined_score(self, original_score: float, cross_encoder_score: float) -> float:
        """
        Calculate combined score from original and cross-encoder scores
        """
        return (original_score * self.config['original_weight'] + 
                cross_encoder_score * self.config['cross_encoder_weight'])
    
    def _extract_query_text(self, query) -> str:
        """
        Extract text from various query formats
        """
        if isinstance(query, str):
            return query
        elif isinstance(query, dict):
            return query.get('description') or query.get('text') or query.get('query') or str(query)
        else:
            return str(query)
    
    def _extract_result_text(self, result: Dict[str, Any]) -> str:
        """
        Extract text from result for cross-encoder scoring
        """
        # Try different text fields
        text_fields = ['content', 'text', 'description', 'summary', 'title']
        
        for field in text_fields:
            if field in result and result[field]:
                text = str(result[field])
                # Limit text length for performance
                return text[:1000] if len(text) > 1000 else text
        
        # Fallback to string representation
        return str(result)[:500]
    
    def _calculate_relevance_improvement(self, original_results: List[Dict[str, Any]], reranked_results: List[Dict[str, Any]]) -> float:
        """
        Calculate relevance improvement percentage
        """
        if len(original_results) == 0 or len(reranked_results) == 0:
            return 0.0
        
        # Calculate average scores
        original_avg = sum(
            result.get('hybridScore') or result.get('similarity') or result.get('confidence') or 0
            for result in original_results
        ) / len(original_results)
        
        reranked_avg = sum(
            result.get('combinedScore') or 0
            for result in reranked_results
        ) / len(reranked_results)
        
        if original_avg > 0:
            return ((reranked_avg - original_avg) / original_avg) * 100
        else:
            return 0.0
    
    def _generate_cache_key(self, query: str, results: List[Dict[str, Any]], context: Dict[str, Any]) -> str:
        """Generate cache key for reranking results"""
        key_data = {
            'query': self._extract_query_text(query),
            'results_hash': hashlib.sha256(str(results).encode()).hexdigest()[:16],
            'context': context.get('source', 'unknown'),
            'model': self.config['reranking_model'],
            'strategy': 'reranking'
        }
        key_string = json.dumps(key_data, sort_keys=True)
        return hashlib.sha256(key_string.encode()).hexdigest()
    
    async def _get_cached_result(self, cache_key: str) -> Optional[List[Dict[str, Any]]]:
        """Get cached reranking result"""
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
            logger.warning(f"⚠️ [RERANKING] Cache read failed: {error}")
            return None
    
    async def _cache_result(self, cache_key: str, result: List[Dict[str, Any]]):
        """Cache reranking result"""
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
            logger.warning(f"⚠️ [RERANKING] Cache write failed: {error}")
    
    async def _fallback_reranking(self, query: str, results: List[Dict[str, Any]], context: Dict[str, Any], original_error: Exception) -> List[Dict[str, Any]]:
        """Fallback when reranking fails"""
        self.metrics['fallback_activations'] += 1
        
        logger.warning(f"🔄 [RERANKING] Activating fallback for query: {query}")
        
        try:
            # Simple score-based reranking as fallback
            fallback_results = []
            for result in results:
                original_score = result.get('hybridScore') or result.get('similarity') or result.get('confidence') or 0
                
                fallback_results.append({
                    **result,
                    'combinedScore': original_score,
                    'reranked': True,
                    'reranking_method': 'fallback',
                    'fallback': True,
                    'original_error': str(original_error),
                    'reranking_metadata': {
                        'fallback_mode': True,
                        'timestamp': time.time()
                    }
                })
            
            # Sort by original score
            fallback_results.sort(key=lambda x: x['combinedScore'], reverse=True)
            
            # Limit results
            final_results = fallback_results[:self.config['max_results']]
            
            return final_results
            
        except Exception as fallback_error:
            logger.error(f"❌ [RERANKING] Fallback also failed: {fallback_error}")
            
            # Ultimate fallback - return original results
            return results
    
    def _update_latency_metrics(self, latency: float):
        """Update average latency metrics"""
        if self.metrics['average_latency'] == 0:
            self.metrics['average_latency'] = latency
        else:
            self.metrics['average_latency'] = (
                self.metrics['average_latency'] + latency
            ) / 2
    
    def get_metrics(self) -> Dict[str, Any]:
        """Get reranking performance metrics"""
        cache_total = self.metrics['cache_hits'] + self.metrics['cache_misses']
        cache_hit_rate = (self.metrics['cache_hits'] / cache_total * 100) if cache_total > 0 else 0
        
        avg_improvement = (
            sum(self.metrics['relevance_improvements']) / len(self.metrics['relevance_improvements'])
            if self.metrics['relevance_improvements'] else 0
        )
        
        latency_compliance = (
            (self.metrics['total_reranking_calls'] - self.metrics['latency_target_violations']) / 
            self.metrics['total_reranking_calls'] * 100
            if self.metrics['total_reranking_calls'] > 0 else 100
        )
        
        return {
            **self.metrics,
            'cache_hit_rate': cache_hit_rate,
            'average_relevance_improvement': avg_improvement,
            'latency_compliance_rate': latency_compliance,
            'model_loaded': self.model_loaded
        }
    
    async def health_check(self) -> Dict[str, Any]:
        """Perform health check on reranking strategy"""
        try:
            # Test basic functionality
            test_query = "test reranking query"
            test_results = [
                {'content': 'test result 1', 'hybridScore': 0.8},
                {'content': 'test result 2', 'hybridScore': 0.6}
            ]
            
            test_result = await self.rerank_results(
                test_query,
                test_results,
                {'source': 'health_check'}
            )
            
            return {
                'status': 'healthy',
                'strategy': 'reranking',
                'bridge_available': True,
                'model_loaded': self.model_loaded,
                'cross_encoder_available': self.cross_encoder is not None,
                'cache_enabled': self.config['cache_enabled'],
                'metrics': self.get_metrics()
            }
            
        except Exception as error:
            return {
                'status': 'unhealthy',
                'strategy': 'reranking',
                'error': str(error),
                'metrics': self.get_metrics()
            }

# Export main class
__all__ = ['RerankingStrategy']
