import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';
import { verifyToken } from '../middlewares/auth.middleware.js';

export const userAddressesRouter = Router();

// ================================================================
// Helper format địa chỉ an toàn BigInt -> Number
// ================================================================
const formatAddress = (addr: any) => ({
  id: Number(addr.id),
  userId: Number(addr.user_id),
  receiverName: addr.receiver_name,
  receiverPhone: addr.receiver_phone,
  province: addr.province || '',
  district: addr.district || '',
  ward: addr.ward || '',
  specificAddress: addr.specific_address || '',
  isDefault: Boolean(addr.is_default),
  fullAddress: [addr.specific_address, addr.ward, addr.district, addr.province].filter(Boolean).join(', '),
});

// ================================================================
// GET /api/user-addresses - Lấy danh sách địa chỉ của người dùng hiện tại
// ================================================================
userAddressesRouter.get('/', verifyToken, async (req: Request, res: Response) => {
  try {
    if (!req.user?.id) {
      return res.status(401).json({ success: false, message: 'Chưa đăng nhập hoặc phiên làm việc đã hết hạn.' });
    }
    const userId = BigInt(req.user.id);

    const addresses = await prisma.user_addresses.findMany({
      where: { user_id: userId },
      orderBy: [
        { is_default: 'desc' },
        { id: 'desc' },
      ],
    });

    return res.json({
      success: true,
      data: addresses.map(formatAddress),
    });
  } catch (error: any) {
    console.error('Lỗi lấy danh sách địa chỉ:', error);
    return res.status(500).json({
      success: false,
      message: 'Không thể lấy danh sách địa chỉ nhận hàng.',
      error: error.message,
    });
  }
});

// ================================================================
// POST /api/user-addresses - Thêm địa chỉ mới
// ================================================================
userAddressesRouter.post('/', verifyToken, async (req: Request, res: Response) => {
  try {
    if (!req.user?.id) {
      return res.status(401).json({ success: false, message: 'Chưa đăng nhập hoặc phiên làm việc đã hết hạn.' });
    }
    const userId = BigInt(req.user.id);
    const { receiver_name, receiver_phone, province, district, ward, specific_address, is_default } = req.body;

    if (!receiver_name || !String(receiver_name).trim()) {
      return res.status(400).json({ success: false, message: 'Vui lòng nhập họ và tên người nhận.' });
    }
    if (!receiver_phone || !String(receiver_phone).trim()) {
      return res.status(400).json({ success: false, message: 'Vui lòng nhập số điện thoại người nhận.' });
    }
    if (!province || !String(province).trim()) {
      return res.status(400).json({ success: false, message: 'Vui lòng chọn Tỉnh / Thành phố.' });
    }
    if (!district || !String(district).trim()) {
      return res.status(400).json({ success: false, message: 'Vui lòng nhập Quận / Huyện.' });
    }
    if (!specific_address || !String(specific_address).trim()) {
      return res.status(400).json({ success: false, message: 'Vui lòng nhập địa chỉ cụ thể (số nhà, đường).' });
    }

    const count = await prisma.user_addresses.count({ where: { user_id: userId } });
    const shouldBeDefault = count === 0 || Boolean(is_default);

    if (shouldBeDefault) {
      await prisma.user_addresses.updateMany({
        where: { user_id: userId },
        data: { is_default: false },
      });
    }

    const newAddress = await prisma.user_addresses.create({
      data: {
        user_id: userId,
        receiver_name: String(receiver_name).trim(),
        receiver_phone: String(receiver_phone).trim(),
        province: String(province).trim(),
        district: String(district).trim(),
        ward: ward ? String(ward).trim() : '',
        specific_address: String(specific_address).trim(),
        is_default: shouldBeDefault,
      },
    });

    return res.status(201).json({
      success: true,
      message: 'Đã thêm địa chỉ nhận hàng mới thành công.',
      data: formatAddress(newAddress),
    });
  } catch (error: any) {
    console.error('Lỗi thêm địa chỉ:', error);
    return res.status(500).json({
      success: false,
      message: 'Không thể thêm địa chỉ nhận hàng.',
      error: error.message,
    });
  }
});

