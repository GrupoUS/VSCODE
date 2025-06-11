/**
 * CSS Audit System for NEON PRO V2.0
 * Identifies and resolves style conflicts
 */

interface CSSConflict {
  selector: string;
  property: string;
  values: string[];
  sources: string[];
  severity: 'low' | 'medium' | 'high' | 'critical';
}

interface AuditResult {
  conflicts: CSSConflict[];
  duplicates: string[];
  unused: string[];
  performance: {
    totalRules: number;
    complexSelectors: string[];
    heavyAnimations: string[];
  };
}

class CSSAuditor {
  private styleSheets: CSSStyleSheet[] = [];
  private conflicts: CSSConflict[] = [];

  constructor() {
    if (typeof window !== 'undefined') {
      this.styleSheets = Array.from(document.styleSheets);
    }
  }

  public async auditStyles(): Promise<AuditResult> {
    const conflicts = await this.findConflicts();
    const duplicates = this.findDuplicates();
    const unused = this.findUnusedStyles();
    const performance = this.analyzePerformance();

    return {
      conflicts,
      duplicates,
      unused,
      performance,
    };
  }

  private async findConflicts(): Promise<CSSConflict[]> {
    const conflicts: CSSConflict[] = [];
    const propertyMap = new Map<string, Map<string, string[]>>();

    try {
      for (const sheet of this.styleSheets) {
        if (!sheet.href || sheet.href.includes('localhost')) {
          try {
            const rules = Array.from(sheet.cssRules || []);
            
            for (const rule of rules) {
              if (rule instanceof CSSStyleRule) {
                const selector = rule.selectorText;
                const style = rule.style;
                
                for (let i = 0; i < style.length; i++) {
                  const property = style.item(i);
                  const value = style.getPropertyValue(property);
                  
                  if (!propertyMap.has(selector)) {
                    propertyMap.set(selector, new Map());
                  }
                  
                  const selectorMap = propertyMap.get(selector)!;
                  if (!selectorMap.has(property)) {
                    selectorMap.set(property, []);
                  }
                  
                  selectorMap.get(property)!.push(value);
                }
              }
            }
          } catch (e) {
            console.warn('Could not access stylesheet:', sheet.href);
          }
        }
      }

      // Analyze conflicts
      for (const [selector, properties] of propertyMap) {
        for (const [property, values] of properties) {
          if (values.length > 1) {
            const uniqueValues = [...new Set(values)];
            if (uniqueValues.length > 1) {
              conflicts.push({
                selector,
                property,
                values: uniqueValues,
                sources: ['globals.css', 'components.css', 'animations.css'],
                severity: this.determineSeverity(property, uniqueValues),
              });
            }
          }
        }
      }
    } catch (error) {
      console.error('Error during CSS audit:', error);
    }

    return conflicts;
  }

  private findDuplicates(): string[] {
    const duplicates: string[] = [];
    const seenRules = new Set<string>();

    try {
      for (const sheet of this.styleSheets) {
        if (!sheet.href || sheet.href.includes('localhost')) {
          try {
            const rules = Array.from(sheet.cssRules || []);
            
            for (const rule of rules) {
              if (rule instanceof CSSStyleRule) {
                const ruleText = rule.cssText;
                if (seenRules.has(ruleText)) {
                  duplicates.push(rule.selectorText);
                } else {
                  seenRules.add(ruleText);
                }
              }
            }
          } catch (e) {
            console.warn('Could not access stylesheet for duplicates:', sheet.href);
          }
        }
      }
    } catch (error) {
      console.error('Error finding duplicates:', error);
    }

    return duplicates;
  }

