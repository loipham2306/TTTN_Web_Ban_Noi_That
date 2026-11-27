import { prisma } from '../config/prisma.js';

export const DEFAULT_POLICY_BANNERS = [
  {
    title: 'BẢO HÀNH 24 THÁNG | BẢO TRÌ TRỌN ĐỜI',
    subtitle: 'KTUFA Care & Warranty',
    description:
      'Mỗi tuyệt tác nội thất KTUFA đều được cam kết đồng hành dài lâu, giữ trọn vẻ đẹp nguyên bản và sự an tâm cho gia chủ.',
    image_url:
      'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1920&q=85',
    link_url: '/chinh-sach-bao-hanh#noi-dung',
    button_text: 'Xem điều khoản bảo hành',
    position: 'chinh-sach-bao-hanh',
    display_order: 1,
    is_active: true,
  },
  {
    title: 'VẬN CHUYỂN AN TOÀN | LẮP ĐẶT TẬN PHÒNG',
    subtitle: 'White-Glove Delivery',
    description:
      'Cước phí minh bạch theo 3 vùng giao nhận. Đội ngũ KTUFA bọc lót 3 lớp chuyên nghiệp và lắp đặt hoàn thiện ngay tại nhà.',
    image_url:
      'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1920&q=85',
    link_url: '/chinh-sach-van-chuyen#noi-dung',
    button_text: 'Xem biểu phí & quy trình',
    position: 'chinh-sach-van-chuyen',
    display_order: 1,
    is_active: true,
  },
  {
    title: 'THANH TOÁN LINH HOẠT | TRẢ GÓP 0% LÃI SUẤT',
    subtitle: 'Flexible & Secure Payment',
    description:
      'Đa dạng lựa chọn từ chuyển khoản VietQR tự động, thanh toán khi nhận hàng đến trả góp 0% giúp bạn dễ dàng sở hữu không gian mơ ước.',
    image_url:
      'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1920&q=85',
    link_url: '/huong-dan-thanh-toan#noi-dung',
    button_text: 'Xem hình thức thanh toán',
    position: 'huong-dan-thanh-toan',
    display_order: 1,
    is_active: true,
  },
];

let policySeedPromise: Promise<void> | null = null;

/**
 * Đảm bảo 3 banner cho các trang chính sách luôn tồn tại trong DB nếu chưa được tạo.
 * Chỉ chạy kiểm tra 1 lần mỗi vòng đời tiến trình server để không tạo thêm tải truy vấn.
 */
export function ensurePolicyBannersSeeded(): Promise<void> {
  if (!policySeedPromise) {
    policySeedPromise = (async () => {
      try {
        for (const item of DEFAULT_POLICY_BANNERS) {
          const existing = await prisma.banners.findFirst({
            where: { position: item.position },
            select: { id: true },
          });
          if (!existing) {
            await prisma.banners.create({ data: item });
          }
        }
      } catch (err) {
        policySeedPromise = null;
        console.warn(
          '[PolicyBanners] Không thể đồng bộ banner mặc định:',
          (err as any)?.message || err
        );
      }
    })();
  }
  return policySeedPromise;
}

