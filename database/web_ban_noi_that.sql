SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS `web_ban_noi_that` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `web_ban_noi_that`;

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 28, 2026 lúc 03:31 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `web_ban_noi_that`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `banners`
--

DROP TABLE IF EXISTS `banners`;
CREATE TABLE `banners` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image_url` text DEFAULT NULL,
  `link_url` varchar(255) DEFAULT '/san-pham',
  `button_text` varchar(100) DEFAULT 'KhĂ¡m phĂ¡ ngay',
  `position` varchar(50) NOT NULL DEFAULT 'hero',
  `display_order` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `banners`
--

INSERT INTO `banners` (`id`, `title`, `subtitle`, `description`, `image_url`, `link_url`, `button_text`, `position`, `display_order`, `is_active`, `created_at`, `updated_at`) VALUES
(2, 'BỘ SƯU TẬP NỘI THẤT', 'KHÔNG GIAN SỐNG ĐẲNG CẤP', 'Khám phá những thiết kế tinh tế, kết hợp hoàn hảo giữa công năng và thẩm mỹ, mang đến vẻ đẹp vượt thời gian cho ngôi nhà của bạn', 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1920&q=80', '/san-pham', 'Khám phá bộ sưu tập', 'san-pham', 1, 1, '2026-10-19 01:23:36', '2026-10-22 01:15:15'),
(3, 'TƯ VẤN PHONG THỦY & BÀI TRÍ NỘI THẤT', 'Ứng Dụng Trí Tuệ Nhân Tạo Gemini AI & Bát Trạch', 'Định hướng sinh khí tài lộc, phối hợp màu sắc ngũ hành và bài trí nội thất chuẩn phong thủy cho gia chủ.', 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1920&q=80', '/phong-thuy', 'Tra cứu cung mệnh ngay', 'phong-thuy', 1, 1, '2026-10-19 01:23:36', '2026-10-19 01:23:36'),
(4, 'NỘI THẤT CAO CẤP', 'BỘ SƯU TẬP 2026', 'Nội thất thiết kế cho không gian sống đẳng cấp — tuyển chọn từ những thương hiệu và xưởng chế tác hàng đầu', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1920&q=80', '/san-pham', 'Khám phá ngay', 'hero', 1, 1, '2026-10-21 23:26:22', '2026-10-22 00:52:51'),
(8, 'SOFA & KỆ TIVI', 'TÂM ĐIỂM PHÒNG KHÁCH', 'Thả mình vào sự êm ái và sang trọng. Không gian tiếp khách ấm cúng, hoàn hảo cho gia đình bạn', 'http://localhost:4000/uploads/banners/banner-1792655674009-326777258.avif', '/san-pham?khong-gian=phong-khach', 'Xem phòng khách', 'hero', 2, 1, '2026-10-22 00:54:43', '2026-10-22 01:03:08'),
(9, 'NGHỆ THUẬT NGHỈ NGƠI', 'NỘI THẤT PHÒNG NGỦ', 'Tái tạo năng lượng sau một ngày dài với bộ sưu tập phòng ngủ mang đậm dấu ấn cá nhân. Sự kết hợp hoàn hảo giữa chất liệu êm ái và thiết kế tinh tế', 'http://localhost:4000/uploads/banners/banner-1792655870396-838715317.avif', '/san-pham?khong-gian=phong-ngu', 'xem phòng ngủ', 'hero', 3, 1, '2026-10-22 00:57:52', '2026-10-22 01:00:40'),
(10, 'HÀI HÒA SINH KHÍ', 'TƯ VẤN PHONG THỦY AI', 'Ứng dụng trí tuệ nhân tạo để phân tích bản mệnh, giúp bạn dễ dàng chọn lựa màu sắc, chất liệu và hướng đặt nội thất thu hút tài lộc, bình an', 'http://localhost:4000/uploads/banners/banner-1792655948259-888496089.avif', '/phong-thuy', 'Tư vấn phong thủy', 'hero', 4, 1, '2026-10-22 00:59:09', '2026-10-22 00:59:09'),
(11, 'Phòng khách', NULL, NULL, 'http://localhost:4000/uploads/banners/banner-1792657223955-569360333.avif', '/san-pham?khong-gian=phong-khach', 'Khám phá ngay', 'space', 1, 1, '2026-10-22 01:20:26', '2026-10-22 01:20:26');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bot_prompts`
--

