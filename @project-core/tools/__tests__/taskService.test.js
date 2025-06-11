const path = require('path');

const TASKS_FILE = path.join(__dirname, '../.taskmaster/tasks-test/tasks.test.json');

// Mock fs to control file system operations
jest.mock('fs', () => ({
  promises: {
    readFile: jest.fn(),
    writeFile: jest.fn(),
  },
}));

const fs = require('fs'); // Import fs AFTER mocking
const taskService = require('../services/taskService'); // Import taskService AFTER mocking

describe('TaskService', () => {
  beforeEach(() => {
    // Reset mocks before each test
    fs.promises.readFile.mockReset();
    fs.promises.writeFile.mockReset();
  });

  it('should create a new task and save it to file', async () => {
    fs.promises.readFile.mockResolvedValueOnce('[]'); // Simulate empty file
    fs.promises.writeFile.mockResolvedValueOnce(undefined); // Simulate successful write

    const newTask = await taskService.createTask('Test Task', 'Description for test task');

    expect(newTask).toBeDefined();
    expect(newTask.id).toBe(1);
    expect(newTask.title).toBe('Test Task');
    expect(newTask.description).toBe('Description for test task');
    expect(newTask.status).toBe('pending');
    expect(newTask.priority).toBe('medium');
    expect(newTask.dependencies).toEqual([]);
    expect(fs.promises.writeFile).toHaveBeenCalledWith(
      TASKS_FILE,
      JSON.stringify([newTask], null, 2),
      'utf8'
    );
  });

  it('should get a task by ID', async () => {
    const mockTasks = [{ id: 1, title: 'Task 1' }, { id: 2, title: 'Task 2' }];
    fs.promises.readFile.mockResolvedValueOnce(JSON.stringify(mockTasks));

    const task = await taskService.getTask(1);
    expect(task).toEqual({ id: 1, title: 'Task 1' });
  });

  it('should return undefined if task not found', async () => {
    const mockTasks = [{ id: 1, title: 'Task 1' }];
    fs.promises.readFile.mockResolvedValueOnce(JSON.stringify(mockTasks));

    const task = await taskService.getTask(99);
    expect(task).toBeUndefined();
  });

  it('should get all tasks', async () => {
    const mockTasks = [{ id: 1, title: 'Task 1' }, { id: 2, title: 'Task 2' }];
    fs.promises.readFile.mockResolvedValueOnce(JSON.stringify(mockTasks));

    const tasks = await taskService.getAllTasks();
    expect(tasks).toEqual(mockTasks);
  });

  it('should update an existing task', async () => {
    const initialTasks = [{ id: 1, title: 'Old Title', status: 'pending' }];
    fs.promises.readFile.mockResolvedValueOnce(JSON.stringify(initialTasks));
    fs.promises.writeFile.mockResolvedValueOnce(undefined);

    const updatedTask = await taskService.updateTask(1, { title: 'New Title', status: 'done' });

    expect(updatedTask.title).toBe('New Title');
    expect(updatedTask.status).toBe('done');
    expect(fs.promises.writeFile).toHaveBeenCalledWith(
      TASKS_FILE,
      JSON.stringify([{ id: 1, title: 'New Title', status: 'done' }], null, 2),
      'utf8'
    );
  });

  it('should return null if updating a non-existent task', async () => {
    fs.promises.readFile.mockResolvedValueOnce('[]');
    const updatedTask = await taskService.updateTask(99, { title: 'Non Existent' });
    expect(updatedTask).toBeNull();
    expect(fs.promises.writeFile).not.toHaveBeenCalled();
  });

  it('should delete an existing task', async () => {
    const initialTasks = [{ id: 1, title: 'Task to Delete' }];
    fs.promises.readFile.mockResolvedValueOnce(JSON.stringify(initialTasks));
    fs.promises.writeFile.mockResolvedValueOnce(undefined);

    const deleted = await taskService.deleteTask(1);
    expect(deleted).toBe(true);
    expect(fs.promises.writeFile).toHaveBeenCalledWith(
      TASKS_FILE,
      JSON.stringify([], null, 2),
      'utf8'
    );
  });

  it('should return false if deleting a non-existent task', async () => {
    fs.promises.readFile.mockResolvedValueOnce('[]');
    const deleted = await taskService.deleteTask(99);
    expect(deleted).toBe(false);
    expect(fs.promises.writeFile).not.toHaveBeenCalled();
  });
});
