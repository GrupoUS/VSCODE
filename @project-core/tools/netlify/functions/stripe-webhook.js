/**
 * GRUPO US - Netlify Function para Stripe Webhook
 * Adaptação do webhook handler para Netlify Functions
 */

const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

exports.handler = async (event, context) => {
    // Apenas aceitar POST requests
    if (event.httpMethod !== 'POST') {
        return {
            statusCode: 405,
            body: JSON.stringify({ error: 'Method not allowed' })
        };
    }

    const sig = event.headers['stripe-signature'];
    const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET;

    let stripeEvent;

    try {
        // Verificar assinatura do webhook
        stripeEvent = stripe.webhooks.constructEvent(
            event.body,
            sig,
            webhookSecret
        );
    } catch (err) {
        console.error('❌ Webhook signature verification failed:', err.message);
        return {
            statusCode: 400,
            body: JSON.stringify({ error: 'Webhook signature verification failed' })
        };
    }

    console.log('🔔 Webhook recebido:', stripeEvent.type);

    try {
        // Processar diferentes tipos de eventos
        switch (stripeEvent.type) {
            case 'payment_intent.succeeded':
                await handlePaymentSuccess(stripeEvent.data.object);
                break;
                
            case 'payment_intent.payment_failed':
                await handlePaymentFailure(stripeEvent.data.object);
                break;
                
            case 'customer.subscription.created':
                await handleSubscriptionCreated(stripeEvent.data.object);
                break;
                
            case 'customer.subscription.updated':
                await handleSubscriptionUpdated(stripeEvent.data.object);
                break;
                
            case 'customer.subscription.deleted':
                await handleSubscriptionCanceled(stripeEvent.data.object);
                break;
                
            case 'invoice.payment_succeeded':
                await handleInvoicePaymentSuccess(stripeEvent.data.object);
                break;
                
            case 'invoice.payment_failed':
                await handleInvoicePaymentFailure(stripeEvent.data.object);
                break;
                
            default:
                console.log(`ℹ️ Evento não tratado: ${stripeEvent.type}`);
        }

        return {
            statusCode: 200,
            body: JSON.stringify({ 
                received: true, 
                eventId: stripeEvent.id,
                type: stripeEvent.type 
            })
        };

    } catch (error) {
        console.error('❌ Erro ao processar webhook:', error.message);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Webhook processing failed' })
        };
    }
};

/**
 * Handlers para eventos específicos
 */
async function handlePaymentSuccess(paymentIntent) {
    console.log(`💰 Payment bem-sucedido: ${paymentIntent.id}`);
    
    // Aqui você pode:
    // 1. Atualizar banco de dados do usuário
    // 2. Enviar email de confirmação
    // 3. Ativar funcionalidades premium
    // 4. Integrar com seu sistema de usuários
    
    // Exemplo de integração com seu SaaS:
    try {
        // Buscar customer no Stripe para obter dados do usuário
        const customer = await stripe.customers.retrieve(paymentIntent.customer);
        
        // Aqui você integraria com seu sistema de usuários
        console.log(`✅ Pagamento processado para: ${customer.email}`);
        
        // Exemplo: Ativar plano premium
        // await ativarPlanoUsuario(customer.email, 'premium');
        
    } catch (error) {
        console.error('❌ Erro ao processar pagamento bem-sucedido:', error.message);
    }
}

async function handlePaymentFailure(paymentIntent) {
    console.log(`💸 Payment falhou: ${paymentIntent.id}`);
    
    try {
        const customer = await stripe.customers.retrieve(paymentIntent.customer);
        console.log(`❌ Falha no pagamento para: ${customer.email}`);
        
        // Aqui você pode:
        // 1. Enviar email de falha no pagamento
        // 2. Suspender funcionalidades premium
        // 3. Oferecer métodos alternativos de pagamento
        
    } catch (error) {
        console.error('❌ Erro ao processar falha de pagamento:', error.message);
    }
}

async function handleSubscriptionCreated(subscription) {
    console.log(`📅 Subscription criada: ${subscription.id}`);
    
    try {
        const customer = await stripe.customers.retrieve(subscription.customer);
        console.log(`✅ Nova subscription para: ${customer.email}`);
        
        // Ativar acesso completo ao SaaS
        // await ativarSubscricaoUsuario(customer.email, subscription.id);
        
    } catch (error) {
        console.error('❌ Erro ao processar nova subscription:', error.message);
    }
}

async function handleSubscriptionUpdated(subscription) {
    console.log(`🔄 Subscription atualizada: ${subscription.id}`);
    
    try {
        const customer = await stripe.customers.retrieve(subscription.customer);
        console.log(`🔄 Subscription atualizada para: ${customer.email}`);
        
        // Atualizar nível de acesso baseado no novo plano
        // await atualizarPlanoUsuario(customer.email, subscription);
        
    } catch (error) {
        console.error('❌ Erro ao processar atualização de subscription:', error.message);
    }
}

async function handleSubscriptionCanceled(subscription) {
    console.log(`❌ Subscription cancelada: ${subscription.id}`);
    
    try {
        const customer = await stripe.customers.retrieve(subscription.customer);
        console.log(`❌ Subscription cancelada para: ${customer.email}`);
        
        // Suspender acesso premium (manter acesso até fim do período pago)
        // await suspenderSubscricaoUsuario(customer.email, subscription.current_period_end);
        
    } catch (error) {
        console.error('❌ Erro ao processar cancelamento de subscription:', error.message);
    }
}

async function handleInvoicePaymentSuccess(invoice) {
    console.log(`📄 Invoice paga: ${invoice.id}`);
    
    try {
        const customer = await stripe.customers.retrieve(invoice.customer);
        console.log(`✅ Invoice paga por: ${customer.email}`);
        
        // Renovar acesso por mais um período
        // await renovarAcessoUsuario(customer.email, invoice.subscription);
        
    } catch (error) {
        console.error('❌ Erro ao processar pagamento de invoice:', error.message);
    }
}

async function handleInvoicePaymentFailure(invoice) {
    console.log(`📄 Invoice não paga: ${invoice.id}`);
    
    try {
        const customer = await stripe.customers.retrieve(invoice.customer);
        console.log(`❌ Falha no pagamento de invoice para: ${customer.email}`);
        
        // Enviar notificação de falha no pagamento
        // Dar prazo para regularização antes de suspender
        // await notificarFalhaCobranca(customer.email, invoice);
        
    } catch (error) {
        console.error('❌ Erro ao processar falha de invoice:', error.message);
    }
}
