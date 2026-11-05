/**
 * Dịch vụ Mailer - Gửi email chiến dịch tiếp thị, OTP & xác nhận đơn hàng qua SMTP
 */

import path from 'path';
import fs from 'fs';
import nodemailer, { type Transporter } from 'nodemailer';
import { ENV } from '../config/env.js';

export interface MailOptions {
  to: string | string[];
  subject: string;
  htmlContent: string;
  campaignCode?: string;
}

export interface MailResult {
  success: boolean;
  messageId: string;
  recipientCount: number;
  deliveryTime: string;
  provider: string;
  previewUrl?: string;
}

export interface OrderMailItem {
  name: string;
  qty: number;
  price: number;
  total: number;
  sku?: string;
  image?: string | null;
}

export interface OrderMailData {
  orderCode: string;
  customerName: string;
  customerEmail: string;
  customerPhone: string;
  shippingAddress?: string | null;
  customerNote?: string | null;
  paymentMethod: string;
  paymentStatus?: string | null;
  createdAt: Date | string;
  items: OrderMailItem[];
  subtotalAmount: number;
  shippingFee: number;
  discountAmount: number;
  couponCode?: string | null;
  totalAmount: number;
}

export interface PaymentSuccessMailData {
  orderCode: string;
  customerName: string;
  customerEmail: string;
  customerPhone: string;
  shippingAddress?: string | null;
  paidAmount: number;
  paymentMethod?: string;
  paymentGateway?: string;
  referenceCode?: string;
  paidAt?: Date | string;
  items: OrderMailItem[];
  totalAmount: number;
}

const formatVND = (num: number): string => {
  return Number(num || 0).toLocaleString('vi-VN') + ' ₫';
};

const mapPaymentMethodTitle = (method: string): string => {
  switch (method) {
    case 'sepay':
      return 'Chuyển khoản VietQR tự động (SePay)';
    case 'cod':
      return 'Thanh toán khi nhận hàng (COD)';
    case 'bank':
      return 'Chuyển khoản truyền thống (Thủ công)';
    default:
      return method || 'Thanh toán khi nhận hàng (COD)';
  }
};

export class MailerService {
  private static transporter: Transporter | null = null;

  /**
   * Khởi tạo hoặc lấy Transporter Nodemailer (Singleton)
   */
  private static getTransporter(): Transporter | null {
    if (this.transporter) return this.transporter;

    if (!ENV.SMTP_USER || !ENV.SMTP_PASS) {
      return null;
    }

    try {
      this.transporter = nodemailer.createTransport({
        host: ENV.SMTP_HOST,
        port: ENV.SMTP_PORT,
        secure: Number(ENV.SMTP_PORT) === 465, // true cho port 465, false cho 587
        auth: {
          user: ENV.SMTP_USER,
          pass: ENV.SMTP_PASS,
        },
        tls: {
          rejectUnauthorized: false,
        },
      });
      return this.transporter;
    } catch (err) {
      console.error('❌ Lỗi khởi tạo SMTP Transporter:', err);
      return null;
    }
  }

  /**
   * Xác định đường dẫn file Logo KTUFA thực tế trên máy chủ để đính kèm CID
   */
  private static getLogoAttachment(): { filename: string; path: string; cid: string } | null {
    const candidates = [
      path.join(process.cwd(), 'assets', 'logo.jpg'),
      path.join(process.cwd(), '..', 'frontend', 'public', 'images', 'logo1.jpg'),
      path.join(process.cwd(), 'public', 'images', 'logo1.jpg'),
      path.join(process.cwd(), 'frontend', 'public', 'images', 'logo1.jpg'),
    ];

    for (const filePath of candidates) {
      if (fs.existsSync(filePath)) {
        return {
          filename: 'logo-ktufa.jpg',
          path: filePath,
          cid: 'brand-logo',
        };
      }
    }
    return null;
  }

  /**
   * Phân tích và tìm đường dẫn file ảnh sản phẩm cục bộ trên máy chủ để đính kèm CID
   * Hỗ trợ ảnh lưu tại backend/uploads hoặc frontend/public/uploads
   * Trả về đường dẫn file tuyệt đối nếu tồn tại trên ổ cứng, hoặc null nếu là ảnh online từ internet
   */
  static resolveLocalProductImagePath(imageStr?: string | null): string | null {
    if (!imageStr || typeof imageStr !== 'string') return null;
    const str = imageStr.trim();
    if (!str) return null;

    // Nếu là URL online hợp lệ từ internet (không chứa localhost hoặc 127.0.0.1) -> Để email client tự tải
    const isExternalOnlineUrl =
      (str.startsWith('http://') || str.startsWith('https://')) &&
      !str.includes('localhost') &&
      !str.includes('127.0.0.1');
    if (isExternalOnlineUrl) {
      return null;
    }

    // Nếu đã là đường dẫn tuyệt đối hợp lệ trên ổ cứng
    if (path.isAbsolute(str) && fs.existsSync(str) && fs.statSync(str).isFile()) {
      return str;
    }

    // Tách đường dẫn tương đối (loại bỏ query params như ?v=123)
    let relativePart = str.split('?')[0];

    if (relativePart.includes('/uploads/')) {
      relativePart = relativePart.substring(relativePart.indexOf('/uploads/') + '/uploads/'.length);
    } else if (relativePart.includes('\\uploads\\')) {
      relativePart = relativePart.substring(relativePart.indexOf('\\uploads\\') + '\\uploads\\'.length);
    } else if (relativePart.startsWith('http://') || relativePart.startsWith('https://')) {
      try {
        const urlObj = new URL(relativePart);
        relativePart = urlObj.pathname.replace(/^\/+/, '');
      } catch {
        relativePart = path.basename(relativePart);
      }
    }

    relativePart = relativePart.replace(/^[/\\]+/, '');
    const filenameOnly = path.basename(relativePart);

    const candidateBaseDirs = [
      path.join(process.cwd(), 'uploads'),
      path.join(process.cwd(), 'backend', 'uploads'),
      path.join(process.cwd(), '..', 'backend', 'uploads'),
      path.join(process.cwd(), '..', 'frontend', 'public', 'uploads'),
      path.join(process.cwd(), 'frontend', 'public', 'uploads'),
      path.join(process.cwd(), 'public', 'uploads'),
      'D:\\TTTN_Web_Ban_Noi_That\\backend\\uploads',
      'D:\\TTTN_Web_Ban_Noi_That\\frontend\\public\\uploads',
    ];

    for (const baseDir of candidateBaseDirs) {
      // 1. Thử với relativePart đầy đủ (giữ cả thư mục con ví dụ banners/xyz.jpg)
      const fullRelativePath = path.join(baseDir, relativePart);
      if (fs.existsSync(fullRelativePath) && fs.statSync(fullRelativePath).isFile()) {
        return fullRelativePath;
      }

      // 2. Thử với tên file thuần túy
      const fullFileNamePath = path.join(baseDir, filenameOnly);
      if (fs.existsSync(fullFileNamePath) && fs.statSync(fullFileNamePath).isFile()) {
        return fullFileNamePath;
      }
    }

    return null;
  }

