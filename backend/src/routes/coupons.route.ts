import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';
import { verifyToken, requireAdmin } from '../middlewares/auth.middleware.js';

export const couponsRouter = Router();

// ================================================================
// GET /api/coupons - Lấy danh sách mã giảm giá
// ================================================================
couponsRouter.get('/', async (_req: Request, res: Response) => {
  try {
    const list = await prisma.coupons.findMany({
      orderBy: { id: 'desc' },
    });

    const data = list.map((c) => ({
      id: c.id,
      code: c.code,
      discountType: c.discount_type,
      discountValue: Number(c.discount_value),
      minOrderValue: c.min_order_value ? Number(c.min_order_value) : 0,
      maxDiscountAmount: c.max_discount_amount ? Number(c.max_discount_amount) : null,
      startDate: c.start_date,
      endDate: c.end_date,
      usageLimit: c.usage_limit,
      usedCount: c.used_count || 0,
      status: c.status !== false,
    }));

    return res.json({ success: true, data });
  } catch (error: any) {
    console.error('Lỗi lấy mã giảm giá:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi lấy mã giảm giá', error: error.message });
  }
});

// ================================================================
// POST /api/coupons - Thêm mã giảm giá mới (Yêu cầu quyền Admin)
// ================================================================
couponsRouter.post('/', verifyToken, requireAdmin, async (req: Request, res: Response) => {
  try {
    const { code, discountType, discountValue, minOrderValue, maxDiscountAmount, startDate, endDate, usageLimit, status } = req.body;

    if (!code || !discountValue) {
      return res.status(400).json({ success: false, message: 'Mã code và giá trị giảm không được để trống.' });
    }

    const existing = await prisma.coupons.findUnique({ where: { code: code.toUpperCase().trim() } });
    if (existing) {
      return res.status(409).json({ success: false, message: 'Mã giảm giá này đã tồn tại.' });
    }

    const coupon = await prisma.coupons.create({
      data: {
        code: code.toUpperCase().trim(),
        discount_type: (discountType === 'percentage' || discountType === 'percent') ? 'percent' : 'fixed_amount',
        discount_value: parseFloat(discountValue),
        min_order_value: minOrderValue ? parseFloat(minOrderValue) : 0,
        max_discount_amount: maxDiscountAmount ? parseFloat(maxDiscountAmount) : null,
        start_date: startDate ? new Date(startDate) : new Date(),
        end_date: endDate ? new Date(endDate) : new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
        usage_limit: usageLimit ? parseInt(usageLimit) : 100,
        status: status !== false,
      },
    });

    return res.status(201).json({ success: true, message: 'Thêm mã giảm giá thành công!', data: coupon });
  } catch (error: any) {
    console.error('Lỗi thêm mã giảm giá:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi thêm mã giảm giá', error: error.message });
  }
});

// ================================================================
// PUT /api/coupons/:id - Cập nhật mã giảm giá / Đổi trạng thái (Yêu cầu quyền Admin)
// ================================================================
couponsRouter.put('/:id', verifyToken, requireAdmin, async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id);
    const { code, discountType, discountValue, minOrderValue, maxDiscountAmount, startDate, endDate, usageLimit, status } = req.body;

    const existing = await prisma.coupons.findUnique({ where: { id } });
    if (!existing) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy mã giảm giá.' });
    }

    const updated = await prisma.coupons.update({
      where: { id },
      data: {
        ...(code !== undefined ? { code: code.toUpperCase().trim() } : {}),
        ...(discountType !== undefined ? { discount_type: discountType } : {}),
        ...(discountValue !== undefined ? { discount_value: parseFloat(discountValue) } : {}),
        ...(minOrderValue !== undefined ? { min_order_value: parseFloat(minOrderValue) } : {}),
        ...(maxDiscountAmount !== undefined ? { max_discount_amount: parseFloat(maxDiscountAmount) } : {}),
        ...(startDate !== undefined ? { start_date: new Date(startDate) } : {}),
        ...(endDate !== undefined ? { end_date: new Date(endDate) } : {}),
        ...(usageLimit !== undefined ? { usage_limit: parseInt(usageLimit) } : {}),
        ...(status !== undefined ? { status: Boolean(status) } : {}),
      },
    });

    return res.json({ success: true, message: 'Cập nhật mã giảm giá thành công!', data: updated });
  } catch (error: any) {
    console.error('Lỗi cập nhật mã giảm giá:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi cập nhật mã giảm giá', error: error.message });
  }
});

// ================================================================
// DELETE /api/coupons/:id - Xóa mã giảm giá (Yêu cầu quyền Admin)
// ================================================================
couponsRouter.delete('/:id', verifyToken, requireAdmin, async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id);
    const existing = await prisma.coupons.findUnique({ where: { id } });
    if (!existing) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy mã giảm giá.' });
    }

    await prisma.coupons.delete({ where: { id } });
    return res.json({ success: true, message: 'Đã xóa mã giảm giá thành công!' });
  } catch (error: any) {
    console.error('Lỗi xóa mã giảm giá:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi xóa mã giảm giá', error: error.message });
  }
});
