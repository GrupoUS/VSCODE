/**
 * Context Manager - Intelligent Context Optimization System
 * GRUPO US VIBECODE SYSTEM V2.0 - AUGMENT OPTIMIZATION
 */

class ContextManager {
  constructor(options = {}) {
    this.maxTokens = options.maxTokens || 32000;
    this.currentTokens = 0;
    this.context = [];
    this.memoryBank = new Map();
    this.compressionHistory = [];
    
    // Thresholds from .clinerules/rules/context-management.md
    this.thresholds = {
      summarization: 0.70,  // 70% - start summarizing
      archiving: 0.85,      // 85% - archive to memory bank
      emergency: 0.90       // 90% - emergency cleanup
    };
    
    this.priorities = {
      CRITICAL: 10,    // Current task, active work
      HIGH: 8,         // Recent decisions, important context
      MEDIUM: 5,       // Supporting information
      LOW: 3,          // Background context
      ARCHIVE: 1       // Can be compressed/archived
    };
  }

  /**
   * Add content to context with priority
   */
  addContext(content, metadata = {}) {
    const tokens = this.countTokens(content);
    const priority = metadata.priority || this.priorities.MEDIUM;
    const type = metadata.type || 'general';
    
    const contextItem = {
      id: this.generateContextId(),
      content,
      tokens,
      priority,
      type,
      timestamp: Date.now(),
      lastAccessed: Date.now(),
      accessCount: 0,
      metadata
    };

    this.context.push(contextItem);
    this.currentTokens += tokens;
    
    console.log(`📝 Added context: ${type} (${tokens} tokens, priority: ${priority})`);
    
    // Check if optimization is needed
    this.checkOptimization();
    
    return contextItem.id;
  }

  /**
   * Check if context optimization is needed
   */
  checkOptimization() {
    const usage = this.currentTokens / this.maxTokens;
    
    if (usage >= this.thresholds.emergency) {
      console.log('🚨 Emergency context cleanup triggered (90%+)');
      this.emergencyCleanup();
    } else if (usage >= this.thresholds.archiving) {
      console.log('📦 Context archiving triggered (85%+)');
      this.archiveContext();
    } else if (usage >= this.thresholds.summarization) {
      console.log('📄 Context summarization triggered (70%+)');
      this.summarizeContext();
    }
  }

  /**
   * Summarize old context to reduce token usage
   */
  summarizeContext() {
    const oldContext = this.context.filter(item => 
      item.priority <= this.priorities.MEDIUM && 
      Date.now() - item.lastAccessed > 5 * 60 * 1000 // 5 minutes
    );

    if (oldContext.length === 0) return;

    // Group context by type for better summarization
    const groupedContext = this.groupContextByType(oldContext);
    
    for (const [type, items] of Object.entries(groupedContext)) {
      if (items.length > 1) {
        const summary = this.createSummary(items, type);
        this.replaceContextItems(items, summary);
      }
    }
  }

  /**
   * Archive low-priority context to memory bank
   */
  archiveContext() {
    const archivableContext = this.context.filter(item => 
      item.priority <= this.priorities.LOW ||
      Date.now() - item.lastAccessed > 10 * 60 * 1000 // 10 minutes
    );

    archivableContext.forEach(item => {
      this.memoryBank.set(item.id, {
        ...item,
        archivedAt: Date.now()
      });
      
      this.removeContextItem(item.id);
    });

    if (archivableContext.length > 0) {
      console.log(`📦 Archived ${archivableContext.length} context items to memory bank`);
    }
  }

  /**
   * Emergency cleanup when context usage is critical
   */
  emergencyCleanup() {
    // Sort by priority and last access time
    this.context.sort((a, b) => {
      if (a.priority !== b.priority) {
        return b.priority - a.priority; // Higher priority first
      }
      return b.lastAccessed - a.lastAccessed; // More recent first
    });

    // Keep only the most important context (top 50%)
    const keepCount = Math.floor(this.context.length * 0.5);
    const toRemove = this.context.slice(keepCount);
    
    // Archive removed items
    toRemove.forEach(item => {
      this.memoryBank.set(item.id, {
        ...item,
        emergencyArchived: true,
        archivedAt: Date.now()
      });
    });

    this.context = this.context.slice(0, keepCount);
    this.recalculateTokens();
    
    console.log(`🚨 Emergency cleanup: Removed ${toRemove.length} items, kept ${keepCount}`);
  }

  /**
   * Group context items by type
   */
  groupContextByType(contextItems) {
    const groups = {};
    
    contextItems.forEach(item => {
      const type = item.type || 'general';
      if (!groups[type]) {
        groups[type] = [];
      }
      groups[type].push(item);
    });

    return groups;
  }

  /**
   * Create summary from multiple context items
   */
  createSummary(items, type) {
    const combinedContent = items.map(item => item.content).join('\n\n');
    const totalTokens = items.reduce((sum, item) => sum + item.tokens, 0);
    
    // Simple summarization - in production, this would use AI
    const summary = this.generateSummary(combinedContent, type);
    const summaryTokens = this.countTokens(summary);
    
    return {
      id: this.generateContextId(),
      content: summary,
      tokens: summaryTokens,
      priority: Math.max(...items.map(item => item.priority)),
      type: `${type}_summary`,
      timestamp: Date.now(),
      lastAccessed: Date.now(),
      accessCount: 0,
      metadata: {
        summarizedFrom: items.map(item => item.id),
        originalTokens: totalTokens,
        compressionRatio: summaryTokens / totalTokens
      }
    };
  }

