import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';

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
// POST /api/reviews - Khách hàng gửi đánh giá sản phẩm
// ================================================================
reviewsRouter.post('/', async (req: Request, res: Response) => {
  try {
    const { productSlug, rating, content, name, phone } = req.body;

    if (!productSlug || !content) {
      return res.status(400).json({ success: false, message: 'Vui lòng cung cấp sản phẩm và nội dung đánh giá.' });
    }

    // 1. Tìm sản phẩm theo slug
    const product = await prisma.products.findFirst({
      where: { slug: String(productSlug) },
    });

    if (!product) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy sản phẩm.' });
    }

    // 2. Tìm hoặc tạo tài khoản khách
    let user = null;
    const cleanPhone = phone ? String(phone).trim() : '';

    if (cleanPhone) {
      user = await prisma.users.findFirst({ where: { phone: cleanPhone } });
    }

    if (!user) {
      const guestEmail = `khach_${Date.now()}_${Math.floor(Math.random() * 1000)}@noithat.local`;
      const customerRole = await prisma.roles.findFirst({ where: { name: 'CUSTOMER' } });
      user = await prisma.users.create({
        data: {
          full_name: name || 'Khách hàng',
          phone: cleanPhone || null,
          email: guestEmail,
          password_hash: 'guest_review',
          role_id: customerRole ? customerRole.id : 1,
          status: true,
        },
      });
    }

    // 3. Tìm order_id để liên kết hợp lệ với foreign key
    let order = await prisma.orders.findFirst({
      where: {
        user_id: user.id,
        order_items: { some: { product_id: product.id } },
      },
    });

    if (!order) {
      order = await prisma.orders.findFirst({ where: { user_id: user.id } });
    }
    if (!order) {
      order = await prisma.orders.findFirst({ orderBy: { id: 'desc' } });
    }

    // Nếu hệ thống hoàn toàn chưa có đơn hàng nào, tạo 1 đơn tượng trưng
    if (!order) {
      order = await prisma.orders.create({
        data: {
          order_code: `NT-INIT-${Date.now().toString().slice(-4)}`,
          user_id: user.id,
          shipping_address: 'Hệ thống đánh giá',
          subtotal_amount: 0,
          total_amount: 0,
          payment_method: 'cod',
          payment_status: 'paid',
          order_status: 'completed',
        },
      });
    }

    // 4. Tạo đánh giá vào MySQL
    const numericRating = Math.min(5, Math.max(1, parseInt(rating) || 5));
    const newRev = await prisma.reviews.create({
      data: {
        product_id: product.id,
        user_id: user.id,
        order_id: order.id,
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
      message: 'Cảm ơn quý khách đã đánh giá sản phẩm!',
      data: {
        id: Number(newRev.id),
        customer: newRev.users?.full_name || name,
        rating: newRev.rating,
        comment: newRev.content,
        date: 'Vừa xong',
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
