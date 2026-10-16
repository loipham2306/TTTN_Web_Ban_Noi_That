import rateLimit from 'express-rate-limit';

/**
 * Giới hạn tần suất gọi API đăng nhập / đăng ký để chống tấn công Brute-force & Credential Stuffing
 */
export const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 phút
  max: 20, // Tối đa 20 lần thử trong 15 phút từ 1 địa chỉ IP
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    success: false,
    message: 'Quá nhiều yêu cầu đăng nhập/đăng ký từ thiết bị của bạn. Vui lòng thử lại sau 15 phút.',
  },
});
