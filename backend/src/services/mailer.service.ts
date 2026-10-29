/**
 * Dịch vụ Mailer - Gửi email chiến dịch tiếp thị & email thông báo OTP qua SMTP
 */

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
                NỘI THẤT CAO CẤP
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
                © ${year} Nội Thất Cao Cấp. Mọi quyền được bảo lưu.
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
                NỘI THẤT CAO CẤP
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
                © ${year} Nội Thất Cao Cấp. Mọi quyền được bảo lưu.
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
    const subject = `[Nội Thất] Mã xác thực đặt lại mật khẩu: ${otp}`;
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
      // IN RÕ RÀNG RA TERMINAL TRONG CHẾ ĐỘ DEV MODE
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
}