  /**
   * Generate summary content (simplified implementation)
   */
  generateSummary(content, type) {
    const lines = content.split('\n').filter(line => line.trim());
    const keyPoints = lines.slice(0, Math.min(10, lines.length));
    
    return `SUMMARY (${type}):\n${keyPoints.join('\n')}\n\n[Summarized from ${lines.length} lines]`;
  }

  /**
   * Replace multiple context items with a summary
   */
  replaceContextItems(itemsToReplace, summary) {
    // Remove original items
    itemsToReplace.forEach(item => {
      this.removeContextItem(item.id);
    });
    
    // Add summary
    this.context.push(summary);
    this.currentTokens += summary.tokens;
    
    const savedTokens = itemsToReplace.reduce((sum, item) => sum + item.tokens, 0) - summary.tokens;
    console.log(`📄 Summarized ${itemsToReplace.length} items, saved ${savedTokens} tokens`);
  }

  /**
   * Remove context item by ID
   */
  removeContextItem(id) {
    const index = this.context.findIndex(item => item.id === id);
    if (index !== -1) {
      const item = this.context[index];
      this.currentTokens -= item.tokens;
      this.context.splice(index, 1);
      return true;
    }
    return false;
  }

  /**
   * Access context item (updates access tracking)
   */
  accessContext(id) {
    const item = this.context.find(item => item.id === id);
    if (item) {
      item.lastAccessed = Date.now();
      item.accessCount++;
      return item.content;
    }
    
    // Check memory bank
    const archivedItem = this.memoryBank.get(id);
    if (archivedItem) {
      // Restore from memory bank if accessed
      this.restoreFromMemoryBank(id);
      return archivedItem.content;
    }
    
    return null;
  }

  /**
   * Restore item from memory bank to active context
   */
  restoreFromMemoryBank(id) {
    const item = this.memoryBank.get(id);
    if (item) {
      // Update metadata
      item.lastAccessed = Date.now();
      item.accessCount++;
      item.restoredAt = Date.now();
      
      // Add back to context
      this.context.push(item);
      this.currentTokens += item.tokens;
      this.memoryBank.delete(id);
      
      console.log(`🔄 Restored context from memory bank: ${id}`);
      
      // Check if optimization is needed after restoration
      this.checkOptimization();
    }
  }

  /**
   * Update context item priority
   */
  updatePriority(id, newPriority) {
    const item = this.context.find(item => item.id === id);
    if (item) {
      item.priority = newPriority;
      item.lastAccessed = Date.now();
      return true;
    }
    return false;
  }

  /**
   * Get current context usage statistics
   */
  getUsageStats() {
    const usage = this.currentTokens / this.maxTokens;
    
    return {
      currentTokens: this.currentTokens,
      maxTokens: this.maxTokens,
      usage: usage,
      usagePercentage: (usage * 100).toFixed(1),
      contextItems: this.context.length,
      memoryBankItems: this.memoryBank.size,
      priorityDistribution: this.getPriorityDistribution(),
      typeDistribution: this.getTypeDistribution(),
      recommendations: this.getOptimizationRecommendations(usage)
    };
  }

  /**
   * Get priority distribution
   */
  getPriorityDistribution() {
    const distribution = {};
    this.context.forEach(item => {
      const priority = item.priority;
      distribution[priority] = (distribution[priority] || 0) + 1;
    });
    return distribution;
  }

  /**
   * Get type distribution
   */
  getTypeDistribution() {
    const distribution = {};
    this.context.forEach(item => {
      const type = item.type;
      distribution[type] = (distribution[type] || 0) + 1;
    });
    return distribution;
  }

  /**
   * Get optimization recommendations
   */
  getOptimizationRecommendations(usage) {
    const recommendations = [];
    
    if (usage > 0.8) {
      recommendations.push('Consider archiving old context items');
    }
    
    if (usage > 0.6) {
      recommendations.push('Summarize related context items');
    }
    
    const oldItems = this.context.filter(item => 
      Date.now() - item.lastAccessed > 15 * 60 * 1000
    );
    
    if (oldItems.length > 5) {
      recommendations.push(`${oldItems.length} items haven't been accessed in 15+ minutes`);
    }
    
    return recommendations;
  }

  /**
   * Count tokens in content (simplified implementation)
   */
  countTokens(content) {
    // Rough estimation: 1 token ≈ 4 characters
    return Math.ceil(content.length / 4);
  }

  /**
   * Generate unique context ID
   */
  generateContextId() {
    return `ctx_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  /**
   * Recalculate total tokens
   */
  recalculateTokens() {
    this.currentTokens = this.context.reduce((sum, item) => sum + item.tokens, 0);
  }

  /**
   * Export context state for handoff
   */
  exportState() {
    return {
      context: this.context,
      memoryBank: Array.from(this.memoryBank.entries()),
      currentTokens: this.currentTokens,
      maxTokens: this.maxTokens,
      exportedAt: Date.now()
    };
  }

  /**
   * Import context state from handoff
   */
  importState(state) {
    this.context = state.context || [];
    this.memoryBank = new Map(state.memoryBank || []);
    this.currentTokens = state.currentTokens || 0;
    this.maxTokens = state.maxTokens || this.maxTokens;
    
    console.log(`🔄 Imported context state: ${this.context.length} items, ${this.currentTokens} tokens`);
  }
}

module.exports = ContextManager;