// ================================================================
// PUT /api/user-addresses/:id - Cập nhật địa chỉ nhận hàng
// ================================================================
userAddressesRouter.put('/:id', verifyToken, async (req: Request, res: Response) => {
  try {
    if (!req.user?.id) {
      return res.status(401).json({ success: false, message: 'Chưa đăng nhập hoặc phiên làm việc đã hết hạn.' });
    }
    const userId = BigInt(req.user.id);
    const addressId = BigInt(req.params.id);
    const { receiver_name, receiver_phone, province, district, ward, specific_address, is_default } = req.body;

    const existing = await prisma.user_addresses.findFirst({
      where: { id: addressId, user_id: userId },
    });

    if (!existing) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy địa chỉ hoặc bạn không có quyền sửa.' });
    }

    const shouldBeDefault = Boolean(is_default);
    if (shouldBeDefault && !existing.is_default) {
      await prisma.user_addresses.updateMany({
        where: { user_id: userId },
        data: { is_default: false },
      });
    }

    const updated = await prisma.user_addresses.update({
      where: { id: addressId },
      data: {
        receiver_name: receiver_name !== undefined ? String(receiver_name).trim() : existing.receiver_name,
        receiver_phone: receiver_phone !== undefined ? String(receiver_phone).trim() : existing.receiver_phone,
        province: province !== undefined ? String(province).trim() : existing.province,
        district: district !== undefined ? String(district).trim() : existing.district,
        ward: ward !== undefined ? String(ward).trim() : existing.ward,
        specific_address: specific_address !== undefined ? String(specific_address).trim() : existing.specific_address,
        is_default: shouldBeDefault || existing.is_default,
      },
    });

    return res.json({
      success: true,
      message: 'Đã cập nhật địa chỉ nhận hàng thành công.',
      data: formatAddress(updated),
    });
  } catch (error: any) {
    console.error('Lỗi cập nhật địa chỉ:', error);
    return res.status(500).json({
      success: false,
      message: 'Không thể cập nhật địa chỉ nhận hàng.',
      error: error.message,
    });
  }
});

// ================================================================
// PATCH /api/user-addresses/:id/default - Đặt làm địa chỉ mặc định
// ================================================================
userAddressesRouter.patch('/:id/default', verifyToken, async (req: Request, res: Response) => {
  try {
    if (!req.user?.id) {
      return res.status(401).json({ success: false, message: 'Chưa đăng nhập hoặc phiên làm việc đã hết hạn.' });
    }
    const userId = BigInt(req.user.id);
    const addressId = BigInt(req.params.id);

    const existing = await prisma.user_addresses.findFirst({
      where: { id: addressId, user_id: userId },
    });

    if (!existing) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy địa chỉ nhận hàng.' });
    }

    await prisma.user_addresses.updateMany({
      where: { user_id: userId },
      data: { is_default: false },
    });

    const updated = await prisma.user_addresses.update({
      where: { id: addressId },
      data: { is_default: true },
    });

    return res.json({
      success: true,
      message: 'Đã đặt làm địa chỉ mặc định thành công.',
      data: formatAddress(updated),
    });
  } catch (error: any) {
    console.error('Lỗi đặt địa chỉ mặc định:', error);
    return res.status(500).json({
      success: false,
      message: 'Không thể đặt địa chỉ mặc định.',
      error: error.message,
    });
  }
});

// ================================================================
// DELETE /api/user-addresses/:id - Xóa địa chỉ nhận hàng
// ================================================================
userAddressesRouter.delete('/:id', verifyToken, async (req: Request, res: Response) => {
  try {
    if (!req.user?.id) {
      return res.status(401).json({ success: false, message: 'Chưa đăng nhập hoặc phiên làm việc đã hết hạn.' });
    }
    const userId = BigInt(req.user.id);
    const addressId = BigInt(req.params.id);

    const existing = await prisma.user_addresses.findFirst({
      where: { id: addressId, user_id: userId },
    });

    if (!existing) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy địa chỉ cần xóa.' });
    }

    await prisma.user_addresses.delete({
      where: { id: addressId },
    });

    if (existing.is_default) {
      const remaining = await prisma.user_addresses.findFirst({
        where: { user_id: userId },
        orderBy: { id: 'desc' },
      });
      if (remaining) {
        await prisma.user_addresses.update({
          where: { id: remaining.id },
          data: { is_default: true },
        });
      }
    }

    return res.json({
      success: true,
      message: 'Đã xóa địa chỉ nhận hàng thành công.',
    });
  } catch (error: any) {
    console.error('Lỗi xóa địa chỉ:', error);
    return res.status(500).json({
      success: false,
      message: 'Không thể xóa địa chỉ nhận hàng.',
      error: error.message,
    });
  }
});