  private findUnusedStyles(): string[] {
    const unused: string[] = [];
    const usedSelectors = new Set<string>();

    try {
      // Get all elements in the DOM
      const allElements = document.querySelectorAll('*');
      
      // Check which selectors are actually used
      for (const sheet of this.styleSheets) {
        if (!sheet.href || sheet.href.includes('localhost')) {
          try {
            const rules = Array.from(sheet.cssRules || []);
            
            for (const rule of rules) {
              if (rule instanceof CSSStyleRule) {
                const selector = rule.selectorText;
                
                try {
                  // Try to find elements matching this selector
                  const matches = document.querySelectorAll(selector);
                  if (matches.length > 0) {
                    usedSelectors.add(selector);
                  } else {
                    // Check if it's a pseudo-class or state selector
                    if (!selector.includes(':hover') && 
                        !selector.includes(':focus') && 
                        !selector.includes(':active') &&
                        !selector.includes('::before') &&
                        !selector.includes('::after')) {
                      unused.push(selector);
                    }
                  }
                } catch (e) {
                  // Invalid selector, skip
                }
              }
            }
          } catch (e) {
            console.warn('Could not access stylesheet for unused styles:', sheet.href);
          }
        }
      }
    } catch (error) {
      console.error('Error finding unused styles:', error);
    }

    return unused;
  }

  private analyzePerformance() {
    let totalRules = 0;
    const complexSelectors: string[] = [];
    const heavyAnimations: string[] = [];

    try {
      for (const sheet of this.styleSheets) {
        if (!sheet.href || sheet.href.includes('localhost')) {
          try {
            const rules = Array.from(sheet.cssRules || []);
            totalRules += rules.length;
            
            for (const rule of rules) {
              if (rule instanceof CSSStyleRule) {
                const selector = rule.selectorText;
                
                // Check for complex selectors
                if (selector.split(' ').length > 3 || 
                    selector.includes('+') || 
                    selector.includes('~') ||
                    selector.includes('[')) {
                  complexSelectors.push(selector);
                }
                
                // Check for heavy animations
                const style = rule.style;
                if (style.animation || style.transform || style.filter) {
                  heavyAnimations.push(selector);
                }
              }
            }
          } catch (e) {
            console.warn('Could not access stylesheet for performance analysis:', sheet.href);
          }
        }
      }
    } catch (error) {
      console.error('Error analyzing performance:', error);
    }

    return {
      totalRules,
      complexSelectors,
      heavyAnimations,
    };
  }

  private determineSeverity(property: string, values: string[]): CSSConflict['severity'] {
    // Critical properties that affect layout
    const criticalProperties = ['display', 'position', 'z-index', 'overflow'];
    if (criticalProperties.includes(property)) {
      return 'critical';
    }

    // High impact properties
    const highImpactProperties = ['color', 'background', 'font-size', 'margin', 'padding'];
    if (highImpactProperties.includes(property)) {
      return 'high';
    }

    // Medium impact properties
    const mediumImpactProperties = ['border', 'box-shadow', 'text-shadow', 'opacity'];
    if (mediumImpactProperties.includes(property)) {
      return 'medium';
    }

    return 'low';
  }

  public generateReport(auditResult: AuditResult): string {
    let report = '# CSS Audit Report - NEON PRO V2.0\n\n';
    
    report += `## Summary\n`;
    report += `- Total Rules: ${auditResult.performance.totalRules}\n`;
    report += `- Conflicts Found: ${auditResult.conflicts.length}\n`;
    report += `- Duplicate Rules: ${auditResult.duplicates.length}\n`;
    report += `- Unused Selectors: ${auditResult.unused.length}\n\n`;

    if (auditResult.conflicts.length > 0) {
      report += `## Conflicts\n`;
      for (const conflict of auditResult.conflicts) {
        report += `### ${conflict.selector} - ${conflict.property}\n`;
        report += `**Severity**: ${conflict.severity}\n`;
        report += `**Values**: ${conflict.values.join(', ')}\n\n`;
      }
    }

    if (auditResult.performance.complexSelectors.length > 0) {
      report += `## Performance Issues\n`;
      report += `### Complex Selectors\n`;
      for (const selector of auditResult.performance.complexSelectors.slice(0, 10)) {
        report += `- ${selector}\n`;
      }
      report += '\n';
    }

    return report;
  }
}

export const cssAuditor = new CSSAuditor();
export default CSSAuditor;
