import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';
import { verifyToken, requireAdmin } from '../middlewares/auth.middleware.js';

export const categoriesRouter = Router();

// ================================================================
// GET /api/categories - Lấy tất cả danh mục kèm số lượng sản phẩm
// ================================================================
categoriesRouter.get('/', async (_req: Request, res: Response) => {
  try {
    const cats = await prisma.categories.findMany({
      orderBy: { id: 'asc' },
      include: {
        _count: {
          select: { products: { where: { deleted_at: null } } },
        },
      },
    });

    const data = cats.map((c) => ({
      id: c.id,
      name: c.name,
      slug: c.slug,
      imageUrl: c.image_url,
      status: c.status !== false,
      productCount: c._count.products,
    }));

    return res.json({ success: true, data });
  } catch (error: any) {
    console.error('Lỗi lấy danh mục:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi lấy danh mục', error: error.message });
  }
});

// ================================================================
// POST /api/categories - Thêm danh mục mới (Yêu cầu quyền Admin)
// ================================================================
categoriesRouter.post('/', verifyToken, requireAdmin, async (req: Request, res: Response) => {
  try {
    const { name, slug, imageUrl, status } = req.body;

    if (!name || !slug) {
      return res.status(400).json({ success: false, message: 'Tên và slug danh mục không được để trống.' });
    }

    const existing = await prisma.categories.findFirst({
      where: { slug },
    });
    if (existing) {
      return res.status(409).json({ success: false, message: 'Slug danh mục này đã tồn tại.' });
    }

    const category = await prisma.categories.create({
      data: {
        name,
        slug,
        image_url: imageUrl || null,
        status: status !== false,
      },
    });

    return res.status(201).json({
      success: true,
      message: 'Thêm danh mục thành công!',
      data: category,
    });
  } catch (error: any) {
    console.error('Lỗi thêm danh mục:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi thêm danh mục', error: error.message });
  }
});

// ================================================================
// PUT /api/categories/:id - Cập nhật danh mục (Yêu cầu quyền Admin)
// ================================================================
categoriesRouter.put('/:id', verifyToken, requireAdmin, async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id);
    const { name, slug, imageUrl, status } = req.body;

    const existing = await prisma.categories.findUnique({ where: { id } });
    if (!existing) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy danh mục.' });
    }

    const updated = await prisma.categories.update({
      where: { id },
      data: {
        ...(name !== undefined ? { name } : {}),
        ...(slug !== undefined ? { slug } : {}),
        ...(imageUrl !== undefined ? { image_url: imageUrl } : {}),
        ...(status !== undefined ? { status } : {}),
      },
    });

    return res.json({
      success: true,
      message: 'Cập nhật danh mục thành công!',
      data: updated,
    });
  } catch (error: any) {
    console.error('Lỗi cập nhật danh mục:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi cập nhật danh mục', error: error.message });
  }
});

// ================================================================
// DELETE /api/categories/:id - Xóa danh mục (Yêu cầu quyền Admin)
// ================================================================
categoriesRouter.delete('/:id', verifyToken, requireAdmin, async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id);

    const existing = await prisma.categories.findUnique({ where: { id } });
    if (!existing) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy danh mục.' });
    }

    // Kiểm tra xem danh mục có sản phẩm không
    const count = await prisma.products.count({
      where: { category_id: id, deleted_at: null },
    });
    if (count > 0) {
      return res.status(400).json({
        success: false,
        message: `Không thể xóa danh mục này vì còn ${count} sản phẩm đang thuộc danh mục.`,
      });
    }

    await prisma.categories.delete({ where: { id } });

    return res.json({ success: true, message: 'Đã xóa danh mục thành công!' });
  } catch (error: any) {
    console.error('Lỗi xóa danh mục:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi xóa danh mục', error: error.message });
  }
});
