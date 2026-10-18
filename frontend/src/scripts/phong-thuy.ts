import { products, type Product } from '../data/products';

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
  sanPhamGoiY: Product[];
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

// Lọc sản phẩm phù hợp ngũ hành và loại phòng
export const laySanPhamGoiY = (loaiPhong: string, nguHanh: string): Product[] => {
  // Lọc theo không gian trước
  let filtered = products.filter((p) => p.space === loaiPhong);
  if (filtered.length < 2) {
    filtered = products; // Nếu phòng ít đồ thì lấy từ toàn bộ kho
  }

  // Ưu tiên sản phẩm có chất liệu/đặc tính hợp ngũ hành
  const prioritized = filtered.filter((p) => {
    const mat = (p.material || '').toLowerCase();
    const name = p.name.toLowerCase();
    if (nguHanh === 'Kim') return mat.includes('kim') || mat.includes('da') || mat.includes('đồng') || name.includes('trắng');
    if (nguHanh === 'Thuỷ') return mat.includes('kính') || mat.includes('da') || name.includes('đen') || name.includes('xanh');
    if (nguHanh === 'Mộc') return mat.includes('gỗ') || mat.includes('mây') || mat.includes('linen') || name.includes('xanh');
    if (nguHanh === 'Hoả') return mat.includes('nỉ') || mat.includes('gỗ') || p.category === 'den';
    if (nguHanh === 'Thổ') return mat.includes('đá') || mat.includes('gốm') || mat.includes('da') || mat.includes('nỉ');
    return true;
  });

  const list = prioritized.length >= 2 ? prioritized : filtered;
  return list.slice(0, 3);
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
    { vaiTro: 'Sinh khí (Tài lộc, thịnh vượng)', huong: info.huong[0] },
    { vaiTro: 'Thiên y (Sức khỏe, bình an)', huong: info.huong[1] },
    { vaiTro: 'Diên niên (Hòa thuận, gắn kết)', huong: info.huong[2] },
    { vaiTro: 'Phục vị (May mắn, học vấn)', huong: info.huong[3] },
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
    sanPhamGoiY: laySanPhamGoiY(input.loaiPhong, info.nguHanh),
  };
};

// Gọi Gemini AI tư vấn chuyên sâu
export const goiAITuVanPhongThuy = async (
  namSinh: number,
  gioiTinh: string,
  loaiPhongLabel: string,
  cung: string,
  nguHanh: string
): Promise<string> => {
  const apiKey = (import.meta as any).env?.PUBLIC_GEMINI_API_KEY;
  if (!apiKey) {
    return 'Vui lòng thêm biến môi trường PUBLIC_GEMINI_API_KEY vào file .env để kích hoạt tư vấn AI.';
  }
  const prompt = `Gia chủ sinh năm ${namSinh} (${gioiTinh === 'nam' ? 'Nam mạng' : 'Nữ mạng'}), thuộc cung ${cung}, mệnh ${nguHanh}. Đang hoàn thiện không gian: ${loaiPhongLabel}.
Hãy đóng vai Chuyên gia Phong Thủy của thương hiệu KTUFA Luxury Furniture, đưa ra lời luận giải ngắn gọn (khoảng 3 đoạn văn):
1. Nhận định phong thủy tổng quan cho căn phòng này của gia chủ.
2. Cách kê đồ đạc chính (hướng, vị trí tựa lưng, ánh sáng) để chiêu tài đón lộc.
3. Lời khuyên chọn chất liệu & màu sắc nội thất tương sinh.
Trình bày sang trọng, ấm áp, dùng gạch đầu dòng rõ ràng.`;

  const models = ['gemini-1.5-flash', 'gemini-2.0-flash', 'gemini-1.5-pro', 'gemini-3.5-flash-lite', 'gemini-3.5-flash', 'gemini-3.8-flash'];
  for (const m of models) {
    try {
      const res = await fetch(
        `https://generativelanguage.googleapis.com/v1beta/models/${m}:generateContent?key=${apiKey}`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            contents: [{ parts: [{ text: prompt }] }],
          }),
        }
      );
      if (res.ok) {
        const data = await res.json();
        const text = data.candidates?.[0]?.content?.parts?.[0]?.text;
        if (text) return text;
      }
    } catch (e) {
      // thử model tiếp theo
    }
  }
  return 'Gia chủ có bản mệnh hài hòa. Khi bài trí nên ưu tiên sự thông thoáng, tựa lưng vững chãi và sử dụng các màu sắc tương sinh theo ngũ hành để tụ tài sinh khí.';
};

export const NHAN_XET: string =
  'Kết quả dựa trên bảng tra cung mệnh (Bát trạch) kết hợp AI luận giải thời gian thực.';

