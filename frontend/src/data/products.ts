export interface Product {
  slug: string;
  name: string;
  category: string;
  categoryLabel: string;
  space: string;
  spaceLabel: string;
  price: number;
  comparePrice?: number | null;
  material: string;
  color?: string;
  colorLabel?: string;
  isNew?: boolean;
  image?: string;
  thumbnail?: string;
}

export const categories: { key: string; label: string }[] = [
  { key: 'sofa', label: 'Sofa' },
  { key: 'ban-an', label: 'Bàn ăn' },
  { key: 'ghe', label: 'Ghế' },
  { key: 'giuong', label: 'Giường' },
  { key: 'tu-ke', label: 'Tủ & Kệ' },
  { key: 'den', label: 'Đèn' },
  { key: 'trang-tri', label: 'Trang trí' },
];

export const spaces: { key: string; label: string }[] = [
  { key: 'phong-khach', label: 'Phòng khách' },
  { key: 'phong-ngu', label: 'Phòng ngủ' },
  { key: 'phong-an', label: 'Phòng ăn' },
  { key: 'lam-viec', label: 'Làm việc' },
  { key: 'chieu-sang', label: 'Chiếu sáng' },
  { key: 'ngoai-troi', label: 'Ngoài trời' },
];

export const materials: { key: string; label: string }[] = [
  { key: 'Gỗ sồi', label: 'Gỗ sồi Nga' },
  { key: 'Gỗ óc chó', label: 'Gỗ óc chó' },
  { key: 'Gỗ teak', label: 'Gỗ teak ngoài trời' },
  { key: 'Gỗ thông', label: 'Gỗ thông tự nhiên' },
  { key: 'Gỗ MDF', label: 'Gỗ công nghiệp MDF' },
  { key: 'Da bò Ý', label: 'Da bò Ý cao cấp' },
  { key: 'Da công nghiệp', label: 'Da công nghiệp' },
  { key: 'Vải linen', label: 'Vải linen thoáng mát' },
  { key: 'Nỉ velvet', label: 'Nỉ velvet nhung' },
  { key: 'Vải bố', label: 'Vải bố Bắc Âu' },
  { key: 'Đá marble', label: 'Đá marble Carrara' },
  { key: 'Đồng thau', label: 'Đồng thau cao cấp' },
  { key: 'Mây tự nhiên', label: 'Mây tự nhiên thủ công' },
  { key: 'Gốm', label: 'Gốm sứ thủ công' },
  { key: 'Kính cường lực', label: 'Kính cường lực' },
  { key: 'Hợp kim mạ', label: 'Hợp kim mạ vàng' },
];

export const colors: { key: string; label: string; hex: string; border?: string }[] = [
  { key: 'nau', label: 'Nâu óc chó / Da bò', hex: '#5C3A21' },
  { key: 'vang-go', label: 'Vàng gỗ tự nhiên', hex: '#D4A373' },
  { key: 'be', label: 'Kem / Be cát', hex: '#E1DDC9' },
  { key: 'den', label: 'Đen huyền bí', hex: '#1F2937' },
  { key: 'xanh-reu', label: 'Xanh rêu KTUFA', hex: '#173524' },
  { key: 'vang-kim', label: 'Vàng Champagne', hex: '#D8B670' },
  { key: 'trang', label: 'Trắng sứ / Marble', hex: '#F9FAFB', border: '#D1D5DB' },
  { key: 'xam', label: 'Xám hiện đại', hex: '#6B7280' },
];

export const priceRanges: { key: string; label: string }[] = [
  { key: '0-10000000', label: 'Dưới 10 triệu' },
  { key: '10000000-20000000', label: '10 - 20 triệu' },
  { key: '20000000-50000000', label: '20 - 50 triệu' },
  { key: '50000000-', label: 'Trên 50 triệu' },
];

export const productsPerPage = 9;

