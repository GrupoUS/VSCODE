/**
 * GRUPO US - Stripe Webhook Handler para Produção
 * Handler completo para processar webhooks Stripe
 */

const express = require('express');
const StripeMCPManager = require('./stripe-mcp-manager');

class StripeWebhookHandler {
    constructor() {
        this.stripeManager = new StripeMCPManager();
        this.app = express();
        this.setupMiddleware();
        this.setupRoutes();
        this.metrics = {
            webhooksReceived: 0,
            webhooksProcessed: 0,
            webhooksFailed: 0,
            lastWebhook: null
        };
    }

    /**
     * Configura middleware
     */
    setupMiddleware() {
        // Raw body parser para webhooks Stripe
        this.app.use('/api/stripe/webhook', express.raw({ type: 'application/json' }));
        this.app.use(express.json());
    }

    /**
     * Configura rotas
     */
    setupRoutes() {
        // Endpoint principal do webhook
        this.app.post('/api/stripe/webhook', this.handleWebhook.bind(this));
        
        // Health check
        this.app.get('/api/stripe/health', this.healthCheck.bind(this));
        
        // Métricas
        this.app.get('/api/stripe/metrics', this.getMetrics.bind(this));
    }

    /**
     * Handler principal do webhook
     */
    async handleWebhook(req, res) {
        const sig = req.headers['stripe-signature'];
        const payload = req.body;

        try {
            this.metrics.webhooksReceived++;
            console.log('🔔 Webhook recebido:', req.headers['stripe-signature']?.substring(0, 20) + '...');

            // Processar webhook via Stripe MCP Manager
            const result = await this.stripeManager.processWebhook(payload, sig);
            
            // Log do evento processado
            console.log(`✅ Webhook processado: ${result.event.type} - ${result.event.id}`);
            
            // Processar evento específico
            await this.processSpecificEvent(result.event);
            
            this.metrics.webhooksProcessed++;
            this.metrics.lastWebhook = {
                type: result.event.type,
                id: result.event.id,
                timestamp: new Date().toISOString()
            };

            res.status(200).json({ received: true, eventId: result.event.id });
        } catch (error) {
            this.metrics.webhooksFailed++;
            console.error('❌ Erro ao processar webhook:', error.message);
            
            // Log detalhado para debugging
            console.error('Webhook Error Details:', {
                signature: sig?.substring(0, 20) + '...',
                payloadLength: payload?.length,
                error: error.message
            });

            res.status(400).json({ 
                error: 'Webhook processing failed',
                message: error.message 
            });
        }
    }

    /**
     * Processa eventos específicos
     */
    async processSpecificEvent(event) {
        switch (event.type) {
            case 'payment_intent.succeeded':
                await this.handlePaymentSuccess(event.data.object);
                break;
                
            case 'payment_intent.payment_failed':
                await this.handlePaymentFailure(event.data.object);
                break;
                
            case 'customer.subscription.created':
                await this.handleSubscriptionCreated(event.data.object);
                break;
                
            case 'customer.subscription.updated':
                await this.handleSubscriptionUpdated(event.data.object);
                break;
                
            case 'customer.subscription.deleted':
                await this.handleSubscriptionCanceled(event.data.object);
                break;
                
            case 'invoice.payment_succeeded':
                await this.handleInvoicePaymentSuccess(event.data.object);
                break;
                
            case 'invoice.payment_failed':
                await this.handleInvoicePaymentFailure(event.data.object);
                break;
                
            case 'charge.dispute.created':
                await this.handleDisputeCreated(event.data.object);
                break;
                
            default:
                console.log(`ℹ️ Evento não tratado especificamente: ${event.type}`);
        }
    }

    /**
     * Handlers para eventos específicos
     */
    async handlePaymentSuccess(paymentIntent) {
        console.log(`💰 Payment bem-sucedido: ${paymentIntent.id}`);
        
        // Notificar sistema GRUPO US
        await this.notifyGrupoUSSystem('payment_success', {
            paymentId: paymentIntent.id,
            amount: paymentIntent.amount,
            currency: paymentIntent.currency,
            customerId: paymentIntent.customer
        });
    }

    async handlePaymentFailure(paymentIntent) {
        console.log(`💸 Payment falhou: ${paymentIntent.id}`);
        
        // Notificar sistema GRUPO US
        await this.notifyGrupoUSSystem('payment_failure', {
            paymentId: paymentIntent.id,
            amount: paymentIntent.amount,
            currency: paymentIntent.currency,
            customerId: paymentIntent.customer,
            lastPaymentError: paymentIntent.last_payment_error
        });
    }

