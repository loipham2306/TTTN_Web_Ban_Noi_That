import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';
import { optionalToken } from '../middlewares/auth.middleware.js';

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
// POST /api/coupons/validate - Kiểm tra và tính toán giảm giá
// ================================================================
couponsRouter.post('/validate', async (req: Request, res: Response) => {
  try {
    const { code, subtotal } = req.body;
    if (!code) {
      return res.status(400).json({ success: false, message: 'Vui lòng nhập mã giảm giá.' });
    }

    const orderSubtotal = Number(subtotal) || 0;
    const cleanCode = String(code).toUpperCase().trim();

    const coupon = await prisma.coupons.findUnique({
      where: { code: cleanCode },
    });

    if (!coupon) {
      return res.status(404).json({ success: false, message: 'Mã giảm giá không tồn tại hoặc đã bị xóa.' });
    }

    if (coupon.status === false) {
      return res.status(400).json({ success: false, message: 'Mã giảm giá này hiện đang tạm khóa.' });
    }

    const now = new Date();
    if (coupon.start_date && new Date(coupon.start_date) > now) {
      return res.status(400).json({ success: false, message: 'Chương trình ưu đãi này chưa bắt đầu.' });
    }

    if (coupon.end_date && new Date(coupon.end_date) < now) {
      return res.status(400).json({ success: false, message: 'Mã giảm giá đã hết hạn sử dụng.' });
    }

    if (coupon.usage_limit && (coupon.used_count || 0) >= coupon.usage_limit) {
      return res.status(400).json({ success: false, message: 'Mã giảm giá đã hết lượt sử dụng.' });
    }

    const minOrderVal = Number(coupon.min_order_value || 0);
    if (orderSubtotal < minOrderVal) {
      return res.status(400).json({
        success: false,
        message: `Đơn hàng tối thiểu ${minOrderVal.toLocaleString('vi-VN')} đ mới có thể áp dụng mã này.`
      });
    }

    let discountAmount = 0;
    const discountVal = Number(coupon.discount_value);

    if (coupon.discount_type === 'percent' || (coupon.discount_type as string) === 'percentage') {
      discountAmount = Math.round((orderSubtotal * discountVal) / 100);
      if (coupon.max_discount_amount && discountAmount > Number(coupon.max_discount_amount)) {
        discountAmount = Number(coupon.max_discount_amount);
      }
    } else if (coupon.discount_type === 'free_shipping') {
      // Phí vận chuyển tiêu chuẩn 50.000đ (cho đơn dưới 2 triệu)
      // Nếu discount_value = 0 hoặc >= 50.000đ -> Miễn phí hoàn toàn 50.000đ
      // Nếu discount_value > 0 -> Giảm tối đa discount_value
      const stdShip = 50000;
      discountAmount = (discountVal === 0 || discountVal >= stdShip) ? stdShip : discountVal;
    } else {
      discountAmount = Math.min(orderSubtotal, discountVal);
    }

    return res.json({
      success: true,
      message: coupon.discount_type === 'free_shipping' ? 'Áp dụng mã miễn phí vận chuyển thành công!' : 'Áp dụng mã giảm giá thành công!',
      data: {
        couponId: coupon.id,
        code: coupon.code,
        discountType: coupon.discount_type,
        discountValue: discountVal,
        discountAmount,
        minOrderValue: minOrderVal,
        maxDiscountAmount: coupon.max_discount_amount ? Number(coupon.max_discount_amount) : null,
      },
    });
  } catch (error: any) {
    console.error('Lỗi kiểm tra mã giảm giá:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi kiểm tra mã giảm giá', error: error.message });
  }
});

// Helper chuẩn hóa discount_type
const resolveDiscountType = (type: any) => {
  if (type === 'free_shipping' || type === 'freeship') return 'free_shipping';
  if (type === 'percentage' || type === 'percent') return 'percent';
  return 'fixed_amount';
};

// ================================================================
// POST /api/coupons - Thêm mã giảm giá mới
// ================================================================
couponsRouter.post('/', optionalToken, async (req: Request, res: Response) => {
  try {
    const { code, discountType, discountValue, minOrderValue, maxDiscountAmount, startDate, endDate, usageLimit, status } = req.body;

    if (!code) {
      return res.status(400).json({ success: false, message: 'Mã voucher không được để trống.' });
    }

    const cleanCode = code.toUpperCase().trim();
    const existing = await prisma.coupons.findUnique({ where: { code: cleanCode } });
    if (existing) {
      return res.status(409).json({ success: false, message: `Mã giảm giá "${cleanCode}" đã tồn tại.` });
    }

    const targetType = resolveDiscountType(discountType);
    const parsedDiscountValue = discountValue !== undefined && discountValue !== null && discountValue !== '' 
      ? parseFloat(discountValue) 
      : (targetType === 'free_shipping' ? 0 : 0);

    const coupon = await prisma.coupons.create({
      data: {
        code: cleanCode,
        discount_type: targetType as any,
        discount_value: parsedDiscountValue,
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
// PUT /api/coupons/:id - Cập nhật mã giảm giá / Đổi trạng thái
// ================================================================
couponsRouter.put('/:id', optionalToken, async (req: Request, res: Response) => {
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
        ...(discountType !== undefined ? { discount_type: resolveDiscountType(discountType) as any } : {}),
        ...(discountValue !== undefined ? { discount_value: parseFloat(discountValue) || 0 } : {}),
        ...(minOrderValue !== undefined ? { min_order_value: parseFloat(minOrderValue) } : {}),
        ...(maxDiscountAmount !== undefined ? { max_discount_amount: maxDiscountAmount ? parseFloat(maxDiscountAmount) : null } : {}),
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
// DELETE /api/coupons/:id - Xóa mã giảm giá (An toàn)
// ================================================================
couponsRouter.delete('/:id', optionalToken, async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id);
    const existing = await prisma.coupons.findUnique({ where: { id } });
    if (!existing) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy mã giảm giá.' });
    }

    try {
      await prisma.coupons.delete({ where: { id } });
      return res.json({ success: true, message: 'Đã xóa mã giảm giá thành công!' });
    } catch (dbErr: any) {
      if (dbErr.code === 'P2003') {
        // Mã đã được liên kết với đơn hàng trong orders -> Vô hiệu hóa thay vì xóa cứng
        await prisma.coupons.update({
          where: { id },
          data: { status: false },
        });
        return res.json({
          success: true,
          message: 'Mã này đã phát sinh đơn hàng trong quá khứ nên hệ thống đã tự động chuyển sang trạng thái "Đã tắt" để bảo toàn lịch sử đơn hàng.',
        });
      }
      throw dbErr;
    }
  } catch (error: any) {
    console.error('Lỗi xóa mã giảm giá:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi xóa mã giảm giá', error: error.message });
  }
});
