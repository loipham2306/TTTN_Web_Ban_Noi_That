import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';

export const importSlipsRouter = Router();

// ================================================================
// GET /api/import-slips - Danh sách phiếu nhập hàng kèm KPI và bộ lọc
// ================================================================
importSlipsRouter.get('/', async (req: Request, res: Response) => {
  try {
    const { supplierId, paymentStatus, status, search, from, to, page = '1', limit = '20' } = req.query;

    const pageNum = Math.max(1, parseInt(page as string, 10));
    const limitNum = Math.min(100, parseInt(limit as string, 10));
    const skip = (pageNum - 1) * limitNum;

    const where: any = {};

    if (supplierId) {
      where.supplier_id = parseInt(supplierId as string, 10);
    }

    if (paymentStatus) {
      where.payment_status = String(paymentStatus);
    }

    if (status) {
      where.status = String(status);
    }

    if (search) {
      const q = String(search).trim();
      where.OR = [
        { slip_code: { contains: q } },
        { suppliers: { name: { contains: q } } },
        { note: { contains: q } },
      ];
    }

    if (from || to) {
      where.import_date = {
        ...(from ? { gte: new Date(from as string) } : {}),
        ...(to ? { lte: new Date(to as string) } : {}),
      };
    }

    const [slips, total, allSlips] = await Promise.all([
      prisma.import_slips.findMany({
        where,
        skip,
        take: limitNum,
        orderBy: { import_date: 'desc' },
        include: {
          suppliers: {
            select: { id: true, code: true, name: true, phone: true, email: true, address: true, contact_person: true },
          },
          users: {
            select: { id: true, full_name: true, email: true },
          },
          import_slip_items: true,
        },
      }),
      prisma.import_slips.count({ where }),
      prisma.import_slips.findMany({
        where: { status: { not: 'cancelled' } },
        select: {
          total_amount: true,
          paid_amount: true,
          debt_amount: true,
          total_items: true,
        },
      }),
    ]);

    // KPI tổng quan nhập kho
    const kpis = {
      totalSlips: allSlips.length,
      totalImportValue: allSlips.reduce((sum, s) => sum + Number(s.total_amount || 0), 0),
      totalPaid: allSlips.reduce((sum, s) => sum + Number(s.paid_amount || 0), 0),
      totalDebt: allSlips.reduce((sum, s) => sum + Number(s.debt_amount || 0), 0),
      totalItemsImported: allSlips.reduce((sum, s) => sum + (s.total_items || 0), 0),
    };

    const data = slips.map((s) => ({
      id: Number(s.id),
      code: s.slip_code,
      slipCode: s.slip_code,
      supplier: s.suppliers ? {
        id: s.suppliers.id,
        code: s.suppliers.code,
        name: s.suppliers.name,
        contactPerson: s.suppliers.contact_person,
        phone: s.suppliers.phone,
        email: s.suppliers.email,
        address: s.suppliers.address,
      } : null,
      creator: s.users ? {
        id: Number(s.users.id),
        name: s.users.full_name,
        fullName: s.users.full_name,
        email: s.users.email,
      } : null,
      totalItems: s.total_items,
      subtotalAmount: Number(s.subtotal_amount),
      discountAmount: Number(s.discount_amount),
      taxAmount: Number(s.tax_amount),
      shippingFee: Number(s.shipping_fee),
      totalAmount: Number(s.total_amount),
      paidAmount: Number(s.paid_amount),
      debtAmount: Number(s.debt_amount),
      paymentMethod: s.payment_method,
      paymentStatus: s.payment_status,
      status: s.status,
      importDate: s.import_date,
      note: s.note,
      itemsCount: s.import_slip_items.length,
      items: s.import_slip_items.map((it) => ({
        id: Number(it.id),
        productId: it.product_id ? Number(it.product_id) : null,
        variantId: it.variant_id ? Number(it.variant_id) : null,
        sku: it.sku,
        productName: it.product_name,
        variantName: it.variant_name,
        quantity: it.quantity,
        importPrice: Number(it.import_price),
        costPrice: Number(it.import_price),
        sellingPrice: Number(it.selling_price),
        totalPrice: Number(it.total_price),
        note: it.note,
      })),
      createdAt: s.created_at,
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
    console.error('Lỗi khi lấy danh sách phiếu nhập hàng:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// ================================================================
// GET /api/import-slips/:idOrCode - Xem chi tiết 1 phiếu nhập hàng
// ================================================================
importSlipsRouter.get('/:idOrCode', async (req: Request, res: Response) => {
  try {
    const { idOrCode } = req.params;
    const isId = /^\d+$/.test(idOrCode);

    const slip = await prisma.import_slips.findFirst({
      where: isId ? { id: BigInt(idOrCode) } : { slip_code: idOrCode },
      include: {
        suppliers: true,
        users: { select: { id: true, full_name: true, email: true, phone: true } },
        import_slip_items: {
          include: {
            products: { select: { id: true, name: true, slug: true } },
            product_variants: { select: { id: true, sku: true, price: true, cost_price: true, stock_quantity: true } },
          },
        },
      },
    });

    if (!slip) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy phiếu nhập hàng.' });
    }

    return res.json({
      success: true,
      data: {
        id: Number(slip.id),
        code: slip.slip_code,
        slipCode: slip.slip_code,
        supplier: slip.suppliers ? {
          id: Number(slip.suppliers.id),
          code: slip.suppliers.code,
          name: slip.suppliers.name,
          contactPerson: slip.suppliers.contact_person,
          phone: slip.suppliers.phone,
          email: slip.suppliers.email,
          address: slip.suppliers.address,
        } : null,
        creator: slip.users ? {
          id: Number(slip.users.id),
          name: slip.users.full_name,
          fullName: slip.users.full_name,
          email: slip.users.email,
        } : null,
        totalItems: slip.total_items,
        subtotalAmount: Number(slip.subtotal_amount),
        discountAmount: Number(slip.discount_amount),
        taxAmount: Number(slip.tax_amount),
        shippingFee: Number(slip.shipping_fee),
        totalAmount: Number(slip.total_amount),
        paidAmount: Number(slip.paid_amount),
        debtAmount: Number(slip.debt_amount),
        paymentMethod: slip.payment_method,
        paymentStatus: slip.payment_status,
        status: slip.status,
        importDate: slip.import_date,
        note: slip.note,
        items: slip.import_slip_items.map((it) => ({
          id: Number(it.id),
          productId: it.product_id ? Number(it.product_id) : null,
          variantId: it.variant_id ? Number(it.variant_id) : null,
          sku: it.sku,
          productName: it.product_name,
          variantName: it.variant_name,
          quantity: it.quantity,
          importPrice: Number(it.import_price),
          costPrice: Number(it.import_price),
          sellingPrice: Number(it.selling_price),
          totalPrice: Number(it.total_price),
          currentStock: it.product_variants?.stock_quantity ?? 0,
          note: it.note,
        })),
        createdAt: slip.created_at,
      },
    });
  } catch (error: any) {
    console.error('Lỗi khi lấy chi tiết phiếu nhập:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// ================================================================
// POST /api/import-slips - Tạo phiếu nhập kho mới
// ================================================================
importSlipsRouter.post('/', async (req: Request, res: Response) => {
  try {
    const supplier_id = req.body.supplier_id || req.body.supplierId;
    const payment_method = req.body.payment_method || req.body.paymentMethod || 'bank';
    const discount_amount = req.body.discount_amount || req.body.discountAmount || 0;
    const tax_amount = req.body.tax_amount || req.body.taxAmount || 0;
    const shipping_fee = req.body.shipping_fee || req.body.shippingFee || 0;
    const paid_amount = req.body.paid_amount || req.body.paidAmount || 0;
    const import_date = req.body.import_date || req.body.importDate;
    const note = req.body.note;
    const items = req.body.items;

    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ success: false, message: 'Vui lòng chọn ít nhất 1 sản phẩm để nhập kho.' });
    }

    if (!supplier_id) {
      return res.status(400).json({ success: false, message: 'Vui lòng chọn nhà cung cấp.' });
    }

    const supplier = await prisma.suppliers.findUnique({
      where: { id: parseInt(String(supplier_id), 10) },
    });

    if (!supplier) {
      return res.status(404).json({ success: false, message: 'Nhà cung cấp không tồn tại.' });
    }

    // Tự sinh mã phiếu nhập PN-YYYYMM-XXX
    const now = new Date();
    const ym = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}`;
    const todayCount = await prisma.import_slips.count();
    const slipCode = `PN-${ym}-${String(todayCount + 1).padStart(3, '0')}`;

    // Tính toán tiền hàng và chuẩn bị items
    let subtotal = 0;
    let totalQuantity = 0;
    const validatedItems: any[] = [];

    for (const item of items) {
      const qty = Math.max(1, parseInt(item.quantity, 10) || 1);
      const importPrice = Math.max(0, parseFloat(item.import_price ?? item.costPrice ?? item.cost_price) || 0);
      const sellingPrice = Math.max(0, parseFloat(item.selling_price ?? item.sellingPrice ?? item.price) || 0);
      const itemTotal = qty * importPrice;

      subtotal += itemTotal;
      totalQuantity += qty;

      let pId = item.product_id ?? item.productId ?? null;
      let vId = item.variant_id ?? item.variantId ?? null;
      let prodName = item.product_name ?? item.productName ?? null;
      let varName = item.variant_name ?? item.variantName ?? null;
      let sku = item.sku ?? null;

      // Nếu có productId nhưng chưa có variantId, tìm variant đầu tiên của sản phẩm
      if (pId && !vId) {
        const variant = await prisma.product_variants.findFirst({
          where: { product_id: BigInt(pId) },
          include: { products: true },
        });
        if (variant) {
          vId = variant.id;
          sku = sku || variant.sku;
          prodName = prodName || variant.products?.name;
          varName = varName || [variant.color, variant.material].filter(Boolean).join(' - ') || null;
        } else {
          // Tạo một variant mặc định nếu sản phẩm chưa có variant
          const prod = await prisma.products.findUnique({ where: { id: BigInt(pId) } });
          if (prod) {
            prodName = prodName || prod.name;
            const newVar = await prisma.product_variants.create({
              data: {
                product_id: BigInt(pId),
                sku: `SKU-${prod.slug || pId}-${Date.now().toString().slice(-4)}`,
                price: sellingPrice || 0,
                cost_price: importPrice,
                stock_quantity: 0,
              },
            });
            vId = newVar.id;
            sku = newVar.sku;
          }
        }
      } else if (vId && !pId) {
        const variant = await prisma.product_variants.findUnique({
          where: { id: BigInt(vId) },
          include: { products: true },
        });
        if (variant) {
          pId = variant.product_id;
          sku = sku || variant.sku;
          prodName = prodName || variant.products?.name;
          varName = varName || [variant.color, variant.material].filter(Boolean).join(' - ') || null;
        }
      }

      if (!prodName && pId) {
        const prod = await prisma.products.findUnique({ where: { id: BigInt(pId) } });
        if (prod) prodName = prod.name;
      }

      validatedItems.push({
        product_id: pId ? BigInt(pId) : null,
        variant_id: vId ? BigInt(vId) : null,
        sku: sku || `SKU-${Date.now()}-${Math.floor(Math.random() * 1000)}`,
        product_name: prodName || 'Sản phẩm nhập kho',
        variant_name: varName,
        quantity: qty,
        import_price: importPrice,
        selling_price: sellingPrice,
        total_price: itemTotal,
        note: item.note || null,
      });
    }

    const discount = Math.max(0, parseFloat(discount_amount) || 0);
    const tax = Math.max(0, parseFloat(tax_amount) || 0);
    const ship = Math.max(0, parseFloat(shipping_fee) || 0);
    const totalAmount = Math.max(0, subtotal - discount + tax + ship);
    const paid = Math.min(totalAmount, Math.max(0, parseFloat(paid_amount) || 0));
    const debt = Math.max(0, totalAmount - paid);

    let paymentStatus = 'unpaid';
    if (paid >= totalAmount && totalAmount > 0) {
      paymentStatus = 'paid';
    } else if (paid > 0) {
      paymentStatus = 'partial';
    }

    // Thực hiện transaction: Lưu phiếu nhập + cập nhật kho + cập nhật giá vốn + tạo phiếu chi sổ quỹ (nếu có trả tiền)
    const result = await prisma.$transaction(async (tx) => {
      // 1. Tạo phiếu nhập
      const newSlip = await tx.import_slips.create({
        data: {
          slip_code: slipCode,
          supplier_id: supplier.id,
          user_id: 1, // Mặc định admin
          total_items: totalQuantity,
          subtotal_amount: subtotal,
          discount_amount: discount,
          tax_amount: tax,
          shipping_fee: ship,
          total_amount: totalAmount,
          paid_amount: paid,
          debt_amount: debt,
          payment_method,
          payment_status: paymentStatus,
          status: 'completed',
          import_date: import_date ? new Date(import_date) : now,
          note: note?.trim() || null,
          import_slip_items: {
            create: validatedItems,
          },
        },
        include: {
          import_slip_items: true,
        },
      });

      // 2. Cập nhật tồn kho và giá vốn (cost_price) cho từng biến thể
      for (const item of validatedItems) {
        if (item.variant_id) {
          await tx.product_variants.update({
            where: { id: item.variant_id },
            data: {
              stock_quantity: { increment: item.quantity },
              cost_price: item.import_price,
              ...(item.selling_price > 0 ? { price: item.selling_price } : {}),
            },
          });
        }
      }

      // 3. Nếu có thanh toán tiền mặt hoặc chuyển khoản ngay, tự động lập Phiếu Chi trong Sổ Quỹ
      if (paid > 0) {
        const cashCode = `PC-${ym}-${String(Date.now()).slice(-4)}`;
        await tx.cash_transactions.create({
          data: {
            code: cashCode,
            type: 'expense',
            category: 'import_payment',
            amount: paid,
            payment_method: payment_method === 'cash' ? 'cash' : 'bank',
            reference_code: slipCode,
            performer_id: 1,
            recipient_name: supplier.name,
            note: `Chi thanh toán phiếu nhập kho ${slipCode} cho ${supplier.name}`,
            status: 'completed',
            created_at: now,
          },
        });
      }

      return newSlip;
    });

    return res.status(201).json({
      success: true,
      message: `Đã nhập kho thành công phiếu ${slipCode}. Tồn kho và giá vốn sản phẩm đã được cập nhật tự động!`,
      data: {
        id: Number(result.id),
        slipCode: result.slip_code,
        totalAmount: Number(result.total_amount),
        paidAmount: Number(result.paid_amount),
        debtAmount: Number(result.debt_amount),
        totalItems: result.total_items,
      },
    });
  } catch (error: any) {
    console.error('Lỗi khi tạo phiếu nhập hàng:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ khi tạo phiếu nhập.', error: error.message });
  }
});

// ================================================================
// PATCH /api/import-slips/:id/payment - Thu ngân thanh toán tiếp tiền hàng / xóa nợ
// ================================================================
importSlipsRouter.patch('/:id/payment', async (req: Request, res: Response) => {
  try {
    const id = BigInt(req.params.id);
    const { amount, payment_method = 'bank', note } = req.body;

    const payAmount = parseFloat(amount);
    if (isNaN(payAmount) || payAmount <= 0) {
      return res.status(400).json({ success: false, message: 'Số tiền thanh toán phải lớn hơn 0.' });
    }

    const slip = await prisma.import_slips.findUnique({
      where: { id },
      include: { suppliers: true },
    });

    if (!slip) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy phiếu nhập hàng.' });
    }

    const currentDebt = Number(slip.debt_amount);
    if (currentDebt <= 0) {
      return res.status(400).json({ success: false, message: 'Phiếu nhập này đã thanh toán đủ, không còn nợ.' });
    }

    const actualPay = Math.min(currentDebt, payAmount);
    const newPaid = Number(slip.paid_amount) + actualPay;
    const newDebt = Math.max(0, Number(slip.total_amount) - newPaid);
    const newPaymentStatus = newDebt === 0 ? 'paid' : 'partial';

    const now = new Date();
    const ym = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}`;
    const cashCode = `PC-${ym}-${String(Date.now()).slice(-4)}`;

    await prisma.$transaction(async (tx) => {
      // Cập nhật phiếu nhập
      await tx.import_slips.update({
        where: { id },
        data: {
          paid_amount: newPaid,
          debt_amount: newDebt,
          payment_status: newPaymentStatus,
          updated_at: now,
        },
      });

      // Tạo Phiếu Chi trong Sổ Quỹ
      await tx.cash_transactions.create({
        data: {
          code: cashCode,
          type: 'expense',
          category: 'supplier_debt',
          amount: actualPay,
          payment_method: payment_method === 'cash' ? 'cash' : 'bank',
          reference_code: slip.slip_code,
          performer_id: 1,
          recipient_name: slip.suppliers?.name || 'Nhà cung cấp',
          note: note?.trim() || `Thanh toán trả nợ đợt tiếp theo cho phiếu nhập ${slip.slip_code}`,
          status: 'completed',
          created_at: now,
        },
      });
    });

    return res.json({
      success: true,
      message: `Đã thanh toán thành công ${new Intl.NumberFormat('vi-VN').format(actualPay)} ₫ cho phiếu ${slip.slip_code}. Đã xuất phiếu chi sổ quỹ ${cashCode}!`,
      data: {
        paidAmount: newPaid,
        debtAmount: newDebt,
        paymentStatus: newPaymentStatus,
      },
    });
  } catch (error: any) {
    console.error('Lỗi thanh toán phiếu nhập:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});
