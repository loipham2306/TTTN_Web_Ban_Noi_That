const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const target = (process.argv[2] || '').toLowerCase().trim();

if (target !== 'mysql' && target !== 'supabase') {
  console.error('\n[LỖI] Tham số không hợp lệ!');
  console.log('Cách dùng:');
  console.log('  npm run db:mysql     -> Chuyển sang MySQL local trên XAMPP');
  console.log('  npm run db:supabase  -> Chuyển sang PostgreSQL Cloud trên Supabase\n');
  process.exit(1);
}

const rootDir = path.resolve(__dirname, '..');
const prismaDir = path.join(rootDir, 'prisma');
const envPath = path.join(rootDir, '.env');

const schemaTarget = path.join(prismaDir, 'schema.prisma');
const schemaMysql = path.join(prismaDir, 'schema.mysql.prisma');
const schemaSupabase = path.join(prismaDir, 'schema.supabase.prisma');

console.log(`\n======================================================`);
console.log(`🔄 ĐANG CHUYỂN CƠ SỞ DỮ LIỆU SANG: ${target.toUpperCase()}`);
console.log(`======================================================`);

// 1. Sao chép Schema tương ứng
if (target === 'mysql') {
  if (!fs.existsSync(schemaMysql)) {
    console.error(`[Lỗi] Không tìm thấy file: ${schemaMysql}`);
    process.exit(1);
  }
  fs.copyFileSync(schemaMysql, schemaTarget);
  console.log(`✓ Đã nạp schema: prisma/schema.mysql.prisma -> schema.prisma`);
} else {
  if (!fs.existsSync(schemaSupabase)) {
    console.error(`[Lỗi] Không tìm thấy file: ${schemaSupabase}`);
    process.exit(1);
  }
  fs.copyFileSync(schemaSupabase, schemaTarget);
  console.log(`✓ Đã nạp schema: prisma/schema.supabase.prisma -> schema.prisma`);
}

// 2. Cập nhật file .env
if (fs.existsSync(envPath)) {
  let envContent = fs.readFileSync(envPath, 'utf8');

  if (target === 'mysql') {
    // Kích hoạt MySQL, vô hiệu hóa Supabase
    envContent = envContent.replace(/^#?\s*(DATABASE_URL\s*=\s*"mysql:[^"]*")/m, '$1');
    envContent = envContent.replace(/^([^#\r\n]*DATABASE_URL\s*=\s*"postgresql:[^"]*")/gm, '# $1');
    envContent = envContent.replace(/^([^#\r\n]*DIRECT_URL\s*=\s*"postgresql:[^"]*")/gm, '# $1');
  } else {
    // Kích hoạt Supabase, vô hiệu hóa MySQL
    envContent = envContent.replace(/^([^#\r\n]*DATABASE_URL\s*=\s*"mysql:[^"]*")/gm, '# $1');
    envContent = envContent.replace(/^#\s*(DATABASE_URL\s*=\s*"postgresql:[^"]*")/gm, '$1');
    envContent = envContent.replace(/^#\s*(DIRECT_URL\s*=\s*"postgresql:[^"]*")/gm, '$1');
  }

  fs.writeFileSync(envPath, envContent, 'utf8');
  console.log(`✓ Đã cập nhật biến môi trường trong file: backend/.env`);
} else {
  console.warn(`[Cảnh báo] Không tìm thấy file .env tại: ${envPath}`);
}

// 3. Tự động sinh Prisma Client
console.log(`⏳ Đang chạy npx prisma generate...`);
try {
  execSync('npx prisma generate', { cwd: rootDir, stdio: 'inherit' });
  console.log(`\n🎉 THÀNH CÔNG! Đã chuyển sang ${target.toUpperCase()} hoàn tất!`);
  if (target === 'mysql') {
    console.log(`👉 Bạn nhớ bật MySQL trong XAMPP (Port 3306) trước khi chạy backend nhé!`);
  } else {
    console.log(`👉 Đã kết nối Supabase Cloud online 24/7 (Không cần bật XAMPP).`);
  }
  console.log(`👉 Khởi động backend bằng lệnh: npm run dev\n`);
} catch (err) {
  console.error(`\n[Lỗi khi chạy prisma generate]:`, err.message);
  process.exit(1);
}
