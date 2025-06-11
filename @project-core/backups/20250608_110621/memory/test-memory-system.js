#!/usr/bin/env node

/**
 * Teste do Sistema de Memória AI
 * 
 * Valida se todos os arquivos de memória foram criados corretamente
 * e testa a integração com o sistema TaskMaster + Sequential Thinking
 */

const fs = require('fs');
const path = require('path');

class MemorySystemTester {
    constructor() {
        this.memoryDir = '.ai_memory';
        this.requiredFiles = [
            'master_rule.md',
            'self_correction_log.md', 
            'project_rules.md',
            'api_documentation.md',
            'database_schema.md',
            'coordination_patterns.md',
            'performance_metrics.md'
        ];
        this.testResults = [];
    }

    /**
     * Executa todos os testes do sistema de memória
     */
    async runAllTests() {
        console.log('🧠 Iniciando teste do Sistema de Memória AI...\n');

        try {
            // Teste 1: Verificar estrutura de diretórios
            this.testDirectoryStructure();

            // Teste 2: Verificar arquivos obrigatórios
            this.testRequiredFiles();

            // Teste 3: Validar conteúdo dos arquivos
            this.testFileContents();

            // Teste 4: Verificar integridade das referências
            this.testCrossReferences();

            // Teste 5: Validar estrutura de dados
            this.testDataStructures();

            // Teste 6: Verificar templates e exemplos
            this.testTemplatesAndExamples();

            // Resumo dos resultados
            this.displayResults();

            return this.testResults.every(result => result.passed);

        } catch (error) {
            console.error('❌ Erro durante os testes:', error);
            return false;
        }
    }

    /**
     * Testa se a estrutura de diretórios está correta
     */
    testDirectoryStructure() {
        console.log('📁 Teste 1: Estrutura de diretórios');
        
        try {
            const memoryDirExists = fs.existsSync(this.memoryDir);
            const memoryDirStats = memoryDirExists ? fs.statSync(this.memoryDir) : null;
            
            if (memoryDirExists && memoryDirStats.isDirectory()) {
                this.addResult('Directory Structure', true, 'Diretório .ai_memory criado corretamente');
                console.log('✅ Diretório .ai_memory existe e é válido');
            } else {
                this.addResult('Directory Structure', false, 'Diretório .ai_memory não encontrado');
                console.log('❌ Diretório .ai_memory não encontrado');
            }
        } catch (error) {
            this.addResult('Directory Structure', false, `Erro ao verificar diretório: ${error.message}`);
            console.log('❌ Erro ao verificar estrutura de diretórios');
        }
        
        console.log('');
    }

    /**
     * Testa se todos os arquivos obrigatórios existem
     */
    testRequiredFiles() {
        console.log('📄 Teste 2: Arquivos obrigatórios');
        
        let allFilesExist = true;
        const missingFiles = [];

        this.requiredFiles.forEach(filename => {
            const filePath = path.join(this.memoryDir, filename);
            const exists = fs.existsSync(filePath);
            
            if (exists) {
                const stats = fs.statSync(filePath);
                console.log(`✅ ${filename} (${stats.size} bytes)`);
            } else {
                console.log(`❌ ${filename} - AUSENTE`);
                missingFiles.push(filename);
                allFilesExist = false;
            }
        });

        this.addResult(
            'Required Files', 
            allFilesExist, 
            allFilesExist ? 'Todos os arquivos obrigatórios presentes' : `Arquivos ausentes: ${missingFiles.join(', ')}`
        );
        
        console.log('');
    }