  /**
   * Tạo khung template email HTML phong cách thương hiệu Nội Thất sang trọng
   */
  static formatHtmlTemplate(subject: string, bodyContent: string, campaignCode?: string): string {
    const year = new Date().getFullYear();
    const formattedParagraphs = bodyContent
      .split('\n')
      .filter((p) => p.trim().length > 0)
      .map((p) => `<p style="margin: 0 0 16px 0; font-size: 14px; line-height: 1.7; color: #2C241E;">${p}</p>`)
      .join('');

    return `
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${subject}</title>
</head>
<body style="margin: 0; padding: 0; background-color: #F7F5F0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #2C241E;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #F7F5F0; padding: 40px 15px;">
    <tr>
      <td align="center">
        <!-- Main Card -->
        <table width="600" cellpadding="0" cellspacing="0" style="background-color: #FFFFFF; border: 1px solid rgba(44, 36, 30, 0.12); box-shadow: 0 8px 30px rgba(0,0,0,0.06); max-width: 600px; width: 100%;">
          
          <!-- Header Gold Bar -->
          <tr>
            <td style="height: 4px; background: linear-gradient(90deg, #D8B670 0%, #F3E5AB 50%, #C49E52 100%);"></td>
          </tr>

          <!-- Brand Header -->
          <tr>
            <td style="background-color: #173524; padding: 28px 36px; text-align: center;">
              <h1 style="margin: 0; color: #E6CA85; font-size: 20px; font-weight: 700; letter-spacing: 0.2em; text-transform: uppercase;">
                KTUFA LUXURY FURNITURE
              </h1>
              <p style="margin: 6px 0 0 0; color: rgba(255,255,255,0.7); font-size: 11px; letter-spacing: 0.15em; text-transform: uppercase;">
                Kiến Tạo Không Gian Sống Tinh Hoa
              </p>
            </td>
          </tr>

          <!-- Email Subject Banner -->
          <tr>
            <td style="padding: 32px 36px 16px 36px; border-bottom: 1px solid #ECE7DE;">
              ${campaignCode ? `<span style="display: inline-block; background-color: #F1ECE1; color: #7B341E; font-size: 10px; font-weight: 700; padding: 3px 8px; text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 10px;">${campaignCode}</span>` : ''}
              <h2 style="margin: 0; color: #173524; font-size: 20px; font-weight: 700; line-height: 1.4;">
                ${subject}
              </h2>
            </td>
          </tr>

          <!-- Email Body Content -->
          <tr>
            <td style="padding: 28px 36px;">
              ${formattedParagraphs}
              
              <!-- Call to Action Button -->
              <div style="margin-top: 32px; text-align: center;">
                <a href="${ENV.CORS_ORIGIN}/san-pham" style="display: inline-block; background: linear-gradient(90deg, #D8B670 0%, #C49E52 100%); color: #173524; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.15em; padding: 14px 28px; text-decoration: none; border-radius: 2px;">
                  Khám Phá Bộ Sưu Tập Ngay
                </a>
              </div>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="background-color: #FAF8F5; padding: 24px 36px; border-top: 1px solid #ECE7DE; text-align: center;">
              <p style="margin: 0 0 8px 0; font-size: 11px; color: #6E6259;">
                Bạn nhận được email này vì đã đăng ký tài khoản tại Cửa hàng Nội Thất.
              </p>
              <p style="margin: 0; font-size: 10px; color: #9B9188;">
                © ${year} KTUFA Luxury Furniture. Mọi quyền được bảo lưu.
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
    `;
  }

