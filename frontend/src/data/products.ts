export interface Product {
  slug: string;
  name: string;
  category: string;
  categoryLabel: string;
  space: string;
  spaceLabel: string;
  price: number;
  material: string;
  isNew?: boolean;
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

export const priceRanges: { key: string; label: string }[] = [
  { key: '0-10000000', label: 'Dưới 10 triệu' },
  { key: '10000000-20000000', label: '10 – 20 triệu' },
  { key: '20000000-50000000', label: '20 – 50 triệu' },
  { key: '50000000-', label: 'Trên 50 triệu' },
];

export const productsPerPage = 8;

export const products: Product[] = [
  { slug: 'sofa-da-y-milano', name: 'Sofa da Ý Milano', category: 'sofa', categoryLabel: 'Sofa', space: 'phong-khach', spaceLabel: 'Phòng khách', price: 58900000, material: 'Da bò Ý', isNew: true },
  { slug: 'sofa-vai-linen-oslo', name: 'Sofa vải linen Oslo', category: 'sofa', categoryLabel: 'Sofa', space: 'phong-khach', spaceLabel: 'Phòng khách', price: 26500000, material: 'Vải linen' },
  { slug: 'sofa-goc-bac-au', name: 'Sofa góc Bắc Âu', category: 'sofa', categoryLabel: 'Sofa', space: 'phong-khach', spaceLabel: 'Phòng khách', price: 32900000, material: 'Vải bố' },
  { slug: 'ban-an-da-marble-carrara', name: 'Bàn ăn đá marble Carrara', category: 'ban-an', categoryLabel: 'Bàn ăn', space: 'phong-an', spaceLabel: 'Phòng ăn', price: 32500000, material: 'Đá marble', isNew: true },
  { slug: 'ban-an-go-soi-nga', name: 'Bàn ăn gỗ sồi Nga', category: 'ban-an', categoryLabel: 'Bàn ăn', space: 'phong-an', spaceLabel: 'Phòng ăn', price: 18900000, material: 'Gỗ sồi' },
  { slug: 'ghe-an-da-boc-y', name: 'Ghế ăn da bọc Ý', category: 'ghe', categoryLabel: 'Ghế', space: 'phong-an', spaceLabel: 'Phòng ăn', price: 4200000, material: 'Da công nghiệp' },
  { slug: 'ghe-thu-gian-go-oc-cho', name: 'Ghế thư giãn gỗ óc chó', category: 'ghe', categoryLabel: 'Ghế', space: 'phong-khach', spaceLabel: 'Phòng khách', price: 18900000, material: 'Gỗ óc chó' },
  { slug: 'ghe-cong-thai-hoc-ergo', name: 'Ghế công thái học Ergo', category: 'ghe', categoryLabel: 'Ghế', space: 'lam-viec', spaceLabel: 'Làm việc', price: 6900000, material: 'Lưới & nhựa' },
  { slug: 'ghe-ngoai-troi-go-teak', name: 'Ghế ngoài trời gỗ teak', category: 'ghe', categoryLabel: 'Ghế', space: 'ngoai-troi', spaceLabel: 'Ngoài trời', price: 8900000, material: 'Gỗ teak' },
  { slug: 'giuong-boc-ni-velvet', name: 'Giường ngủ bọc nỉ Velvet', category: 'giuong', categoryLabel: 'Giường', space: 'phong-ngu', spaceLabel: 'Phòng ngủ', price: 22900000, material: 'Nỉ velvet' },
  { slug: 'giuong-go-tu-nhien-scandinavian', name: 'Giường gỗ tự nhiên Scandinavian', category: 'giuong', categoryLabel: 'Giường', space: 'phong-ngu', spaceLabel: 'Phòng ngủ', price: 28500000, material: 'Gỗ sồi' },
  { slug: 'tu-quan-ao-4-canh', name: 'Tủ quần áo 4 cánh', category: 'tu-ke', categoryLabel: 'Tủ & Kệ', space: 'phong-ngu', spaceLabel: 'Phòng ngủ', price: 24500000, material: 'Gỗ MDF' },
  { slug: 'ke-tivi-treo-tuong', name: 'Kệ tivi treo tường', category: 'tu-ke', categoryLabel: 'Tủ & Kệ', space: 'phong-khach', spaceLabel: 'Phòng khách', price: 9800000, material: 'Gỗ công nghiệp' },
  { slug: 'ke-sach-go-thong', name: 'Kệ sách gỗ thông', category: 'tu-ke', categoryLabel: 'Tủ & Kệ', space: 'lam-viec', spaceLabel: 'Làm việc', price: 7200000, material: 'Gỗ thông' },
  { slug: 'den-san-dong-thau', name: 'Đèn sàn đồng thau', category: 'den', categoryLabel: 'Đèn', space: 'chieu-sang', spaceLabel: 'Chiếu sáng', price: 7900000, material: 'Đồng thau', isNew: true },
  { slug: 'den-tha-tran-may', name: 'Đèn thả trần mây', category: 'den', categoryLabel: 'Đèn', space: 'phong-an', spaceLabel: 'Phòng ăn', price: 3400000, material: 'Mây tự nhiên' },
  { slug: 'den-ban-gom', name: 'Đèn bàn gốm', category: 'den', categoryLabel: 'Đèn', space: 'lam-viec', spaceLabel: 'Làm việc', price: 1900000, material: 'Gốm' },
  { slug: 'ban-tra-mat-kinh', name: 'Bàn trà mặt kính', category: 'trang-tri', categoryLabel: 'Trang trí', space: 'phong-khach', spaceLabel: 'Phòng khách', price: 5600000, material: 'Kính cường lực' },
  { slug: 'guong-trang-tri-vien-vang', name: 'Gương trang trí viền mạ vàng', category: 'trang-tri', categoryLabel: 'Trang trí', space: 'phong-ngu', spaceLabel: 'Phòng ngủ', price: 3100000, material: 'Hợp kim mạ' },
];

export const formatVnd = (value: number): string => value.toLocaleString('vi-VN') + '₫';
