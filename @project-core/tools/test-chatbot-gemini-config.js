#!/usr/bin/env node

/**
 * Script de Teste - Configuração Gemini Chatbot Assistente Pessoal
 * GRUPO US VIBECODE SYSTEM V2.0
 * 
 * Este script verifica se as configurações do modelo Gemini foram aplicadas corretamente
 * em todos os projetos do chatbot assistente pessoal.
 */

const fs = require('fs');
const path = require('path');

console.log('🤖 TESTE DE CONFIGURAÇÃO - CHATBOT ASSISTENTE PESSOAL');
console.log('📋 Verificando configuração do modelo Gemini...\n');

// Configurações esperadas
const EXPECTED_MODEL = 'google/gemini-2.5-flash-preview-05-20:thinking';
const PROJECTS = ['neonpro', 'aegiswallet', 'harmoniza-facil-agendas'];

// Resultados do teste
let testResults = {
  passed: 0,
  failed: 0,
  warnings: 0,
  details: []
};

/**
 * Função para verificar se um arquivo contém o modelo esperado
 */
function checkFileForModel(filePath, expectedPattern, description) {
  try {
    if (!fs.existsSync(filePath)) {
      testResults.failed++;
      testResults.details.push({
        status: '❌',
        test: description,
        result: `Arquivo não encontrado: ${filePath}`
      });
      return false;
    }

    const content = fs.readFileSync(filePath, 'utf8');
    const hasExpectedModel = content.includes(EXPECTED_MODEL);
    
    if (hasExpectedModel) {
      testResults.passed++;
      testResults.details.push({
        status: '✅',
        test: description,
        result: `Modelo Gemini configurado corretamente`
      });
      return true;
    } else {
      testResults.failed++;
      testResults.details.push({
        status: '❌',
        test: description,
        result: `Modelo Gemini não encontrado. Verificar configuração.`
      });
      return false;
    }
  } catch (error) {
    testResults.failed++;
    testResults.details.push({
      status: '❌',
      test: description,
      result: `Erro ao ler arquivo: ${error.message}`
    });
    return false;
  }
}

/**
 * Função para verificar variáveis de ambiente
 */
function checkEnvFile(filePath, description) {
  try {
    if (!fs.existsSync(filePath)) {
      testResults.warnings++;
      testResults.details.push({
        status: '⚠️',
        test: description,
        result: `Arquivo .env.example não encontrado: ${filePath}`
      });
      return false;
    }

    const content = fs.readFileSync(filePath, 'utf8');
    const hasGoogleKey = content.includes('GOOGLE_API_KEY');
    const hasOpenRouterKey = content.includes('OPENROUTER_API_KEY');
    
    if (hasGoogleKey && hasOpenRouterKey) {
      testResults.passed++;
      testResults.details.push({
        status: '✅',
        test: description,
        result: `Variáveis de ambiente configuradas (GOOGLE_API_KEY, OPENROUTER_API_KEY)`
      });
      return true;
    } else {
      testResults.warnings++;
      testResults.details.push({
        status: '⚠️',
        test: description,
        result: `Variáveis de ambiente incompletas. Google: ${hasGoogleKey}, OpenRouter: ${hasOpenRouterKey}`
      });
      return false;
    }
  } catch (error) {
    testResults.failed++;
    testResults.details.push({
      status: '❌',
      test: description,
      result: `Erro ao ler .env.example: ${error.message}`
    });
    return false;
  }
}

// TESTES PRINCIPAIS

console.log('🔍 EXECUTANDO TESTES...\n');

// 1. NEONPRO - Chat with AI
checkFileForModel(
  'neonpro/supabase/functions/chat-with-ai/index.ts',
  EXPECTED_MODEL,
  'NEONPRO - Chat with AI Function'
);

// 2. AEGISWALLET - AI Financial Chat
checkFileForModel(
  'aegiswallet/supabase/functions/ai-financial-chat/index.ts',
  EXPECTED_MODEL,
  'AEGISWALLET - AI Financial Chat Function'
);

// 3. HARMONIZA - TaskMaster Config
checkFileForModel(
  'harmoniza-facil-agendas/Rules/mcp-integration/config.json',
  EXPECTED_MODEL,
  'HARMONIZA - TaskMaster MCP Config'
);

// 4. Configurações Centralizadas
checkFileForModel(
  'augment-interface-config.json',
  EXPECTED_MODEL,
  'Configuração Central - Augment Interface'
);

checkFileForModel(
  'augment-optimization-config.json',
  EXPECTED_MODEL,
  'Configuração Central - Augment Optimization'
);

checkFileForModel(
  '.env.taskmaster',
  EXPECTED_MODEL,
  'Configuração Central - TaskMaster Environment'
);

// 5. Variáveis de Ambiente
checkEnvFile('neonpro/.env.example', 'NEONPRO - Environment Variables');
checkEnvFile('aegiswallet/.env.example', 'AEGISWALLET - Environment Variables');
checkEnvFile('harmoniza-facil-agendas/.env.example', 'HARMONIZA - Environment Variables');

// RELATÓRIO FINAL
console.log('📊 RELATÓRIO DE TESTES\n');
console.log('═'.repeat(60));

testResults.details.forEach(detail => {
  console.log(`${detail.status} ${detail.test}`);
  console.log(`   ${detail.result}\n`);
});

console.log('═'.repeat(60));
console.log(`✅ Testes Aprovados: ${testResults.passed}`);
console.log(`❌ Testes Falharam: ${testResults.failed}`);
console.log(`⚠️  Avisos: ${testResults.warnings}`);

const totalTests = testResults.passed + testResults.failed + testResults.warnings;
const successRate = ((testResults.passed / totalTests) * 100).toFixed(1);

console.log(`📈 Taxa de Sucesso: ${successRate}%`);

if (testResults.failed === 0 && testResults.warnings <= 1) {
  console.log('\n🎉 CONFIGURAÇÃO GEMINI APLICADA COM SUCESSO!');
  console.log('✅ O chatbot assistente pessoal está configurado para usar Gemini como modelo padrão.');
} else if (testResults.failed === 0) {
  console.log('\n⚠️  CONFIGURAÇÃO PARCIALMENTE APLICADA');
  console.log('✅ Funcionalidades principais configuradas, mas há avisos para revisar.');
} else {
  console.log('\n❌ CONFIGURAÇÃO INCOMPLETA');
  console.log('🔧 Revisar os itens falharam antes de usar o chatbot.');
}

console.log('\n📝 PRÓXIMOS PASSOS RECOMENDADOS:');
console.log('1. Configurar as API keys nos arquivos .env de cada projeto');
console.log('2. Testar uma interação básica com o chatbot');
console.log('3. Verificar logs para confirmar que Gemini está sendo usado');
console.log('4. Implementar integração WhatsApp conforme planejado');

process.exit(testResults.failed > 0 ? 1 : 0);
