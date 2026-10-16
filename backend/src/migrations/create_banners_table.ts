import { prisma } from '../config/prisma.js';

async function main() {
  console.log('Creating banners table in MySQL...');
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS banners (
      id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      subtitle VARCHAR(255) NULL,
      description TEXT NULL,
      image_url TEXT NOT NULL,
      link_url VARCHAR(255) NULL DEFAULT '/san-pham',
      button_text VARCHAR(100) NULL DEFAULT 'Khám phá ngay',
      position VARCHAR(50) NOT NULL DEFAULT 'hero',
      display_order INT DEFAULT 0,
      is_active BOOLEAN DEFAULT TRUE,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );
  `);
  console.log('Table banners created or already exists.');

  // Check count
  const count: any = await prisma.$queryRawUnsafe('SELECT COUNT(*) as count FROM banners');
  console.log('Banner count in MySQL:', count);
  process.exit(0);
}

main().catch((err) => {
  console.error('Error creating banners table:', err);
  process.exit(1);
});
