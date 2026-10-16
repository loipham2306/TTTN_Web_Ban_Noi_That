import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { ENV } from '../config/env.js';

export interface AuthUserPayload {
  id: number;
  email: string;
  role: string;
  full_name?: string;
}

// Extend Express Request type
declare global {
  namespace Express {
    interface Request {
      user?: AuthUserPayload;
    }
  }
}

/**
 * Middleware xác thực JSON Web Token (JWT)
 * Đọc token từ header Authorization: Bearer <token>
 */
export const verifyToken = (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      success: false,
      message: 'Yêu cầu đăng nhập để thực hiện chức năng này (Thiếu Bearer Token).',
    });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, ENV.JWT_SECRET) as AuthUserPayload;
    req.user = decoded;
    next();
  } catch (err: any) {
    if (err.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        message: 'Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại.',
        expired: true,
      });
    }
    return res.status(401).json({
      success: false,
      message: 'Mã xác thực không hợp lệ.',
    });
  }
};

/**
 * Middleware phân quyền (Role-Based Access Control - RBAC)
 */
export const requireRole = (allowedRoles: string[]) => {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'Chưa xác thực danh tính.',
      });
    }

    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        message: 'Bạn không có quyền thực hiện hành động này (Yêu cầu quyền: ' + allowedRoles.join(', ') + ').',
      });
    }

    next();
  };
};

/**
 * Middleware yêu cầu quyền Quản trị viên (Admin hoặc Seller)
 */
export const requireAdmin = requireRole(['admin', 'seller']);

/**
 * Middleware tùy chọn: Nếu có token thì giải mã, không có thì vẫn cho qua (cho các API công khai cần nhận diện user nếu đã login)
 */
export const optionalToken = (req: Request, _res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization;
  if (authHeader && authHeader.startsWith('Bearer ')) {
    const token = authHeader.split(' ')[1];
    try {
      const decoded = jwt.verify(token, ENV.JWT_SECRET) as AuthUserPayload;
      req.user = decoded;
    } catch {}
  }
  next();
};
