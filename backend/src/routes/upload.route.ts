import { Router, Request, Response } from 'express';
import multer from 'multer';
import path from 'path';
import fs from 'fs';
import { verifyToken, requireAdmin } from '../middlewares/auth.middleware.js';

export const uploadRouter = Router();

// Ensure uploads directory exists
const backendUploadsDir = path.join(process.cwd(), 'uploads');
if (!fs.existsSync(backendUploadsDir)) {
  fs.mkdirSync(backendUploadsDir, { recursive: true });
}

// Frontend public/uploads directory for seamless static serving
const frontendUploadsDir = path.resolve(process.cwd(), '../frontend/public/uploads');
if (!fs.existsSync(frontendUploadsDir)) {
  try {
    fs.mkdirSync(frontendUploadsDir, { recursive: true });
  } catch {}
}

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => {
    cb(null, backendUploadsDir);
  },
  filename: (_req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase() || '.jpg';
    const cleanName = path.basename(file.originalname, ext).replace(/[^a-zA-Z0-9]/g, '-').slice(0, 30);
    const uniqueSuffix = `${Date.now()}-${Math.round(Math.random() * 1e5)}`;
    cb(null, `prod-${cleanName}-${uniqueSuffix}${ext}`);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 10 * 1024 * 1024 }, // 10MB limit
  fileFilter: (_req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Chỉ chấp nhận tệp định dạng hình ảnh!'));
    }
  },
});

// Helper to copy file to frontend public directory
const syncToFrontend = (filename: string) => {
  try {
    if (fs.existsSync(frontendUploadsDir)) {
      const src = path.join(backendUploadsDir, filename);
      const dest = path.join(frontendUploadsDir, filename);
      fs.copyFileSync(src, dest);
    }
  } catch (err) {
    console.warn('Không thể sao chép tệp sang frontend public uploads:', err);
  }
};

// ================================================================
// POST /api/upload
// Upload single image (Yêu cầu quyền Admin)
// ================================================================
uploadRouter.post('/', verifyToken, requireAdmin, upload.single('image'), (req: Request, res: Response) => {
  try {
    if (!req.file) {
      return res.status(400).json({ success: false, message: 'Vui lòng chọn một tệp hình ảnh.' });
    }

    const filename = req.file.filename;
    syncToFrontend(filename);

    const imageUrl = `http://localhost:4000/uploads/${filename}`;

    return res.json({
      success: true,
      message: 'Tải ảnh lên thành công!',
      url: imageUrl,
      relativePath: `/uploads/${filename}`,
      filename,
    });
  } catch (error: any) {
    console.error('Lỗi khi tải ảnh lên:', error);
    return res.status(500).json({ success: false, message: error.message || 'Lỗi khi tải ảnh lên.' });
  }
});

// ================================================================
// POST /api/upload/multiple
// Upload multiple images (Yêu cầu quyền Admin)
// ================================================================
uploadRouter.post('/multiple', verifyToken, requireAdmin, upload.array('images', 5), (req: Request, res: Response) => {
  try {
    const files = req.files as Express.Multer.File[];
    if (!files || files.length === 0) {
      return res.status(400).json({ success: false, message: 'Vui lòng chọn ít nhất một hình ảnh.' });
    }

    const urls = files.map((file) => {
      syncToFrontend(file.filename);
      return `http://localhost:4000/uploads/${file.filename}`;
    });

    return res.json({
      success: true,
      message: `Đã tải lên ${files.length} ảnh thành công!`,
      urls,
    });
  } catch (error: any) {
    console.error('Lỗi khi tải nhiều ảnh:', error);
    return res.status(500).json({ success: false, message: error.message || 'Lỗi khi tải ảnh.' });
  }
});
