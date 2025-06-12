/**
 * PERFORMANCE MONITOR - PLAYWRIGHT MCP OPTIMIZATION
 * 
 * Sistema de monitoramento de performance para Playwright MCP Microsoft oficial
 * Foca em accessibility snapshots vs screenshots e otimização contínua
 * 
 * @version 1.0
 * @author GRUPO US - VIBECODE SYSTEM
 */

const fs = require('fs').promises;
const path = require('path');

class PlaywrightPerformanceMonitor {
    constructor() {
        this.metrics = {
            snapshotTime: [],
            screenshotTime: [],
            navigationTime: [],
            actionTime: [],
            memoryUsage: [],
            networkRequests: []
        };
        
        this.thresholds = {
            snapshotWarning: 1000,    // 1s
            snapshotCritical: 2000,   // 2s
            screenshotWarning: 3000,  // 3s
            screenshotCritical: 5000, // 5s
            navigationWarning: 5000,  // 5s
            navigationCritical: 10000 // 10s
        };
        
        this.reportPath = '@project-core/automation/playwright-output/performance-reports';
        this.startTime = Date.now();
    }

    /**
     * Medir tempo de accessibility snapshot
     */
    async measureSnapshot(operation) {
        const start = Date.now();
        const startMemory = process.memoryUsage();
        
        try {
            console.log('📋 Measuring accessibility snapshot...');
            const result = await operation();
            
            const duration = Date.now() - start;
            const endMemory = process.memoryUsage();
            const memoryDelta = endMemory.heapUsed - startMemory.heapUsed;
            
            this.metrics.snapshotTime.push(duration);
            this.metrics.memoryUsage.push(memoryDelta);
            
            this.logPerformance('SNAPSHOT', duration, memoryDelta);
            this.checkThresholds('snapshot', duration);
            
            return result;
        } catch (error) {
            console.error('❌ Snapshot measurement failed:', error.message);
            throw error;
        }
    }

    /**
     * Medir tempo de screenshot
     */
    async measureScreenshot(operation) {
        const start = Date.now();
        const startMemory = process.memoryUsage();
        
        try {
            console.log('📸 Measuring screenshot...');
            const result = await operation();
            
            const duration = Date.now() - start;
            const endMemory = process.memoryUsage();
            const memoryDelta = endMemory.heapUsed - startMemory.heapUsed;
            
            this.metrics.screenshotTime.push(duration);
            this.metrics.memoryUsage.push(memoryDelta);
            
            this.logPerformance('SCREENSHOT', duration, memoryDelta);
            this.checkThresholds('screenshot', duration);
            
            return result;
        } catch (error) {
            console.error('❌ Screenshot measurement failed:', error.message);
            throw error;
        }
    }

    /**
     * Medir tempo de navegação
     */
    async measureNavigation(operation) {
        const start = Date.now();
        
        try {
            console.log('🧭 Measuring navigation...');
            const result = await operation();
            
            const duration = Date.now() - start;
            this.metrics.navigationTime.push(duration);
            
            this.logPerformance('NAVIGATION', duration);
            this.checkThresholds('navigation', duration);
            
            return result;
        } catch (error) {
            console.error('❌ Navigation measurement failed:', error.message);
            throw error;
        }
    }

    /**
     * Medir tempo de ação (click, type, etc.)
     */
    async measureAction(actionType, operation) {
        const start = Date.now();
        
        try {
            console.log(`⚡ Measuring ${actionType} action...`);
            const result = await operation();
            
            const duration = Date.now() - start;
            this.metrics.actionTime.push(duration);
            
            this.logPerformance(`ACTION_${actionType.toUpperCase()}`, duration);
            
            return result;
        } catch (error) {
            console.error(`❌ ${actionType} action measurement failed:`, error.message);
            throw error;
        }
    }

    /**
     * Log de performance com formatação
     */
    logPerformance(operation, duration, memoryDelta = 0) {
        const status = this.getPerformanceStatus(operation.toLowerCase(), duration);
        const memoryMB = (memoryDelta / 1024 / 1024).toFixed(2);
        
        console.log(`📊 ${operation}: ${duration}ms ${memoryDelta ? `(+${memoryMB}MB)` : ''} ${status}`);
    }

    /**
     * Verificar thresholds e alertas
     */
    checkThresholds(type, duration) {
        const warningThreshold = this.thresholds[`${type}Warning`];
        const criticalThreshold = this.thresholds[`${type}Critical`];
        
        if (duration > criticalThreshold) {
            console.log(`🚨 CRITICAL: ${type} took ${duration}ms (threshold: ${criticalThreshold}ms)`);
        } else if (duration > warningThreshold) {
            console.log(`⚠️ WARNING: ${type} took ${duration}ms (threshold: ${warningThreshold}ms)`);
        }
    }

