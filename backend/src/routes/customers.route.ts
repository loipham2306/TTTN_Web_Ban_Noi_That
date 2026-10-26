import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';

export const customersRouter = Router();

// Định nghĩa màu sắc badge cho từng thứ hạng hội viên
export const TIER_CONFIG: Record<string, { label: string; color: string; minSpent: number }> = {
  DIAMOND: {
    label: 'Kim Cương',
    color: 'bg-purple-100 text-purple-800 border-purple-300',
    minSpent: 50_000_000,
  },
  GOLD: {
    label: 'Vàng',
    color: 'bg-amber-100 text-amber-800 border-amber-300',
    minSpent: 20_000_000,
  },
  SILVER: {
    label: 'Bạc',
    color: 'bg-slate-100 text-slate-800 border-slate-300',
    minSpent: 5_000_000,
  },
  BRONZE: {
    label: 'Đồng',
    color: 'bg-orange-100 text-orange-800 border-orange-300',
    minSpent: 0,
  },
};

// Tính toán thứ hạng hội viên dựa trên tổng chi tiêu
export function calculateTier(totalSpent: number) {
  if (totalSpent >= TIER_CONFIG.DIAMOND.minSpent) return TIER_CONFIG.DIAMOND;
  if (totalSpent >= TIER_CONFIG.GOLD.minSpent) return TIER_CONFIG.GOLD;
  if (totalSpent >= TIER_CONFIG.SILVER.minSpent) return TIER_CONFIG.SILVER;
  return TIER_CONFIG.BRONZE;
}

// Định dạng dữ liệu khách hàng trả về cho frontend
function formatCustomer(c: any) {
  const orders = c.orders || [];
  const validOrders = orders.filter((o: any) => o.order_status !== 'cancelled');
  const totalSpent = validOrders.reduce((sum: number, o: any) => sum + Number(o.total_amount || 0), 0);
  const tierInfo = calculateTier(totalSpent);
  const isActive = c.status !== false;

  const defaultAddress = c.user_addresses?.find((a: any) => a.is_default) || c.user_addresses?.[0];
  const addressText = defaultAddress
    ? [defaultAddress.specific_address, defaultAddress.ward, defaultAddress.district, defaultAddress.province]
        .filter(Boolean)
        .join(', ')
    : '';

  const regDate = c.created_at ? new Date(c.created_at) : new Date();
  const dateFormatted = `${String(regDate.getDate()).padStart(2, '0')}/${String(regDate.getMonth() + 1).padStart(2, '0')}/${regDate.getFullYear()}`;

  return {
    id: `KH-${String(c.id).padStart(4, '0')}`,
    rawId: Number(c.id),
    name: c.full_name || 'Khách hàng',
    email: c.email,
    phone: c.phone || 'Chưa cập nhật',
    avatar: c.avatar_url,
    orders: orders.length,
    validOrdersCount: validOrders.length,
    spentRaw: totalSpent,
    spent: totalSpent > 0 ? `${totalSpent.toLocaleString('vi-VN')} ₫` : '0 ₫',
    tier: tierInfo.label,
    tierColor: tierInfo.color,
    status: isActive ? 'Hoạt động' : 'Tạm khóa',
    date: dateFormatted,
    address: addressText,
    createdAt: c.created_at,
  };
}

