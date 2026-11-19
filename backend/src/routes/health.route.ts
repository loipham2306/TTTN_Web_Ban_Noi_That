import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';
import path from 'path';
import fs from 'fs';

const router = Router();

// GET /api/health - Kiểm tra tình trạng kết nối & đo độ trễ MySQL thực tế
router.get('/', async (_req: Request, res: Response) => {
  const startTime = Date.now();
  try {
    // Đo độ trễ query MySQL thực tế
    await prisma.$queryRawUnsafe('SELECT 1');
    const latencyMs = Date.now() - startTime;

    const [productsCount, ordersCount, usersCount] = await Promise.all([
      prisma.products.count({ where: { deleted_at: null } }).catch(() => 0),
      prisma.orders.count().catch(() => 0),
      prisma.users.count({ where: { deleted_at: null } }).catch(() => 0),
    ]);

    return res.json({
      status: 'ok',
      database: {
        status: 'connected',
        host: 'localhost:3306',
        name: 'web_ban_noi_that',
        latencyMs,
        tablesCount: 17,
        productsCount,
        ordersCount,
        usersCount,
      },
      serverTime: new Date().toISOString(),
      uptimeSeconds: Math.floor(process.uptime()),
    });
  } catch (err: any) {
    return res.status(500).json({
      status: 'error',
      database: {
        status: 'disconnected',
        error: err.message,
      },
      serverTime: new Date().toISOString(),
    });
  }
});

// GET /api/health/backup-sql - Xuất và tải trực tiếp file sao lưu CSDL MySQL (.sql)
router.get('/backup-sql', (_req: Request, res: Response) => {
  try {
    const candidatePaths = [
      path.resolve(process.cwd(), 'database/web_ban_noi_that.sql'),
      path.resolve(process.cwd(), '../database/web_ban_noi_that.sql'),
    ];
    const sqlPath = candidatePaths.find((p) => fs.existsSync(p));

    if (!sqlPath) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy file CSDL web_ban_noi_that.sql để sao lưu.' });
    }

    const now = new Date();
    const dateStr = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}${String(now.getDate()).padStart(2, '0')}`;
    const filename = `backup_web_ban_noi_that_${dateStr}.sql`;

    res.setHeader('Content-Type', 'application/sql');
    res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
    const fileStream = fs.createReadStream(sqlPath);
    return fileStream.pipe(res);
  } catch (err: any) {
    console.error('Lỗi sao lưu CSDL:', err);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi sao lưu dữ liệu', error: err.message });
  }
});

export const healthRouter = router;