DROP TABLE IF EXISTS `bot_prompts`;
CREATE TABLE `bot_prompts` (
  `id` int(10) UNSIGNED NOT NULL,
  `context_key` varchar(50) NOT NULL COMMENT 'system_prompt, return_policy, etc.',
  `content` text NOT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `bot_prompts`
--

INSERT INTO `bot_prompts` (`id`, `context_key`, `content`, `is_active`) VALUES
(1, 'system_prompt', 'Bạn là trợ lý AI ảo của thương hiệu Nội thất KTUFA Luxury Furniture. Hãy tư vấn lịch sự, chuẩn phong thủy, ngắn gọn và hữu ích cho khách hàng. Xưng hô là dạ/thưa.', 1),
(2, 'shipping_policy', 'Giao hàng miễn phí nội thành cho đơn từ 2 triệu. Các tỉnh khác hỗ trợ vận chuyển chuyên nghiệp.', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
CREATE TABLE `cart_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `cart_id` bigint(20) UNSIGNED NOT NULL,
  `variant_id` bigint(20) UNSIGNED NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int(10) UNSIGNED NOT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`id`, `parent_id`, `name`, `slug`, `image_url`, `status`) VALUES
(1, NULL, 'Sofa', 'sofa', NULL, 1),
(2, NULL, 'Bàn ăn', 'ban-an', NULL, 1),
(3, NULL, 'Ghế', 'ghe', NULL, 1),
(4, NULL, 'Giường', 'giuong', NULL, 1),
(5, NULL, 'Tủ & Kệ', 'tu-ke', NULL, 1),
(6, NULL, 'Đèn', 'den', NULL, 1),
(7, NULL, 'Trang trí', 'trang-tri', NULL, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chat_messages`
--

DROP TABLE IF EXISTS `chat_messages`;
CREATE TABLE `chat_messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `session_id` bigint(20) UNSIGNED NOT NULL,
  `sender_type` enum('customer','ai_bot','seller') NOT NULL,
  `sender_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'ID cá»§a user hoáº·c seller náº¿u cĂ³',
  `content` text NOT NULL COMMENT 'Ná»™i dung tin nháº¯n',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chat_sessions`
--

DROP TABLE IF EXISTS `chat_sessions`;
CREATE TABLE `chat_sessions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `guest_id` varchar(255) DEFAULT NULL COMMENT 'Cookie/Session ID cho khĂ¡ch vĂ£ng lai',
  `status` enum('bot_handling','human_requested','human_handling','closed') DEFAULT 'bot_handling',
  `started_at` datetime DEFAULT current_timestamp(),
  `ended_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `coupons`
--

DROP TABLE IF EXISTS `coupons`;
CREATE TABLE `coupons` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(50) NOT NULL,
  `discount_type` enum('percent','fixed_amount','free_shipping') NOT NULL,
  `discount_value` decimal(15,2) NOT NULL,
  `min_order_value` decimal(15,2) DEFAULT 0.00,
  `max_discount_amount` decimal(15,2) DEFAULT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `usage_limit` int(11) DEFAULT NULL,
  `used_count` int(11) DEFAULT 0,
  `status` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `coupons`
--

INSERT INTO `coupons` (`id`, `code`, `discount_type`, `discount_value`, `min_order_value`, `max_discount_amount`, `start_date`, `end_date`, `usage_limit`, `used_count`, `status`) VALUES
(1, 'GIAM10', 'percent', 10.00, 500000.00, 500000.00, '2026-10-22 06:47:04', '2027-01-20 06:47:04', 100, 0, 1),
(2, 'NOITHAT50K', 'fixed_amount', 50000.00, 200000.00, NULL, '2026-10-22 06:47:04', '2027-01-20 06:47:04', 100, 0, 1),
(3, 'TRIAN1K', 'fixed_amount', 1000.00, 1000.00, NULL, '2026-10-22 06:47:04', '2027-01-20 06:47:04', 100, 1, 1),
(5, 'MAMOI', 'free_shipping', 50000.00, 0.00, NULL, '2026-10-22 07:15:00', '2027-01-31 00:00:00', 20, 13, 1),
(7, 'FREESHIP', 'free_shipping', 0.00, 0.00, NULL, '2026-10-22 07:30:32', '2027-01-01 00:00:00', 100, 2, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `email_campaigns`
--

DROP TABLE IF EXISTS `email_campaigns`;
CREATE TABLE `email_campaigns` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `target_audience` varchar(100) NOT NULL DEFAULT 'all',
  `recipients_count` int(11) NOT NULL DEFAULT 0,
  `action_type` varchar(50) NOT NULL DEFAULT 'send-now',
  `status` varchar(50) NOT NULL DEFAULT 'Đã hoàn tất',
  `content` text NOT NULL,
  `open_rate` decimal(5,2) NOT NULL DEFAULT 0.00,
  `click_rate` decimal(5,2) NOT NULL DEFAULT 0.00,
  `sent_count` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `email_campaigns`
--

INSERT INTO `email_campaigns` (`id`, `code`, `title`, `target_audience`, `recipients_count`, `action_type`, `status`, `content`, `open_rate`, `click_rate`, `sent_count`, `created_at`, `updated_at`) VALUES
(1, 'CAM-001', 'Chào mừng thành viên mới - Nhận ngay Voucher 10% đơn đầu tiên', 'Tất cả khách hàng', 9, 'send-now', 'Đã hoàn tất', 'Kính gửi Quý khách hàng,\n\nCảm ơn Quý khách đã đăng ký thành viên tại Cửa hàng Nội Thất. Để bắt đầu hành trình kiến tạo không gian sống mơ ước, chúng tôi xin gửi tặng Quý khách mã giảm giá 10% cho đơn hàng đầu tiên: WELCOME2026.\n\nChúc Quý khách có trải nghiệm mua sắm tuyệt vời!', 88.50, 42.00, 9, '2026-10-20 14:59:13', '2026-10-23 14:59:13'),
(2, 'CAM-002', 'Tri ân Hội viên VIP - Ra mắt Bộ sưu tập Gỗ Óc Chó Mùa Thu 2026', 'Hội viên VIP (Kim Cương / Vàng)', 2, 'send-now', 'Đã hoàn tất', 'Kính gửi Hội viên VIP,\n\nNhân dịp ra mắt bộ sưu tập nội thất cao cấp Mùa Thu 2026, Nội Thất trân trọng kính mời Quý khách trải nghiệm những tuyệt tác gỗ tự nhiên mới nhất với ưu đãi đặc quyền lên tới 20% cùng dịch vụ tư vấn thiết kế phong thủy miễn phí.\n\nTrân trọng cảm ơn sự đồng hành của Quý khách!', 95.00, 68.50, 2, '2026-10-22 14:59:13', '2026-10-23 14:59:13'),
(3, 'CAM-003', 'Khuyến mãi cuối tuần - Giảm 15% Sofa & Bàn Ăn', 'Tất cả khách hàng (9 khách)', 9, 'send-now', 'Đã hoàn tất', 'Chương trình ưu đãi giảm 15% toàn bộ sản phẩm Sofa da Ý và Bàn ăn mặt đá cao cấp duy nhất cuối tuần này.', 85.50, 38.00, 9, '2026-10-23 14:59:39', '2026-10-23 14:59:39');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_code` varchar(50) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `coupon_id` int(10) UNSIGNED DEFAULT NULL,
  `shipping_address` text NOT NULL COMMENT 'LÆ°u cá»©ng Ä‘á»‹a chá»‰ text/JSON lĂºc Ä‘áº·t',
  `shipping_fee` decimal(15,2) DEFAULT 0.00,
  `subtotal_amount` decimal(15,2) NOT NULL,
  `discount_amount` decimal(15,2) DEFAULT 0.00,
  `total_amount` decimal(15,2) NOT NULL,
  `payment_method` varchar(50) NOT NULL COMMENT 'COD, VNPay, Momo',
  `payment_status` enum('pending','paid','refunded') DEFAULT 'pending',
  `order_status` enum('pending','confirmed','shipping','completed','cancelled') DEFAULT 'pending',
  `seller_note` text DEFAULT NULL,
  `customer_note` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `orders`
--

INSERT INTO `orders` (`id`, `order_code`, `user_id`, `coupon_id`, `shipping_address`, `shipping_fee`, `subtotal_amount`, `discount_amount`, `total_amount`, `payment_method`, `payment_status`, `order_status`, `seller_note`, `customer_note`, `created_at`, `updated_at`) VALUES
(5, 'NT-2610-9661', 6, NULL, '543b tĂ¢n phĂº, r, TP. Há»“ ChĂ­ Minh', 0.00, 7500000.00, 0.00, 7500000.00, 'cod', 'pending', 'pending', NULL, NULL, '2026-10-16 04:13:03', '2026-10-22 15:15:57'),
(6, 'NT-2610-5385', 6, NULL, '110d tĂ¢n quĂ½, tĂ¢n phĂº, HCM, r, TP. Há»“ ChĂ­ Minh', 0.00, 24500000.00, 0.00, 24500000.00, 'cod', 'pending', 'pending', NULL, NULL, '2026-10-16 08:36:49', '2026-10-22 15:15:57'),
(7, 'NT-2610-3221', 7, NULL, '412, TĂ¢n PhĂº, TP. Há»“ ChĂ­ Minh', 0.00, 7500000.00, 0.00, 7500000.00, 'cod', 'pending', 'pending', NULL, NULL, '2026-10-18 13:02:12', '2026-10-18 13:02:12'),
(8, 'NT-2610-5947', 8, NULL, '123 Du?ng C?u Gi?y, C?u Gi?y, H� N?i', 0.00, 12000000.00, 0.00, 12000000.00, 'sepay', 'paid', 'confirmed', '[SePay Webhook] Thanh toán thành công 12.000.000 đ qua MBBank (Ref: REF99999) lúc 2026-10-21 11:18:00', NULL, '2026-10-21 04:19:14', '2026-10-21 11:19:14'),
(9, 'NT-2610-4932', 9, NULL, '456 Du?ng C?u Gi?y, C?u Gi?y, H� N?i', 0.00, 8500000.00, 0.00, 8500000.00, 'sepay', 'paid', 'confirmed', '[DEMO TEST] Thanh toán giả lập thành công 8.500.000 đ lúc 11:19:22 21/10/2026', NULL, '2026-10-21 04:19:22', '2026-10-21 11:19:22'),
(10, 'NT-2610-8753', 6, NULL, '765A Tp hcm, r, TP. Hồ Chí Minh', 0.00, 7500000.00, 0.00, 7500000.00, 'sepay', 'pending', 'pending', NULL, NULL, '2026-10-21 05:32:28', '2026-10-22 15:15:57'),
(11, 'NT-2610-7863', 6, NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', 0.00, 7500000.00, 0.00, 7500000.00, 'sepay', 'pending', 'pending', NULL, NULL, '2026-10-21 05:41:17', '2026-10-22 15:15:57'),
(12, 'NT-2610-5288', 6, NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', 0.00, 15000000.00, 0.00, 15000000.00, 'sepay', 'pending', 'pending', NULL, NULL, '2026-10-21 05:57:04', '2026-10-22 15:15:57'),
(13, 'NT-2610-9861', 6, NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', 0.00, 15000000.00, 0.00, 15000000.00, 'sepay', 'pending', 'pending', NULL, NULL, '2026-10-21 06:00:38', '2026-10-22 15:15:57'),
(14, 'NT-2610-1738', 6, NULL, '299 trịnh đình trọng, hòa thạnh, tân phú, TP HCM, r, TP. Hồ Chí Minh', 0.00, 7500000.00, 0.00, 7500000.00, 'sepay', 'pending', 'pending', NULL, NULL, '2026-10-21 06:05:29', '2026-10-22 15:15:57'),
(15, 'NT-2610-5475', 6, NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', 0.00, 7500000.00, 0.00, 7500000.00, 'sepay', 'pending', 'pending', NULL, NULL, '2026-10-21 06:16:28', '2026-10-22 15:15:57'),
(16, 'NT-2610-4750', 6, NULL, '543b tân phú, r, TP. Hồ Chí Minh', 0.00, 7500000.00, 0.00, 7500000.00, 'sepay', 'pending', 'pending', NULL, NULL, '2026-10-21 06:20:13', '2026-10-22 15:15:57'),
(17, 'NT-2610-7968', 6, NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', 0.00, 7500000.00, 0.00, 7500000.00, 'sepay', 'pending', 'pending', NULL, NULL, '2026-10-21 06:20:29', '2026-10-22 15:15:57'),
(18, 'NT-2610-2647', 6, NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', 50000.00, 2000.00, 0.00, 52000.00, 'sepay', 'pending', 'pending', NULL, NULL, '2026-10-22 03:50:43', '2026-10-22 15:15:57'),
(19, 'NT-2610-3033', 11, 3, '123 Phố Huế, Ba Đình, Hà Nội', 50000.00, 2000.00, 1000.00, 51000.00, 'cod', 'pending', 'pending', NULL, NULL, '2026-10-22 06:47:49', '2026-10-22 06:47:49'),
(20, 'NT-2610-6180', 6, NULL, '765A Tp hcm, r, TP. Hồ Chí Minh', 50000.00, 2000.00, 0.00, 52000.00, 'sepay', 'pending', 'pending', NULL, NULL, '2026-10-22 07:41:30', '2026-10-22 15:15:57'),
(21, 'NT-2610-9063', 6, 7, '765A Tp hcm, r, TP. Hồ Chí Minh', 0.00, 2000.00, 50000.00, 2000.00, 'sepay', 'pending', 'pending', NULL, NULL, '2026-10-22 07:41:30', '2026-10-22 15:15:57'),
(24, 'NT-2610-9964', 6, NULL, '765A Tp hcm, r, TP. Hồ Chí Minh', 50000.00, 2000.00, 0.00, 52000.00, 'sepay', 'pending', 'pending', NULL, NULL, '2026-10-22 07:44:20', '2026-10-22 15:15:57'),
(25, 'NT-2610-8735', 6, 5, '765A Tp hcm, r, TP. Hồ Chí Minh', 0.00, 2000.00, 50000.00, 2000.00, 'sepay', 'paid', 'confirmed', '[SePay Webhook] Thanh toán thành công 2.000 đ qua MBBank (Ref: FT26295755326490) lúc 2026-10-22 14:45:00', NULL, '2026-10-22 07:45:40', '2026-10-22 15:15:57'),
(26, 'NT-2610-3146', 6, 5, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', 0.00, 2000.00, 50000.00, 2000.00, 'sepay', 'paid', 'confirmed', '[SePay Webhook] Thanh toán thành công 2.000 đ qua MBBank (Ref: FT26295050733038) lúc 2026-10-22 14:52:00', NULL, '2026-10-22 07:52:04', '2026-10-22 15:15:57'),
(27, 'NT-2610-8318', 6, 5, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', 0.00, 2000.00, 50000.00, 2000.00, 'sepay', 'paid', 'confirmed', '[SePay Webhook] Thanh toán thành công 2.000 đ qua MBBank (Ref: FT26295064070640) lúc 2026-10-22 15:09:00', NULL, '2026-10-22 08:09:42', '2026-10-22 15:15:57'),
(28, 'NT-2610-2866', 6, NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', 50000.00, 2000.00, 0.00, 52000.00, 'cod', 'pending', 'pending', NULL, NULL, '2026-10-22 08:10:45', '2026-10-22 15:15:57'),
(29, 'NT-2610-2519', 5, NULL, '543b tân phú, r, TP. Hồ Chí Minh', 50000.00, 2000.00, 0.00, 52000.00, 'sepay', 'pending', 'pending', NULL, NULL, '2026-10-22 15:34:01', '2026-10-22 15:34:01'),
(30, 'NT-2610-7865', 5, NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', 50000.00, 4000.00, 0.00, 54000.00, 'cod', 'pending', 'pending', NULL, NULL, '2026-10-22 16:57:01', '2026-10-22 16:57:01'),
(31, 'NT-2610-5539', 6, NULL, '543b tân phú, r, TP. Hồ Chí Minh', 50000.00, 2000.00, 0.00, 52000.00, 'sepay', 'paid', 'cancelled', '[SePay Webhook] Thanh toán thành công 52.000 đ qua MBBank (Ref: FT26296741390800) lúc 2026-10-23 09:27:00', NULL, '2026-10-23 02:27:01', '2026-10-27 09:49:01'),
(32, 'NT-2610-8123', 13, NULL, '220 nguyễn hồng đào, tân bình, TP. Hồ Chí Minh', 50000.00, 2000.00, 0.00, 52000.00, 'sepay', 'pending', 'pending', NULL, NULL, '2026-10-27 03:17:55', '2026-10-27 03:17:55'),
(33, 'NT-2610-4939', 13, NULL, '220 Nguyễn Hồng Đào, Tân Bình, TP. Hồ Chí Minh', 50000.00, 2000.00, 0.00, 52000.00, 'cod', 'paid', 'completed', NULL, NULL, '2026-10-27 03:18:22', '2026-10-27 10:19:49'),
(35, 'NT-2610-5686', 7, NULL, '412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh', 50000.00, 8000.00, 0.00, 58000.00, 'cod', 'paid', 'completed', NULL, NULL, '2026-10-29 08:16:20', '2026-10-29 15:17:48'),
(36, 'NT-2610-6366', 15, NULL, '412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh', 50000.00, 4000.00, 0.00, 54000.00, 'cod', 'pending', 'shipping', NULL, NULL, '2026-10-29 08:18:50', '2026-10-29 18:30:30'),
(37, 'NT-2610-7491', 6, 5, '543b Tân Phú, TP. Hồ Chí Minh', 0.00, 2000.00, 50000.00, 2000.00, 'cod', 'pending', 'pending', NULL, NULL, '2026-10-28 03:19:22', '2026-10-28 03:19:22');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_items`
--

DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `variant_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_name` varchar(255) NOT NULL COMMENT 'TĂªn lÆ°u cá»©ng lĂºc mua',
  `variant_name` varchar(255) DEFAULT NULL COMMENT 'MĂ u/Cháº¥t liá»‡u lÆ°u cá»©ng',
  `sku` varchar(50) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL COMMENT 'Giá lưu cùng lúc mua',
  `cost_price` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_price` decimal(15,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `variant_id`, `product_name`, `variant_name`, `sku`, `quantity`, `unit_price`, `total_price`) VALUES
(6, 5, 20, 20, 'sofa_Ä‘en nhĂ¡m', NULL, 'SOFADEN_NHAM_001', 1, 7500000.00, 7500000.00),
(7, 6, 12, 12, 'Tá»§ quáº§n Ă¡o 4 cĂ¡nh', NULL, 'SKU-TU-QUAN-AO-4-CANH', 1, 24500000.00, 24500000.00),
(8, 7, 20, 20, 'sofa_Ä‘en nhĂ¡m', NULL, 'SOFADEN_NHAM_001', 1, 7500000.00, 7500000.00),
(9, 8, 1, 1, 'Sofa da � Milano', NULL, 'SKU-SOFA-DA-Y-MILANO', 1, 12000000.00, 12000000.00),
(10, 9, 3, 3, 'Sofa g�c B?c �u', NULL, 'SKU-SOFA-GOC-BAC-AU', 1, 8500000.00, 8500000.00),
(11, 10, 20, 20, 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, 7500000.00, 7500000.00),
(12, 11, 20, 20, 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, 7500000.00, 7500000.00),
(13, 12, 20, 20, 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 2, 7500000.00, 15000000.00),
(14, 13, 20, 20, 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 2, 7500000.00, 15000000.00),
(15, 14, 20, 20, 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, 7500000.00, 7500000.00),
(16, 15, 20, 20, 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, 7500000.00, 7500000.00),
(17, 16, 20, 20, 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, 7500000.00, 7500000.00),
(18, 17, 20, 20, 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, 7500000.00, 7500000.00),
(19, 18, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, 2000.00, 2000.00),
(20, 19, 21, 21, 'Châm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, 2000.00, 2000.00),
(21, 20, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, 2000.00, 2000.00),
(22, 21, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, 2000.00, 2000.00),
(25, 24, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, 2000.00, 2000.00),
(26, 25, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, 2000.00, 2000.00),
(27, 26, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, 2000.00, 2000.00),
(28, 27, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, 2000.00, 2000.00),
(29, 28, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, 2000.00, 2000.00),
(30, 29, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, 2000.00, 2000.00),
(31, 30, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 2, 2000.00, 4000.00),
(32, 31, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, 2000.00, 2000.00),
(33, 32, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, 2000.00, 2000.00),
(34, 33, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, 2000.00, 2000.00),
(35, 35, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 4, 2000.00, 8000.00),
(36, 36, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 2, 2000.00, 4000.00),
(37, 37, 21, 21, 'cham trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, 2000.00, 2000.00);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `short_description` text DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `view_count` int(11) DEFAULT 0,
  `status` tinyint(1) DEFAULT 1 COMMENT '1: Äang bĂ¡n, 0: Ngá»«ng bĂ¡n',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`id`, `category_id`, `name`, `slug`, `short_description`, `content`, `brand`, `view_count`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Sofa da Ý Milano', 'sofa-da-y-milano', 'Sofa ba chỗ bọc da bò Ý nguyên tấm, khung gỗ sồi sấy khô và đệm mút đàn hồi cao cấp, giữ phom bền theo thời gian.', NULL, NULL, 54, 1, '2026-10-08 09:00:01', '2026-10-26 23:59:35', NULL),
(2, 1, 'Sofa vải linen Oslo', 'sofa-vai-linen-oslo', 'Sofa vải linen thoáng mát, đường may tỉ mỉ, chân gỗ chế tác thủ công, phù hợp không gian sống tối giản.', NULL, NULL, 60, 1, '2026-10-08 09:00:01', '2026-10-26 23:59:35', NULL),
(3, 1, 'Sofa góc Bắc Âu', 'sofa-goc-bac-au', 'Sofa góc chữ L phong cách Bắc Âu, các mô-đun tháo rời và đổi hướng linh hoạt theo bố cục phòng.', NULL, NULL, 57, 1, '2026-10-08 09:00:01', '2026-10-26 23:59:35', NULL),
(4, 2, 'Bàn ăn đá marble Carrara', 'ban-an-da-marble-carrara', 'Bàn ăn mặt đá marble Carrara nhập khẩu, chân kim loại mạ titan chống gỉ, mặt bàn được xử lý chống thấm.', NULL, NULL, 58, 1, '2026-10-08 09:00:01', '2026-10-26 23:59:35', NULL),
(5, 2, 'Bàn ăn gỗ sồi Nga', 'ban-an-go-soi-nga', 'Bàn ăn gỗ sồi Nga nguyên khối, phủ dầu bảo vệ tự nhiên giữ trọn vân gỗ và độ ấm của chất liệu.', NULL, NULL, 49, 1, '2026-10-08 09:00:01', '2026-10-26 23:59:35', NULL),
(6, 3, 'Ghế ăn da bọc Ý', 'ghe-an-da-boc-y', 'Ghế ăn bọc da công nghiệp cao cấp, khung thép chịu lực, đệm êm vừa vặn cho bữa ăn dài.', NULL, NULL, 49, 1, '2026-10-08 09:00:01', '2026-10-26 23:59:35', NULL),
(7, 3, 'Ghế thư giãn gỗ óc chó', 'ghe-thu-gian-go-oc-cho', 'Ghế thư giãn gỗ óc chó, tựa lưng cong theo cơ thể, đệm vải nhập khẩu tạo cảm giác dễ chịu khi đọc sách.', NULL, NULL, 51, 1, '2026-10-08 09:00:01', '2026-10-26 23:59:35', NULL),
(8, 3, 'Ghế công thái học Ergo', 'ghe-cong-thai-hoc-ergo', 'Ghế công thái học lưng lưới, tựa đầu và tay vịn điều chỉnh ba hướng, hỗ trợ cột sống khi làm việc dài.', NULL, NULL, 49, 1, '2026-10-08 09:00:01', '2026-10-26 23:59:36', NULL),
(9, 3, 'Ghế ngoài trời gỗ teak', 'ghe-ngoai-troi-go-teak', 'Ghế ngoài trời gỗ teak chống mối mọt và chịu được mưa nắng, phù hợp ban công, sân vườn.', NULL, NULL, 49, 1, '2026-10-08 09:00:01', '2026-10-26 23:59:36', NULL),
(10, 4, 'Giường ngủ bọc nỉ Velvet', 'giuong-boc-ni-velvet', 'Giường bọc nỉ velvet với đầu giường cao, khung gỗ chắc chắn và hệ nan đệm êm ái.', NULL, NULL, 49, 1, '2026-10-08 09:00:01', '2026-10-26 23:59:36', NULL),
(11, 4, 'Giường gỗ tự nhiên Scandinavian', 'giuong-go-tu-nhien-scandinavian', 'Giường gỗ sồi tự nhiên tối giản, bề mặt phủ dầu mờ an toàn cho sức khỏe và dễ vệ sinh.', NULL, NULL, 49, 1, '2026-10-08 09:00:01', '2026-10-26 23:59:36', NULL),
(12, 5, 'Tủ quần áo 4 cánh', 'tu-quan-ao-4-canh', 'Tủ quần áo bốn cánh gỗ MDF chống ẩm, ray giảm chấn và hệ ngăn chia tiện dụng.', NULL, NULL, 59, 1, '2026-10-08 09:00:02', '2026-10-26 23:59:36', NULL),
(13, 5, 'Kệ tivi treo tường', 'ke-tivi-treo-tuong', 'Kệ tivi treo tường gọn gàng, có lỗ đi dây điện và tải trọng tới 60 kg.', NULL, NULL, 52, 1, '2026-10-08 09:00:02', '2026-10-26 23:59:36', NULL),
(14, 5, 'Kệ sách gỗ thông', 'ke-sach-go-thong', 'Kệ sách gỗ thông năm tầng, thiết kế mở giúp góc làm việc thoáng đãng và dễ sắp xếp.', NULL, NULL, 52, 1, '2026-10-08 09:00:02', '2026-10-26 23:59:36', NULL),
(15, 6, 'Đèn sàn đồng thau', 'den-san-dong-thau', 'Đèn sàn đồng thau thân mảnh, chao vải tản sáng dịu, tạo điểm nhấn cho góc đọc sách.', NULL, NULL, 49, 1, '2026-10-08 09:00:02', '2026-10-26 23:59:36', NULL),
(16, 6, 'Đèn thả trần mây', 'den-tha-tran-may', 'Đèn thả trần đan mây tự nhiên, ánh sáng ấm áp, phù hợp treo trên bàn ăn hoặc đảo bếp.', NULL, NULL, 53, 1, '2026-10-08 09:00:02', '2026-10-26 23:59:36', NULL),
(17, 6, 'Đèn bàn gốm', 'den-ban-gom', 'Đèn bàn gốm men mờ, chụp vải, cho ánh sáng vàng ấm phù hợp bàn làm việc và đầu giường.', NULL, NULL, 49, 1, '2026-10-08 09:00:02', '2026-10-26 23:59:36', NULL),
(18, 7, 'Bàn trà mặt kính', 'ban-tra-mat-kinh', 'Bàn trà mặt kính cường lực 12 mm, khung inox mạ vàng sang trọng, dễ lau chùi.', NULL, NULL, 49, 1, '2026-10-08 09:00:02', '2026-10-26 23:59:36', NULL),
(19, 7, 'Gương trang trí viền mạ vàng', 'guong-trang-tri-vien-vang', 'Gương trang trí viền hợp kim mạ vàng, treo ngang hoặc dọc đều cân đối cho phòng ngủ.', NULL, NULL, 49, 1, '2026-10-08 09:00:02', '2026-10-26 23:59:36', NULL),
(20, 1, 'Sofa da bò Ý cao cấp', 'sofaden-nham', 'Sofa da màu đen nhám quý phái, đệm êm ái cho không gian phòng khách hiện đại.', NULL, NULL, 163, 1, '2026-10-15 16:33:12', '2026-10-26 23:59:36', NULL),
(21, 7, 'cham trang trí', 'cham-trang-tri', 'sản phẩm trang trí nổi bật', NULL, NULL, 53, 1, '2026-10-22 03:38:08', '2026-10-26 23:59:36', NULL),
(22, 1, 'S?n ph?m th? nghi?m Phuong �n 3', 'test-pa3-product-1792641888', NULL, NULL, NULL, 0, 0, '2026-10-22 04:04:48', '2026-10-22 11:04:54', '2026-10-22 04:04:54');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_images`
--

DROP TABLE IF EXISTS `product_images`;
CREATE TABLE `product_images` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `variant_id` bigint(20) UNSIGNED DEFAULT NULL,
  `image_url` text DEFAULT NULL,
  `is_thumbnail` tinyint(1) DEFAULT 0,
  `sort_order` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `product_images`
--

INSERT INTO `product_images` (`id`, `product_id`, `variant_id`, `image_url`, `is_thumbnail`, `sort_order`) VALUES
(1, 20, NULL, 'https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcRki-yI52sFUUgMgey0RaCVX8DJkX5Vs2qx1TZhr0wbKwUYbS5Mo_2IviRrNzQOG3xih_u-xAldpoQGMviu9ia-Fx1kC0j0d6Am1I5dDVktCDHeadrSxaSBkA&usqp=CAc', 1, 0),
(5, 20, NULL, 'http://localhost:4000/uploads/prod-anh-NT4-1792120685145-93706.jpg', 0, 1),
(6, 20, NULL, 'http://localhost:4000/uploads/prod-anh-NT3-1792120685151-71667.jpg', 0, 2),
(7, 20, NULL, 'http://localhost:4000/uploads/prod-anh-NT2-1792120685155-7455.jpg', 0, 3),
(8, 1, NULL, 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80', 1, 0),
(9, 2, NULL, 'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?auto=format&fit=crop&w=600&q=80', 1, 0),
(10, 3, NULL, 'https://images.unsplash.com/photo-1540574163026-643ea20ade25?auto=format&fit=crop&w=600&q=80', 1, 0),
(11, 4, NULL, 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=600&q=80', 1, 0),
(12, 5, NULL, 'https://images.unsplash.com/photo-1577140917170-285929fb55b7?auto=format&fit=crop&w=600&q=80', 1, 0),
(13, 6, NULL, 'https://images.unsplash.com/photo-1580481077198-c847ad43616b?auto=format&fit=crop&w=600&q=80', 1, 0),
(14, 7, NULL, 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=600&q=80', 1, 0),
(15, 8, NULL, 'https://images.unsplash.com/photo-1505797149-43b0069ec26b?auto=format&fit=crop&w=600&q=80', 1, 0),
(16, 9, NULL, 'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=600&q=80', 1, 0),
(17, 10, NULL, 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=600&q=80', 1, 0),
(18, 11, NULL, 'https://images.unsplash.com/photo-1540518614846-7ede433c4ef9?auto=format&fit=crop&w=600&q=80', 1, 0),
(19, 12, NULL, 'https://www.noithatkaya.com/wp-content/uploads/2023/09/Tu-Quan-Ao-17.jpg', 1, 0),
(20, 13, NULL, 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=600&q=80', 1, 0),
(21, 14, NULL, 'https://images.unsplash.com/photo-1594671581654-278554dd3460?auto=format&fit=crop&w=600&q=80', 1, 0),
(22, 15, NULL, 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=600&q=80', 1, 0),
(23, 16, NULL, 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&w=600&q=80', 1, 0),
(24, 17, NULL, 'https://images.unsplash.com/photo-1534349762230-e0cadf78f5da?auto=format&fit=crop&w=600&q=80', 1, 0),
(25, 18, NULL, 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?auto=format&fit=crop&w=600&q=80', 1, 0),
(26, 19, NULL, 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=600&q=80', 1, 0),
(27, 21, NULL, 'http://localhost:4000/uploads/prod-mohinh-1792641014106-54374.jpg', 1, 0),
(28, 22, NULL, 'http://localhost:4000/uploads/test.jpg', 1, 0),
(29, 21, NULL, 'http://localhost:4000/uploads/prod-mohinh-1792649798446-77710.jpg', 0, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_variants`
--

DROP TABLE IF EXISTS `product_variants`;
CREATE TABLE `product_variants` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `sku` varchar(50) NOT NULL,
  `color` varchar(50) DEFAULT NULL,
  `material` varchar(50) DEFAULT NULL,
  `price` decimal(15,2) NOT NULL,
  `cost_price` decimal(15,2) NOT NULL DEFAULT 0.00,
  `compare_at_price` decimal(15,2) DEFAULT NULL,
  `stock_quantity` int(11) DEFAULT 0,
  `weight_gram` int(11) DEFAULT NULL COMMENT 'DĂ¹ng Ä‘á»ƒ tĂ­nh phĂ­ ship',
  `dimensions` varchar(50) DEFAULT NULL COMMENT 'DĂ i x Rá»™ng x Cao'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `product_variants`
--

INSERT INTO `product_variants` (`id`, `product_id`, `sku`, `color`, `material`, `price`, `compare_at_price`, `stock_quantity`, `weight_gram`, `dimensions`) VALUES
(1, 1, 'SKU-SOFA-DA-Y-MILANO', NULL, 'Da bò Ý', 58900000.00, NULL, 20, NULL, '240 × 95 × 78 cm'),
(2, 2, 'SKU-SOFA-VAI-LINEN-OSLO', NULL, 'Vải linen', 26500000.00, NULL, 20, NULL, '210 × 88 × 80 cm'),
(3, 3, 'SKU-SOFA-GOC-BAC-AU', NULL, 'Vải bố', 32900000.00, NULL, 20, NULL, '270 × 180 × 82 cm'),
(4, 4, 'SKU-BAN-AN-DA-MARBLE-CARRARA', NULL, 'Đá marble', 32500000.00, NULL, 20, NULL, '180 × 90 × 75 cm'),
(5, 5, 'SKU-BAN-AN-GO-SOI-NGA', NULL, 'Gỗ sồi', 18900000.00, NULL, 20, NULL, '160 × 80 × 75 cm'),
(6, 6, 'SKU-GHE-AN-DA-BOC-Y', NULL, 'Da công nghiệp', 4200000.00, NULL, 20, NULL, '48 × 55 × 88 cm'),
(7, 7, 'SKU-GHE-THU-GIAN-GO-OC-CHO', NULL, 'Gỗ óc chó', 18900000.00, NULL, 20, NULL, '72 × 80 × 95 cm'),
(8, 8, 'SKU-GHE-CONG-THAI-HOC-ERGO', NULL, 'Lưới & nhựa', 6900000.00, NULL, 20, NULL, '66 × 66 × 118 cm'),
(9, 9, 'SKU-GHE-NGOAI-TROI-GO-TEAK', NULL, 'Gỗ teak', 8900000.00, NULL, 20, NULL, '58 × 62 × 85 cm'),
(10, 10, 'SKU-GIUONG-BOC-NI-VELVET', NULL, 'Nỉ velvet', 22900000.00, NULL, 20, NULL, '180 × 200 × 110 cm'),
(11, 11, 'SKU-GIUONG-GO-TU-NHIEN-SCANDINAVIAN', NULL, 'Gỗ sồi', 28500000.00, NULL, 20, NULL, '160 × 200 × 95 cm'),
(12, 12, 'SKU-TU-QUAN-AO-4-CANH', NULL, 'Gỗ MDF', 11000000.00, 12600000.00, 20, NULL, '200 × 60 × 220 cm'),
(13, 13, 'SKU-KE-TIVI-TREO-TUONG', NULL, 'Gỗ công nghiệp', 9800000.00, NULL, 20, NULL, '180 × 35 × 40 cm'),
(14, 14, 'SKU-KE-SACH-GO-THONG', NULL, 'Gỗ thông', 7200000.00, NULL, 20, NULL, '80 × 30 × 180 cm'),
(15, 15, 'SKU-DEN-SAN-DONG-THAU', NULL, 'Đồng thau', 7900000.00, NULL, 20, NULL, 'Ø 40 × 160 cm'),
(16, 16, 'SKU-DEN-THA-TRAN-MAY', NULL, 'Mây tự nhiên', 3400000.00, NULL, 20, NULL, 'Ø 55 × 40 cm'),
(17, 17, 'SKU-DEN-BAN-GOM', NULL, 'Gốm', 1900000.00, NULL, 20, NULL, 'Ø 25 × 45 cm'),
(18, 18, 'SKU-BAN-TRA-MAT-KINH', NULL, 'Kính cường lực', 5600000.00, NULL, 20, NULL, '120 × 60 × 42 cm'),
(19, 19, 'SKU-GUONG-TRANG-TRI-VIEN-VANG', NULL, 'Hợp kim mạ', 3100000.00, NULL, 20, NULL, '60 × 90 cm'),
(20, 20, 'SOFADEN_NHAM_001', NULL, 'Da bò Ý', 7500000.00, NULL, 20, NULL, '220 × 90 × 75 cm'),
(21, 21, 'CHAM_TRANG_TRI_001', NULL, 'gốm', 2000.00, 4000.00, 19, NULL, NULL),
(22, 22, 'TEST_PA3_PRODUCT_1792641888_001', NULL, NULL, 3500000.00, NULL, 15, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `reviews`
--

DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `rating` tinyint(4) NOT NULL CHECK (`rating` between 1 and 5),
  `content` text DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `reviews`
--

INSERT INTO `reviews` (`id`, `product_id`, `user_id`, `order_id`, `rating`, `content`, `status`, `created_at`) VALUES
(2, 21, 13, 31, 5, 'very nice', 1, '2026-10-27 03:04:28');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`) VALUES
(1, 'admin', 'Quản trị viên toàn quyền'),
(2, 'seller', 'Người bán hàng, quản lý sản phẩm, đơn hàng'),
(3, 'customer', 'Khách mua hàng'),
(4, 'consultant', 'Chuyên viên tư vấn phong thủy'),
(5, 'warehouse', 'Thủ kho & vận chuyển'),
(6, 'marketing', 'Marketing & truyền thông'),
(7, 'cashier', 'Thu ngân & Kế toán quỹ, quản lý dòng tiền và đối soát');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `shopping_carts`
--

DROP TABLE IF EXISTS `shopping_carts`;
CREATE TABLE `shopping_carts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `session_id` varchar(255) DEFAULT NULL COMMENT 'DĂ nh cho khĂ¡ch chÆ°a Ä‘Äƒng nháº­p',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `showcases`
--

DROP TABLE IF EXISTS `showcases`;
CREATE TABLE `showcases` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `image_url` text DEFAULT NULL,
  `link_url` varchar(255) DEFAULT '/san-pham',
  `display_order` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `spaces`
--

DROP TABLE IF EXISTS `spaces`;
CREATE TABLE `spaces` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `image_url` text DEFAULT NULL,
  `display_order` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `spaces`
--

INSERT INTO `spaces` (`id`, `name`, `slug`, `image_url`, `display_order`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Phòng khách', 'phong-khach', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1200&q=80', 1, 1, '2026-10-23 04:38:26', '2026-10-23 04:38:26'),
(2, 'Phòng ngủ', 'phong-ngu', 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1200&q=80', 2, 1, '2026-10-23 04:38:26', '2026-10-23 04:38:26'),
(3, 'Phòng ăn', 'phong-an', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=1200&q=80', 3, 1, '2026-10-23 04:38:26', '2026-10-23 04:38:26'),
(4, 'Làm việc', 'lam-viec', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=1200&q=80', 4, 1, '2026-10-23 04:38:26', '2026-10-23 04:38:26'),
(5, 'Chiếu sáng', 'chieu-sang', 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=1200&q=80', 5, 1, '2026-10-23 04:38:26', '2026-10-23 04:38:26'),
(6, 'Ngoài trời', 'ngoai-troi', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=1200&q=80', 6, 1, '2026-10-23 04:38:26', '2026-10-23 04:38:26');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `system_logs`
--

DROP TABLE IF EXISTS `system_logs`;
CREATE TABLE `system_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `action` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar_url` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1 COMMENT '1: Active, 0: Banned',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `role_id`, `email`, `password_hash`, `full_name`, `phone`, `avatar_url`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 3, 'hi@gmail.com', '$2b$10$H3ndNj83h9RJ8QOHeiDei.5W0.REvZ.zcKgKV10Tv5AJTcL3QLnH.', 'hi', '0903456789', NULL, 1, '2026-10-09 06:18:11', '2026-10-16 12:13:46', NULL),
(2, 3, 'test@gmail.com', 'guest_no_login', 'Nguyễn Văn Test', '0988776655', NULL, 1, '2026-10-09 06:45:38', '2026-10-22 09:28:50', NULL),
(3, 3, 'truongvy6272005@gmail.com', 'guest_no_login', 'vy truong', '0123456789', NULL, 1, '2026-10-09 07:29:42', '2026-10-09 07:29:42', NULL),
(4, 3, 'truongvy2762005@gmail.com', 'GOOGLE_OAUTH_ACCOUNT', 'Vỹ kC', NULL, 'https://lh3.googleusercontent.com/a/ACg8ocJ2NPbtjfbyyXQ6uch4KEjQnd--kzitj9wQpAmn2toz_4Tn4Bo=s96-c', 1, '2026-10-15 05:57:00', '2026-10-22 09:28:50', NULL),
(5, 3, 'truongvy1022@gmail.com', 'GOOGLE_OAUTH_ACCOUNT', 'TC Vỹ', NULL, 'https://lh3.googleusercontent.com/a/ACg8ocLhZ6L4w2K-WVrG7afxpApEK-nu_0Wpy6X0FIBpJWPBMPTP2KQ=s96-c', 1, '2026-10-15 06:20:28', '2026-10-22 09:28:50', NULL),
(6, 1, 'admin@noithat.vn', '$2b$10$pZW98jYWOjFUbibKOUiAPuAIEQyHsLYFTzkVF4oowryYGtmgu0agG', 'Quản Trị Viên', '0359180209', NULL, 1, '2026-10-16 05:07:04', '2026-10-23 09:27:01', NULL),
(7, 1, 'huuloi230605@gmail.com', '$2b$10$eEOn1NBbmWBILnUzlZ6qHepjpy2xYhXV9ecPFrZYj7vOURP07GlDq', 'Phạm Hữu Lợi', NULL, 'https://lh3.googleusercontent.com/a/ACg8ocLzhk1m_1LhcUGjj9gfktop0CQekD7_cbSo3lFwSz1ZgAnUK4_EBA=s96-c', 1, '2026-10-18 12:53:49', '2026-10-22 09:28:50', NULL),
(8, 3, 'test@example.com', 'guest_no_login', 'Trần Văn Test VIP', '0988777666', NULL, 1, '2026-10-21 04:19:14', '2026-10-23 14:47:58', NULL),
(9, 3, 'testsim@example.com', 'guest_no_login', 'Tran Van Test Simulator', '0988777999', NULL, 1, '2026-10-21 04:19:22', '2026-10-21 04:19:22', NULL),
(10, 3, 'vabshop2026@gmail.com', '$2b$10$kdtOAo.Wc18c8O7Ux6.JrufiviFJOIoiljjW.m8xYx1x7o56Vq41S', 'Vab Shop', NULL, 'https://lh3.googleusercontent.com/a/ACg8ocJGscgmOMruAxUDT96bPa4yVCtZ8kUztI6RDwngAFTzFlJB1qk=s96-c', 1, '2026-10-21 06:50:32', '2026-10-21 06:50:32', NULL),
(11, 3, 'khach_1792651669064@noithat.local', 'guest_no_login', 'Khách Test Coupon', '0987654321', NULL, 1, '2026-10-22 06:47:49', '2026-10-22 06:47:49', NULL),
(12, 2, 'vy.dang@noithat.vn', '$2b$10$pqyJbU4XM/qEuQ3eWFCKoeP1.27WnKaTxXLcxHPe0Gj41jc/dcI6e', 'Đặng Thảo Vy', '0909003003', NULL, 1, '2026-10-23 07:29:41', '2026-10-23 14:29:56', NULL),
(13, 3, 'kkhoa2304@gmail.com', '$2b$10$t.8oOrU25q8lSoxmSkReWOChoemJ.PMoAS6HzQ/MMPKWpSSOe3t1m', 'K Khoa', '0877766122', NULL, 1, '2026-10-27 02:22:57', '2026-10-27 02:43:46', NULL),
(14, 3, 'khach_1793067441199_269@noithat.local', 'guest_review', 'Nguyễn Văn Test', '0901234567', NULL, 1, '2026-10-27 02:17:21', '2026-10-27 02:17:21', NULL),
(15, 3, 'huuloi2005@gmail.com', '$2b$10$OeapyVSWs1605d2VWuQGfe7KHgXztqCgUMM9qx8Vpcp/k2enQZDsO', 'Phạm Hữu Lợi', NULL, NULL, 1, '2026-10-29 08:14:15', '2026-10-29 08:14:15', NULL),
(30, 3, 'nhi@gmail.com', '$2b$10$U2byzlPlD9J8vxO6cHYA7u1HTj2p.KU733QGZXdJq9lKob0tBrWbK', 'nhi', '0123456799', NULL, 1, '2026-10-28 17:31:14', '2026-10-28 17:31:14', NULL),
(31, 3, 'truongchivy9a4.19.20.nts1@gmail.com', '$2b$10$Ugskhk8aR5yq0jnqOiyem.6yV0G.eI73UMSLSfLU5MUsfpTeiTlU6', 'truong chí vỹ', '0348571843', NULL, 1, '2026-10-29 06:16:58', '2026-10-29 06:16:58', NULL),
(32, 3, 'truongchivy27000@gmail.com', '$2b$10$I2yzNfFICapQmnSdDx5bJ.Ux7Ku7T4tHCS.hZ1vRLnU8hyzztd2fS', 'truong chi vy', '0359180208', NULL, 1, '2026-10-29 07:18:03', '2026-10-29 07:20:38', NULL),
(33, 3, 'truongchivy27001@gmail.com', '$2b$10$q4MNPUudU6Zzlyb3iqzGfOsUu1kKq8Q2jqV8k3rZ1FymNsrq8ppDm', 'truong chi vy', '0359180207', NULL, 1, '2026-10-29 08:06:46', '2026-10-29 08:06:46', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_addresses`
--

DROP TABLE IF EXISTS `user_addresses`;
CREATE TABLE `user_addresses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `receiver_name` varchar(100) NOT NULL,
  `receiver_phone` varchar(20) NOT NULL,
  `province` varchar(100) NOT NULL,
  `district` varchar(100) NOT NULL,
  `ward` varchar(100) NOT NULL,
  `specific_address` varchar(255) NOT NULL,
  `is_default` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `wishlists`
--

DROP TABLE IF EXISTS `wishlists`;
CREATE TABLE `wishlists` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `wishlists`
--

INSERT INTO `wishlists` (`id`, `user_id`, `product_id`, `created_at`) VALUES
(2, 4, 13, '2026-10-16 08:09:57'),
(4, 5, 16, '2026-10-22 02:47:34');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `banners`
--
ALTER TABLE `banners`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `bot_prompts`
--
ALTER TABLE `bot_prompts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `context_key` (`context_key`);

--
-- Chỉ mục cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_id` (`cart_id`),
  ADD KEY `variant_id` (`variant_id`);

--
-- Chỉ mục cho bảng `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Chỉ mục cho bảng `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `session_id` (`session_id`),
  ADD KEY `sender_id` (`sender_id`);

--
-- Chỉ mục cho bảng `chat_sessions`
--
ALTER TABLE `chat_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `coupons`
--
ALTER TABLE `coupons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Chỉ mục cho bảng `email_campaigns`
--
ALTER TABLE `email_campaigns`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_campaign_code` (`code`);

--
-- Chỉ mục cho bảng `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_code` (`order_code`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `coupon_id` (`coupon_id`);

--
-- Chỉ mục cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `variant_id` (`variant_id`);

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `category_id` (`category_id`);

--
-- Chỉ mục cho bảng `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `variant_id` (`variant_id`);

--
-- Chỉ mục cho bảng `product_variants`
--
ALTER TABLE `product_variants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Chỉ mục cho bảng `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Chỉ mục cho bảng `shopping_carts`
--
ALTER TABLE `shopping_carts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `showcases`
--
ALTER TABLE `showcases`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `spaces`
--
ALTER TABLE `spaces`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Chỉ mục cho bảng `system_logs`
--
ALTER TABLE `system_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone` (`phone`),
  ADD KEY `role_id` (`role_id`);

--
-- Chỉ mục cho bảng `user_addresses`
--
ALTER TABLE `user_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `wishlists`
--
ALTER TABLE `wishlists`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_product_wishlist` (`user_id`,`product_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `banners`
--
ALTER TABLE `banners`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT cho bảng `bot_prompts`
--
ALTER TABLE `bot_prompts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `chat_messages`
--
ALTER TABLE `chat_messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `chat_sessions`
--
ALTER TABLE `chat_sessions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `coupons`
--
ALTER TABLE `coupons`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `email_campaigns`
--
ALTER TABLE `email_campaigns`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT cho bảng `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT cho bảng `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT cho bảng `product_variants`
--
ALTER TABLE `product_variants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT cho bảng `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `shopping_carts`
--
ALTER TABLE `shopping_carts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `showcases`
--
ALTER TABLE `showcases`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `spaces`
--
ALTER TABLE `spaces`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `system_logs`
--
ALTER TABLE `system_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `user_addresses`
--
ALTER TABLE `user_addresses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `wishlists`
--
ALTER TABLE `wishlists`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `shopping_carts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD CONSTRAINT `chat_messages_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `chat_sessions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `chat_messages_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `chat_sessions`
--
ALTER TABLE `chat_sessions`
  ADD CONSTRAINT `chat_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Các ràng buộc cho bảng `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_images_ibfk_2` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `product_variants`
--
ALTER TABLE `product_variants`
  ADD CONSTRAINT `product_variants_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `shopping_carts`
--
ALTER TABLE `shopping_carts`
  ADD CONSTRAINT `shopping_carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `system_logs`
--
ALTER TABLE `system_logs`
  ADD CONSTRAINT `system_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Các ràng buộc cho bảng `user_addresses`
--
ALTER TABLE `user_addresses`
  ADD CONSTRAINT `user_addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `wishlists`
--
ALTER TABLE `wishlists`
  ADD CONSTRAINT `wishlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlists_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `password_otps`
--

DROP TABLE IF EXISTS `password_otps`;
CREATE TABLE `password_otps` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `otp_hash` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `attempts` int(11) NOT NULL DEFAULT 0,
  `used_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `password_otps_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


-- --------------------------------------------------------
-- Dữ liệu bảng chat_sessions
-- --------------------------------------------------------
INSERT INTO `chat_sessions` VALUES (1,15,'guest_mvhqiq99_b6ri','bot_handling','2026-10-29 10:47:11',NULL),(2,15,'guest_mvhqiq99_b6ri','bot_handling','2026-10-29 11:47:31',NULL);


-- --------------------------------------------------------
-- Dữ liệu bảng chat_messages
-- --------------------------------------------------------
INSERT INTO `chat_messages` VALUES (1,1,'customer',15,'Sinh nÄƒm 1995 (áº¤t Há»£i) nĂªn chá»n sofa mĂ u gĂ¬?','2026-10-29 10:47:11'),(2,1,'ai_bot',NULL,'Dáº¡, chĂ o quĂ½ khĂ¡ch! TĂ´i lĂ  ChuyĂªn gia tÆ° váº¥n Phong Thá»§y & Ná»™i Tháº¥t cá»§a **KTUFA Luxury Furniture**. Ráº¥t vinh háº¡nh Ä‘Æ°á»£c Ä‘á»“ng hĂ nh cĂ¹ng quĂ½ khĂ¡ch trĂªn hĂ nh trĂ¬nh kiáº¿n táº¡o má»™t khĂ´ng gian sá»‘ng thá»‹nh vÆ°á»£ng vĂ  viĂªn mĂ£n.\n\nÄá»‘i vá»›i gia chá»§ sinh nÄƒm **1995 (tuá»•i áº¤t Há»£i)**, viá»‡c lá»±a chá»n mĂ u sáº¯c cho bá»™ sofa â€“ trĂ¡i tim cá»§a phĂ²ng khĂ¡ch â€“ Ä‘Ă³ng vai trĂ² vĂ´ cĂ¹ng quan trá»ng Ä‘á»ƒ chiĂªu tĂ i hĂºt lá»™c, mang láº¡i bĂ¬nh an vĂ  vÆ°á»£ng khĂ­ cho gia Ä‘Ă¬nh. DÆ°á»›i Ä‘Ă¢y lĂ  nhá»¯ng tÆ° váº¥n chuyĂªn sĂ¢u tá»« **KTUFA Luxury Furniture**:\n\n### 1. PhĂ¢n tĂ­ch Báº£n má»‡nh & NgÅ© hĂ nh\n* **NÄƒm sinh Ă¢m lá»‹ch:** 1995 â€“ áº¤t Há»£i (Con lá»£n).\n* **NgÅ© hĂ nh náº¡p Ă¢m:** **SÆ¡n Äáº§u Há»a** (Lá»­a trĂªn nĂºi).\n\nTheo quy luáº­t ngÅ© hĂ nh tÆ°Æ¡ng sinh - tÆ°Æ¡ng kháº¯c, Ä‘á»ƒ chá»n mĂ u sáº¯c sofa mang láº¡i may máº¯n, chĂºng ta Æ°u tiĂªn cĂ¡c gam mĂ u tÆ°Æ¡ng há»£p (cĂ¹ng hĂ nh Há»a) vĂ  tÆ°Æ¡ng sinh (Há»a sinh Thá»• hoáº·c Má»™c sinh Há»a).\n\n### 2. Gá»£i Ă½ mĂ u sáº¯c Sofa chuáº©n phong thá»§y cho tuá»•i áº¤t Há»£i (1995)\n\n* **MĂ u tÆ°Æ¡ng há»£p (HĂ nh Há»a):** \n  * *MĂ u sáº¯c:* Äá», há»“ng, tĂ­m, cam Ä‘áº­m.\n  * *Ă nghÄ©a:* TÄƒng cÆ°á»ng nÄƒng lÆ°á»£ng báº£n má»‡nh, mang láº¡i sá»± nhiá»‡t huyáº¿t, may máº¯n vĂ  tĂ i lá»™c dá»“i dĂ o. \n  * *Gá»£i Ă½ tá»« **KTUFA Luxury Furniture** phá»‘i ná»™i tháº¥t:* QuĂ½ khĂ¡ch cĂ³ thá»ƒ chá»n cĂ¡c máº«u sofa da cao cáº¥p bá»c da tĂ´ng mĂ u Ä‘á» Ä‘Ă´ sang trá»ng hoáº·c Ä‘iá»ƒm xuyáº¿t gá»‘i Ă´m mĂ u cam/há»“ng tráº§m Ä‘á»ƒ táº¡o Ä‘iá»ƒm nháº¥n quyá»n quĂ½ cho phĂ²ng khĂ¡ch mĂ  váº«n giá»¯ Ä‘Æ°á»£c sá»± nhĂ£ nháº·n.\n\n* **MĂ u tÆ°Æ¡ng sinh (HĂ nh Má»™c - Má»™c sinh Há»a):** \n  * *MĂ u sáº¯c:* Xanh lĂ¡ cĂ¢y, xanh rĂªu, xanh lá»¥c.\n  * *Ă nghÄ©a:* Má»™c sinh Há»a lĂ  má»‘i quan há»‡ sinh trÆ°á»Ÿng, giĂºp gia chá»§ gáº·p nhiá»u quĂ½ nhĂ¢n phĂ¹ trá»£, cĂ´ng danh sá»± nghiá»‡p phĂ¡t triá»ƒn vá»¯ng cháº¯c, sá»©c khá»e hanh thĂ´ng.\n  * *Gá»£i Ă½ tá»« **KTUFA Luxury Furniture** phá»‘i ná»™i tháº¥t:* Má»™t bá»™ sofa da bĂ² Ă cao cáº¥p káº¿t há»£p vá»›i khung gá»— Ă³c chĂ³ tá»± nhiĂªn (Má»™c sinh Há»a cá»±c tá»‘t) hoáº·c má»™t thiáº¿t káº¿ sofa bá»c ná»‰ nhung cao cáº¥p mĂ u xanh rĂªu tráº§m sáº½ lĂ  lá»±a chá»n hoĂ n háº£o, vá»«a há»£p phong thá»§y vá»«a mang Ä‘áº­m hÆ¡i thá»Ÿ kiáº¿n trĂºc thÆ°á»£ng lÆ°u.\n\n### 3. CĂ¡c mĂ u sáº¯c Ä‘áº¡i ká»µ cáº§n trĂ¡nh\n* **MĂ u thuá»™c hĂ nh Thá»§y (Thá»§y kháº¯c Há»a):** Äen, xanh dÆ°Æ¡ng, xanh nÆ°á»›c biá»ƒn. \n  * *LĂ½ do:* NÆ°á»›c dáº­p táº¯t lá»­a, mang theo nÄƒng lÆ°á»£ng xung kháº¯c, dá»… gĂ¢y cáº£n trá»Ÿ tĂ i lá»™c vĂ  báº¥t á»•n trong gia Ä‘áº¡o. Do Ä‘Ă³, quĂ½ khĂ¡ch tuyá»‡t Ä‘á»‘i nĂªn trĂ¡nh chá»n sofa cĂ³ tĂ´ng mĂ u chá»§ Ä‘áº¡o nĂ y.\n* **MĂ u thuá»™c hĂ nh Kim (Há»a kháº¯c Kim):** Tráº¯ng, xĂ¡m, Ă¡nh kim (máº·c dĂ¹ Há»a kháº¯c Kim nhÆ°ng nÄƒng lÆ°á»£ng cá»§a Há»a sáº½ bá»‹ tiĂªu hao khi \"kháº¯c\", khĂ´ng cĂ³ lá»£i cho gia chá»§).\n\n### 4. Gá»£i Ă½ khĂ´ng gian tá»« KTUFA Luxury Furniture\nÄá»ƒ tá»‘i Æ°u hĂ³a nÄƒng lÆ°á»£ng phong thá»§y cho phĂ²ng khĂ¡ch tuá»•i áº¤t Há»£i 1995, khi bĂ i trĂ­ sofa, quĂ½ khĂ¡ch cÅ©ng nĂªn lÆ°u Ă½:\n* **Vá»‹ trĂ­ Ä‘áº·t sofa:** NĂªn kĂª sofa tá»±a lÆ°ng vĂ o bá»©c tÆ°á»ng vá»¯ng chĂ£i (tá»a sÆ¡n) Ä‘á»ƒ táº¡o tháº¿ \"vá»¯ng nhÆ° bĂ n tháº¡ch\", hÆ°á»›ng nhĂ¬n ra khĂ´ng gian má»Ÿ hoáº·c cá»­a chĂ­nh (nhÆ°ng khĂ´ng Ä‘á»‘i diá»‡n trá»±c diá»‡n) Ä‘á»ƒ Ä‘Ă³n tĂ i khĂ­.\n* **Cháº¥t liá»‡u Ä‘á» xuáº¥t:** CĂ¡c dĂ²ng **sofa da tháº­t cao cáº¥p** káº¿t há»£p chĂ¢n gá»— tá»± nhiĂªn hoáº·c **sofa bá»c váº£i nhung cao cáº¥p** cá»§a **KTUFA Luxury Furniture** khĂ´ng chá»‰ Ä‘áº¡t chuáº©n kĂ­ch thÆ°á»›c phong thá»§y theo ThÆ°á»›c Lá»— Ban mĂ  cĂ²n mang Ä‘áº¿n cáº£m giĂ¡c Ăªm Ă¡i, tá»¥ khĂ­ tá»‘t cho ngĂ´i nhĂ .\n\nMá»i quĂ½ khĂ¡ch ghĂ© thÄƒm website cá»§a **KTUFA Luxury Furniture** Ä‘á»ƒ tham kháº£o cĂ¡c bá»™ sÆ°u táº­p sofa phĂ²ng khĂ¡ch thÆ°á»£ng háº¡ng Ä‘Æ°á»£c thiáº¿t káº¿ riĂªng cho tá»«ng báº£n má»‡nh. KhĂ´ng gian sá»‘ng Ä‘áº³ng cáº¥p vĂ  vÆ°á»£ng khĂ­ cá»§a quĂ½ khĂ¡ch Ä‘ang chá» Ä‘Æ°á»£c hoĂ n thiá»‡n! \n\nQuĂ½ khĂ¡ch cĂ³ cáº§n tĂ´i tÆ° váº¥n thĂªm vá» hÆ°á»›ng Ä‘áº·t sofa hay cĂ¡ch phá»‘i mĂ u ná»™i tháº¥t cho khĂ´ng gian phĂ²ng khĂ¡ch nĂ y khĂ´ng áº¡?','2026-10-29 10:47:11'),(3,2,'customer',15,'[Studio BĂ¡t Tráº¡ch] Gia chá»§ Nam máº¡ng sinh nÄƒm 2001 Â· KhĂ´ng gian: PhĂ²ng Äƒn Â· Cung CĂ n (Kim)','2026-10-29 11:47:31'),(4,2,'ai_bot',NULL,'KĂ­nh chĂ o QuĂ½ gia chá»§ sinh nÄƒm 2001 (Nam máº¡ng), thuá»™c cung CĂ n, hĂ nh Kim. Vá»›i tÆ° cĂ¡ch lĂ  ChuyĂªn gia Phong thá»§y cá»§a **KTUFA Luxury Furniture**, tĂ´i xin gá»­i tá»›i anh luáº­n giáº£i chuyĂªn sĂ¢u vĂ  tinh táº¿ cho khĂ´ng gian **PhĂ²ng Äƒn** â€“ nÆ¡i giá»¯ lá»­a háº¡nh phĂºc vĂ  vÆ°á»£ng khĂ­ cho gia Ä‘Ă¬nh.\n\n*   **Nháº­n Ä‘á»‹nh phong thá»§y tá»•ng quan:** Nam máº¡ng sinh nÄƒm 2001 thuá»™c TĂ¢y tá»© má»‡nh, há»£p vá»›i cĂ¡c hÆ°á»›ng TĂ¢y, TĂ¢y Nam, TĂ¢y Báº¯c vĂ  ÄĂ´ng Báº¯c. PhĂ²ng Äƒn lĂ  khĂ´ng gian dung dÆ°á»¡ng nguá»“n nÄƒng lÆ°á»£ng Thá»• (thá»©c Äƒn) sinh Kim (báº£n má»‡nh), tÆ°á»£ng trÆ°ng cho sá»± sung tĂºc vĂ  bá»n vá»¯ng. Viá»‡c bá»‘ trĂ­ phĂ²ng Äƒn tá»a láº¡c á»Ÿ cĂ¡c cung tá»‘t sáº½ giĂºp gia chá»§ kĂ­ch hoáº¡t tĂ i váº­n, gia Ä‘áº¡o hÆ°ng thá»‹nh, cĂ¡c má»‘i quan há»‡ xĂ£ há»™i rá»™ng má»Ÿ vĂ  luĂ´n gáº·p quĂ½ nhĂ¢n phĂ¹ trá»£.\n*   **Bá»‘ trĂ­ Ä‘á»“ Ä‘áº¡c chiĂªu tĂ i Ä‘Ă³n lá»™c:** \n    *   *HÆ°á»›ng bĂ n Äƒn:* NĂªn Ä‘áº·t bĂ n Äƒn quay vá» cĂ¡c hÆ°á»›ng sinh khĂ­ nhÆ° TĂ¢y Nam (DiĂªn NiĂªn) hoáº·c TĂ¢y (Sinh KhĂ­) Ä‘á»ƒ thu hĂºt tĂ i lá»™c vĂ  sá»± hĂ²a há»£p.\n    *   *Vá»‹ trĂ­ tá»±a lÆ°ng:* Gháº¿ ngá»“i cá»§a gia chá»§ khi dĂ¹ng bá»¯a nĂªn hÆ°á»›ng ra cá»­a chĂ­nh hoáº·c Ä‘áº·t á»Ÿ vá»‹ trĂ­ cĂ³ táº§m nhĂ¬n bao quĂ¡t, phĂ­a sau cĂ³ tÆ°á»ng vá»¯ng cháº¯c lĂ m \"tháº¿ tá»±a sÆ¡n\" táº¡o sá»± vá»¯ng chĂ£i, tá»± tin trong sá»± nghiá»‡p.\n    *   *Ănh sĂ¡ng:* Æ¯u tiĂªn Ă¡nh sĂ¡ng vĂ ng áº¥m Ă¡p tá»« há»‡ thá»‘ng Ä‘Ă¨n chĂ¹m pha lĂª Ä‘áº·t giá»¯a bĂ n Äƒn, tÆ°á»£ng trÆ°ng cho sá»± trá»n váº¹n, sung tĂºc vĂ  giĂºp kĂ­ch thĂ­ch vá»‹ giĂ¡c, gáº¯n káº¿t tĂ¬nh cáº£m gia Ä‘Ă¬nh.\n*   **Cháº¥t liá»‡u & MĂ u sáº¯c ná»™i tháº¥t tÆ°Æ¡ng sinh:** \n    *   *MĂ u sáº¯c:* Báº£n má»‡nh Kim ráº¥t há»£p vá»›i cĂ¡c tĂ´ng mĂ u thuáº§n khiáº¿t nhÆ° tráº¯ng, báº¡c, Ă¡nh kim, káº¿t há»£p hĂ i hĂ²a vá»›i mĂ u vĂ ng áº¥m, nĂ¢u Ä‘áº¥t cá»§a hĂ nh Thá»• (Thá»• sinh Kim) nhÆ° mĂ u gá»— sá»“i tá»± nhiĂªn, mĂ u da bĂ². TrĂ¡nh cĂ¡c mĂ u kháº¯c nhÆ° Ä‘á», há»“ng thuá»™c hĂ nh Há»a.\n    *   *Cháº¥t liá»‡u:* KTUFA Luxury Furniture khuyĂªn dĂ¹ng bĂ n Äƒn máº·t Ä‘Ă¡ marble cao cáº¥p (Ä‘áº¡i diá»‡n cho hĂ nh Thá»• vĂ  Kim) káº¿t há»£p chĂ¢n bĂ n inox máº¡ PVD Ă¡nh vĂ ng sang trá»ng, Ä‘i kĂ¨m gháº¿ bá»c da Ă má»m máº¡i. Sá»± káº¿t há»£p nĂ y khĂ´ng chá»‰ nĂ¢ng táº§m Ä‘áº³ng cáº¥p khĂ´ng gian mĂ  cĂ²n táº¡o chuá»—i ngÅ© hĂ nh tÆ°Æ¡ng sinh hoĂ n háº£o, mang láº¡i bĂ¬nh an vĂ  tĂ i lá»™c viĂªn mĂ£n cho gia chá»§ tráº» tuá»•i.','2026-10-29 11:47:31');


-- ========================================================
-- Bảng: suppliers (Nhà cung cấp)
-- ========================================================
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE `suppliers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(150) NOT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `suppliers` VALUES (1,'NCC-GO-BAC-AU','Xưởng Nội Thất Châu Âu','Trương Chí Vỹá»¹','0912345678','hung.gobackau@noithat.vn','HĂ€ Ná»˜I',1,'2026-10-29 15:47:05','2026-10-29 16:52:37'),(2,'NCC-DA-Y-MILANO','CĂ´ng Ty Sofa Cao Cáº¥p NhĂ  K','K Khoa','0934567890','trang.milano@da-y.vn','Tân Phú, Há»“ ChĂ­ Minh',1,'2026-10-29 15:47:05','2026-10-29 16:53:44'),(3,'NCC-DA-MARBLE','TĂ¡Â»â€¢ng Kho Ă„ÂĂƒÂ¡ TĂ¡Â»Â± NhiĂƒÂªn & BĂƒÂ n Ă„â€n Carrara','LĂƒÂª HoĂƒÂ ng Long','0978901234','long.carrara@stone-viet.com','KCN BiĂƒÂªn HĂƒÂ²a 2, Ă„ÂĂ¡Â»â€œng Nai',0,'2026-10-29 15:47:05','2026-10-29 16:53:52'),(4,'NCC-GOM-DEN','XĂ†Â°Ă¡Â»Å¸ng Ă„ÂĂƒÂ¨n ThĂ¡Â»Â§ CĂƒÂ´ng MĂ¡Â»Â¹ NghĂ¡Â»â€¡ & GĂ¡Â»â€˜m SĂ¡Â»Â©','PhĂ¡ÂºÂ¡m Minh Ă„ÂĂ¡Â»Â©c','0901239876','duc.gomart@noithat.vn','LĂƒÂ ng GĂ¡Â»â€˜m BĂƒÂ¡t TrĂƒÂ ng, Gia LĂƒÂ¢m, HĂƒÂ  NĂ¡Â»â„¢i',0,'2026-10-29 15:47:05','2026-10-29 16:54:06'),(5,'NCC-005','XÆ°á»Ÿng Gá»— Quáº£ng ChĂ¢u','Anh Lá»£i Hotboi','0902566063',NULL,'Há»“ ChĂ­ Minh',1,'2026-10-29 10:41:02','2026-10-29 10:41:02');


-- ========================================================
-- Bảng: import_slips (Phiếu nhập kho)
-- ========================================================
-- Table structure for table `import_slips`
--

DROP TABLE IF EXISTS `import_slips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
DROP TABLE IF EXISTS `import_slips`;
CREATE TABLE `import_slips` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `slip_code` varchar(50) NOT NULL,
  `supplier_id` int(10) unsigned DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `total_items` int(11) NOT NULL DEFAULT 0,
  `subtotal_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `discount_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `tax_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `shipping_fee` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `paid_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `debt_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `payment_method` varchar(50) NOT NULL DEFAULT 'cash',
  `payment_status` varchar(50) NOT NULL DEFAULT 'unpaid',
  `status` varchar(50) NOT NULL DEFAULT 'completed',
  `import_date` datetime DEFAULT current_timestamp(),
  `note` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `slip_code` (`slip_code`),
  KEY `fk_import_supplier` (`supplier_id`),
  KEY `fk_import_user` (`user_id`),
  CONSTRAINT `fk_import_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_import_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `import_slips` VALUES (1,'PN-202609-001',1,1,15,185000000.00,5000000.00,0.00,2000000.00,182000000.00,182000000.00,0.00,'bank','paid','completed','2026-09-10 09:30:00','NhĂ¡ÂºÂ­p lĂƒÂ´ bĂƒÂ n Ă„Æ’n gĂ¡Â»â€” sĂ¡Â»â€œi vĂƒÂ  kĂ¡Â»â€¡ tivi phĂ¡Â»Â¥c vĂ¡Â»Â¥ mĂƒÂ¹a cao Ă„â€˜iĂ¡Â»Æ’m cuĂ¡Â»â€˜i nĂ„Æ’m','2026-09-10 09:30:00','2026-10-29 15:47:05'),(2,'PN-202610-001',2,1,10,220000000.00,0.00,0.00,3000000.00,223000000.00,223000000.00,0.00,'bank','paid','completed','2026-10-05 14:00:00','NhĂ¡ÂºÂ­p da bĂƒÂ² ĂƒÂ cao cĂ¡ÂºÂ¥p vĂƒÂ  khung ghĂ¡ÂºÂ¿ thĂ†Â° giĂƒÂ£n ĂƒÂ³c chĂƒÂ³','2026-10-05 14:00:00','2026-10-29 15:47:05'),(3,'PN-202610-002',3,1,8,140000000.00,2000000.00,0.00,1500000.00,139500000.00,100000000.00,39500000.00,'bank','partial','completed','2026-10-18 10:15:00','NhĂ¡ÂºÂ­p mĂ¡ÂºÂ·t Ă„â€˜ĂƒÂ¡ Carrara, thanh toĂƒÂ¡n trĂ†Â°Ă¡Â»â€ºc 100tr, cĂƒÂ²n nĂ¡Â»Â£ 39.5tr Ă„â€˜Ă¡ÂºÂ¿n cuĂ¡Â»â€˜i thĂƒÂ¡ng','2026-10-18 10:15:00','2026-10-29 15:47:05'),(4,'PN-202610-003',4,1,25,45000000.00,0.00,0.00,1000000.00,46000000.00,46000000.00,0.00,'cash','paid','completed','2026-10-24 16:30:00','NhĂ¡ÂºÂ­p Ă„â€˜ĂƒÂ¨n thĂ¡ÂºÂ£ trĂ¡ÂºÂ§n vĂƒÂ  Ă„â€˜ĂƒÂ¨n sĂƒÂ n Ă„â€˜Ă¡Â»â€œng thau trĂ¡ÂºÂ£ tiĂ¡Â»Ân mĂ¡ÂºÂ·t trĂ¡Â»Â±c tiĂ¡ÂºÂ¿p','2026-10-24 16:30:00','2026-10-29 15:47:05'),(5,'PN-202610-005',1,1,2,5000.00,0.00,0.00,0.00,5000.00,5000.00,0.00,'cash','paid','completed','2026-10-29 00:00:00',NULL,'2026-10-29 10:25:07','2026-10-29 10:25:07'),(6,'PN-202610-006',2,1,5,5000.00,0.00,0.00,0.00,5000.00,5000.00,0.00,'cash','paid','completed','2026-10-29 00:00:00',NULL,'2026-10-29 10:39:46','2026-10-29 10:39:46');


-- ========================================================
-- Bảng: import_slip_items (Chi tiết phiếu nhập kho)
-- ========================================================
-- Table structure for table `import_slip_items`
--

DROP TABLE IF EXISTS `import_slip_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
DROP TABLE IF EXISTS `import_slip_items`;
CREATE TABLE `import_slip_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `slip_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned DEFAULT NULL,
  `variant_id` bigint(20) unsigned DEFAULT NULL,
  `sku` varchar(50) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `variant_name` varchar(255) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `import_price` decimal(15,2) NOT NULL DEFAULT 0.00,
  `selling_price` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_price` decimal(15,2) NOT NULL DEFAULT 0.00,
  `note` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_isi_slip` (`slip_id`),
  KEY `fk_isi_product` (`product_id`),
  KEY `fk_isi_variant` (`variant_id`),
  CONSTRAINT `fk_isi_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_isi_slip` FOREIGN KEY (`slip_id`) REFERENCES `import_slips` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_isi_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `import_slip_items` VALUES (1,1,5,5,'SKU-BAN-AN-GO-SOI-NGA','BĂƒÂ n Ă„â€n GĂ¡Â»â€” SĂ¡Â»â€œi Nga Scandinavian','MĂƒÂ u GĂ¡Â»â€” TĂ¡Â»Â± NhiĂƒÂªn',10,11000000.00,18900000.00,110000000.00,NULL),(2,1,14,14,'SKU-KE-TIVI-TREO-TUONG','KĂ¡Â»â€¡ Tivi Treo TĂ†Â°Ă¡Â»Âng HiĂ¡Â»â€¡n Ă„ÂĂ¡ÂºÂ¡i','GĂ¡Â»â€” Walnut SĂ¡Â»â€œi',5,15000000.00,24500000.00,75000000.00,NULL),(3,2,1,1,'SKU-SOFA-DA-Y-MILANO','Sofa Da BĂƒÂ² ĂƒÂ Milano Grand','Da BĂƒÂ² MĂƒÂ u NĂƒÂ¢u HĂ¡ÂºÂ¡t DĂ¡ÂºÂ»',4,34000000.00,58900000.00,136000000.00,NULL),(4,2,7,7,'SKU-GHE-THU-GIAN-GO-OC-CHO','GhĂ¡ÂºÂ¿ ThĂ†Â° GiĂƒÂ£n Lounge GĂ¡Â»â€” Ăƒâ€œc ChĂƒÂ³','GĂ¡Â»â€” Ăƒâ€œc ChĂƒÂ³ BĂ¡ÂºÂ¯c MĂ¡Â»Â¹',6,14000000.00,24500000.00,84000000.00,NULL),(5,3,4,4,'SKU-BAN-AN-DA-MARBLE-CARRARA','BĂƒÂ n Ă„â€n MĂ¡ÂºÂ·t Ă„ÂĂƒÂ¡ CĂ¡ÂºÂ©m ThĂ¡ÂºÂ¡ch Carrara','Ă„ÂĂƒÂ¡ TrĂ¡ÂºÂ¯ng Carrara',8,17500000.00,32500000.00,140000000.00,NULL),(6,4,16,16,'SKU-DEN-SAN-DONG-THAU','Ă„ÂĂƒÂ¨n SĂƒÂ n Ă„ÂĂ¡Â»Â©ng ThĂƒÂ¢n Ă„ÂĂ¡Â»â€œng Thau BĂ¡ÂºÂ¯c Ăƒâ€u','Ă„ÂĂ¡Â»â€œng Thau CĂ¡Â»â€¢ Ă„ÂiĂ¡Â»Æ’n',15,1800000.00,3200000.00,27000000.00,NULL),(7,4,17,17,'SKU-DEN-THA-TRAN-MAY','Ă„ÂĂƒÂ¨n ThĂ¡ÂºÂ£ TrĂ¡ÂºÂ§n ThĂ¡Â»Â§ CĂƒÂ´ng SĂ¡Â»Â£i MĂƒÂ¢y Ă„Âan','MĂƒÂ¢y Tre Ă„Âan TĂ¡Â»Â± NhiĂƒÂªn',10,1800000.00,2900000.00,18000000.00,NULL),(8,5,1,1,'SKU-TEST','Test Nháº­p HĂ ng','Da bĂ² Ă',2,2500.00,5000.00,5000.00,NULL),(9,6,21,21,'cham-trang-tri','cham trang trĂ­','gá»‘m',5,1000.00,2000.00,5000.00,NULL);


-- ========================================================
-- Bảng: cash_transactions (Sổ quỹ thu chi tiền mặt)
-- ========================================================
-- Table structure for table `cash_transactions`
--

DROP TABLE IF EXISTS `cash_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
DROP TABLE IF EXISTS `cash_transactions`;
CREATE TABLE `cash_transactions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `type` enum('income','expense') NOT NULL,
  `category` varchar(100) NOT NULL,
  `amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `payment_method` enum('cash','bank') NOT NULL DEFAULT 'cash',
  `reference_code` varchar(50) DEFAULT NULL,
  `performer_id` bigint(20) unsigned DEFAULT NULL,
  `recipient_name` varchar(150) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'completed',
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `fk_cash_performer` (`performer_id`),
  KEY `idx_cash_type` (`type`),
  KEY `idx_cash_method` (`payment_method`),
  KEY `idx_cash_ref` (`reference_code`),
  CONSTRAINT `fk_cash_performer` FOREIGN KEY (`performer_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `cash_transactions` VALUES (1,'PC-202609-001','expense','import_payment',182000000.00,'bank','PN-202609-001',1,'XĂ†Â°Ă¡Â»Å¸ng GĂ¡Â»â€” TĂ¡Â»Â± NhiĂƒÂªn BĂ¡ÂºÂ¯c Ăƒâ€u','ChuyĂ¡Â»Æ’n khoĂ¡ÂºÂ£n thanh toĂƒÂ¡n tiĂ¡Â»Ân hĂƒÂ ng phiĂ¡ÂºÂ¿u PN-202609-001','completed','2026-09-10 10:00:00'),(2,'PC-202610-001','expense','import_payment',223000000.00,'bank','PN-202610-001',1,'NĂ¡Â»â„¢i ThĂ¡ÂºÂ¥t Da ĂƒÂ Milano','ChuyĂ¡Â»Æ’n khoĂ¡ÂºÂ£n thanh toĂƒÂ¡n phiĂ¡ÂºÂ¿u nhĂ¡ÂºÂ­p PN-202610-001','completed','2026-10-05 15:30:00'),(3,'PC-202610-002','expense','import_payment',100000000.00,'bank','PN-202610-002',1,'TĂ¡Â»â€¢ng Kho Ă„ÂĂƒÂ¡ TĂ¡Â»Â± NhiĂƒÂªn Carrara','TĂ¡ÂºÂ¡m Ă¡Â»Â©ng Ă„â€˜Ă¡Â»Â£t 1 phiĂ¡ÂºÂ¿u nhĂ¡ÂºÂ­p PN-202610-002','completed','2026-10-18 11:00:00'),(4,'PC-202610-003','expense','import_payment',46000000.00,'cash','PN-202610-003',1,'XĂ†Â°Ă¡Â»Å¸ng Ă„ÂĂƒÂ¨n ThĂ¡Â»Â§ CĂƒÂ´ng BĂƒÂ¡t TrĂƒÂ ng','Chi tiĂ¡Â»Ân mĂ¡ÂºÂ·t thanh toĂƒÂ¡n trĂ¡Â»Â±c tiĂ¡ÂºÂ¿p tĂ¡ÂºÂ¡i showroom phiĂ¡ÂºÂ¿u PN-202610-003','completed','2026-10-24 16:45:00'),(5,'PT-202610-001','income','order_bank',58900000.00,'bank','DH-20261005-01',1,'KhĂƒÂ¡ch hĂƒÂ ng TrĂ¡ÂºÂ§n VĂ„Æ’n Test','Thanh toĂƒÂ¡n chuyĂ¡Â»Æ’n khoĂ¡ÂºÂ£n VietQR Ă„â€˜Ă†Â¡n hĂƒÂ ng DH-20261005-01','completed','2026-10-05 16:20:00'),(6,'PT-202610-002','income','order_bank',32500000.00,'bank','DH-20261012-02',1,'KhĂƒÂ¡ch hĂƒÂ ng Ă„ÂĂ¡ÂºÂ·ng ThĂ¡ÂºÂ£o Vy','Thanh toĂƒÂ¡n chuyĂ¡Â»Æ’n khoĂ¡ÂºÂ£n VietQR Ă„â€˜Ă†Â¡n hĂƒÂ ng DH-20261012-02','completed','2026-10-12 11:15:00'),(7,'PT-202610-003','income','order_cod',18900000.00,'cash','DH-20261015-03',1,'Shipper Giao HĂƒÂ ng TiĂ¡ÂºÂ¿t KiĂ¡Â»â€¡m','Thu ngĂƒÂ¢n nhĂ¡ÂºÂ­n tiĂ¡Â»Ân mĂ¡ÂºÂ·t COD tĂ¡Â»Â« shipper Ă„â€˜Ă†Â¡n DH-20261015-03','completed','2026-10-15 17:30:00'),(8,'PT-202610-004','income','order_cod',4420000.00,'cash','DH-20261022-04',1,'Shipper Viettel Post','Thu ngĂƒÂ¢n nhĂ¡ÂºÂ­n tiĂ¡Â»Ân mĂ¡ÂºÂ·t COD tĂ¡Â»Â« shipper Ă„â€˜Ă†Â¡n DH-20261022-04','completed','2026-10-22 18:00:00'),(9,'PC-202610-7189','expense','import_payment',5000.00,'cash','PN-202610-005',1,'Xưởng Nội Thất Châu Âu','Chi thanh toĂ¡n phiáº¿u nháº­p kho PN-202610-005 cho Xưởng Nội Thất Châu Âu','completed','2026-10-29 10:25:07'),(10,'PC-202610-6814','expense','import_payment',5000.00,'cash','PN-202610-006',1,'CĂ´ng Ty Sofa Cao Cáº¥p NhĂ  K','Chi thanh toĂ¡n phiáº¿u nháº­p kho PN-202610-006 cho CĂ´ng Ty Sofa Cao Cáº¥p NhĂ  K','completed','2026-10-29 10:39:46');


-- ========================================================
-- Bảng: password_otps (Mã OTP quên mật khẩu)
-- ========================================================
DROP TABLE IF EXISTS `password_otps`;
CREATE TABLE `password_otps` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `otp_hash` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `attempts` int(11) NOT NULL DEFAULT 0,
  `used_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `password_otps_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `password_otps` (`id`, `user_id`, `otp_hash`, `expires_at`, `attempts`, `used_at`, `created_at`) VALUES
(1, 31, '5d5a9a8de376fecc729ab35616a8094cbbbe4b7703f836ff6cbf1d447d82b6c3', '2026-10-29 06:25:09', 0, '2026-10-29 06:21:17', '2026-10-29 06:20:09'),
(2, 31, '75146e81d7f4fbefb3b4015de106336f0857aa44c333ae104e5634ee24c151d2', '2026-10-29 06:26:17', 0, '2026-10-29 06:22:20', '2026-10-29 06:21:17'),
(3, 31, 'd0246b0cd49b6e74b1de74afe527241e0247dc8794b5737777ba95cb965ccf73', '2026-10-29 06:27:20', 0, '2026-10-29 06:29:17', '2026-10-29 06:22:20'),
(4, 31, '2c0030f6be770b6d5ec126259c0df52890d1be564a67d1edbc215d1492146baf', '2026-10-29 06:34:17', 0, '2026-10-29 06:37:08', '2026-10-29 06:29:17'),
(5, 31, 'feaf0b56e50541bd9e0cad060fc754b64cb25369ebfb31a8a023157e73805209', '2026-10-29 06:42:08', 0, NULL, '2026-10-29 06:37:08'),
(6, 32, 'bb0314f2497653906843e3b0759991b035b964cf7ce6d0572fb30ecf0ecd94a2', '2026-10-29 07:24:10', 0, '2026-10-29 07:20:19', '2026-10-29 07:19:10');


SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET SQL_MODE=@OLD_SQL_MODE;
