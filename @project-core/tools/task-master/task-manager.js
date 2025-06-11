/**
 * GRUPO US - Task Master AI Manager
 * Seguindo VIBECODE SYSTEM V2.0
 * Integração com Playwright e MCP
 */

const fs = require('fs');
const path = require('path');
const PlaywrightAutomation = require('../automation/playwright-basic');

class TaskMasterManager {
    constructor(configPath = './task-master-config.json') {
        this.config = this.loadConfig(configPath);
        this.automation = null;
        this.tasks = [];
        this.currentTask = null;
        this.metrics = {
            tasksCompleted: 0,
            tasksCreated: 0,
            errorsEncountered: 0,
            successRate: 0
        };
    }

    loadConfig(configPath) {
        try {
            const configData = fs.readFileSync(configPath, 'utf8');
            return JSON.parse(configData);
        } catch (error) {
            console.error('❌ Erro ao carregar configuração:', error.message);
            return this.getDefaultConfig();
        }
    }

    getDefaultConfig() {
        return {
            project: { name: "Default Project" },
            taskmaster: { enabled: true, mode: "basic" },
            automation: { playwright: { timeout: 30000 } }
        };
    }

    async initialize() {
        try {
            console.log('🚀 Inicializando Task Master AI Manager...');
            
            // Inicializar automação Playwright se habilitada
            if (this.config.taskmaster.integration?.playwright) {
                this.automation = new PlaywrightAutomation();
                console.log('✅ Integração Playwright inicializada');
            }

            // Carregar tarefas existentes
            await this.loadExistingTasks();

            console.log('✅ Task Master AI Manager inicializado com sucesso!');
            return { success: true, message: 'Inicializado' };
        } catch (error) {
            console.error('❌ Erro na inicialização:', error.message);
            return { success: false, error: error.message };
        }
    }

    async loadExistingTasks() {
        try {
            const tasksDir = './tasks';
            if (fs.existsSync(tasksDir)) {
                const taskFiles = fs.readdirSync(tasksDir).filter(f => f.endsWith('.txt'));
                
                for (const file of taskFiles) {
                    const taskContent = fs.readFileSync(path.join(tasksDir, file), 'utf8');
                    const taskId = file.replace('.txt', '');
                    
                    this.tasks.push({
                        id: taskId,
                        content: taskContent,
                        status: 'pending',
                        createdAt: new Date(),
                        file: file
                    });
                }
                
                console.log(`📋 ${this.tasks.length} tarefas carregadas`);
            }
        } catch (error) {
            console.error('⚠️ Erro ao carregar tarefas:', error.message);
        }
    }

    createTask(description, type = 'general', priority = 'medium') {
        const task = {
            id: `task_${Date.now()}`,
            description,
            type,
            priority,
            status: 'created',
            createdAt: new Date(),
            steps: this.generateSteps(type),
            automation: type.includes('automation') || type.includes('test')
        };

        this.tasks.push(task);
        this.metrics.tasksCreated++;
        
        console.log(`📝 Tarefa criada: ${task.id} - ${description}`);
        return task;
    }

    generateSteps(type) {
        const templates = this.config.automation?.task_templates || {};
        
        if (templates[type]) {
            return templates[type].steps;
        }

        // Steps padrão baseado no tipo
        switch (type) {
            case 'web_testing':
                return ['navigate', 'interact', 'validate', 'screenshot'];
            case 'form_automation':
                return ['navigate', 'fill_form', 'submit', 'validate_response'];
            case 'multi_browser_test':
                return ['setup_browsers', 'parallel_execution', 'compare_results'];
            default:
                return ['analyze', 'plan', 'execute', 'validate'];
        }
    }

