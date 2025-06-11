const Task = require('./task');
const fs = require('fs');
const path = require('path');

class TaskManager {
    constructor() {
        this.tasks = [];
        this.nextTaskId = 1;
        this.tasksDir = path.join(__dirname, '..', '.taskmaster', 'tasks');
        if (!fs.existsSync(this.tasksDir)) {
            fs.mkdirSync(this.tasksDir, { recursive: true });
        }
    }

    addTask(title, description, dependencies = []) {
        const id = this.nextTaskId++;
        const newTask = new Task(id, title, description, 'pending', dependencies);
        this.tasks.push(newTask);
        this.saveTaskToFile(newTask);
        return newTask;
    }

    updateTask(id, newTitle, newDescription, newStatus, newDependencies) {
        const taskIndex = this.tasks.findIndex(task => task.id === id);
        if (taskIndex === -1) {
            console.log(`Task with ID ${id} not found.`);
            return null;
        }

        const task = this.tasks[taskIndex];
        task.title = newTitle !== undefined ? newTitle : task.title;
        task.description = newDescription !== undefined ? newDescription : task.description;
        task.status = newStatus !== undefined ? newStatus : task.status;
        task.dependencies = newDependencies !== undefined ? newDependencies : task.dependencies;
        
        this.saveTaskToFile(task);
        return task;
    }

    listTasks() {
        return this.tasks;
    }

    generateMarkdown(task) {
        let markdown = `# Task ID: ${task.id}\n`;
        markdown += `## Title: ${task.title}\n`;
        markdown += `## Description: ${task.description}\n`;
        markdown += `## Status: ${task.status}\n`;
        if (task.dependencies && task.dependencies.length > 0) {
            markdown += `## Dependencies: ${task.dependencies.join(', ')}\n`;
        }
        return markdown;
    }

    saveTaskToFile(task) {
        const markdownContent = this.generateMarkdown(task);
        const fileName = `task_${task.id}.md`;
        const filePath = path.join(this.tasksDir, fileName);
        fs.writeFileSync(filePath, markdownContent);
        console.log(`Task ${task.id} saved to ${filePath}`);
    }
}

module.exports = TaskManager;
