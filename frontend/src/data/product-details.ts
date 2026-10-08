export interface ProductDetail {
  description: string;
  dimensions: string;
  warranty: string;
}

export const productDetails: Record<string, ProductDetail> = {
  'sofa-da-y-milano': { description: 'Sofa ba chỗ bọc da bò Ý nguyên tấm, khung gỗ sồi sấy khô và đệm mút đàn hồi cao cấp, giữ phom bền theo thời gian.', dimensions: '240 × 95 × 78 cm', warranty: '24 tháng' },
  'sofa-vai-linen-oslo': { description: 'Sofa vải linen thoáng mát, đường may tỉ mỉ, chân gỗ chế tác thủ công, phù hợp không gian sống tối giản.', dimensions: '210 × 88 × 80 cm', warranty: '24 tháng' },
  'sofa-goc-bac-au': { description: 'Sofa góc chữ L phong cách Bắc Âu, các mô-đun tháo rời và đổi hướng linh hoạt theo bố cục phòng.', dimensions: '270 × 180 × 82 cm', warranty: '24 tháng' },
  'ban-an-da-marble-carrara': { description: 'Bàn ăn mặt đá marble Carrara nhập khẩu, chân kim loại mạ titan chống gỉ, mặt bàn được xử lý chống thấm.', dimensions: '180 × 90 × 75 cm', warranty: '24 tháng' },
  'ban-an-go-soi-nga': { description: 'Bàn ăn gỗ sồi Nga nguyên khối, phủ dầu bảo vệ tự nhiên giữ trọn vân gỗ và độ ấm của chất liệu.', dimensions: '160 × 80 × 75 cm', warranty: '24 tháng' },
  'ghe-an-da-boc-y': { description: 'Ghế ăn bọc da công nghiệp cao cấp, khung thép chịu lực, đệm êm vừa vặn cho bữa ăn dài.', dimensions: '48 × 55 × 88 cm', warranty: '12 tháng' },
  'ghe-thu-gian-go-oc-cho': { description: 'Ghế thư giãn gỗ óc chó, tựa lưng cong theo cơ thể, đệm vải nhập khẩu tạo cảm giác dễ chịu khi đọc sách.', dimensions: '72 × 80 × 95 cm', warranty: '24 tháng' },
  'ghe-cong-thai-hoc-ergo': { description: 'Ghế công thái học lưng lưới, tựa đầu và tay vịn điều chỉnh ba hướng, hỗ trợ cột sống khi làm việc dài.', dimensions: '66 × 66 × 118 cm', warranty: '12 tháng' },
  'ghe-ngoai-troi-go-teak': { description: 'Ghế ngoài trời gỗ teak chống mối mọt và chịu được mưa nắng, phù hợp ban công, sân vườn.', dimensions: '58 × 62 × 85 cm', warranty: '24 tháng' },
  'giuong-boc-ni-velvet': { description: 'Giường bọc nỉ velvet với đầu giường cao, khung gỗ chắc chắn và hệ nan đệm êm ái.', dimensions: '180 × 200 × 110 cm', warranty: '24 tháng' },
  'giuong-go-tu-nhien-scandinavian': { description: 'Giường gỗ sồi tự nhiên tối giản, bề mặt phủ dầu mờ an toàn cho sức khỏe và dễ vệ sinh.', dimensions: '160 × 200 × 95 cm', warranty: '24 tháng' },
  'tu-quan-ao-4-canh': { description: 'Tủ quần áo bốn cánh gỗ MDF chống ẩm, ray giảm chấn và hệ ngăn chia tiện dụng.', dimensions: '200 × 60 × 220 cm', warranty: '24 tháng' },
  'ke-tivi-treo-tuong': { description: 'Kệ tivi treo tường gọn gàng, có lỗ đi dây điện và tải trọng tới 60 kg.', dimensions: '180 × 35 × 40 cm', warranty: '24 tháng' },
  'ke-sach-go-thong': { description: 'Kệ sách gỗ thông năm tầng, thiết kế mở giúp góc làm việc thoáng đãng và dễ sắp xếp.', dimensions: '80 × 30 × 180 cm', warranty: '12 tháng' },
  'den-san-dong-thau': { description: 'Đèn sàn đồng thau thân mảnh, chao vải tản sáng dịu, tạo điểm nhấn cho góc đọc sách.', dimensions: 'Ø 40 × 160 cm', warranty: '12 tháng' },
  'den-tha-tran-may': { description: 'Đèn thả trần đan mây tự nhiên, ánh sáng ấm áp, phù hợp treo trên bàn ăn hoặc đảo bếp.', dimensions: 'Ø 55 × 40 cm', warranty: '12 tháng' },
  'den-ban-gom': { description: 'Đèn bàn gốm men mờ, chụp vải, cho ánh sáng vàng ấm phù hợp bàn làm việc và đầu giường.', dimensions: 'Ø 25 × 45 cm', warranty: '12 tháng' },
  'ban-tra-mat-kinh': { description: 'Bàn trà mặt kính cường lực 12 mm, khung inox mạ vàng sang trọng, dễ lau chùi.', dimensions: '120 × 60 × 42 cm', warranty: '12 tháng' },
  'guong-trang-tri-vien-vang': { description: 'Gương trang trí viền hợp kim mạ vàng, treo ngang hoặc dọc đều cân đối cho phòng ngủ.', dimensions: '60 × 90 cm', warranty: '12 tháng' },
};

const FALLBACK: ProductDetail = {
  description: 'Sản phẩm được chế tác thủ công và kiểm định chất lượng trước khi giao đến khách hàng.',
  dimensions: 'Đang cập nhật',
  warranty: '12 tháng',
};

export const getProductDetail = (slug: string): ProductDetail => productDetails[slug] ?? FALLBACK;
