import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const categoriesData = [
  { slug: 'sofa', name: 'Sofa' },
  { slug: 'ban-an', name: 'Bàn ăn' },
  { slug: 'ghe', name: 'Ghế' },
  { slug: 'giuong', name: 'Giường' },
  { slug: 'tu-ke', name: 'Tủ & Kệ' },
  { slug: 'den', name: 'Đèn' },
  { slug: 'trang-tri', name: 'Trang trí' },
];

const productsData = [
  { slug: 'sofa-da-y-milano', name: 'Sofa da Ý Milano', categorySlug: 'sofa', price: 58900000, material: 'Da bò Ý', dimensions: '240 × 95 × 78 cm', desc: 'Sofa ba chỗ bọc da bò Ý nguyên tấm, khung gỗ sồi sấy khô và đệm mút đàn hồi cao cấp, giữ phom bền theo thời gian.' },
  { slug: 'sofa-vai-linen-oslo', name: 'Sofa vải linen Oslo', categorySlug: 'sofa', price: 26500000, material: 'Vải linen', dimensions: '210 × 88 × 80 cm', desc: 'Sofa vải linen thoáng mát, đường may tỉ mỉ, chân gỗ chế tác thủ công, phù hợp không gian sống tối giản.' },
  { slug: 'sofa-goc-bac-au', name: 'Sofa góc Bắc Âu', categorySlug: 'sofa', price: 32900000, material: 'Vải bố', dimensions: '270 × 180 × 82 cm', desc: 'Sofa góc chữ L phong cách Bắc Âu, các mô-đun tháo rời và đổi hướng linh hoạt theo bố cục phòng.' },
  { slug: 'ban-an-da-marble-carrara', name: 'Bàn ăn đá marble Carrara', categorySlug: 'ban-an', price: 32500000, material: 'Đá marble', dimensions: '180 × 90 × 75 cm', desc: 'Bàn ăn mặt đá marble Carrara nhập khẩu, chân kim loại mạ titan chống gỉ, mặt bàn được xử lý chống thấm.' },
  { slug: 'ban-an-go-soi-nga', name: 'Bàn ăn gỗ sồi Nga', categorySlug: 'ban-an', price: 18900000, material: 'Gỗ sồi', dimensions: '160 × 80 × 75 cm', desc: 'Bàn ăn gỗ sồi Nga nguyên khối, phủ dầu bảo vệ tự nhiên giữ trọn vân gỗ và độ ấm của chất liệu.' },
  { slug: 'ghe-an-da-boc-y', name: 'Ghế ăn da bọc Ý', categorySlug: 'ghe', price: 4200000, material: 'Da công nghiệp', dimensions: '48 × 55 × 88 cm', desc: 'Ghế ăn bọc da công nghiệp cao cấp, khung thép chịu lực, đệm êm vừa vặn cho bữa ăn dài.' },
  { slug: 'ghe-thu-gian-go-oc-cho', name: 'Ghế thư giãn gỗ óc chó', categorySlug: 'ghe', price: 18900000, material: 'Gỗ óc chó', dimensions: '72 × 80 × 95 cm', desc: 'Ghế thư giãn gỗ óc chó, tựa lưng cong theo cơ thể, đệm vải nhập khẩu tạo cảm giác dễ chịu khi đọc sách.' },
  { slug: 'ghe-cong-thai-hoc-ergo', name: 'Ghế công thái học Ergo', categorySlug: 'ghe', price: 6900000, material: 'Lưới & nhựa', dimensions: '66 × 66 × 118 cm', desc: 'Ghế công thái học lưng lưới, tựa đầu và tay vịn điều chỉnh ba hướng, hỗ trợ cột sống khi làm việc dài.' },
  { slug: 'ghe-ngoai-troi-go-teak', name: 'Ghế ngoài trời gỗ teak', categorySlug: 'ghe', price: 8900000, material: 'Gỗ teak', dimensions: '58 × 62 × 85 cm', desc: 'Ghế ngoài trời gỗ teak chống mối mọt và chịu được mưa nắng, phù hợp ban công, sân vườn.' },
  { slug: 'giuong-boc-ni-velvet', name: 'Giường ngủ bọc nỉ Velvet', categorySlug: 'giuong', price: 22900000, material: 'Nỉ velvet', dimensions: '180 × 200 × 110 cm', desc: 'Giường bọc nỉ velvet với đầu giường cao, khung gỗ chắc chắn và hệ nan đệm êm ái.' },
  { slug: 'giuong-go-tu-nhien-scandinavian', name: 'Giường gỗ tự nhiên Scandinavian', categorySlug: 'giuong', price: 28500000, material: 'Gỗ sồi', dimensions: '160 × 200 × 95 cm', desc: 'Giường gỗ sồi tự nhiên tối giản, bề mặt phủ dầu mờ an toàn cho sức khỏe và dễ vệ sinh.' },
  { slug: 'tu-quan-ao-4-canh', name: 'Tủ quần áo 4 cánh', categorySlug: 'tu-ke', price: 24500000, material: 'Gỗ MDF', dimensions: '200 × 60 × 220 cm', desc: 'Tủ quần áo bốn cánh gỗ MDF chống ẩm, ray giảm chấn và hệ ngăn chia tiện dụng.' },
  { slug: 'ke-tivi-treo-tuong', name: 'Kệ tivi treo tường', categorySlug: 'tu-ke', price: 9800000, material: 'Gỗ công nghiệp', dimensions: '180 × 35 × 40 cm', desc: 'Kệ tivi treo tường gọn gàng, có lỗ đi dây điện và tải trọng tới 60 kg.' },
  { slug: 'ke-sach-go-thong', name: 'Kệ sách gỗ thông', categorySlug: 'tu-ke', price: 7200000, material: 'Gỗ thông', dimensions: '80 × 30 × 180 cm', desc: 'Kệ sách gỗ thông năm tầng, thiết kế mở giúp góc làm việc thoáng đãng và dễ sắp xếp.' },
  { slug: 'den-san-dong-thau', name: 'Đèn sàn đồng thau', categorySlug: 'den', price: 7900000, material: 'Đồng thau', dimensions: 'Ø 40 × 160 cm', desc: 'Đèn sàn đồng thau thân mảnh, chao vải tản sáng dịu, tạo điểm nhấn cho góc đọc sách.' },
  { slug: 'den-tha-tran-may', name: 'Đèn thả trần mây', categorySlug: 'den', price: 3400000, material: 'Mây tự nhiên', dimensions: 'Ø 55 × 40 cm', desc: 'Đèn thả trần đan mây tự nhiên, ánh sáng ấm áp, phù hợp treo trên bàn ăn hoặc đảo bếp.' },
  { slug: 'den-ban-gom', name: 'Đèn bàn gốm', categorySlug: 'den', price: 1900000, material: 'Gốm', dimensions: 'Ø 25 × 45 cm', desc: 'Đèn bàn gốm men mờ, chụp vải, cho ánh sáng vàng ấm phù hợp bàn làm việc và đầu giường.' },
  { slug: 'ban-tra-mat-kinh', name: 'Bàn trà mặt kính', categorySlug: 'trang-tri', price: 5600000, material: 'Kính cường lực', dimensions: '120 × 60 × 42 cm', desc: 'Bàn trà mặt kính cường lực 12 mm, khung inox mạ vàng sang trọng, dễ lau chùi.' },
  { slug: 'guong-trang-tri-vien-vang', name: 'Gương trang trí viền mạ vàng', categorySlug: 'trang-tri', price: 3100000, material: 'Hợp kim mạ', dimensions: '60 × 90 cm', desc: 'Gương trang trí viền hợp kim mạ vàng, treo ngang hoặc dọc đều cân đối cho phòng ngủ.' },
];

