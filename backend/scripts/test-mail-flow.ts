import { MailerService } from '../src/services/mailer.service.js';

async function runTest() {
  console.log('--- BẮT ĐẦU KIỂM THỬ HỆ THỐNG EMAIL NỘI THẤT KTUFA ---');

  // 1. Kiểm thử Email Xác nhận Đặt hàng
  console.log('\n[TEST 1] Thử nghiệm gửi Email Xác nhận Đặt hàng:');
  const orderResult = await MailerService.sendOrderConfirmationMail({
    orderCode: 'NT-2611-9988',
    customerName: 'Nguyễn Văn Test VIP',
    customerEmail: 'test.customer@gmail.com',
    customerPhone: '0912345678',
    shippingAddress: 'Tòa nhà Landmark 81, 720A Điện Biên Phủ, Phường 22, Bình Thạnh, TP. Hồ Chí Minh',
    customerNote: 'Giao hàng giờ hành chính, gọi trước 30 phút.',
    paymentMethod: 'sepay',
    paymentStatus: 'pending',
    createdAt: new Date(),
    items: [
      {
        name: 'Sofa da Ý Milano',
        qty: 1,
        price: 58900000,
        total: 58900000,
        sku: 'SOFA-MILANO-01',
        image: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80',
      },
      {
        name: 'Bàn ăn đá marble Carrara',
        qty: 1,
        price: 32500000,
        total: 32500000,
        sku: 'BAN-MARBLE-02',
        image: 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=600&q=80',
      },
    ],
    subtotalAmount: 91400000,
    shippingFee: 0,
    discountAmount: 1000000,
    couponCode: 'VIPKTUFA',
    totalAmount: 90400000,
  });

  console.log('Kết quả Test 1:', orderResult);

  // 2. Kiểm thử Email Xác nhận Đã thanh toán thành công
  console.log('\n[TEST 2] Thử nghiệm gửi Email Xác nhận Thanh toán Thành công:');
  const paymentResult = await MailerService.sendPaymentSuccessMail({
    orderCode: 'NT-2611-9988',
    customerName: 'Nguyễn Văn Test VIP',
    customerEmail: 'test.customer@gmail.com',
    customerPhone: '0912345678',
    shippingAddress: 'Tòa nhà Landmark 81, 720A Điện Biên Phủ, Phường 22, Bình Thạnh, TP. Hồ Chí Minh',
    paidAmount: 90400000,
    paymentMethod: 'sepay',
    paymentGateway: 'Chuyển khoản VietQR tự động (SePay / MBBank)',
    referenceCode: 'MB9876543210',
    paidAt: new Date(),
    items: [
      {
        name: 'Sofa da Ý Milano',
        qty: 1,
        price: 58900000,
        total: 58900000,
        image: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80',
      },
      {
        name: 'Bàn ăn đá marble Carrara',
        qty: 1,
        price: 32500000,
        total: 32500000,
        image: 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=600&q=80',
      },
    ],
    totalAmount: 90400000,
  });

  console.log('Kết quả Test 2:', paymentResult);
  console.log('\n--- HOÀN TẤT KIỂM THỬ TOÀN BỘ HỆ THỐNG EMAIL KTUFA ---');
}

runTest().catch(console.error);

