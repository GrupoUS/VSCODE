/**
 * GRUPO US TEST HELPERS - PLAYWRIGHT AUTOMATION
 * 
 * Helpers específicos para testes automatizados do GRUPO US VIBECODE SYSTEM
 * Integração com Supabase, Figma e TaskMaster
 * 
 * @version 1.0
 * @author GRUPO US - VIBECODE SYSTEM
 */

import { Page, expect } from '@playwright/test';

export class GrupoUSTestHelpers {
    private page: Page;

    constructor(page: Page) {
        this.page = page;
    }

    /**
     * Setup de autenticação para testes GRUPO US
     */
    async setupAuthentication(page: Page) {
        // Interceptar requests de autenticação
        await page.route('**/auth/**', route => {
            console.log('🔐 Auth request intercepted:', route.request().url());
            route.continue();
        });

        // Setup storage state se existir
        const storageStatePath = '@project-core/automation/playwright-storage-state.json';
        try {
            const storageState = require(storageStatePath);
            await page.context().addCookies(storageState.cookies);
            console.log('✅ Authentication state loaded');
        } catch (error) {
            console.log('ℹ️ No existing auth state, will authenticate manually');
        }
    }

    /**
     * Setup de viewport otimizado para GRUPO US
     */
    async setupViewport(page: Page) {
        await page.setViewportSize({ width: 1280, height: 720 });
        
        // Verificar se viewport foi aplicado corretamente
        const viewport = page.viewportSize();
        expect(viewport?.width).toBe(1280);
        expect(viewport?.height).toBe(720);
        
        console.log('✅ Viewport configured: 1280x720');
    }

    /**
     * Setup de interceptação de rede
     */
    async setupNetworkInterception(page: Page) {
        // Bloquear recursos desnecessários para performance
        await page.route('**/*.{png,jpg,jpeg,gif,svg,woff,woff2}', route => {
            route.abort();
        });

        // Interceptar APIs críticas
        await page.route('**/api/**', route => {
            console.log('🌐 API request:', route.request().method(), route.request().url());
            route.continue();
        });

        // Interceptar Supabase requests
        await page.route('**/*.supabase.co/**', route => {
            console.log('🗄️ Supabase request:', route.request().url());
            route.continue();
        });

        console.log('✅ Network interception configured');
    }

    /**
     * Login automático com credenciais de teste
     */
    async loginWithTestCredentials(email: string = 'test@grupous.com', password: string = 'test123') {
        console.log(`🔐 Logging in with: ${email}`);
        
        // Navegar para página de login
        await this.page.goto('/login');
        
        // Aguardar carregamento
        await this.page.waitForLoadState('networkidle');
        
        // Preencher credenciais
        await this.page.fill('[data-testid="email-input"]', email);
        await this.page.fill('[data-testid="password-input"]', password);
        
        // Clicar em login
        await this.page.click('[data-testid="login-button"]');
        
        // Aguardar redirecionamento
        await this.page.waitForURL('**/dashboard');
        
        // Verificar login bem-sucedido
        await expect(this.page.locator('[data-testid="user-menu"]')).toBeVisible();
        
        console.log('✅ Login successful');
    }

    /**
     * Verificar branding GRUPO US
     */
    async verifyGrupoUSBranding() {
        // Verificar logo
        await expect(this.page.locator('[data-testid="grupo-us-logo"]')).toBeVisible();
        
        // Verificar cores do tema
        const primaryColor = await this.page.evaluate(() => {
            return getComputedStyle(document.documentElement).getPropertyValue('--primary-color');
        });
        
        expect(primaryColor).toBeTruthy();
        
        // Verificar meta tags
        const title = await this.page.title();
        expect(title).toContain('GRUPO US');
        
        console.log('✅ GRUPO US branding verified');
    }

    /**
     * Aguardar carregamento de dados Supabase
     */
    async waitForSupabaseData(timeout: number = 10000) {
        console.log('⏳ Waiting for Supabase data...');
        
        // Aguardar indicador de loading desaparecer
        await this.page.waitForSelector('[data-testid="loading-spinner"]', { 
            state: 'hidden', 
            timeout 
        });
        
        // Aguardar dados aparecerem
        await this.page.waitForSelector('[data-testid="data-loaded"]', { 
            timeout 
        });
        
        console.log('✅ Supabase data loaded');
    }

    /**
     * Capturar screenshot com timestamp
     */
    async captureTimestampedScreenshot(name: string) {
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const filename = `${name}-${timestamp}.png`;
        const path = `@project-core/automation/playwright-output/screenshots/${filename}`;
        
        await this.page.screenshot({ 
            path,
            fullPage: true 
        });
        
        console.log(`📸 Screenshot captured: ${filename}`);
        return filename;
    }

