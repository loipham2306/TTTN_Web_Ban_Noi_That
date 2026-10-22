import multer from 'multer';
import path from 'path';
import fs from 'fs';

// Tạo thư mục uploads/banners nếu chưa tồn tại
const uploadDir = path.join(process.cwd(), 'uploads/banners');
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    cb(null, 'banner-' + uniqueSuffix + path.extname(file.originalname));
  },
});

export const uploadBanner = multer({ storage });