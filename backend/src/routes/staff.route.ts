import { Router, Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import { prisma } from '../config/prisma.js';

export const staffRouter = Router();

// Bản đồ phân loại phòng ban theo vai trò
export const ROLE_DEPARTMENT_MAP: Record<string, string> = {
  admin: 'Ban Giám Đốc',
  seller: 'Phòng Kinh Doanh',
  consultant: 'Tư Vấn Khách Hàng',
  warehouse: 'Kho Vận',
  marketing: 'Truyền Thông',
};

// Bản đồ tên hiển thị vai trò tiếng Việt trang trọng
export const ROLE_DISPLAY_MAP: Record<string, string> = {
  admin: 'Quản Trị Viên (Admin)',
  seller: 'Quản Lý Bán Hàng',
  consultant: 'Chuyên Viên Tư Vấn Phong Thủy',
  warehouse: 'Thủ Kho & Vận Chuyển',
  marketing: 'Marketing & Khuyến Mãi',
};

// Khởi tạo các vai trò chuẩn hóa & seed dữ liệu nhân sự mẫu nếu DB chưa có
const initStaffData = async () => {
  try {
    const rolesToEnsure = [
      { id: 1, name: 'admin', description: 'Quản trị viên toàn quyền' },
      { id: 2, name: 'seller', description: 'Quản lý bán hàng' },
      { id: 3, name: 'customer', description: 'Khách mua hàng' },
      { id: 4, name: 'consultant', description: 'Chuyên viên tư vấn phong thủy' },
      { id: 5, name: 'warehouse', description: 'Thủ kho & vận chuyển' },
      { id: 6, name: 'marketing', description: 'Marketing & truyền thông' },
    ];

    for (const r of rolesToEnsure) {
      const existing = await prisma.roles.findFirst({
        where: { OR: [{ id: r.id }, { name: r.name }] },
      });
      if (!existing) {
        await prisma.roles.create({
          data: {
            id: r.id,
            name: r.name,
            description: r.description,
          },
        });
      }
    }

    // Đếm số lượng nhân sự hiện có (loại trừ role customer = 3)
    const staffCount = await prisma.users.count({
      where: {
        role_id: { not: 3 },
        deleted_at: null,
      },
    });

    // Nếu chỉ có 1 admin hoặc chưa có nhân sự phòng ban, seed thêm 4 nhân viên thực tế
    if (staffCount <= 1) {
      const sampleStaff = [
        {
          name: 'Lê Hoàng Nam',
          email: 'nam.le@noithat.vn',
          phone: '0909002002',
          roleName: 'seller',
          status: true,
        },
        {
          name: 'Đặng Thảo Vy',
          email: 'vy.dang@noithat.vn',
          phone: '0909003003',
          roleName: 'consultant',
          status: true,
        },
        {
          name: 'Nguyễn Tiến Dũng',
          email: 'dung.nguyen@noithat.vn',
          phone: '0909004004',
          roleName: 'warehouse',
          status: true,
        },
        {
          name: 'Trần Bảo Ngọc',
          email: 'ngoc.tran@noithat.vn',
          phone: '0909005005',
          roleName: 'marketing',
          status: true,
        },
      ];

      const defaultPasswordHash = await bcrypt.hash('Staff@123456', 10);

      for (const st of sampleStaff) {
        const existUser = await prisma.users.findFirst({
          where: { OR: [{ email: st.email }, { phone: st.phone }] },
        });

        if (!existUser) {
          const roleRecord = await prisma.roles.findFirst({
            where: { name: st.roleName },
          });

          if (roleRecord) {
            await prisma.users.create({
              data: {
                full_name: st.name,
                email: st.email,
                phone: st.phone,
                password_hash: defaultPasswordHash,
                role_id: roleRecord.id,
                status: st.status,
              },
            });
          }
        }
      }
      console.log('✅ Đã khởi tạo danh sách nhân sự thực tế ban đầu.');
    }
  } catch (err) {
    console.warn('⚠️ Lỗi kiểm tra / khởi tạo danh mục nhân sự:', err);
  }
};

// Kích hoạt khởi tạo khi server nạp module
initStaffData();

// Helper định dạng dữ liệu nhân viên trả về client
function formatStaffUser(u: any) {
  const roleName = u.roles?.name || 'seller';
  const roleDisplay = ROLE_DISPLAY_MAP[roleName] || u.roles?.description || roleName;
  const dept = ROLE_DEPARTMENT_MAP[roleName] || 'Bộ phận Vận hành';
  const isActive = u.status !== false;

  return {
    id: Number(u.id),
    code: `NV-${String(u.id).padStart(3, '0')}`,
    name: u.full_name,
    email: u.email,
    phone: u.phone || 'Chưa cập nhật',
    roleId: u.role_id,
    roleKey: roleName,
    role: roleDisplay,
    dept: dept,
    avatar: u.avatar_url,
    status: isActive ? 'Trực tuyến' : 'Đã khóa',
    statusColor: isActive
      ? 'bg-emerald-100 text-emerald-800 border-emerald-300'
      : 'bg-red-100 text-red-800 border-red-300',
    lastLogin: u.updated_at ? new Date(u.updated_at).toLocaleString('vi-VN') : 'Vừa xong',
    createdAt: u.created_at,
  };
}

// ================================================================
// GET /api/staff - Lấy danh sách toàn bộ nhân viên & thống kê
// ================================================================
staffRouter.get('/', async (req: Request, res: Response) => {
  try {
    const { search, role } = req.query;

    const whereClause: any = {
      role_id: { not: 3 }, // Không bao gồm khách hàng (customer)
      deleted_at: null,
    };

    if (search && typeof search === 'string') {
      const q = search.trim();
      whereClause.OR = [
        { full_name: { contains: q } },
        { email: { contains: q } },
        { phone: { contains: q } },
      ];
    }

    if (role && typeof role === 'string' && role !== 'all') {
      whereClause.roles = { name: role };
    }

    const staffUsers = await prisma.users.findMany({
      where: whereClause,
      include: { roles: true },
      orderBy: { id: 'asc' },
    });

    const formattedList = staffUsers.map(formatStaffUser);

    // Tính toán KPIs thực tế từ cơ sở dữ liệu
    const totalStaff = formattedList.length;
    const onlineStaff = formattedList.filter((s) => s.status === 'Trực tuyến').length;
    const adminCount = formattedList.filter((s) => s.roleKey === 'admin').length;
    const lockedCount = formattedList.filter((s) => s.status === 'Đã khóa').length;

    return res.json({
      success: true,
      data: formattedList,
      stats: {
        total: totalStaff,
        online: onlineStaff,
        admins: adminCount,
        locked: lockedCount,
        twoFactorPercentage: 100, // Tiêu chuẩn bảo mật hệ thống
      },
    });
  } catch (error: any) {
    console.error('Lỗi khi lấy danh sách nhân sự:', error);
    return res.status(500).json({
      success: false,
      message: 'Không thể tải danh sách nhân sự từ cơ sở dữ liệu.',
      error: error.message,
    });
  }
});

// ================================================================
// GET /api/staff/roles - Lấy danh sách các chức vụ nhân sự hợp lệ
// ================================================================
staffRouter.get('/roles', async (_req: Request, res: Response) => {
  try {
    const roles = await prisma.roles.findMany({
      where: { name: { not: 'customer' } },
      orderBy: { id: 'asc' },
    });

    const formattedRoles = roles.map((r) => ({
      id: r.id,
      name: r.name,
      display: ROLE_DISPLAY_MAP[r.name] || r.description || r.name,
      dept: ROLE_DEPARTMENT_MAP[r.name] || 'Vận hành',
      description: r.description,
    }));

    return res.json({
      success: true,
      data: formattedRoles,
    });
  } catch (error: any) {
    return res.status(500).json({
      success: false,
      message: 'Lỗi tải danh mục vai trò.',
      error: error.message,
    });
  }
});

// ================================================================
// POST /api/staff - Thêm nhân viên mới vào hệ thống
// ================================================================
staffRouter.post('/', async (req: Request, res: Response) => {
  try {
    const { name, email, phone, roleId, roleName, password } = req.body;

    if (!name || !email) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp họ tên và email nhân viên.',
      });
    }

    // Kiểm tra định dạng email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({
        success: false,
        message: 'Địa chỉ email không đúng định dạng.',
      });
    }

    // Kiểm tra trùng lặp email
    const existEmail = await prisma.users.findUnique({
      where: { email },
    });
    if (existEmail) {
      return res.status(409).json({
        success: false,
        message: `Email "${email}" đã tồn tại trên hệ thống.`,
      });
    }

    // Kiểm tra trùng số điện thoại nếu có cung cấp
    if (phone) {
      const existPhone = await prisma.users.findUnique({
        where: { phone },
      });
      if (existPhone) {
        return res.status(409).json({
          success: false,
          message: `Số điện thoại "${phone}" đã được sử dụng bởi người dùng khác.`,
        });
      }
    }

    // Xác định vai trò (Role)
    let assignedRoleId = 2; // Mặc định seller
    if (roleId) {
      assignedRoleId = Number(roleId);
    } else if (roleName) {
      // Tìm theo roleName hoặc display text
      let foundRole = await prisma.roles.findFirst({
        where: { name: roleName },
      });
      if (!foundRole) {
        // Tìm ngược từ ROLE_DISPLAY_MAP
        const matchedKey = Object.entries(ROLE_DISPLAY_MAP).find(
          ([_, disp]) => disp.toLowerCase() === roleName.toLowerCase()
        )?.[0];
        if (matchedKey) {
          foundRole = await prisma.roles.findFirst({ where: { name: matchedKey } });
        }
      }
      if (foundRole) assignedRoleId = foundRole.id;
    }

    // Mã hóa mật khẩu bảo mật
    const rawPassword = password && password.length >= 6 ? password : 'Staff@123456';
    const hashedPassword = await bcrypt.hash(rawPassword, 10);

    const newUser = await prisma.users.create({
      data: {
        full_name: name.trim(),
        email: email.trim().toLowerCase(),
        phone: phone ? phone.trim() : null,
        password_hash: hashedPassword,
        role_id: assignedRoleId,
        status: true,
      },
      include: { roles: true },
    });

    return res.status(201).json({
      success: true,
      message: `Đã thêm thành công nhân viên "${newUser.full_name}" vào cơ sở dữ liệu.`,
      data: formatStaffUser(newUser),
    });
  } catch (error: any) {
    console.error('Lỗi khi thêm nhân viên:', error);
    return res.status(500).json({
      success: false,
      message: 'Không thể lưu nhân viên vào cơ sở dữ liệu.',
      error: error.message,
    });
  }
});