  /**
   * Tạo template HTML riêng biệt cho email gửi mã OTP đặt lại mật khẩu
   */
  static formatOtpTemplate(otp: string, recipientName?: string): string {
    const year = new Date().getFullYear();
    const displayName = recipientName ? `Quý khách <strong>${recipientName}</strong>` : 'Quý khách';

    return `
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mã xác thực đặt lại mật khẩu</title>
</head>
<body style="margin: 0; padding: 0; background-color: #F7F5F0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #2C241E;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #F7F5F0; padding: 40px 15px;">
    <tr>
      <td align="center">
        <table width="600" cellpadding="0" cellspacing="0" style="background-color: #FFFFFF; border: 1px solid rgba(44, 36, 30, 0.12); box-shadow: 0 8px 30px rgba(0,0,0,0.06); max-width: 600px; width: 100%; border-radius: 4px; overflow: hidden;">
          
          <!-- Header Gold Bar -->
          <tr>
            <td style="height: 4px; background: linear-gradient(90deg, #D8B670 0%, #F3E5AB 50%, #C49E52 100%);"></td>
          </tr>

          <!-- Brand Header -->
          <tr>
            <td style="background-color: #173524; padding: 26px 36px; text-align: center;">
              <h1 style="margin: 0; color: #E6CA85; font-size: 18px; font-weight: 700; letter-spacing: 0.2em; text-transform: uppercase;">
                KTUFA LUXURY FURNITURE
              </h1>
              <p style="margin: 6px 0 0 0; color: rgba(255,255,255,0.7); font-size: 10px; letter-spacing: 0.15em; text-transform: uppercase;">
                Hệ Thống Bảo Mật & Xác Thực Khách Hàng
              </p>
            </td>
          </tr>

          <!-- Body Content -->
          <tr>
            <td style="padding: 36px 36px 28px 36px;">
              <h2 style="margin: 0 0 16px 0; color: #173524; font-size: 19px; font-weight: 700;">
                Yêu cầu đặt lại mật khẩu tài khoản
              </h2>

              <p style="margin: 0 0 16px 0; font-size: 14px; line-height: 1.7; color: #2C241E;">
                Kính chào ${displayName},
              </p>
              <p style="margin: 0 0 20px 0; font-size: 14px; line-height: 1.7; color: #2C241E;">
                Hệ thống Nội Thất nhận được yêu cầu đặt lại mật khẩu cho tài khoản của Quý khách. Vui lòng sử dụng mã xác thực OTP 6 chữ số dưới đây để tiếp tục quy trình:
              </p>

              <!-- OTP Code Display Box -->
              <div style="background-color: #FAF8F5; border: 2px dashed #C49E52; border-radius: 6px; padding: 24px; text-align: center; margin: 26px 0;">
                <span style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.15em; color: #7B341E; font-weight: 700; display: block; margin-bottom: 8px;">
                  MÃ XÁC THỰC OTP CỦA BẠN
                </span>
                <div style="font-family: 'Courier New', Courier, monospace; font-size: 38px; font-weight: 800; letter-spacing: 0.35em; color: #173524; text-indent: 0.35em;">
                  ${otp}
                </div>
                <p style="margin: 10px 0 0 0; font-size: 12px; color: #8C7E72;">
                  ⏱️ Mã có hiệu lực trong vòng <strong>5 phút</strong>
                </p>
              </div>

              <!-- Warning Alert -->
              <div style="background-color: #FEF7F5; border-left: 4px solid #C05621; padding: 14px 18px; margin: 24px 0; border-radius: 2px;">
                <p style="margin: 0; font-size: 12.5px; line-height: 1.6; color: #7B341E;">
                  <strong>⚠️ Cảnh báo bảo mật:</strong> Tuyệt đối KHÔNG chia sẻ mã OTP này cho bất kỳ ai, kể cả nhân viên Nội Thất. Chúng tôi sẽ không bao giờ yêu cầu mã này qua điện thoại.
                </p>
              </div>

              <p style="margin: 0 0 8px 0; font-size: 13px; line-height: 1.7; color: #6E6259;">
                Nếu Quý khách không thực hiện yêu cầu này, vui lòng bỏ qua email. Mật khẩu hiện tại của bạn vẫn được bảo vệ an toàn tuyệt đối.
              </p>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="background-color: #FAF8F5; padding: 20px 36px; border-top: 1px solid #ECE7DE; text-align: center;">
              <p style="margin: 0 0 6px 0; font-size: 11px; color: #6E6259;">
                Hệ thống gửi thư tự động từ Website Nội Thất. Vui lòng không trả lời email này.
              </p>
              <p style="margin: 0; font-size: 10px; color: #9B9188;">
                © ${year} KTUFA Luxury Furniture. Mọi quyền được bảo lưu.
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
    `;
  }