    /**
     * Valida o conteúdo básico dos arquivos
     */
    testFileContents() {
        console.log('📝 Teste 3: Conteúdo dos arquivos');
        
        const contentTests = [
            {
                file: 'master_rule.md',
                requiredSections: ['MY CORE DIRECTIVE', 'TASKMASTER + SEQUENTIAL THINKING INTEGRATION', 'COORDINATION DECISION PROCESS'],
                description: 'Regras mestras com integração TaskMaster'
            },
            {
                file: 'project_rules.md', 
                requiredSections: ['TaskMaster + Sequential Thinking Integration', 'Stack Tecnológica', 'Regras de Coordenação'],
                description: 'Regras específicas do projeto'
            },
            {
                file: 'api_documentation.md',
                requiredSections: ['TaskMaster CLI Commands', 'Advanced Rules Engine API', 'Workflow Patterns'],
                description: 'Documentação de APIs e workflows'
            },
            {
                file: 'database_schema.md',
                requiredSections: ['tasks.json', 'config.json', 'Decision History'],
                description: 'Schema de dados do sistema'
            },
            {
                file: 'coordination_patterns.md',
                requiredSections: ['Successful Patterns', 'Anti-Patterns', 'Performance Optimization Patterns'],
                description: 'Padrões de coordenação aprendidos'
            },
            {
                file: 'performance_metrics.md',
                requiredSections: ['Decision Performance', 'Learning Analytics', 'Performance Benchmarks'],
                description: 'Métricas de performance e aprendizado'
            }
        ];

        let allContentValid = true;

        contentTests.forEach(test => {
            try {
                const filePath = path.join(this.memoryDir, test.file);
                const content = fs.readFileSync(filePath, 'utf8');
                
                const missingSections = test.requiredSections.filter(section => 
                    !content.includes(section)
                );

                if (missingSections.length === 0) {
                    console.log(`✅ ${test.file}: ${test.description}`);
                } else {
                    console.log(`❌ ${test.file}: Seções ausentes - ${missingSections.join(', ')}`);
                    allContentValid = false;
                }
            } catch (error) {
                console.log(`❌ ${test.file}: Erro ao ler arquivo - ${error.message}`);
                allContentValid = false;
            }
        });

        this.addResult(
            'File Contents',
            allContentValid,
            allContentValid ? 'Todo o conteúdo obrigatório presente' : 'Algumas seções obrigatórias ausentes'
        );
        
        console.log('');
    }

    /**
     * Verifica referências cruzadas entre arquivos
     */
    testCrossReferences() {
        console.log('🔗 Teste 4: Referências cruzadas');
        
        try {
            const masterRuleContent = fs.readFileSync(path.join(this.memoryDir, 'master_rule.md'), 'utf8');
            
            const expectedReferences = [
                'coordination_patterns.md',
                'performance_metrics.md',
                'api_documentation.md',
                'database_schema.md'
            ];

            let allReferencesValid = true;
            const missingReferences = [];

            expectedReferences.forEach(ref => {
                if (!masterRuleContent.includes(ref)) {
                    missingReferences.push(ref);
                    allReferencesValid = false;
                }
            });

            if (allReferencesValid) {
                console.log('✅ Todas as referências cruzadas estão presentes');
            } else {
                console.log(`❌ Referências ausentes: ${missingReferences.join(', ')}`);
            }

            this.addResult(
                'Cross References',
                allReferencesValid,
                allReferencesValid ? 'Referências cruzadas válidas' : `Referências ausentes: ${missingReferences.join(', ')}`
            );

        } catch (error) {
            this.addResult('Cross References', false, `Erro ao verificar referências: ${error.message}`);
            console.log('❌ Erro ao verificar referências cruzadas');
        }
        
        console.log('');
    }

    /**
     * Valida estruturas de dados documentadas
     */
    testDataStructures() {
        console.log('🏗️ Teste 5: Estruturas de dados');
        
        try {
            const schemaContent = fs.readFileSync(path.join(this.memoryDir, 'database_schema.md'), 'utf8');
            
            const requiredStructures = [
                'tasks.json',
                'config.json', 
                'Decision History',
                'Learning Patterns',
                'Performance Metrics'
            ];

            let allStructuresDocumented = true;
            const missingStructures = [];

            requiredStructures.forEach(structure => {
                if (!schemaContent.includes(structure)) {
                    missingStructures.push(structure);
                    allStructuresDocumented = false;
                }
            });

            if (allStructuresDocumented) {
                console.log('✅ Todas as estruturas de dados estão documentadas');
            } else {
                console.log(`❌ Estruturas não documentadas: ${missingStructures.join(', ')}`);
            }

            this.addResult(
                'Data Structures',
                allStructuresDocumented,
                allStructuresDocumented ? 'Estruturas de dados completas' : `Estruturas ausentes: ${missingStructures.join(', ')}`
            );

        } catch (error) {
            this.addResult('Data Structures', false, `Erro ao verificar estruturas: ${error.message}`);
            console.log('❌ Erro ao verificar estruturas de dados');
        }
        
        console.log('');
    }