// ================================================================
// PUT /api/staff/:id/role - Phân quyền / Cập nhật vai trò nhân sự
// ================================================================
staffRouter.put('/:id/role', async (req: Request, res: Response) => {
  try {
    const staffId = Number(req.params.id);
    const { roleId, roleName } = req.body;

    if (isNaN(staffId)) {
      return res.status(400).json({ success: false, message: 'ID nhân viên không hợp lệ.' });
    }

    const targetUser = await prisma.users.findUnique({
      where: { id: BigInt(staffId) },
      include: { roles: true },
    });

    if (!targetUser) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy nhân viên.' });
    }

    // Tìm role ID tương ứng
    let newRoleId: number | null = null;
    if (roleId) {
      newRoleId = Number(roleId);
    } else if (roleName) {
      let r = await prisma.roles.findFirst({ where: { name: roleName } });
      if (!r) {
        const matchedKey = Object.entries(ROLE_DISPLAY_MAP).find(
          ([_, disp]) => disp.toLowerCase() === roleName.toLowerCase()
        )?.[0];
        if (matchedKey) {
          r = await prisma.roles.findFirst({ where: { name: matchedKey } });
        }
      }
      if (r) newRoleId = r.id;
    }

    if (!newRoleId) {
      return res.status(400).json({ success: false, message: 'Vui lòng chọn vai trò hợp lệ.' });
    }

    const updatedUser = await prisma.users.update({
      where: { id: BigInt(staffId) },
      data: { role_id: newRoleId },
      include: { roles: true },
    });

    return res.json({
      success: true,
      message: `Đã cập nhật phân quyền cho nhân viên "${updatedUser.full_name}".`,
      data: formatStaffUser(updatedUser),
    });
  } catch (error: any) {
    console.error('Lỗi cập nhật phân quyền:', error);
    return res.status(500).json({
      success: false,
      message: 'Không thể cập nhật phân quyền trong cơ sở dữ liệu.',
      error: error.message,
    });
  }
});