  /**
   * Tạo template HTML cho Email Xác nhận Đặt hàng (Phong cách Tinh gọn - Minimalist Luxury)
   */
  static formatOrderConfirmationTemplate(data: OrderMailData, hasEmbeddedLogo: boolean = false): string {
    const year = new Date().getFullYear();

    const productRows = data.items
      .map((item, index) => {
        const itemImageHtml = item.image
          ? `<img src="${item.image}" alt="${item.name}" width="52" height="52" style="width: 52px; height: 52px; object-fit: cover; border-radius: 4px; border: 1px solid #ECE7DE; display: block;" />`
          : `<div style="width: 52px; height: 52px; background-color: #EDE8DE; border-radius: 4px; border: 1px solid #DFD9CE; text-align: center; line-height: 52px; color: #7B6E65; font-size: 20px;">🛋️</div>`;

        return `
        <tr style="border-bottom: 1px solid #F1ECE1; background-color: ${index % 2 === 0 ? '#FFFFFF' : '#FAFAFA'};">
          <td style="padding: 10px 12px; vertical-align: middle;">
            <table cellpadding="0" cellspacing="0" border="0" style="width: 100%;">
              <tr>
                <td style="width: 58px; vertical-align: middle;">
                  ${itemImageHtml}
                </td>
                <td style="vertical-align: middle; padding-left: 8px;">
                  <div style="font-size: 13.5px; font-weight: 700; color: #173524; line-height: 1.35;">${item.name}</div>
                </td>
              </tr>
            </table>
          </td>
          <td style="padding: 10px 8px; text-align: center; vertical-align: middle; font-size: 13px; font-weight: 600; color: #6E6259; white-space: nowrap;">
            x${item.qty}
          </td>
          <td style="padding: 10px 12px; text-align: right; vertical-align: middle; font-size: 13.5px; font-weight: 700; color: #173524; white-space: nowrap;">
            ${formatVND(item.total)}
          </td>
        </tr>`;
      })
      .join('');

    return `
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Xác nhận đơn hàng #${data.orderCode}</title>
</head>
<body style="margin: 0; padding: 0; background-color: #F7F5F0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #2C241E;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #F7F5F0; padding: 24px 10px;">
    <tr>
      <td align="center">
        <!-- Main Card -->
        <table width="600" cellpadding="0" cellspacing="0" style="background-color: #FFFFFF; border: 1px solid rgba(44, 36, 30, 0.1); box-shadow: 0 6px 24px rgba(0,0,0,0.05); max-width: 600px; width: 100%; border-radius: 6px; overflow: hidden;">
          
          <!-- Thanh viền vàng Gold -->
          <tr>
            <td style="height: 4px; background: linear-gradient(90deg, #D8B670 0%, #F3E5AB 50%, #C49E52 100%);"></td>
          </tr>

          <!-- Header Logo KTUFA -->
          <tr>
            <td style="background-color: #173524; padding: 18px 24px; text-align: center;">
              ${
                hasEmbeddedLogo
                  ? `<img src="cid:brand-logo" alt="KTUFA Logo" style="max-height: 44px; width: auto; object-fit: contain; margin-bottom: 4px; display: inline-block;" />`
                  : `<div style="font-size: 22px; line-height: 1; margin-bottom: 2px;">🏛️</div>`
              }
              <div style="color: #E6CA85; font-size: 16px; font-weight: 800; letter-spacing: 0.2em; text-transform: uppercase;">
                KTUFA LUXURY FURNITURE
              </div>
            </td>
          </tr>

          <!-- Tiêu đề & Lời chào ngắn gọn -->
          <tr>
            <td style="padding: 24px 28px 16px 28px;">
              <div style="font-size: 18px; font-weight: 800; color: #173524; text-transform: uppercase; letter-spacing: 0.05em;">
                Đặt hàng thành công • <span style="color: #B45309;">#${data.orderCode}</span>
              </div>
              <p style="margin: 6px 0 0 0; font-size: 13.5px; color: #5C5046; line-height: 1.5;">
                Chào <strong>${data.customerName}</strong>, KTUFA đã tiếp nhận đơn hàng của bạn và đang chuẩn bị giao sớm nhất.
              </p>
            </td>
          </tr>

          <!-- Bảng sản phẩm tinh giản -->
          <tr>
            <td style="padding: 0 28px 16px 28px;">
              <table width="100%" cellpadding="0" cellspacing="0" style="border-collapse: collapse; border: 1px solid #ECE7DE; border-radius: 4px; overflow: hidden;">
                <thead>
                  <tr style="background-color: #F8F6F2; border-bottom: 1.5px solid #D8B670;">
                    <th style="padding: 9px 12px; text-align: left; font-size: 11px; text-transform: uppercase; letter-spacing: 0.08em; color: #173524;">Sản phẩm</th>
                    <th style="padding: 9px 8px; text-align: center; font-size: 11px; text-transform: uppercase; letter-spacing: 0.08em; color: #173524; width: 14%;">SL</th>
                    <th style="padding: 9px 12px; text-align: right; font-size: 11px; text-transform: uppercase; letter-spacing: 0.08em; color: #173524; width: 28%;">Thành tiền</th>
                  </tr>
                </thead>
                <tbody>
                  ${productRows}
                </tbody>
              </table>
            </td>
          </tr>

          <!-- 1. KHỐI GIAO NHẬN & PHƯƠNG THỨC THANH TOÁN (Mỗi phần 1 hàng ngang) -->
          <tr>
            <td style="padding: 0 28px 14px 28px;">
              <div style="background-color: #FAF8F5; border: 1px solid #ECE7DE; border-radius: 4px; padding: 14px 18px;">
                <!-- Hàng 1: Địa chỉ nhận hàng -->
                <div style="padding-bottom: 12px; border-bottom: 1px dashed #E5E0D8;">
                  <div style="font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.1em; color: #173524; margin-bottom: 4px;">
                    📍 Địa chỉ nhận hàng
                  </div>
                  <div style="font-size: 13px; color: #2C241E; line-height: 1.5;">
                    <strong>${data.customerName}</strong> • ${data.customerPhone}<br/>
                    ${data.shippingAddress || 'Nhận tại cửa hàng'}
                    ${data.customerNote ? `<div style="color: #8C7E72; font-size: 11.5px; margin-top: 3px; font-style: italic;">Ghi chú: "${data.customerNote}"</div>` : ''}
                  </div>
                </div>

                <!-- Hàng 2: Phương thức thanh toán (nằm bên dưới địa chỉ) -->
                <div style="padding-top: 10px;">
                  <div style="font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.1em; color: #173524; margin-bottom: 4px;">
                    💳 Phương thức thanh toán
                  </div>
                  <div style="font-size: 13px; color: #2C241E; line-height: 1.5;">
                    <strong>${mapPaymentMethodTitle(data.paymentMethod)}</strong>
                    <span style="font-size: 12px; color: #6E6259; margin-left: 6px;">
                      (${data.paymentStatus === 'paid' ? '<strong style="color: #059669;">Đã thanh toán</strong>' : '<strong style="color: #B45309;">Chờ xác nhận</strong>'})
                    </span>
                  </div>
                </div>
              </div>
            </td>
          </tr>

          <!-- 2. KHỐI THANH TOÁN (Nằm bên dưới phần thông tin giao hàng) -->
          <tr>
            <td style="padding: 0 28px 20px 28px;">
              <div style="background-color: #FFFFFF; border: 1px solid #ECE7DE; border-radius: 4px; padding: 14px 18px;">
                <div style="font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.1em; color: #173524; margin-bottom: 8px;">
                  💵 Chi tiết thanh toán
                </div>
                <table width="100%" cellpadding="0" cellspacing="0" style="font-size: 12.5px; line-height: 1.6;">
                  <tr>
                    <td style="color: #6E6259; padding: 2px 0;">Tạm tính tiền hàng:</td>
                    <td style="text-align: right; color: #2C241E;">${formatVND(data.subtotalAmount)}</td>
                  </tr>
                  <tr>
                    <td style="color: #6E6259; padding: 2px 0;">Phí vận chuyển:</td>
                    <td style="text-align: right; color: #059669; font-weight: 600;">
                      ${data.shippingFee === 0 ? 'Miễn phí vận chuyển' : formatVND(data.shippingFee)}
                    </td>
                  </tr>
                  ${
                    data.discountAmount > 0
                      ? `<tr>
                    <td style="color: #B45309; padding: 2px 0;">Ưu đãi giảm giá ${data.couponCode ? `(${data.couponCode})` : ''}:</td>
                    <td style="text-align: right; color: #B45309; font-weight: 700;">-${formatVND(data.discountAmount)}</td>
                  </tr>`
                      : ''
                  }
                  <tr>
                    <td colspan="2" style="border-top: 1px solid #ECE7DE; padding-top: 6px; margin-top: 4px;"></td>
                  </tr>
                  <tr>
                    <td style="font-size: 13.5px; font-weight: 800; color: #173524; text-transform: uppercase;">
                      TỔNG CỘNG THANH TOÁN:
                    </td>
                    <td style="font-size: 16px; font-weight: 800; color: #B45309; text-align: right;">
                      ${formatVND(data.totalAmount)}
                    </td>
                  </tr>
                </table>
              </div>
            </td>
          </tr>

          <!-- Nút Theo Dõi Đơn Hàng -->
          <tr>
            <td style="padding: 0 28px 24px 28px; text-align: center;">
              <a href="${ENV.CORS_ORIGIN}/tai-khoan" style="display: inline-block; background: linear-gradient(90deg, #D8B670 0%, #C49E52 100%); color: #173524; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.14em; padding: 11px 28px; text-decoration: none; border-radius: 4px;">
                Theo dõi đơn hàng
              </a>
            </td>
          </tr>

          <!-- Footer Tối Giản -->
          <tr>
            <td style="background-color: #F8F6F2; padding: 14px 24px; border-top: 1px solid #ECE7DE; text-align: center; font-size: 11px; color: #7B6E65;">
              <div>Hotline VIP: <strong>1900 636 884</strong> • Showroom: <strong>615 Âu Cơ, TP. HCM</strong></div>
              <div style="font-size: 10px; color: #9B9188; margin-top: 3px;">© ${year} KTUFA Luxury Furniture. Cam kết 100% chính hãng, bảo hành 24 tháng.</div>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
    `;
  }

