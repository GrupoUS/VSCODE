const express = require('express');
const dotenv = require('dotenv');

dotenv.config();

const connectDB = require('./config/db');

connectDB();

const rateLimit = require('express-rate-limit');

const app = express();
const PORT = process.env.PORT || 3000;

// Configuração do limitador de taxa
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100, // Limite de 100 requisições por IP a cada 15 minutos
  message: 'Too many requests from this IP, please try again after 15 minutes',
});

app.use(express.json());

// Aplicar o limitador de taxa a todas as requisições
app.use(limiter);

// Middleware para log de tempo de resposta
app.use((req, res, next) => {
  const start = process.hrtime();
  res.on('finish', () => {
    const diff = process.hrtime(start);
    const responseTime = (diff[0] * 1e9 + diff[1]) / 1e6; // Convert to milliseconds
    console.log(`${req.method} ${req.originalUrl} - ${responseTime.toFixed(2)}ms`);
  });
  next();
});

const authRoutes = require('./routes/authRoutes');
const productRoutes = require('./routes/productRoutes');
const taskRoutes = require('./routes/taskRoutes'); // Adiciona a rota de tarefas

app.use('/api/auth', authRoutes);
app.use('/api/products', productRoutes);
app.use('/api/tasks', taskRoutes); // Usa a rota de tarefas

app.get('/', (req, res) => {
  res.send('API is running...');
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
