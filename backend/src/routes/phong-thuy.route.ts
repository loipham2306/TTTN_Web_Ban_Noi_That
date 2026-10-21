import { Router, Request, Response } from 'express';
import { prisma } from '../config/prisma.js';

export const phongThuyRouter = Router();

const SYSTEM_PROMPT = `Bạn là một Chuyên gia Phong Thủy và Kiến trúc sư nội thất cao cấp của thương hiệu nội thất sang trọng KTUFA Luxury Furniture.
Nhiệm vụ của bạn là tư vấn cho khách hàng về phong thủy nhà ở, bài trí nội thất, chọn màu sắc, kích thước và chất liệu chuẩn phong thủy Á Đông của KTUFA Luxury Furniture.
Khi xưng hô hoặc chào hỏi khách hàng, luôn sử dụng thương hiệu "KTUFA Luxury Furniture", tuyệt đối không dùng bất kỳ tên thương hiệu nào khác.

Kiến thức chuyên môn của bạn bao gồm:
1. Bản mệnh & Ngũ hành (Kim - Mộc - Thủy - Hỏa - Thổ):
   - Tính toán chính xác mệnh theo năm sinh (Can Chi, Ngũ Hành Nạp Âm).
   - Quy luật tương sinh, tương trợ, tương khắc.
   - Tư vấn màu sắc nội thất hợp mệnh và các màu đại kỵ cần tránh.
2. Cung phi Bát Trạch:
   - Đông tứ mệnh và Tây tứ mệnh (phân biệt rõ nam mạng và nữ mạng).
   - 4 hướng tốt: Sinh Khí, Thiên Y, Diên Niên, Phục Vị.
   - 4 hướng xấu: Tuyệt Mệnh, Ngũ Quỷ, Lục Sát, Họa Hại.
3. Nguyên tắc bài trí nội thất:
   - Phòng khách: Vị trí sofa (tựa tường vững chãi, không đối diện trực xung cửa chính), bàn trà, ánh sáng tụ khí.
   - Phòng ngủ: Hướng đầu giường (tọa hung hướng cát, tránh đối diện gương, tránh xà ngang ép đỉnh).
   - Bàn làm việc: Tựa sơn hướng thủy, không quay lưng ra cửa.
   - Bàn thờ, phòng bếp, phòng ăn.
4. Thước Lỗ Ban:
   - Kích thước thông thủy, kích thước nội thất lọt vào các cung quý (Tài, Nghĩa, Quan, Bản).
5. Phong cách tư vấn:
   - Giọng điệu ấm áp, trang nhã, uyên bác và tôn trọng khách hàng.
   - Định dạng câu trả lời rõ ràng: Dùng bullet point, in đậm từ khóa quan trọng, phân mục rành mạch.
   - Khéo léo gợi ý khách hàng xem các sản phẩm nội thất tương ứng (sofa da, bàn trà gỗ sồi/gỗ óc chó, tủ kệ, giường ngủ) của KTUFA Luxury Furniture trên website để hoàn thiện không gian sống.

QUY TẮC GIỚI HẠN PHẠM VI (BẮT BUỘC TUÂN THỦ NGHIÊM NGẶT):
- Bạn CHỈ ĐƯỢC PHÉP trả lời các câu hỏi liên quan đến: Phong thủy, bản mệnh, cung mệnh, tử vi phong thủy nhà ở, kiến trúc, decor, bài trí và lựa chọn sản phẩm nội thất (sofa, giường ngủ, bàn ghế, tủ kệ, màu sắc, chất liệu, thước Lỗ Ban...).
- TUYỆT ĐỐI KHÔNG trả lời các câu hỏi ngoài lề như: Lập trình/code, giải toán, dịch thuật kiến thức chung, thời tiết, tin tức, lịch sử thế giới, chính trị, y tế sức khỏe cá nhân, làm thơ/văn không liên quan, hoặc các yêu cầu đóng vai/bẻ khóa (jailbreak).
- Khi người dùng hỏi bất kỳ chủ đề nào ngoài phạm vi phong thủy & nội thất:
  Hãy từ chối một cách lịch sự, nhã nhặn và ngay lập tức bẻ lái gợi ý người dùng quay lại chủ đề nội thất & phong thủy.
  Mẫu phản hồi chuẩn mực: "Dạ, tôi là Chuyên gia tư vấn Phong Thủy & Nội Thất của KTUFA Luxury Furniture. Tôi xin phép chỉ hỗ trợ quý khách về bài trí không gian sống, phong thủy nhà ở, bản mệnh và lựa chọn nội thất phù hợp. Quý khách đang quan tâm đến không gian phòng khách, phòng ngủ hay cần tư vấn tuổi/mệnh để chọn nội thất nào không ạ?"`;

