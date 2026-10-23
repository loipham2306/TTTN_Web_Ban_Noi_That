import { Router, Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { prisma } from '../config/prisma.js';
import { ENV } from '../config/env.js';
import { verifyToken, requireAdmin } from '../middlewares/auth.middleware.js';
import { authLimiter } from '../middlewares/rateLimit.middleware.js';

export const authRouter = Router();

// Helper tạo JWT Token
const generateToken = (payload: { id: number; email: string; role: string; full_name?: string }, expiresIn: any = '7d') => {
  return jwt.sign(payload, ENV.JWT_SECRET, { expiresIn });
};

// Đảm bảo tài khoản Quản trị viên (Admin) mặc định luôn sẵn sàng
const ensureDefaultAdmin = async () => {
  try {
    const adminRole = await prisma.roles.findFirst({
      where: { name: 'admin' },
    });
    const adminRoleId = adminRole ? adminRole.id : 1;

    const existingAdmin = await prisma.users.findUnique({
      where: { email: 'admin@noithat.vn' },
    });

    if (!existingAdmin) {
      const hashedPassword = await bcrypt.hash('Admin@123456', 10);
      await prisma.users.create({
        data: {
          full_name: 'Quản Trị Viên Cấp Cao',
          email: 'admin@noithat.vn',
          password_hash: hashedPassword,
          role_id: adminRoleId,
          status: true,
        },
      });
      console.log('✅ Đã khởi tạo tài khoản Quản trị viên mặc định: admin@noithat.vn / Admin@123456');
    }
  } catch (err) {
    console.error('Không thể kiểm tra/khởi tạo tài khoản admin mặc định:', err);
  }
};
// Chạy kiểm tra khi file được import
ensureDefaultAdmin();

export function cleanFullName(name?: string | null, role?: string): string {
  if (!name) return '';
  let cleaned = name.trim();
  if (role === 'admin' || /qu[aá][º°\?]?n\s*tr[aá][»\?]?\s*vi[aăa][ª\?]?n/i.test(cleaned)) {
    return 'Quản Trị Viên';
  }
  return cleaned
    .replace(/Nguyá»…n/g, 'Nguyễn')
    .replace(/Pháº¡m/g, 'Phạm')
    .replace(/Há»¯u/g, 'Hữu')
    .replace(/Lá»£i/g, 'Lợi')
    .replace(/Vá»¹/g, 'Vỹ')
    .replace(/VÄƒn/g, 'Văn')
    .replace(/\s*Cáº¥p Cao/gi, '')
    .trim();
}

// ================================================================
// POST /api/auth/register - Đăng ký tài khoản mới an toàn
// ================================================================
authRouter.post('/register', authLimiter, async (req: Request, res: Response) => {
  try {
    const { fullname, email, phone, password } = req.body;

    if (!fullname || !email || !password) {
      return res.status(400).json({ success: false, message: 'Vui lòng điền đầy đủ họ tên, email và mật khẩu.' });
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ success: false, message: 'Địa chỉ email không đúng định dạng.' });
    }

    if (password.length < 6) {
      return res.status(400).json({ success: false, message: 'Mật khẩu phải chứa ít nhất 6 ký tự để bảo mật.' });
    }

    // Kiểm tra email đã tồn tại hay chưa
    const existing = await prisma.users.findUnique({
      where: { email },
    });

    if (existing) {
      return res.status(409).json({ success: false, message: 'Email này đã được sử dụng. Vui lòng chọn email khác hoặc đăng nhập.' });
    }

    // Role customer mặc định
    let customerRole = await prisma.roles.findFirst({
      where: { name: 'customer' },
    });
    const roleId = customerRole ? customerRole.id : 3;

    // Băm mật khẩu bằng Bcrypt
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(password, saltRounds);

    const newUser = await prisma.users.create({
      data: {
        full_name: fullname.trim(),
        email: email.trim().toLowerCase(),
        phone: phone ? phone.trim() : null,
        password_hash: hashedPassword,
        role_id: roleId,
        status: true,
      },
      include: { roles: true },
    });

    const userRole = newUser.roles?.name || 'customer';
    const token = generateToken({
      id: Number(newUser.id),
      email: newUser.email,
      role: userRole,
      full_name: newUser.full_name,
    }, '7d');

    return res.status(201).json({
      success: true,
      message: 'Đăng ký tài khoản thành công!',
      token,
      user: {
        id: Number(newUser.id),
        email: newUser.email,
        full_name: newUser.full_name,
        phone: newUser.phone,
        role: userRole,
      },
    });
  } catch (error: any) {
    console.error('Lỗi đăng ký tài khoản:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi đăng ký tài khoản.', error: error.message });
  }
});

