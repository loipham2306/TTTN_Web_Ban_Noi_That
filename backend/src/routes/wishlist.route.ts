import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';
import { verifyToken } from '../middlewares/auth.middleware.js';

export const wishlistRouter = Router();

// ================================================================
// GET /api/wishlist - Lấy danh sách sản phẩm yêu thích của tài khoản
// ================================================================
wishlistRouter.get('/', verifyToken, async (req: Request, res: Response) => {
  try {
    const userId = BigInt(req.user!.id);

    const items = await prisma.wishlists.findMany({
      where: { user_id: userId },
      orderBy: { created_at: 'desc' },
      include: {
        products: {
          include: {
            categories: { select: { id: true, name: true, slug: true } },
            product_variants: {
              select: { id: true, price: true, compare_at_price: true, stock_quantity: true },
              take: 1,
            },
            product_images: {
              orderBy: [{ is_thumbnail: 'desc' }, { sort_order: 'asc' }],
              select: { image_url: true },
              take: 1,
            },
          },
        },
      },
    });

    const data = items.map((w) => {
      const p = w.products;
      const variant = p.product_variants[0];
      const image = p.product_images[0];
      return {
        id: Number(w.id),
        productId: Number(p.id),
        name: p.name,
        slug: p.slug,
        category: p.categories?.name || '',
        categorySlug: p.categories?.slug || '',
        price: variant ? Number(variant.price) : 0,
        comparePrice: variant?.compare_at_price ? Number(variant.compare_at_price) : null,
        thumbnail: image?.image_url || null,
        createdAt: w.created_at,
      };
    });

    return res.json({
      success: true,
      data,
      count: data.length,
    });
  } catch (error: any) {
    console.error('Lỗi lấy danh sách yêu thích:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi lấy danh sách yêu thích.', error: error.message });
  }
});

// ================================================================
// POST /api/wishlist/toggle - Thêm hoặc Bỏ yêu thích một sản phẩm
// Body: { slug?: string, productId?: number }
// ================================================================
wishlistRouter.post('/toggle', verifyToken, async (req: Request, res: Response) => {
  try {
    const userId = BigInt(req.user!.id);
    const { slug, productId } = req.body;

    if (!slug && !productId) {
      return res.status(400).json({ success: false, message: 'Vui lòng cung cấp slug hoặc productId.' });
    }

    let product;
    if (productId) {
      product = await prisma.products.findUnique({
        where: { id: BigInt(productId) },
      });
    } else if (slug) {
      product = await prisma.products.findUnique({
        where: { slug: String(slug) },
      });
    }

    if (!product) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy sản phẩm.' });
    }

    const existing = await prisma.wishlists.findUnique({
      where: {
        user_id_product_id: {
          user_id: userId,
          product_id: product.id,
        },
      },
    });

    if (existing) {
      // Đã tim rồi -> Bỏ tim
      await prisma.wishlists.delete({
        where: { id: existing.id },
      });
      return res.json({
        success: true,
        isFavorited: false,
        message: 'Đã xóa sản phẩm khỏi danh sách yêu thích.',
        productId: Number(product.id),
        slug: product.slug,
      });
    } else {
      // Chưa tim -> Thêm tim
      await prisma.wishlists.create({
        data: {
          user_id: userId,
          product_id: product.id,
        },
      });
      return res.json({
        success: true,
        isFavorited: true,
        message: 'Đã lưu sản phẩm vào danh sách yêu thích.',
        productId: Number(product.id),
        slug: product.slug,
      });
    }
  } catch (error: any) {
    console.error('Lỗi toggle yêu thích:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi cập nhật yêu thích.', error: error.message });
  }
});

// ================================================================
// DELETE /api/wishlist/:slugOrId - Xóa sản phẩm khỏi yêu thích
// ================================================================
wishlistRouter.delete('/:slugOrId', verifyToken, async (req: Request, res: Response) => {
  try {
    const userId = BigInt(req.user!.id);
    const param = req.params.slugOrId;

    // Tìm product theo id hoặc slug
    const isNum = /^\d+$/.test(param);
    const product = await prisma.products.findFirst({
      where: isNum
        ? { OR: [{ id: BigInt(param) }, { slug: param }] }
        : { slug: param },
    });

    if (!product) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy sản phẩm.' });
    }

    await prisma.wishlists.deleteMany({
      where: {
        user_id: userId,
        product_id: product.id,
      },
    });

    return res.json({
      success: true,
      message: 'Đã xóa sản phẩm khỏi danh sách yêu thích.',
    });
  } catch (error: any) {
    console.error('Lỗi khi xóa khỏi yêu thích:', error);
    return res.status(500).json({ success: false, message: 'Lỗi khi xóa khỏi yêu thích.', error: error.message });
  }
});