  /**
   * Tạo template HTML cho Email Xác nhận Thanh toán Thành công (Phong cách Tinh gọn)
   */
  static formatPaymentSuccessTemplate(data: PaymentSuccessMailData, hasEmbeddedLogo: boolean = false): string {
    const year = new Date().getFullYear();
    const paidTime = data.paidAt
      ? new Date(data.paidAt).toLocaleString('vi-VN', { timeZone: 'Asia/Ho_Chi_Minh', hour: '2-digit', minute: '2-digit', day: '2-digit', month: '2-digit', year: 'numeric' })
      : new Date().toLocaleString('vi-VN', { timeZone: 'Asia/Ho_Chi_Minh' });

    const productRows = data.items
      .map((item, index) => {
        const itemImageHtml = item.image
          ? `<img src="${item.image}" alt="${item.name}" width="48" height="48" style="width: 48px; height: 48px; object-fit: cover; border-radius: 4px; border: 1px solid #ECE7DE; display: block;" />`
          : `<div style="width: 48px; height: 48px; background-color: #EDE8DE; border-radius: 4px; border: 1px solid #DFD9CE; text-align: center; line-height: 48px; color: #7B6E65; font-size: 18px;">🛋️</div>`;

        return `
        <tr style="border-bottom: 1px solid #F1ECE1; background-color: ${index % 2 === 0 ? '#FFFFFF' : '#FAFAFA'};">
          <td style="padding: 8px 12px; vertical-align: middle;">
            <table cellpadding="0" cellspacing="0" border="0" style="width: 100%;">
              <tr>
                <td style="width: 54px; vertical-align: middle;">
                  ${itemImageHtml}
                </td>
                <td style="vertical-align: middle; padding-left: 8px;">
                  <div style="font-size: 13px; font-weight: 700; color: #173524;">${item.name}</div>
                </td>
              </tr>
            </table>
          </td>
          <td style="padding: 8px; text-align: center; vertical-align: middle; font-size: 12.5px; color: #6E6259;">
            x${item.qty}
          </td>
          <td style="padding: 8px 12px; text-align: right; vertical-align: middle; font-size: 13px; font-weight: 700; color: #173524;">
            ${formatVND(item.total)}
          </td>
        </tr>`;
      })
      .join('');

    return `
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Xác nhận thanh toán thành công #${data.orderCode}</title>
</head>
<body style="margin: 0; padding: 0; background-color: #F7F5F0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #2C241E;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #F7F5F0; padding: 24px 10px;">
    <tr>
      <td align="center">
        <!-- Main Card -->
        <table width="600" cellpadding="0" cellspacing="0" style="background-color: #FFFFFF; border: 1px solid rgba(44, 36, 30, 0.1); box-shadow: 0 6px 24px rgba(0,0,0,0.05); max-width: 600px; width: 100%; border-radius: 6px; overflow: hidden;">
          
          <!-- Thanh viền vàng Gold -->
          <tr>
            <td style="height: 4px; background: linear-gradient(90deg, #D8B670 0%, #F3E5AB 50%, #C49E52 100%);"></td>
          </tr>

          <!-- Header Logo KTUFA -->
          <tr>
            <td style="background-color: #173524; padding: 18px 24px; text-align: center;">
              ${
                hasEmbeddedLogo
                  ? `<img src="cid:brand-logo" alt="KTUFA Logo" style="max-height: 44px; width: auto; object-fit: contain; margin-bottom: 4px; display: inline-block;" />`
                  : `<div style="font-size: 22px; line-height: 1; margin-bottom: 2px;">🏛️</div>`
              }
              <div style="color: #E6CA85; font-size: 16px; font-weight: 800; letter-spacing: 0.2em; text-transform: uppercase;">
                KTUFA LUXURY FURNITURE
              </div>
            </td>
          </tr>

          <!-- Banner Thanh toán Thành Công Gọn Gàng -->
          <tr>
            <td style="padding: 20px 28px 12px 28px;">
              <div style="background-color: #ECFDF5; border: 1px solid #10B981; border-radius: 6px; padding: 12px 18px; text-align: center;">
                <div style="color: #065F46; font-size: 14px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.08em;">
                  ✅ ĐÃ THANH TOÁN THÀNH CÔNG • #${data.orderCode}
                </div>
                <div style="color: #047857; font-size: 13px; margin-top: 4px;">
                  Đã nhận đủ <strong>${formatVND(data.paidAmount)}</strong> qua ${data.paymentGateway || 'VietQR SePay'}.
                </div>
              </div>
              <p style="margin: 12px 0 0 0; font-size: 13.5px; color: #5C5046; line-height: 1.5;">
                Chào <strong>${data.customerName}</strong>, đơn hàng đã được xác nhận thanh toán và đang chuyển sang khâu đóng gói vận chuyển.
              </p>
            </td>
          </tr>

          <!-- Bảng sản phẩm -->
          <tr>
            <td style="padding: 0 28px 16px 28px;">
              <table width="100%" cellpadding="0" cellspacing="0" style="border-collapse: collapse; border: 1px solid #ECE7DE; border-radius: 4px; overflow: hidden;">
                <tbody>
                  ${productRows}
                </tbody>
              </table>
            </td>
          </tr>

          <!-- 1. KHỐI GIAO NHẬN & CỔNG THANH TOÁN (Mỗi phần 1 hàng ngang) -->
          <tr>
            <td style="padding: 0 28px 14px 28px;">
              <div style="background-color: #FAF8F5; border: 1px solid #ECE7DE; border-radius: 4px; padding: 14px 18px;">
                <!-- Hàng 1: Địa chỉ nhận hàng -->
                <div style="padding-bottom: 12px; border-bottom: 1px dashed #E5E0D8;">
                  <div style="font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.1em; color: #173524; margin-bottom: 4px;">
                    📍 Địa chỉ nhận hàng
                  </div>
                  <div style="font-size: 13px; color: #2C241E; line-height: 1.5;">
                    <strong>${data.customerName}</strong> • ${data.customerPhone}<br/>
                    ${data.shippingAddress || 'Nhận tại cửa hàng'}
                  </div>
                </div>

                <!-- Hàng 2: Cổng thanh toán (bên dưới địa chỉ) -->
                <div style="padding-top: 10px;">
                  <div style="font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.1em; color: #173524; margin-bottom: 4px;">
                    💳 Cổng thanh toán
                  </div>
                  <div style="font-size: 13px; color: #2C241E; line-height: 1.5;">
                    <strong>${data.paymentGateway || 'Chuyển khoản VietQR (SePay)'}</strong>
                    <span style="font-size: 12px; color: #059669; font-weight: 700; margin-left: 6px;">
                      (Đã thanh toán 100%)
                    </span>
                  </div>
                </div>
              </div>
            </td>
          </tr>

          <!-- 2. KHỐI CHI TIẾT GIAO DỊCH & SỐ TIỀN (Nằm bên dưới) -->
          <tr>
            <td style="padding: 0 28px 20px 28px;">
              <div style="background-color: #FFFFFF; border: 1px solid #ECE7DE; border-radius: 4px; padding: 14px 18px;">
                <div style="font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.1em; color: #173524; margin-bottom: 8px;">
                  🏦 Chi tiết giao dịch thanh toán
                </div>
                <table width="100%" cellpadding="0" cellspacing="0" style="font-size: 12.5px; line-height: 1.6;">
                  <tr>
                    <td style="color: #6E6259; padding: 2px 0;">Thời gian ghi nhận:</td>
                    <td style="text-align: right; color: #2C241E;">${paidTime}</td>
                  </tr>
                  ${
                    data.referenceCode
                      ? `<tr>
                    <td style="color: #6E6259; padding: 2px 0;">Mã tham chiếu ngân hàng:</td>
                    <td style="text-align: right; font-family: monospace; color: #173524;">${data.referenceCode}</td>
                  </tr>`
                      : ''
                  }
                  <tr>
                    <td colspan="2" style="border-top: 1px solid #ECE7DE; padding-top: 6px; margin-top: 4px;"></td>
                  </tr>
                  <tr>
                    <td style="font-size: 13.5px; font-weight: 800; color: #173524; text-transform: uppercase;">
                      SỐ TIỀN ĐÃ THANH TOÁN:
                    </td>
                    <td style="font-size: 16px; font-weight: 800; color: #059669; text-align: right;">
                      ${formatVND(data.paidAmount)}
                    </td>
                  </tr>
                </table>
              </div>
            </td>
          </tr>

          <!-- Nút Theo Dõi Đơn Hàng -->
          <tr>
            <td style="padding: 0 28px 22px 28px; text-align: center;">
              <a href="${ENV.CORS_ORIGIN}/tai-khoan" style="display: inline-block; background: linear-gradient(90deg, #D8B670 0%, #C49E52 100%); color: #173524; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.14em; padding: 11px 28px; text-decoration: none; border-radius: 4px;">
                Xem tình trạng đơn hàng
              </a>
            </td>
          </tr>

          <!-- Footer Tối Giản -->
          <tr>
            <td style="background-color: #F8F6F2; padding: 12px 24px; border-top: 1px solid #ECE7DE; text-align: center; font-size: 11px; color: #7B6E65;">
              Showroom: <strong>615 Âu Cơ, TP. HCM</strong> • Hotline: <strong>1900 636 884</strong> • © ${year} KTUFA
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
    `;
  }

