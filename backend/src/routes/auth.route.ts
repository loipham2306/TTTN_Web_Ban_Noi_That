import crypto from 'crypto';
import { MailerService } from '../services/mailer.service.js';
import { Router, Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { prisma } from '../config/prisma.js';
import { ENV } from '../config/env.js';
import { verifyToken, requireAdmin } from '../middlewares/auth.middleware.js';
import { authLimiter } from '../middlewares/rateLimit.middleware.js';

export const authRouter = Router();

const RESET_JWT_SECRET = ENV.JWT_SECRET + '_password_reset_secret_salt_2026';

// Tự động kiểm tra và khởi tạo bảng password_otps nếu chưa có trong MySQL
const initPasswordOtpsTable = async () => {
  try {
    await prisma.$executeRawUnsafe(`
      CREATE TABLE IF NOT EXISTS \`password_otps\` (
        \`id\` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
        \`user_id\` bigint(20) UNSIGNED NOT NULL,
        \`otp_hash\` varchar(255) NOT NULL,
        \`expires_at\` datetime NOT NULL,
        \`attempts\` int(11) NOT NULL DEFAULT 0,
        \`used_at\` datetime DEFAULT NULL,
        \`created_at\` datetime DEFAULT current_timestamp(),
        PRIMARY KEY (\`id\`),
        KEY \`user_id\` (\`user_id\`),
        CONSTRAINT \`password_otps_ibfk_1\` FOREIGN KEY (\`user_id\`) REFERENCES \`users\` (\`id\`) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
  } catch (err) {
    // Không làm gián đoạn nếu CSDL chưa kết nối
  }
};
initPasswordOtpsTable();


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
  if (!name || !name.trim()) return role === 'admin' ? 'Quản Trị Viên' : 'Khách';
  let cleaned = name.trim();
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
      return res.status(400).json({ success: false, field: 'email', message: 'Địa chỉ email không đúng định dạng.' });
    }

    if (password.length < 6) {
      return res.status(400).json({ success: false, field: 'password', message: 'Mật khẩu phải chứa ít nhất 6 ký tự để bảo mật.' });
    }

    // Chuẩn hóa dữ liệu
    const cleanEmail = email.trim().toLowerCase();
    const cleanPhone = phone ? phone.trim().replace(/\s+/g, '') : null;

    // Kiểm tra định dạng số điện thoại nếu người dùng nhập
    if (cleanPhone) {
      const phoneRegex = /^(0|\+84)[1-9][0-9]{8}$/;
      if (!phoneRegex.test(cleanPhone)) {
        return res.status(400).json({
          success: false,
          field: 'phone',
          message: 'Số điện thoại không hợp lệ (phải gồm 10 chữ số, bắt đầu bằng 0 hoặc +84).'
        });
      }
    }

    // 1. Kiểm tra email đã tồn tại hay chưa
    const existingEmail = await prisma.users.findUnique({
      where: { email: cleanEmail },
      include: { roles: true },
    });

    if (existingEmail) {
      // Nếu email này thuộc tài khoản khách vãng lai (guest chưa từng tạo mật khẩu)
      // Cho phép nâng cấp trực tiếp thành viên chính thức
      if (existingEmail.password_hash === 'guest_no_login' || existingEmail.password_hash === 'guest_review') {
        const saltRounds = 10;
        const hashedPassword = await bcrypt.hash(password, saltRounds);

        let customerRole = await prisma.roles.findFirst({
          where: { name: 'customer' },
        });
        const roleId = customerRole ? customerRole.id : (existingEmail.role_id || 3);

        const updatedUser = await prisma.users.update({
          where: { id: existingEmail.id },
          data: {
            full_name: fullname.trim(),
            phone: cleanPhone || existingEmail.phone,
            password_hash: hashedPassword,
            role_id: roleId,
            status: true,
          },
          include: { roles: true },
        });

        const userRole = updatedUser.roles?.name || 'customer';
        const token = generateToken({
          id: Number(updatedUser.id),
          email: updatedUser.email,
          role: userRole,
          full_name: updatedUser.full_name,
        }, '7d');

        return res.status(201).json({
          success: true,
          message: 'Đăng ký tài khoản thành công! Dữ liệu trước đây của bạn đã được kích hoạt.',
          token,
          user: {
            id: Number(updatedUser.id),
            email: updatedUser.email,
            full_name: updatedUser.full_name,
            phone: updatedUser.phone,
            role: userRole,
          },
        });
      }

      return res.status(409).json({
        success: false,
        field: 'email',
        message: 'Email này đã được đăng ký. Vui lòng đăng nhập hoặc chọn Quên mật khẩu.'
      });
    }

    // 2. Kiểm tra số điện thoại đã tồn tại hay chưa
    if (cleanPhone) {
      const existingPhone = await prisma.users.findFirst({
        where: { phone: cleanPhone },
      });

      if (existingPhone && existingPhone.password_hash !== 'guest_no_login' && existingPhone.password_hash !== 'guest_review') {
        return res.status(409).json({
          success: false,
          field: 'phone',
          message: 'Số điện thoại này đã được đăng ký cho một tài khoản khác. Vui lòng nhập số khác hoặc đăng nhập.'
        });
      }
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
        email: cleanEmail,
        phone: cleanPhone,
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
        avatar: null,
      },
    });
  } catch (error: any) {
    console.error('Lỗi đăng ký tài khoản:', error);

    // Bắt mã lỗi Unique Constraint (P2002) từ Prisma một cách an toàn
    if (error.code === 'P2002') {
      const target = (error.meta?.target as string[]) || [];
      const targetStr = Array.isArray(target) ? target.join(',') : String(target);

      if (targetStr.includes('email')) {
        return res.status(409).json({
          success: false,
          field: 'email',
          message: 'Email này đã được đăng ký trong hệ thống. Vui lòng sử dụng email khác hoặc đăng nhập.',
        });
      }
      if (targetStr.includes('phone')) {
        return res.status(409).json({
          success: false,
          field: 'phone',
          message: 'Số điện thoại này đã được sử dụng. Vui lòng dùng số khác hoặc đăng nhập.',
        });
      }
    }

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

    const cleanPassword = typeof password === 'string' ? password.trim() : '';

    if (isBcryptHash) {
      isMatch = await bcrypt.compare(cleanPassword, user.password_hash);
      if (!isMatch && cleanPassword !== password) {
        isMatch = await bcrypt.compare(password, user.password_hash);
      }
    } else {
      // Đối chiếu mật khẩu cũ chưa mã hóa
      if (user.password_hash === cleanPassword || user.password_hash === password) {
        isMatch = true;
        // Tự động nâng cấp mã hóa mật khẩu sang Bcrypt ngay lập tức
        const newHash = await bcrypt.hash(cleanPassword, 10);
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
        avatar: user.avatar_url || null,
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
// PUT /api/auth/profile - Cập nhật thông tin cá nhân vào Database
// ================================================================
authRouter.put('/profile', verifyToken, async (req: Request, res: Response) => {
  try {
    if (!req.user || !req.user.id) {
      return res.status(401).json({ success: false, message: 'Chưa đăng nhập hoặc phiên làm việc đã hết hạn.' });
    }

    const { full_name, phone } = req.body;
    const userId = BigInt(req.user.id);

    const user = await prisma.users.findUnique({
      where: { id: userId },
      include: { roles: true },
    });

    if (!user) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy thông tin tài khoản người dùng.' });
    }

    const updateData: any = {
      updated_at: new Date(),
    };

    if (full_name !== undefined) {
      const cleanName = String(full_name).trim();
      if (!cleanName) {
        return res.status(400).json({ success: false, message: 'Họ và tên không được để trống.' });
      }
      updateData.full_name = cleanName;
    }

    if (phone !== undefined) {
      const cleanPhone = String(phone).trim();
      if (cleanPhone) {
        const existingPhone = await prisma.users.findFirst({
          where: {
            phone: cleanPhone,
            id: { not: userId },
          },
        });
        if (existingPhone) {
          return res.status(400).json({
            success: false,
            message: 'Số điện thoại này đã được liên kết với một tài khoản khác. Vui lòng chọn số khác.',
          });
        }
        updateData.phone = cleanPhone;
      } else {
        updateData.phone = null;
      }
    }

    const updated = await prisma.users.update({
      where: { id: userId },
      data: updateData,
      include: { roles: true },
    });

    console.log(`[AUTH] Cập nhật thông tin thành công cho tài khoản ID: ${userId} -> Tên: "${updated.full_name}", SĐT: "${updated.phone}"`);

    return res.json({
      success: true,
      message: 'Cập nhật thông tin cá nhân thành công!',
      user: {
        id: Number(updated.id),
        email: updated.email,
        full_name: cleanFullName(updated.full_name, updated.roles?.name),
        phone: updated.phone || 'Chưa cập nhật',
        avatar: updated.avatar_url,
        role: updated.roles?.name || 'customer',
      },
    });
  } catch (error: any) {
    console.error('Lỗi cập nhật hồ sơ cá nhân:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi cập nhật thông tin.', error: error.message });
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

// ================================================================
// POST /api/auth/change-password - Đổi mật khẩu cá nhân
// ================================================================
authRouter.post('/change-password', verifyToken, async (req: Request, res: Response) => {
  try {
    if (!req.user || !req.user.id) {
      return res.status(401).json({ success: false, message: 'Chưa đăng nhập hoặc phiên làm việc đã hết hạn.' });
    }

    const { oldPassword, newPassword } = req.body;
    const cleanOld = String(oldPassword || '').trim();
    const cleanNew = String(newPassword || '').trim();

    if (!cleanNew || cleanNew.length < 6) {
      return res.status(400).json({ success: false, message: 'Mật khẩu mới phải có tối thiểu 6 ký tự.' });
    }

    const userId = BigInt(req.user.id);
    const user = await prisma.users.findUnique({
      where: { id: userId },
    });

    if (!user) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy thông tin tài khoản người dùng.' });
    }

    // Nếu tài khoản có mật khẩu cũ (không phải tài khoản Google OAuth không đặt pass)
    if (user.password_hash && user.password_hash !== 'guest_no_login' && user.password_hash !== 'GOOGLE_OAUTH_ACCOUNT') {
      if (!cleanOld) {
        return res.status(400).json({ success: false, message: 'Vui lòng nhập mật khẩu hiện tại.' });
      }

      let isMatch = false;
      const isBcrypt = user.password_hash.startsWith('$2a$') || user.password_hash.startsWith('$2b$');
      if (isBcrypt) {
        isMatch = await bcrypt.compare(cleanOld, user.password_hash);
        if (!isMatch && oldPassword && oldPassword !== cleanOld) {
          isMatch = await bcrypt.compare(oldPassword, user.password_hash);
        }
      } else {
        isMatch = (user.password_hash === cleanOld || user.password_hash === oldPassword);
      }

      if (!isMatch) {
        return res.status(400).json({ success: false, message: 'Mật khẩu hiện tại không chính xác. Vui lòng thử lại.' });
      }
    }

    // Băm mật khẩu mới bằng Bcrypt
    const salt = await bcrypt.genSalt(10);
    const newPasswordHash = await bcrypt.hash(cleanNew, salt);

    await prisma.users.update({
      where: { id: userId },
      data: { 
        password_hash: newPasswordHash,
        updated_at: new Date(),
      },
    });

    console.log(`[AUTH] Đã đổi mật khẩu thành công cho tài khoản ${user.email} (ID: ${userId})`);

    return res.json({
      success: true,
      message: 'Đổi mật khẩu thành công! Bạn có thể sử dụng mật khẩu mới để đăng nhập.',
    });
  } catch (error: any) {
    console.error('Lỗi khi đổi mật khẩu:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi đổi mật khẩu.', error: error.message });
  }
});


// ================================================================
// POST /api/auth/forgot-password - Yêu cầu gửi mã OTP đặt lại mật khẩu
// ================================================================
authRouter.post('/forgot-password', authLimiter, async (req: Request, res: Response) => {
  try {
    const rawEmail = req.body.email;
    const cleanEmail = String(rawEmail || '').trim().toLowerCase();

    // Thông báo chung nhất quán để chống dò quét danh sách email người dùng (Anti-Enumeration)
    const genericResponse = {
      success: true,
      message: 'Nếu email tồn tại trong hệ thống, mã xác thực OTP đã được gửi. Vui lòng kiểm tra hộp thư đến (và thư mục Spam).',
    };

    if (!cleanEmail) {
      return res.status(400).json({ success: false, message: 'Vui lòng nhập địa chỉ email của bạn.' });
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(cleanEmail)) {
      return res.status(400).json({ success: false, message: 'Địa chỉ email không đúng định dạng.' });
    }

    // Đảm bảo bảng đã tồn tại
    await initPasswordOtpsTable();

    // Tìm kiếm tài khoản người dùng
    const user = await prisma.users.findUnique({
      where: { email: cleanEmail },
      include: { roles: true },
    });

    // Nếu không tìm thấy hoặc tài khoản bị khóa -> delay nhỏ tránh timing attack rồi trả về cùng thông điệp chung
    if (!user || user.status === false) {
      await new Promise((resolve) => setTimeout(resolve, 300));
      return res.json(genericResponse);
    }

    // Nếu là tài khoản liên kết Google OAuth hoặc khách vãng lai -> không gửi OTP, vẫn trả thông báo chung
    if (user.password_hash === 'GOOGLE_OAUTH_ACCOUNT' || user.password_hash === 'guest_no_login') {
      await new Promise((resolve) => setTimeout(resolve, 300));
      return res.json(genericResponse);
    }

    // 1. Kiểm tra Cooldown: Mỗi lần gửi phải cách nhau tối thiểu 60 giây
    const oneMinuteAgo = new Date(Date.now() - 60 * 1000);
    const recentOtp = await prisma.password_otps.findFirst({
      where: {
        user_id: user.id,
        created_at: { gte: oneMinuteAgo },
      },
      orderBy: { created_at: 'desc' },
    });

    if (recentOtp && recentOtp.created_at) {
      const remainingSeconds = Math.max(1, Math.ceil((recentOtp.created_at.getTime() + 60000 - Date.now()) / 1000));
      return res.status(429).json({
        success: false,
        message: `Vui lòng đợi ${remainingSeconds} giây trước khi yêu cầu gửi lại mã OTP mới.`,
        cooldown: remainingSeconds,
      });
    }

    // 2. Giới hạn tối đa 5 lần yêu cầu OTP trong vòng 1 giờ cho 1 tài khoản
    const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000);
    const hourlyRequests = await prisma.password_otps.count({
      where: {
        user_id: user.id,
        created_at: { gte: oneHourAgo },
      },
    });

    if (hourlyRequests >= 5) {
      return res.status(429).json({
        success: false,
        message: 'Bạn đã yêu cầu gửi mã quá nhiều lần trong vòng 1 giờ. Vui lòng thử lại sau.',
      });
    }

    // 3. Vô hiệu hóa các mã OTP chưa sử dụng trước đó của người dùng
    await prisma.password_otps.updateMany({
      where: {
        user_id: user.id,
        used_at: null,
      },
      data: {
        used_at: new Date(),
      },
    });

    // 4. Sinh mã OTP 6 số ngẫu nhiên an toàn bằng crypto.randomInt
    const otp = crypto.randomInt(100000, 1000000).toString();

    // 5. Băm mã OTP bằng HMAC-SHA256 (tuyệt đối không lưu bản rõ trong cơ sở dữ liệu)
    const otpHash = crypto.createHmac('sha256', ENV.JWT_SECRET).update(otp).digest('hex');
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000); // Có hiệu lực trong 5 phút

    // 6. Lưu vào bảng password_otps
    await prisma.password_otps.create({
      data: {
        user_id: user.id,
        otp_hash: otpHash,
        expires_at: expiresAt,
        attempts: 0,
      },
    });

    // 7. Gửi mã OTP qua dịch vụ Mailer (SMTP hoặc in console DEV MODE)
    try {
      await MailerService.sendOtpMail(user.email, otp, cleanFullName(user.full_name, user.roles?.name));
    } catch (mailErr: any) {
      console.error('Lỗi khi gửi email OTP:', mailErr);
      return res.status(500).json({
        success: false,
        message: 'Không thể gửi email chứa mã OTP vào lúc này. Vui lòng thử lại sau.',
      });
    }

    return res.json(genericResponse);
  } catch (error: any) {
    console.error('Lỗi yêu cầu quên mật khẩu:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi xử lý quên mật khẩu.', error: error.message });
  }
});

// ================================================================
// POST /api/auth/verify-otp - Xác thực mã OTP 6 số
// ================================================================
authRouter.post('/verify-otp', authLimiter, async (req: Request, res: Response) => {
  try {
    const { email, otp } = req.body;
    const cleanEmail = String(email || '').trim().toLowerCase();
    const cleanOtp = String(otp || '').trim();

    if (!cleanEmail || !cleanOtp) {
      return res.status(400).json({ success: false, message: 'Vui lòng cung cấp đầy đủ email và mã OTP 6 số.' });
    }

    if (!/^\d{6}$/.test(cleanOtp)) {
      return res.status(400).json({ success: false, message: 'Mã OTP không đúng định dạng (phải gồm 6 chữ số).' });
    }

    const user = await prisma.users.findUnique({
      where: { email: cleanEmail },
    });

    if (!user || user.status === false) {
      return res.status(400).json({ success: false, message: 'Mã xác thực không hợp lệ hoặc đã hết hạn.' });
    }

    // Tìm mã OTP mới nhất chưa được sử dụng
    const otpRecord = await prisma.password_otps.findFirst({
      where: {
        user_id: user.id,
        used_at: null,
      },
      orderBy: { created_at: 'desc' },
    });

    if (!otpRecord) {
      return res.status(400).json({ success: false, message: 'Mã xác thực không tồn tại hoặc đã được sử dụng. Vui lòng yêu cầu mã mới.' });
    }

    // Kiểm tra thời gian hết hạn (5 phút)
    if (new Date() > otpRecord.expires_at) {
      return res.status(400).json({ success: false, message: 'Mã xác thực OTP đã hết hạn (chỉ có hiệu lực trong 5 phút). Vui lòng yêu cầu mã mới.' });
    }

    // Kiểm tra số lần nhập sai (tối đa 5 lần)
    if (otpRecord.attempts >= 5) {
      return res.status(400).json({ success: false, message: 'Mã xác thực đã bị vô hiệu hóa do nhập sai quá 5 lần. Vui lòng yêu cầu gửi mã mới.' });
    }

    // So sánh bản băm HMAC-SHA256
    const inputHash = crypto.createHmac('sha256', ENV.JWT_SECRET).update(cleanOtp).digest('hex');

    if (inputHash !== otpRecord.otp_hash) {
      const newAttempts = otpRecord.attempts + 1;
      await prisma.password_otps.update({
        where: { id: otpRecord.id },
        data: { attempts: newAttempts },
      });

      const remainingAttempts = 5 - newAttempts;
      if (remainingAttempts <= 0) {
        return res.status(400).json({
          success: false,
          message: 'Mã xác thực không đúng. Mã đã bị khóa do nhập sai quá 5 lần. Vui lòng yêu cầu mã mới.',
        });
      }

      return res.status(400).json({
        success: false,
        message: `Mã xác thực không chính xác. Bạn còn ${remainingAttempts} lần thử.`,
        remainingAttempts,
      });
    }

    // Khớp mã thành công -> Đánh dấu used_at
    await prisma.password_otps.update({
      where: { id: otpRecord.id },
      data: { used_at: new Date() },
    });

    // Tạo resetToken (sống 10 phút, mục đích riêng, KHÔNG chứa trường role)
    const resetToken = jwt.sign(
      {
        id: Number(user.id),
        email: user.email,
        purpose: 'password_reset',
      },
      RESET_JWT_SECRET,
      { expiresIn: '10m' }
    );

    return res.json({
      success: true,
      message: 'Xác thực mã OTP thành công. Vui lòng tiến hành tạo mật khẩu mới.',
      resetToken,
    });
  } catch (error: any) {
    console.error('Lỗi xác thực mã OTP:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi xác thực mã OTP.', error: error.message });
  }
});

// ================================================================
// POST /api/auth/reset-password - Đặt lại mật khẩu mới bằng resetToken
// ================================================================
authRouter.post('/reset-password', authLimiter, async (req: Request, res: Response) => {
  try {
    const { resetToken, newPassword } = req.body;
    const cleanPassword = String(newPassword || '').trim();

    if (!resetToken || !cleanPassword) {
      return res.status(400).json({ success: false, message: 'Vui lòng cung cấp mã xác thực đặt lại và mật khẩu mới.' });
    }

    if (cleanPassword.length < 6) {
      return res.status(400).json({ success: false, message: 'Mật khẩu mới phải có tối thiểu 6 ký tự để bảo mật.' });
    }

    // Xác thực resetToken bằng khóa bí mật riêng
    let decoded: any;
    try {
      decoded = jwt.verify(resetToken, RESET_JWT_SECRET);
    } catch (jwtErr: any) {
      return res.status(401).json({
        success: false,
        message: 'Phiên đặt lại mật khẩu đã hết hạn hoặc không hợp lệ. Vui lòng thực hiện lại từ đầu.',
      });
    }

    if (!decoded || decoded.purpose !== 'password_reset' || !decoded.id) {
      return res.status(401).json({
        success: false,
        message: 'Mã xác thực đặt lại mật khẩu không hợp lệ.',
      });
    }

    const userId = BigInt(decoded.id);
    const user = await prisma.users.findUnique({
      where: { id: userId },
    });

    if (!user || user.status === false) {
      return res.status(404).json({ success: false, message: 'Tài khoản người dùng không tồn tại hoặc đã bị khóa.' });
    }

    // Băm mật khẩu mới bằng Bcryptjs
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(cleanPassword, saltRounds);

    // Cập nhật mật khẩu mới cho tài khoản
    await prisma.users.update({
      where: { id: userId },
      data: {
        password_hash: hashedPassword,
        updated_at: new Date(),
      },
    });

    // Vô hiệu hóa toàn bộ OTP còn lại của tài khoản
    await prisma.password_otps.updateMany({
      where: {
        user_id: userId,
        used_at: null,
      },
      data: {
        used_at: new Date(),
      },
    });

    console.log(`✅ [AUTH] Đã đặt lại mật khẩu thành công qua OTP cho tài khoản: ${user.email} (ID: ${userId})`);

    return res.json({
      success: true,
      message: 'Đặt lại mật khẩu thành công! Bạn có thể sử dụng mật khẩu mới để đăng nhập ngay bây giờ.',
    });
  } catch (error: any) {
    console.error('Lỗi đặt lại mật khẩu:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi đặt lại mật khẩu.', error: error.message });
  }
});
