import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';
import { verifyToken, requireAdmin, requireAdminOrInternal, AuthUserPayload } from '../middlewares/auth.middleware.js';
import jwt from 'jsonwebtoken';
import { ENV } from '../config/env.js';
import { MailerService } from '../services/mailer.service.js';

export const ordersRouter = Router();

/**
 * Trích xuất lý do hủy đơn hàng từ seller_note để hiển thị minh bạch cho khách hàng
 */
export function extractCancelReason(order: { order_status?: string | null; seller_note?: string | null }): string | null {
  if (order.order_status !== 'cancelled') return null;
  if (order.seller_note) {
    const match = order.seller_note.match(/\[CANCEL_REASON:\s*([^\]]+)\]/i);
    if (match) return match[1].trim();
    if (order.seller_note.includes('quá hạn') || order.seller_note.includes('tự động hủy')) {
      return 'Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa nhận được tiền chuyển khoản).';
    }
  }
  return 'Đơn hàng đã được hủy theo yêu cầu.';
}

// POST /api/orders - Tạo đơn hàng mới
ordersRouter.post('/', async (req: Request, res: Response) => {
  try {
    const { fullname, phone, email, province, district, address, note, payment_method, items, coupon_code, save_address } = req.body;

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
      image?: string | null;
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
      let itemImage: string | null = (item.image && String(item.image)) || null;

      if (slug) {
        const product = await prisma.products.findFirst({
          where: { slug },
          include: { product_variants: true, product_images: true },
        });

        if (product) {
          productId = product.id;
          realName = product.name;

          if (product.product_images && product.product_images.length > 0) {
            const thumb = product.product_images.find((img) => img.is_thumbnail) || product.product_images[0];
            if (thumb && thumb.image_url) {
              itemImage = thumb.image_url;
            }
          }

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
        image: itemImage,
      });
    }

    // Thực hiện đặt hàng an toàn trong Database Transaction nguyên tử
    const newOrder = await prisma.$transaction(async (tx) => {
      // 1. Kiểm tra và áp dụng mã giảm giá
      let discountAmount = 0;
      let appliedCouponId: number | null = null;
      let appliedCoupon: any = null;

      if (coupon_code) {
        const cleanCoupon = String(coupon_code).toUpperCase().trim();
        const coupon = await tx.coupons.findUnique({
          where: { code: cleanCoupon },
        });

        if (coupon && coupon.status !== false) {
          const now = new Date();
          const isValidDate = (!coupon.start_date || new Date(coupon.start_date) <= now) &&
                              (!coupon.end_date || new Date(coupon.end_date) >= now);
          const hasUsage = !coupon.usage_limit || (coupon.used_count || 0) < coupon.usage_limit;
          const meetsMin = subtotalAmount >= Number(coupon.min_order_value || 0);

          if (isValidDate && hasUsage && meetsMin) {
            // Ràng buộc bảo mật: Mỗi khách hàng chỉ được dùng mã ưu đãi này 1 lần duy nhất
            const userUsedCoupon = await tx.orders.findFirst({
              where: {
                user_id: user.id,
                coupon_id: coupon.id,
                order_status: { not: 'cancelled' },
              },
            });

            if (userUsedCoupon) {
              throw new Error(`Bạn đã sử dụng mã ưu đãi "${cleanCoupon}" cho một đơn hàng trước đó.`);
            }

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

            // Tăng lượt sử dụng mã
            await tx.coupons.update({
              where: { id: coupon.id },
              data: { used_count: { increment: 1 } },
            });
          }
        }
      }

      // 2. Tính toán cước phí và tổng tiền
      const isFreeShipping = appliedCoupon?.discount_type === 'free_shipping';
      const baseShippingFee = subtotalAmount >= 2000000 ? 0 : 50000;
      let actualShippingFee = baseShippingFee;

      if (isFreeShipping) {
        actualShippingFee = Math.max(0, baseShippingFee - discountAmount);
      }

      const totalAmount = Math.max(0, subtotalAmount - (isFreeShipping ? 0 : discountAmount)) + actualShippingFee;

      // 3. Khóa và kiểm tra lại tồn kho tức thời trong Transaction
      for (const item of validatedItems) {
        if (item.variantId) {
          const currentVariant = await tx.product_variants.findUnique({
            where: { id: item.variantId },
            select: { stock_quantity: true },
          });
          const availableStock = Number(currentVariant?.stock_quantity ?? 0);
          if (availableStock < item.qty) {
            throw new Error(`Sản phẩm "${item.name}" không đủ số lượng tồn kho (hiện chỉ còn ${availableStock} chiếc).`);
          }
        }
      }

      // 4. Sinh mã đơn hàng: NT-YYYYMM-XXXX
      const randomSuffix = Math.floor(1000 + Math.random() * 9000);
      const dateStr = new Date().toISOString().slice(2, 7).replace('-', '');
      const orderCode = `NT-${dateStr}-${randomSuffix}`;
      const fullAddress = [address, district, province].filter(Boolean).join(', ');

      // 5. Tạo đơn hàng trong bảng `orders`
      const orderCreated = await tx.orders.create({
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
          seller_note: (email && String(email).trim()) ? `[NOTIFY_EMAIL:${String(email).trim()}]` : null,
        },
      });

      // 6. Tạo chi tiết đơn hàng `order_items` và trừ tồn kho biến thể
      for (const item of validatedItems) {
        await tx.order_items.create({
          data: {
            order_id: orderCreated.id,
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

        if (item.variantId) {
          await tx.product_variants.update({
            where: { id: item.variantId },
            data: { stock_quantity: { decrement: item.qty } },
          });
        }
      }

      return orderCreated;
    });

    // Tự động lưu địa chỉ vào sổ địa chỉ (user_addresses) nếu khách chưa có địa chỉ nào hoặc có tick chọn lưu địa chỉ
    try {
      if (province && district && address) {
        const addressCount = await prisma.user_addresses.count({ where: { user_id: user.id } });
        if (addressCount === 0 || save_address === true) {
          const duplicate = await prisma.user_addresses.findFirst({
            where: {
              user_id: user.id,
              province: String(province).trim(),
              district: String(district).trim(),
              specific_address: String(address).trim(),
            },
          });
          if (!duplicate) {
            await prisma.user_addresses.create({
              data: {
                user_id: user.id,
                receiver_name: String(fullname || user.full_name).trim(),
                receiver_phone: String(phone || user.phone || '').trim(),
                province: String(province).trim(),
                district: String(district).trim(),
                ward: '',
                specific_address: String(address).trim(),
                is_default: addressCount === 0,
              },
            });
          }
        }
      }
    } catch (saveAddrErr) {
      console.warn('Lỗi tự động lưu địa chỉ nhận hàng:', saveAddrErr);
    }

    // 7. GỬI EMAIL XÁC NHẬN ĐƠN HÀNG TỰ ĐỘNG (Kèm Logo KTUFA & Hình ảnh sản phẩm)
    // Thực thi nền không chặn (Fire-and-forget) để API phản hồi ngay lập tức cho khách hàng
    const recipientEmail = (email && String(email).trim()) || user.email;
    if (recipientEmail && recipientEmail.includes('@')) {
      MailerService.sendOrderConfirmationMail({
        orderCode: newOrder.order_code,
        customerName: fullname,
        customerEmail: recipientEmail,
        customerPhone: phone,
        shippingAddress: newOrder.shipping_address || 'Địa chỉ giao hàng',
        customerNote: newOrder.customer_note,
        paymentMethod: newOrder.payment_method,
        paymentStatus: newOrder.payment_status || 'pending',
        createdAt: newOrder.created_at || new Date(),
        items: validatedItems.map((i) => ({
          name: i.name,
          qty: i.qty,
          price: i.price,
          total: i.price * i.qty,
          sku: i.sku,
          image: i.image,
        })),
        subtotalAmount: Number(newOrder.subtotal_amount),
        shippingFee: Number(newOrder.shipping_fee ?? 0),
        discountAmount: Number(newOrder.discount_amount ?? 0),
        couponCode: coupon_code || null,
        totalAmount: Number(newOrder.total_amount),
      }).catch((mailErr) => {
        console.warn(`[ORDERS ROUTE] Không thể gửi email xác nhận đơn hàng #${newOrder.order_code}:`, mailErr.message);
      });
    }

    return res.status(201).json({
      success: true,
      message: 'Đặt hàng thành công!',
      data: {
        orderId: Number(newOrder.id),
        orderCode: newOrder.order_code,
        subtotalAmount: Number(newOrder.subtotal_amount),
        shippingFee: Number(newOrder.shipping_fee ?? 0),
        totalAmount: Number(newOrder.total_amount),
        paymentMethod: newOrder.payment_method,
        customerName: fullname,
        phone,
        address: newOrder.shipping_address,
        createdAt: newOrder.created_at,
      },
    });
  } catch (error: any) {
    console.error('Lỗi khi tạo đơn hàng:', error);
    return res.status(400).json({
      success: false,
      message: error.message || 'Lỗi khi tạo đơn hàng. Vui lòng kiểm tra lại thông tin.',
      error: error.message,
    });
  }
});

// GET /api/orders - Lấy danh sách đơn hàng
ordersRouter.get('/', requireAdminOrInternal, async (_req: Request, res: Response) => {
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
      cancelReason: extractCancelReason(o),
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

    // Chỉ tính các đơn hàng có trạng thái ĐÃ HOÀN THÀNH (Giao thành công) cho phần Đơn hoàn thành & Tổng chi tiêu tích lũy
    const completedOrders = userOrders.filter((o) => o.order_status === 'completed');
    const totalSpent = completedOrders.reduce((sum, o) => sum + Number(o.total_amount), 0);
    const completedCount = completedOrders.length;

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
      cancelReason: extractCancelReason(o),
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
        completedCount,
        totalSpent,
      },
    });
  } catch (error: any) {
    console.error('Lỗi lấy danh sách đơn hàng của tôi:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// ================================================================
// POST /api/orders/:idOrCode/cancel - Khách hàng hủy đơn hàng của chính mình
// ================================================================
ordersRouter.post('/:idOrCode/cancel', verifyToken, async (req: Request, res: Response) => {
  try {
    if (!req.user) {
      return res.status(401).json({ success: false, message: 'Vui lòng đăng nhập để thực hiện thao tác này.' });
    }

    const { idOrCode } = req.params;
    const { reason, note } = req.body;

    const cancelReason = (reason && String(reason).trim())
      ? String(reason).trim()
      : (note && String(note).trim())
        ? String(note).trim()
        : 'Khách hàng yêu cầu hủy đơn qua trang tài khoản.';

    // Tìm đơn hàng theo ID số hoặc Order Code
    const isNumericId = /^\d+$/.test(idOrCode);
    const existingOrder = await prisma.orders.findFirst({
      where: isNumericId
        ? { id: BigInt(idOrCode) }
        : { order_code: idOrCode },
      include: {
        order_items: true,
        users: true,
      },
    });

    if (!existingOrder) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy đơn hàng cần hủy.' });
    }

    // Kiểm tra quyền sở hữu đơn hàng
    const currentUserId = BigInt(req.user.id);
    const isOwner = existingOrder.user_id === currentUserId ||
      Boolean(req.user.email && existingOrder.users?.email === req.user.email);
    const isAdmin = req.user.role === 'admin' || req.user.role === 'superadmin' || (req.user as any).role_id === 1;

    if (!isOwner && !isAdmin) {
      return res.status(403).json({ success: false, message: 'Bạn không có quyền hủy đơn hàng của người khác.' });
    }

    // Kiểm tra trạng thái đơn hàng có được phép hủy không
    if (existingOrder.order_status === 'cancelled') {
      return res.status(400).json({ success: false, message: 'Đơn hàng này đã được hủy trước đó.' });
    }

    if (existingOrder.order_status === 'shipping') {
      return res.status(400).json({
        success: false,
        message: 'Đơn hàng đang trên đường vận chuyển, không thể hủy. Vui lòng liên hệ Hotline CSKH 1900 636 884 để được hỗ trợ.',
      });
    }

    if (existingOrder.order_status === 'completed') {
      return res.status(400).json({
        success: false,
        message: 'Đơn hàng đã hoàn thành, không thể hủy.',
      });
    }

    // 1. Hoàn lại tồn kho cho các sản phẩm trong đơn
    for (const item of existingOrder.order_items) {
      if (item.variant_id) {
        try {
          await prisma.product_variants.update({
            where: { id: item.variant_id },
            data: { stock_quantity: { increment: item.quantity } },
          });
        } catch (stockErr) {
          console.warn(`[UserCancel] Lỗi hoàn tồn kho biến thể ID ${item.variant_id}:`, stockErr);
        }
      }
    }

    // 2. Hoàn lại lượt sử dụng coupon (nếu có)
    if (existingOrder.coupon_id) {
      try {
        await prisma.coupons.update({
          where: { id: existingOrder.coupon_id },
          data: { used_count: { decrement: 1 } },
        });
      } catch (couponErr) {
        console.warn(`[UserCancel] Lỗi hoàn coupon ID ${existingOrder.coupon_id}:`, couponErr);
      }
    }

    // 3. Ghi nhận lý do hủy vào seller_note
    let currentNote = existingOrder.seller_note || '';
    const reasonTag = `[CANCEL_REASON: ${cancelReason}]`;
    if (/\[CANCEL_REASON:\s*[^\]]+\]/i.test(currentNote)) {
      currentNote = currentNote.replace(/\[CANCEL_REASON:\s*[^\]]+\]/i, reasonTag);
    } else {
      currentNote = (currentNote ? currentNote + '\n' : '') + reasonTag;
    }

    // 4. Cập nhật trạng thái đơn hàng thành 'cancelled'
    const updatedOrder = await prisma.orders.update({
      where: { id: existingOrder.id },
      data: {
        order_status: 'cancelled',
        seller_note: currentNote,
      },
    });

    console.log(`[UserCancel] Khách hàng ${req.user.email || req.user.id} đã hủy thành công đơn hàng #${existingOrder.order_code}. Lý do: ${cancelReason}`);

    return res.json({
      success: true,
      message: `Đã hủy thành công đơn hàng #${existingOrder.order_code}.`,
      data: {
        orderId: Number(updatedOrder.id),
        orderCode: updatedOrder.order_code,
        orderStatus: updatedOrder.order_status,
        cancelReason,
      },
    });
  } catch (error: any) {
    console.error('Lỗi khi hủy đơn hàng:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi hủy đơn hàng.', error: error.message });
  }
});

