import { Router, Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import { prisma } from '../config/prisma.js';
import { ENV } from '../config/env.js';

export const reviewsRouter = Router();

// ================================================================
// GET /api/reviews - Lấy danh sách đánh giá
// ================================================================
reviewsRouter.get('/', async (req: Request, res: Response) => {
  try {
    const { productSlug, activeOnly } = req.query;

    const where: any = {};
    if (productSlug) {
      where.products = { slug: String(productSlug) };
    }
    if (activeOnly === 'true') {
      where.status = true;
    }

    const reviews = await prisma.reviews.findMany({
      where,
      orderBy: { created_at: 'desc' },
      include: {
        products: { select: { id: true, name: true, slug: true } },
        users: { select: { id: true, full_name: true, email: true, phone: true } },
      },
    });

    const data = reviews.map((r) => {
      let comment = r.content || '';
      let adminReply = '';
      if (comment.includes('[PHAN_HOI_ADMIN]:')) {
        const parts = comment.split('[PHAN_HOI_ADMIN]:');
        comment = parts[0].trim();
        adminReply = parts[1].trim();
      }

      return {
        id: Number(r.id),
        customer: r.users?.full_name || 'Khách hàng',
        customerPhone: r.users?.phone || '',
        product: r.products?.name || 'Sản phẩm nội thất',
        productSlug: r.products?.slug || '',
        rating: r.rating,
        comment,
        adminReply,
        date: r.created_at ? new Date(r.created_at).toLocaleDateString('vi-VN') : '',
        status: r.status ? 'Đã duyệt' : 'Đã ẩn',
        statusColor: r.status ? 'bg-emerald-100 text-emerald-800 border-emerald-300' : 'bg-red-100 text-red-800 border-red-300',
        isActive: Boolean(r.status),
      };
    });

    return res.json({ success: true, data });
  } catch (error: any) {
    console.error('Lỗi lấy danh sách đánh giá:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// ================================================================
// GET /api/reviews/check-eligibility - Kiểm tra khách đã mua hàng hay chưa
// ================================================================
reviewsRouter.get('/check-eligibility', async (req: Request, res: Response) => {
  try {
    const { productSlug, phone, email } = req.query;

    if (!productSlug) {
      return res.status(400).json({ success: false, message: 'Thiếu productSlug' });
    }

    let authUserId: bigint | null = null;
    let authUserEmail: string | null = null;
    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.split(' ')[1];
      try {
        const decoded = jwt.verify(token, ENV.JWT_SECRET) as any;
        if (decoded?.id) authUserId = BigInt(decoded.id);
        if (decoded?.email) authUserEmail = String(decoded.email).trim().toLowerCase();
      } catch {}
    }

    const slugStr = String(productSlug);
    const product = await prisma.products.findFirst({
      where: {
        OR: [
          { slug: slugStr },
          { id: !isNaN(Number(slugStr)) ? BigInt(slugStr) : -1 },
        ],
      },
    });

    if (!product) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy sản phẩm.' });
    }

    const cleanPhone = phone ? String(phone).trim() : '';
    const cleanEmail = email ? String(email).trim().toLowerCase() : (authUserEmail || '');

    const userMatchConditions: any[] = [];
    if (authUserId) userMatchConditions.push({ user_id: authUserId });
    if (cleanPhone) userMatchConditions.push({ users: { phone: cleanPhone } });
    if (cleanEmail) userMatchConditions.push({ users: { email: cleanEmail } });

    if (userMatchConditions.length === 0) {
      return res.json({
        success: true,
        canReview: false,
        reason: 'not_authenticated',
        message: 'Vui lòng đăng nhập hoặc nhập số điện thoại đặt hàng để đánh giá.',
      });
    }

    const purchasedOrder = await prisma.orders.findFirst({
      where: {
        OR: userMatchConditions,
        order_items: {
          some: {
            OR: [
              { product_id: product.id },
              { product_name: { contains: product.name } },
            ],
          },
        },
        order_status: { not: 'cancelled' },
      },
      orderBy: { id: 'desc' },
    });

    if (!purchasedOrder) {
      return res.json({
        success: true,
        canReview: false,
        reason: 'not_purchased',
        message: 'Bạn chưa mua sản phẩm này hoặc đơn hàng đã bị hủy.',
      });
    }

    const reviewed = await prisma.reviews.findFirst({
      where: {
        product_id: product.id,
        order_id: purchasedOrder.id,
      },
    });

    if (reviewed) {
      return res.json({
        success: true,
        canReview: false,
        reason: 'already_reviewed',
        message: 'Bạn đã gửi đánh giá cho sản phẩm này rồi.',
      });
    }

    return res.json({
      success: true,
      canReview: true,
      orderCode: purchasedOrder.order_code,
      message: 'Bạn đủ điều kiện đánh giá sản phẩm này.',
    });
  } catch (error: any) {
    console.error('Lỗi kiểm tra quyền đánh giá:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// ================================================================
// POST /api/reviews - Khách hàng gửi đánh giá sản phẩm
// RÀNG BUỘC: Khách hàng PHẢI ĐÃ TỪNG MUA sản phẩm đó thành công
// ================================================================
reviewsRouter.post('/', async (req: Request, res: Response) => {
  try {
    const { productSlug, rating, content, name, phone, email } = req.body;

    if (!productSlug || !content) {
      return res.status(400).json({ success: false, message: 'Vui lòng cung cấp sản phẩm và nội dung đánh giá.' });
    }

    // 1. Tìm sản phẩm theo slug hoặc id
    const slugStr = String(productSlug);
    const product = await prisma.products.findFirst({
      where: {
        OR: [
          { slug: slugStr },
          { id: !isNaN(Number(slugStr)) ? BigInt(slugStr) : -1 },
        ],
      },
    });

    if (!product) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy sản phẩm.' });
    }

    // 2. RÀNG BUỘC BẮT BUỘC: Khách hàng PHẢI ĐĂNG NHẬP mới được gửi đánh giá
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'Vui lòng đăng nhập tài khoản trước khi gửi đánh giá sản phẩm.',
      });
    }

    const token = authHeader.split(' ')[1];
    let decoded: any;
    try {
      decoded = jwt.verify(token, ENV.JWT_SECRET) as any;
    } catch (err) {
      return res.status(401).json({
        success: false,
        message: 'Phiên đăng nhập đã hết hạn hoặc không hợp lệ. Vui lòng đăng nhập lại.',
      });
    }

    if (!decoded || !decoded.id) {
      return res.status(401).json({
        success: false,
        message: 'Thông tin xác thực không hợp lệ. Vui lòng đăng nhập lại.',
      });
    }

    const user = await prisma.users.findUnique({
      where: { id: BigInt(decoded.id) },
    });

    if (!user || user.status === false) {
      return res.status(403).json({
        success: false,
        message: 'Tài khoản người dùng không tồn tại hoặc đã bị khóa.',
      });
    }

    // 3. RÀNG BUỘC CHẶT CHẼ: KHÁCH HÀNG PHẢI ĐÃ TỪNG MUA SẢN PHẨM NÀY
    const cleanPhone = phone ? String(phone).trim() : (user.phone || '');
    const cleanEmail = email ? String(email).trim().toLowerCase() : user.email;

    const userMatchConditions: any[] = [{ user_id: user.id }];
    if (cleanPhone) userMatchConditions.push({ users: { phone: cleanPhone } });
    if (cleanEmail) userMatchConditions.push({ users: { email: cleanEmail } });

    // Tìm đơn hàng hợp lệ có chứa sản phẩm này (không bị hủy)
    const purchasedOrder = await prisma.orders.findFirst({
      where: {
        OR: userMatchConditions,
        order_items: {
          some: {
            OR: [
              { product_id: product.id },
              { product_name: { contains: product.name } },
            ],
          },
        },
        order_status: { not: 'cancelled' },
      },
      orderBy: { id: 'desc' },
      include: {
        users: true,
      },
    });

    if (!purchasedOrder) {
      return res.status(403).json({
        success: false,
        message: 'Bạn chưa mua sản phẩm này (hoặc đơn hàng đã bị hủy). Chỉ khách hàng đã mua sản phẩm mới có quyền gửi đánh giá.',
      });
    }

    // 4. Kiểm tra xem người dùng đã từng gửi đánh giá cho sản phẩm này chưa
    const existingReview = await prisma.reviews.findFirst({
      where: {
        product_id: product.id,
        user_id: user.id,
      },
    });

    if (existingReview) {
      return res.status(400).json({
        success: false,
        message: 'Bạn đã gửi đánh giá cho sản phẩm này rồi. Cảm ơn quý khách đã đóng góp ý kiến!',
      });
    }

    // 5. Tạo đánh giá vào MySQL
    const numericRating = Math.min(5, Math.max(1, parseInt(rating) || 5));
    const newRev = await prisma.reviews.create({
      data: {
        product_id: product.id,
        user_id: user.id,
        order_id: purchasedOrder.id,
        rating: numericRating,
        content: String(content).trim(),
        status: true, // Mặc định hiển thị
      },
      include: {
        users: { select: { full_name: true } },
      },
    });

    return res.status(201).json({
      success: true,
      message: 'Cảm ơn quý khách đã mua hàng và đánh giá sản phẩm!',
      data: {
        id: Number(newRev.id),
        customer: newRev.users?.full_name || name || 'Khách hàng chính hãng',
        rating: newRev.rating,
        comment: newRev.content,
        date: 'Vừa xong',
        isVerifiedBuyer: true,
      },
    });
  } catch (error: any) {
    console.error('Lỗi khi gửi đánh giá:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi gửi đánh giá.', error: error.message });
  }
});

// ================================================================
// PATCH /api/reviews/:id/status - Admin Ẩn / Hiện đánh giá
// ================================================================
reviewsRouter.patch('/:id/status', async (req: Request, res: Response) => {
  try {
    const id = BigInt(req.params.id);
    const { status } = req.body;

    const existing = await prisma.reviews.findUnique({ where: { id } });
    if (!existing) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy đánh giá.' });
    }

    const nextStatus = status !== undefined ? Boolean(status) : !existing.status;
    const updated = await prisma.reviews.update({
      where: { id },
      data: { status: nextStatus },
    });

    return res.json({
      success: true,
      message: nextStatus ? 'Đã duyệt hiển thị đánh giá!' : 'Đã ẩn đánh giá khỏi website!',
      status: nextStatus ? 'Đã duyệt' : 'Đã ẩn',
      isActive: nextStatus,
    });
  } catch (error: any) {
    console.error('Lỗi cập nhật trạng thái đánh giá:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// ================================================================
// POST /api/reviews/:id/reply - Admin phản hồi đánh giá
// ================================================================
reviewsRouter.post('/:id/reply', async (req: Request, res: Response) => {
  try {
    const id = BigInt(req.params.id);
    const { reply } = req.body;

    const existing = await prisma.reviews.findUnique({ where: { id } });
    if (!existing) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy đánh giá.' });
    }

    const baseComment = (existing.content || '').split('[PHAN_HOI_ADMIN]:')[0].trim();
    const cleanReply = reply ? String(reply).trim() : '';
    const updatedContent = cleanReply ? `${baseComment}\n\n[PHAN_HOI_ADMIN]: ${cleanReply}` : baseComment;

    await prisma.reviews.update({
      where: { id },
      data: { content: updatedContent },
    });

    return res.json({
      success: true,
      message: 'Đã gửi phản hồi đánh giá thành công!',
      adminReply: cleanReply,
    });
  } catch (error: any) {
    console.error('Lỗi khi phản hồi đánh giá:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// ================================================================
// DELETE /api/reviews/:id - Xóa đánh giá
// ================================================================
reviewsRouter.delete('/:id', async (req: Request, res: Response) => {
  try {
    const id = BigInt(req.params.id);
    await prisma.reviews.delete({ where: { id } });
    return res.json({ success: true, message: 'Đã xóa đánh giá thành công!' });
  } catch (error: any) {
    return res.status(500).json({ success: false, message: 'Lỗi khi xóa đánh giá.', error: error.message });
  }
});
