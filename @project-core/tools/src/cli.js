#!/usr/bin/env node

const { Command } = require('commander');
const program = new Command();
const taskService = require('./services/taskService');

program
  .name('task-master-ai')
  .description('CLI for managing tasks with AI optimization')
  .version('1.0.0');

program
  .command('add <title> <description>')
  .description('Add a new task')
  .option('-s, --status <status>', 'Status of the task (pending, in-progress, done, etc.)', 'pending')
  .option('-p, --priority <priority>', 'Priority of the task (high, medium, low)', 'medium')
  .option('-d, --dependencies <ids>', 'Comma-separated list of task IDs this task depends on')
  .action(async (title, description, options) => {
    try {
      const dependencies = options.dependencies ? options.dependencies.split(',').map(Number) : [];
      const task = await taskService.createTask(title, description, options.status, options.priority, dependencies);
      console.log('Tarefa adicionada:', JSON.stringify(task, null, 2));
    } catch (error) {
      console.error('Erro ao adicionar tarefa:', error.message);
    }
  });

program
  .command('list')
  .description('List all tasks')
  .action(async () => {
    try {
      const tasks = await taskService.getAllTasks();
      if (tasks.length === 0) {
        console.log('Nenhuma tarefa encontrada.');
        return;
      }
      tasks.forEach(task => {
        console.log(`ID: ${task.id}, Título: ${task.title}, Status: ${task.status}, Prioridade: ${task.priority}, Dependências: ${task.dependencies.join(', ')}`);
      });
    } catch (error) {
      console.error('Erro ao listar tarefas:', error.message);
    }
  });

program
  .command('show <id>')
  .description('Show details of a task')
  .action(async (id) => {
    try {
      const task = await taskService.getTask(Number(id));
      if (!task) {
        console.log(`Tarefa com ID ${id} não encontrada.`);
        return;
      }
      console.log('Detalhes da Tarefa:', JSON.stringify(task, null, 2));
    } catch (error) {
      console.error('Erro ao mostrar tarefa:', error.message);
    }
  });

program
  .command('update <id>')
  .description('Update a task')
  .option('-t, --title <title>', 'New title for the task')
  .option('-d, --description <description>', 'New description for the task')
  .option('-s, --status <status>', 'New status for the task')
  .option('-p, --priority <priority>', 'New priority for the task')
  .option('-e, --dependencies <ids>', 'New comma-separated list of task IDs this task depends on')
  .action(async (id, options) => {
    try {
      const updates = {};
      if (options.title) updates.title = options.title;
      if (options.description) updates.description = options.description;
      if (options.status) updates.status = options.status;
      if (options.priority) updates.priority = options.priority;
      if (options.dependencies) updates.dependencies = options.dependencies.split(',').map(Number);

      const updatedTask = await taskService.updateTask(Number(id), updates);
      if (!updatedTask) {
        console.log(`Tarefa com ID ${id} não encontrada.`);
        return;
      }
      console.log('Tarefa atualizada:', JSON.stringify(updatedTask, null, 2));
    } catch (error) {
      console.error('Erro ao atualizar tarefa:', error.message);
    }
  });

program
  .command('delete <id>')
  .description('Delete a task')
  .action(async (id) => {
    try {
      const deleted = await taskService.deleteTask(Number(id));
      if (!deleted) {
        console.log(`Tarefa com ID ${id} não encontrada.`);
        return;
      }
      console.log(`Tarefa com ID ${id} excluída com sucesso.`);
    } catch (error) {
      console.error('Erro ao excluir tarefa:', error.message);
    }
  });

program.parse(process.argv);