// ================================================================
// GET /api/orders/analytics - Thống kê doanh thu, giá vốn thực tế, sổ quỹ và KPI
// ================================================================
ordersRouter.get('/analytics', requireAdminOrInternal, async (_req: Request, res: Response) => {
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
        const itemTotal = Number(item.total_price || (Number(item.unit_price) * item.quantity) || 0);
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
        cancelReason: extractCancelReason(order),
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
ordersRouter.patch('/:id/status', verifyToken, requireAdmin, async (req: Request, res: Response) => {
  try {
    const orderId = BigInt(req.params.id);
    const { orderStatus, paymentStatus, cancelReason } = req.body;

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

    // Ghi nhận lý do hủy đơn vào seller_note nếu có
    if (cancelReason && typeof cancelReason === 'string' && cancelReason.trim()) {
      const cleanReason = cancelReason.trim();
      let currentNote = existingOrder.seller_note || '';
      if (/\[CANCEL_REASON:\s*[^\]]+\]/i.test(currentNote)) {
        currentNote = currentNote.replace(/\[CANCEL_REASON:\s*[^\]]+\]/i, `[CANCEL_REASON: ${cleanReason}]`);
      } else {
        currentNote = (currentNote ? currentNote + '\n' : '') + `[CANCEL_REASON: ${cleanReason}]`;
      }
      updateData.seller_note = currentNote;
    }

    // Nếu đơn hàng chuyển sang huỷ (cancelled) mà trước đó chưa hủy -> Hoàn lại tồn kho và hoàn lượt sử dụng coupon
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

      if (existingOrder.coupon_id) {
        try {
          await prisma.coupons.update({
            where: { id: existingOrder.coupon_id },
            data: { used_count: { decrement: 1 } },
          });
        } catch (couponErr) {
          console.warn('Lỗi hoàn lượt sử dụng coupon:', couponErr);
        }
      }
    }

    // Nếu mở lại đơn hàng từng bị hủy -> Trừ lại tồn kho biến thể và tính lại lượt dùng coupon
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

      if (existingOrder.coupon_id) {
        try {
          await prisma.coupons.update({
            where: { id: existingOrder.coupon_id },
            data: { used_count: { increment: 1 } },
          });
        } catch (couponErr) {
          console.warn('Lỗi tăng lại lượt sử dụng coupon:', couponErr);
        }
      }
    }

    const updatedOrder = await prisma.orders.update({
      where: { id: orderId },
      data: updateData,
    });

    // Tự động kích hoạt gửi email Xác nhận Thanh toán Thành công nếu đơn được chuyển sang "Đã thanh toán" (paid)
    if (existingOrder.payment_status !== 'paid' && updateData.payment_status === 'paid') {
      const fullOrder = await prisma.orders.findUnique({
        where: { id: orderId },
        include: {
          users: true,
          order_items: {
            include: {
              products: {
                include: { product_images: true },
              },
            },
          },
        },
      });

      const recipientEmail = (() => {
        if (fullOrder?.seller_note) {
          const match = fullOrder.seller_note.match(/\[NOTIFY_EMAIL:\s*([^\]\s]+)\]/i);
          if (match && match[1] && match[1].includes('@')) {
            return match[1].trim();
          }
        }
        return fullOrder?.users?.email || '';
      })();

      if (fullOrder && recipientEmail && recipientEmail.includes('@')) {
        const items = fullOrder.order_items.map((item) => {
          let imgUrl: string | null = null;
          if (item.products?.product_images && item.products.product_images.length > 0) {
            const thumb = item.products.product_images.find((i) => i.is_thumbnail) || item.products.product_images[0];
            imgUrl = thumb.image_url;
          }
          return {
            name: item.product_name,
            qty: item.quantity,
            price: Number(item.unit_price),
            total: Number(item.total_price),
            sku: item.sku || undefined,
            image: imgUrl,
          };
        });

        MailerService.sendPaymentSuccessMail({
          orderCode: fullOrder.order_code,
          customerName: fullOrder.users.full_name || 'Quý khách',
          customerEmail: recipientEmail,
          customerPhone: fullOrder.users.phone || 'Chưa cập nhật',
          shippingAddress: fullOrder.shipping_address,
          paidAmount: Number(fullOrder.total_amount),
          paymentMethod: fullOrder.payment_method,
          paymentGateway: fullOrder.payment_method === 'cod' ? 'Thanh toán tiền mặt khi nhận hàng (COD)' : 'Chuyển khoản / Quản trị viên duyệt',
          referenceCode: fullOrder.order_code,
          paidAt: new Date(),
          items,
          totalAmount: Number(fullOrder.total_amount),
        }).catch((err) => {
          console.warn('[ORDERS ROUTE] Không thể gửi email thông báo thanh toán thành công:', err.message);
        });
      }
    }

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

