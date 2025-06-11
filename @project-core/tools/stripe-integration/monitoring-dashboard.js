/**
 * GRUPO US - Stripe Monitoring Dashboard
 * Dashboard completo para monitoramento de produção
 */

const StripeMCPManager = require('./stripe-mcp-manager');

class StripeMonitoringDashboard {
    constructor() {
        this.stripeManager = new StripeMCPManager();
        this.alerts = [];
        this.metrics = {
            payments: {
                successful: 0,
                failed: 0,
                pending: 0,
                totalVolume: 0
            },
            subscriptions: {
                active: 0,
                canceled: 0,
                pastDue: 0
            },
            webhooks: {
                received: 0,
                processed: 0,
                failed: 0
            },
            errors: {
                apiErrors: 0,
                webhookErrors: 0,
                systemErrors: 0
            }
        };
        this.thresholds = {
            failureRate: 0.05, // 5%
            responseTime: 2000, // 2s
            errorRate: 0.02, // 2%
            webhookFailureRate: 0.01 // 1%
        };
    }

    /**
     * Inicia monitoramento
     */
    async startMonitoring() {
        console.log('📊 INICIANDO MONITORAMENTO STRIPE - GRUPO US');
        
        await this.stripeManager.initialize();
        
        // Configurar coleta de métricas
        this.setupMetricsCollection();
        
        // Configurar alertas
        this.setupAlerts();
        
        // Iniciar dashboard
        this.startDashboard();
        
        console.log('✅ Monitoramento Stripe ativo');
    }

    /**
     * Configura coleta de métricas
     */
    setupMetricsCollection() {
        // Coletar métricas a cada 5 minutos
        setInterval(async () => {
            await this.collectMetrics();
        }, 5 * 60 * 1000);

        // Análise de alertas a cada minuto
        setInterval(async () => {
            await this.analyzeAlerts();
        }, 60 * 1000);
    }

    /**
     * Coleta métricas do Stripe
     */
    async collectMetrics() {
        try {
            console.log('📈 Coletando métricas...');
            
            // Simular coleta de métricas (em produção, usar Stripe API)
            const stripeMetrics = this.stripeManager.getMetrics();
            
            // Atualizar métricas locais
            this.updateMetrics(stripeMetrics);
            
            // Log das métricas principais
            this.logMetrics();
            
        } catch (error) {
            console.error('❌ Erro ao coletar métricas:', error.message);
            this.metrics.errors.systemErrors++;
        }
    }

    /**
     * Atualiza métricas
     */
    updateMetrics(stripeMetrics) {
        // Simular dados de produção
        this.metrics.payments.successful = stripeMetrics.successfulPayments || 0;
        this.metrics.payments.failed = stripeMetrics.failedPayments || 0;
        this.metrics.webhooks.processed = stripeMetrics.webhooksProcessed || 0;
        this.metrics.errors.apiErrors = stripeMetrics.errors || 0;
        
        // Calcular taxas
        const totalPayments = this.metrics.payments.successful + this.metrics.payments.failed;
        this.metrics.payments.failureRate = totalPayments > 0 ? 
            this.metrics.payments.failed / totalPayments : 0;
    }

    /**
     * Log das métricas
     */
    logMetrics() {
        console.log('\n📊 MÉTRICAS STRIPE - GRUPO US');
        console.log('=' .repeat(40));
        console.log(`💳 Payments Successful: ${this.metrics.payments.successful}`);
        console.log(`💸 Payments Failed: ${this.metrics.payments.failed}`);
        console.log(`📈 Failure Rate: ${(this.metrics.payments.failureRate * 100).toFixed(2)}%`);
        console.log(`🔔 Webhooks Processed: ${this.metrics.webhooks.processed}`);
        console.log(`❌ API Errors: ${this.metrics.errors.apiErrors}`);
        console.log('=' .repeat(40));
    }

    /**
     * Configura alertas
     */
    setupAlerts() {
        console.log('🚨 Configurando alertas...');
        
        // Configurar diferentes tipos de alertas
        this.alertConfigs = [
            {
                name: 'High Failure Rate',
                condition: () => this.metrics.payments.failureRate > this.thresholds.failureRate,
                severity: 'critical',
                message: 'Taxa de falha de pagamentos acima do limite'
            },
            {
                name: 'Webhook Failures',
                condition: () => this.metrics.webhooks.failed > 10,
                severity: 'warning',
                message: 'Muitas falhas de webhook detectadas'
            },
            {
                name: 'API Errors',
                condition: () => this.metrics.errors.apiErrors > 5,
                severity: 'warning',
                message: 'Muitos erros de API detectados'
            },
            {
                name: 'System Health',
                condition: () => !this.stripeManager.isInitialized,
                severity: 'critical',
                message: 'Sistema Stripe não está inicializado'
            }
        ];
    }

    /**
     * Analisa e dispara alertas
     */
    async analyzeAlerts() {
        for (const alertConfig of this.alertConfigs) {
            if (alertConfig.condition()) {
                await this.triggerAlert(alertConfig);
            }
        }
    }

