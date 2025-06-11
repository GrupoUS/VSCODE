/**
 * GRUPO US - Exemplo de Automação de Formulários
 * Demonstra preenchimento e submissão de formulários
 */

const PlaywrightAutomation = require('../playwright-basic');

async function formAutomationExample() {
    const automation = new PlaywrightAutomation();
    
    try {
        await automation.init('chromium');
        
        // Navegar para página de exemplo de formulário
        await automation.navigate('https://httpbin.org/forms/post');
        
        // Capturar estado inicial
        await automation.screenshot('form-initial');
        
        // Preencher campos do formulário
        await automation.fill('input[name="custname"]', 'GRUPO US Cliente');
        await automation.fill('input[name="custtel"]', '11999999999');
        await automation.fill('input[name="custemail"]', 'contato@grupous.com');
        
        // Selecionar tamanho da pizza (exemplo)
        await automation.click('input[value="medium"]');
        
        // Selecionar toppings
        await automation.click('input[name="topping"][value="bacon"]');
        await automation.click('input[name="topping"][value="cheese"]');
        
        // Preencher comentários
        await automation.fill('textarea[name="comments"]', 'Pedido automatizado via Playwright - GRUPO US');
        
        // Capturar formulário preenchido
        await automation.screenshot('form-filled');
        
        // Submeter formulário
        await automation.click('input[type="submit"]');
        
        // Aguardar página de resultado
        await automation.waitForElement('pre');
        
        // Capturar resultado
        await automation.screenshot('form-submitted');
        
        // Obter texto do resultado
        const result = await automation.getText('pre');
        console.log('📋 Resultado da submissão:', result);
        
        console.log('🎉 Exemplo de automação de formulário concluído!');
        
    } catch (error) {
        console.error('❌ Erro no exemplo:', error);
        await automation.screenshot('form-error');
    } finally {
        await automation.close();
    }
}

// Executar se chamado diretamente
if (require.main === module) {
    formAutomationExample();
}

module.exports = formAutomationExample;
