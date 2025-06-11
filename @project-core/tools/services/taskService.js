const fs = require('fs').promises;
const path = require('path');
const Task = require('../models/task');

// Use an environment variable or default to the main tasks file
const TASKS_FILE = process.env.NODE_ENV === 'test' 
  ? path.join(__dirname, '../.taskmaster/tasks-test/tasks.test.json')
  : path.join(__dirname, '../.taskmaster/tasks/tasks.json');

async function readTasksFromFile() {
  try {
    const data = await fs.readFile(TASKS_FILE, 'utf8');
    return JSON.parse(data);
  } catch (error) {
    if (error.code === 'ENOENT') {
      // If file or directory does not exist, create the directory and return empty array
      await fs.mkdir(path.dirname(TASKS_FILE), { recursive: true });
      return [];
    }
    throw error;
  }
}

async function writeTasksToFile(tasks) {
  await fs.writeFile(TASKS_FILE, JSON.stringify(tasks, null, 2), 'utf8');
}

async function createTask(title, description, status, priority, dependencies) {
  const tasks = await readTasksFromFile();
  const id = tasks.length > 0 ? Math.max(...tasks.map(task => task.id)) + 1 : 1;
  const newTask = new Task(id, title, description, status, priority, dependencies);
  tasks.push(newTask);
  await writeTasksToFile(tasks);
  return newTask;
}

async function getTask(id) {
  const tasks = await readTasksFromFile();
  return tasks.find(task => task.id === id);
}

async function getAllTasks() {
  return await readTasksFromFile();
}

async function updateTask(id, updates) {
  const tasks = await readTasksFromFile();
  const taskIndex = tasks.findIndex(task => task.id === id);

  if (taskIndex === -1) {
    return null; // Task not found
  }

  tasks[taskIndex] = { ...tasks[taskIndex], ...updates };
  await writeTasksToFile(tasks);
  return tasks[taskIndex];
}

async function deleteTask(id) {
  let tasks = await readTasksFromFile();
  const initialLength = tasks.length;
  tasks = tasks.filter(task => task.id !== id);

  if (tasks.length === initialLength) {
    return false; // Task not found
  }

  await writeTasksToFile(tasks);
  return true; // Task deleted
}

module.exports = {
  createTask,
  getTask,
  getAllTasks,
  updateTask,
  deleteTask,
};
