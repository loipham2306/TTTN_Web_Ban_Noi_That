export interface PhongThuyInput {
  namSinh: number;
  gioiTinh: 'nam' | 'nu';
  loaiPhong: string;
}

export interface HuongTot {
  vaiTro: string;
  huong: string;
}

export interface PhongThuyResult {
  quaiSo: number;
  cung: string;
  nhomMenh: string;
  nguHanh: string;
  huongTot: HuongTot[];
  mauSac: string[];
  goiY: string[];
}

interface CungInfo {
  ten: string;
  nguHanh: string;
  nhomMenh: string;
  huong: [string, string, string, string];
}

export const LOAI_PHONG: { key: string; label: string }[] = [
  { key: 'phong-khach', label: 'Phòng khách' },
  { key: 'phong-ngu', label: 'Phòng ngủ' },
  { key: 'phong-an', label: 'Phòng ăn' },
  { key: 'lam-viec', label: 'Phòng làm việc' },
  { key: 'khac', label: 'Không gian khác' },
];

const CUNG: Record<number, CungInfo> = {
  1: { ten: 'Khảm', nguHanh: 'Thuỷ', nhomMenh: 'Đông tứ mệnh', huong: ['Đông Nam', 'Đông', 'Nam', 'Bắc'] },
  2: { ten: 'Khôn', nguHanh: 'Thổ', nhomMenh: 'Tây tứ mệnh', huong: ['Đông Bắc', 'Tây', 'Tây Bắc', 'Tây Nam'] },
  3: { ten: 'Chấn', nguHanh: 'Mộc', nhomMenh: 'Đông tứ mệnh', huong: ['Nam', 'Bắc', 'Đông Nam', 'Đông'] },
  4: { ten: 'Tốn', nguHanh: 'Mộc', nhomMenh: 'Đông tứ mệnh', huong: ['Bắc', 'Nam', 'Đông', 'Đông Nam'] },
  6: { ten: 'Càn', nguHanh: 'Kim', nhomMenh: 'Tây tứ mệnh', huong: ['Tây', 'Đông Bắc', 'Tây Nam', 'Tây Bắc'] },
  7: { ten: 'Đoài', nguHanh: 'Kim', nhomMenh: 'Tây tứ mệnh', huong: ['Tây Bắc', 'Tây Nam', 'Đông Bắc', 'Tây'] },
  8: { ten: 'Cấn', nguHanh: 'Thổ', nhomMenh: 'Tây tứ mệnh', huong: ['Tây Nam', 'Tây Bắc', 'Tây', 'Đông Bắc'] },
  9: { ten: 'Ly', nguHanh: 'Hoả', nhomMenh: 'Đông tứ mệnh', huong: ['Đông', 'Đông Nam', 'Bắc', 'Nam'] },
};

const FALLBACK: CungInfo = CUNG[1];

const MAU_SAC: Record<string, string[]> = {
  'Thuỷ': ['Đen', 'Xanh dương', 'Xám bạc'],
  'Thổ': ['Vàng đất', 'Nâu', 'Be'],
  'Mộc': ['Xanh lá', 'Xanh ngọc'],
  'Kim': ['Trắng', 'Xám', 'Ánh kim'],
  'Hoả': ['Đỏ', 'Hồng', 'Tím'],
};

export const tinhQuaiSo = (namSinh: number, gioiTinh: 'nam' | 'nu'): number => {
  let sum = String(namSinh)
    .split('')
    .reduce((total, char) => total + Number(char), 0);

  while (sum > 9) {
    sum = String(sum)
      .split('')
      .reduce((total, char) => total + Number(char), 0);
  }

  const sauNam2000 = namSinh >= 2000;
  let quaiSo: number;

  if (gioiTinh === 'nam') {
    quaiSo = (sauNam2000 ? 9 : 10) - sum;
    if (quaiSo <= 0) quaiSo += 9;
  } else {
    quaiSo = (sauNam2000 ? 6 : 5) + sum;
    if (quaiSo > 9) quaiSo -= 9;
  }

  if (quaiSo === 5) quaiSo = gioiTinh === 'nam' ? 2 : 8;
  return quaiSo;
};

const goiYTheoPhong = (
  loaiPhong: string,
  huongTot: HuongTot[],
  nguHanh: string,
  mauSac: string[]
): string[] => {
  const sinhKhi = huongTot[0]?.huong ?? '';
  const thienY = huongTot[1]?.huong ?? '';
  const mau = mauSac[0] ?? '';
  const dungChung = [
    'Dùng tông ' + mau + ' cho đồ nội thất chính để hợp ngũ hành ' + nguHanh + '.',
    'Hạn chế gương lớn và vật nhọn chiếu thẳng vào khu vực sinh hoạt chính.',
  ];

  if (loaiPhong === 'phong-khach') {
    return [
      'Đặt sofa quay về hướng ' + sinhKhi + ', ghế chủ tựa vào tường vững.',
      'Giữ lối vào thông thoáng, tránh kê tủ cao chắn ngay cửa chính.',
      ...dungChung,
    ];
  }

  if (loaiPhong === 'phong-ngu') {
    return [
      'Đầu giường tựa vào tường đặc, nếu được thì quay về hướng ' + thienY + '.',
      'Không kê đầu giường sát cửa sổ và tránh xà ngang đè phía trên.',
      ...dungChung,
    ];
  }

  if (loaiPhong === 'phong-an') {
    return [
      'Chọn bàn ăn hình tròn hoặc bầu dục để khí lưu thông tốt hơn.',
      'Treo đèn thấp ngay trên mặt bàn, tránh xà ngang chạy ngang bàn ăn.',
      ...dungChung,
    ];
  }

  if (loaiPhong === 'lam-viec') {
    return [
      'Kê bàn làm việc quay về hướng ' + sinhKhi + ' và tựa lưng vào tường.',
      'Tránh ngồi quay lưng ra cửa hoặc cửa sổ lớn.',
      ...dungChung,
    ];
  }

  return [
    'Bố trí theo hướng ' + sinhKhi + ' cho vị trí ngồi hoặc điểm nhìn chính.',
    'Sắp xếp gọn gàng, giữ lối đi thông thoáng để khí lưu chuyển đều.',
    ...dungChung,
  ];
};

export const tuVanPhongThuy = (input: PhongThuyInput): PhongThuyResult => {
  const quaiSo = tinhQuaiSo(input.namSinh, input.gioiTinh);
  const info = CUNG[quaiSo] ?? FALLBACK;

  const huongTot: HuongTot[] = [
    { vaiTro: 'Sinh khí', huong: info.huong[0] },
    { vaiTro: 'Thiên y', huong: info.huong[1] },
    { vaiTro: 'Diên niên', huong: info.huong[2] },
    { vaiTro: 'Phục vị', huong: info.huong[3] },
  ];

  const mauSac = MAU_SAC[info.nguHanh] ?? [];

  return {
    quaiSo,
    cung: info.ten,
    nhomMenh: info.nhomMenh,
    nguHanh: info.nguHanh,
    huongTot,
    mauSac,
    goiY: goiYTheoPhong(input.loaiPhong, huongTot, info.nguHanh, mauSac),
  };
};

export const NHAN_XET: string =
  'Kết quả dựa trên bảng tra cung mệnh (Bát trạch) và chỉ mang tính tham khảo.';

export const AI_HOOK: string =
  'Phần tư vấn diễn giải chi tiết bằng AI sẽ được nối vào sau, khi API máy chủ sẵn sàng.';
