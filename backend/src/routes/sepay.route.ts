import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';
import { MailerService } from '../services/mailer.service.js';

export const sepayRouter = Router();

/**
 * Helper gửi email xác nhận thanh toán thành công (Bất đồng bộ không chặn)
 */
async function sendPaymentSuccessEmailAsync(
  orderId: bigint,
  paidAmt: number,
  refCode?: string,
  gatewayName?: string,
  transDate?: any
) {
  try {
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

    if (!fullOrder) return;

    const recipientEmail = (() => {
      if (fullOrder.seller_note) {
        const match = fullOrder.seller_note.match(/\[NOTIFY_EMAIL:\s*([^\]\s]+)\]/i);
        if (match && match[1] && match[1].includes('@')) {
          return match[1].trim();
        }
      }
      return fullOrder.users?.email || '';
    })();

    if (!recipientEmail || !recipientEmail.includes('@')) return;

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

    await MailerService.sendPaymentSuccessMail({
      orderCode: fullOrder.order_code,
      customerName: fullOrder.users.full_name || 'Quý khách',
      customerEmail: recipientEmail,
      customerPhone: fullOrder.users.phone || 'Chưa cập nhật',
      shippingAddress: fullOrder.shipping_address,
      paidAmount: paidAmt,
      paymentMethod: fullOrder.payment_method,
      paymentGateway: gatewayName || 'Chuyển khoản VietQR (SePay)',
      referenceCode: refCode || fullOrder.order_code,
      paidAt: transDate || new Date(),
      items,
      totalAmount: Number(fullOrder.total_amount),
    });
  } catch (err: any) {
    console.warn('[SePay Webhook] Không thể gửi email thông báo thanh toán thành công:', err.message);
  }
}

// GET /api/sepay/config - Cung cấp thông tin cấu hình cổng SePay cho Frontend
sepayRouter.get('/config', (_req: Request, res: Response) => {
  return res.json({
    success: true,
    data: {
      bankAccount: process.env.SEPAY_BANK_ACCOUNT || '8890359180209',
      bankName: process.env.SEPAY_BANK_NAME || 'MBBank',
      accountName: process.env.SEPAY_ACCOUNT_NAME || 'TRUONG CHI VY',
    },
  });
});

/**
 * POST /api/sepay/webhook - Tiếp nhận Webhook thông báo biến động số dư từ SePay
 * Header: Authorization: Apikey <SEPAY_API_KEY>
 * Body format theo tài liệu SePay:
 * {
 *   "id": 123456,
 *   "gateway": "MBBank",
 *   "transactionDate": "2026-10-21 11:15:00",
 *   "accountNumber": "0368889999",
 *   "transferType": "in",
 *   "transferAmount": 2500000,
 *   "content": "NT26101234 thanh toan don hang",
 *   "referenceCode": "MB12345678"
 * }
 */