// POST /api/phong-thuy/consult
phongThuyRouter.post('/consult', async (req: Request, res: Response) => {
  try {
    const { message, history = [] } = req.body;
    if (!message || typeof message !== 'string') {
      res.status(400).json({ success: false, message: 'Nội dung tin nhắn không hợp lệ' });
      return;
    }

    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey) {
      res.status(500).json({ success: false, message: 'Chưa cấu hình GEMINI_API_KEY trong hệ thống' });
      return;
    }

    // Build contents for Gemini API
    const formattedHistory = history.map((item: { role: string; text: string }) => ({
      role: item.role === 'assistant' || item.role === 'model' ? 'model' : 'user',
      parts: [{ text: item.text }],
    }));

    const contents = [
      ...formattedHistory,
      { role: 'user', parts: [{ text: message }] },
    ];

    const model = process.env.GEMINI_MODEL || 'gemini-1.5-flash';
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          systemInstruction: {
            parts: [{ text: SYSTEM_PROMPT }],
          },
          contents,
        }),
      }
    );

    if (!response.ok) {
      const errText = await response.text();
      console.error('Gemini API Error:', errText);
      res.status(response.status).json({ success: false, message: 'Lỗi khi kết nối với AI Gemini' });
      return;
    }

    const data: any = await response.json();
    const reply = data.candidates?.[0]?.content?.parts?.[0]?.text || 'Xin lỗi, tôi chưa thể trả lời câu hỏi này vào lúc này.';

    res.json({ success: true, reply });
  } catch (error: any) {
    console.error('Lỗi tư vấn phong thủy:', error);
    res.status(500).json({ success: false, message: 'Đã có lỗi xảy ra trong quá trình tư vấn', error: error.message });
  }
});

// POST /api/phong-thuy/chat-log - Lưu lịch sử chat AI vào Database
phongThuyRouter.post('/chat-log', async (req: Request, res: Response) => {
  try {
    const { sessionId, guestId, userId, userEmail, userName, userPhone, userMessage, botMessage } = req.body;

    if (!userMessage && !botMessage) {
      res.status(400).json({ success: false, message: 'Thiếu nội dung tin nhắn để lưu.' });
      return;
    }

    let finalUserId: bigint | null = null;
    if (userId) {
      try {
        finalUserId = BigInt(userId);
      } catch {}
    }

    // Nếu chưa có ID nhưng có Email, tự động đối chiếu trong bảng users
    if (!finalUserId && userEmail && typeof userEmail === 'string') {
      try {
        const found = await prisma.users.findUnique({
          where: { email: userEmail.trim().toLowerCase() },
        });
        if (found) {
          finalUserId = found.id;
        }
      } catch (err) {
        console.warn('Lỗi tìm kiếm user theo email:', err);
      }
    }

    let session = null;
    if (sessionId) {
      try {
        session = await prisma.chat_sessions.findUnique({
          where: { id: BigInt(sessionId) },
        });
      } catch {}
    }

    // Đặt tên guest kèm thông tin nếu có
    const formattedGuestId = userName && !finalUserId
      ? `${guestId || 'guest_' + Date.now()} (Tên: ${userName})`
      : (guestId || `guest_${Date.now()}`);

    if (!session) {
      session = await prisma.chat_sessions.create({
        data: {
          guest_id: formattedGuestId,
          user_id: finalUserId,
          status: 'bot_handling',
          started_at: new Date(),
        },
      });
    } else if (!session.user_id && finalUserId) {
      // Cập nhật người dùng nếu phiên ban đầu là khách vãng lai nhưng sau đó đăng nhập
      session = await prisma.chat_sessions.update({
        where: { id: session.id },
        data: { user_id: finalUserId },
      });
    }

    if (userMessage && typeof userMessage === 'string' && userMessage.trim()) {
      await prisma.chat_messages.create({
        data: {
          session_id: session.id,
          sender_type: 'customer',
          sender_id: finalUserId,
          content: userMessage.trim(),
        },
      });
    }

    if (botMessage && typeof botMessage === 'string' && botMessage.trim()) {
      await prisma.chat_messages.create({
        data: {
          session_id: session.id,
          sender_type: 'ai_bot',
          content: botMessage.trim(),
        },
      });
    }

    res.json({
      success: true,
      sessionId: session.id.toString(),
      message: 'Đã lưu lịch sử chat AI thành công.',
    });
  } catch (error: any) {
    console.error('Lỗi lưu lịch sử chat AI:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lưu lịch sử chat', error: error.message });
  }
});