// ================================================================
// GET /api/customers - Lấy danh sách khách hàng và thống kê KPIs
// ================================================================
customersRouter.get('/', async (req: Request, res: Response) => {
  try {
    const { search, tier, status } = req.query;

    const whereClause: any = {
      role_id: 3, // Vai trò Khách hàng (customer)
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

    if (status === 'active') whereClause.status = true;
    if (status === 'locked') whereClause.status = false;

    const customers = await prisma.users.findMany({
      where: whereClause,
      include: {
        orders: {
          orderBy: { created_at: 'desc' },
        },
        user_addresses: true,
      },
      orderBy: { created_at: 'desc' },
    });

    let formatted = customers.map(formatCustomer);

    // Lọc theo tier nếu có
    if (tier && typeof tier === 'string' && tier !== '') {
      formatted = formatted.filter((c) => c.tier.toLowerCase() === tier.toLowerCase());
    }

    // Tính toán thống kê KPIs thực tế
    const totalCustomers = formatted.length;
    const vipCustomers = formatted.filter((c) => c.tier === 'Kim Cương' || c.tier === 'Vàng').length;
    
    const customersWithSpending = formatted.filter((c) => c.spentRaw > 0);
    const totalRevenueFromCustomers = formatted.reduce((sum, c) => sum + c.spentRaw, 0);
    const avgSpent = customersWithSpending.length > 0 
      ? Math.round(totalRevenueFromCustomers / customersWithSpending.length) 
      : 0;

    const returningCustomersCount = formatted.filter((c) => c.orders >= 2).length;
    const returningRate = totalCustomers > 0 
      ? Number(((returningCustomersCount / totalCustomers) * 100).toFixed(1))
      : 0;

    return res.json({
      success: true,
      data: formatted,
      stats: {
        total: totalCustomers,
        totalText: `${totalCustomers} tài khoản`,
        vip: vipCustomers,
        vipText: `${vipCustomers} khách`,
        avgSpent: avgSpent,
        avgSpentText: avgSpent > 0 ? `${avgSpent.toLocaleString('vi-VN')} ₫` : '0 ₫',
        returningRate: returningRate,
        returningRateText: `${returningRate}%`,
      },
    });
  } catch (error: any) {
    console.error('Lỗi khi lấy danh sách khách hàng:', error);
    return res.status(500).json({
      success: false,
      message: 'Không thể tải danh sách khách hàng từ cơ sở dữ liệu.',
      error: error.message,
    });
  }
});

// ================================================================
// GET /api/customers/:id - Chi tiết khách hàng kèm lịch sử đơn hàng
// ================================================================
customersRouter.get('/:id', async (req: Request, res: Response) => {
  try {
    const rawId = req.params.id.replace(/^KH-0*/, '');
    const customerId = Number(rawId);

    if (isNaN(customerId)) {
      return res.status(400).json({ success: false, message: 'Mã khách hàng không hợp lệ.' });
    }

    const customer = await prisma.users.findUnique({
      where: { id: BigInt(customerId) },
      include: {
        orders: {
          include: { order_items: true },
          orderBy: { created_at: 'desc' },
          take: 10,
        },
        user_addresses: true,
        reviews: true,
      },
    });

    if (!customer || customer.role_id !== 3 || customer.deleted_at !== null) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy hồ sơ khách hàng.' });
    }

    const formatted = formatCustomer(customer);

    const recentOrders = customer.orders.map((o) => ({
      id: Number(o.id),
      orderCode: o.order_code,
      total: Number(o.total_amount),
      status: o.order_status,
      paymentStatus: o.payment_status,
      createdAt: o.created_at,
      itemCount: o.order_items.length,
    }));

    return res.json({
      success: true,
      data: {
        ...formatted,
        recentOrders,
        addresses: customer.user_addresses.map((a) => ({
          id: Number(a.id),
          receiverName: a.receiver_name,
          phone: a.receiver_phone,
          address: [a.specific_address, a.ward, a.district, a.province].filter(Boolean).join(', '),
          isDefault: a.is_default,
        })),
      },
    });
  } catch (error: any) {
    return res.status(500).json({
      success: false,
      message: 'Lỗi tải chi tiết khách hàng.',
      error: error.message,
    });
  }
});