sepayRouter.post('/webhook', async (req: Request, res: Response) => {
  try {
    const authHeader = req.headers.authorization || '';
    const configuredApiKey = process.env.SEPAY_API_KEY;

    // Kiểm tra API Key nếu đã được cấu hình trong .env
    if (configuredApiKey && configuredApiKey !== 'sepay_api_key_secret_demo') {
      const incomingKey = authHeader.replace(/^Apikey\s+/i, '').trim();
      if (incomingKey !== configuredApiKey) {
        console.warn('[SePay Webhook] Sai API Key từ SePay:', incomingKey);
        return res.status(401).json({ success: false, message: 'Sai mã xác thực SePay API Key.' });
      }
    }

    const {
      id,
      gateway,
      transactionDate,
      transferType,
      transferAmount,
      content,
      referenceCode,
    } = req.body;

    console.log('[SePay Webhook] Nhận dữ liệu giao dịch:', {
      id,
      gateway,
      transferType,
      transferAmount,
      content,
      referenceCode,
    });

    // Chỉ xử lý giao dịch tiền vào tài khoản
    if (transferType !== 'in') {
      return res.status(200).json({ success: true, message: 'Bỏ qua giao dịch tiền ra.' });
    }

    const rawContent = String(content || '').toUpperCase();
    const cleanContent = rawContent.replace(/[^A-Z0-9]/g, ''); // Bỏ dấu gạch ngang, khoảng trắng

    // Lấy các đơn hàng đang chờ thanh toán gần đây (tối đa 100 đơn)
    const pendingOrders = await prisma.orders.findMany({
      where: {
        payment_status: 'pending',
      },
      orderBy: { created_at: 'desc' },
      take: 100,
    });

    // Tìm đơn hàng có mã xuất hiện trong nội dung chuyển khoản
    const matchedOrder = pendingOrders.find((order) => {
      const fullCode = order.order_code.toUpperCase();
      const cleanCode = fullCode.replace(/[^A-Z0-9]/g, '');

      // So khớp cả định dạng có gạch (NT-2610-xxxx) và định dạng liền (NT2610xxxx)
      return (
        rawContent.includes(fullCode) ||
        cleanContent.includes(cleanCode) ||
        (cleanCode.length > 5 && cleanContent.includes(cleanCode.slice(-6)))
      );
    });

    if (!matchedOrder) {
      console.warn(`[SePay Webhook] Không tìm thấy đơn hàng phù hợp với nội dung: "${content}"`);
      // Vẫn trả về 200 để SePay không retry liên tục
      return res.status(200).json({
        success: true,
        message: 'Giao dịch đã được ghi nhận nhưng chưa khớp đơn hàng nào.',
      });
    }

    const orderAmount = Number(matchedOrder.total_amount);
    const paidAmount = Number(transferAmount) || 0;

    if (paidAmount < orderAmount) {
      console.warn(
        `[SePay Webhook] Đơn hàng ${matchedOrder.order_code} số tiền chuyển thiếu: ${paidAmount} < ${orderAmount}`
      );
      // Ghi chú đơn hàng bị thiếu tiền
      await prisma.orders.update({
        where: { id: matchedOrder.id },
        data: {
          seller_note: [
            matchedOrder.seller_note,
            `[CẢNH BÁO SePay] Khách chuyển thiếu tiền: Đã nhận ${paidAmount.toLocaleString('vi-VN')} đ (cần ${orderAmount.toLocaleString('vi-VN')} đ). Ref: ${referenceCode || id}`,
          ]
            .filter(Boolean)
            .join('\n'),
        },
      });

      return res.status(200).json({
        success: true,
        message: 'Số tiền chuyển khoản chưa đủ tổng giá trị đơn hàng.',
      });
    }

    // Kiểm tra xem đơn hàng đã được thanh toán trước đó chưa (tránh trùng lặp webhook)
    if (matchedOrder.payment_status === 'paid') {
      console.log(`[SePay Webhook] Đơn hàng ${matchedOrder.order_code} đã được thanh toán trước đó.`);
      return res.status(200).json({
        success: true,
        message: `Đơn hàng ${matchedOrder.order_code} đã thanh toán từ trước.`,
        data: {
          orderCode: matchedOrder.order_code,
          paymentStatus: matchedOrder.payment_status,
        },
      });
    }

    const now = new Date();
    const ym = now.toISOString().slice(2, 7).replace('-', '');
    const cashCode = `PT-${ym}-${String(Date.now()).slice(-4)}${Math.floor(Math.random() * 10)}`;

    // Cập nhật trạng thái đơn hàng và tự động ghi Phiếu Thu ngân hàng vào Sổ Quỹ
    const updatedOrder = await prisma.$transaction(async (tx) => {
      // 1. Cập nhật trạng thái đơn hàng thành đã thanh toán và đã xác nhận
      const order = await tx.orders.update({
        where: { id: matchedOrder.id },
        data: {
          payment_status: 'paid',
          order_status: 'confirmed',
          seller_note: [
            matchedOrder.seller_note,
            `[SePay Webhook] Thanh toán thành công ${paidAmount.toLocaleString('vi-VN')} đ qua ${gateway || 'Ngân hàng MBBank'} (Ref: ${referenceCode || id}) lúc ${transactionDate || now.toLocaleString('vi-VN')}`,
          ]
            .filter(Boolean)
            .join('\n'),
        },
      });

      // 2. Tự động ghi nhận Phiếu Thu tiền gửi ngân hàng vào Sổ Quỹ (cash_transactions)
      const existingTx = await tx.cash_transactions.findFirst({
        where: { reference_code: matchedOrder.order_code },
      });

      if (!existingTx) {
        await tx.cash_transactions.create({
          data: {
            code: cashCode,
            type: 'income',
            category: 'order_payment',
            amount: paidAmount,
            payment_method: 'bank',
            reference_code: matchedOrder.order_code,
            recipient_name: (matchedOrder as any).users?.full_name || 'Khách hàng thanh toán SePay VietQR',
            note: `Thu tiền đơn hàng #${matchedOrder.order_code} qua SePay ${gateway || 'MBBank'} (Giao dịch: ${referenceCode || id})`,
            status: 'completed',
            created_at: now,
          },
        });
      }

      return order;
    });

    console.log(`[SePay Webhook] ✅ Đơn hàng ${updatedOrder.order_code} đã thanh toán thành công và đã ghi sổ quỹ!`);

    // Kích hoạt gửi email xác nhận thanh toán thành công ngầm (Non-blocking)
    sendPaymentSuccessEmailAsync(
      updatedOrder.id,
      paidAmount,
      referenceCode || String(id),
      gateway || 'Ngân hàng (VietQR SePay)',
      transactionDate ? new Date(transactionDate) : new Date()
    );

    return res.status(200).json({
      success: true,
      message: `Đơn hàng ${updatedOrder.order_code} đã được cập nhật thanh toán thành công và ghi sổ quỹ.`,
      data: {
        orderCode: updatedOrder.order_code,
        paymentStatus: updatedOrder.payment_status,
      },
    });
  } catch (error: any) {
    console.error('[SePay Webhook] Lỗi xử lý:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi máy chủ khi xử lý SePay Webhook.',
      error: error.message,
    });
  }
});
