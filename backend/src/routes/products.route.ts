import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';

export const productsRouter = Router();

// ================================================================
// GET /api/products
// Query: ?category=sofa&minPrice=0&maxPrice=50000000&page=1&limit=12
// ================================================================
productsRouter.get('/', async (req: Request, res: Response) => {
  try {
    const { category, minPrice, maxPrice, page = '1', limit = '12', search } = req.query;

    const pageNum  = Math.max(1, parseInt(page as string, 10));
    const limitNum = Math.min(50, parseInt(limit as string, 10));
    const skip     = (pageNum - 1) * limitNum;

    const where: any = {
      deleted_at: null,
      status: true,
    };

    if (category) {
      where.categories = { slug: category as string };
    }

    if (search) {
      where.name = { contains: search as string };
    }

    if (minPrice || maxPrice) {
      where.product_variants = {
        some: {
          price: {
            ...(minPrice ? { gte: parseFloat(minPrice as string) } : {}),
            ...(maxPrice ? { lte: parseFloat(maxPrice as string) } : {}),
          },
        },
      };
    }

    const [products, total] = await Promise.all([
      prisma.products.findMany({
        where,
        skip,
        take: limitNum,
        orderBy: { created_at: 'desc' },
        include: {
          categories: { select: { id: true, name: true, slug: true } },
          product_variants: {
            select: { id: true, price: true, compare_at_price: true, stock_quantity: true, color: true, material: true },
            take: 1,
          },
          product_images: {
            where: { is_thumbnail: true },
            select: { image_url: true },
            take: 1,
          },
        },
      }),
      prisma.products.count({ where }),
    ]);

    const data = products.map((p) => ({
      id:          Number(p.id),
      name:        p.name,
      slug:        p.slug,
      brand:       p.brand,
      category:    p.categories.slug,
      categoryLabel: p.categories.name,
      price:       p.product_variants[0] ? Number(p.product_variants[0].price) : 0,
      comparePrice: p.product_variants[0]?.compare_at_price ? Number(p.product_variants[0].compare_at_price) : null,
      stock:       p.product_variants[0]?.stock_quantity ?? 0,
      material:    p.product_variants[0]?.material ?? '',
      color:       p.product_variants[0]?.color ?? '',
      thumbnail:   p.product_images[0]?.image_url ?? null,
      shortDescription: p.short_description,
    }));

    return res.json({
      success: true,
      data,
      pagination: { page: pageNum, limit: limitNum, total, totalPages: Math.ceil(total / limitNum) },
    });
  } catch (error: any) {
    console.error('Loi lay san pham:', error);
    return res.status(500).json({ success: false, message: 'Loi may chu.', error: error.message });
  }
});

// ================================================================
// GET /api/products/:slug
// ================================================================
productsRouter.get('/:slug', async (req: Request, res: Response) => {
  try {
    const { slug } = req.params;

    const product = await prisma.products.findFirst({
      where: { slug, deleted_at: null },
      include: {
        categories: true,
        product_variants: true,
        product_images: { orderBy: { sort_order: 'asc' } },
      },
    });

    if (!product) {
      return res.status(404).json({ success: false, message: 'Khong tim thay san pham.' });
    }

    // Increment view count
    await prisma.products.update({
      where: { id: product.id },
      data: { view_count: { increment: 1 } },
    });

    return res.json({
      success: true,
      data: {
        id:               Number(product.id),
        name:             product.name,
        slug:             product.slug,
        brand:            product.brand,
        content:          product.content,
        shortDescription: product.short_description,
        category:         { id: product.categories.id, name: product.categories.name, slug: product.categories.slug },
        variants: product.product_variants.map((v) => ({
          id:           Number(v.id),
          sku:          v.sku,
          color:        v.color,
          material:     v.material,
          price:        Number(v.price),
          comparePrice: v.compare_at_price ? Number(v.compare_at_price) : null,
          stock:        v.stock_quantity,
          dimensions:   v.dimensions,
        })),
        images: product.product_images.map((img) => ({
          id:          Number(img.id),
          url:         img.image_url,
          isThumbnail: img.is_thumbnail,
        })),
      },
    });
  } catch (error: any) {
    console.error('Loi lay chi tiet san pham:', error);
    return res.status(500).json({ success: false, message: 'Loi may chu.', error: error.message });
  }
});

