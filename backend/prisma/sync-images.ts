import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const productImagesMap: Record<string, string> = {
  'sofa-da-y-milano': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80',
  'sofa-vai-linen-oslo': 'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?auto=format&fit=crop&w=600&q=80',
  'sofa-goc-bac-au': 'https://images.unsplash.com/photo-1540574163026-643ea20ade25?auto=format&fit=crop&w=600&q=80',
  'ban-an-da-marble-carrara': 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=600&q=80',
  'ban-an-go-soi-nga': 'https://images.unsplash.com/photo-1577140917170-285929fb55b7?auto=format&fit=crop&w=600&q=80',
  'ghe-an-da-boc-y': 'https://images.unsplash.com/photo-1580481077198-c847ad43616b?auto=format&fit=crop&w=600&q=80',
  'ghe-thu-gian-go-oc-cho': 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=600&q=80',
  'ghe-cong-thai-hoc-ergo': 'https://images.unsplash.com/photo-1505797149-43b0069ec26b?auto=format&fit=crop&w=600&q=80',
  'ghe-ngoai-troi-go-teak': 'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=600&q=80',
  'giuong-boc-ni-velvet': 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=600&q=80',
  'giuong-go-tu-nhien-scandinavian': 'https://images.unsplash.com/photo-1540518614846-7ede433c4ef9?auto=format&fit=crop&w=600&q=80',
  'tu-quan-ao-4-canh': 'https://images.unsplash.com/photo-1558997519-83ea9252def8?auto=format&fit=crop&w=600&q=80',
  'ke-tivi-treo-tuong': 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=600&q=80',
  'ke-sach-go-thong': 'https://images.unsplash.com/photo-1594671581654-278554dd3460?auto=format&fit=crop&w=600&q=80',
  'den-san-dong-thau': 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=600&q=80',
  'den-tha-tran-may': 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&w=600&q=80',
  'den-ban-gom': 'https://images.unsplash.com/photo-1534349762230-e0cadf78f5da?auto=format&fit=crop&w=600&q=80',
  'ban-tra-mat-kinh': 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?auto=format&fit=crop&w=600&q=80',
  'guong-trang-tri-vien-vang': 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=600&q=80',
};

async function syncImages() {
  console.log('Connecting to MySQL and synchronizing images...');
  let updatedCount = 0;
  let createdCount = 0;

  for (const [slug, imageUrl] of Object.entries(productImagesMap)) {
    const product = await prisma.products.findFirst({ where: { slug } });
    if (!product) {
      console.log(`Product with slug "${slug}" not found in database, skipping.`);
      continue;
    }

    const existingThumbnail = await prisma.product_images.findFirst({
      where: { product_id: product.id, is_thumbnail: true },
    });

    if (existingThumbnail) {
      await prisma.product_images.update({
        where: { id: existingThumbnail.id },
        data: { image_url: imageUrl },
      });
      updatedCount++;
    } else {
      await prisma.product_images.create({
        data: {
          product_id: product.id,
          image_url: imageUrl,
          is_thumbnail: true,
          sort_order: 0,
        },
      });
      createdCount++;
    }
  }

  console.log(`Synchronization finished! Created: ${createdCount}, Updated: ${updatedCount}`);
  await prisma.$disconnect();
}

syncImages().catch((err) => {
  console.error('Sync failed:', err);
  process.exit(1);
});
