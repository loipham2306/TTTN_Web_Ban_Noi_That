import { app } from './app.js';
import { ENV } from './config/env.js';
import { prisma } from './config/prisma.js';
import { autoCancelExpiredOrders } from './routes/orders.route.js';

app.listen(ENV.PORT, () => {
  console.log(`Backend server running at http://localhost:${ENV.PORT}`);
  console.log(`Health check: http://localhost:${ENV.PORT}/api/health`);

  // Mở sẵn kết nối tới Supabase PostgreSQL để tránh cold-start TLS handshake ở request đầu tiên
  prisma.$connect().catch((err) => {
    console.warn('[Prisma] Không thể kết nối sẵn:', err.message);
  });

  // Tiến trình quét và tự động hủy đơn hàng chưa thanh toán quá 24h
  const SCAN_INTERVAL_MS = 30 * 60 * 1000; // Mỗi 30 phút quét 1 lần
  setTimeout(() => {
    autoCancelExpiredOrders(24).catch((err) => {
      console.warn('[AutoCancel] Lỗi quét lần đầu:', err.message);
    });
  }, 5000);

  setInterval(() => {
    autoCancelExpiredOrders(24).catch((err) => {
      console.warn('[AutoCancel] Lỗi quét định kỳ:', err.message);
    });
  }, SCAN_INTERVAL_MS);
});