async function main() {
  console.log('Seeding categories and products into XAMPP MySQL...');

  for (const cat of categoriesData) {
    const existing = await prisma.categories.findUnique({ where: { slug: cat.slug } });
    if (!existing) {
      await prisma.categories.create({
        data: {
          slug: cat.slug,
          name: cat.name,
          status: true,
        },
      });
    }
  }

  const allCategories = await prisma.categories.findMany();
  const catMap = new Map(allCategories.map((c) => [c.slug, c.id]));

  for (const p of productsData) {
    const catId = catMap.get(p.categorySlug);
    if (!catId) continue;

    const existingProduct = await prisma.products.findUnique({ where: { slug: p.slug } });
    if (!existingProduct) {
      const created = await prisma.products.create({
        data: {
          slug: p.slug,
          name: p.name,
          category_id: catId,
          short_description: p.desc,
          status: true,
        },
      });

      await prisma.product_variants.create({
        data: {
          product_id: created.id,
          sku: 'SKU-' + p.slug.toUpperCase(),
          material: p.material,
          price: p.price,
          stock_quantity: 20,
          dimensions: p.dimensions,
        },
      });
    }
  }

  console.log('Seed into XAMPP completed successfully!');
  await prisma.$disconnect();
}

main().catch((err) => {
  console.error('Seed failed:', err);
  process.exit(1);
});