    /**
     * Obter status de performance
     */
    getPerformanceStatus(type, duration) {
        const warningThreshold = this.thresholds[`${type}Warning`];
        const criticalThreshold = this.thresholds[`${type}Critical`];
        
        if (duration > criticalThreshold) return '🚨';
        if (duration > warningThreshold) return '⚠️';
        return '✅';
    }

    /**
     * Calcular estatísticas
     */
    calculateStats(array) {
        if (array.length === 0) return { avg: 0, min: 0, max: 0, median: 0 };
        
        const sorted = [...array].sort((a, b) => a - b);
        const avg = array.reduce((a, b) => a + b, 0) / array.length;
        const min = sorted[0];
        const max = sorted[sorted.length - 1];
        const median = sorted[Math.floor(sorted.length / 2)];
        
        return { avg: Math.round(avg), min, max, median };
    }

    /**
     * Gerar relatório de performance
     */
    generateReport() {
        const totalTime = Date.now() - this.startTime;
        
        const report = {
            timestamp: new Date().toISOString(),
            totalExecutionTime: totalTime,
            metrics: {
                snapshots: {
                    count: this.metrics.snapshotTime.length,
                    stats: this.calculateStats(this.metrics.snapshotTime),
                    efficiency: this.calculateEfficiency('snapshot')
                },
                screenshots: {
                    count: this.metrics.screenshotTime.length,
                    stats: this.calculateStats(this.metrics.screenshotTime),
                    efficiency: this.calculateEfficiency('screenshot')
                },
                navigation: {
                    count: this.metrics.navigationTime.length,
                    stats: this.calculateStats(this.metrics.navigationTime)
                },
                actions: {
                    count: this.metrics.actionTime.length,
                    stats: this.calculateStats(this.metrics.actionTime)
                },
                memory: {
                    stats: this.calculateStats(this.metrics.memoryUsage),
                    totalMB: (this.metrics.memoryUsage.reduce((a, b) => a + b, 0) / 1024 / 1024).toFixed(2)
                }
            },
            recommendations: this.generateRecommendations(),
            performance: this.calculateOverallPerformance()
        };

        console.log('\n📊 PERFORMANCE REPORT GENERATED');
        console.log('================================');
        console.log(`Total Execution Time: ${totalTime}ms`);
        console.log(`Snapshots: ${report.metrics.snapshots.count} (avg: ${report.metrics.snapshots.stats.avg}ms)`);
        console.log(`Screenshots: ${report.metrics.screenshots.count} (avg: ${report.metrics.screenshots.stats.avg}ms)`);
        console.log(`Navigation: ${report.metrics.navigation.count} (avg: ${report.metrics.navigation.stats.avg}ms)`);
        console.log(`Actions: ${report.metrics.actions.count} (avg: ${report.metrics.actions.stats.avg}ms)`);
        console.log(`Memory Usage: ${report.metrics.memory.totalMB}MB`);
        console.log(`Overall Performance: ${report.performance.score}/100`);
        
        if (report.recommendations.length > 0) {
            console.log('\n💡 RECOMMENDATIONS:');
            report.recommendations.forEach((rec, index) => {
                console.log(`${index + 1}. ${rec}`);
            });
        }

        return report;
    }

    /**
     * Calcular eficiência (snapshots vs screenshots)
     */
    calculateEfficiency(type) {
        const times = this.metrics[`${type}Time`];
        if (times.length === 0) return 100;
        
        const avgTime = times.reduce((a, b) => a + b, 0) / times.length;
        const threshold = this.thresholds[`${type}Warning`];
        
        return Math.max(0, Math.min(100, ((threshold - avgTime) / threshold) * 100));
    }

    /**
     * Gerar recomendações baseadas em métricas
     */
    generateRecommendations() {
        const recommendations = [];
        
        // Análise de snapshots
        const snapshotStats = this.calculateStats(this.metrics.snapshotTime);
        if (snapshotStats.avg > this.thresholds.snapshotWarning) {
            recommendations.push(`Optimize selectors for faster snapshots (current avg: ${snapshotStats.avg}ms)`);
        }
        
        // Análise de screenshots
        const screenshotStats = this.calculateStats(this.metrics.screenshotTime);
        if (screenshotStats.avg > this.thresholds.screenshotWarning) {
            recommendations.push(`Reduce screenshot usage, prefer accessibility snapshots (current avg: ${screenshotStats.avg}ms)`);
        }
        
        // Comparação snapshot vs screenshot
        if (this.metrics.screenshotTime.length > this.metrics.snapshotTime.length) {
            recommendations.push('Consider using more accessibility snapshots instead of screenshots for better performance');
        }
        
        // Análise de navegação
        const navigationStats = this.calculateStats(this.metrics.navigationTime);
        if (navigationStats.avg > this.thresholds.navigationWarning) {
            recommendations.push(`Optimize page load performance or increase timeout (current avg: ${navigationStats.avg}ms)`);
        }
        
        // Análise de memória
        const memoryStats = this.calculateStats(this.metrics.memoryUsage);
        const totalMemoryMB = memoryStats.avg / 1024 / 1024;
        if (totalMemoryMB > 100) {
            recommendations.push(`High memory usage detected (${totalMemoryMB.toFixed(2)}MB avg), consider optimizing operations`);
        }
        
        return recommendations;
    }

