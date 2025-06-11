/**
 * GRUPO US - Stripe Production Security Validator
 * Valida configurações de segurança para produção
 */

class StripeProductionSecurityValidator {
    constructor() {
        this.securityChecks = [];
        this.warnings = [];
        this.errors = [];
    }

    /**
     * Executa todas as validações de segurança
     */
    async validateProductionSecurity() {
        console.log('🔒 VALIDANDO SEGURANÇA STRIPE PRODUÇÃO - GRUPO US');
        console.log('=' .repeat(60));

        // Validações de API Keys
        this.validateApiKeys();
        
        // Validações de Environment
        this.validateEnvironment();
        
        // Validações de Configuração
        this.validateConfiguration();
        
        // Validações de Webhook
        this.validateWebhookSecurity();

        this.generateSecurityReport();
        return this.getValidationResult();
    }

    /**
     * Valida API Keys de produção
     */
    validateApiKeys() {
        console.log('\n🔑 Validando API Keys...');

        // Verificar se keys estão configuradas
        const secretKey = process.env.STRIPE_SECRET_KEY;
        const publishableKey = process.env.STRIPE_PUBLISHABLE_KEY;
        const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET;

        if (!secretKey) {
            this.errors.push('STRIPE_SECRET_KEY não configurada');
        } else if (secretKey.startsWith('sk_test_')) {
            this.errors.push('STRIPE_SECRET_KEY ainda está em modo test');
        } else if (secretKey.startsWith('sk_live_')) {
            this.securityChecks.push('✅ Secret Key de produção configurada');
        }

        if (!publishableKey) {
            this.warnings.push('STRIPE_PUBLISHABLE_KEY não configurada');
        } else if (publishableKey.startsWith('pk_test_')) {
            this.warnings.push('STRIPE_PUBLISHABLE_KEY ainda está em modo test');
        } else if (publishableKey.startsWith('pk_live_')) {
            this.securityChecks.push('✅ Publishable Key de produção configurada');
        }

        if (!webhookSecret) {
            this.errors.push('STRIPE_WEBHOOK_SECRET não configurada');
        } else if (webhookSecret.startsWith('whsec_')) {
            this.securityChecks.push('✅ Webhook Secret configurada');
        }

        // Verificar se keys não são placeholders
        if (secretKey && secretKey.includes('your_')) {
            this.errors.push('Secret Key ainda é placeholder');
        }
    }

    /**
     * Valida configurações de ambiente
     */
    validateEnvironment() {
        console.log('\n🌍 Validando Environment...');

        const environment = process.env.STRIPE_ENVIRONMENT;
        const nodeEnv = process.env.NODE_ENV;
        const debug = process.env.STRIPE_DEBUG;
        const logLevel = process.env.STRIPE_LOG_LEVEL;

        if (environment !== 'live') {
            this.errors.push('STRIPE_ENVIRONMENT deve ser "live" para produção');
        } else {
            this.securityChecks.push('✅ Environment configurado para produção');
        }

        if (nodeEnv !== 'production') {
            this.warnings.push('NODE_ENV não está configurado como "production"');
        } else {
            this.securityChecks.push('✅ NODE_ENV configurado para produção');
        }

        if (debug === 'true') {
            this.warnings.push('STRIPE_DEBUG está habilitado em produção');
        } else {
            this.securityChecks.push('✅ Debug desabilitado para produção');
        }

        if (logLevel === 'debug' || logLevel === 'info') {
            this.warnings.push('Log level muito verboso para produção');
        }
    }

    /**
     * Valida configurações gerais
     */
    validateConfiguration() {
        console.log('\n⚙️ Validando Configuração...');

        const secureMode = process.env.STRIPE_SECURE_MODE;
        const rateLimit = process.env.STRIPE_RATE_LIMIT;
        const timeout = process.env.STRIPE_TIMEOUT;

        if (secureMode !== 'true') {
            this.warnings.push('STRIPE_SECURE_MODE não está habilitado');
        } else {
            this.securityChecks.push('✅ Secure mode habilitado');
        }

        if (!rateLimit || parseInt(rateLimit) > 1000) {
            this.warnings.push('Rate limit muito alto ou não configurado');
        } else {
            this.securityChecks.push('✅ Rate limit configurado adequadamente');
        }

        if (!timeout || parseInt(timeout) > 60000) {
            this.warnings.push('Timeout muito alto ou não configurado');
        } else {
            this.securityChecks.push('✅ Timeout configurado adequadamente');
        }
    }

    /**
     * Valida segurança de webhooks
     */
    validateWebhookSecurity() {
        console.log('\n🔔 Validando Webhook Security...');

        const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET;
        const webhookTolerance = process.env.STRIPE_WEBHOOK_TOLERANCE;

        if (webhookSecret && webhookSecret.length < 32) {
            this.warnings.push('Webhook secret parece muito curto');
        }

        if (!webhookTolerance || parseInt(webhookTolerance) > 600) {
            this.warnings.push('Webhook tolerance muito alto');
        } else {
            this.securityChecks.push('✅ Webhook tolerance configurado');
        }
    }

    /**
     * Gera relatório de segurança
     */
    generateSecurityReport() {
        console.log('\n' + '=' .repeat(60));
        console.log('📊 RELATÓRIO DE SEGURANÇA STRIPE PRODUÇÃO');
        console.log('=' .repeat(60));

        console.log('\n✅ VERIFICAÇÕES APROVADAS:');
        this.securityChecks.forEach(check => console.log(`  ${check}`));

        if (this.warnings.length > 0) {
            console.log('\n⚠️ AVISOS:');
            this.warnings.forEach(warning => console.log(`  ⚠️ ${warning}`));
        }

        if (this.errors.length > 0) {
            console.log('\n❌ ERROS CRÍTICOS:');
            this.errors.forEach(error => console.log(`  ❌ ${error}`));
        }

        console.log('\n📈 RESUMO:');
        console.log(`  ✅ Aprovadas: ${this.securityChecks.length}`);
        console.log(`  ⚠️ Avisos: ${this.warnings.length}`);
        console.log(`  ❌ Erros: ${this.errors.length}`);

        if (this.errors.length === 0) {
            console.log('\n🎉 CONFIGURAÇÃO SEGURA PARA PRODUÇÃO!');
        } else {
            console.log('\n🚨 CORRIJA OS ERROS ANTES DE USAR EM PRODUÇÃO!');
        }
    }

    /**
     * Retorna resultado da validação
     */
    getValidationResult() {
        return {
            isProductionReady: this.errors.length === 0,
            securityScore: this.securityChecks.length,
            totalChecks: this.securityChecks.length + this.warnings.length + this.errors.length,
            checks: this.securityChecks,
            warnings: this.warnings,
            errors: this.errors,
            timestamp: new Date().toISOString()
        };
    }
}

// Executar validação se chamado diretamente
if (require.main === module) {
    (async () => {
        const validator = new StripeProductionSecurityValidator();
        const result = await validator.validateProductionSecurity();
        
        // Exit com código apropriado
        process.exit(result.isProductionReady ? 0 : 1);
    })();
}

module.exports = StripeProductionSecurityValidator;
