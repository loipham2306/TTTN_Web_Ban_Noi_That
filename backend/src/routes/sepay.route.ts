import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';

export const sepayRouter = Router();

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

    // Cập nhật trạng thái đơn hàng thành đã thanh toán và đã xác nhận
    const updatedOrder = await prisma.orders.update({
      where: { id: matchedOrder.id },
      data: {
        payment_status: 'paid',
        order_status: 'confirmed',
        seller_note: [
          matchedOrder.seller_note,
          `[SePay Webhook] Thanh toán thành công ${paidAmount.toLocaleString('vi-VN')} đ qua ${gateway || 'Ngân hàng'} (Ref: ${referenceCode || id}) lúc ${transactionDate || new Date().toLocaleString('vi-VN')}`,
        ]
          .filter(Boolean)
          .join('\n'),
      },
    });

    console.log(`[SePay Webhook] ✅ Đơn hàng ${updatedOrder.order_code} đã thanh toán thành công!`);

    return res.status(200).json({
      success: true,
      message: `Đơn hàng ${updatedOrder.order_code} đã được cập nhật thanh toán thành công.`,
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

/**
 * POST /api/sepay/simulate-payment - Endpoint giả lập thanh toán dành cho môi trường phát triển / Demo Đồ án
 * Body: { orderCode: string }
 */
sepayRouter.post('/simulate-payment', async (req: Request, res: Response) => {
  try {
    const { orderCode } = req.body;

    if (!orderCode) {
      return res.status(400).json({ success: false, message: 'Vui lòng cung cấp mã đơn hàng orderCode.' });
    }

    const order = await prisma.orders.findUnique({
      where: { order_code: orderCode },
    });

    if (!order) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy đơn hàng cần thanh toán giả lập.' });
    }

    const updated = await prisma.orders.update({
      where: { id: order.id },
      data: {
        payment_status: 'paid',
        order_status: 'confirmed',
        seller_note: [
          order.seller_note,
          `[DEMO TEST] Thanh toán giả lập thành công ${Number(order.total_amount).toLocaleString('vi-VN')} đ lúc ${new Date().toLocaleString('vi-VN')}`,
        ]
          .filter(Boolean)
          .join('\n'),
      },
    });

    return res.json({
      success: true,
      message: `Đã giả lập thanh toán thành công cho đơn hàng ${updated.order_code}`,
      data: {
        orderCode: updated.order_code,
        paymentStatus: updated.payment_status,
        orderStatus: updated.order_status,
      },
    });
  } catch (error: any) {
    console.error('[SePay Simulator] Lỗi giả lập thanh toán:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});
