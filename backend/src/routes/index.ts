import { Router } from 'express';
import { healthRouter }   from './health.route.js';
import { authRouter }     from './auth.route.js';
import { productsRouter } from './products.route.js';
import { ordersRouter }   from './orders.route.js';

const router = Router();

router.use('/health',   healthRouter);
router.use('/auth',     authRouter);
router.use('/products', productsRouter);
router.use('/orders',   ordersRouter);

export const apiRouter = router;