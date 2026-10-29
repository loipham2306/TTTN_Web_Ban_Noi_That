import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';
import { verifyToken, AuthUserPayload } from '../middlewares/auth.middleware.js';
import jwt from 'jsonwebtoken';
import { ENV } from '../config/env.js';

export const ordersRouter = Router();

// POST /api/orders - Tạo đơn hàng mới
ordersRouter.post('/', async (req: Request, res: Response) => {
  try {
    const { fullname, phone, email, province, district, address, note, payment_method, items, coupon_code } = req.body;

    if (!fullname || !phone || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp đầy đủ họ tên, số điện thoại và danh sách sản phẩm.',
      });
    }

    // 1. RÀNG BUỘC BẮT BUỘC: Khách hàng PHẢI ĐĂNG NHẬP trước khi đặt hàng
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'Vui lòng đăng nhập tài khoản trước khi tiến hành đặt hàng.',
      });
    }

    const token = authHeader.split(' ')[1];
    let decoded: AuthUserPayload;
    try {
      decoded = jwt.verify(token, ENV.JWT_SECRET) as AuthUserPayload;
    } catch (tokenErr) {
      return res.status(401).json({
        success: false,
        message: 'Phiên đăng nhập đã hết hạn hoặc không hợp lệ. Vui lòng đăng nhập lại.',
      });
    }

    if (!decoded || !decoded.id) {
      return res.status(401).json({
        success: false,
        message: 'Thông tin tài khoản không hợp lệ. Vui lòng đăng nhập lại.',
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

    // Cập nhật số điện thoại cho tài khoản nếu khách chưa có
    if (phone && !user.phone) {
      try {
        await prisma.users.update({
          where: { id: user.id },
          data: { phone },
        });
      } catch {}
    }

    // 2. Xác thực từng sản phẩm từ CSDL, kiểm tra tồn kho và đối chiếu giá thực tế
    let subtotalAmount = 0;
    const validatedItems: Array<{
      slug: string;
      name: string;
      price: number;
      qty: number;
      productId: bigint | null;
      variantId: bigint | null;
      sku: string;
    }> = [];

    for (const item of items) {
      const slug = String(item.slug || '').trim();
      const requestedQty = Math.max(1, Number(item.qty) || 1);
      let realPrice = Number(item.price) || 0;
      let realName = String(item.name || 'Sản phẩm nội thất');
      let productId: bigint | null = null;
      let variantId: bigint | null = null;
      let sku = slug || `SKU-${Date.now()}`;

      if (slug) {
        const product = await prisma.products.findFirst({
          where: { slug },
          include: { product_variants: true },
        });

        if (product) {
          productId = product.id;
          realName = product.name;

          if (product.product_variants && product.product_variants.length > 0) {
            const variant = product.product_variants[0];
            variantId = variant.id;
            sku = variant.sku || sku;

            // Ràng buộc bảo mật: Luôn lấy giá từ CSDL để tránh can thiệp giá client
            if (variant.price && Number(variant.price) > 0) {
              realPrice = Number(variant.price);
            }

            // Ràng buộc tồn kho: Không cho phép đặt khi hết hàng hoặc số lượng vượt quá kho
            const availableStock = Number(variant.stock_quantity ?? 0);
            if (availableStock <= 0) {
              return res.status(400).json({
                success: false,
                message: `Sản phẩm "${product.name}" hiện đã hết hàng trong kho. Vui lòng chọn sản phẩm khác hoặc liên hệ cửa hàng.`,
              });
            }
            if (requestedQty > availableStock) {
              return res.status(400).json({
                success: false,
                message: `Sản phẩm "${product.name}" chỉ còn ${availableStock} sản phẩm trong kho (quý khách yêu cầu ${requestedQty}).`,
              });
            }
          }
        }
      }

      subtotalAmount += realPrice * requestedQty;
      validatedItems.push({
        slug,
        name: realName,
        price: realPrice,
        qty: requestedQty,
        productId,
        variantId,
        sku,
      });
    }

    // Tính toán giảm giá từ coupon (nếu có)
    let discountAmount = 0;
    let appliedCouponId: number | null = null;
    let appliedCoupon: any = null;

    if (coupon_code) {
      const cleanCoupon = String(coupon_code).toUpperCase().trim();
      const coupon = await prisma.coupons.findUnique({
        where: { code: cleanCoupon },
      });

      if (coupon && coupon.status !== false) {
        const now = new Date();
        const isValidDate = (!coupon.start_date || new Date(coupon.start_date) <= now) &&
                            (!coupon.end_date || new Date(coupon.end_date) >= now);
        const hasUsage = !coupon.usage_limit || (coupon.used_count || 0) < coupon.usage_limit;
        const meetsMin = subtotalAmount >= Number(coupon.min_order_value || 0);

        if (isValidDate && hasUsage && meetsMin) {
          appliedCouponId = coupon.id;
          appliedCoupon = coupon;
          const val = Number(coupon.discount_value);
          if (coupon.discount_type === 'percent' || (coupon.discount_type as string) === 'percentage') {
            discountAmount = Math.round((subtotalAmount * val) / 100);
            if (coupon.max_discount_amount && discountAmount > Number(coupon.max_discount_amount)) {
              discountAmount = Number(coupon.max_discount_amount);
            }
          } else if (coupon.discount_type === 'free_shipping') {
            const stdShip = subtotalAmount >= 2000000 ? 0 : 50000;
            discountAmount = (val === 0 || val >= stdShip) ? stdShip : val;
          } else {
            discountAmount = Math.min(subtotalAmount, val);
          }

          // Tăng lượt sử dụng
          await prisma.coupons.update({
            where: { id: coupon.id },
            data: { used_count: { increment: 1 } },
          });
        }
      }
    }

    // Phí vận chuyển tiêu chuẩn: Miễn phí từ 2 triệu, ngược lại 50.000 đ
    const isFreeShipping = appliedCoupon?.discount_type === 'free_shipping';
    const baseShippingFee = subtotalAmount >= 2000000 ? 0 : 50000;
    let actualShippingFee = baseShippingFee;

    if (isFreeShipping) {
      actualShippingFee = Math.max(0, baseShippingFee - discountAmount);
    }

    const totalAmount = Math.max(0, subtotalAmount - (isFreeShipping ? 0 : discountAmount)) + actualShippingFee;

    // Sinh mã đơn hàng: NT-YYYYMM-XXXX
    const randomSuffix = Math.floor(1000 + Math.random() * 9000);
    const dateStr = new Date().toISOString().slice(2, 7).replace('-', '');
    const orderCode = `NT-${dateStr}-${randomSuffix}`;

    const fullAddress = [address, district, province].filter(Boolean).join(', ');

    // 3. Tạo bản ghi đơn hàng trong bảng `orders`
    const newOrder = await prisma.orders.create({
      data: {
        order_code: orderCode,
        user_id: user.id,
        coupon_id: appliedCouponId,
        shipping_address: fullAddress || 'Tại cửa hàng',
        shipping_fee: actualShippingFee,
        subtotal_amount: subtotalAmount,
        discount_amount: discountAmount,
        total_amount: totalAmount,
        payment_method: payment_method || 'cod',
        payment_status: 'pending',
        order_status: 'pending',
        customer_note: note || null,
      },
    });

    // 4. Tạo chi tiết đơn hàng trong bảng `order_items` và trừ tồn kho thực tế
    for (const item of validatedItems) {
      await prisma.order_items.create({
        data: {
          order_id: newOrder.id,
          product_id: item.productId,
          variant_id: item.variantId,
          product_name: item.name,
          variant_name: null,
          sku: item.sku,
          quantity: item.qty,
          unit_price: item.price,
          total_price: item.price * item.qty,
        },
      });

      // Tự động trừ số lượng tồn kho (stock_quantity) của biến thể sản phẩm trong CSDL
      if (item.variantId) {
        try {
          const currentVariant = await prisma.product_variants.findUnique({
            where: { id: item.variantId },
            select: { stock_quantity: true },
          });
          const currentStock = Number(currentVariant?.stock_quantity ?? 0);
          const newStock = Math.max(0, currentStock - item.qty);
          await prisma.product_variants.update({
            where: { id: item.variantId },
            data: { stock_quantity: newStock },
          });
        } catch (stockErr) {
          console.warn('Lỗi trừ tồn kho biến thể:', item.variantId, stockErr);
        }
      }
    }

    return res.status(201).json({
      success: true,
      message: 'Đặt hàng thành công!',
      data: {
        orderId: Number(newOrder.id),
        orderCode: newOrder.order_code,
        subtotalAmount,
        shippingFee: actualShippingFee,
        totalAmount,
        paymentMethod: newOrder.payment_method,
        customerName: fullname,
        phone,
        address: fullAddress,
        createdAt: newOrder.created_at,
      },
    });
  } catch (error: any) {
    console.error('Lỗi khi tạo đơn hàng:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi máy chủ khi tạo đơn hàng.',
      error: error.message,
    });
  }
});

