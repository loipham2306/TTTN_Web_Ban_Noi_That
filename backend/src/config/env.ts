import dotenv from 'dotenv';
dotenv.config();

export const ENV = {
  PORT: process.env.PORT ? parseInt(process.env.PORT, 10) : 4000,
  CORS_ORIGIN: process.env.CORS_ORIGIN || 'http://localhost:4321',
  DATABASE_URL: process.env.DATABASE_URL || '',
  GEMINI_API_KEY: process.env.GEMINI_API_KEY || '',
  JWT_SECRET: process.env.JWT_SECRET || 'enterprise_noi_that_jwt_secret_key_2026_super_secure',
};