// ================================================================
// PUT /api/customers/:id - Chỉnh sửa thông tin khách hàng
// ================================================================
customersRouter.put('/:id', async (req: Request, res: Response) => {
  try {
    const rawId = req.params.id.replace(/^KH-0*/, '');
    const customerId = Number(rawId);
    const { name, phone, status } = req.body;

    if (isNaN(customerId)) {
      return res.status(400).json({ success: false, message: 'Mã khách hàng không hợp lệ.' });
    }

    const exist = await prisma.users.findUnique({
      where: { id: BigInt(customerId) },
    });

    if (!exist || exist.role_id !== 3) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy khách hàng.' });
    }

    const updateData: any = {};
    if (name && typeof name === 'string') updateData.full_name = name.trim();
    if (phone !== undefined) updateData.phone = phone ? phone.trim() : null;
    if (status !== undefined) {
      updateData.status = status === 'Hoạt động' || status === true;
    }

    const updated = await prisma.users.update({
      where: { id: BigInt(customerId) },
      data: updateData,
      include: {
        orders: true,
        user_addresses: true,
      },
    });

    return res.json({
      success: true,
      message: `Đã cập nhật thông tin khách hàng "${updated.full_name}" thành công!`,
      data: formatCustomer(updated),
    });
  } catch (error: any) {
    console.error('Lỗi cập nhật khách hàng:', error);
    return res.status(500).json({
      success: false,
      message: 'Không thể cập nhật thông tin khách hàng trong cơ sở dữ liệu.',
      error: error.message,
    });
  }
});

// ================================================================
// PATCH /api/customers/:id/status - Khóa / Mở khóa tài khoản khách hàng
// ================================================================
customersRouter.patch('/:id/status', async (req: Request, res: Response) => {
  try {
    const rawId = req.params.id.replace(/^KH-0*/, '');
    const customerId = Number(rawId);

    if (isNaN(customerId)) {
      return res.status(400).json({ success: false, message: 'Mã khách hàng không hợp lệ.' });
    }

    const customer = await prisma.users.findUnique({
      where: { id: BigInt(customerId) },
    });

    if (!customer || customer.role_id !== 3) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy khách hàng.' });
    }

    const nextStatus = typeof req.body.status === 'boolean'
      ? req.body.status
      : !(customer.status !== false);

    const updated = await prisma.users.update({
      where: { id: BigInt(customerId) },
      data: { status: nextStatus },
      include: {
        orders: true,
        user_addresses: true,
      },
    });

    const actionText = nextStatus ? 'Mở khóa' : 'Khóa';
    return res.json({
      success: true,
      message: `Đã ${actionText} tài khoản của "${updated.full_name}" thành công.`,
      data: formatCustomer(updated),
    });
  } catch (error: any) {
    console.error('Lỗi đổi trạng thái khách hàng:', error);
    return res.status(500).json({
      success: false,
      message: 'Không thể cập nhật trạng thái khách hàng trong cơ sở dữ liệu.',
      error: error.message,
    });
  }
});

// ================================================================
// DELETE /api/customers/:id - Xóa an toàn khách hàng (Soft delete)
// ================================================================
customersRouter.delete('/:id', async (req: Request, res: Response) => {
  try {
    const rawId = req.params.id.replace(/^KH-0*/, '');
    const customerId = Number(rawId);

    if (isNaN(customerId)) {
      return res.status(400).json({ success: false, message: 'Mã khách hàng không hợp lệ.' });
    }

    const customer = await prisma.users.findUnique({
      where: { id: BigInt(customerId) },
    });

    if (!customer || customer.role_id !== 3) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy khách hàng.' });
    }

    await prisma.users.update({
      where: { id: BigInt(customerId) },
      data: {
        deleted_at: new Date(),
        status: false,
      },
    });

    return res.json({
      success: true,
      message: `Đã xóa tài khoản khách hàng "${customer.full_name}" khỏi hệ thống.`,
    });
  } catch (error: any) {
    console.error('Lỗi khi xóa khách hàng:', error);
    return res.status(500).json({
      success: false,
      message: 'Không thể xóa khách hàng khỏi cơ sở dữ liệu.',
      error: error.message,
    });
  }
});
