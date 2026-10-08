import { Router } from 'express';
import { healthRouter } from './health.route.js';

const router = Router();

router.use('/health', healthRouter);
// TODO: Mount products, orders, shipping, phong-thuy, admin routes

export const apiRouter = router;