  /**
   * Phát hành email chiến dịch hoặc email thử nghiệm (Duy trì tương thích 100% với campaigns.route.ts)
   */
  static async sendMail(options: MailOptions): Promise<MailResult> {
    const recipients = Array.isArray(options.to) ? options.to : [options.to];
    const messageId = `msg_${Date.now()}_${Math.random().toString(36).substring(2, 9)}`;
    const deliveryTime = new Date().toLocaleString('vi-VN');

    // Khởi tạo HTML thương hiệu hoàn chỉnh
    const htmlEmail = this.formatHtmlTemplate(options.subject, options.htmlContent, options.campaignCode);

    const transporter = this.getTransporter();
    const isDevMode = ENV.OTP_DEV_MODE || !transporter;

    if (!isDevMode && transporter) {
      try {
        const info = await transporter.sendMail({
          from: ENV.SMTP_FROM,
          to: recipients.join(', '),
          subject: options.subject,
          html: htmlEmail,
        });

        console.log(`✉️ [MAILER SERVICE] Đã gửi email thực tế thành công qua SMTP: "${options.subject}" -> ${recipients.join(', ')} (ID: ${info.messageId})`);

        return {
          success: true,
          messageId: info.messageId || messageId,
          recipientCount: recipients.length,
          deliveryTime,
          provider: `Nodemailer SMTP (${ENV.SMTP_HOST})`,
          previewUrl: `http://localhost:4000/api/campaigns/preview/${messageId}`,
        };
      } catch (err: any) {
        console.error('❌ [MAILER SERVICE] Lỗi khi gửi mail qua SMTP:', err.message);
        throw new Error(`Lỗi máy chủ khi gửi email qua SMTP: ${err.message}`);
      }
    } else {
      // Chế độ DEV MODE
      console.log(`✉️ [MAILER SERVICE - DEV MODE] Phát hành email: "${options.subject}"`);
      console.log(`   - Người nhận: ${recipients.join(', ')}`);
      console.log(`   - Mã chiến dịch: ${options.campaignCode || 'N/A'}`);
      console.log(`   - Trạng thái: ✅ Simulated Delivered (Chế độ Thử Nghiệm)`);

      return {
        success: true,
        messageId,
        recipientCount: recipients.length,
        deliveryTime,
        provider: 'Nội Thất Smart Mailer (DEV MODE / SMTP Local)',
        previewUrl: `http://localhost:4000/api/campaigns/preview/${messageId}`,
      };
    }
  }

