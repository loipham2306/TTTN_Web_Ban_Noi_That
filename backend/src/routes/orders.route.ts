import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';

export const ordersRouter = Router();

// POST /api/orders - Tạo đơn hàng mới
ordersRouter.post('/', async (req: Request, res: Response) => {
  try {
    const { fullname, phone, email, province, district, address, note, payment_method, items } = req.body;

    if (!fullname || !phone || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp đầy đủ họ tên, số điện thoại và danh sách sản phẩm.',
      });
    }

    // 1. Tìm hoặc tạo user liên kết
    let user = null;
    if (email || phone) {
      user = await prisma.users.findFirst({
        where: {
          OR: [
            ...(email ? [{ email }] : []),
            ...(phone ? [{ phone }] : []),
          ],
        },
      });
    }

    if (!user) {
      let customerRole = await prisma.roles.findFirst({
        where: { name: 'customer' },
      });
      if (!customerRole) {
        customerRole = await prisma.roles.findFirst();
      }

      const guestEmail = email || `khach_${Date.now()}@noithat.local`;
      user = await prisma.users.create({
        data: {
          full_name: fullname,
          email: guestEmail,
          phone: phone || null,
          password_hash: 'guest_no_login',
          role_id: customerRole ? customerRole.id : 1,
          status: true,
        },
      });
    }

    // 2. Tính toán tiền
    let subtotalAmount = 0;
    const validatedItems: Array<{
      slug: string;
      name: string;
      price: number;
      qty: number;
    }> = [];

    for (const item of items) {
      const price = Number(item.price) || 0;
      const qty = Math.max(1, Number(item.qty) || 1);
      subtotalAmount += price * qty;
      validatedItems.push({
        slug: String(item.slug || ''),
        name: String(item.name || 'Sản phẩm nội thất'),
        price,
        qty,
      });
    }

    // Miễn phí vận chuyển từ 2 triệu, ngược lại 50.000 đ
    const shippingFee = subtotalAmount >= 2000000 ? 0 : 50000;
    const totalAmount = subtotalAmount + shippingFee;

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
        shipping_address: fullAddress || 'Tại cửa hàng',
        shipping_fee: shippingFee,
        subtotal_amount: subtotalAmount,
        discount_amount: 0,
        total_amount: totalAmount,
        payment_method: payment_method || 'cod',
        payment_status: 'pending',
        order_status: 'pending',
        customer_note: note || null,
      },
    });

    // 4. Tạo chi tiết đơn hàng trong bảng `order_items`
    for (const item of validatedItems) {
      let product = null;
      if (item.slug) {
        product = await prisma.products.findFirst({
          where: { slug: item.slug },
          include: { product_variants: true },
        });
      }

      await prisma.order_items.create({
        data: {
          order_id: newOrder.id,
          product_id: product ? product.id : null,
          variant_id: product?.product_variants?.[0]?.id ?? null,
          product_name: item.name,
          variant_name: null,
          sku: product?.product_variants?.[0]?.sku ?? (item.slug || `SKU-${Date.now()}`),
          quantity: item.qty,
          unit_price: item.price,
          total_price: item.price * item.qty,
        },
      });
    }

    return res.status(201).json({
      success: true,
      message: 'Đặt hàng thành công!',
      data: {
        orderId: Number(newOrder.id),
        orderCode: newOrder.order_code,
        subtotalAmount,
        shippingFee,
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

// GET /api/orders/:code - Xem chi tiết đơn hàng
ordersRouter.get('/:code', async (req: Request, res: Response) => {
  try {
    const { code } = req.params;
    const order = await prisma.orders.findUnique({
      where: { order_code: code },
      include: {
        users: true,
        order_items: true,
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
        total: Number(order.total_amount),
        paymentMethod: order.payment_method,
        paymentStatus: order.payment_status,
        orderStatus: order.order_status,
        customerNote: order.customer_note,
        createdAt: order.created_at,
        items: order.order_items.map((it) => ({
          name: it.product_name,
          sku: it.sku,
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