// GET /api/orders - Lấy danh sách đơn hàng
ordersRouter.get('/', async (_req: Request, res: Response) => {
  try {
    const orderList = await prisma.orders.findMany({
      include: {
        users: true,
        order_items: true,
        coupons: true,
      },
      orderBy: { created_at: 'desc' },
      take: 50,
    });

    const formatted = orderList.map((o) => ({
      id: Number(o.id),
      orderCode: o.order_code,
      customerName: o.users?.full_name ?? 'Khách vãng lai',
      phone: o.users?.phone ?? '',
      email: o.users?.email ?? '',
      shippingAddress: o.shipping_address,
      subtotal: Number(o.subtotal_amount),
      shippingFee: Number(o.shipping_fee ?? 0),
      discountAmount: Number(o.discount_amount ?? 0),
      couponCode: o.coupons?.code ?? null,
      total: Number(o.total_amount),
      paymentMethod: o.payment_method,
      paymentStatus: o.payment_status,
      orderStatus: o.order_status,
      customerNote: o.customer_note,
      createdAt: o.created_at,
      items: o.order_items.map((it) => ({
        id: Number(it.id),
        name: it.product_name,
        sku: it.sku,
        qty: it.quantity,
        price: Number(it.unit_price),
        total: Number(it.total_price),
      })),
    }));

    return res.json({ success: true, data: formatted });
  } catch (error: any) {
    console.error('Lỗi lấy danh sách đơn hàng:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// ================================================================
// GET /api/orders/my-orders - Lấy danh sách đơn hàng của người dùng hiện tại
// ================================================================
ordersRouter.get('/my-orders', verifyToken, async (req: Request, res: Response) => {
  try {
    if (!req.user) {
      return res.status(401).json({ success: false, message: 'Chưa đăng nhập.' });
    }

    const currentUser = await prisma.users.findUnique({
      where: { id: BigInt(req.user.id) },
    });

    const userOrders = await prisma.orders.findMany({
      where: {
        OR: [
          { user_id: BigInt(req.user.id) },
          ...(req.user.email ? [{ users: { email: req.user.email } }] : []),
          ...(currentUser?.phone ? [{ users: { phone: currentUser.phone } }] : []),
        ],
      },
      include: {
        order_items: {
          include: {
            products: {
              include: {
                product_images: {
                  where: { is_thumbnail: true },
                  take: 1,
                },
              },
            },
          },
        },
        users: true,
        coupons: true,
      },
      orderBy: { created_at: 'desc' },
    });

    const totalSpent = userOrders
      .filter((o) => o.payment_status === 'paid' || o.order_status === 'completed')
      .reduce((sum, o) => sum + Number(o.total_amount), 0);

    const formatted = userOrders.map((o) => ({
      id: Number(o.id),
      orderCode: o.order_code,
      customerName: o.users?.full_name ?? null,
      phone: o.users?.phone ?? null,
      email: o.users?.email ?? null,
      createdAt: o.created_at,
      total: Number(o.total_amount),
      subtotal: Number(o.subtotal_amount),
      shippingFee: Number(o.shipping_fee ?? 0),
      discountAmount: Number(o.discount_amount ?? 0),
      couponCode: o.coupons?.code ?? null,
      paymentStatus: o.payment_status,
      orderStatus: o.order_status,
      paymentMethod: o.payment_method,
      shippingAddress: o.shipping_address,
      customerNote: o.customer_note,
      items: o.order_items.map((it) => ({
        id: Number(it.id),
        name: it.product_name,
        slug: it.products?.slug ?? null,
        sku: it.sku,
        imageUrl: it.products?.product_images?.[0]?.image_url ?? null,
        qty: it.quantity,
        price: Number(it.unit_price),
        total: Number(it.total_price),
      })),
    }));

    return res.json({
      success: true,
      data: formatted,
      stats: {
        ordersCount: userOrders.length,
        completedCount: userOrders.filter((o) => o.payment_status === 'paid' || o.order_status === 'completed').length,
        totalSpent,
      },
    });
  } catch (error: any) {
    console.error('Lỗi lấy danh sách đơn hàng của tôi:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// GET /api/orders/:code - Xem chi tiết đơn hàng
ordersRouter.get('/:code', async (req: Request, res: Response) => {
  try {
    const { code } = req.params;
    const order = await prisma.orders.findUnique({
      where: { order_code: code },
      include: {
        users: true,
        order_items: {
          include: {
            products: {
              include: {
                product_images: {
                  where: { is_thumbnail: true },
                  take: 1,
                },
              },
            },
          },
        },
        coupons: true,
      },
    });

    if (!order) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy đơn hàng.' });
    }

    return res.json({
      success: true,
      data: {
        id: Number(order.id),
        orderCode: order.order_code,
        customerName: order.users?.full_name,
        phone: order.users?.phone,
        email: order.users?.email,
        shippingAddress: order.shipping_address,
        subtotal: Number(order.subtotal_amount),
        shippingFee: Number(order.shipping_fee ?? 0),
        discountAmount: Number(order.discount_amount ?? 0),
        couponCode: order.coupons?.code ?? null,
        total: Number(order.total_amount),
        paymentMethod: order.payment_method,
        paymentStatus: order.payment_status,
        orderStatus: order.order_status,
        customerNote: order.customer_note,
        createdAt: order.created_at,
        items: order.order_items.map((it) => ({
          name: it.product_name,
          slug: it.products?.slug ?? null,
          sku: it.sku,
          imageUrl: it.products?.product_images?.[0]?.image_url ?? null,
          qty: it.quantity,
          price: Number(it.unit_price),
          total: Number(it.total_price),
        })),
      },
    });
  } catch (error: any) {
    console.error('Lỗi tra cứu đơn hàng:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});
// ================================================================
// PATCH /api/orders/:id/status - Cập nhật trạng thái đơn hàng & xử lý hoàn/trừ kho
// ================================================================
ordersRouter.patch('/:id/status', async (req: Request, res: Response) => {
  try {
    const orderId = BigInt(req.params.id);
    const { orderStatus, paymentStatus } = req.body;

    const existingOrder = await prisma.orders.findUnique({
      where: { id: orderId },
      include: { order_items: true },
    });

    if (!existingOrder) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy đơn hàng.' });
    }

    // Ánh xạ trạng thái tiếng Việt / frontend sang enum database
    const mapToDbStatus: Record<string, 'pending' | 'confirmed' | 'shipping' | 'completed' | 'cancelled'> = {
      'cho-xac-nhan': 'pending',
      'pending': 'pending',
      'dang-chuan-bi': 'confirmed',
      'confirmed': 'confirmed',
      'dang-giao': 'shipping',
      'shipping': 'shipping',
      'hoan-thanh': 'completed',
      'completed': 'completed',
      'da-huy': 'cancelled',
      'cancelled': 'cancelled',
    };

    const targetOrderStatus = orderStatus ? mapToDbStatus[orderStatus] || orderStatus : undefined;
    const prevStatus = existingOrder.order_status;
    const updateData: any = {};

    if (targetOrderStatus) updateData.order_status = targetOrderStatus;
    if (paymentStatus) updateData.payment_status = paymentStatus;

    // Tự động cập nhật payment_status = 'paid' khi hoàn thành
    if (targetOrderStatus === 'completed' && !paymentStatus) {
      updateData.payment_status = 'paid';
    }

    // Nếu đơn hàng chuyển sang huỷ (cancelled) mà trước đó chưa hủy -> Hoàn lại tồn kho biến thể
    if (targetOrderStatus === 'cancelled' && prevStatus !== 'cancelled') {
      for (const item of existingOrder.order_items) {
        const vId = item.variant_id;
        if (vId) {
          try {
            await prisma.product_variants.update({
              where: { id: vId },
              data: { stock_quantity: { increment: item.quantity } },
            });
          } catch (e) {
            console.warn('Lỗi hoàn tồn kho biến thể ID:', vId, e);
          }
        }
      }
    }

    // Nếu mở lại đơn hàng từng bị hủy -> Trừ lại tồn kho biến thể
    if (prevStatus === 'cancelled' && targetOrderStatus && targetOrderStatus !== 'cancelled') {
      for (const item of existingOrder.order_items) {
        const vId = item.variant_id;
        if (vId) {
          try {
            const v = await prisma.product_variants.findUnique({ where: { id: vId } });
            const curr = Number(v?.stock_quantity ?? 0);
            await prisma.product_variants.update({
              where: { id: vId },
              data: { stock_quantity: Math.max(0, curr - item.quantity) },
            });
          } catch (e) {}
        }
      }
    }

    const updatedOrder = await prisma.orders.update({
      where: { id: orderId },
      data: updateData,
    });

    return res.json({
      success: true,
      message: 'Cập nhật trạng thái đơn hàng thành công!',
      data: {
        id: Number(updatedOrder.id),
        orderCode: updatedOrder.order_code,
        orderStatus: updatedOrder.order_status,
        paymentStatus: updatedOrder.payment_status,
      },
    });
  } catch (error: any) {
    console.error('Lỗi khi cập nhật trạng thái đơn hàng:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});
