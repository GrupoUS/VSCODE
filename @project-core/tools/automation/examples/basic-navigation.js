/**
 * GRUPO US - Exemplo Básico de Navegação
 * Demonstra navegação básica e interações
 */

const PlaywrightAutomation = require('../playwright-basic');

async function basicNavigationExample() {
    const automation = new PlaywrightAutomation();
    
    try {
        // Inicializar browser
        await automation.init('chromium');
        
        // Navegar para Google
        await automation.navigate('https://www.google.com');
        
        // Capturar screenshot inicial
        await automation.screenshot('google-homepage');
        
        // Preencher campo de busca (seletor mais robusto)
        await automation.fill('textarea[name="q"], input[name="q"]', 'GRUPO US desenvolvimento');

        // Pressionar Enter para buscar
        await automation.page.keyboard.press('Enter');
        
        // Aguardar resultados
        await automation.waitForElement('#search');
        
        // Capturar screenshot dos resultados
        await automation.screenshot('search-results');
        
        console.log('🎉 Exemplo de navegação básica concluído!');
        
    } catch (error) {
        console.error('❌ Erro no exemplo:', error);
        await automation.screenshot('error-state');
    } finally {
        await automation.close();
    }
}

// Executar se chamado diretamente
if (require.main === module) {
    basicNavigationExample();
}

module.exports = basicNavigationExample;
