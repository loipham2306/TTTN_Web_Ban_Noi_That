import express from 'express';
import cors from 'cors';
import { ENV } from './config/env.js';
import { apiRouter } from './routes/index.js';
import { notFoundMiddleware } from './middlewares/notFound.middleware.js';
import { errorMiddleware } from './middlewares/error.middleware.js';

export const app = express();

app.use(cors({ origin: ENV.CORS_ORIGIN, credentials: true }));
app.use(express.json());

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