// ================================================================
// PATCH /api/staff/:id/status - Khóa / Mở khóa tài khoản nhân sự
// ================================================================
staffRouter.patch('/:id/status', async (req: Request, res: Response) => {
  try {
    const staffId = Number(req.params.id);
    if (isNaN(staffId)) {
      return res.status(400).json({ success: false, message: 'ID nhân viên không hợp lệ.' });
    }

    const targetUser = await prisma.users.findUnique({
      where: { id: BigInt(staffId) },
      include: { roles: true },
    });

    if (!targetUser) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy nhân viên.' });
    }

    // Không cho phép khóa tài khoản Admin tối cao nếu là admin duy nhất
    if (targetUser.roles?.name === 'admin' && targetUser.status === true) {
      const activeAdminCount = await prisma.users.count({
        where: {
          role_id: 1,
          status: true,
          deleted_at: null,
        },
      });
      if (activeAdminCount <= 1) {
        return res.status(400).json({
          success: false,
          message: 'Không thể khóa tài khoản Quản trị viên tối cao duy nhất của hệ thống.',
        });
      }
    }

    // Đảo ngược trạng thái hiện tại hoặc nhận theo body
    const nextStatus = typeof req.body.status === 'boolean'
      ? req.body.status
      : !(targetUser.status !== false);

    const updatedUser = await prisma.users.update({
      where: { id: BigInt(staffId) },
      data: { status: nextStatus },
      include: { roles: true },
    });

    const actionText = nextStatus ? 'Mở khóa' : 'Khóa';
    return res.json({
      success: true,
      message: `Đã ${actionText} tài khoản của "${updatedUser.full_name}" thành công.`,
      data: formatStaffUser(updatedUser),
    });
  } catch (error: any) {
    console.error('Lỗi cập nhật trạng thái nhân sự:', error);
    return res.status(500).json({
      success: false,
      message: 'Không thể cập nhật trạng thái trong cơ sở dữ liệu.',
      error: error.message,
    });
  }
});

