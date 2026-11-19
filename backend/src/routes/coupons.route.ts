import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';
import { optionalToken, verifyToken, requireAdmin } from '../middlewares/auth.middleware.js';

export const couponsRouter = Router();

// ================================================================
// CẤU HÌNH VOUCHER ĐẶC QUYỀN THĂNG HẠNG HỘI VIÊN
// Mỗi khách hàng chỉ được giảm 1 lần duy nhất cho mỗi bậc thăng hạng
// ================================================================
export const TIER_UPGRADE_VOUCHERS: Record<string, { tierKey: string; tierLabel: string; minSpent: number; perk: string }> = {
  'UP-BAC': {
    tierKey: 'SILVER',
    tierLabel: 'Hạng Bạc',
    minSpent: 5_000_000,
    perk: 'Giảm 5% tối đa 500.000 đ (Chỉ dùng 1 lần)',
  },
  'UP-VANG': {
    tierKey: 'GOLD',
    tierLabel: 'Hạng Vàng',
    minSpent: 20_000_000,
    perk: 'Giảm 10% tối đa 1.500.000 đ (Chỉ dùng 1 lần)',
  },
  'UP-KIMCUONG': {
    tierKey: 'DIAMOND',
    tierLabel: 'Hạng Kim Cương',
    minSpent: 50_000_000,
    perk: 'Giảm 15% tối đa 3.000.000 đ (Chỉ dùng 1 lần)',
  },
};

/**
 * Kiểm tra điều kiện thăng hạng của khách hàng đối với voucher
 */
export async function checkUserTierEligibility(userId: bigint, couponCode: string, prismaClient: any = prisma) {
  const cleanCode = couponCode.toUpperCase().trim();
  const rule = TIER_UPGRADE_VOUCHERS[cleanCode];
  if (!rule) return { isTierVoucher: false, eligible: true };

  const completedOrders = await prismaClient.orders.findMany({
    where: {
      user_id: userId,
      order_status: 'completed',
    },
    select: { total_amount: true },
  });
  const totalSpent = completedOrders.reduce((sum: number, o: any) => sum + Number(o.total_amount || 0), 0);

  if (totalSpent < rule.minSpent) {
    return {
      isTierVoucher: true,
      eligible: false,
      rule,
      totalSpent,
      message: `Mã ưu đãi này chỉ dành cho khách hàng đã thăng ${rule.tierLabel} (Chi tiêu tích lũy từ ${rule.minSpent.toLocaleString('vi-VN')} đ). Tổng chi tiêu hiện tại của bạn: ${totalSpent.toLocaleString('vi-VN')} đ.`,
    };
  }

  return {
    isTierVoucher: true,
    eligible: true,
    rule,
    totalSpent,
  };
}

// ================================================================
// GET /api/coupons - Lấy danh sách mã giảm giá (kèm trạng thái cá nhân hóa)
// ================================================================
couponsRouter.get('/', optionalToken, async (req: Request, res: Response) => {
  try {
    const list = await prisma.coupons.findMany({
      orderBy: { id: 'desc' },
    });

    let userTotalSpent = 0;
    let usedCouponIds: number[] = [];

    if (req.user?.id) {
      const userId = BigInt(req.user.id);
      const [completedOrders, userUsedOrders] = await Promise.all([
        prisma.orders.findMany({
          where: { user_id: userId, order_status: 'completed' },
          select: { total_amount: true },
        }),
        prisma.orders.findMany({
          where: { user_id: userId, coupon_id: { not: null }, order_status: { not: 'cancelled' } },
          select: { coupon_id: true },
        }),
      ]);
      userTotalSpent = completedOrders.reduce((sum: number, o: any) => sum + Number(o.total_amount || 0), 0);
      usedCouponIds = userUsedOrders.map((o) => o.coupon_id as number).filter(Boolean);
    }

    const data = list.map((c) => {
      const codeUpper = c.code.toUpperCase().trim();
      const tierRule = TIER_UPGRADE_VOUCHERS[codeUpper];
      const isTierVoucher = Boolean(tierRule);
      const isUsed = usedCouponIds.includes(c.id);

      let isEligible = true;
      let requirementNote: string | null = null;

      if (isTierVoucher && tierRule) {
        if (!req.user?.id) {
          isEligible = false;
          requirementNote = `Đăng nhập để nhận ưu đãi ${tierRule.tierLabel}`;
        } else if (isUsed) {
          isEligible = false;
          requirementNote = `Bạn đã sử dụng ưu đãi thăng ${tierRule.tierLabel} (Mỗi hội viên chỉ được giảm 1 lần)`;
        } else if (userTotalSpent < tierRule.minSpent) {
          isEligible = false;
          const remain = tierRule.minSpent - userTotalSpent;
          requirementNote = `Tích lũy thêm ${remain.toLocaleString('vi-VN')} đ để mở khóa ${tierRule.tierLabel}`;
        } else {
          isEligible = true;
          requirementNote = `Đặc quyền ${tierRule.tierLabel} khả dụng (Giảm 1 lần duy nhất)`;
        }
      } else if (isUsed) {
        isEligible = false;
        requirementNote = 'Bạn đã sử dụng mã này cho đơn hàng trước đó';
      }

      return {
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
        isTierVoucher,
        tierLabel: tierRule ? tierRule.tierLabel : null,
        minSpentRequired: tierRule ? tierRule.minSpent : null,
        isUsed,
        isEligible,
        requirementNote,
      };
    });

    return res.json({ success: true, data });
  } catch (error: any) {
    console.error('Lỗi lấy mã giảm giá:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi lấy mã giảm giá', error: error.message });
  }
});

