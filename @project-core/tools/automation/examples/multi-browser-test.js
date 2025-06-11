/**
 * GRUPO US - Exemplo Multi-Browser
 * Testa compatibilidade entre diferentes browsers
 */

const PlaywrightAutomation = require('../playwright-basic');

async function multiBrowserTest() {
    const browsers = ['chromium', 'firefox', 'webkit'];
    const results = {};
    
    for (const browserType of browsers) {
        console.log(`\n🔄 Testando browser: ${browserType.toUpperCase()}`);
        
        const automation = new PlaywrightAutomation();
        
        try {
            const startTime = Date.now();
            
            await automation.init(browserType);
            await automation.navigate('https://whatsmyuseragent.org/');
            
            // Aguardar carregamento
            await automation.waitForElement('.user-agent');
            
            // Obter user agent
            const userAgent = await automation.getText('.user-agent');
            
            // Capturar screenshot específico do browser
            await automation.screenshot(`${browserType}-useragent`);
            
            const endTime = Date.now();
            const loadTime = endTime - startTime;
            
            results[browserType] = {
                success: true,
                userAgent: userAgent.trim(),
                loadTime: `${loadTime}ms`
            };
            
            console.log(`✅ ${browserType}: ${loadTime}ms`);
            
        } catch (error) {
            console.error(`❌ Erro no ${browserType}:`, error.message);
            results[browserType] = {
                success: false,
                error: error.message
            };
        } finally {
            await automation.close();
        }
    }
    
    // Relatório final
    console.log('\n📊 RELATÓRIO MULTI-BROWSER:');
    console.log('================================');
    
    for (const [browser, result] of Object.entries(results)) {
        console.log(`\n🌐 ${browser.toUpperCase()}:`);
        if (result.success) {
            console.log(`   ✅ Sucesso - ${result.loadTime}`);
            console.log(`   🔍 User Agent: ${result.userAgent.substring(0, 50)}...`);
        } else {
            console.log(`   ❌ Falha: ${result.error}`);
        }
    }
    
    return results;
}

// Executar se chamado diretamente
if (require.main === module) {
    multiBrowserTest();
}

module.exports = multiBrowserTest;
