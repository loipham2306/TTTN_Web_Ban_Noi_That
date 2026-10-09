import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';

export const authRouter = Router();

// POST /api/auth/register
authRouter.post('/register', async (req: Request, res: Response) => {
  try {
    const { fullname, email, phone, password } = req.body;

    if (!email || !password || !fullname) {
      return res.status(400).json({ success: false, message: 'Vui lòng điền đầy đủ họ tên, email và mật khẩu.' });
    }

    // Check if email already exists
    const existing = await prisma.users.findUnique({
      where: { email },
    });

    if (existing) {
      return res.status(409).json({ success: false, message: 'Email này đã được đăng ký tài khoản.' });
    }

    // Default customer role_id = 2 (or find by name 'customer')
    let customerRole = await prisma.roles.findFirst({
      where: { name: 'customer' },
    });

    if (!customerRole) {
      customerRole = await prisma.roles.findFirst();
    }

    const newUser = await prisma.users.create({
      data: {
        full_name: fullname,
        email,
        phone: phone || null,
        password_hash: password, // In production, hash with bcrypt
        role_id: customerRole ? customerRole.id : 1,
        status: true,
      },
    });

    return res.status(201).json({
      success: true,
      message: 'Đăng ký tài khoản thành công!',
      user: {
        id: Number(newUser.id),
        email: newUser.email,
        full_name: newUser.full_name,
        phone: newUser.phone,
      },
    });
  } catch (error: any) {
    console.error('Lỗi đăng ký:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi đăng ký tài khoản.', error: error.message });
  }
});

// POST /api/auth/login
authRouter.post('/login', async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ success: false, message: 'Vui lòng nhập email và mật khẩu.' });
    }

    const user = await prisma.users.findUnique({
      where: { email },
      include: { roles: true },
    });

    if (!user || user.password_hash !== password) {
      return res.status(401).json({ success: false, message: 'Email hoặc mật khẩu không chính xác.' });
    }

    return res.json({
      success: true,
      message: 'Đăng nhập thành công!',
      user: {
        id: Number(user.id),
        email: user.email,
        full_name: user.full_name,
        phone: user.phone,
        role: user.roles?.name || 'customer',
      },
    });
  } catch (error: any) {
    console.error('Lỗi đăng nhập:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi đăng nhập.', error: error.message });
  }
});

// GET /api/auth/customers - Get registered customers for Admin
authRouter.get('/customers', async (_req: Request, res: Response) => {
  try {
    const customers = await prisma.users.findMany({
      include: {
        orders: true,
      },
      orderBy: { created_at: 'desc' },
    });

    const formatted = customers.map((c) => ({
      id: `KH-${c.id}`,
      name: c.full_name,
      email: c.email,
      phone: c.phone || 'Chưa cập nhật',
      ordersCount: c.orders.length,
      totalSpent: c.orders.reduce((sum, o) => sum + Number(o.total_amount), 0),
      createdAt: c.created_at,
    }));

    return res.json({ success: true, data: formatted });
  } catch (error: any) {
    console.error('Lỗi lấy danh sách khách hàng:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});