// ================================================================
// POST /api/coupons/validate - Kiểm tra và tính toán giảm giá
// ================================================================
couponsRouter.post('/validate', optionalToken, async (req: Request, res: Response) => {
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

    // Kiểm tra điều kiện đặc quyền thăng hạng hội viên (nếu là voucher thăng hạng)
    const tierRule = TIER_UPGRADE_VOUCHERS[cleanCode];
    if (tierRule) {
      if (!req.user?.id) {
        return res.status(401).json({
          success: false,
          message: `Mã ưu đãi "${cleanCode}" là đặc quyền khi thăng ${tierRule.tierLabel}. Vui lòng đăng nhập để sử dụng.`,
        });
      }

      const eligibility = await checkUserTierEligibility(BigInt(req.user.id), cleanCode);
      if (!eligibility.eligible) {
        return res.status(400).json({
          success: false,
          message: eligibility.message,
        });
      }
    }

    // Kiểm tra xem tài khoản khách hàng đã từng dùng mã này chưa (Chỉ dùng 1 lần)
    if (req.user?.id) {
      const userUsed = await prisma.orders.findFirst({
        where: {
          user_id: BigInt(req.user.id),
          coupon_id: coupon.id,
          order_status: { not: 'cancelled' },
        },
      });
      if (userUsed) {
        if (tierRule) {
          return res.status(400).json({
            success: false,
            message: `Bạn đã sử dụng ưu đãi thăng ${tierRule.tierLabel} cho một đơn hàng trước đó rồi (Mỗi khách hàng chỉ được giảm 1 lần khi thăng cấp hạng).`,
          });
        }
        return res.status(400).json({
          success: false,
          message: 'Bạn đã sử dụng mã giảm giá này cho một đơn hàng trước đó.',
        });
      }
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
      message: tierRule
        ? `Áp dụng thành công ưu đãi đặc quyền thăng ${tierRule.tierLabel} (Giảm 1 lần duy nhất)!`
        : (coupon.discount_type === 'free_shipping' ? 'Áp dụng mã miễn phí vận chuyển thành công!' : 'Áp dụng mã giảm giá thành công!'),
      data: {
        couponId: coupon.id,
        code: coupon.code,
        discountType: coupon.discount_type,
        discountValue: discountVal,
        discountAmount,
        minOrderValue: minOrderVal,
        maxDiscountAmount: coupon.max_discount_amount ? Number(coupon.max_discount_amount) : null,
        isTierVoucher: Boolean(tierRule),
        tierLabel: tierRule ? tierRule.tierLabel : null,
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
couponsRouter.post('/', verifyToken, requireAdmin, async (req: Request, res: Response) => {
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
couponsRouter.delete('/:id', verifyToken, requireAdmin, async (req: Request, res: Response) => {
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