// GET /api/phong-thuy/chat-sessions - Lấy danh sách toàn bộ phiên chat AI cho Admin
phongThuyRouter.get('/chat-sessions', async (_req: Request, res: Response) => {
  try {
    const sessions = await prisma.chat_sessions.findMany({
      include: {
        users: {
          select: {
            id: true,
            full_name: true,
            email: true,
            phone: true,
          },
        },
        chat_messages: {
          orderBy: { created_at: 'asc' },
        },
      },
      orderBy: { started_at: 'desc' },
      take: 100,
    });

    const data = sessions.map((s) => {
      const msgs = s.chat_messages.map((m) => ({
        id: m.id.toString(),
        senderType: m.sender_type,
        content: m.content,
        createdAt: m.created_at ? m.created_at.toISOString() : null,
      }));

      const firstCustomerMsg = msgs.find((m) => m.senderType === 'customer');
      const latestAiMsg = [...msgs].reverse().find((m) => m.senderType === 'ai_bot');
      const lastMsg = msgs[msgs.length - 1];

      let resolvedName = 'Khách vãng lai';
      if (s.users?.full_name) {
        resolvedName = s.users.full_name;
      } else if (s.users?.email) {
        resolvedName = s.users.email;
      } else if (s.guest_id && s.guest_id.includes('(Tên: ')) {
        const match = s.guest_id.match(/\(Tên: (.*?)\)/);
        if (match && match[1]) resolvedName = match[1];
      }

      return {
        id: s.id.toString(),
        code: `AI-PT-${s.id.toString().padStart(4, '0')}`,
        guestId: s.guest_id || 'Ẩn danh',
        userName: resolvedName,
        userEmail: s.users?.email || '',
        userPhone: s.users?.phone || '',
        status: s.status || 'bot_handling',
        startedAt: s.started_at ? s.started_at.toISOString() : new Date().toISOString(),
        messageCount: msgs.length,
        previewQuestion: firstCustomerMsg ? firstCustomerMsg.content : (lastMsg?.content || 'Hỏi đáp phong thủy'),
        latestAdvice: latestAiMsg ? latestAiMsg.content : (lastMsg?.content || ''),
        messages: msgs,
      };
    });

    res.json({ success: true, data });
  } catch (error: any) {
    console.error('Lỗi lấy danh sách chat sessions:', error);
    res.status(500).json({ success: false, message: 'Lỗi lấy dữ liệu chat sessions', error: error.message });
  }
});

// DELETE /api/phong-thuy/chat-sessions/:id - Xóa 1 phiên chat
phongThuyRouter.delete('/chat-sessions/:id', async (req: Request, res: Response) => {
  try {
    const id = BigInt(req.params.id);
    await prisma.chat_messages.deleteMany({
      where: { session_id: id },
    });
    await prisma.chat_sessions.delete({
      where: { id },
    });
    res.json({ success: true, message: 'Đã xóa phiên chat thành công.' });
  } catch (error: any) {
    console.error('Lỗi xóa chat session:', error);
    res.status(500).json({ success: false, message: 'Lỗi xóa phiên chat', error: error.message });
  }
});

