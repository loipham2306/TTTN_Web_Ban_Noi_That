export type ShippingZone = 'hcm' | 'nearby' | 'other';

export interface ShippingRule {
  zone: ShippingZone;
  label: string;
  freeThreshold: number;
  baseFee: number;
}

const NEARBY_PROVINCES = [
  'bình dương',
  'binh duong',
  'đồng nai',
  'dong nai',
  'long an',
  'tây ninh',
  'tay ninh',
  'bà rịa',
  'vũng tàu',
  'vung tau',
];

/**
 * Xác định quy tắc phí vận chuyển dựa trên Tỉnh/Thành phố nhận hàng:
 * - TP. Hồ Chí Minh: Miễn phí từ 2.000.000 ₫ (Dưới ngưỡng: 50.000 ₫)
 * - Tỉnh lân cận (Bình Dương, Đồng Nai, Long An, Tây Ninh, BR-VT): Miễn phí từ 10.000.000 ₫ (Dưới ngưỡng: 150.000 ₫)
 * - Tỉnh/thành khác: Miễn phí từ 20.000.000 ₫ (Hỗ trợ phí ship mặc định: 300.000 ₫)
 */
export function getShippingRuleByProvince(province?: string | null): ShippingRule {
  const normalized = (province || '').trim().toLowerCase();

  if (
    !normalized ||
    normalized.includes('hồ chí minh') ||
    normalized.includes('ho chi minh') ||
    normalized === 'tphcm' ||
    normalized === 'tp.hcm' ||
    normalized === 'hcm'
  ) {
    return {
      zone: 'hcm',
      label: 'Nội thành TP. Hồ Chí Minh',
      freeThreshold: 2_000_000,
      baseFee: 50_000,
    };
  }

  if (NEARBY_PROVINCES.some((kw) => normalized.includes(kw))) {
    return {
      zone: 'nearby',
      label: 'Tỉnh lân cận TP. HCM',
      freeThreshold: 10_000_000,
      baseFee: 150_000,
    };
  }

  return {
    zone: 'other',
    label: 'Tỉnh / thành khác toàn quốc',
    freeThreshold: 20_000_000,
    baseFee: 300_000,
  };
}

/**
 * Tính phí vận chuyển tiêu chuẩn theo tổng tiền hàng và tỉnh/thành phố.
 */
export function calculateShippingFee(subtotal: number, province?: string | null): number {
  if (subtotal <= 0) return 0;
  const rule = getShippingRuleByProvince(province);
  return subtotal >= rule.freeThreshold ? 0 : rule.baseFee;
}

