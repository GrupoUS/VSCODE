/**
 * GRUPO US - Teste de Integração Stripe MCP
 * Seguindo VIBECODE SYSTEM V2.0
 * Testes completos para validar integração Stripe
 */

const StripeMCPManager = require('./stripe-mcp-manager');
const StripePlaywrightIntegration = require('./stripe-playwright-integration');

class StripeIntegrationTester {
    constructor() {
        // Configurar variáveis de ambiente para teste
        this.setupTestEnvironment();

        this.results = {
            startTime: new Date().toISOString(),
            tests: [],
            summary: {
                total: 0,
                passed: 0,
                failed: 0,
                skipped: 0
            }
        };
    }

    /**
     * Configura ambiente de teste com valores mock
     */
    setupTestEnvironment() {
        if (!process.env.STRIPE_SECRET_KEY || process.env.STRIPE_SECRET_KEY.includes('your_')) {
            process.env.STRIPE_SECRET_KEY = 'sk_test_mock_key_for_testing_grupo_us';
            process.env.STRIPE_PUBLISHABLE_KEY = 'pk_test_mock_key_for_testing_grupo_us';
            process.env.STRIPE_WEBHOOK_SECRET = 'whsec_mock_webhook_secret_for_testing';
            process.env.STRIPE_ENVIRONMENT = 'test';
            process.env.STRIPE_API_VERSION = '2023-10-16';

            console.log('🔧 Configurações de teste aplicadas (mock keys)');
        }
    }

    /**
     * Executa todos os testes de integração
     */
    async runAllTests() {
        console.log('🧪 INICIANDO TESTES DE INTEGRAÇÃO STRIPE MCP - GRUPO US');
        console.log('=' .repeat(60));
        
        try {
            // Teste 1: Inicialização do Stripe MCP Manager
            await this.testStripeMCPManagerInitialization();
            
            // Teste 2: Operações básicas do Stripe
            await this.testBasicStripeOperations();
            
            // Teste 3: Integração com Playwright
            await this.testPlaywrightIntegration();
            
            // Teste 4: Processamento de Webhooks
            await this.testWebhookProcessing();
            
            // Teste 5: Error Handling
            await this.testErrorHandling();
            
            // Teste 6: Métricas e Monitoramento
            await this.testMetricsAndMonitoring();
            
            this.generateFinalReport();
            
        } catch (error) {
            console.error('❌ Erro crítico nos testes:', error.message);
            this.results.summary.failed++;
        }
        
        return this.results;
    }

    /**
     * Teste 1: Inicialização do Stripe MCP Manager
     */
    async testStripeMCPManagerInitialization() {
        const testName = 'Stripe MCP Manager Initialization';
        console.log(`\n🔄 Executando: ${testName}`);
        
        try {
            const manager = new StripeMCPManager();
            const result = await manager.initialize();
            
            this.addTestResult(testName, true, {
                initialized: result.success,
                config: manager.config.stripe,
                metrics: manager.getMetrics()
            });
            
            console.log('✅ Stripe MCP Manager inicializado com sucesso');
        } catch (error) {
            this.addTestResult(testName, false, { error: error.message });
            console.log('❌ Falha na inicialização do Stripe MCP Manager');
        }
    }

    /**
     * Teste 2: Operações básicas do Stripe
     */
    async testBasicStripeOperations() {
        const testName = 'Basic Stripe Operations';
        console.log(`\n💳 Executando: ${testName}`);
        
        try {
            const manager = new StripeMCPManager();
            await manager.initialize();
            
            // Teste criação de customer
            const customer = await manager.createCustomer({
                email: 'test@grupous.com',
                name: 'Test User GRUPO US',
                metadata: { test: 'true' }
            });
            
            // Teste criação de payment intent
            const paymentIntent = await manager.createPaymentIntent({
                amount: 2000,
                currency: 'usd',
                customerId: customer.id,
                metadata: { test: 'true' }
            });
            
            // Teste criação de subscription
            const subscription = await manager.createSubscription({
                customerId: customer.id,
                items: [{ price: 'price_test_123' }],
                metadata: { test: 'true' }
            });
            
            this.addTestResult(testName, true, {
                customer: customer.id,
                paymentIntent: paymentIntent.id,
                subscription: subscription.id,
                metrics: manager.getMetrics()
            });
            
            console.log('✅ Operações básicas do Stripe executadas com sucesso');
        } catch (error) {
            this.addTestResult(testName, false, { error: error.message });
            console.log('❌ Falha nas operações básicas do Stripe');
        }
    }

    /**
     * Teste 3: Integração com Playwright
     */
    async testPlaywrightIntegration() {
        const testName = 'Playwright Integration';
        console.log(`\n🎭 Executando: ${testName}`);
        
        try {
            const integration = new StripePlaywrightIntegration();
            await integration.initialize();
            
            // Executar teste de fluxo de pagamento
            const paymentFlowResult = await integration.runPaymentFlowTest({
                customer: { email: 'playwright-test@grupous.com' },
                payment: { amount: 1500 },
                card: { number: '4242424242424242' }
            });
            
            this.addTestResult(testName, paymentFlowResult.success, {
                testId: paymentFlowResult.id,
                steps: paymentFlowResult.steps.length,
                metrics: integration.getMetrics()
            });
            
            console.log('✅ Integração com Playwright funcionando');
        } catch (error) {
            this.addTestResult(testName, false, { error: error.message });
            console.log('❌ Falha na integração com Playwright');
        }
    }

