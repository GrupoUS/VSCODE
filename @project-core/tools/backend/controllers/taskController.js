const Task = require('../models/Task');
const { z } = require('zod'); // Precisará instalar o zod
const mongoose = require('mongoose');

// Schemas de validação com Zod
const createTaskSchema = z.object({
  title: z.string().min(1, "O título é obrigatório."),
  description: z.string().optional(),
  status: z.enum(['pending', 'in-progress', 'done', 'archived']).default('pending'),
  dueDate: z.string().datetime().optional(),
  assignedTo: z.string().optional(), // Será validado como ObjectId no controller
  clinicId: z.string().uuid("ID da clínica inválido."), // Será validado como ObjectId no controller
});

const updateTaskSchema = z.object({
  title: z.string().min(1, "O título é obrigatório.").optional(),
  description: z.string().optional(),
  status: z.enum(['pending', 'in-progress', 'done', 'archived']).optional(),
  dueDate: z.string().datetime().optional(),
  assignedTo: z.string().optional(),
});

// Função auxiliar para tratamento de erros
const handleControllerError = (res, error) => {
  if (error instanceof z.ZodError) {
    return res.status(400).json({ error: error.errors });
  }
  if (error.name === 'CastError' && error.kind === 'ObjectId') {
    return res.status(400).json({ error: 'ID inválido.' });
  }
  console.error(error);
  return res.status(500).json({ error: 'Erro interno do servidor.' });
};

// @desc    Criar uma nova tarefa
// @route   POST /api/tasks
// @access  Private (Clinic Owner/Staff)
exports.createTask = async (req, res) => {
  try {
    const validatedData = createTaskSchema.parse(req.body);

    // Validação adicional para ObjectId
    if (validatedData.assignedTo && !mongoose.Types.ObjectId.isValid(validatedData.assignedTo)) {
      return res.status(400).json({ error: 'ID de usuário atribuído inválido.' });
    }
    if (!mongoose.Types.ObjectId.isValid(validatedData.clinicId)) {
      return res.status(400).json({ error: 'ID da clínica inválido.' });
    }

    const task = await Task.create(validatedData);
    res.status(201).json(task);
  } catch (error) {
    handleControllerError(res, error);
  }
};

// @desc    Listar todas as tarefas
// @route   GET /api/tasks
// @access  Private (Clinic Owner/Staff)
exports.getTasks = async (req, res) => {
  try {
    const { clinicId, status, assignedTo, search, page = 1, limit = 10 } = req.query;

    if (!clinicId || !mongoose.Types.ObjectId.isValid(clinicId)) {
      return res.status(400).json({ error: 'ID da clínica é obrigatório e deve ser válido.' });
    }

    const query = { clinicId };

    if (status) {
      query.status = status;
    }
    if (assignedTo && mongoose.Types.ObjectId.isValid(assignedTo)) {
      query.assignedTo = assignedTo;
    }
    if (search) {
      query.title = { $regex: search, $options: 'i' }; // Busca case-insensitive no título
    }

    const tasks = await Task.find(query)
      .limit(parseInt(limit))
      .skip((parseInt(page) - 1) * parseInt(limit))
      .sort({ createdAt: -1 });

    const total = await Task.countDocuments(query);

    res.status(200).json({
      data: tasks,
      total,
      page: parseInt(page),
      totalPages: Math.ceil(total / parseInt(limit)),
    });
  } catch (error) {
    handleControllerError(res, error);
  }
};

// @desc    Obter tarefa por ID
// @route   GET /api/tasks/:id
// @access  Private (Clinic Owner/Staff)
exports.getTaskById = async (req, res) => {
  try {
    const { id } = req.params;
    const { clinicId } = req.query; // Adicionado clinicId para RLS

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ error: 'ID da tarefa inválido.' });
    }
    if (!clinicId || !mongoose.Types.ObjectId.isValid(clinicId)) {
      return res.status(400).json({ error: 'ID da clínica é obrigatório e deve ser válido.' });
    }

    const task = await Task.findOne({ _id: id, clinicId });

    if (!task) {
      return res.status(404).json({ error: 'Tarefa não encontrada.' });
    }

    res.status(200).json(task);
  } catch (error) {
    handleControllerError(res, error);
  }
};

// @desc    Atualizar uma tarefa
// @route   PUT /api/tasks/:id
// @access  Private (Clinic Owner/Staff)
exports.updateTask = async (req, res) => {
  try {
    const { id } = req.params;
    const { clinicId } = req.body; // Adicionado clinicId para RLS

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ error: 'ID da tarefa inválido.' });
    }
    if (!clinicId || !mongoose.Types.ObjectId.isValid(clinicId)) {
      return res.status(400).json({ error: 'ID da clínica é obrigatório e deve ser válido.' });
    }

    const validatedData = updateTaskSchema.parse(req.body);

    if (validatedData.assignedTo && !mongoose.Types.ObjectId.isValid(validatedData.assignedTo)) {
      return res.status(400).json({ error: 'ID de usuário atribuído inválido.' });
    }

    const task = await Task.findOneAndUpdate(
      { _id: id, clinicId },
      { $set: validatedData },
      { new: true, runValidators: true }
    );

    if (!task) {
      return res.status(404).json({ error: 'Tarefa não encontrada.' });
    }

    res.status(200).json(task);
  } catch (error) {
    handleControllerError(res, error);
  }
};

// @desc    Excluir uma tarefa
// @route   DELETE /api/tasks/:id
// @access  Private (Clinic Owner/Staff)
exports.deleteTask = async (req, res) => {
  try {
    const { id } = req.params;
    const { clinicId } = req.query; // Adicionado clinicId para RLS

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ error: 'ID da tarefa inválido.' });
    }
    if (!clinicId || !mongoose.Types.ObjectId.isValid(clinicId)) {
      return res.status(400).json({ error: 'ID da clínica é obrigatório e deve ser válido.' });
    }

    const task = await Task.findOneAndDelete({ _id: id, clinicId });

    if (!task) {
      return res.status(404).json({ error: 'Tarefa não encontrada.' });
    }

    res.status(200).json({ message: 'Tarefa removida com sucesso.' });
  } catch (error) {
    handleControllerError(res, error);
  }
};