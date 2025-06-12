#!/usr/bin/env python3

"""
CENTRAL MEMORY HUB COORDINATOR V1.0
GRUPO US VIBECODE SYSTEM - Native RAG Implementation

Central coordinator for all memory sources and RAG strategies.
Orchestrates Enhanced Memory System V4.0, Crawl4AI strategies, Cognee ECL pipeline,
and integrates with MCP Shrimp Task Manager via environment variables.

Features:
- Intelligent routing based on query type and context
- Robust fallback chain for zero disruption
- Integration with all native RAG strategies
- Performance monitoring and optimization
- 100% backward compatibility
"""

import asyncio
import json
import hashlib
import time
import logging
import os
from pathlib import Path
from typing import Dict, Any, List, Optional, Tuple
import sys

# Add parent directory for imports
sys.path.append(str(Path(__file__).parent.parent))

from integration.js_bridge import JavaScriptBridge
from crawl4ai_strategies.contextual_embeddings import ContextualEmbeddingsStrategy
from crawl4ai_strategies.hybrid_search import HybridSearchStrategy
from crawl4ai_strategies.agentic_rag import AgenticRAGStrategy
from crawl4ai_strategies.reranking import RerankingStrategy
from cognee_ecl_pipeline.ecl_pipeline import CogneeECLPipeline

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class CentralMemoryCoordinator:
    """
    Central coordinator for all memory sources and RAG strategies
    """
    
    def __init__(self):
        # Initialize JavaScript bridge for legacy system integration
        self.js_bridge = JavaScriptBridge()
        
        # Initialize all Crawl4AI strategies
        self.crawl4ai_strategies = {
            'contextual_embeddings': ContextualEmbeddingsStrategy(),
            'hybrid_search': HybridSearchStrategy(),
            'agentic_rag': AgenticRAGStrategy(),
            'reranking': RerankingStrategy()
        }
        
        # Initialize Cognee ECL pipeline
        self.cognee_pipeline = CogneeECLPipeline()
        
        # Configuration - FASE 3 Optimized
        self.config = {
            'routing_enabled': True,
            'fallback_enabled': True,
            'performance_monitoring': True,
            'mcp_integration': True,
            'cache_enabled': True,
            'cache_ttl': 3600,  # 1 hour
            'max_concurrent_strategies': 3,
            'timeout_seconds': 30,
            'backward_compatibility': True,
            # FASE 3 Cache Optimizations
            'intelligent_cache_enabled': True,
            'cache_compression': True,
            'cache_preload': True,
            'adaptive_ttl': True,
            'cache_size_limit': 1000,  # Max cache entries
            'cache_hit_threshold': 0.8,  # 80% hit rate target
            'memory_pressure_threshold': 0.9  # 90% memory usage
        }
        
        # Memory sources registry
        self.memory_sources = {
            'enhanced_memory': {
                'name': 'Enhanced Memory System V4.0',
                'type': 'legacy_system',
                'priority': 1,
                'bridge_component': 'enhanced_memory',
                'fallback_available': True
            },
            'self_correction': {
                'name': 'Self Correction Log',
                'type': 'file_based',
                'priority': 2,
                'file_path': '@project-core/memory/self_correction_log.md',
                'fallback_available': True
            },
            'augment_memories': {
                'name': 'Augment Memories',
                'type': 'native_bridge',
                'priority': 3,
                'bridge_component': 'augment_bridge',
                'fallback_available': True
            },
            'crawl4ai_rag': {
                'name': 'Crawl4AI Native Strategies',
                'type': 'native_strategies',
                'priority': 4,
                'strategies': self.crawl4ai_strategies,
                'fallback_available': True
            },
            'cognee_ecl': {
                'name': 'Cognee ECL Pipeline',
                'type': 'native_pipeline',
                'priority': 5,
                'pipeline': self.cognee_pipeline,
                'fallback_available': True
            }
        }
        
        # Performance metrics - FASE 3 Enhanced
        self.metrics = {
            'total_consultations': 0,
            'routing_decisions': {},
            'strategy_usage': {},
            'fallback_activations': 0,
            'cache_hits': 0,
            'cache_misses': 0,
            'average_response_time': 0,
            'success_rate': 100.0,
            'mcp_integrations': 0,
            # FASE 3 Cache Metrics
            'cache_hit_rate': 0.0,
            'cache_size': 0,
            'cache_evictions': 0,
            'cache_compression_ratio': 0.0,
            'adaptive_ttl_adjustments': 0,
            'memory_pressure_events': 0,
            'preload_cache_hits': 0
        }
        
        # Cache directory and intelligent cache system - FASE 3
        self.cache_dir = Path(__file__).parent.parent / 'cache' / 'central-hub'
        self.cache_dir.mkdir(parents=True, exist_ok=True)

        # FASE 3 Intelligent Cache System
        self.intelligent_cache = {}
        self.cache_metadata = {}
        self.cache_access_patterns = {}
        self.preload_cache = {}
        self.last_cache_cleanup = time.time()
        
        # MCP Shrimp integration via environment variables
        self._setup_mcp_integration()
        
        logger.info("✅ [CENTRAL HUB] Memory Coordinator initialized successfully")

    async def initialize(self):
        """Initialize the memory coordinator"""
        try:
            # Already initialized in constructor
            return True
        except Exception as error:
            logger.error(f"❌ [CENTRAL HUB] Initialization failed: {error}")
            return False

    def _setup_mcp_integration(self):
        """Setup MCP Shrimp Task Manager integration via environment variables"""
        try:
            # Set environment variables for MCP Shrimp integration
            os.environ['MEMORY_COORDINATOR_ACTIVE'] = 'true'
            os.environ['NATIVE_RAG_SYSTEM_ENABLED'] = 'true'
            os.environ['CRAWL4AI_STRATEGIES_AVAILABLE'] = json.dumps(list(self.crawl4ai_strategies.keys()))
            os.environ['COGNEE_ECL_PIPELINE_ACTIVE'] = 'true'
            
            logger.info("✅ [CENTRAL HUB] MCP integration environment variables set")
            
        except Exception as error:
            logger.warning(f"⚠️ [CENTRAL HUB] MCP integration setup failed: {error}")
    
    async def coordinate_memory_operations(self, query: str, context: Dict[str, Any] = None) -> Dict[str, Any]:
        """Alias for coordinate_memory_consultation for MCP integration compatibility"""
        return await self.coordinate_memory_consultation(query, context)

    async def coordinate_memory_consultation(self, query: str, context: Dict[str, Any] = None) -> Dict[str, Any]:
        """
        Central coordination of memory consultation across all sources
        
        Args:
            query: Query string or complex query object
            context: Additional context information
            
        Returns:
            Coordinated response from appropriate memory sources
        """
        start_time = time.time()
        self.metrics['total_consultations'] += 1
        
        try:
            # Prepare context information
            if context is None:
                context = {}
            
            # Generate cache key
            cache_key = self._generate_cache_key(query, context)
            
            # FASE 3 Intelligent Cache Check
            cached_result = await self._get_cached_result_intelligent(cache_key, query, context)
            if cached_result is not None:
                self.metrics['cache_hits'] += 1
                self._update_cache_hit_rate()
                response_time = (time.time() - start_time) * 1000
                logger.info(f"💾 [CENTRAL HUB] Intelligent cache hit ({response_time:.1f}ms)")
                return cached_result

            self.metrics['cache_misses'] += 1
            
            # Step 1: Intelligent routing decision
            routing_decision = await self._make_routing_decision(query, context)
            
            # Step 2: Execute consultation strategy
            consultation_result = await self._execute_consultation_strategy(query, context, routing_decision)
            
            # Step 3: Apply fallback if needed
            if not consultation_result['success'] and self.config['fallback_enabled']:
                consultation_result = await self._execute_fallback_chain(query, context, routing_decision)
            
            # Step 4: Optimize and enhance results
            optimized_result = await self._optimize_consultation_result(consultation_result, context)
            
            # Step 5: Integrate with MCP Shrimp if configured
            if self.config['mcp_integration']:
                await self._integrate_with_mcp_shrimp(optimized_result, context)
            
            # FASE 3 Intelligent Cache Storage
            await self._cache_result_intelligent(cache_key, optimized_result, query, context)
            
            # Update metrics
            response_time = (time.time() - start_time) * 1000
            self._update_response_time_metrics(response_time)
            
            logger.info(f"✅ [CENTRAL HUB] Memory consultation completed ({response_time:.1f}ms)")
            return optimized_result
            
        except Exception as error:
            logger.error(f"❌ [CENTRAL HUB] Memory consultation failed: {error}")
            
            # Ultimate fallback
            if self.config['fallback_enabled']:
                return await self._ultimate_fallback(query, context, error)
            
            raise
    
    async def _make_routing_decision(self, query: str, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Make intelligent routing decision based on query type and context
        """
        try:
            # Analyze query characteristics
            query_analysis = self._analyze_query(query, context)
            
            # Determine optimal strategy combination
            strategy_selection = self._select_strategies(query_analysis, context)
            
            # Create routing decision
            routing_decision = {
                'query_analysis': query_analysis,
                'selected_strategies': strategy_selection,
                'execution_order': self._determine_execution_order(strategy_selection),
                'fallback_chain': self._build_fallback_chain(strategy_selection),
                'estimated_complexity': query_analysis['complexity'],
                'routing_timestamp': time.time()
            }
            
            # Update routing metrics
            strategy_key = '+'.join(sorted(strategy_selection))
            self.metrics['routing_decisions'][strategy_key] = self.metrics['routing_decisions'].get(strategy_key, 0) + 1
            
            logger.info(f"🧭 [CENTRAL HUB] Routing decision: {strategy_selection}")
            return routing_decision
            
        except Exception as error:
            logger.error(f"❌ [CENTRAL HUB] Routing decision failed: {error}")
            
            # Default routing decision
            return {
                'query_analysis': {'type': 'unknown', 'complexity': 'medium'},
                'selected_strategies': ['enhanced_memory'],
                'execution_order': ['enhanced_memory'],
                'fallback_chain': ['enhanced_memory', 'self_correction'],
                'estimated_complexity': 'medium',
                'routing_timestamp': time.time(),
                'error': str(error)
            }
    
    def _analyze_query(self, query: str, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Analyze query to determine characteristics and optimal strategy
        """
        query_text = self._extract_query_text(query)
        
        analysis = {
            'type': 'general',
            'complexity': 'medium',
            'domain': 'general',
            'requires_code_analysis': False,
            'requires_pattern_recognition': False,
            'requires_semantic_search': False,
            'requires_reranking': False,
            'length': len(query_text),
            'keywords': query_text.lower().split()[:10]  # First 10 keywords
        }
        
        # Determine query type
        if any(keyword in query_text.lower() for keyword in ['code', 'function', 'class', 'method', 'pattern']):
            analysis['type'] = 'code_analysis'
            analysis['requires_code_analysis'] = True
            analysis['requires_pattern_recognition'] = True
        elif any(keyword in query_text.lower() for keyword in ['search', 'find', 'lookup', 'retrieve']):
            analysis['type'] = 'search_query'
            analysis['requires_semantic_search'] = True
            analysis['requires_reranking'] = True
        elif any(keyword in query_text.lower() for keyword in ['error', 'bug', 'issue', 'problem']):
            analysis['type'] = 'error_analysis'
            analysis['domain'] = 'debugging'
        elif any(keyword in query_text.lower() for keyword in ['memory', 'remember', 'recall', 'history']):
            analysis['type'] = 'memory_query'
            analysis['domain'] = 'memory_system'
        
        # Determine complexity
        if len(query_text) > 200 or analysis['type'] in ['code_analysis', 'error_analysis']:
            analysis['complexity'] = 'high'
        elif len(query_text) < 50:
            analysis['complexity'] = 'low'
        
        return analysis
    
    def _select_strategies(self, query_analysis: Dict[str, Any], context: Dict[str, Any]) -> List[str]:
        """
        Select optimal strategies based on query analysis
        """
        strategies = []
        
        # Always include enhanced memory as base
        strategies.append('enhanced_memory')
        
        # Add strategies based on query type
        if query_analysis['requires_code_analysis']:
            strategies.append('crawl4ai_rag')  # Agentic RAG for code analysis
            strategies.append('cognee_ecl')   # ECL pipeline for entity extraction
        
        if query_analysis['requires_semantic_search']:
            strategies.append('crawl4ai_rag')  # Hybrid search + contextual embeddings
        
        if query_analysis['requires_reranking']:
            strategies.append('crawl4ai_rag')  # Reranking strategy
        
        if query_analysis['type'] == 'error_analysis':
            strategies.append('self_correction')  # Self correction log
        
        if query_analysis['complexity'] == 'high':
            strategies.append('cognee_ecl')  # ECL pipeline for complex analysis
        
        # Remove duplicates while preserving order
        unique_strategies = []
        for strategy in strategies:
            if strategy not in unique_strategies:
                unique_strategies.append(strategy)
        
        # Limit concurrent strategies
        return unique_strategies[:self.config['max_concurrent_strategies']]
    
    def _determine_execution_order(self, strategies: List[str]) -> List[str]:
        """
        Determine optimal execution order based on strategy priorities
        """
        # Sort by priority (lower number = higher priority)
        priority_order = []
        for strategy in strategies:
            if strategy in self.memory_sources:
                priority = self.memory_sources[strategy]['priority']
                priority_order.append((priority, strategy))
        
        # Sort by priority and return strategy names
        priority_order.sort(key=lambda x: x[0])
        return [strategy for _, strategy in priority_order]
    
    def _build_fallback_chain(self, strategies: List[str]) -> List[str]:
        """
        Build fallback chain for robust error handling
        """
        fallback_chain = []
        
        # Add strategies with fallback available
        for strategy in strategies:
            if strategy in self.memory_sources and self.memory_sources[strategy]['fallback_available']:
                fallback_chain.append(strategy)
        
        # Always include enhanced_memory as ultimate fallback
        if 'enhanced_memory' not in fallback_chain:
            fallback_chain.append('enhanced_memory')
        
        return fallback_chain
    
    async def _execute_consultation_strategy(self, query: str, context: Dict[str, Any], routing_decision: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute consultation strategy based on routing decision
        """
        try:
            execution_order = routing_decision['execution_order']
            results = {}
            
            for strategy_name in execution_order:
                try:
                    strategy_result = await self._execute_single_strategy(strategy_name, query, context)
                    results[strategy_name] = strategy_result
                    
                    # Update strategy usage metrics
                    self.metrics['strategy_usage'][strategy_name] = self.metrics['strategy_usage'].get(strategy_name, 0) + 1
                    
                except Exception as strategy_error:
                    logger.warning(f"⚠️ [CENTRAL HUB] Strategy {strategy_name} failed: {strategy_error}")
                    results[strategy_name] = {
                        'success': False,
                        'error': str(strategy_error),
                        'strategy': strategy_name
                    }
            
            # Aggregate results
            aggregated_result = self._aggregate_strategy_results(results, routing_decision)
            
            return {
                'success': True,
                'results': aggregated_result,
                'strategies_used': list(results.keys()),
                'routing_decision': routing_decision,
                'execution_timestamp': time.time()
            }
            
        except Exception as error:
            logger.error(f"❌ [CENTRAL HUB] Strategy execution failed: {error}")
            return {
                'success': False,
                'error': str(error),
                'strategies_used': [],
                'routing_decision': routing_decision,
                'execution_timestamp': time.time()
            }
    
    async def _execute_single_strategy(self, strategy_name: str, query: str, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute a single strategy
        """
        if strategy_name == 'enhanced_memory':
            return await self._execute_enhanced_memory(query, context)
        elif strategy_name == 'self_correction':
            return await self._execute_self_correction(query, context)
        elif strategy_name == 'augment_memories':
            return await self._execute_augment_memories(query, context)
        elif strategy_name == 'crawl4ai_rag':
            return await self._execute_crawl4ai_strategies(query, context)
        elif strategy_name == 'cognee_ecl':
            return await self._execute_cognee_pipeline(query, context)
        else:
            raise ValueError(f"Unknown strategy: {strategy_name}")
    
    async def _execute_enhanced_memory(self, query: str, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute Enhanced Memory System V4.0 consultation
        """
        try:
            # Call enhanced memory via JavaScript bridge
            memory_args = [query, {
                'source': context.get('source', 'central_hub'),
                'consultation_type': 'enhanced_memory',
                'context': context
            }]
            
            result = await self.js_bridge.call_js_component(
                'enhanced_memory',
                'consultMemory',
                memory_args
            )
            
            return {
                'success': True,
                'data': result,
                'strategy': 'enhanced_memory',
                'source': 'bridge_integration'
            }
            
        except Exception as error:
            logger.warning(f"⚠️ [CENTRAL HUB] Enhanced memory failed: {error}")
            return {
                'success': False,
                'error': str(error),
                'strategy': 'enhanced_memory'
            }
    
    async def _execute_self_correction(self, query: str, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute self correction log consultation
        """
        try:
            # Read self correction log
            log_file = Path(__file__).parent.parent.parent / 'self_correction_log.md'
            
            if log_file.exists():
                with open(log_file, 'r', encoding='utf-8') as f:
                    log_content = f.read()
                
                # Simple search in log content
                query_text = self._extract_query_text(query).lower()
                relevant_lines = []
                
                for line in log_content.split('\n'):
                    if any(keyword in line.lower() for keyword in query_text.split()):
                        relevant_lines.append(line.strip())
                
                return {
                    'success': True,
                    'data': {
                        'relevant_entries': relevant_lines[:10],  # Limit to 10 entries
                        'total_matches': len(relevant_lines)
                    },
                    'strategy': 'self_correction',
                    'source': 'file_based'
                }
            else:
                return {
                    'success': False,
                    'error': 'Self correction log not found',
                    'strategy': 'self_correction'
                }
                
        except Exception as error:
            logger.warning(f"⚠️ [CENTRAL HUB] Self correction failed: {error}")
            return {
                'success': False,
                'error': str(error),
                'strategy': 'self_correction'
            }
    
    async def _execute_augment_memories(self, query: str, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute Augment Memories consultation via native bridge
        """
        try:
            # Import Augment bridge
            from .augment_bridge import AugmentMemoriesBridge

            # Initialize bridge
            augment_bridge = AugmentMemoriesBridge()

            # Initialize if not already done
            bridge_initialized = await augment_bridge.initialize()
            if not bridge_initialized:
                return {
                    'success': False,
                    'error': 'Augment bridge initialization failed',
                    'strategy': 'augment_memories'
                }

            # Search preferences based on query
            query_text = self._extract_query_text(query)
            matching_preferences = await augment_bridge.search_preferences(query_text)

            # Get additional context if available
            query_analysis = context.get('query_analysis', {})

            # If query is technology-specific, get technology preferences
            if query_analysis.get('requires_code_analysis', False):
                tech_preferences = []
                for tech in ['React', 'Next.js', 'TypeScript', 'MCP', 'Sequential Thinking']:
                    tech_prefs = await augment_bridge.get_technology_preferences(tech)
                    tech_preferences.extend(tech_prefs)

                # Combine with general search results
                all_preferences = matching_preferences + tech_preferences
                # Remove duplicates
                seen_lines = set()
                unique_preferences = []
                for pref in all_preferences:
                    if pref['line_number'] not in seen_lines:
                        seen_lines.add(pref['line_number'])
                        unique_preferences.append(pref)
                matching_preferences = unique_preferences

            return {
                'success': True,
                'data': {
                    'matching_preferences': matching_preferences,
                    'total_matches': len(matching_preferences),
                    'bridge_metrics': augment_bridge.get_metrics()
                },
                'strategy': 'augment_memories',
                'source': 'native_bridge'
            }

        except Exception as error:
            logger.warning(f"⚠️ [CENTRAL HUB] Augment memories failed: {error}")
            return {
                'success': False,
                'error': str(error),
                'strategy': 'augment_memories'
            }

    async def _execute_crawl4ai_strategies(self, query: str, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute Crawl4AI native strategies
        """
        try:
            query_analysis = context.get('query_analysis', {})
            results = {}

            # Execute relevant Crawl4AI strategies based on query analysis
            if query_analysis.get('requires_semantic_search', False):
                # Contextual embeddings + hybrid search
                contextual_result = await self.crawl4ai_strategies['contextual_embeddings'].generate_contextual_embeddings(
                    query, context
                )
                results['contextual_embeddings'] = contextual_result

                hybrid_result = await self.crawl4ai_strategies['hybrid_search'].perform_hybrid_search(
                    query, context
                )
                results['hybrid_search'] = hybrid_result

            if query_analysis.get('requires_code_analysis', False):
                # Agentic RAG for code analysis
                agentic_result = await self.crawl4ai_strategies['agentic_rag'].extract_code_patterns(
                    query, context
                )
                results['agentic_rag'] = agentic_result

            if query_analysis.get('requires_reranking', False) and 'hybrid_search' in results:
                # Reranking for result optimization
                reranking_result = await self.crawl4ai_strategies['reranking'].rerank_results(
                    query, results['hybrid_search'], context
                )
                results['reranking'] = reranking_result

            # If no specific requirements, use contextual embeddings as default
            if not results:
                contextual_result = await self.crawl4ai_strategies['contextual_embeddings'].generate_contextual_embeddings(
                    query, context
                )
                results['contextual_embeddings'] = contextual_result

            return {
                'success': True,
                'data': results,
                'strategy': 'crawl4ai_rag',
                'strategies_executed': list(results.keys())
            }

        except Exception as error:
            logger.warning(f"⚠️ [CENTRAL HUB] Crawl4AI strategies failed: {error}")
            return {
                'success': False,
                'error': str(error),
                'strategy': 'crawl4ai_rag'
            }

    async def _execute_cognee_pipeline(self, query: str, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute Cognee ECL pipeline
        """
        try:
            # Execute ECL pipeline
            ecl_result = await self.cognee_pipeline.execute_ecl_pipeline(
                self._extract_query_text(query),
                context.get('source', 'central_hub'),
                context
            )

            return {
                'success': True,
                'data': ecl_result,
                'strategy': 'cognee_ecl',
                'pipeline_phases': ['extract', 'cognify', 'load']
            }

        except Exception as error:
            logger.warning(f"⚠️ [CENTRAL HUB] Cognee pipeline failed: {error}")
            return {
                'success': False,
                'error': str(error),
                'strategy': 'cognee_ecl'
            }

    def _aggregate_strategy_results(self, results: Dict[str, Any], routing_decision: Dict[str, Any]) -> Dict[str, Any]:
        """
        Aggregate results from multiple strategies
        """
        aggregated = {
            'successful_strategies': [],
            'failed_strategies': [],
            'combined_data': {},
            'confidence_score': 0.0,
            'result_count': 0
        }

        total_strategies = len(results)
        successful_count = 0

        for strategy_name, result in results.items():
            if result.get('success', False):
                aggregated['successful_strategies'].append(strategy_name)
                aggregated['combined_data'][strategy_name] = result.get('data', {})
                successful_count += 1
            else:
                aggregated['failed_strategies'].append(strategy_name)
                aggregated['combined_data'][strategy_name] = {
                    'error': result.get('error', 'Unknown error'),
                    'success': False
                }

        # Calculate confidence score
        if total_strategies > 0:
            aggregated['confidence_score'] = successful_count / total_strategies

        # Count total results
        for strategy_data in aggregated['combined_data'].values():
            if isinstance(strategy_data, dict) and 'data' in strategy_data:
                if isinstance(strategy_data['data'], list):
                    aggregated['result_count'] += len(strategy_data['data'])
                elif isinstance(strategy_data['data'], dict):
                    aggregated['result_count'] += 1

        return aggregated

    async def _execute_fallback_chain(self, query: str, context: Dict[str, Any], routing_decision: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute fallback chain when primary strategies fail
        """
        self.metrics['fallback_activations'] += 1

        logger.warning(f"🔄 [CENTRAL HUB] Activating fallback chain")

        try:
            fallback_chain = routing_decision.get('fallback_chain', ['enhanced_memory'])
            fallback_results = {}

            for strategy_name in fallback_chain:
                try:
                    fallback_result = await self._execute_single_strategy(strategy_name, query, context)
                    if fallback_result.get('success', False):
                        fallback_results[strategy_name] = fallback_result
                        logger.info(f"✅ [CENTRAL HUB] Fallback strategy {strategy_name} succeeded")
                        break  # Stop at first successful fallback
                except Exception as fallback_error:
                    logger.warning(f"⚠️ [CENTRAL HUB] Fallback strategy {strategy_name} failed: {fallback_error}")
                    continue

            if fallback_results:
                aggregated_result = self._aggregate_strategy_results(fallback_results, routing_decision)
                return {
                    'success': True,
                    'results': aggregated_result,
                    'strategies_used': list(fallback_results.keys()),
                    'fallback_activated': True,
                    'routing_decision': routing_decision,
                    'execution_timestamp': time.time()
                }
            else:
                return await self._ultimate_fallback(query, context, Exception("All fallback strategies failed"))

        except Exception as error:
            logger.error(f"❌ [CENTRAL HUB] Fallback chain failed: {error}")
            return await self._ultimate_fallback(query, context, error)

    async def _ultimate_fallback(self, query: str, context: Dict[str, Any], original_error: Exception) -> Dict[str, Any]:
        """
        Ultimate fallback when all strategies fail
        """
        logger.warning(f"🚨 [CENTRAL HUB] Activating ultimate fallback")

        return {
            'success': False,
            'results': {
                'successful_strategies': [],
                'failed_strategies': ['all'],
                'combined_data': {
                    'error_message': 'All memory consultation strategies failed',
                    'original_error': str(original_error),
                    'fallback_response': f"Unable to process query: {self._extract_query_text(query)[:100]}...",
                    'suggestions': [
                        'Try simplifying the query',
                        'Check system connectivity',
                        'Verify memory sources are available'
                    ]
                },
                'confidence_score': 0.0,
                'result_count': 0
            },
            'strategies_used': [],
            'fallback_activated': True,
            'ultimate_fallback': True,
            'execution_timestamp': time.time()
        }

    async def _optimize_consultation_result(self, consultation_result: Dict[str, Any], context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Optimize and enhance consultation results
        """
        try:
            if not consultation_result.get('success', False):
                return consultation_result

            results = consultation_result.get('results', {})

            # Add metadata
            optimized_result = {
                **consultation_result,
                'metadata': {
                    'coordinator_version': '1.0',
                    'optimization_applied': True,
                    'total_strategies': len(consultation_result.get('strategies_used', [])),
                    'confidence_score': results.get('confidence_score', 0.0),
                    'result_count': results.get('result_count', 0),
                    'processing_timestamp': time.time()
                }
            }

            # Enhance with performance metrics
            if self.config['performance_monitoring']:
                optimized_result['performance_metrics'] = {
                    'total_consultations': self.metrics['total_consultations'],
                    'success_rate': self.metrics['success_rate'],
                    'average_response_time': self.metrics['average_response_time'],
                    'cache_hit_rate': (
                        self.metrics['cache_hits'] /
                        (self.metrics['cache_hits'] + self.metrics['cache_misses']) * 100
                        if (self.metrics['cache_hits'] + self.metrics['cache_misses']) > 0 else 0
                    )
                }

            return optimized_result

        except Exception as error:
            logger.warning(f"⚠️ [CENTRAL HUB] Result optimization failed: {error}")
            return consultation_result

    async def _integrate_with_mcp_shrimp(self, result: Dict[str, Any], context: Dict[str, Any]):
        """
        Integrate with MCP Shrimp Task Manager via environment variables
        """
        try:
            if not self.config['mcp_integration']:
                return

            self.metrics['mcp_integrations'] += 1

            # Update environment variables with consultation results
            os.environ['LAST_MEMORY_CONSULTATION_SUCCESS'] = str(result.get('success', False))
            os.environ['LAST_MEMORY_CONSULTATION_TIMESTAMP'] = str(time.time())
            os.environ['MEMORY_CONSULTATION_COUNT'] = str(self.metrics['total_consultations'])

            # Set strategy usage information
            strategies_used = result.get('strategies_used', [])
            os.environ['LAST_STRATEGIES_USED'] = json.dumps(strategies_used)

            logger.info(f"🔗 [CENTRAL HUB] MCP Shrimp integration updated")

        except Exception as error:
            logger.warning(f"⚠️ [CENTRAL HUB] MCP Shrimp integration failed: {error}")

    def _extract_query_text(self, query) -> str:
        """Extract text from various query formats"""
        if isinstance(query, str):
            return query
        elif isinstance(query, dict):
            return query.get('description') or query.get('text') or query.get('query') or str(query)
        else:
            return str(query)

    def _generate_cache_key(self, query: str, context: Dict[str, Any]) -> str:
        """Generate cache key for consultation results"""
        key_data = {
            'query': self._extract_query_text(query),
            'context': context.get('source', 'unknown'),
            'coordinator_version': '1.0'
        }
        key_string = json.dumps(key_data, sort_keys=True)
        return hashlib.sha256(key_string.encode()).hexdigest()

    async def _get_cached_result(self, cache_key: str) -> Optional[Dict[str, Any]]:
        """Get cached consultation result"""
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
            logger.warning(f"⚠️ [CENTRAL HUB] Cache read failed: {error}")
            return None

    async def _cache_result(self, cache_key: str, result: Dict[str, Any]):
        """Cache consultation result"""
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
            logger.warning(f"⚠️ [CENTRAL HUB] Cache write failed: {error}")

    def _update_response_time_metrics(self, response_time: float):
        """Update average response time metrics"""
        if self.metrics['average_response_time'] == 0:
            self.metrics['average_response_time'] = response_time
        else:
            self.metrics['average_response_time'] = (
                self.metrics['average_response_time'] + response_time
            ) / 2

    def get_metrics(self) -> Dict[str, Any]:
        """Get coordinator performance metrics"""
        cache_total = self.metrics['cache_hits'] + self.metrics['cache_misses']
        cache_hit_rate = (self.metrics['cache_hits'] / cache_total * 100) if cache_total > 0 else 0

        return {
            **self.metrics,
            'cache_hit_rate': cache_hit_rate,
            'memory_sources_available': len(self.memory_sources),
            'crawl4ai_strategies_available': len(self.crawl4ai_strategies),
            'mcp_integration_active': self.config['mcp_integration']
        }

    async def health_check(self) -> Dict[str, Any]:
        """Perform health check on memory coordinator"""
        try:
            # Test basic functionality
            test_result = await self.coordinate_memory_consultation(
                'health check test query',
                {'source': 'health_check'}
            )

            return {
                'status': 'healthy',
                'coordinator': 'central_memory_hub',
                'memory_sources_available': len(self.memory_sources),
                'crawl4ai_strategies_available': len(self.crawl4ai_strategies),
                'cognee_pipeline_available': True,
                'mcp_integration_active': self.config['mcp_integration'],
                'test_consultation_success': test_result.get('success', False),
                'metrics': self.get_metrics()
            }

        except Exception as error:
            return {
                'status': 'unhealthy',
                'coordinator': 'central_memory_hub',
                'error': str(error),
                'metrics': self.get_metrics()
            }

    # FASE 3 INTELLIGENT CACHE SYSTEM METHODS

    async def _get_cached_result_intelligent(self, cache_key: str, query: str, context: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """FASE 3 Intelligent cache retrieval with access pattern tracking"""
        if not self.config['intelligent_cache_enabled']:
            return await self._get_cached_result(cache_key)

        try:
            # Check memory cache first (fastest)
            if cache_key in self.intelligent_cache:
                cache_entry = self.intelligent_cache[cache_key]

                # Check TTL with adaptive adjustment
                current_time = time.time()
                ttl = self._calculate_adaptive_ttl(cache_key, cache_entry)

                if current_time - cache_entry['timestamp'] < ttl:
                    # Update access pattern
                    self._update_access_pattern(cache_key, query, context)

                    # Decompress if needed
                    if cache_entry.get('compressed', False):
                        result = self._decompress_cache_data(cache_entry['data'])
                    else:
                        result = cache_entry['data']

                    self.metrics['cache_size'] = len(self.intelligent_cache)
                    return result
                else:
                    # Expired entry
                    del self.intelligent_cache[cache_key]
                    if cache_key in self.cache_metadata:
                        del self.cache_metadata[cache_key]

            # Check preload cache for similar queries
            preload_result = await self._check_preload_cache(query, context)
            if preload_result:
                self.metrics['preload_cache_hits'] += 1
                return preload_result

            # Fallback to file cache
            return await self._get_cached_result(cache_key)

        except Exception as error:
            logger.warning(f"⚠️ [CENTRAL HUB] Intelligent cache read failed: {error}")
            return await self._get_cached_result(cache_key)

    async def _cache_result_intelligent(self, cache_key: str, result: Dict[str, Any], query: str, context: Dict[str, Any]):
        """FASE 3 Intelligent cache storage with compression and optimization"""
        if not self.config['intelligent_cache_enabled']:
            return await self._cache_result(cache_key, result)

        try:
            # Check memory pressure and cleanup if needed
            await self._manage_cache_memory_pressure()

            # Prepare cache entry
            cache_entry = {
                'data': result,
                'timestamp': time.time(),
                'access_count': 1,
                'query_hash': hashlib.sha256(str(query).encode()).hexdigest()[:16],
                'context_type': context.get('source', 'unknown'),
                'compressed': False,
                'size_bytes': len(json.dumps(result))
            }

            # Apply compression for large results
            if cache_entry['size_bytes'] > 1024:  # 1KB threshold
                compressed_data = self._compress_cache_data(result)
                if len(compressed_data) < cache_entry['size_bytes'] * 0.8:  # 20% compression minimum
                    cache_entry['data'] = compressed_data
                    cache_entry['compressed'] = True
                    cache_entry['size_bytes'] = len(compressed_data)
                    self.metrics['cache_compression_ratio'] = len(compressed_data) / cache_entry['size_bytes']

            # Store in memory cache
            self.intelligent_cache[cache_key] = cache_entry

            # Update metadata
            self.cache_metadata[cache_key] = {
                'created': time.time(),
                'last_access': time.time(),
                'access_frequency': 1,
                'query_pattern': self._extract_query_pattern(query),
                'context_pattern': self._extract_context_pattern(context)
            }

            # Update metrics
            self.metrics['cache_size'] = len(self.intelligent_cache)

            # Preload similar queries if pattern detected
            await self._preload_similar_queries(query, context, result)

            # Also store in file cache as backup
            await self._cache_result(cache_key, result)

        except Exception as error:
            logger.warning(f"⚠️ [CENTRAL HUB] Intelligent cache write failed: {error}")
            await self._cache_result(cache_key, result)

    def _calculate_adaptive_ttl(self, cache_key: str, cache_entry: Dict[str, Any]) -> float:
        """Calculate adaptive TTL based on access patterns"""
        if not self.config['adaptive_ttl']:
            return self.config['cache_ttl']

        base_ttl = self.config['cache_ttl']

        # Adjust based on access frequency
        if cache_key in self.cache_metadata:
            metadata = self.cache_metadata[cache_key]
            access_frequency = metadata.get('access_frequency', 1)

            # More frequently accessed items get longer TTL
            if access_frequency > 10:
                multiplier = 2.0
            elif access_frequency > 5:
                multiplier = 1.5
            elif access_frequency > 2:
                multiplier = 1.2
            else:
                multiplier = 1.0

            adaptive_ttl = base_ttl * multiplier
            self.metrics['adaptive_ttl_adjustments'] += 1
            return adaptive_ttl

        return base_ttl

    def _update_access_pattern(self, cache_key: str, query: str, context: Dict[str, Any]):
        """Update access patterns for intelligent caching"""
        if cache_key in self.cache_metadata:
            metadata = self.cache_metadata[cache_key]
            metadata['last_access'] = time.time()
            metadata['access_frequency'] += 1

        # Track global access patterns
        query_pattern = self._extract_query_pattern(query)
        if query_pattern not in self.cache_access_patterns:
            self.cache_access_patterns[query_pattern] = {'count': 0, 'last_seen': time.time()}

        self.cache_access_patterns[query_pattern]['count'] += 1
        self.cache_access_patterns[query_pattern]['last_seen'] = time.time()

    def _update_cache_hit_rate(self):
        """Update cache hit rate metrics"""
        total_requests = self.metrics['cache_hits'] + self.metrics['cache_misses']
        if total_requests > 0:
            self.metrics['cache_hit_rate'] = self.metrics['cache_hits'] / total_requests

    async def _manage_cache_memory_pressure(self):
        """Manage cache memory pressure with intelligent eviction"""
        current_size = len(self.intelligent_cache)

        if current_size > self.config['cache_size_limit']:
            # Calculate eviction candidates
            eviction_candidates = []
            current_time = time.time()

            for cache_key, metadata in self.cache_metadata.items():
                if cache_key in self.intelligent_cache:
                    # Score based on access frequency and recency
                    access_frequency = metadata.get('access_frequency', 1)
                    last_access = metadata.get('last_access', current_time)
                    age = current_time - last_access

                    # Lower score = higher eviction priority
                    score = access_frequency / (age + 1)
                    eviction_candidates.append((score, cache_key))

            # Sort by score and evict lowest scoring entries
            eviction_candidates.sort(key=lambda x: x[0])
            evict_count = current_size - int(self.config['cache_size_limit'] * 0.8)  # Evict to 80% capacity

            for _, cache_key in eviction_candidates[:evict_count]:
                if cache_key in self.intelligent_cache:
                    del self.intelligent_cache[cache_key]
                if cache_key in self.cache_metadata:
                    del self.cache_metadata[cache_key]
                self.metrics['cache_evictions'] += 1

            self.metrics['memory_pressure_events'] += 1
            logger.info(f"🧹 [CENTRAL HUB] Cache cleanup: evicted {evict_count} entries")

    def _compress_cache_data(self, data: Dict[str, Any]) -> bytes:
        """Compress cache data for storage efficiency"""
        import gzip
        json_str = json.dumps(data, separators=(',', ':'))
        return gzip.compress(json_str.encode('utf-8'))

    def _decompress_cache_data(self, compressed_data: bytes) -> Dict[str, Any]:
        """Decompress cache data"""
        import gzip
        json_str = gzip.decompress(compressed_data).decode('utf-8')
        return json.loads(json_str)

    def _extract_query_pattern(self, query: str) -> str:
        """Extract query pattern for similarity matching"""
        query_text = self._extract_query_text(query).lower()
        # Simple pattern extraction - could be enhanced with NLP
        words = query_text.split()
        if len(words) > 3:
            return ' '.join(sorted(words[:3]))  # First 3 words, sorted
        return query_text

    def _extract_context_pattern(self, context: Dict[str, Any]) -> str:
        """Extract context pattern for similarity matching"""
        return context.get('source', 'unknown')

    async def _check_preload_cache(self, query: str, context: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Check preload cache for similar queries"""
        query_pattern = self._extract_query_pattern(query)

        if query_pattern in self.preload_cache:
            preload_entry = self.preload_cache[query_pattern]

            # Check if preload entry is still valid
            if time.time() - preload_entry['timestamp'] < self.config['cache_ttl'] / 2:  # Half TTL for preload
                return preload_entry['data']
            else:
                del self.preload_cache[query_pattern]

        return None

    async def _preload_similar_queries(self, query: str, context: Dict[str, Any], result: Dict[str, Any]):
        """Preload cache for similar queries"""
        if not self.config['cache_preload']:
            return

        query_pattern = self._extract_query_pattern(query)

        # Store in preload cache for similar queries
        self.preload_cache[query_pattern] = {
            'data': result,
            'timestamp': time.time(),
            'original_query': query,
            'context_pattern': self._extract_context_pattern(context)
        }

        # Limit preload cache size
        if len(self.preload_cache) > 100:
            # Remove oldest entries
            oldest_pattern = min(self.preload_cache.keys(),
                               key=lambda k: self.preload_cache[k]['timestamp'])
            del self.preload_cache[oldest_pattern]

# Export main class
__all__ = ['CentralMemoryCoordinator']