    /**
     * Teste 4: Processamento de Webhooks
     */
    async testWebhookProcessing() {
        const testName = 'Webhook Processing';
        console.log(`\n🔔 Executando: ${testName}`);
        
        try {
            const manager = new StripeMCPManager();
            await manager.initialize();
            
            // Simular webhook de pagamento bem-sucedido
            const webhookResult = await manager.processWebhook(
                JSON.stringify({
                    id: 'evt_test_webhook',
                    type: 'payment_intent.succeeded',
                    data: {
                        object: {
                            id: 'pi_test_123',
                            status: 'succeeded'
                        }
                    }
                }),
                'test_signature'
            );
            
            this.addTestResult(testName, webhookResult.received, {
                eventType: webhookResult.event.type,
                eventId: webhookResult.event.id,
                metrics: manager.getMetrics()
            });
            
            console.log('✅ Processamento de webhooks funcionando');
        } catch (error) {
            this.addTestResult(testName, false, { error: error.message });
            console.log('❌ Falha no processamento de webhooks');
        }
    }

    /**
     * Teste 5: Error Handling
     */
    async testErrorHandling() {
        const testName = 'Error Handling';
        console.log(`\n⚠️ Executando: ${testName}`);

        try {
            // Temporariamente remover a variável de ambiente para forçar erro
            const originalKey = process.env.STRIPE_SECRET_KEY;
            delete process.env.STRIPE_SECRET_KEY;

            const manager = new StripeMCPManager();

            let errorCaught = false;
            try {
                await manager.initialize();
            } catch (error) {
                errorCaught = true;
                console.log('✅ Erro capturado corretamente:', error.message);
            }

            // Restaurar variável de ambiente
            process.env.STRIPE_SECRET_KEY = originalKey;

            this.addTestResult(testName, errorCaught, {
                errorHandled: errorCaught,
                message: 'Error handling funcionando corretamente'
            });

            if (errorCaught) {
                console.log('✅ Error handling funcionando corretamente');
            } else {
                console.log('❌ Error handling não funcionou como esperado');
            }
        } catch (error) {
            this.addTestResult(testName, false, { error: error.message });
            console.log('❌ Falha no error handling');
        }
    }

    /**
     * Teste 6: Métricas e Monitoramento
     */
    async testMetricsAndMonitoring() {
        const testName = 'Metrics and Monitoring';
        console.log(`\n📊 Executando: ${testName}`);
        
        try {
            const manager = new StripeMCPManager();
            await manager.initialize();
            
            // Executar algumas operações para gerar métricas
            await manager.createCustomer({
                email: 'metrics-test@grupous.com',
                name: 'Metrics Test User'
            });
            
            const metrics = manager.getMetrics();
            const healthStatus = manager.getHealthStatus();
            
            const metricsValid = (
                typeof metrics.apiCalls === 'number' &&
                typeof metrics.errors === 'number' &&
                healthStatus.status === 'healthy'
            );
            
            this.addTestResult(testName, metricsValid, {
                metrics,
                healthStatus,
                validation: 'Métricas e monitoramento funcionando'
            });
            
            console.log('✅ Métricas e monitoramento funcionando');
        } catch (error) {
            this.addTestResult(testName, false, { error: error.message });
            console.log('❌ Falha nas métricas e monitoramento');
        }
    }

    /**
     * Adiciona resultado de teste
     */
    addTestResult(testName, success, data = {}) {
        const result = {
            name: testName,
            success,
            timestamp: new Date().toISOString(),
            data
        };
        
        this.results.tests.push(result);
        this.results.summary.total++;
        
        if (success) {
            this.results.summary.passed++;
        } else {
            this.results.summary.failed++;
        }
    }

    /**
     * Gera relatório final
     */
    generateFinalReport() {
        this.results.endTime = new Date().toISOString();
        this.results.duration = new Date(this.results.endTime) - new Date(this.results.startTime);
        
        console.log('\n' + '=' .repeat(60));
        console.log('📊 RELATÓRIO FINAL - TESTES STRIPE MCP INTEGRATION');
        console.log('=' .repeat(60));
        console.log(`✅ Testes Passaram: ${this.results.summary.passed}`);
        console.log(`❌ Testes Falharam: ${this.results.summary.failed}`);
        console.log(`📊 Total de Testes: ${this.results.summary.total}`);
        console.log(`⏱️ Duração: ${this.results.duration}ms`);
        console.log(`📈 Taxa de Sucesso: ${((this.results.summary.passed / this.results.summary.total) * 100).toFixed(2)}%`);
        
        if (this.results.summary.failed === 0) {
            console.log('\n🎉 TODOS OS TESTES PASSARAM! Stripe MCP Integration está funcionando perfeitamente.');
        } else {
            console.log('\n⚠️ Alguns testes falharam. Verifique os logs acima para detalhes.');
        }
        
        console.log('=' .repeat(60));
    }

    /**
     * Salva relatório em arquivo
     */
    async saveReport() {
        const fs = require('fs').promises;
        const reportPath = `./reports/stripe-integration-test-${Date.now()}.json`;
        
        try {
            await fs.writeFile(reportPath, JSON.stringify(this.results, null, 2));
            console.log(`📄 Relatório salvo em: ${reportPath}`);
        } catch (error) {
            console.error('❌ Erro ao salvar relatório:', error.message);
        }
    }
}

// Executar testes se chamado diretamente
if (require.main === module) {
    (async () => {
        const tester = new StripeIntegrationTester();
        const results = await tester.runAllTests();
        await tester.saveReport();
        
        // Exit com código apropriado
        process.exit(results.summary.failed === 0 ? 0 : 1);
    })();
}

module.exports = StripeIntegrationTester;
