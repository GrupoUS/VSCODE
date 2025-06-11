/**
 * GRUPO US - Exemplo Simples e Confiável
 * Teste básico que sempre funciona
 */

const PlaywrightAutomation = require('../playwright-basic');

async function simpleTestExample() {
    const automation = new PlaywrightAutomation();
    
    try {
        console.log('🎭 GRUPO US - Teste Simples Iniciado');
        
        // Inicializar browser
        await automation.init('chromium');
        
        // Navegar para página de exemplo confiável
        await automation.navigate('https://example.com');
        
        // Capturar screenshot inicial
        await automation.screenshot('example-homepage');
        
        // Verificar título da página
        const title = await automation.page.title();
        console.log(`📄 Título da página: ${title}`);
        
        // Obter texto do heading principal
        const heading = await automation.getText('h1');
        console.log(`📝 Heading principal: ${heading}`);
        
        // Verificar se existe link "More information"
        const linkExists = await automation.page.locator('a').count() > 0;
        console.log(`🔗 Links encontrados: ${linkExists ? 'Sim' : 'Não'}`);
        
        if (linkExists) {
            // Capturar screenshot antes do clique
            await automation.screenshot('before-click');
            
            // Clicar no primeiro link
            await automation.click('a:first-child');
            
            // Aguardar carregamento
            await automation.page.waitForLoadState('networkidle');
            
            // Capturar screenshot após navegação
            await automation.screenshot('after-navigation');
            
            console.log(`🌐 Nova URL: ${automation.page.url()}`);
        }
        
        console.log('🎉 Teste simples concluído com sucesso!');
        
    } catch (error) {
        console.error('❌ Erro no teste:', error.message);
        await automation.screenshot('simple-test-error');
    } finally {
        await automation.close();
    }
}

// Executar se chamado diretamente
if (require.main === module) {
    simpleTestExample();
}

module.exports = simpleTestExample;
