const {
  createTask,
  getTasks,
  getTaskById,
  updateTask,
  deleteTask,
} = require('../../controllers/taskController');
const Task = require('../../models/Task');
const { ZodError } = require('zod');

// Mock do modelo Task
jest.mock('../../models/Task');

describe('Task Controller Unit Tests', () => {
  let mockReq, mockRes, mockNext;

  beforeEach(() => {
    mockReq = {
      body: {},
      params: {},
      query: {},
    };
    mockRes = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    };
    mockNext = jest.fn();
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  // Testes para createTask
  describe('createTask', () => {
    it('should create a new task successfully', async () => {
      const newTaskData = {
        title: 'Test Task',
        description: 'This is a test description.',
        clinicId: 'someClinicId',
        assignedTo: 'someUserId',
        status: 'pending',
      };
      mockReq.body = newTaskData;

      const savedTask = { _id: 'newTaskId', ...newTaskData, createdAt: new Date() };
      Task.create.mockResolvedValue(savedTask);

      await createTask(mockReq, mockRes, mockNext);

      expect(Task.create).toHaveBeenCalledWith(newTaskData);
      expect(mockRes.status).toHaveBeenCalledWith(201);
      expect(mockRes.json).toHaveBeenCalledWith(savedTask);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should handle ZodError for invalid input', async () => {
      mockReq.body = {
        title: 'Short', // Invalid title
        description: 123, // Invalid description type
      };

      await createTask(mockReq, mockRes, mockNext);

      expect(Task.create).not.toHaveBeenCalled();
      expect(mockRes.status).toHaveBeenCalledWith(400);
      expect(mockRes.json).toHaveBeenCalledWith(expect.objectContaining({
        error: expect.any(Array),
      }));
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should handle other errors during task creation', async () => {
      const error = new Error('Database connection failed');
      Task.create.mockRejectedValue(error);
      mockReq.body = {
        title: 'Valid Task',
        description: 'Valid description',
        clinicId: 'someClinicId',
        assignedTo: 'someUserId',
        status: 'pending',
      };

      await createTask(mockReq, mockRes, mockNext);

      expect(Task.create).toHaveBeenCalled();
      expect(mockRes.status).toHaveBeenCalledWith(500);
      expect(mockRes.json).toHaveBeenCalledWith({ error: 'Internal server error' });
      expect(mockNext).not.toHaveBeenCalled();
    });
  });

  // Testes para getTasks
  describe('getTasks', () => {
    it('should return a list of tasks with default pagination', async () => {
      const tasks = [{ _id: '1', title: 'Task 1' }, { _id: '2', title: 'Task 2' }];
      Task.find.mockReturnThis();
      Task.countDocuments.mockResolvedValue(2);
      Task.skip.mockReturnThis();
      Task.limit.mockResolvedValue(tasks);

      await getTasks(mockReq, mockRes, mockNext);

      expect(Task.find).toHaveBeenCalledWith({});
      expect(Task.skip).toHaveBeenCalledWith(0);
      expect(Task.limit).toHaveBeenCalledWith(20);
      expect(mockRes.status).toHaveBeenCalledWith(200);
      expect(mockRes.json).toHaveBeenCalledWith({
        data: tasks,
        total: 2,
        page: 1,
        totalPages: 1,
      });
    });

    it('should filter tasks by clinicId and status', async () => {
      mockReq.query = { clinicId: 'clinic123', status: 'completed' };
      const tasks = [{ _id: '1', clinicId: 'clinic123', status: 'completed' }];
      Task.find.mockReturnThis();
      Task.countDocuments.mockResolvedValue(1);
      Task.skip.mockReturnThis();
      Task.limit.mockResolvedValue(tasks);

      await getTasks(mockReq, mockRes, mockNext);

      expect(Task.find).toHaveBeenCalledWith({ clinicId: 'clinic123', status: 'completed' });
      expect(mockRes.status).toHaveBeenCalledWith(200);
      expect(mockRes.json).toHaveBeenCalledWith({
        data: tasks,
        total: 1,
        page: 1,
        totalPages: 1,
      });
    });

    it('should handle errors during task retrieval', async () => {
      const error = new Error('Network error');
      Task.find.mockRejectedValue(error);

      await getTasks(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(500);
      expect(mockRes.json).toHaveBeenCalledWith({ error: 'Internal server error' });
    });
  });

  // Testes para getTaskById
  describe('getTaskById', () => {
    it('should return a task if found', async () => {
      const task = { _id: 'taskId123', title: 'Specific Task' };
      mockReq.params.id = 'taskId123';
      Task.findById.mockResolvedValue(task);

      await getTaskById(mockReq, mockRes, mockNext);

      expect(Task.findById).toHaveBeenCalledWith('taskId123');
      expect(mockRes.status).toHaveBeenCalledWith(200);
      expect(mockRes.json).toHaveBeenCalledWith(task);
    });

    it('should return 404 if task not found', async () => {
      mockReq.params.id = 'nonExistentId';
      Task.findById.mockResolvedValue(null);

      await getTaskById(mockReq, mockRes, mockNext);

      expect(Task.findById).toHaveBeenCalledWith('nonExistentId');
      expect(mockRes.status).toHaveBeenCalledWith(404);
      expect(mockRes.json).toHaveBeenCalledWith({ error: 'Task not found' });
    });

    it('should handle errors during task retrieval by ID', async () => {
      const error = new Error('DB error');
      mockReq.params.id = 'taskId123';
      Task.findById.mockRejectedValue(error);

      await getTaskById(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(500);
      expect(mockRes.json).toHaveBeenCalledWith({ error: 'Internal server error' });
    });
  });

  // Testes para updateTask
  describe('updateTask', () => {
    it('should update a task successfully', async () => {
      const updatedData = { title: 'Updated Title', status: 'completed' };
      mockReq.params.id = 'taskId123';
      mockReq.body = updatedData;

      const existingTask = { _id: 'taskId123', title: 'Old Title', status: 'pending' };
      const savedTask = { ...existingTask, ...updatedData, updatedAt: new Date() };

      Task.findByIdAndUpdate.mockResolvedValue(savedTask);

      await updateTask(mockReq, mockRes, mockNext);

      expect(Task.findByIdAndUpdate).toHaveBeenCalledWith(
        'taskId123',
        { ...updatedData, updatedAt: expect.any(Date) },
        { new: true, runValidators: true }
      );
      expect(mockRes.status).toHaveBeenCalledWith(200);
      expect(mockRes.json).toHaveBeenCalledWith(savedTask);
    });

    it('should return 404 if task to update not found', async () => {
      mockReq.params.id = 'nonExistentId';
      mockReq.body = { title: 'New Title' };
      Task.findByIdAndUpdate.mockResolvedValue(null);

      await updateTask(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(404);
      expect(mockRes.json).toHaveBeenCalledWith({ error: 'Task not found' });
    });

    it('should handle ZodError for invalid update input', async () => {
      mockReq.params.id = 'taskId123';
      mockReq.body = { title: 123 }; // Invalid type

      await updateTask(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(400);
      expect(mockRes.json).toHaveBeenCalledWith(expect.objectContaining({
        error: expect.any(Array),
      }));
    });

    it('should handle other errors during task update', async () => {
      const error = new Error('Update failed');
      mockReq.params.id = 'taskId123';
      mockReq.body = { title: 'Valid Update' };
      Task.findByIdAndUpdate.mockRejectedValue(error);

      await updateTask(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(500);
      expect(mockRes.json).toHaveBeenCalledWith({ error: 'Internal server error' });
    });
  });

  // Testes para deleteTask
  describe('deleteTask', () => {
    it('should delete a task successfully', async () => {
      const deletedTask = { _id: 'taskId123', title: 'Task to Delete' };
      mockReq.params.id = 'taskId123';
      Task.findByIdAndDelete.mockResolvedValue(deletedTask);

      await deleteTask(mockReq, mockRes, mockNext);

      expect(Task.findByIdAndDelete).toHaveBeenCalledWith('taskId123');
      expect(mockRes.status).toHaveBeenCalledWith(200);
      expect(mockRes.json).toHaveBeenCalledWith({ message: 'Task deleted successfully' });
    });

    it('should return 404 if task to delete not found', async () => {
      mockReq.params.id = 'nonExistentId';
      Task.findByIdAndDelete.mockResolvedValue(null);

      await deleteTask(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(404);
      expect(mockRes.json).toHaveBeenCalledWith({ error: 'Task not found' });
    });

    it('should handle errors during task deletion', async () => {
      const error = new Error('Deletion failed');
      mockReq.params.id = 'taskId123';
      Task.findByIdAndDelete.mockRejectedValue(error);

      await deleteTask(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(500);
      expect(mockRes.json).toHaveBeenCalledWith({ error: 'Internal server error' });
    });
  });
});