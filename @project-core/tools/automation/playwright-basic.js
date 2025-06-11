/**
 * GRUPO US - Playwright Basic Automation Scripts
 * Seguindo VIBECODE SYSTEM V2.0
 */

const { chromium, firefox, webkit } = require('playwright');
require('dotenv').config({ path: '.env.playwright' });

class PlaywrightAutomation {
    constructor(options = {}) {
        this.browser = null;
        this.page = null;
        this.options = {
            headless: process.env.PLAYWRIGHT_HEADLESS === 'true',
            slowMo: parseInt(process.env.PLAYWRIGHT_SLOW_MO) || 100,
            viewport: {
                width: parseInt(process.env.PLAYWRIGHT_VIEWPORT_WIDTH) || 1280,
                height: parseInt(process.env.PLAYWRIGHT_VIEWPORT_HEIGHT) || 720
            },
            ...options
        };
    }

    async init(browserType = 'chromium') {
        try {
            console.log(`🚀 Iniciando browser ${browserType}...`);
            
            const browsers = { chromium, firefox, webkit };
            this.browser = await browsers[browserType].launch({
                headless: this.options.headless,
                slowMo: this.options.slowMo
            });

            this.page = await this.browser.newPage({
                viewport: this.options.viewport
            });

            // Configurar timeouts
            this.page.setDefaultTimeout(parseInt(process.env.PLAYWRIGHT_TIMEOUT) || 30000);
            this.page.setDefaultNavigationTimeout(parseInt(process.env.PLAYWRIGHT_NAVIGATION_TIMEOUT) || 30000);

            console.log('✅ Browser iniciado com sucesso!');
            return this;
        } catch (error) {
            console.error('❌ Erro ao iniciar browser:', error);
            throw error;
        }
    }

    async navigate(url) {
        try {
            console.log(`🌐 Navegando para: ${url}`);
            await this.page.goto(url, { waitUntil: 'networkidle' });
            console.log('✅ Navegação concluída!');
            return this;
        } catch (error) {
            console.error('❌ Erro na navegação:', error);
            throw error;
        }
    }

    async click(selector, options = {}) {
        try {
            console.log(`👆 Clicando em: ${selector}`);
            await this.page.waitForSelector(selector, { timeout: 10000 });
            await this.page.click(selector, options);
            console.log('✅ Clique realizado!');
            return this;
        } catch (error) {
            console.error('❌ Erro no clique:', error);
            throw error;
        }
    }

    async fill(selector, value) {
        try {
            console.log(`✏️ Preenchendo ${selector} com: ${value}`);
            await this.page.waitForSelector(selector, { timeout: 10000 });
            await this.page.fill(selector, value);
            console.log('✅ Campo preenchido!');
            return this;
        } catch (error) {
            console.error('❌ Erro no preenchimento:', error);
            throw error;
        }
    }

    async screenshot(name = 'screenshot', fullPage = true) {
        try {
            const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
            const filename = `screenshots/${name}-${timestamp}.png`;
            
            console.log(`📸 Capturando screenshot: ${filename}`);
            await this.page.screenshot({ 
                path: filename, 
                fullPage 
            });
            console.log('✅ Screenshot capturado!');
            return filename;
        } catch (error) {
            console.error('❌ Erro na captura:', error);
            throw error;
        }
    }

    async waitForElement(selector, timeout = 10000) {
        try {
            console.log(`⏳ Aguardando elemento: ${selector}`);
            await this.page.waitForSelector(selector, { timeout });
            console.log('✅ Elemento encontrado!');
            return this;
        } catch (error) {
            console.error('❌ Elemento não encontrado:', error);
            throw error;
        }
    }

    async getText(selector) {
        try {
            await this.page.waitForSelector(selector, { timeout: 10000 });
            const text = await this.page.textContent(selector);
            console.log(`📝 Texto obtido de ${selector}: ${text}`);
            return text;
        } catch (error) {
            console.error('❌ Erro ao obter texto:', error);
            throw error;
        }
    }

    async close() {
        try {
            console.log('🔒 Fechando browser...');
            if (this.browser) {
                await this.browser.close();
                console.log('✅ Browser fechado!');
            }
        } catch (error) {
            console.error('❌ Erro ao fechar browser:', error);
            throw error;
        }
    }
}

module.exports = PlaywrightAutomation;
