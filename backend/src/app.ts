import express from 'express';
import cors from 'cors';
import { ENV } from './config/env.js';
import { apiRouter } from './routes/index.js';
import { notFoundMiddleware } from './middlewares/notFound.middleware.js';
import { errorMiddleware } from './middlewares/error.middleware.js';

export const app = express();

app.use(cors({ origin: ENV.CORS_ORIGIN, credentials: true }));
app.use(express.json());

app.use('/api', apiRouter);

app.use(notFoundMiddleware);
app.use(errorMiddleware);