    /**
     * Verifica templates e exemplos
     */
    testTemplatesAndExamples() {
        console.log('📋 Teste 6: Templates e exemplos');
        
        try {
            const logContent = fs.readFileSync(path.join(this.memoryDir, 'self_correction_log.md'), 'utf8');
            const hasTemplate = logContent.includes('Template for Future Entries');
            
            const apiContent = fs.readFileSync(path.join(this.memoryDir, 'api_documentation.md'), 'utf8');
            const hasExamples = apiContent.includes('Example:') && apiContent.includes('```');

            const templatesValid = hasTemplate && hasExamples;

            if (templatesValid) {
                console.log('✅ Templates e exemplos estão presentes');
            } else {
                console.log('❌ Templates ou exemplos ausentes');
            }

            this.addResult(
                'Templates and Examples',
                templatesValid,
                templatesValid ? 'Templates e exemplos completos' : 'Templates ou exemplos ausentes'
            );

        } catch (error) {
            this.addResult('Templates and Examples', false, `Erro ao verificar templates: ${error.message}`);
            console.log('❌ Erro ao verificar templates e exemplos');
        }
        
        console.log('');
    }

    /**
     * Adiciona resultado de teste
     */
    addResult(testName, passed, message) {
        this.testResults.push({
            test: testName,
            passed: passed,
            message: message,
            timestamp: new Date().toISOString()
        });
    }

    /**
     * Exibe resumo dos resultados
     */
    displayResults() {
        console.log('📊 RESUMO DOS TESTES DO SISTEMA DE MEMÓRIA');
        console.log('==========================================');
        
        const passedTests = this.testResults.filter(r => r.passed).length;
        const totalTests = this.testResults.length;
        const successRate = ((passedTests / totalTests) * 100).toFixed(1);

        console.log(`✅ Testes aprovados: ${passedTests}/${totalTests} (${successRate}%)`);
        console.log('');

        this.testResults.forEach(result => {
            const icon = result.passed ? '✅' : '❌';
            console.log(`${icon} ${result.test}: ${result.message}`);
        });

        console.log('');
        
        if (passedTests === totalTests) {
            console.log('🎉 SISTEMA DE MEMÓRIA AI IMPLEMENTADO COM SUCESSO!');
            console.log('');
            console.log('📚 Arquivos de memória criados:');
            this.requiredFiles.forEach(file => {
                console.log(`   - ${file}`);
            });
            console.log('');
            console.log('🚀 O sistema agora possui:');
            console.log('   - Memória persistente entre sessões');
            console.log('   - Auto-aprendizado e correção');
            console.log('   - Regras adaptáveis');
            console.log('   - Integração com TaskMaster + Sequential Thinking');
            console.log('   - Padrões de coordenação documentados');
            console.log('   - Métricas de performance');
        } else {
            console.log('⚠️ Sistema de memória implementado com algumas pendências.');
            console.log('Verifique os itens marcados com ❌ acima.');
        }
    }
}

// Executa os testes se o script for chamado diretamente
if (require.main === module) {
    const tester = new MemorySystemTester();
    tester.runAllTests()
        .then(success => {
            process.exit(success ? 0 : 1);
        })
        .catch(error => {
            console.error('❌ Erro fatal:', error);
            process.exit(1);
        });
}

module.exports = { MemorySystemTester };