// ================================================================
// POST /api/orders/:id/resend-email - Gửi lại email xác nhận đơn hàng (Dành cho Admin/Staff)
// ================================================================
ordersRouter.post('/:id/resend-email', verifyToken, requireAdmin, async (req: Request, res: Response) => {
  try {
    const orderId = BigInt(req.params.id);
    const order = await prisma.orders.findUnique({
      where: { id: orderId },
      include: {
        users: true,
        coupons: true,
        order_items: {
          include: {
            products: {
              include: { product_images: true },
            },
          },
        },
      },
    });

    if (!order) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy đơn hàng.' });
    }

    const recipientEmail = (() => {
      if (order.seller_note) {
        const match = order.seller_note.match(/\[NOTIFY_EMAIL:\s*([^\]\s]+)\]/i);
        if (match && match[1] && match[1].includes('@')) {
          return match[1].trim();
        }
      }
      return order.users?.email || '';
    })();

    if (!recipientEmail || !recipientEmail.includes('@')) {
      return res.status(400).json({ success: false, message: 'Không tìm thấy email của khách hàng liên kết với đơn này.' });
    }

    const items = order.order_items.map((item) => {
      let imgUrl: string | null = null;
      if (item.products?.product_images && item.products.product_images.length > 0) {
        const thumb = item.products.product_images.find((i) => i.is_thumbnail) || item.products.product_images[0];
        imgUrl = thumb.image_url;
      }

      return {
        name: item.product_name,
        qty: item.quantity,
        price: Number(item.unit_price),
        total: Number(item.total_price),
        sku: item.sku || undefined,
        image: imgUrl,
      };
    });

    const result = await MailerService.sendOrderConfirmationMail({
      orderCode: order.order_code,
      customerName: order.users?.full_name || 'Quý khách',
      customerEmail: recipientEmail,
      customerPhone: order.users?.phone || 'Chưa cập nhật',
      shippingAddress: order.shipping_address || 'Địa chỉ giao hàng',
      customerNote: order.customer_note,
      paymentMethod: order.payment_method,
      paymentStatus: order.payment_status || 'pending',
      createdAt: order.created_at || new Date(),
      items,
      subtotalAmount: Number(order.subtotal_amount),
      shippingFee: Number(order.shipping_fee ?? 0),
      discountAmount: Number(order.discount_amount ?? 0),
      couponCode: order.coupons?.code || null,
      totalAmount: Number(order.total_amount),
    });

    return res.json({
      success: true,
      message: `Đã gửi lại email xác nhận đơn hàng tới ${recipientEmail}.`,
      data: result,
    });
  } catch (error: any) {
    console.error('Lỗi khi gửi lại email đơn hàng:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi gửi lại email.', error: error.message });
  }
});