    /**
     * Calcular performance geral
     */
    calculateOverallPerformance() {
        const snapshotEfficiency = this.calculateEfficiency('snapshot');
        const screenshotEfficiency = this.calculateEfficiency('screenshot');
        
        // Peso maior para snapshots (preferidos)
        const weightedScore = (snapshotEfficiency * 0.6) + (screenshotEfficiency * 0.4);
        
        return {
            score: Math.round(weightedScore),
            grade: this.getPerformanceGrade(weightedScore),
            snapshotEfficiency: Math.round(snapshotEfficiency),
            screenshotEfficiency: Math.round(screenshotEfficiency)
        };
    }

    /**
     * Obter grade de performance
     */
    getPerformanceGrade(score) {
        if (score >= 90) return 'A+';
        if (score >= 80) return 'A';
        if (score >= 70) return 'B';
        if (score >= 60) return 'C';
        if (score >= 50) return 'D';
        return 'F';
    }

    /**
     * Salvar relatório em arquivo
     */
    async saveReport(report) {
        try {
            // Criar diretório se não existir
            await fs.mkdir(this.reportPath, { recursive: true });
            
            // Nome do arquivo com timestamp
            const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
            const filename = `performance-report-${timestamp}.json`;
            const filepath = path.join(this.reportPath, filename);
            
            // Salvar relatório
            await fs.writeFile(filepath, JSON.stringify(report, null, 2), 'utf8');
            
            console.log(`💾 Performance report saved: ${filepath}`);
            return filepath;
        } catch (error) {
            console.error('❌ Failed to save performance report:', error.message);
            throw error;
        }
    }

    /**
     * Comparar com relatórios anteriores
     */
    async compareWithPrevious() {
        try {
            const files = await fs.readdir(this.reportPath);
            const reportFiles = files.filter(f => f.startsWith('performance-report-')).sort().reverse();
            
            if (reportFiles.length < 2) {
                console.log('ℹ️ No previous reports for comparison');
                return null;
            }
            
            const previousReportPath = path.join(this.reportPath, reportFiles[1]);
            const previousReport = JSON.parse(await fs.readFile(previousReportPath, 'utf8'));
            
            const currentReport = this.generateReport();
            
            const comparison = {
                snapshotImprovement: currentReport.metrics.snapshots.stats.avg - previousReport.metrics.snapshots.stats.avg,
                screenshotImprovement: currentReport.metrics.screenshots.stats.avg - previousReport.metrics.screenshots.stats.avg,
                performanceImprovement: currentReport.performance.score - previousReport.performance.score
            };
            
            console.log('\n📈 PERFORMANCE COMPARISON');
            console.log('=========================');
            console.log(`Snapshot Performance: ${comparison.snapshotImprovement > 0 ? '📉' : '📈'} ${Math.abs(comparison.snapshotImprovement)}ms`);
            console.log(`Screenshot Performance: ${comparison.screenshotImprovement > 0 ? '📉' : '📈'} ${Math.abs(comparison.screenshotImprovement)}ms`);
            console.log(`Overall Score: ${comparison.performanceImprovement > 0 ? '📈' : '📉'} ${Math.abs(comparison.performanceImprovement)} points`);
            
            return comparison;
        } catch (error) {
            console.error('❌ Failed to compare with previous reports:', error.message);
            return null;
        }
    }

    /**
     * Reset métricas para nova sessão
     */
    reset() {
        this.metrics = {
            snapshotTime: [],
            screenshotTime: [],
            navigationTime: [],
            actionTime: [],
            memoryUsage: [],
            networkRequests: []
        };
        this.startTime = Date.now();
        console.log('🔄 Performance monitor reset');
    }
}

module.exports = { PlaywrightPerformanceMonitor };

// Exemplo de uso
if (require.main === module) {
    const monitor = new PlaywrightPerformanceMonitor();
    
    // Simular medições
    async function simulateTest() {
        // Simular snapshot
        await monitor.measureSnapshot(async () => {
            await new Promise(resolve => setTimeout(resolve, 500));
            return { elements: [], accessibility: true };
        });
        
        // Simular screenshot
        await monitor.measureScreenshot(async () => {
            await new Promise(resolve => setTimeout(resolve, 2000));
            return { image: 'base64...', visual: true };
        });
        
        // Gerar relatório
        const report = monitor.generateReport();
        await monitor.saveReport(report);
        await monitor.compareWithPrevious();
    }
    
    simulateTest().catch(console.error);
}