// ================================================================
// POST /api/auth/login - Đăng nhập tài khoản & Cấp JWT Token
// ================================================================
authRouter.post('/login', authLimiter, async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ success: false, message: 'Vui lòng nhập đầy đủ email và mật khẩu.' });
    }

    const cleanEmail = email.trim().toLowerCase();

    const user = await prisma.users.findUnique({
      where: { email: cleanEmail },
      include: { roles: true },
    });

    if (!user) {
      return res.status(401).json({ success: false, message: 'Email hoặc mật khẩu không chính xác.' });
    }

    if (user.status === false) {
      return res.status(403).json({ success: false, message: 'Tài khoản của bạn đã bị khóa hoặc tạm ngưng hoạt động.' });
    }

    // Kiểm tra mật khẩu (hỗ trợ cả Bcrypt băm an toàn và cơ chế tự động nâng cấp nếu còn pass plaintext cũ)
    let isMatch = false;
    const isBcryptHash = user.password_hash.startsWith('$2a$') || user.password_hash.startsWith('$2b$');

    // Chặn tài khoản chưa đặt mật khẩu (khách mua hàng vãng lai hoặc tài khoản chỉ liên kết Google)
    if (user.password_hash === 'guest_no_login' || user.password_hash === 'GOOGLE_OAUTH_ACCOUNT') {
      return res.status(400).json({
        success: false,
        message: 'Tài khoản này được liên kết qua Google hoặc đặt hàng vãng lai. Vui lòng đăng nhập bằng Google hoặc bấm Quên mật khẩu.',
      });
    }

    if (isBcryptHash) {
      isMatch = await bcrypt.compare(password, user.password_hash);
    } else {
      // Đối chiếu mật khẩu cũ chưa mã hóa
      if (user.password_hash === password) {
        isMatch = true;
        // Tự động nâng cấp mã hóa mật khẩu sang Bcrypt ngay lập tức
        const newHash = await bcrypt.hash(password, 10);
        await prisma.users.update({
          where: { id: user.id },
          data: { password_hash: newHash },
        });
      }
    }

    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Email hoặc mật khẩu không chính xác.' });
    }

    const userRole = user.roles?.name || 'customer';
    const expiresIn = userRole === 'admin' ? '1d' : '7d';

    const token = generateToken({
      id: Number(user.id),
      email: user.email,
      role: userRole,
      full_name: user.full_name,
    }, expiresIn);

    return res.json({
      success: true,
      message: 'Đăng nhập thành công!',
      token,
      user: {
        id: Number(user.id),
        email: user.email,
        full_name: cleanFullName(user.full_name, userRole),
        phone: user.phone,
        role: userRole,
      },
    });
  } catch (error: any) {
    console.error('Lỗi đăng nhập:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi đăng nhập.', error: error.message });
  }
});

// ================================================================
// POST /api/auth/google - Xử lý đăng nhập / tài khoản Google
// ================================================================
authRouter.post('/google', async (req: Request, res: Response) => {
  try {
    const { email, fullname, avatar_url } = req.body;

    if (!email) {
      return res.status(400).json({ success: false, message: 'Thiếu thông tin email từ Google.' });
    }

    const cleanEmail = email.trim().toLowerCase();

    let user = await prisma.users.findUnique({
      where: { email: cleanEmail },
      include: { roles: true },
    });

    if (!user) {
      let customerRole = await prisma.roles.findFirst({
        where: { name: 'customer' },
      });
      const roleId = customerRole ? customerRole.id : 3;

      // Sinh mật khẩu ngẫu nhiên băm an toàn cho tài khoản OAuth
      const randomPassword = Math.random().toString(36).slice(-12) + Date.now().toString(36);
      const hashedPassword = await bcrypt.hash(randomPassword, 10);

      user = await prisma.users.create({
        data: {
          email: cleanEmail,
          full_name: fullname || cleanEmail.split('@')[0],
          avatar_url: avatar_url || null,
          password_hash: hashedPassword,
          role_id: roleId,
          status: true,
        },
        include: { roles: true },
      });
    } else if (avatar_url && user.avatar_url !== avatar_url) {
      // Tự động đồng bộ ảnh đại diện mới nhất từ Google OAuth vào cơ sở dữ liệu
      user = await prisma.users.update({
        where: { id: user.id },
        data: { avatar_url },
        include: { roles: true },
      });
    }

    const userRole = user.roles?.name || 'customer';
    const token = generateToken({
      id: Number(user.id),
      email: user.email,
      role: userRole,
      full_name: user.full_name,
    }, '7d');

    return res.json({
      success: true,
      message: 'Đăng nhập Google thành công!',
      token,
      user: {
        id: Number(user.id),
        email: user.email,
        full_name: user.full_name,
        avatar: user.avatar_url || avatar_url || null,
        role: userRole,
      },
    });
  } catch (error: any) {
    console.error('Lỗi đăng nhập Google:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi xử lý Google Login.', error: error.message });
  }
});

// ================================================================
// GET /api/auth/me - Kiểm tra và lấy thông tin phiên làm việc hiện tại
// ================================================================
authRouter.get('/me', verifyToken, async (req: Request, res: Response) => {
  try {
    if (!req.user) {
      return res.status(401).json({ success: false, message: 'Chưa đăng nhập.' });
    }

    const user = await prisma.users.findUnique({
      where: { id: req.user.id },
      include: { roles: true },
    });

    if (!user || user.status === false) {
      return res.status(401).json({ success: false, message: 'Tài khoản không tồn tại hoặc đã bị khóa.' });
    }

    return res.json({
      success: true,
      user: {
        id: Number(user.id),
        email: user.email,
        full_name: cleanFullName(user.full_name, user.roles?.name),
        phone: user.phone,
        avatar: user.avatar_url,
        role: user.roles?.name || 'customer',
      },
    });
  } catch (error: any) {
    console.error('Lỗi kiểm tra phiên /me:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// ================================================================
// GET /api/auth/customers - Lấy danh sách khách hàng (Chỉ dành cho Admin/Seller)
// ================================================================
authRouter.get('/customers', verifyToken, requireAdmin, async (_req: Request, res: Response) => {
  try {
    const customers = await prisma.users.findMany({
      include: {
        orders: true,
        roles: true,
      },
      orderBy: { created_at: 'desc' },
    });

    const formatted = customers.map((c) => ({
      id: `KH-${c.id}`,
      name: c.full_name,
      email: c.email,
      phone: c.phone || 'Chưa cập nhật',
      role: c.roles?.name || 'customer',
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