    async handleSubscriptionCreated(subscription) {
        console.log(`📅 Subscription criada: ${subscription.id}`);
        
        await this.notifyGrupoUSSystem('subscription_created', {
            subscriptionId: subscription.id,
            customerId: subscription.customer,
            status: subscription.status,
            items: subscription.items.data
        });
    }

    async handleSubscriptionUpdated(subscription) {
        console.log(`🔄 Subscription atualizada: ${subscription.id}`);
        
        await this.notifyGrupoUSSystem('subscription_updated', {
            subscriptionId: subscription.id,
            customerId: subscription.customer,
            status: subscription.status,
            previousAttributes: subscription.previous_attributes
        });
    }

    async handleSubscriptionCanceled(subscription) {
        console.log(`❌ Subscription cancelada: ${subscription.id}`);
        
        await this.notifyGrupoUSSystem('subscription_canceled', {
            subscriptionId: subscription.id,
            customerId: subscription.customer,
            canceledAt: subscription.canceled_at,
            cancelationReason: subscription.cancellation_details?.reason
        });
    }

    async handleInvoicePaymentSuccess(invoice) {
        console.log(`📄 Invoice paga: ${invoice.id}`);
        
        await this.notifyGrupoUSSystem('invoice_paid', {
            invoiceId: invoice.id,
            customerId: invoice.customer,
            amount: invoice.amount_paid,
            subscriptionId: invoice.subscription
        });
    }

    async handleInvoicePaymentFailure(invoice) {
        console.log(`📄 Invoice não paga: ${invoice.id}`);
        
        await this.notifyGrupoUSSystem('invoice_payment_failed', {
            invoiceId: invoice.id,
            customerId: invoice.customer,
            amount: invoice.amount_due,
            subscriptionId: invoice.subscription,
            attemptCount: invoice.attempt_count
        });
    }

    async handleDisputeCreated(dispute) {
        console.log(`⚠️ Disputa criada: ${dispute.id}`);
        
        // Alerta crítico para disputas
        await this.notifyGrupoUSSystem('dispute_created', {
            disputeId: dispute.id,
            chargeId: dispute.charge,
            amount: dispute.amount,
            reason: dispute.reason,
            status: dispute.status
        }, 'critical');
    }

    /**
     * Notifica sistema GRUPO US
     */
    async notifyGrupoUSSystem(eventType, data, priority = 'normal') {
        try {
            // Implementar notificação para sistema GRUPO US
            console.log(`📢 Notificando GRUPO US: ${eventType}`, data);
            
            // Aqui você integraria com:
            // - Sistema de notificações GRUPO US
            // - TaskMaster para criar tasks automáticas
            // - Sistema de alertas para eventos críticos
            
            if (priority === 'critical') {
                console.log('🚨 ALERTA CRÍTICO - Ação imediata necessária');
                // Enviar notificação urgente
            }
        } catch (error) {
            console.error('❌ Erro ao notificar sistema GRUPO US:', error.message);
        }
    }

    /**
     * Health check endpoint
     */
    async healthCheck(req, res) {
        const health = {
            status: 'healthy',
            timestamp: new Date().toISOString(),
            stripe: await this.stripeManager.getHealthStatus(),
            metrics: this.metrics,
            uptime: process.uptime()
        };
        
        res.json(health);
    }

    /**
     * Endpoint de métricas
     */
    async getMetrics(req, res) {
        const metrics = {
            webhook: this.metrics,
            stripe: this.stripeManager.getMetrics(),
            system: {
                uptime: process.uptime(),
                memory: process.memoryUsage(),
                timestamp: new Date().toISOString()
            }
        };
        
        res.json(metrics);
    }

    /**
     * Inicia o servidor webhook
     */
    async start(port = 3000) {
        await this.stripeManager.initialize();
        
        this.app.listen(port, () => {
            console.log(`🔔 Stripe Webhook Handler rodando na porta ${port}`);
            console.log(`📡 Endpoint: http://localhost:${port}/api/stripe/webhook`);
            console.log(`🏥 Health: http://localhost:${port}/api/stripe/health`);
            console.log(`📊 Metrics: http://localhost:${port}/api/stripe/metrics`);
        });
    }
}

// Executar se chamado diretamente
if (require.main === module) {
    const handler = new StripeWebhookHandler();
    handler.start(process.env.PORT || 3000);
}

module.exports = StripeWebhookHandler;
