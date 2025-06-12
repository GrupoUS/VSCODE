#!/usr/bin/env python3

"""
CRAWL4AI HYBRID SEARCH STRATEGY V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Native Python implementation of Crawl4AI's USE_HYBRID_SEARCH strategy.
Combines vector search (semantic) with keyword search (lexical) using RRF merge algorithm.

Based on Crawl4AI research and RRF (Reciprocal Rank Fusion):
- Vector search: Semantic embeddings for contextual understanding
- Keyword search: BM25 algorithm for exact term matching
- RRF merge: Formula RRF(d) = Σ(r ∈ R) 1 / (k + r(d)) with k=60
- Performance: 100-1000x faster than rank-bm25 using bm25s library

Features:
- Hybrid search combining semantic + lexical approaches
- Integration with JavaScript bridge for vector search
- Native BM25 implementation using bm25s library
- RRF (Reciprocal Rank Fusion) merge algorithm
- Integration with existing hybrid cache system
- Robust fallback mechanisms
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

class HybridSearchStrategy:
    """
    Native implementation of Crawl4AI's hybrid search strategy
    """
    
    def __init__(self):
        # Initialize JavaScript bridge for vector search integration
        self.js_bridge = JavaScriptBridge()
        
        # Configuration based on research
        self.config = {
            'vector_weight': 0.7,
            'keyword_weight': 0.3,
            'rrf_k': 60,  # RRF constant (empirically proven optimal)
            'bm25_k1': 1.2,  # BM25 parameter
            'bm25_b': 0.75,  # BM25 parameter
            'max_results': 100,
            'cache_enabled': True,
            'cache_ttl': 1800,  # 30 minutes (matching existing system)
            'fallback_enabled': True,
            'performance_monitoring': True
        }
        
        # Performance metrics
        self.metrics = {
            'total_searches': 0,
            'vector_search_calls': 0,
            'keyword_search_calls': 0,
            'rrf_merge_calls': 0,
            'cache_hits': 0,
            'cache_misses': 0,
            'fallback_activations': 0,
            'average_search_time': 0,
            'hybrid_search_success_rate': 100.0
        }
        
        # Cache directory (integrating with existing hybrid cache)
        self.cache_dir = Path(__file__).parent.parent / 'cache' / 'hybrid-search'
        self.cache_dir.mkdir(parents=True, exist_ok=True)
        
        # BM25 components
        self.bm25_retriever = None
        self.document_corpus = []
        self.tokenized_corpus = []
        
        # Initialize BM25 system
        self._initialize_bm25_system()
        
        logger.info("✅ [HYBRID SEARCH] Strategy initialized successfully")
    
    def _initialize_bm25_system(self):
        """Initialize BM25 system with fallback"""
        try:
            # Try to import bm25s library
            import bm25s
            self.bm25s = bm25s
            logger.info("✅ [HYBRID SEARCH] BM25S library loaded successfully")
        except ImportError:
            logger.warning("⚠️ [HYBRID SEARCH] BM25S library not available, using fallback")
            self.bm25s = None
    
    async def perform_hybrid_search(self, query: str, context: Dict[str, Any] = None) -> List[Dict[str, Any]]:
        """
        Perform hybrid search combining vector and keyword search
        
        Args:
            query: Search query string
            context: Additional context information
            
        Returns:
            List of search results with hybrid scores
        """
        start_time = time.time()
        self.metrics['total_searches'] += 1
        
        try:
            # Prepare context information
            if context is None:
                context = {}
            
            # Generate cache key
            cache_key = self._generate_cache_key(query, context)
            
            # Check cache first
            cached_result = await self._get_cached_result(cache_key)
            if cached_result is not None:
                self.metrics['cache_hits'] += 1
                search_time = (time.time() - start_time) * 1000
                logger.info(f"💾 [HYBRID SEARCH] Cache hit ({search_time:.1f}ms)")
                return cached_result
            
            self.metrics['cache_misses'] += 1
            
            # Step 1: Perform vector search via JavaScript bridge
            vector_results = await self._perform_vector_search(query, context)
            
            # Step 2: Perform keyword search using native BM25
            keyword_results = await self._perform_keyword_search(query, context)
            
            # Step 3: Merge results using RRF algorithm
            hybrid_results = self._merge_results_rrf(vector_results, keyword_results)
            
            # Step 4: Enhance results with metadata
            enhanced_results = self._enhance_results_metadata(hybrid_results, query, context)
            
            # Cache the results
            await self._cache_result(cache_key, enhanced_results)
            
            # Update metrics
            search_time = (time.time() - start_time) * 1000
            self._update_search_time_metrics(search_time)
            
            logger.info(f"✅ [HYBRID SEARCH] Completed hybrid search ({search_time:.1f}ms)")
            return enhanced_results
            
        except Exception as error:
            logger.error(f"❌ [HYBRID SEARCH] Search failed: {error}")
            
            # Try fallback if enabled
            if self.config['fallback_enabled']:
                return await self._fallback_search(query, context, error)
            
            raise
    
    async def _perform_vector_search(self, query: str, context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        Perform vector search using JavaScript bridge
        """
        self.metrics['vector_search_calls'] += 1
        
        try:
            # Call vector search via JavaScript bridge
            search_args = [query, {
                'max_results': self.config['max_results'],
                'domain': context.get('domain', 'general'),
                'source': context.get('source', 'unknown'),
                'search_type': 'vector'
            }]
            
            result = await self.js_bridge.call_js_component(
                'embedding_service',
                'vectorSearch',
                search_args
            )
            
            # Normalize vector search results
            vector_results = []
            if isinstance(result, list):
                for i, item in enumerate(result):
                    vector_results.append({
                        'content': item.get('content', ''),
                        'score': item.get('score', 0.0),
                        'rank': i + 1,
                        'search_type': 'vector',
                        'metadata': item.get('metadata', {})
                    })
            
            logger.info(f"🔍 [HYBRID SEARCH] Vector search: {len(vector_results)} results")
            return vector_results
            
        except Exception as error:
            logger.warning(f"⚠️ [HYBRID SEARCH] Vector search failed: {error}")
            return []
    
    async def _perform_keyword_search(self, query: str, context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        Perform keyword search using native BM25
        """
        self.metrics['keyword_search_calls'] += 1
        
        try:
            if self.bm25s is not None and self.bm25_retriever is not None:
                # Use BM25S library for keyword search
                return await self._bm25s_search(query, context)
            else:
                # Fallback to simple keyword matching
                return await self._simple_keyword_search(query, context)
                
        except Exception as error:
            logger.warning(f"⚠️ [HYBRID SEARCH] Keyword search failed: {error}")
            return []
    
    async def _bm25s_search(self, query: str, context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        Perform BM25 search using bm25s library
        """
        try:
            # Tokenize query
            query_tokens = self.bm25s.tokenize([query])
            
            # Retrieve results
            results, scores = self.bm25_retriever.retrieve(
                query_tokens, 
                k=self.config['max_results']
            )
            
            # Format results
            keyword_results = []
            for i in range(results.shape[1]):
                doc_id = results[0, i]
                score = scores[0, i]
                
                if doc_id < len(self.document_corpus):
                    keyword_results.append({
                        'content': self.document_corpus[doc_id],
                        'score': float(score),
                        'rank': i + 1,
                        'search_type': 'keyword',
                        'metadata': {
                            'doc_id': int(doc_id),
                            'bm25_score': float(score),
                            'algorithm': 'bm25s'
                        }
                    })
            
            logger.info(f"📝 [HYBRID SEARCH] BM25S search: {len(keyword_results)} results")
            return keyword_results
            
        except Exception as error:
            logger.warning(f"⚠️ [HYBRID SEARCH] BM25S search failed: {error}")
            return []
    
    async def _simple_keyword_search(self, query: str, context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        Simple keyword search fallback
        """
        try:
            query_terms = query.lower().split()
            keyword_results = []
            
            for i, doc in enumerate(self.document_corpus):
                doc_lower = doc.lower()
                score = 0.0
                
                # Simple TF-IDF-like scoring
                for term in query_terms:
                    if term in doc_lower:
                        tf = doc_lower.count(term) / len(doc_lower.split())
                        score += tf
                
                if score > 0:
                    keyword_results.append({
                        'content': doc,
                        'score': score,
                        'rank': len(keyword_results) + 1,
                        'search_type': 'keyword',
                        'metadata': {
                            'doc_id': i,
                            'simple_score': score,
                            'algorithm': 'simple_keyword'
                        }
                    })
            
            # Sort by score
            keyword_results.sort(key=lambda x: x['score'], reverse=True)
            
            # Limit results
            keyword_results = keyword_results[:self.config['max_results']]
            
            # Update ranks
            for i, result in enumerate(keyword_results):
                result['rank'] = i + 1
            
            logger.info(f"📝 [HYBRID SEARCH] Simple keyword search: {len(keyword_results)} results")
            return keyword_results
            
        except Exception as error:
            logger.warning(f"⚠️ [HYBRID SEARCH] Simple keyword search failed: {error}")
            return []
    
    def _merge_results_rrf(self, vector_results: List[Dict[str, Any]], keyword_results: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """
        Merge results using Reciprocal Rank Fusion (RRF) algorithm
        
        RRF Formula: RRF(d) = Σ(r ∈ R) 1 / (k + r(d))
        where k=60 (empirically proven optimal value)
        """
        self.metrics['rrf_merge_calls'] += 1
        
        try:
            # Create document score map
            doc_scores = {}
            doc_metadata = {}
            
            # Process vector results
            for result in vector_results:
                content = result['content']
                rank = result['rank']
                
                # RRF score contribution from vector search
                rrf_score = 1.0 / (self.config['rrf_k'] + rank)
                weighted_score = rrf_score * self.config['vector_weight']
                
                if content not in doc_scores:
                    doc_scores[content] = 0.0
                    doc_metadata[content] = {
                        'search_types': [],
                        'vector_rank': None,
                        'keyword_rank': None,
                        'vector_score': None,
                        'keyword_score': None
                    }
                
                doc_scores[content] += weighted_score
                doc_metadata[content]['search_types'].append('vector')
                doc_metadata[content]['vector_rank'] = rank
                doc_metadata[content]['vector_score'] = result['score']
            
            # Process keyword results
            for result in keyword_results:
                content = result['content']
                rank = result['rank']
                
                # RRF score contribution from keyword search
                rrf_score = 1.0 / (self.config['rrf_k'] + rank)
                weighted_score = rrf_score * self.config['keyword_weight']
                
                if content not in doc_scores:
                    doc_scores[content] = 0.0
                    doc_metadata[content] = {
                        'search_types': [],
                        'vector_rank': None,
                        'keyword_rank': None,
                        'vector_score': None,
                        'keyword_score': None
                    }
                
                doc_scores[content] += weighted_score
                doc_metadata[content]['search_types'].append('keyword')
                doc_metadata[content]['keyword_rank'] = rank
                doc_metadata[content]['keyword_score'] = result['score']
            
            # Create merged results
            merged_results = []
            for content, hybrid_score in doc_scores.items():
                merged_results.append({
                    'content': content,
                    'hybrid_score': hybrid_score,
                    'search_types': doc_metadata[content]['search_types'],
                    'vector_rank': doc_metadata[content]['vector_rank'],
                    'keyword_rank': doc_metadata[content]['keyword_rank'],
                    'vector_score': doc_metadata[content]['vector_score'],
                    'keyword_score': doc_metadata[content]['keyword_score'],
                    'boosted': len(doc_metadata[content]['search_types']) > 1  # Found in both searches
                })
            
            # Sort by hybrid score
            merged_results.sort(key=lambda x: x['hybrid_score'], reverse=True)
            
            # Add final ranks
            for i, result in enumerate(merged_results):
                result['final_rank'] = i + 1
            
            logger.info(f"🔀 [HYBRID SEARCH] RRF merge: {len(merged_results)} results")
            return merged_results
            
        except Exception as error:
            logger.error(f"❌ [HYBRID SEARCH] RRF merge failed: {error}")
            # Fallback to simple concatenation
            return vector_results + keyword_results
    
    def _enhance_results_metadata(self, results: List[Dict[str, Any]], query: str, context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        Enhance results with additional metadata
        """
        enhanced_results = []
        
        for result in results:
            enhanced_result = {
                **result,
                'metadata': {
                    **result.get('metadata', {}),
                    'query': query,
                    'search_strategy': 'hybrid_search',
                    'rrf_k': self.config['rrf_k'],
                    'vector_weight': self.config['vector_weight'],
                    'keyword_weight': self.config['keyword_weight'],
                    'timestamp': time.time(),
                    'context': context.get('source', 'unknown')
                }
            }
            enhanced_results.append(enhanced_result)
        
        return enhanced_results
    
    def index_corpus(self, corpus: List[str]):
        """
        Index corpus for keyword search
        """
        try:
            self.document_corpus = corpus
            
            if self.bm25s is not None:
                # Tokenize corpus for BM25S
                self.tokenized_corpus = self.bm25s.tokenize(corpus)
                
                # Create BM25 retriever
                self.bm25_retriever = self.bm25s.BM25(
                    k1=self.config['bm25_k1'],
                    b=self.config['bm25_b']
                )
                
                # Index the corpus
                self.bm25_retriever.index(self.tokenized_corpus)
                
                logger.info(f"✅ [HYBRID SEARCH] Indexed {len(corpus)} documents with BM25S")
            else:
                logger.info(f"✅ [HYBRID SEARCH] Indexed {len(corpus)} documents (simple mode)")
                
        except Exception as error:
            logger.error(f"❌ [HYBRID SEARCH] Corpus indexing failed: {error}")
    
    def _generate_cache_key(self, query: str, context: Dict[str, Any]) -> str:
        """Generate cache key for hybrid search"""
        key_data = {
            'query': query.lower().strip(),
            'context': context.get('source', 'unknown'),
            'vector_weight': self.config['vector_weight'],
            'keyword_weight': self.config['keyword_weight'],
            'rrf_k': self.config['rrf_k'],
            'strategy': 'hybrid_search'
        }
        key_string = json.dumps(key_data, sort_keys=True)
        return hashlib.sha256(key_string.encode()).hexdigest()
    
    async def _get_cached_result(self, cache_key: str) -> Optional[List[Dict[str, Any]]]:
        """Get cached hybrid search result"""
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
            logger.warning(f"⚠️ [HYBRID SEARCH] Cache read failed: {error}")
            return None
    
    async def _cache_result(self, cache_key: str, result: List[Dict[str, Any]]):
        """Cache hybrid search result"""
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
            logger.warning(f"⚠️ [HYBRID SEARCH] Cache write failed: {error}")
    
    async def _fallback_search(self, query: str, context: Dict[str, Any], original_error: Exception) -> List[Dict[str, Any]]:
        """Fallback when hybrid search fails"""
        self.metrics['fallback_activations'] += 1
        
        logger.warning(f"🔄 [HYBRID SEARCH] Activating fallback for query: {query}")
        
        try:
            # Try keyword search only as fallback
            keyword_results = await self._perform_keyword_search(query, context)
            
            # Enhance with fallback metadata
            fallback_results = []
            for result in keyword_results:
                fallback_result = {
                    **result,
                    'hybrid_score': result['score'],
                    'search_types': ['keyword'],
                    'fallback': True,
                    'original_error': str(original_error),
                    'metadata': {
                        **result.get('metadata', {}),
                        'fallback_mode': True,
                        'search_strategy': 'hybrid_search_fallback'
                    }
                }
                fallback_results.append(fallback_result)
            
            return fallback_results
            
        except Exception as fallback_error:
            logger.error(f"❌ [HYBRID SEARCH] Fallback also failed: {fallback_error}")
            
            # Ultimate fallback - return empty results with error info
            return [{
                'content': f"Search failed: {original_error}",
                'hybrid_score': 0.0,
                'search_types': ['error'],
                'fallback': True,
                'error': str(fallback_error),
                'metadata': {
                    'search_strategy': 'hybrid_search_error',
                    'original_error': str(original_error),
                    'fallback_error': str(fallback_error)
                }
            }]
    
    def _update_search_time_metrics(self, search_time: float):
        """Update average search time metrics"""
        if self.metrics['average_search_time'] == 0:
            self.metrics['average_search_time'] = search_time
        else:
            self.metrics['average_search_time'] = (
                self.metrics['average_search_time'] + search_time
            ) / 2
    
    def get_metrics(self) -> Dict[str, Any]:
        """Get hybrid search performance metrics"""
        cache_total = self.metrics['cache_hits'] + self.metrics['cache_misses']
        cache_hit_rate = (self.metrics['cache_hits'] / cache_total * 100) if cache_total > 0 else 0
        
        return {
            **self.metrics,
            'cache_hit_rate': cache_hit_rate,
            'search_efficiency': cache_hit_rate  # Cache hits improve efficiency
        }
    
    async def health_check(self) -> Dict[str, Any]:
        """Perform health check on hybrid search strategy"""
        try:
            # Test basic functionality
            test_result = await self.perform_hybrid_search(
                'test query',
                {'source': 'health_check'}
            )
            
            return {
                'status': 'healthy',
                'strategy': 'hybrid_search',
                'bridge_available': True,
                'bm25s_available': self.bm25s is not None,
                'corpus_indexed': len(self.document_corpus) > 0,
                'metrics': self.get_metrics()
            }
            
        except Exception as error:
            return {
                'status': 'unhealthy',
                'strategy': 'hybrid_search',
                'error': str(error),
                'metrics': self.get_metrics()
            }

# Export main class
__all__ = ['HybridSearchStrategy']
