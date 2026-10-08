import { GoogleGenerativeAI } from '@google/generative-ai';
import { ENV } from './env.js';

/**
 * Khung cau hinh Gemini API cho tu van phong thuy
 * Chi khoi tao khi co GEMINI_API_KEY
 */
export const getGeminiModel = () => {
  if (!ENV.GEMINI_API_KEY) {
    return null;
  }
  const genAI = new GoogleGenerativeAI(ENV.GEMINI_API_KEY);
  return genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
};