    /**
     * Dispara alerta
     */
    async triggerAlert(alertConfig) {
        const alert = {
            id: `alert_${Date.now()}`,
            name: alertConfig.name,
            severity: alertConfig.severity,
            message: alertConfig.message,
            timestamp: new Date().toISOString(),
            metrics: { ...this.metrics }
        };

        this.alerts.push(alert);
        
        console.log(`🚨 ALERTA ${alertConfig.severity.toUpperCase()}: ${alertConfig.message}`);
        
        // Enviar notificação
        await this.sendAlert(alert);
        
        // Manter apenas últimos 100 alertas
        if (this.alerts.length > 100) {
            this.alerts = this.alerts.slice(-100);
        }
    }

    /**
     * Envia alerta
     */
    async sendAlert(alert) {
        try {
            // Implementar envio de alertas para:
            // - Email
            // - Slack
            // - SMS (para alertas críticos)
            // - Sistema de monitoramento GRUPO US
            
            console.log('📧 Enviando alerta:', alert.name);
            
            if (alert.severity === 'critical') {
                console.log('🚨 ALERTA CRÍTICO - Notificação urgente enviada');
                // Enviar SMS/chamada para equipe
            }
            
        } catch (error) {
            console.error('❌ Erro ao enviar alerta:', error.message);
        }
    }

    /**
     * Inicia dashboard web
     */
    startDashboard() {
        const express = require('express');
        const app = express();
        
        app.use(express.json());
        
        // Endpoint de métricas
        app.get('/api/monitoring/metrics', (req, res) => {
            res.json({
                metrics: this.metrics,
                alerts: this.alerts.slice(-10), // Últimos 10 alertas
                health: this.stripeManager.getHealthStatus(),
                timestamp: new Date().toISOString()
            });
        });
        
        // Endpoint de alertas
        app.get('/api/monitoring/alerts', (req, res) => {
            res.json({
                alerts: this.alerts,
                activeAlerts: this.alerts.filter(a => 
                    new Date() - new Date(a.timestamp) < 24 * 60 * 60 * 1000 // Últimas 24h
                )
            });
        });
        
        // Dashboard HTML simples
        app.get('/dashboard', (req, res) => {
            res.send(this.generateDashboardHTML());
        });
        
        const port = process.env.MONITORING_PORT || 3001;
        app.listen(port, () => {
            console.log(`📊 Dashboard de monitoramento: http://localhost:${port}/dashboard`);
        });
    }

    /**
     * Gera HTML do dashboard
     */
    generateDashboardHTML() {
        return `
        <!DOCTYPE html>
        <html>
        <head>
            <title>GRUPO US - Stripe Monitoring</title>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
                .container { max-width: 1200px; margin: 0 auto; }
                .card { background: white; padding: 20px; margin: 10px 0; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
                .metric { display: inline-block; margin: 10px; padding: 15px; background: #f8f9fa; border-radius: 4px; }
                .alert-critical { background: #ffebee; border-left: 4px solid #f44336; }
                .alert-warning { background: #fff3e0; border-left: 4px solid #ff9800; }
                .status-healthy { color: #4caf50; }
                .status-error { color: #f44336; }
                h1 { color: #333; }
                h2 { color: #666; }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>🚀 GRUPO US - Stripe Monitoring Dashboard</h1>
                
                <div class="card">
                    <h2>📊 Métricas em Tempo Real</h2>
                    <div class="metric">
                        <strong>Payments Successful:</strong> ${this.metrics.payments.successful}
                    </div>
                    <div class="metric">
                        <strong>Payments Failed:</strong> ${this.metrics.payments.failed}
                    </div>
                    <div class="metric">
                        <strong>Failure Rate:</strong> ${(this.metrics.payments.failureRate * 100).toFixed(2)}%
                    </div>
                    <div class="metric">
                        <strong>Webhooks Processed:</strong> ${this.metrics.webhooks.processed}
                    </div>
                </div>
                
                <div class="card">
                    <h2>🚨 Alertas Recentes</h2>
                    ${this.alerts.slice(-5).map(alert => `
                        <div class="alert-${alert.severity}">
                            <strong>${alert.name}</strong> - ${alert.message}
                            <br><small>${alert.timestamp}</small>
                        </div>
                    `).join('')}
                </div>
                
                <div class="card">
                    <h2>🏥 Status do Sistema</h2>
                    <div class="status-${this.stripeManager.isInitialized ? 'healthy' : 'error'}">
                        Stripe MCP: ${this.stripeManager.isInitialized ? 'Healthy' : 'Error'}
                    </div>
                </div>
            </div>
            
            <script>
                // Auto-refresh a cada 30 segundos
                setTimeout(() => location.reload(), 30000);
            </script>
        </body>
        </html>
        `;
    }

    /**
     * Obtém relatório de monitoramento
     */
    getMonitoringReport() {
        return {
            metrics: this.metrics,
            alerts: this.alerts,
            health: this.stripeManager.getHealthStatus(),
            thresholds: this.thresholds,
            uptime: process.uptime(),
            timestamp: new Date().toISOString()
        };
    }
}

// Executar se chamado diretamente
if (require.main === module) {
    const monitor = new StripeMonitoringDashboard();
    monitor.startMonitoring();
}

module.exports = StripeMonitoringDashboard;