export const products: Product[] = [
  { slug: 'sofa-da-y-milano', name: 'Sofa da Ý Milano', category: 'sofa', categoryLabel: 'Sofa', space: 'phong-khach', spaceLabel: 'Phòng khách', price: 58900000, material: 'Da bò Ý', color: 'nau', colorLabel: 'Nâu da bò', isNew: true, image: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80' },
  { slug: 'sofa-vai-linen-oslo', name: 'Sofa vải linen Oslo', category: 'sofa', categoryLabel: 'Sofa', space: 'phong-khach', spaceLabel: 'Phòng khách', price: 26500000, material: 'Vải linen', color: 'be', colorLabel: 'Be cát', image: 'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?auto=format&fit=crop&w=600&q=80' },
  { slug: 'sofa-goc-bac-au', name: 'Sofa góc Bắc Âu', category: 'sofa', categoryLabel: 'Sofa', space: 'phong-khach', spaceLabel: 'Phòng khách', price: 32900000, material: 'Vải bố', color: 'xam', colorLabel: 'Xám Bắc Âu', image: 'https://images.unsplash.com/photo-1540574163026-643ea20ade25?auto=format&fit=crop&w=600&q=80' },
  { slug: 'ban-an-da-marble-carrara', name: 'Bàn ăn đá marble Carrara', category: 'ban-an', categoryLabel: 'Bàn ăn', space: 'phong-an', spaceLabel: 'Phòng ăn', price: 32500000, material: 'Đá marble', color: 'trang', colorLabel: 'Trắng Carrara', isNew: true, image: 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=600&q=80' },
  { slug: 'ban-an-go-soi-nga', name: 'Bàn ăn gỗ sồi Nga', category: 'ban-an', categoryLabel: 'Bàn ăn', space: 'phong-an', spaceLabel: 'Phòng ăn', price: 18900000, material: 'Gỗ sồi', color: 'vang-go', colorLabel: 'Vàng gỗ sồi', image: 'https://images.unsplash.com/photo-1577140917170-285929fb55b7?auto=format&fit=crop&w=600&q=80' },
  { slug: 'ghe-an-da-boc-y', name: 'Ghế ăn da bọc Ý', category: 'ghe', categoryLabel: 'Ghế', space: 'phong-an', spaceLabel: 'Phòng ăn', price: 4200000, material: 'Da công nghiệp', color: 'den', colorLabel: 'Đen', image: 'https://images.unsplash.com/photo-1580481077198-c847ad43616b?auto=format&fit=crop&w=600&q=80' },
  { slug: 'ghe-thu-gian-go-oc-cho', name: 'Ghế thư giãn gỗ óc chó', category: 'ghe', categoryLabel: 'Ghế', space: 'phong-khach', spaceLabel: 'Phòng khách', price: 18900000, material: 'Gỗ óc chó', color: 'nau', colorLabel: 'Nâu óc chó', image: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=600&q=80' },
  { slug: 'ghe-cong-thai-hoc-ergo', name: 'Ghế công thái học Ergo', category: 'ghe', categoryLabel: 'Ghế', space: 'lam-viec', spaceLabel: 'Làm việc', price: 6900000, material: 'Lưới & nhựa', color: 'den', colorLabel: 'Đen', image: 'https://images.unsplash.com/photo-1505797149-43b0069ec26b?auto=format&fit=crop&w=600&q=80' },
  { slug: 'ghe-ngoai-troi-go-teak', name: 'Ghế ngoài trời gỗ teak', category: 'ghe', categoryLabel: 'Ghế', space: 'ngoai-troi', spaceLabel: 'Ngoài trời', price: 8900000, material: 'Gỗ teak', color: 'nau', colorLabel: 'Nâu mật ong', image: 'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=600&q=80' },
  { slug: 'giuong-boc-ni-velvet', name: 'Giường ngủ bọc nỉ Velvet', category: 'giuong', categoryLabel: 'Giường', space: 'phong-ngu', spaceLabel: 'Phòng ngủ', price: 22900000, material: 'Nỉ velvet', color: 'xanh-reu', colorLabel: 'Xanh rêu', image: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=600&q=80' },
  { slug: 'giuong-go-tu-nhien-scandinavian', name: 'Giường gỗ tự nhiên Scandinavian', category: 'giuong', categoryLabel: 'Giường', space: 'phong-ngu', spaceLabel: 'Phòng ngủ', price: 28500000, material: 'Gỗ sồi', color: 'vang-go', colorLabel: 'Vàng gỗ tự nhiên', image: 'https://images.unsplash.com/photo-1540518614846-7ede433c4ef9?auto=format&fit=crop&w=600&q=80' },
  { slug: 'tu-quan-ao-4-canh', name: 'Tủ quần áo 4 cánh', category: 'tu-ke', categoryLabel: 'Tủ & Kệ', space: 'phong-ngu', spaceLabel: 'Phòng ngủ', price: 24500000, material: 'Gỗ MDF', color: 'trang', colorLabel: 'Trắng', image: 'https://images.unsplash.com/photo-1558997519-83ea9252def8?auto=format&fit=crop&w=600&q=80' },
  { slug: 'ke-tivi-treo-tuong', name: 'Kệ tivi treo tường', category: 'tu-ke', categoryLabel: 'Tủ & Kệ', space: 'phong-khach', spaceLabel: 'Phòng khách', price: 9800000, material: 'Gỗ công nghiệp', color: 'nau', colorLabel: 'Nâu óc chó', image: 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=600&q=80' },
  { slug: 'ke-sach-go-thong', name: 'Kệ sách gỗ thông', category: 'tu-ke', categoryLabel: 'Tủ & Kệ', space: 'lam-viec', spaceLabel: 'Làm việc', price: 7200000, material: 'Gỗ thông', color: 'vang-go', colorLabel: 'Vàng gỗ thông', image: 'https://images.unsplash.com/photo-1594671581654-278554dd3460?auto=format&fit=crop&w=600&q=80' },
  { slug: 'den-san-dong-thau', name: 'Đèn sàn đồng thau', category: 'den', categoryLabel: 'Đèn', space: 'chieu-sang', spaceLabel: 'Chiếu sáng', price: 7900000, material: 'Đồng thau', color: 'vang-kim', colorLabel: 'Vàng đồng / Champagne', isNew: true, image: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=600&q=80' },
  { slug: 'den-tha-tran-may', name: 'Đèn thả trần mây', category: 'den', categoryLabel: 'Đèn', space: 'phong-an', spaceLabel: 'Phòng ăn', price: 3400000, material: 'Mây tự nhiên', color: 'be', colorLabel: 'Mây vàng nhạt', image: 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&w=600&q=80' },
  { slug: 'den-ban-gom', name: 'Đèn bàn gốm', category: 'den', categoryLabel: 'Đèn', space: 'lam-viec', spaceLabel: 'Làm việc', price: 1900000, material: 'Gốm', color: 'trang', colorLabel: 'Trắng gốm men', image: 'https://images.unsplash.com/photo-1534349762230-e0cadf78f5da?auto=format&fit=crop&w=600&q=80' },
  { slug: 'ban-tra-mat-kinh', name: 'Bàn trà mặt kính', category: 'trang-tri', categoryLabel: 'Trang trí', space: 'phong-khach', spaceLabel: 'Phòng khách', price: 5600000, material: 'Kính cường lực', color: 'vang-kim', colorLabel: 'Vàng kim titan', image: 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?auto=format&fit=crop&w=600&q=80' },
  { slug: 'guong-trang-tri-vien-vang', name: 'Gương trang trí viền mạ vàng', category: 'trang-tri', categoryLabel: 'Trang trí', space: 'phong-ngu', spaceLabel: 'Phòng ngủ', price: 3100000, material: 'Hợp kim mạ', color: 'vang-kim', colorLabel: 'Vàng kim', image: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=600&q=80' },
];

export const formatVnd = (value: number): string => Number(value || 0).toLocaleString('vi-VN') + ' đ';