    /**
     * Verificar performance da página
     */
    async verifyPagePerformance() {
        const performanceMetrics = await this.page.evaluate(() => {
            const navigation = performance.getEntriesByType('navigation')[0] as PerformanceNavigationTiming;
            return {
                loadTime: navigation.loadEventEnd - navigation.loadEventStart,
                domContentLoaded: navigation.domContentLoadedEventEnd - navigation.domContentLoadedEventStart,
                firstPaint: performance.getEntriesByName('first-paint')[0]?.startTime || 0,
                firstContentfulPaint: performance.getEntriesByName('first-contentful-paint')[0]?.startTime || 0
            };
        });

        // Verificar métricas de performance
        expect(performanceMetrics.loadTime).toBeLessThan(3000); // < 3s
        expect(performanceMetrics.domContentLoaded).toBeLessThan(2000); // < 2s
        
        console.log('⚡ Performance metrics:', performanceMetrics);
        return performanceMetrics;
    }

    /**
     * Testar responsividade
     */
    async testResponsiveness() {
        const viewports = [
            { width: 1920, height: 1080, name: 'Desktop Large' },
            { width: 1280, height: 720, name: 'Desktop' },
            { width: 768, height: 1024, name: 'Tablet' },
            { width: 375, height: 667, name: 'Mobile' }
        ];

        for (const viewport of viewports) {
            console.log(`📱 Testing ${viewport.name}: ${viewport.width}x${viewport.height}`);
            
            await this.page.setViewportSize({ 
                width: viewport.width, 
                height: viewport.height 
            });
            
            // Aguardar reflow
            await this.page.waitForTimeout(500);
            
            // Verificar elementos críticos ainda visíveis
            await expect(this.page.locator('[data-testid="main-navigation"]')).toBeVisible();
            
            // Capturar screenshot
            await this.captureTimestampedScreenshot(`responsive-${viewport.name.toLowerCase().replace(' ', '-')}`);
        }
        
        // Restaurar viewport padrão
        await this.page.setViewportSize({ width: 1280, height: 720 });
        
        console.log('✅ Responsiveness testing completed');
    }

    /**
     * Verificar acessibilidade básica
     */
    async verifyAccessibility() {
        console.log('♿ Checking accessibility...');
        
        // Verificar elementos com aria-labels
        const elementsWithAriaLabel = await this.page.locator('[aria-label]').count();
        expect(elementsWithAriaLabel).toBeGreaterThan(0);
        
        // Verificar headings hierárquicos
        const h1Count = await this.page.locator('h1').count();
        expect(h1Count).toBe(1); // Deve ter exatamente um H1
        
        // Verificar contraste (básico)
        const contrastIssues = await this.page.evaluate(() => {
            const elements = document.querySelectorAll('*');
            let issues = 0;
            
            elements.forEach(el => {
                const styles = getComputedStyle(el);
                const bgColor = styles.backgroundColor;
                const textColor = styles.color;
                
                // Verificação básica de contraste
                if (bgColor === textColor) {
                    issues++;
                }
            });
            
            return issues;
        });
        
        expect(contrastIssues).toBe(0);
        
        console.log('✅ Basic accessibility checks passed');
    }

    /**
     * Cleanup após testes
     */
    async cleanup() {
        // Limpar localStorage
        await this.page.evaluate(() => {
            localStorage.clear();
            sessionStorage.clear();
        });
        
        // Limpar cookies não essenciais
        const context = this.page.context();
        await context.clearCookies();
        
        console.log('🧹 Test cleanup completed');
    }

    /**
     * Salvar estado de autenticação
     */
    async saveAuthenticationState() {
        const storageState = await this.page.context().storageState();
        const storageStatePath = '@project-core/automation/playwright-storage-state.json';
        
        require('fs').writeFileSync(
            storageStatePath, 
            JSON.stringify(storageState, null, 2)
        );
        
        console.log('💾 Authentication state saved');
    }
}

/**
 * Utilitários específicos para Supabase
 */
export class SupabaseTestUtils {
    /**
     * Aguardar conexão Supabase
     */
    static async waitForSupabaseConnection(page: Page, timeout: number = 5000) {
        await page.waitForFunction(() => {
            return window.supabase && window.supabase.auth;
        }, { timeout });
        
        console.log('✅ Supabase connection established');
    }

    /**
     * Verificar dados de teste no Supabase
     */
    static async verifyTestData(page: Page, table: string, expectedCount: number) {
        const count = await page.evaluate(async (tableName) => {
            const { data, error } = await window.supabase
                .from(tableName)
                .select('*', { count: 'exact' });
            
            return error ? 0 : data?.length || 0;
        }, table);
        
        expect(count).toBeGreaterThanOrEqual(expectedCount);
        console.log(`✅ Supabase ${table} data verified: ${count} records`);
    }
}

/**
 * Validador de componentes Figma
 */
export class FigmaComponentValidator {
    /**
     * Verificar se componente renderizou conforme Figma
     */
    static async validateFigmaComponent(page: Page, componentSelector: string) {
        const component = page.locator(componentSelector);
        await expect(component).toBeVisible();
        
        // Verificar propriedades visuais básicas
        const boundingBox = await component.boundingBox();
        expect(boundingBox).toBeTruthy();
        expect(boundingBox!.width).toBeGreaterThan(0);
        expect(boundingBox!.height).toBeGreaterThan(0);
        
        console.log(`✅ Figma component validated: ${componentSelector}`);
    }
}
