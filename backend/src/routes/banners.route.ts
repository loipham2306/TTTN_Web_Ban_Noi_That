import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';

export const bannersRouter = Router();

// GET /api/banners - Lấy danh sách banner
bannersRouter.get('/', async (req: Request, res: Response) => {
  try {
    const { position, activeOnly } = req.query;

    const where: any = {};
    if (position && typeof position === 'string') {
      where.position = position;
    }
    if (activeOnly === 'true') {
      where.is_active = true;
    }

    const bannerList = await prisma.banners.findMany({
      where,
      orderBy: [
        { display_order: 'asc' },
        { created_at: 'desc' },
      ],
    });

    const formatted = bannerList.map((b) => ({
      id: Number(b.id),
      title: b.title,
      subtitle: b.subtitle || '',
      description: b.description || '',
      imageUrl: b.image_url,
      linkUrl: b.link_url || '/san-pham',
      buttonText: b.button_text || 'Khám phá ngay',
      position: b.position,
      displayOrder: Number(b.display_order ?? 0),
      isActive: Boolean(b.is_active),
      createdAt: b.created_at,
      updatedAt: b.updated_at,
    }));

    return res.json({
      success: true,
      data: formatted,
    });
  } catch (error: any) {
    console.error('Lỗi khi lấy danh sách banner:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi máy chủ khi lấy danh sách banner.',
      error: error.message,
    });
  }
});

// POST /api/banners - Tạo banner mới
bannersRouter.post('/', async (req: Request, res: Response) => {
  try {
    const {
      title,
      subtitle,
      description,
      imageUrl,
      linkUrl,
      buttonText,
      position = 'hero',
      displayOrder = 0,
      isActive = true,
    } = req.body;

    if (!title || !imageUrl) {
      return res.status(400).json({
        success: false,
        message: 'Tiêu đề và đường dẫn hình ảnh là bắt buộc.',
      });
    }

    const created = await prisma.banners.create({
      data: {
        title: String(title).trim(),
        subtitle: subtitle ? String(subtitle).trim() : null,
        description: description ? String(description).trim() : null,
        image_url: String(imageUrl).trim(),
        link_url: linkUrl ? String(linkUrl).trim() : '/san-pham',
        button_text: buttonText ? String(buttonText).trim() : 'Khám phá ngay',
        position: String(position).trim(),
        display_order: Number(displayOrder) || 0,
        is_active: Boolean(isActive),
      },
    });

    return res.status(201).json({
      success: true,
      message: 'Tạo banner mới thành công!',
      data: {
        id: Number(created.id),
        title: created.title,
        subtitle: created.subtitle,
        description: created.description,
        imageUrl: created.image_url,
        linkUrl: created.link_url,
        buttonText: created.button_text,
        position: created.position,
        displayOrder: Number(created.display_order),
        isActive: Boolean(created.is_active),
      },
    });
  } catch (error: any) {
    console.error('Lỗi khi tạo banner:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi máy chủ khi tạo banner.',
      error: error.message,
    });
  }
});

// PUT /api/banners/:id - Cập nhật banner
bannersRouter.put('/:id', async (req: Request, res: Response) => {
  try {
    const id = Number(req.params.id);
    if (!id) {
      return res.status(400).json({ success: false, message: 'ID không hợp lệ.' });
    }

    const {
      title,
      subtitle,
      description,
      imageUrl,
      linkUrl,
      buttonText,
      position,
      displayOrder,
      isActive,
    } = req.body;

    const data: any = {};
    if (title !== undefined) data.title = String(title).trim();
    if (subtitle !== undefined) data.subtitle = subtitle ? String(subtitle).trim() : null;
    if (description !== undefined) data.description = description ? String(description).trim() : null;
    if (imageUrl !== undefined) data.image_url = String(imageUrl).trim();
    if (linkUrl !== undefined) data.link_url = linkUrl ? String(linkUrl).trim() : '/san-pham';
    if (buttonText !== undefined) data.button_text = buttonText ? String(buttonText).trim() : 'Khám phá ngay';
    if (position !== undefined) data.position = String(position).trim();
    if (displayOrder !== undefined) data.display_order = Number(displayOrder) || 0;
    if (isActive !== undefined) data.is_active = Boolean(isActive);

    const updated = await prisma.banners.update({
      where: { id },
      data,
    });

    return res.json({
      success: true,
      message: 'Cập nhật banner thành công!',
      data: {
        id: Number(updated.id),
        title: updated.title,
        imageUrl: updated.image_url,
        isActive: Boolean(updated.is_active),
      },
    });
  } catch (error: any) {
    console.error('Lỗi khi cập nhật banner:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi máy chủ khi cập nhật banner.',
      error: error.message,
    });
  }
});

// PATCH /api/banners/:id/toggle - Bật/tắt trạng thái hiển thị
bannersRouter.patch('/:id/toggle', async (req: Request, res: Response) => {
  try {
    const id = Number(req.params.id);
    if (!id) {
      return res.status(400).json({ success: false, message: 'ID không hợp lệ.' });
    }

    const banner = await prisma.banners.findUnique({ where: { id } });
    if (!banner) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy banner.' });
    }

    const updated = await prisma.banners.update({
      where: { id },
      data: { is_active: !banner.is_active },
    });

    return res.json({
      success: true,
      message: `Đã ${updated.is_active ? 'bật' : 'tắt'} hiển thị banner thành công!`,
      isActive: Boolean(updated.is_active),
    });
  } catch (error: any) {
    console.error('Lỗi khi bật/tắt banner:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi máy chủ khi đổi trạng thái banner.',
      error: error.message,
    });
  }
});

// DELETE /api/banners/:id - Xóa banner
bannersRouter.delete('/:id', async (req: Request, res: Response) => {
  try {
    const id = Number(req.params.id);
    if (!id) {
      return res.status(400).json({ success: false, message: 'ID không hợp lệ.' });
    }

    await prisma.banners.delete({
      where: { id },
    });

    return res.json({
      success: true,
      message: 'Xóa banner thành công!',
    });
  } catch (error: any) {
    console.error('Lỗi khi xóa banner:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi máy chủ khi xóa banner.',
      error: error.message,
    });
  }
});
