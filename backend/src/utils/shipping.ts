/**
 * Tiện ích tính toán phí vận chuyển (tiền ship) thông minh cho ngành Nội Thất
 * Dựa trên: Tỉnh/Thành phố (4 phân vùng), Giá trị đơn hàng (5 phân khúc) và Phụ phí hàng cồng kềnh/đi theo bộ
 */

export function calculateShippingFee(subtotal: number, province: string = '', totalQty: number = 1): number {
  if (subtotal <= 0 || totalQty <= 0) return 0;

  // 1. Đơn hàng từ 10.000.000 ₫ trở lên -> FREESHIP 100% TOÀN QUỐC
  if (subtotal >= 10000000) return 0;

  const p = (province || '').toLowerCase().trim();

  // 2. Xác định 4 phân vùng địa lý (Kho hàng đặt duy nhất tại TP. Hồ Chí Minh)
  // KV1: Nội thành TP.HCM (Kho chính - giao nhanh)
  const isKV1 = !p || p.includes('hồ chí minh') || p.includes('hcm') || p.includes('sài gòn');

  // KV2: Ngoại thành & Tỉnh giáp ranh / vệ tinh TP.HCM (Bán kính 20km - 60km)
  const isKV2 = p.includes('bình dương') || p.includes('đồng nai') || p.includes('long an') || 
                p.includes('bà rịa') || p.includes('vũng tàu') || p.includes('tây ninh') || p.includes('bình phước');

  // KV3: Các tỉnh Miền Tây & Miền Nam lân cận (Khoảng cách 70km - 300km)
  const isKV3 = p.includes('cần thơ') || p.includes('tiền giang') || p.includes('bến tre') || 
                p.includes('vĩnh long') || p.includes('trà vinh') || p.includes('đồng tháp') || 
                p.includes('an giang') || p.includes('kiên giang') || p.includes('hậu giang') || 
                p.includes('sóc trăng') || p.includes('bạc liêu') || p.includes('cà mau');

  // KV4 (Mặc định còn lại): Liên miền Bắc - Nam & Miền Trung (Hà Nội, Hải Phòng, Đà Nẵng, Bắc Ninh, Quảng Ninh...)
  // Khoảng cách hơn 800km - 1.700km từ kho TP.HCM, vận chuyển xe tải đường dài / tàu hỏa

  let baseShip = 0;

  if (subtotal >= 5000000) {
    // Đơn 5tr - dưới 10tr: Hỗ trợ cước phí xe tải
    baseShip = isKV1 ? 50000 : (isKV2 ? 90000 : (isKV3 ? 160000 : 220000));
  } else if (subtotal >= 3000000) {
    // Đơn 3tr - dưới 5tr: Hàng nội thất cồng kềnh
    baseShip = isKV1 ? 140000 : (isKV2 ? 190000 : (isKV3 ? 250000 : 350000));
  } else if (subtotal >= 1000000) {
    // Đơn 1tr - dưới 3tr: Hàng vừa
    baseShip = isKV1 ? 80000 : (isKV2 ? 120000 : (isKV3 ? 160000 : 230000));
  } else {
    // Đơn dưới 1tr: Đồ decor, phụ kiện nhỏ gọn
    baseShip = isKV1 ? 45000 : (isKV2 ? 70000 : (isKV3 ? 95000 : 120000));
  }

  // 3. Phụ phí kiện hàng cồng kềnh / theo bộ: Từ món thứ 3 trở lên phụ thu 20.000 ₫/món đóng gói bốc xếp
  const bulkyFee = totalQty > 2 ? (totalQty - 2) * 20000 : 0;

  return baseShip + bulkyFee;
}