  /**
   * Gửi email mã OTP xác thực đặt lại mật khẩu
   */
  static async sendOtpMail(toEmail: string, otp: string, recipientName?: string): Promise<{ success: boolean; messageId: string }> {
    const subject = `[KTUFA] Mã xác thực đặt lại mật khẩu: ${otp}`;
    const html = this.formatOtpTemplate(otp, recipientName);
    const messageId = `otp_${Date.now()}_${Math.random().toString(36).substring(2, 8)}`;

    const transporter = this.getTransporter();
    const isDevMode = ENV.OTP_DEV_MODE || !transporter;

    if (!isDevMode && transporter) {
      try {
        const info = await transporter.sendMail({
          from: ENV.SMTP_FROM,
          to: toEmail,
          subject,
          html,
        });

        console.log(`✅ [MAILER SERVICE] Đã gửi mã OTP thực tế tới email ${toEmail} qua SMTP (MessageID: ${info.messageId})`);
        return { success: true, messageId: info.messageId || messageId };
      } catch (err: any) {
        console.error(`❌ [MAILER SERVICE] Lỗi gửi email OTP tới ${toEmail}:`, err.message);
        throw new Error('Không thể gửi email OTP qua máy chủ thư. Vui lòng kiểm tra lại cấu hình SMTP.');
      }
    } else {
      console.log('\n================================================================================');
      console.log(`📢 [MAILER SERVICE - DEV MODE] YÊU CẦU ĐẶT LẠI MẬT KHẨU`);
      console.log(`📧 Gửi tới: ${toEmail} (${recipientName || 'Khách hàng'})`);
      console.log(`🔑 MÃ XÁC THỰC OTP 6 SỐ: [  ${otp}  ]`);
      console.log(`⏱️ Thời hạn: 5 phút kể từ lúc gửi`);
      console.log(`💡 Lưu ý: Hệ thống đang ở chế độ DEV MODE (chưa có mật khẩu ứng dụng Gmail hoặc OTP_DEV_MODE=true)`);
      console.log('================================================================================\n');

      return { success: true, messageId };
    }
  }

  /**
   * Gửi email Xác nhận Đặt hàng (Đính kèm Logo CID & Ảnh Sản phẩm)
   */
  static async sendOrderConfirmationMail(orderData: OrderMailData): Promise<MailResult> {
    const recipientEmail = orderData.customerEmail;
    if (!recipientEmail || !recipientEmail.includes('@')) {
      console.warn(`[MAILER SERVICE] Không thể gửi email đơn hàng #${orderData.orderCode}: Email không hợp lệ (${recipientEmail})`);
      return {
        success: false,
        messageId: '',
        recipientCount: 0,
        deliveryTime: new Date().toLocaleString('vi-VN'),
        provider: 'N/A',
      };
    }

    const subject = `[Nội Thất KTUFA] Xác nhận đặt hàng thành công - Đơn hàng #${orderData.orderCode}`;
    const logoAttachment = this.getLogoAttachment();
    const hasLogo = Boolean(logoAttachment);

    // Chuẩn bị danh sách tệp đính kèm CID
    const mailAttachments: any[] = [];
    if (logoAttachment) {
      mailAttachments.push(logoAttachment);
    }

    // Xử lý đính kèm CID cho từng ảnh sản phẩm lưu cục bộ (uploads/)
    const fileToCidMap = new Map<string, string>();
    let imgCounter = 0;

    const processedItems: OrderMailItem[] = (orderData.items || []).map((item) => {
      const localPath = this.resolveLocalProductImagePath(item.image);
      if (localPath) {
        let cid = fileToCidMap.get(localPath);
        if (!cid) {
          cid = `order-prod-img-${imgCounter++}`;
          fileToCidMap.set(localPath, cid);
          mailAttachments.push({
            filename: path.basename(localPath),
            path: localPath,
            cid: cid,
            contentDisposition: 'inline',
          });
        }
        return {
          ...item,
          image: `cid:${cid}`,
        };
      }
      return item;
    });

    const processedOrderData: OrderMailData = {
      ...orderData,
      items: processedItems,
    };

    const html = this.formatOrderConfirmationTemplate(processedOrderData, hasLogo);
    const messageId = `order_${orderData.orderCode}_${Date.now()}`;
    const deliveryTime = new Date().toLocaleString('vi-VN');

    const transporter = this.getTransporter();
    const isDevMode = ENV.OTP_DEV_MODE || !transporter;

    if (!isDevMode && transporter) {
      try {
        const info = await transporter.sendMail({
          from: ENV.SMTP_FROM,
          to: recipientEmail,
          subject,
          html,
          attachments: mailAttachments,
        });

        console.log(`✉️ [MAILER SERVICE] Đã gửi email xác nhận đơn hàng #${orderData.orderCode} tới ${recipientEmail} qua SMTP (ID: ${info.messageId}, Đính kèm CID: ${mailAttachments.length})`);

        return {
          success: true,
          messageId: info.messageId || messageId,
          recipientCount: 1,
          deliveryTime,
          provider: `Nodemailer SMTP (${ENV.SMTP_HOST})`,
        };
      } catch (err: any) {
        console.error(`❌ [MAILER SERVICE] Lỗi gửi email xác nhận đơn hàng #${orderData.orderCode}:`, err.message);
        return {
          success: false,
          messageId,
          recipientCount: 0,
          deliveryTime,
          provider: 'SMTP Error',
        };
      }
    } else {
      // DEV MODE: Log trực quan ra terminal
      console.log('\n================================================================================');
      console.log(`📦 [MAILER SERVICE - DEV MODE] XÁC NHẬN ĐƠN HÀNG THÀNH CÔNG`);
      console.log(`📧 Gửi tới: ${recipientEmail} (Khách hàng: ${orderData.customerName})`);
      console.log(`🏷️ MÃ ĐƠN HÀNG: #${orderData.orderCode}`);
      console.log(`💵 Tổng thanh toán: ${formatVND(orderData.totalAmount)} (${mapPaymentMethodTitle(orderData.paymentMethod)})`);
      console.log(`📍 Địa chỉ giao hàng: ${orderData.shippingAddress}`);
      console.log(`🛋️ Số lượng sản phẩm: ${processedOrderData.items.length} mặt hàng:`);
      processedOrderData.items.forEach((item, idx) => {
        console.log(`   ${idx + 1}. ${item.name} (x${item.qty}) -> ${formatVND(item.total)} | Ảnh: ${item.image || 'N/A'}`);
      });
      console.log(`🖼️ Đính kèm Logo KTUFA: ${hasLogo ? '✅ Có file logo CID' : '⚠️ Dùng chữ thương hiệu'}`);
      console.log(`📎 Tổng số file đính kèm CID: ${mailAttachments.length}`);
      console.log(`💡 Chế độ: DEV MODE (Điền SMTP_USER & SMTP_PASS vào backend/.env để gửi thư thật tới Gmail)`);
      console.log('================================================================================\n');

      return {
        success: true,
        messageId,
        recipientCount: 1,
        deliveryTime,
        provider: 'KTUFA Smart Mailer (DEV MODE)',
      };
    }
  }

