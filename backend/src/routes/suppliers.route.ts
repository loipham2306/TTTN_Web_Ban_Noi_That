import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';

export const suppliersRouter = Router();

// ================================================================
// GET /api/suppliers - Lấy danh sách nhà cung cấp kèm thống kê công nợ
// ================================================================
suppliersRouter.get('/', async (_req: Request, res: Response) => {
  try {
    const suppliers = await prisma.suppliers.findMany({
      orderBy: { created_at: 'desc' },
      include: {
        import_slips: {
          select: {
            id: true,
            total_amount: true,
            paid_amount: true,
            debt_amount: true,
            status: true,
          },
        },
      },
    });

    const data = suppliers.map((s) => {
      const activeSlips = s.import_slips.filter((slip) => slip.status !== 'cancelled');
      const totalOrders = activeSlips.length;
      const totalPurchased = activeSlips.reduce((sum, slip) => sum + Number(slip.total_amount || 0), 0);
      const totalPaid = activeSlips.reduce((sum, slip) => sum + Number(slip.paid_amount || 0), 0);
      const totalDebt = activeSlips.reduce((sum, slip) => sum + Number(slip.debt_amount || 0), 0);

      return {
        id: s.id,
        code: s.code,
        name: s.name,
        contactPerson: s.contact_person,
        phone: s.phone,
        email: s.email,
        address: s.address,
        status: s.status,
        stats: {
          totalOrders,
          totalPurchased,
          totalPaid,
          totalDebt,
        },
        createdAt: s.created_at,
        updatedAt: s.updated_at,
      };
    });

    return res.json({ success: true, data });
  } catch (error: any) {
    console.error('Lỗi khi lấy danh sách nhà cung cấp:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// ================================================================
// POST /api/suppliers - Thêm nhà cung cấp mới
// ================================================================
suppliersRouter.post('/', async (req: Request, res: Response) => {
  try {
    const { name, contact_person, contactPerson, phone, email, address } = req.body;
    const finalContact = (contactPerson ?? contact_person)?.trim() || null;

    if (!name || !name.trim()) {
      return res.status(400).json({ success: false, message: 'Tên nhà cung cấp không được để trống.' });
    }

    // Tự sinh mã NCC nếu không truyền vào
    const count = await prisma.suppliers.count();
    const code = req.body.code?.trim() || `NCC-${String(count + 1).padStart(3, '0')}`;

    const existing = await prisma.suppliers.findFirst({
      where: {
        OR: [
          { code },
          { name: name.trim() },
        ],
      },
    });

    if (existing) {
      return res.status(400).json({ success: false, message: 'Mã hoặc tên nhà cung cấp đã tồn tại.' });
    }

    const created = await prisma.suppliers.create({
      data: {
        code,
        name: name.trim(),
        contact_person: finalContact,
        phone: phone?.trim() || null,
        email: email?.trim() || null,
        address: address?.trim() || null,
        status: true,
      },
    });

    return res.status(201).json({
      success: true,
      message: 'Đã tạo nhà cung cấp thành công.',
      data: created,
    });
  } catch (error: any) {
    console.error('Lỗi khi thêm nhà cung cấp:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// ================================================================
// PUT /api/suppliers/:id - Cập nhật thông tin nhà cung cấp
// ================================================================
suppliersRouter.put('/:id', async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id, 10);
    const { name, contact_person, contactPerson, phone, email, address, status } = req.body;
    const finalContact = contactPerson !== undefined ? contactPerson?.trim() || null : (contact_person !== undefined ? contact_person?.trim() || null : undefined);

    if (isNaN(id)) {
      return res.status(400).json({ success: false, message: 'ID không hợp lệ.' });
    }

    const supplier = await prisma.suppliers.findUnique({ where: { id } });
    if (!supplier) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy nhà cung cấp.' });
    }

    const updated = await prisma.suppliers.update({
      where: { id },
      data: {
        ...(name ? { name: name.trim() } : {}),
        contact_person: finalContact !== undefined ? finalContact : supplier.contact_person,
        phone: phone !== undefined ? phone?.trim() || null : supplier.phone,
        email: email !== undefined ? email?.trim() || null : supplier.email,
        address: address !== undefined ? address?.trim() || null : supplier.address,
        ...(status !== undefined ? { status: Boolean(status) } : {}),
      },
    });

    return res.json({
      success: true,
      message: 'Cập nhật nhà cung cấp thành công.',
      data: updated,
    });
  } catch (error: any) {
    console.error('Lỗi khi cập nhật nhà cung cấp:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});

// ================================================================
// DELETE /api/suppliers/:id - Xóa hoặc ngừng hợp tác
// ================================================================
suppliersRouter.delete('/:id', async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id, 10);
    if (isNaN(id)) {
      return res.status(400).json({ success: false, message: 'ID không hợp lệ.' });
    }

    // Kiểm tra có phiếu nhập không
    const slipCount = await prisma.import_slips.count({ where: { supplier_id: id } });
    if (slipCount > 0) {
      // Nếu có phiếu nhập thì chuyển trạng thái ngừng hợp tác thay vì xóa cứng
      await prisma.suppliers.update({
        where: { id },
        data: { status: false },
      });
      return res.json({
        success: true,
        message: 'Nhà cung cấp đã có phiếu nhập liên kết nên được chuyển sang trạng thái "Ngừng hợp tác".',
      });
    }

    await prisma.suppliers.delete({ where: { id } });
    return res.json({ success: true, message: 'Đã xóa nhà cung cấp thành công.' });
  } catch (error: any) {
    console.error('Lỗi xóa nhà cung cấp:', error);
    return res.status(500).json({ success: false, message: 'Lỗi máy chủ.', error: error.message });
  }
});
