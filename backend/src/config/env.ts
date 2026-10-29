import dotenv from 'dotenv';
dotenv.config();

export const ENV = {
  PORT: process.env.PORT ? parseInt(process.env.PORT, 10) : 4000,
  CORS_ORIGIN: process.env.CORS_ORIGIN || 'http://localhost:4321',
  DATABASE_URL: process.env.DATABASE_URL || '',
  GEMINI_API_KEY: process.env.GEMINI_API_KEY || '',
  JWT_SECRET: process.env.JWT_SECRET || 'enterprise_noi_that_jwt_secret_key_2026_super_secure',

  // Cấu hình SMTP gửi Email
  SMTP_HOST: process.env.SMTP_HOST || 'smtp.gmail.com',
  SMTP_PORT: process.env.SMTP_PORT ? parseInt(process.env.SMTP_PORT, 10) : 465,
  SMTP_USER: process.env.SMTP_USER || '',
  SMTP_PASS: process.env.SMTP_PASS || '',
  SMTP_FROM: process.env.SMTP_FROM || 'Nội Thất Cao Cấp <noreply@noithat.vn>',

  // Chế độ thử nghiệm OTP: nếu true hoặc chưa cấu hình SMTP thì in OTP ra console
  OTP_DEV_MODE: process.env.OTP_DEV_MODE === 'true',
};