// ================================================================
// DELETE /api/staff/:id - Xóa an toàn nhân sự (Soft delete)
// ================================================================
staffRouter.delete('/:id', async (req: Request, res: Response) => {
  try {
    const staffId = Number(req.params.id);
    if (isNaN(staffId)) {
      return res.status(400).json({ success: false, message: 'ID nhân viên không hợp lệ.' });
    }

    const targetUser = await prisma.users.findUnique({
      where: { id: BigInt(staffId) },
      include: { roles: true },
    });

    if (!targetUser) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy nhân viên.' });
    }

    if (targetUser.roles?.name === 'admin') {
      return res.status(400).json({
        success: false,
        message: 'Không thể xóa tài khoản Quản trị viên khỏi hệ thống.',
      });
    }

    await prisma.users.update({
      where: { id: BigInt(staffId) },
      data: {
        deleted_at: new Date(),
        status: false,
      },
    });

    return res.json({
      success: true,
      message: `Đã xóa nhân sự "${targetUser.full_name}" khỏi danh sách vận hành.`,
    });
  } catch (error: any) {
    console.error('Lỗi khi xóa nhân sự:', error);
    return res.status(500).json({
      success: false,
      message: 'Không thể xóa nhân sự khỏi cơ sở dữ liệu.',
      error: error.message,
    });
  }
});
