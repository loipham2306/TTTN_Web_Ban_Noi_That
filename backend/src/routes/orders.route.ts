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
      costPrice: number;
      qty: number;
      productId: bigint | null;
      variantId: bigint | null;
      sku: string;
    }> = [];

    for (const item of items) {
      const slug = String(item.slug || '').trim();
      const requestedQty = Math.max(1, Number(item.qty) || 1);
      let realPrice = Number(item.price) || 0;
      let costPrice = 0;
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

            costPrice = Number(variant.cost_price || 0);

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
        costPrice: costPrice > 0 ? costPrice : Math.round(realPrice * 0.58),
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
          cost_price: item.costPrice || 0,
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

// ================================================================
// GET /api/orders/analytics - Thống kê doanh thu, giá vốn thực tế, sổ quỹ và KPI
// ================================================================
ordersRouter.get('/analytics', async (_req: Request, res: Response) => {
  try {
    // 1. Lấy tất cả đơn hàng hợp lệ kèm chi tiết sản phẩm và giá vốn thực
    const [validOrders, allOrdersCount, cancelledOrdersCount, allImportSlips, allCashTxs, aiConsultationsCount, totalRegisteredCustomers] = await Promise.all([
      prisma.orders.findMany({
        where: {
          order_status: { notIn: ['cancelled'] },
        },
        include: {
          users: { select: { id: true, full_name: true, phone: true } },
          order_items: {
            include: {
              product_variants: { select: { id: true, cost_price: true, price: true } },
              products: {
                select: {
                  id: true,
                  name: true,
                  slug: true,
                  categories: { select: { id: true, name: true } },
                  product_images: {
                    select: { image_url: true, is_thumbnail: true },
                    take: 2,
                  },
                },
              },
            },
          },
        },
        orderBy: { created_at: 'asc' },
      }),
      prisma.orders.count(),
      prisma.orders.count({ where: { order_status: 'cancelled' } }),
      prisma.import_slips.findMany({
        where: { status: { not: 'cancelled' } },
        select: {
          total_amount: true,
          paid_amount: true,
          debt_amount: true,
          import_date: true,
        },
      }),
      prisma.cash_transactions.findMany({
        where: { status: 'completed' },
        select: {
          type: true,
          amount: true,
          payment_method: true,
        },
      }),
      prisma.chat_sessions.count(),
      prisma.users.count({
        where: {
          roles: { name: 'customer' },
        },
      }),
    ]);

    // 2. Tính toán Giá Vốn Hàng Bán (COGS) và Lợi Nhuận Gộp THỰC TẾ cho từng đơn hàng
    let totalRevenue = 0;
    let totalCogs = 0;

    // Map chi tiết sản phẩm để tìm Top sản phẩm bán chạy theo số lượt bán & sinh lời
    const productProfitMap: Record<string, {
      id?: number;
      name: string;
      productName: string;
      sku: string;
      quantitySold: number;
      soldQty: number;
      revenue: number;
      cogs: number;
      cost: number;
      profit: number;
      thumbnail?: string | null;
      category?: string;
    }> = {};

    for (const order of validOrders) {
      const orderRev = Number(order.total_amount || 0);
      totalRevenue += orderRev;

      let orderItemCogs = 0;
      for (const item of order.order_items) {
        const itemQty = item.quantity || 1;
        const itemPrice = Number(item.unit_price || 0);
        let itemCost = Number(item.cost_price || 0);

        // Fallback giá vốn nếu chưa có: lấy từ variant hoặc 58% giá bán
        if (itemCost === 0 && item.product_variants?.cost_price) {
          itemCost = Number(item.product_variants.cost_price);
        }
        if (itemCost === 0) {
          itemCost = Math.round(itemPrice * 0.58);
        }

        const lineCogs = itemCost * itemQty;
        const lineRev = Number(item.total_price || itemPrice * itemQty);
        orderItemCogs += lineCogs;

        // Lưu thống kê sản phẩm
        const prodKey = item.product_id ? String(item.product_id) : (item.sku || item.product_name);
        const prodName = item.products?.name || item.product_name;
        const thumbnail = item.products?.product_images?.find((img) => img.is_thumbnail)?.image_url
          || item.products?.product_images?.[0]?.image_url
          || null;
        const category = item.products?.categories?.name || 'Nội thất';

        if (!productProfitMap[prodKey]) {
          productProfitMap[prodKey] = {
            id: item.product_id ? Number(item.product_id) : undefined,
            name: prodName,
            productName: prodName,
            sku: item.sku,
            quantitySold: 0,
            soldQty: 0,
            revenue: 0,
            cogs: 0,
            cost: 0,
            profit: 0,
            thumbnail,
            category,
          };
        }
        productProfitMap[prodKey].quantitySold += itemQty;
        productProfitMap[prodKey].soldQty += itemQty;
        productProfitMap[prodKey].revenue += lineRev;
        productProfitMap[prodKey].cogs += lineCogs;
        productProfitMap[prodKey].cost += lineCogs;
        productProfitMap[prodKey].profit += (lineRev - lineCogs);
      }

      totalCogs += orderItemCogs;
    }

    const totalGrossProfit = totalRevenue - totalCogs;
    const overallMargin = totalRevenue > 0 ? ((totalGrossProfit / totalRevenue) * 100).toFixed(1) + '%' : '0.0%';

    // Top 5 sản phẩm bán chạy nhất dựa trên số lượt bán (quantitySold)
    const topSellingProducts = Object.values(productProfitMap)
      .sort((a, b) => b.quantitySold - a.quantitySold || b.revenue - a.revenue)
      .slice(0, 5)
      .map((p) => ({
        ...p,
        margin: p.revenue > 0 ? ((p.profit / p.revenue) * 100).toFixed(1) + '%' : '0.0%',
      }));

    // Top 5 sản phẩm sinh lời cao nhất
    const topProfitableProducts = Object.values(productProfitMap)
      .sort((a, b) => b.profit - a.profit || b.revenue - a.revenue)
      .slice(0, 5)
      .map((p) => ({
        ...p,
        margin: p.revenue > 0 ? ((p.profit / p.revenue) * 100).toFixed(1) + '%' : '0.0%',
      }));

    // 3. Phân bổ theo Phương Thức Thanh Toán (Payment Method Breakdown)
    const paymentMethodsMap: Record<string, { label: string; revenue: number; orders: number; color: string }> = {
      sepay: { label: 'Chuyển khoản VietQR (SePay)', revenue: 0, orders: 0, color: 'bg-[#173524]' },
      cod: { label: 'Thanh toán tiền mặt COD', revenue: 0, orders: 0, color: 'bg-clay-600' },
      bank: { label: 'Chuyển khoản trực tiếp', revenue: 0, orders: 0, color: 'bg-emerald-700' },
    };

    for (const order of validOrders) {
      const pm = (order.payment_method || 'cod').toLowerCase();
      const target = paymentMethodsMap[pm] ? pm : (pm.includes('sepay') || pm.includes('bank') ? 'sepay' : 'cod');
      paymentMethodsMap[target].revenue += Number(order.total_amount || 0);
      paymentMethodsMap[target].orders += 1;
    }

    const paymentMethodsList = Object.entries(paymentMethodsMap)
      .filter(([_, data]) => data.orders > 0)
      .map(([key, data]) => ({
        key,
        label: data.label,
        revenue: data.revenue,
        orders: data.orders,
        percent: totalRevenue > 0 ? Number(((data.revenue / totalRevenue) * 100).toFixed(1)) : 0,
        color: data.color,
      }))
      .sort((a, b) => b.revenue - a.revenue);

    // 4. Số dư Sổ Quỹ & Dòng tiền thực tế
    let cashBalance = 0;
    let bankBalance = 0;
    let totalCashInflow = 0;
    let totalCashOutflow = 0;

    for (const tx of allCashTxs) {
      const amt = Number(tx.amount || 0);
      if (tx.type === 'income') {
        totalCashInflow += amt;
        if (tx.payment_method === 'cash') cashBalance += amt;
        else bankBalance += amt;
      } else {
        totalCashOutflow += amt;
        if (tx.payment_method === 'cash') cashBalance -= amt;
        else bankBalance -= amt;
      }
    }

    const totalImportSpending = allImportSlips.reduce((sum, s) => sum + Number(s.total_amount || 0), 0);
    const totalSupplierDebt = allImportSlips.reduce((sum, s) => sum + Number(s.debt_amount || 0), 0);

    // 5. Thống kê theo 7 ngày gần nhất
    const today = new Date();
    const daysMap: Record<string, { dateStr: string; dayLabel: string; revenue: number; cogs: number; orders: number }> = {};
    const vnDays = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

    for (let i = 6; i >= 0; i--) {
      const d = new Date(today);
      d.setDate(d.getDate() - i);
      const isoDate = d.toISOString().split('T')[0];
      const dayOfWeek = vnDays[d.getDay()];
      daysMap[isoDate] = {
        dateStr: isoDate,
        dayLabel: dayOfWeek,
        revenue: 0,
        cogs: 0,
        orders: 0,
      };
    }

    for (const order of validOrders) {
      if (order.created_at) {
        const orderDateStr = order.created_at.toISOString().split('T')[0];
        if (daysMap[orderDateStr]) {
          const rev = Number(order.total_amount);
          const cogs = order.order_items.reduce((sum, it) => sum + (Number(it.cost_price || 0) * it.quantity), 0);
          daysMap[orderDateStr].revenue += rev;
          daysMap[orderDateStr].cogs += cogs;
          daysMap[orderDateStr].orders += 1;
        }
      }
    }

    let dailyList = Object.values(daysMap);
    const recent7DaysRevenue = dailyList.reduce((sum, d) => sum + d.revenue, 0);

    if (recent7DaysRevenue === 0 && validOrders.length > 0) {
      const activeDaysMap: Record<string, { dateStr: string; dayLabel: string; revenue: number; cogs: number; orders: number }> = {};
      for (const order of validOrders) {
        if (order.created_at) {
          const orderDateStr = order.created_at.toISOString().split('T')[0];
          const d = new Date(order.created_at);
          const dayOfWeek = vnDays[d.getDay()];
          if (!activeDaysMap[orderDateStr]) {
            activeDaysMap[orderDateStr] = {
              dateStr: orderDateStr,
              dayLabel: `${dayOfWeek} (${d.getDate()}/${d.getMonth() + 1})`,
              revenue: 0,
              cogs: 0,
              orders: 0,
            };
          }
          const rev = Number(order.total_amount);
          const cogs = order.order_items.reduce((sum, it) => sum + (Number(it.cost_price || 0) * it.quantity), 0);
          activeDaysMap[orderDateStr].revenue += rev;
          activeDaysMap[orderDateStr].cogs += cogs;
          activeDaysMap[orderDateStr].orders += 1;
        }
      }
      const sortedActiveDays = Object.values(activeDaysMap).sort((a, b) => a.dateStr.localeCompare(b.dateStr));
      if (sortedActiveDays.length > 0) {
        dailyList = sortedActiveDays.slice(-7);
      }
    }

    const maxDayRevenue = Math.max(...dailyList.map((d) => d.revenue), 1);
    const daily7Days = dailyList.map((d) => {
      const valInMillions = Number((d.revenue / 1_000_000).toFixed(1));
      let height = '0%';
      if (d.revenue > 0) {
        const pct = Math.max(10, Math.round((d.revenue / maxDayRevenue) * 100));
        height = `${pct}%`;
      }
      const profit = d.revenue - d.cogs;
      return {
        day: d.dayLabel,
        date: d.dateStr,
        revenue: d.revenue,
        cogs: d.cogs,
        profit,
        val: valInMillions,
        orders: d.orders,
        height,
      };
    });

    // 6. Thống kê theo 6 tháng gần nhất với GIÁ VỐN & LỢI NHUẬN THỰC TẾ
    const monthsMap: Record<string, { monthLabel: string; yearMonth: string; revenue: number; cogs: number; orders: number; importCost: number }> = {};
    for (let i = 5; i >= 0; i--) {
      const mDate = new Date(today.getFullYear(), today.getMonth() - i, 1);
      const ym = `${mDate.getFullYear()}-${String(mDate.getMonth() + 1).padStart(2, '0')}`;
      monthsMap[ym] = {
        monthLabel: `Tháng ${mDate.getMonth() + 1}`,
        yearMonth: ym,
        revenue: 0,
        cogs: 0,
        orders: 0,
        importCost: 0,
      };
    }

    for (const order of validOrders) {
      if (order.created_at) {
        const ym = `${order.created_at.getFullYear()}-${String(order.created_at.getMonth() + 1).padStart(2, '0')}`;
        if (monthsMap[ym]) {
          const rev = Number(order.total_amount);
          const cogs = order.order_items.reduce((sum, it) => sum + (Number(it.cost_price || 0) * it.quantity), 0);
          monthsMap[ym].revenue += rev;
          monthsMap[ym].cogs += cogs;
          monthsMap[ym].orders += 1;
        }
      }
    }

    for (const slip of allImportSlips) {
      if (slip.import_date) {
        const ym = `${slip.import_date.getFullYear()}-${String(slip.import_date.getMonth() + 1).padStart(2, '0')}`;
        if (monthsMap[ym]) {
          monthsMap[ym].importCost += Number(slip.total_amount);
        }
      }
    }

    const monthlyList = Object.values(monthsMap);
    const maxMonthRev = Math.max(...monthlyList.map((m) => m.revenue), 1);
    const monthlyStats = monthlyList.map((m) => {
      const valInMillions = Math.round(m.revenue / 1_000_000);
      const cost = m.cogs;
      const profit = m.revenue - m.cogs;
      const margin = m.revenue > 0 ? ((profit / m.revenue) * 100).toFixed(1) + '%' : '0.0%';
      let height = '0%';
      if (m.revenue > 0) {
        const pct = Math.max(12, Math.round((m.revenue / maxMonthRev) * 100));
        height = `${pct}%`;
      }
      return {
        month: m.monthLabel,
        yearMonth: m.yearMonth,
        revenue: m.revenue,
        cost,
        profit,
        margin,
        orders: m.orders,
        importCost: m.importCost,
        val: valInMillions,
        height,
      };
    });

    // 7. Tỷ trọng doanh số theo danh mục sản phẩm
    const categoryRevenueMap: Record<string, number> = {};
    for (const order of validOrders) {
      for (const item of order.order_items) {
        const catName = item.products?.categories?.name || 'Sản phẩm khác';
        const itemTotal = Number(item.total_price || (item.unit_price * item.quantity) || 0);
        categoryRevenueMap[catName] = (categoryRevenueMap[catName] || 0) + itemTotal;
      }
    }

    const totalCategorySales = Object.values(categoryRevenueMap).reduce((sum, v) => sum + v, 0);
    const categoryColors = ['bg-[#173524]', 'bg-clay-600', 'bg-emerald-700', 'bg-amber-700', 'bg-stone-600', 'bg-walnut-800'];

    const categoryShare = Object.entries(categoryRevenueMap)
      .map(([name, revenue], idx) => {
        const percent = totalCategorySales > 0 ? Number(((revenue / totalCategorySales) * 100).toFixed(1)) : 0;
        return {
          name,
          revenue,
          percent,
          color: categoryColors[idx % categoryColors.length],
        };
      })
      .sort((a, b) => b.revenue - a.revenue);

    // Current month real stats
    const currentYm = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}`;
    const currentMonthOrders = validOrders.filter((o) => {
      if (!o.created_at) return false;
      const ym = `${o.created_at.getFullYear()}-${String(o.created_at.getMonth() + 1).padStart(2, '0')}`;
      return ym === currentYm;
    });

    const monthlyRevenue = currentMonthOrders.reduce((sum, o) => sum + Number(o.total_amount), 0);
    const monthlyCost = currentMonthOrders.reduce((sum, o) => {
      return sum + o.order_items.reduce((iSum, it) => iSum + (Number(it.cost_price || 0) * it.quantity), 0);
    }, 0);
    const monthlyProfit = monthlyRevenue - monthlyCost;
    const monthlyMargin = monthlyRevenue > 0 ? ((monthlyProfit / monthlyRevenue) * 100).toFixed(1) + '%' : '0.0%';

    return res.json({
      success: true,
      data: {
        kpis: {
          totalRevenue,
          totalCogs,
          totalGrossProfit,
          overallMargin,
          totalOrders: validOrders.length,
          allOrdersCount,
          cancelledOrdersCount,
          monthlyRevenue,
          monthlyCost,
          monthlyProfit,
          monthlyMargin,
          monthlyOrders: currentMonthOrders.length,
          uniqueCustomers: totalRegisteredCustomers,
          aiConsultations: aiConsultationsCount,
          // Sổ quỹ & tiền mặt thực tế
          cashBalance,
          bankBalance,
          totalCashInflow,
          totalCashOutflow,
          totalImportSpending,
          totalSupplierDebt,
        },
        daily7Days,
        monthlyStats,
        categoryShare,
        paymentMethods: paymentMethodsList,
        topSellingProducts,
        topProfitableProducts,
      },
    });
  } catch (error: any) {
    console.error('Lỗi khi tính toán phân tích doanh thu:', error);
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
