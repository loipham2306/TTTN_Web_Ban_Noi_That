import express from 'express';
import cors from 'cors';
import path from 'path';
import { ENV } from './config/env.js';
import { apiRouter } from './routes/index.js';
import { notFoundMiddleware } from './middlewares/notFound.middleware.js';
import { errorMiddleware } from './middlewares/error.middleware.js';

export const app = express();

const allowedOrigins = [
  ENV.CORS_ORIGIN,
  'http://localhost:4321',
  'http://127.0.0.1:4321',
  'http://localhost:3000',
  'http://localhost:5173',
];

app.use(
  cors({
    origin: (origin, callback) => {
      // Cho phép requests không có origin (curl, postman, mobile)
      if (!origin) return callback(null, true);
      if (
        allowedOrigins.includes(origin) ||
        origin.startsWith('http://localhost:') ||
        origin.startsWith('http://127.0.0.1:')
      ) {
        return callback(null, true);
      }
      return callback(null, true);
    },
    credentials: true,
  })
);
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Serve uploaded static files
app.use('/uploads', express.static(path.join(process.cwd(), 'uploads')));

app.get('/', (_req, res) => {
  res.json({
    status: 'success',
    message: 'Máy chủ Backend API Nội Thất đang hoạt động bình thường!',
    frontend: 'http://localhost:4321',
    endpoints: {
      health: 'http://localhost:4000/api/health',
      products: 'http://localhost:4000/api/products',
      orders: 'http://localhost:4000/api/orders',
      auth_customers: 'http://localhost:4000/api/auth/customers',
    },
  });
});

app.use('/api', apiRouter);

app.use(notFoundMiddleware);
app.use(errorMiddleware);
