const path = require('path');
const fs = require('fs').promises;

// Set NODE_ENV to 'test' before requiring any modules that depend on it
process.env.NODE_ENV = 'test';

const { execa } = require('execa'); // Keep this one
// const path = require('path'); // Remove duplicate
// const fs = require('fs').promises; // Remove duplicate

const CLI_PATH = path.join(__dirname, '../cli.js');
const TASKS_FILE = path.join(__dirname, '../.taskmaster/tasks-test/tasks.test.json'); // Use test-specific file

describe('CLI End-to-End Tests', () => {
  // Clean up tasks.json before each test to ensure a clean state
  beforeEach(async () => {
    try {
      await fs.writeFile(TASKS_FILE, '[]', 'utf8');
    } catch (error) {
      if (error.code === 'ENOENT') {
        // Directory might not exist, create it
        await fs.mkdir(path.dirname(TASKS_FILE), { recursive: true });
        await fs.writeFile(TASKS_FILE, '[]', 'utf8');
      } else {
        throw error;
      }
    }
  });

  it('should add a task and list it', async () => {
    // Add a task
    const addResult = await execa('node', [CLI_PATH, 'add', 'E2E Task', 'E2E Description']);
    expect(addResult.stdout).toContain('Tarefa adicionada:');

    // List tasks and verify
    const listResult = await execa('node', [CLI_PATH, 'list']);
    expect(listResult.stdout).toContain('ID: 1, Título: E2E Task, Status: pending, Prioridade: medium, Dependências: ');
  });

  it('should show details of a specific task', async () => {
    // Add a task first
    await execa('node', [CLI_PATH, 'add', 'Task to Show', 'Description to Show']);

    // Show task details
    const showResult = await execa('node', [CLI_PATH, 'show', '1']);
    expect(showResult.stdout).toContain('Detalhes da Tarefa:');
    // Extract and parse the JSON object from the stdout
    const match = showResult.stdout.match(/\{[\s\S]*\}/);
    expect(match).toBeDefined(); // Ensure a match was found
    const taskDetailsOutput = JSON.parse(match[0]);
    expect(taskDetailsOutput.title).toBe('Task to Show');
    expect(taskDetailsOutput.description).toBe('Description to Show');
  });

  it('should update an existing task', async () => {
    // Add a task
    await execa('node', [CLI_PATH, 'add', 'Old Task', 'Old Description']);

    // Update the task
    const updateResult = await execa('node', [CLI_PATH, 'update', '1', '--title', 'Updated Task', '--status', 'done']);
    // console.log('updateResult.stdout:', updateResult.stdout); // Temporary log - remove after debugging
    expect(updateResult.stdout).toContain('Tarefa atualizada:');
    // Extract and parse the JSON object from the stdout
    const matchUpdate = updateResult.stdout.match(/\{[\s\S]*\}/);
    expect(matchUpdate).toBeDefined(); // Ensure a match was found
    const updatedTaskOutput = JSON.parse(matchUpdate[0]);
    expect(updatedTaskOutput.title).toBe('Updated Task');
    expect(updatedTaskOutput.status).toBe('done');

    // Verify the update by listing tasks
    const listResult = await execa('node', [CLI_PATH, 'list']);
    expect(listResult.stdout).toContain('ID: 1, Título: Updated Task, Status: done, Prioridade: medium, Dependências: ');
  });

  it('should delete an existing task', async () => {
    // Add a task
    await execa('node', [CLI_PATH, 'add', 'Task to Delete', 'Description to Delete']);

    // Delete the task
    const deleteResult = await execa('node', [CLI_PATH, 'delete', '1']);
    expect(deleteResult.stdout).toContain('Tarefa com ID 1 excluída com sucesso.');

    // Verify deletion by listing tasks
    const listResult = await execa('node', [CLI_PATH, 'list']);
    expect(listResult.stdout).toContain('Nenhuma tarefa encontrada.'); // Should be empty
  });

  it('should handle invalid command inputs', async () => {
    // Test adding a task with missing arguments
    await expect(execa('node', [CLI_PATH, 'add', 'MissingArg'])).rejects.toThrow(/missing required argument 'description'/);

    // Test showing a non-existent task
    const showNonExistentResult = await execa('node', [CLI_PATH, 'show', '999']);
    expect(showNonExistentResult.stdout).toContain('Tarefa com ID 999 não encontrada.');

    // Test updating a non-existent task
    const updateNonExistentResult = await execa('node', [CLI_PATH, 'update', '999', '--title', 'Non Existent']);
    expect(updateNonExistentResult.stdout).toContain('Tarefa com ID 999 não encontrada.');

    // Test deleting a non-existent task
    const deleteNonExistentResult = await execa('node', [CLI_PATH, 'delete', '999']);
    expect(deleteNonExistentResult.stdout).toContain('Tarefa com ID 999 não encontrada.');
  });
});