  /**
   * Gửi email Xác nhận Đã thanh toán Thành công (Đính kèm Logo CID & Ảnh Sản phẩm)
   */
  static async sendPaymentSuccessMail(paymentData: PaymentSuccessMailData): Promise<MailResult> {
    const recipientEmail = paymentData.customerEmail;
    if (!recipientEmail || !recipientEmail.includes('@')) {
      console.warn(`[MAILER SERVICE] Không thể gửi email thanh toán đơn hàng #${paymentData.orderCode}: Email không hợp lệ (${recipientEmail})`);
      return {
        success: false,
        messageId: '',
        recipientCount: 0,
        deliveryTime: new Date().toLocaleString('vi-VN'),
        provider: 'N/A',
      };
    }

    const subject = `[Nội Thất KTUFA] Xác nhận đã thanh toán thành công - Đơn hàng #${paymentData.orderCode}`;
    const logoAttachment = this.getLogoAttachment();
    const hasLogo = Boolean(logoAttachment);

    // Chuẩn bị danh sách tệp đính kèm CID
    const mailAttachments: any[] = [];
    if (logoAttachment) {
      mailAttachments.push(logoAttachment);
    }

    // Xử lý đính kèm CID cho từng ảnh sản phẩm lưu cục bộ (uploads/)
    const fileToCidMap = new Map<string, string>();
    let imgCounter = 0;

    const processedItems: OrderMailItem[] = (paymentData.items || []).map((item) => {
      const localPath = this.resolveLocalProductImagePath(item.image);
      if (localPath) {
        let cid = fileToCidMap.get(localPath);
        if (!cid) {
          cid = `pay-prod-img-${imgCounter++}`;
          fileToCidMap.set(localPath, cid);
          mailAttachments.push({
            filename: path.basename(localPath),
            path: localPath,
            cid: cid,
            contentDisposition: 'inline',
          });
        }
        return {
          ...item,
          image: `cid:${cid}`,
        };
      }
      return item;
    });

    const processedPaymentData: PaymentSuccessMailData = {
      ...paymentData,
      items: processedItems,
    };

    const html = this.formatPaymentSuccessTemplate(processedPaymentData, hasLogo);
    const messageId = `paid_${paymentData.orderCode}_${Date.now()}`;
    const deliveryTime = new Date().toLocaleString('vi-VN');

    const transporter = this.getTransporter();
    const isDevMode = ENV.OTP_DEV_MODE || !transporter;

    if (!isDevMode && transporter) {
      try {
        const info = await transporter.sendMail({
          from: ENV.SMTP_FROM,
          to: recipientEmail,
          subject,
          html,
          attachments: mailAttachments,
        });

        console.log(`💳 [MAILER SERVICE] Đã gửi email xác nhận thanh toán đơn hàng #${paymentData.orderCode} tới ${recipientEmail} qua SMTP (ID: ${info.messageId}, Đính kèm CID: ${mailAttachments.length})`);

        return {
          success: true,
          messageId: info.messageId || messageId,
          recipientCount: 1,
          deliveryTime,
          provider: `Nodemailer SMTP (${ENV.SMTP_HOST})`,
        };
      } catch (err: any) {
        console.error(`❌ [MAILER SERVICE] Lỗi gửi email xác nhận thanh toán #${paymentData.orderCode}:`, err.message);
        return {
          success: false,
          messageId,
          recipientCount: 0,
          deliveryTime,
          provider: 'SMTP Error',
        };
      }
    } else {
      // DEV MODE: Log trực quan ra terminal
      console.log('\n================================================================================');
      console.log(`💳 [MAILER SERVICE - DEV MODE] XÁC NHẬN ĐÃ THANH TOÁN THÀNH CÔNG`);
      console.log(`📧 Gửi tới: ${recipientEmail} (Khách hàng: ${paymentData.customerName})`);
      console.log(`🏷️ MÃ ĐƠN HÀNG: #${paymentData.orderCode}`);
      console.log(`💵 Số tiền thanh toán: ${formatVND(paymentData.paidAmount)}`);
      console.log(`🏦 Cổng thanh toán: ${paymentData.paymentGateway || 'VietQR SePay'}`);
      if (paymentData.referenceCode) {
        console.log(`🔢 Mã tham chiếu: ${paymentData.referenceCode}`);
      }
      console.log(`📦 Đơn hàng đang được chuẩn bị để đóng gói và vận chuyển!`);
      console.log(`🛋️ Số lượng sản phẩm: ${processedPaymentData.items.length} mặt hàng:`);
      processedPaymentData.items.forEach((item, idx) => {
        console.log(`   ${idx + 1}. ${item.name} (x${item.qty}) -> ${formatVND(item.total)} | Ảnh: ${item.image || 'N/A'}`);
      });
      console.log(`🖼️ Đính kèm Logo KTUFA: ${hasLogo ? '✅ Có file logo CID' : '⚠️ Dùng chữ thương hiệu'}`);
      console.log(`📎 Tổng số file đính kèm CID: ${mailAttachments.length}`);
      console.log(`💡 Chế độ: DEV MODE (Điền SMTP_USER & SMTP_PASS vào backend/.env để gửi thư thật tới Gmail)`);
      console.log('================================================================================\n');

      return {
        success: true,
        messageId,
        recipientCount: 1,
        deliveryTime,
        provider: 'KTUFA Smart Mailer (DEV MODE)',
      };
    }
  }
}
