import { prisma } from '../config/prisma.js';

async function seedBanners() {
  console.log('Seeding page header banners...');

  const existingSanpham = await prisma.banners.findFirst({
    where: { position: 'san-pham' }
  });

  if (!existingSanpham) {
    await prisma.banners.create({
      data: {
        title: 'BỘ SƯU TẬP NỘI THẤT CAO CẤP',
        subtitle: 'Không Gian Sống Nghệ Thuật & Đẳng Cấp',
        description: 'Tuyển chọn hơn 500+ mẫu thiết kế tinh xảo từ gỗ tự nhiên, da Ý cao cấp và kim loại mạ vàng sang trọng.',
        image_url: 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1920&q=80',
        link_url: '/san-pham',
        button_text: 'Khám phá bộ sưu tập',
        position: 'san-pham',
        display_order: 1,
        is_active: true,
      }
    });
    console.log('Created banner for san-pham');
  } else {
    console.log('Banner for san-pham already exists');
  }

  const existingPhongthuy = await prisma.banners.findFirst({
    where: { position: 'phong-thuy' }
  });

  if (!existingPhongthuy) {
    await prisma.banners.create({
      data: {
        title: 'TƯ VẤN PHONG THỦY & BÀI TRÍ NỘI THẤT',
        subtitle: 'Ứng Dụng Trí Tuệ Nhân Tạo Gemini AI & Bát Trạch',
        description: 'Định hướng sinh khí tài lộc, phối hợp màu sắc ngũ hành và bài trí nội thất chuẩn phong thủy cho gia chủ.',
        image_url: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1920&q=80',
        link_url: '/phong-thuy',
        button_text: 'Tra cứu cung mệnh ngay',
        position: 'phong-thuy',
        display_order: 1,
        is_active: true,
      }
    });
    console.log('Created banner for phong-thuy');
  } else {
    console.log('Banner for phong-thuy already exists');
  }

  const existingVechungtoi = await prisma.banners.findFirst({
    where: { position: 've-chung-toi' }
  });

  if (!existingVechungtoi) {
    await prisma.banners.create({
      data: {
        title: 'VỀ CHÚNG TÔI — KTUFA',
        subtitle: 'Hành Trình Kiến Tạo Không Gian Sống Đẳng Cấp',
        description: 'Tuyển chọn vật liệu tự nhiên thượng hạng, chế tác thủ công tinh xảo và triết lý phong thủy Á Đông kiến tạo kiệt tác không gian sống.',
        image_url: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1920&q=80',
        link_url: '/ve-chung-toi#cau-chuyen',
        button_text: 'Khám phá ngay',
        position: 've-chung-toi',
        display_order: 1,
        is_active: true,
      }
    });
    console.log('Created banner for ve-chung-toi');
  } else {
    console.log('Banner for ve-chung-toi already exists');
  }

  process.exit(0);
}

seedBanners().catch((err) => {
  console.error(err);
  process.exit(1);
});