// ================================================================
// POST /api/products  (Admin – them san pham moi)
// ================================================================
productsRouter.post('/', async (req: Request, res: Response) => {
  try {
    const { name, slug, categoryId, shortDescription, content, brand, price, comparePrice, stock, color, material, imageUrl } = req.body;

    if (!name || !slug || !categoryId || !price) {
      return res.status(400).json({ success: false, message: 'Vui long dien day du ten, slug, danh muc va gia.' });
    }

    // Check slug unique
    const existing = await prisma.products.findFirst({ where: { slug } });
    if (existing) {
      return res.status(409).json({ success: false, message: 'Slug nay da ton tai.' });
    }

    const product = await prisma.products.create({
      data: {
        name,
        slug,
        category_id: parseInt(categoryId),
        short_description: shortDescription || null,
        content: content || null,
        brand: brand || null,
        status: true,
        product_variants: {
          create: {
            sku:             slug.toUpperCase().replace(/-/g, '_') + '_001',
            price:           parseFloat(price),
            compare_at_price: comparePrice ? parseFloat(comparePrice) : null,
            stock_quantity:  parseInt(stock) || 0,
            color:           color || null,
            material:        material || null,
          },
        },
        product_images: imageUrl ? {
          create: { image_url: imageUrl, is_thumbnail: true, sort_order: 0 },
        } : undefined,
      },
      include: { product_variants: true, product_images: true },
    });

    return res.status(201).json({
      success: true,
      message: 'Them san pham thanh cong!',
      data: { id: Number(product.id), name: product.name, slug: product.slug },
    });
  } catch (error: any) {
    console.error('Loi them san pham:', error);
    return res.status(500).json({ success: false, message: 'Loi may chu.', error: error.message });
  }
});

// ================================================================
// PUT /api/products/:id  (Admin – sua san pham)
// ================================================================
productsRouter.put('/:id', async (req: Request, res: Response) => {
  try {
    const id = BigInt(req.params.id);
    const { name, slug, categoryId, shortDescription, content, brand, status, price, comparePrice, stock } = req.body;

    const product = await prisma.products.findFirst({ where: { id } });
    if (!product) return res.status(404).json({ success: false, message: 'Khong tim thay san pham.' });

    await prisma.products.update({
      where: { id },
      data: {
        ...(name        ? { name }                                     : {}),
        ...(slug        ? { slug }                                     : {}),
        ...(categoryId  ? { category_id: parseInt(categoryId) }        : {}),
        ...(shortDescription !== undefined ? { short_description: shortDescription } : {}),
        ...(content     !== undefined ? { content }                    : {}),
        ...(brand       !== undefined ? { brand }                      : {}),
        ...(status      !== undefined ? { status: Boolean(status) }    : {}),
        updated_at: new Date(),
      },
    });

    // Update variant price/stock if provided
    if (price || stock !== undefined) {
      const variant = await prisma.product_variants.findFirst({ where: { product_id: id } });
      if (variant) {
        await prisma.product_variants.update({
          where: { id: variant.id },
          data: {
            ...(price        ? { price: parseFloat(price), compare_at_price: comparePrice ? parseFloat(comparePrice) : variant.compare_at_price } : {}),
            ...(stock !== undefined ? { stock_quantity: parseInt(stock) } : {}),
          },
        });
      }
    }

    return res.json({ success: true, message: 'Cap nhat san pham thanh cong!' });
  } catch (error: any) {
    console.error('Loi sua san pham:', error);
    return res.status(500).json({ success: false, message: 'Loi may chu.', error: error.message });
  }
});

// ================================================================
// DELETE /api/products/:id  (Admin – xoa mem)
// ================================================================
productsRouter.delete('/:id', async (req: Request, res: Response) => {
  try {
    const id = BigInt(req.params.id);
    const product = await prisma.products.findFirst({ where: { id, deleted_at: null } });
    if (!product) return res.status(404).json({ success: false, message: 'Khong tim thay san pham.' });

    await prisma.products.update({
      where: { id },
      data: { deleted_at: new Date(), status: false },
    });

    return res.json({ success: true, message: 'Xoa san pham thanh cong!' });
  } catch (error: any) {
    console.error('Loi xoa san pham:', error);
    return res.status(500).json({ success: false, message: 'Loi may chu.', error: error.message });
  }
});

// ================================================================
// GET /api/products/categories/all
// ================================================================
productsRouter.get('/categories/all', async (_req: Request, res: Response) => {
  try {
    const cats = await prisma.categories.findMany({
      where: { status: true },
      orderBy: { id: 'asc' },
      select: { id: true, name: true, slug: true, image_url: true },
    });
    return res.json({ success: true, data: cats });
  } catch (error: any) {
    return res.status(500).json({ success: false, message: 'Loi may chu.', error: error.message });
  }
});
