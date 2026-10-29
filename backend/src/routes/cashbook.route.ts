import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';

export const cashbookRouter = Router();

// ================================================================
// GET /api/cashbook - Sổ quỹ thu chi, số dư két tiền mặt & ngân hàng
// ================================================================
cashbookRouter.get('/', async (req: Request, res: Response) => {
  try {
    const { type, method, category, from, to, search, page = '1', limit = '30' } = req.query;

    const pageNum = Math.max(1, parseInt(page as string, 10));
    const limitNum = Math.min(100, parseInt(limit as string, 10));
    const skip = (pageNum - 1) * limitNum;

    const where: any = {
      status: 'completed',
    };

    if (type) {
      where.type = type as 'income' | 'expense';
    }

    if (method) {
      where.payment_method = method as 'cash' | 'bank';
    }

    if (category) {
      where.category = String(category);
    }

    if (search) {
      const q = String(search).trim();
      where.OR = [
        { code: { contains: q } },
        { reference_code: { contains: q } },
        { recipient_name: { contains: q } },
        { note: { contains: q } },
      ];
    }

    if (from || to) {
      where.created_at = {
        ...(from ? { gte: new Date(from as string) } : {}),
        ...(to ? { lte: new Date(to as string) } : {}),
      };
    }

    const [transactions, total, allTransactions, pendingCodOrders, activeDebtSlips] = await Promise.all([
      prisma.cash_transactions.findMany({
        where,
        skip,
        take: limitNum,
        orderBy: { created_at: 'desc' },
        include: {
          users: { select: { id: true, full_name: true, email: true } },
        },
      }),
      prisma.cash_transactions.count({ where }),
      // Toàn bộ giao dịch để tính số dư quỹ
      prisma.cash_transactions.findMany({
        where: { status: 'completed' },
        select: {
          type: true,
          amount: true,
          payment_method: true,
        },
      }),
      // Đơn hàng COD chưa đối soát
      prisma.orders.findMany({
        where: {
          payment_method: 'cod',
          payment_status: 'pending',
          order_status: { notIn: ['cancelled'] },
        },
        select: { total_amount: true },
      }),
      // Phiếu nhập còn nợ NCC
      prisma.import_slips.findMany({
        where: {
          debt_amount: { gt: 0 },
          status: { not: 'cancelled' },
        },
        select: { debt_amount: true },
      }),
    ]);

    // Tính toán số dư tiền mặt và ngân hàng
    let totalCashIncome = 0;
    let totalCashExpense = 0;
    let totalBankIncome = 0;
    let totalBankExpense = 0;

    for (const tx of allTransactions) {
      const amt = Number(tx.amount || 0);
      if (tx.payment_method === 'cash') {
        if (tx.type === 'income') totalCashIncome += amt;
        else totalCashExpense += amt;
      } else {
        if (tx.type === 'income') totalBankIncome += amt;
        else totalBankExpense += amt;
      }
    }

    const cashBalance = totalCashIncome - totalCashExpense;
    const bankBalance = totalBankIncome - totalBankExpense;
    const totalBalance = cashBalance + bankBalance;
    const pendingCodAmount = pendingCodOrders.reduce((sum, o) => sum + Number(o.total_amount || 0), 0);
    const supplierDebtAmount = activeDebtSlips.reduce((sum, s) => sum + Number(s.debt_amount || 0), 0);

    const kpis = {
      cashBalance,
      bankBalance,
      totalBalance,
      totalCashIncome,
      totalCashExpense,
      totalBankIncome,
      totalBankExpense,
      pendingCodCount: pendingCodOrders.length,
      pendingCodAmount,
      supplierDebtAmount,
    };

    const data = transactions.map((t) => ({
      id: Number(t.id),
      code: t.code,
      type: t.type,
      category: t.category,
      categoryLabel: formatCategoryLabel(t.category, t.type),
      amount: Number(t.amount),
      paymentMethod: t.payment_method,
      referenceCode: t.reference_code,
      recipientName: t.recipient_name,
      note: t.note,
      status: t.status,
      performer: t.users ? {
        id: Number(t.users.id),
        name: t.users.full_name,
        email: t.users.email,
      } : null,
      createdAt: t.created_at,
    }));

    return res.json({
      success: true,
      data,
      kpis,
      pagination: {
        page: pageNum,
        limit: limitNum,
        total,
        totalPages: Math.ceil(total / limitNum),
      },
    });
  } catch (error: any) {
    console.error('Lỗi khi lấy sổ quỹ:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// Helper định dạng nhãn danh mục thu chi
function formatCategoryLabel(category: string, type: string): string {
  const map: Record<string, string> = {
    order_cod: 'Thu tiền mặt COD (Đơn hàng)',
    order_bank: 'Thu chuyển khoản VietQR (Đơn hàng)',
    import_payment: 'Chi tiền mua hàng (Phiếu nhập)',
    supplier_debt: 'Chi trả nợ Nhà cung cấp',
    operational: 'Chi phí vận hành showroom',
    shipping: 'Chi cước bốc dỡ & vận chuyển',
    salary: 'Chi lương nhân sự',
    deposit: 'Thu tiền đặt cọc giữ hàng',
    refund: 'Chi hoàn tiền khách trả hàng',
    other: type === 'income' ? 'Khoản thu khác' : 'Khoản chi khác',
  };
  return map[category] || (type === 'income' ? 'Khoản thu' : 'Khoản chi');
}

// ================================================================
// GET /api/cashbook/cod-reconciliation - Danh sách đơn hàng COD chờ đối soát
// ================================================================
cashbookRouter.get('/cod-reconciliation', async (_req: Request, res: Response) => {
  try {
    const orders = await prisma.orders.findMany({
      where: {
        payment_method: 'cod',
        payment_status: 'pending',
        order_status: { notIn: ['cancelled'] },
      },
      orderBy: { created_at: 'desc' },
      include: {
        users: { select: { id: true, full_name: true, phone: true } },
        order_items: true,
      },
    });

    const data = orders.map((o) => ({
      id: Number(o.id),
      orderCode: o.order_code,
      customerName: o.users?.full_name || 'Khách hàng',
      customerPhone: o.users?.phone || 'Chưa cập nhật',
      shippingAddress: o.shipping_address,
      totalAmount: Number(o.total_amount),
      orderStatus: o.order_status,
      paymentStatus: o.payment_status,
      itemsCount: o.order_items.length,
      createdAt: o.created_at,
    }));

    const totalPendingAmount = data.reduce((sum, o) => sum + o.totalAmount, 0);

    return res.json({
      success: true,
      data,
      stats: {
        count: data.length,
        totalAmount: totalPendingAmount,
      },
    });
  } catch (error: any) {
    console.error('Lỗi khi lấy danh sách đối soát COD:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// ================================================================
// POST /api/cashbook/reconcile-cod - Thu ngân xác nhận thu tiền mặt COD từ shipper
// ================================================================
cashbookRouter.post('/reconcile-cod', async (req: Request, res: Response) => {
  try {
    const { orderCodes, note, shipperName } = req.body;

    if (!orderCodes || !Array.isArray(orderCodes) || orderCodes.length === 0) {
      return res.status(400).json({ success: false, message: 'Vui lòng chọn ít nhất 1 đơn hàng để đối soát.' });
    }

    const orders = await prisma.orders.findMany({
      where: {
        order_code: { in: orderCodes },
        payment_method: 'cod',
        payment_status: 'pending',
      },
      include: {
        users: { select: { full_name: true } },
      },
    });

    if (orders.length === 0) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy đơn hàng COD hợp lệ cần đối soát.' });
    }

    const now = new Date();
    const ym = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}`;
    let totalCollected = 0;

    await prisma.$transaction(async (tx) => {
      for (const order of orders) {
        const amount = Number(order.total_amount);
        totalCollected += amount;

        // 1. Cập nhật đơn hàng sang đã thanh toán và hoàn tất
        await tx.orders.update({
          where: { id: order.id },
          data: {
            payment_status: 'paid',
            order_status: 'completed',
            updated_at: now,
          },
        });

        // 2. Tạo Phiếu Thu tiền mặt (PT-...) trong sổ quỹ
        const cashCode = `PT-${ym}-${String(Date.now()).slice(-4)}${Math.floor(Math.random() * 10)}`;
        await tx.cash_transactions.create({
          data: {
            code: cashCode,
            type: 'income',
            category: 'order_cod',
            amount,
            payment_method: 'cash',
            reference_code: order.order_code,
            performer_id: 1, // Thu ngân
            recipient_name: shipperName?.trim() || order.users?.full_name || 'Shipper thu hộ COD',
            note: note?.trim() || `Thu ngân nhận tiền mặt COD đơn hàng #${order.order_code}`,
            status: 'completed',
            created_at: now,
          },
        });
      }
    });

    const fmtVnd = (v: number) => new Intl.NumberFormat('vi-VN').format(v) + ' ₫';
    return res.json({
      success: true,
      message: `Đã đối soát thành công ${orders.length} đơn hàng! Đã thu ${fmtVnd(totalCollected)} vào quỹ tiền mặt.`,
      data: {
        ordersCount: orders.length,
        totalCollected,
      },
    });
  } catch (error: any) {
    console.error('Lỗi khi đối soát tiền mặt COD:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// ================================================================
// POST /api/cashbook/transaction - Thu ngân tạo phiếu thu / chi thủ công
// ================================================================
cashbookRouter.post('/transaction', async (req: Request, res: Response) => {
  try {
    const { type, category, amount, payment_method = 'cash', reference_code, recipient_name, note } = req.body;

    if (!type || (type !== 'income' && type !== 'expense')) {
      return res.status(400).json({ success: false, message: 'Loại phiếu không hợp lệ (thu hoặc chi).' });
    }

    const parsedAmount = parseFloat(amount);
    if (isNaN(parsedAmount) || parsedAmount <= 0) {
      return res.status(400).json({ success: false, message: 'Số tiền giao dịch phải lớn hơn 0.' });
    }

    const now = new Date();
    const ym = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}`;
    const prefix = type === 'income' ? 'PT' : 'PC';
    const code = `${prefix}-${ym}-${String(Date.now()).slice(-4)}`;

    const newTx = await prisma.cash_transactions.create({
      data: {
        code,
        type,
        category: category?.trim() || (type === 'income' ? 'other_income' : 'other_expense'),
        amount: parsedAmount,
        payment_method: payment_method === 'bank' ? 'bank' : 'cash',
        reference_code: reference_code?.trim() || null,
        performer_id: 1,
        recipient_name: recipient_name?.trim() || (type === 'income' ? 'Người nộp tiền' : 'Người nhận tiền'),
        note: note?.trim() || `${type === 'income' ? 'Phiếu thu' : 'Phiếu chi'} tạo thủ công tại quầy thu ngân`,
        status: 'completed',
        created_at: now,
      },
    });

    const actionText = type === 'income' ? 'Phiếu Thu' : 'Phiếu Chi';
    return res.status(201).json({
      success: true,
      message: `Đã lập ${actionText} ${code} thành công!`,
      data: newTx,
    });
  } catch (error: any) {
    console.error('Lỗi khi lập phiếu thu chi:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});
