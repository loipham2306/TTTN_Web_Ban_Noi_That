import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';

export const reviewsRouter = Router();

// ================================================================
// GET /api/reviews
// ================================================================
reviewsRouter.get('/', async (req: Request, res: Response) => {
  try {
    const { productSlug } = req.query;

    const where: any = {};
    if (productSlug) {
      where.products = { slug: String(productSlug) };
    }

    const reviews = await prisma.reviews.findMany({
      where,
      orderBy: { created_at: 'desc' },
      include: {
        products: { select: { id: true, name: true, slug: true } },
        users: { select: { id: true, full_name: true, email: true } },
      },
    });

    const data = reviews.map((r) => ({
      id: Number(r.id),
      customer: r.users?.full_name || 'Khách hàng',
      product: r.products?.name || 'Sản phẩm nội thất',
      productSlug: r.products?.slug || '',
      rating: r.rating,
      comment: r.content || '',
      date: r.created_at ? new Date(r.created_at).toLocaleDateString('vi-VN') : '',
      status: r.status ? 'Đã duyệt' : 'Chờ duyệt',
      statusColor: r.status ? 'bg-emerald-100 text-emerald-800 border-emerald-300' : 'bg-amber-100 text-amber-800 border-amber-300',
      adminReply: '',
    }));

    return res.json({ success: true, data });
  } catch (error: any) {
    console.error('Lỗi lấy danh sách đánh giá:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// ================================================================
// DELETE /api/reviews/:id
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
