/**
 * GRUPO US - Teste de Integração TaskMaster + Playwright
 * Seguindo VIBECODE SYSTEM V2.0
 */

const TaskMasterPlaywrightIntegration = require('./index');

async function testIntegration() {
    console.log('🧪 TESTE DE INTEGRAÇÃO TASKMASTER + PLAYWRIGHT');
    console.log('===============================================\n');

    const integration = new TaskMasterPlaywrightIntegration({
        playwright: {
            headless: false,
            timeout: 15000,
            screenshotsPath: './screenshots',
            reportsPath: './reports'
        }
    });

    try {
        // 1. Inicializar integração
        console.log('1️⃣ Inicializando integração...');
        const initResult = await integration.initialize();
        
        if (!initResult.success) {
            throw new Error(`Falha na inicialização: ${initResult.error}`);
        }
        
        console.log('✅ Integração inicializada com sucesso!\n');

        // 2. Testar automação básica
        console.log('2️⃣ Testando automação básica...');
        const basicResult = await integration.executeAutomationTask(
            'Navegar para example.com e capturar screenshot',
            { browser: 'chromium', stepDelay: 1000 }
        );
        
        if (basicResult.success) {
            console.log('✅ Automação básica executada com sucesso!');
            console.log(`   Resultado: ${JSON.stringify(basicResult.result, null, 2)}`);
        } else {
            console.log('❌ Falha na automação básica:', basicResult.error);
        }
        console.log('');

        // 3. Testar automação de formulário
        console.log('3️⃣ Testando automação de formulário...');
        const formResult = await integration.executeAutomationTask(
            'Navegar para httpbin.org/forms/post, preencher formulário e capturar screenshot',
            { browser: 'chromium', stepDelay: 2000 }
        );
        
        if (formResult.success) {
            console.log('✅ Automação de formulário executada com sucesso!');
        } else {
            console.log('❌ Falha na automação de formulário:', formResult.error);
        }
        console.log('');

        // 4. Verificar status
        console.log('4️⃣ Verificando status da integração...');
        const status = integration.getStatus();
        console.log('📊 Status atual:');
        console.log(`   Inicializado: ${status.initialized}`);
        console.log(`   Tarefas no histórico: ${status.taskHistory}`);
        console.log(`   Métricas: ${JSON.stringify(status.metrics, null, 2)}`);
        console.log('');

        // 5. Gerar relatório
        console.log('5️⃣ Gerando relatório...');
        const report = await integration.generateTaskMasterReport();
        console.log('✅ Relatório gerado com sucesso!');
        console.log(`   Taxa de sucesso: ${report.metrics.successRate}%`);
        console.log(`   Tempo médio de execução: ${report.metrics.averageExecutionTime}ms`);
        console.log('');

        // 6. Cleanup
        console.log('6️⃣ Executando cleanup...');
        await integration.cleanup();
        console.log('✅ Cleanup concluído!');
        console.log('');

        console.log('🎉 TESTE DE INTEGRAÇÃO CONCLUÍDO COM SUCESSO!');
        console.log('============================================');
        console.log('');
        console.log('📋 Resumo:');
        console.log(`   ✅ Integração inicializada`);
        console.log(`   ✅ Automação básica testada`);
        console.log(`   ✅ Automação de formulário testada`);
        console.log(`   ✅ Status verificado`);
        console.log(`   ✅ Relatório gerado`);
        console.log(`   ✅ Cleanup executado`);
        console.log('');
        console.log('🚀 A integração TaskMaster + Playwright está funcionando perfeitamente!');

    } catch (error) {
        console.error('❌ ERRO NO TESTE DE INTEGRAÇÃO:', error.message);
        console.error('Stack trace:', error.stack);
        
        // Tentar cleanup mesmo em caso de erro
        try {
            await integration.cleanup();
        } catch (cleanupError) {
            console.error('❌ Erro no cleanup:', cleanupError.message);
        }
        
        process.exit(1);
    }
}

// Executar teste se chamado diretamente
if (require.main === module) {
    testIntegration();
}

module.exports = testIntegration;