/**
 * Tự động quét và hủy các đơn hàng chưa thanh toán quá số giờ quy định (mặc định 24h).
 * Chỉ hủy các đơn hàng chưa thanh toán (payment_status: 'pending') và đang ở trạng thái 'pending' (Chờ xác nhận).
 * Hoàn lại tồn kho biến thể và hoàn lại lượt dùng mã giảm giá coupon.
 */
export async function autoCancelExpiredOrders(hoursThreshold = 24): Promise<{ cancelledCount: number; orderCodes: string[] }> {
  try {
    const cutoffDate = new Date(Date.now() - hoursThreshold * 60 * 60 * 1000);

    const expiredOrders = await prisma.orders.findMany({
      where: {
        payment_status: 'pending',
        order_status: 'pending',
        created_at: { lte: cutoffDate },
      },
      include: {
        order_items: true,
      },
    });

    if (expiredOrders.length === 0) {
      return { cancelledCount: 0, orderCodes: [] };
    }

    const cancelledCodes: string[] = [];

    for (const order of expiredOrders) {
      try {
        // 1. Hoàn lại tồn kho các biến thể
        for (const item of order.order_items) {
          if (item.variant_id) {
            try {
              await prisma.product_variants.update({
                where: { id: item.variant_id },
                data: { stock_quantity: { increment: item.quantity } },
              });
            } catch (err) {
              console.warn(`[AutoCancel] Lỗi hoàn kho cho biến thể ${item.variant_id}:`, err);
            }
          }
        }

        // 2. Hoàn lại lượt dùng coupon nếu có
        if (order.coupon_id) {
          try {
            await prisma.coupons.update({
              where: { id: order.coupon_id },
              data: { used_count: { decrement: 1 } },
            });
          } catch (err) {
            console.warn(`[AutoCancel] Lỗi hoàn coupon ${order.coupon_id}:`, err);
          }
        }

        // 3. Cập nhật seller_note kèm lý do hủy quá hạn
        let currentNote = order.seller_note || '';
        const reasonTag = `[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán ${hoursThreshold} giờ (chưa thanh toán).]`;
        if (/\[CANCEL_REASON:\s*[^\]]+\]/i.test(currentNote)) {
          currentNote = currentNote.replace(/\[CANCEL_REASON:\s*[^\]]+\]/i, reasonTag);
        } else {
          currentNote = (currentNote ? currentNote + '\n' : '') + reasonTag;
        }

        // 4. Cập nhật order_status = 'cancelled'
        await prisma.orders.update({
          where: { id: order.id },
          data: {
            order_status: 'cancelled',
            seller_note: currentNote,
          },
        });

        cancelledCodes.push(order.order_code);
        console.log(`[AutoCancel] Đã tự động hủy đơn ${order.order_code} do quá hạn thanh toán ${hoursThreshold}h`);
      } catch (itemErr: any) {
        console.error(`[AutoCancel] Lỗi khi xử lý hủy đơn ${order.order_code}:`, itemErr.message);
      }
    }

    return { cancelledCount: cancelledCodes.length, orderCodes: cancelledCodes };
  } catch (error: any) {
    console.error('[AutoCancel] Lỗi trong tiến trình quét đơn quá hạn:', error);
    return { cancelledCount: 0, orderCodes: [] };
  }
}

// ================================================================
// POST /api/orders/auto-cancel-expired - API kích hoạt hủy đơn quá hạn thủ công hoặc webhook cron
// ================================================================
ordersRouter.post('/auto-cancel-expired', async (req: Request, res: Response) => {
  try {
    const hours = req.body?.hours ? Number(req.body.hours) : 24;
    const result = await autoCancelExpiredOrders(hours);
    return res.json({
      success: true,
      message: `Đã quét và tự động hủy ${result.cancelledCount} đơn hàng quá hạn thanh toán ${hours} giờ.`,
      data: result,
    });
  } catch (error: any) {
    return res.status(500).json({ success: false, message: 'Lỗi khi quét hủy đơn quá hạn.', error: error.message });
  }
});