    async executeTask(taskId) {
        const task = this.tasks.find(t => t.id === taskId);
        if (!task) {
            throw new Error(`Tarefa ${taskId} não encontrada`);
        }

        console.log(`🎯 Executando tarefa: ${task.description}`);
        this.currentTask = task;
        task.status = 'executing';
        task.startedAt = new Date();

        try {
            if (task.automation && this.automation) {
                await this.executeAutomationTask(task);
            } else {
                await this.executeManualTask(task);
            }

            task.status = 'completed';
            task.completedAt = new Date();
            this.metrics.tasksCompleted++;
            
            console.log(`✅ Tarefa concluída: ${task.id}`);
            return { success: true, task };
        } catch (error) {
            task.status = 'failed';
            task.error = error.message;
            this.metrics.errorsEncountered++;
            
            console.error(`❌ Erro na tarefa ${task.id}:`, error.message);
            return { success: false, error: error.message, task };
        }
    }

    async executeAutomationTask(task) {
        if (!this.automation) {
            throw new Error('Automação não inicializada');
        }

        console.log('🎭 Executando tarefa de automação...');
        
        // Inicializar browser se necessário
        if (!this.automation.browser) {
            await this.automation.init('chromium');
        }

        // Executar steps da tarefa
        for (const step of task.steps) {
            console.log(`🔄 Executando step: ${step}`);
            await this.executeAutomationStep(step, task);
        }
    }

    async executeAutomationStep(step, task) {
        switch (step) {
            case 'navigate':
                const url = task.url || 'https://example.com';
                await this.automation.navigate(url);
                break;
            
            case 'screenshot':
                await this.automation.screenshot(`task-${task.id}-${step}`);
                break;
            
            case 'interact':
                // Implementar interações específicas baseadas na tarefa
                console.log('🖱️ Executando interações...');
                break;
            
            case 'validate':
                console.log('✅ Validando resultados...');
                break;
            
            default:
                console.log(`⚠️ Step não implementado: ${step}`);
        }
    }

    async executeManualTask(task) {
        console.log('📋 Executando tarefa manual...');
        
        // Simular execução de tarefa manual
        for (const step of task.steps) {
            console.log(`📝 Step manual: ${step}`);
            // Aqui seria implementada a lógica específica para cada step
        }
    }

    getNextTask() {
        const pendingTasks = this.tasks.filter(t => t.status === 'created' || t.status === 'pending');
        
        if (pendingTasks.length === 0) {
            return null;
        }

        // Priorizar por prioridade e data de criação
        return pendingTasks.sort((a, b) => {
            const priorityOrder = { high: 3, medium: 2, low: 1 };
            const aPriority = priorityOrder[a.priority] || 1;
            const bPriority = priorityOrder[b.priority] || 1;
            
            if (aPriority !== bPriority) {
                return bPriority - aPriority;
            }
            
            return new Date(a.createdAt) - new Date(b.createdAt);
        })[0];
    }

    getMetrics() {
        this.metrics.successRate = this.metrics.tasksCreated > 0 
            ? (this.metrics.tasksCompleted / this.metrics.tasksCreated * 100).toFixed(2)
            : 0;

        return {
            ...this.metrics,
            totalTasks: this.tasks.length,
            pendingTasks: this.tasks.filter(t => t.status === 'created' || t.status === 'pending').length,
            completedTasks: this.tasks.filter(t => t.status === 'completed').length,
            failedTasks: this.tasks.filter(t => t.status === 'failed').length
        };
    }

    async generateReport() {
        const metrics = this.getMetrics();
        const report = {
            timestamp: new Date().toISOString(),
            project: this.config.project.name,
            metrics,
            tasks: this.tasks.map(t => ({
                id: t.id,
                description: t.description,
                type: t.type,
                status: t.status,
                createdAt: t.createdAt,
                completedAt: t.completedAt
            }))
        };

        // Salvar relatório
        const reportPath = `reports/task-master-report-${Date.now()}.json`;
        if (!fs.existsSync('reports')) {
            fs.mkdirSync('reports', { recursive: true });
        }
        
        fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
        console.log(`📊 Relatório gerado: ${reportPath}`);
        
        return report;
    }

    async cleanup() {
        if (this.automation) {
            await this.automation.close();
        }
        console.log('🧹 Cleanup concluído');
    }
}

module.exports = TaskMasterManager;
