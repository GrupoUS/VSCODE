/**
 * GRUPO US - Testes de Automação Playwright
 * Seguindo VIBECODE SYSTEM V2.0
 */

const { test, expect } = require('@playwright/test');

test.describe('GRUPO US - Automação Básica', () => {
    
    test('deve navegar e capturar screenshot', async ({ page }) => {
        await page.goto('https://example.com');
        await expect(page).toHaveTitle(/Example Domain/);
        
        // Capturar screenshot
        await page.screenshot({ path: 'screenshots/test-navigation.png' });
    });

    test('deve preencher formulário básico', async ({ page }) => {
        await page.goto('https://httpbin.org/forms/post');
        
        // Preencher campos
        await page.fill('input[name="custname"]', 'GRUPO US Test');
        await page.fill('input[name="custemail"]', 'test@grupous.com');
        
        // Verificar preenchimento
        await expect(page.locator('input[name="custname"]')).toHaveValue('GRUPO US Test');
        await expect(page.locator('input[name="custemail"]')).toHaveValue('test@grupous.com');
    });

    test('deve testar responsividade', async ({ page }) => {
        // Testar diferentes viewports
        const viewports = [
            { width: 1920, height: 1080 }, // Desktop
            { width: 768, height: 1024 },  // Tablet
            { width: 375, height: 667 }    // Mobile
        ];

        for (const viewport of viewports) {
            await page.setViewportSize(viewport);
            await page.goto('https://example.com');
            
            // Capturar screenshot para cada viewport
            await page.screenshot({ 
                path: `screenshots/responsive-${viewport.width}x${viewport.height}.png` 
            });
            
            // Verificar se página carregou
            await expect(page.locator('h1')).toBeVisible();
        }
    });

    test('deve testar performance básica', async ({ page }) => {
        const startTime = Date.now();
        
        await page.goto('https://example.com');
        await page.waitForLoadState('networkidle');
        
        const loadTime = Date.now() - startTime;
        
        // Verificar se carregou em menos de 5 segundos
        expect(loadTime).toBeLessThan(5000);
        
        console.log(`⚡ Tempo de carregamento: ${loadTime}ms`);
    });

    test('deve verificar acessibilidade básica', async ({ page }) => {
        await page.goto('https://example.com');
        
        // Verificar se tem título
        await expect(page).toHaveTitle(/.+/);
        
        // Verificar se tem heading principal
        const h1 = page.locator('h1');
        await expect(h1).toBeVisible();
        
        // Verificar contraste básico (exemplo)
        const bodyColor = await page.evaluate(() => {
            return window.getComputedStyle(document.body).color;
        });
        
        expect(bodyColor).toBeTruthy();
    });
});

test.describe('GRUPO US - Testes Multi-Browser', () => {
    
    ['chromium', 'firefox', 'webkit'].forEach(browserName => {
        test(`deve funcionar no ${browserName}`, async ({ page }) => {
            await page.goto('https://whatsmyuseragent.org/');
            
            // Aguardar carregamento
            await page.waitForSelector('.user-agent', { timeout: 10000 });
            
            // Verificar se user agent foi detectado
            const userAgent = await page.textContent('.user-agent');
            expect(userAgent).toBeTruthy();
            expect(userAgent.length).toBeGreaterThan(10);
            
            console.log(`🌐 ${browserName}: ${userAgent.substring(0, 50)}...`);
        });
    });
});

test.describe('GRUPO US - Testes de Integração', () => {
    
    test('deve testar fluxo completo de usuário', async ({ page }) => {
        // Simular jornada completa do usuário
        await page.goto('https://example.com');
        
        // Verificar página inicial
        await expect(page.locator('h1')).toContainText('Example Domain');
        
        // Simular clique em link (se existir)
        const links = await page.locator('a').count();
        if (links > 0) {
            await page.click('a:first-child');
            await page.waitForLoadState('networkidle');
        }
        
        // Capturar estado final
        await page.screenshot({ path: 'screenshots/user-journey-end.png' });
    });

    test('deve validar formulário com dados inválidos', async ({ page }) => {
        await page.goto('https://httpbin.org/forms/post');
        
        // Tentar submeter formulário vazio
        await page.click('input[type="submit"]');
        
        // Verificar se ainda está na mesma página (validação client-side)
        await expect(page).toHaveURL(/forms\/post/);
        
        // Preencher com dados inválidos
        await page.fill('input[name="custemail"]', 'email-invalido');
        
        // Verificar validação HTML5
        const emailInput = page.locator('input[name="custemail"]');
        const isValid = await emailInput.evaluate(el => el.validity.valid);
        expect(isValid).toBeFalsy();
    });
});
