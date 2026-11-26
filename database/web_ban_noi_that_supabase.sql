-- ================================================================
-- SUPABASE POSTGRESQL DATABASE DUMP
-- Project: KTUFA-WebNoiThat (apphmfgvaefciwvizlai)
-- Export Date: 2026-11-20T07:33:53.630Z
-- Total Tables: 27
-- ================================================================

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

-- ------------------------------------------------------------
-- Cấu trúc bảng: roles
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."roles" (
    "id" integer DEFAULT nextval('roles_id_seq'::regclass) NOT NULL,
    "name" character varying(50) NOT NULL,
    "description" character varying(255),
    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: roles (7 bản ghi)
INSERT INTO public."roles" ("id", "name", "description") VALUES (1, 'admin', 'Quáº£n trá»‹ viĂªn toĂ n quyá»n');
INSERT INTO public."roles" ("id", "name", "description") VALUES (2, 'seller', 'NgÆ°á»i bĂ¡n hĂ ng, quáº£n lĂ½ sáº£n pháº©m, Ä‘Æ¡n hĂ ng');
INSERT INTO public."roles" ("id", "name", "description") VALUES (3, 'customer', 'KhĂ¡ch mua hĂ ng');
INSERT INTO public."roles" ("id", "name", "description") VALUES (4, 'consultant', 'Chuyên viên tư vấn phong thủy');
INSERT INTO public."roles" ("id", "name", "description") VALUES (5, 'warehouse', 'Thủ kho & vận chuyển');
INSERT INTO public."roles" ("id", "name", "description") VALUES (6, 'marketing', 'Marketing & truyền thông');
INSERT INTO public."roles" ("id", "name", "description") VALUES (7, 'cashier', 'Thu ngÃ¢n & Káº¿ toÃ¡n quá»¹, quáº£n lÃ½ dÃ²ng tiá»n vÃ  Ä‘á»‘i soÃ¡t');

-- ------------------------------------------------------------
-- Cấu trúc bảng: users
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."users" (
    "id" bigint DEFAULT nextval('users_id_seq'::regclass) NOT NULL,
    "role_id" integer NOT NULL,
    "email" character varying(100) NOT NULL,
    "password_hash" character varying(255) NOT NULL,
    "full_name" character varying(100) NOT NULL,
    "phone" character varying(20),
    "avatar_url" character varying(255),
    "status" boolean DEFAULT true,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" timestamp without time zone,
    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: users (19 bản ghi)
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('1', 3, 'hi@gmail.com', '$2b$10$H3ndNj83h9RJ8QOHeiDei.5W0.REvZ.zcKgKV10Tv5AJTcL3QLnH.', 'hi', '0903456789', NULL, TRUE, '2026-10-08T23:18:11.000Z', '2026-10-16T05:13:46.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('2', 3, 'test@gmail.com', 'guest_no_login', 'Nguyễn Văn Test', '0988776655', NULL, TRUE, '2026-10-08T23:45:38.000Z', '2026-10-22T02:28:50.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('3', 3, 'truongvy6272005@gmail.com', 'guest_no_login', 'vy truong', '0123456789', NULL, TRUE, '2026-10-09T00:29:42.000Z', '2026-10-09T00:29:42.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('4', 3, 'truongvy2762005@gmail.com', 'GOOGLE_OAUTH_ACCOUNT', 'Vỹ kC', NULL, 'https://lh3.googleusercontent.com/a/ACg8ocJ2NPbtjfbyyXQ6uch4KEjQnd--kzitj9wQpAmn2toz_4Tn4Bo=s96-c', TRUE, '2026-10-14T22:57:00.000Z', '2026-10-22T02:28:50.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('5', 3, 'truongvy1022@gmail.com', 'GOOGLE_OAUTH_ACCOUNT', 'TC Vỹ', NULL, 'https://lh3.googleusercontent.com/a/ACg8ocLhZ6L4w2K-WVrG7afxpApEK-nu_0Wpy6X0FIBpJWPBMPTP2KQ=s96-c', TRUE, '2026-10-14T23:20:28.000Z', '2026-10-22T02:28:50.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('6', 1, 'admin@noithat.vn', '$2b$10$pZW98jYWOjFUbibKOUiAPuAIEQyHsLYFTzkVF4oowryYGtmgu0agG', 'Quản Trị Viên', '0359180209', NULL, TRUE, '2026-10-15T22:07:04.000Z', '2026-10-23T02:27:01.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('7', 1, 'huuloi230605@gmail.com', '$2b$10$eEOn1NBbmWBILnUzlZ6qHepjpy2xYhXV9ecPFrZYj7vOURP07GlDq', 'Phạm Hữu Lợi', '0902455063', 'https://lh3.googleusercontent.com/a/ACg8ocLzhk1m_1LhcUGjj9gfktop0CQekD7_cbSo3lFwSz1ZgAnUK4_EBA=s96-c', TRUE, '2026-10-18T05:53:49.000Z', '2026-10-29T23:46:18.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('8', 3, 'test@example.com', 'guest_no_login', 'Trần Văn Test VIP', '0988777666', NULL, TRUE, '2026-10-20T21:19:14.000Z', '2026-10-23T07:47:58.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('9', 3, 'testsim@example.com', 'guest_no_login', 'Tran Van Test Simulator', '0988777999', NULL, TRUE, '2026-10-20T21:19:22.000Z', '2026-10-20T21:19:22.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('10', 3, 'vabshop2026@gmail.com', '$2b$10$kdtOAo.Wc18c8O7Ux6.JrufiviFJOIoiljjW.m8xYx1x7o56Vq41S', 'Vab Shop', NULL, 'https://lh3.googleusercontent.com/a/ACg8ocJGscgmOMruAxUDT96bPa4yVCtZ8kUztI6RDwngAFTzFlJB1qk=s96-c', TRUE, '2026-10-20T23:50:32.000Z', '2026-10-20T23:50:32.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('11', 3, 'khach_1792651669064@noithat.local', 'guest_no_login', 'Khách Test Coupon', '0987654321', NULL, TRUE, '2026-10-21T23:47:49.000Z', '2026-10-21T23:47:49.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('12', 2, 'vy.dang@noithat.vn', '$2b$10$pqyJbU4XM/qEuQ3eWFCKoeP1.27WnKaTxXLcxHPe0Gj41jc/dcI6e', 'Đặng Thảo Vy', '0909003003', NULL, TRUE, '2026-10-23T00:29:41.000Z', '2026-10-23T07:29:56.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('13', 3, 'kkhoa2304@gmail.com', '$2b$10$t.8oOrU25q8lSoxmSkReWOChoemJ.PMoAS6HzQ/MMPKWpSSOe3t1m', 'K Khoa', '0877766122', NULL, TRUE, '2026-10-26T19:22:57.000Z', '2026-10-26T19:43:46.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('14', 3, 'khach_1793067441199_269@noithat.local', 'guest_review', 'Nguyễn Văn Test', '0901234567', NULL, TRUE, '2026-10-26T19:17:21.000Z', '2026-10-26T19:17:21.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('30', 3, 'nhi@gmail.com', '$2b$10$U2byzlPlD9J8vxO6cHYA7u1HTj2p.KU733QGZXdJq9lKob0tBrWbK', 'nhi', '0123456799', NULL, TRUE, '2026-10-28T03:31:14.000Z', '2026-10-28T03:31:14.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('31', 3, 'truongchivy9a4.19.20.nts1@gmail.com', '$2b$10$Ugskhk8aR5yq0jnqOiyem.6yV0G.eI73UMSLSfLU5MUsfpTeiTlU6', 'truong chí vỹ', '0348571843', NULL, TRUE, '2026-10-28T16:16:58.000Z', '2026-10-28T16:16:58.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('32', 3, 'truongchivy27000@gmail.com', '$2b$10$I2yzNfFICapQmnSdDx5bJ.Ux7Ku7T4tHCS.hZ1vRLnU8hyzztd2fS', 'truong chi vy', '0359180208', NULL, TRUE, '2026-10-28T17:18:03.000Z', '2026-10-28T17:20:38.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('33', 3, 'truongchivy27001@gmail.com', '$2b$10$q4MNPUudU6Zzlyb3iqzGfOsUu1kKq8Q2jqV8k3rZ1FymNsrq8ppDm', 'truong chi vy', '0359180207', NULL, TRUE, '2026-10-28T18:06:46.000Z', '2026-10-28T18:06:46.000Z', NULL);
INSERT INTO public."users" ("id", "role_id", "email", "password_hash", "full_name", "phone", "avatar_url", "status", "created_at", "updated_at", "deleted_at") VALUES ('15', 3, 'huuloi2005@gmail.com', '$2b$10$OeapyVSWs1605d2VWuQGfe7KHgXztqCgUMM9qx8Vpcp/k2enQZDsO', 'Phạm Lợi', '0902455060', '/uploads/avatars/avatar-u15-1794977608868.jpg', TRUE, '2026-10-27T19:55:10.000Z', '2026-11-17T21:53:28.879Z', NULL);

-- ------------------------------------------------------------
-- Cấu trúc bảng: user_addresses
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."user_addresses" (
    "id" bigint DEFAULT nextval('user_addresses_id_seq'::regclass) NOT NULL,
    "user_id" bigint NOT NULL,
    "receiver_name" character varying(100) NOT NULL,
    "receiver_phone" character varying(20) NOT NULL,
    "province" character varying(100) NOT NULL,
    "district" character varying(100) NOT NULL,
    "ward" character varying(100) NOT NULL,
    "specific_address" character varying(255) NOT NULL,
    "is_default" boolean DEFAULT false,
    CONSTRAINT "user_addresses_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: user_addresses (2 bản ghi)
INSERT INTO public."user_addresses" ("id", "user_id", "receiver_name", "receiver_phone", "province", "district", "ward", "specific_address", "is_default") VALUES ('1', '15', 'Phạm Lợi', '0902455060', 'TP. Hồ Chí Minh', 'Tân Phú', '', '412 Lũy Bán Bích', TRUE);
INSERT INTO public."user_addresses" ("id", "user_id", "receiver_name", "receiver_phone", "province", "district", "ward", "specific_address", "is_default") VALUES ('2', '15', 'Phạm Lợi', '0902455060', 'Tiền Giang', 'Cái Bè', '', 'Mỹ Trinh A', FALSE);

-- ------------------------------------------------------------
-- Cấu trúc bảng: password_otps
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."password_otps" (
    "id" bigint DEFAULT nextval('password_otps_id_seq'::regclass) NOT NULL,
    "user_id" bigint NOT NULL,
    "otp_hash" character varying(255) NOT NULL,
    "expires_at" timestamp without time zone NOT NULL,
    "attempts" integer DEFAULT 0 NOT NULL,
    "used_at" timestamp without time zone,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "password_otps_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: password_otps (6 bản ghi)
INSERT INTO public."password_otps" ("id", "user_id", "otp_hash", "expires_at", "attempts", "used_at", "created_at") VALUES ('1', '31', '5d5a9a8de376fecc729ab35616a8094cbbbe4b7703f836ff6cbf1d447d82b6c3', '2026-10-28T16:25:09.000Z', 0, '2026-10-28T16:21:17.000Z', '2026-10-28T16:20:09.000Z');
INSERT INTO public."password_otps" ("id", "user_id", "otp_hash", "expires_at", "attempts", "used_at", "created_at") VALUES ('2', '31', '75146e81d7f4fbefb3b4015de106336f0857aa44c333ae104e5634ee24c151d2', '2026-10-28T16:26:17.000Z', 0, '2026-10-28T16:22:20.000Z', '2026-10-28T16:21:17.000Z');
INSERT INTO public."password_otps" ("id", "user_id", "otp_hash", "expires_at", "attempts", "used_at", "created_at") VALUES ('3', '31', 'd0246b0cd49b6e74b1de74afe527241e0247dc8794b5737777ba95cb965ccf73', '2026-10-28T16:27:20.000Z', 0, '2026-10-28T16:29:17.000Z', '2026-10-28T16:22:20.000Z');
INSERT INTO public."password_otps" ("id", "user_id", "otp_hash", "expires_at", "attempts", "used_at", "created_at") VALUES ('4', '31', '2c0030f6be770b6d5ec126259c0df52890d1be564a67d1edbc215d1492146baf', '2026-10-28T16:34:17.000Z', 0, '2026-10-28T16:37:08.000Z', '2026-10-28T16:29:17.000Z');
INSERT INTO public."password_otps" ("id", "user_id", "otp_hash", "expires_at", "attempts", "used_at", "created_at") VALUES ('5', '31', 'feaf0b56e50541bd9e0cad060fc754b64cb25369ebfb31a8a023157e73805209', '2026-10-28T16:42:08.000Z', 0, NULL, '2026-10-28T16:37:08.000Z');
INSERT INTO public."password_otps" ("id", "user_id", "otp_hash", "expires_at", "attempts", "used_at", "created_at") VALUES ('6', '32', 'bb0314f2497653906843e3b0759991b035b964cf7ce6d0572fb30ecf0ecd94a2', '2026-10-28T17:24:10.000Z', 0, '2026-10-28T17:20:19.000Z', '2026-10-28T17:19:10.000Z');

-- ------------------------------------------------------------
-- Cấu trúc bảng: bot_prompts
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."bot_prompts" (
    "id" integer DEFAULT nextval('bot_prompts_id_seq'::regclass) NOT NULL,
    "context_key" character varying(50) NOT NULL,
    "content" text NOT NULL,
    "is_active" boolean DEFAULT true,
    CONSTRAINT "bot_prompts_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: bot_prompts (2 bản ghi)
INSERT INTO public."bot_prompts" ("id", "context_key", "content", "is_active") VALUES (1, 'system_prompt', 'Bạn là trợ lý AI ảo của thương hiệu Nội thất KTUFA Luxury Furniture. Hãy tư vấn lịch sự, chuẩn phong thủy, ngắn gọn và hữu ích cho khách hàng. Xưng hô là dạ/thưa.', TRUE);
INSERT INTO public."bot_prompts" ("id", "context_key", "content", "is_active") VALUES (2, 'shipping_policy', 'Giao hàng miễn phí nội thành cho đơn từ 2 triệu. Các tỉnh khác hỗ trợ vận chuyển chuyên nghiệp.', TRUE);

-- ------------------------------------------------------------
-- Cấu trúc bảng: categories
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."categories" (
    "id" integer DEFAULT nextval('categories_id_seq'::regclass) NOT NULL,
    "parent_id" integer,
    "name" character varying(100) NOT NULL,
    "slug" character varying(150) NOT NULL,
    "image_url" character varying(255),
    "status" boolean DEFAULT true,
    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: categories (7 bản ghi)
INSERT INTO public."categories" ("id", "parent_id", "name", "slug", "image_url", "status") VALUES (1, NULL, 'Sofa', 'sofa', NULL, TRUE);
INSERT INTO public."categories" ("id", "parent_id", "name", "slug", "image_url", "status") VALUES (2, NULL, 'Bàn ăn', 'ban-an', NULL, TRUE);
INSERT INTO public."categories" ("id", "parent_id", "name", "slug", "image_url", "status") VALUES (3, NULL, 'Ghế', 'ghe', NULL, TRUE);
INSERT INTO public."categories" ("id", "parent_id", "name", "slug", "image_url", "status") VALUES (4, NULL, 'Giường', 'giuong', NULL, TRUE);
INSERT INTO public."categories" ("id", "parent_id", "name", "slug", "image_url", "status") VALUES (5, NULL, 'Tủ & Kệ', 'tu-ke', NULL, TRUE);
INSERT INTO public."categories" ("id", "parent_id", "name", "slug", "image_url", "status") VALUES (6, NULL, 'Đèn', 'den', NULL, TRUE);
INSERT INTO public."categories" ("id", "parent_id", "name", "slug", "image_url", "status") VALUES (7, NULL, 'Trang trí', 'trang-tri', NULL, TRUE);

-- ------------------------------------------------------------
-- Cấu trúc bảng: spaces
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."spaces" (
    "id" integer DEFAULT nextval('spaces_id_seq'::regclass) NOT NULL,
    "name" character varying(100) NOT NULL,
    "slug" character varying(150) NOT NULL,
    "image_url" text,
    "display_order" integer DEFAULT 0,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "spaces_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: spaces (6 bản ghi)
INSERT INTO public."spaces" ("id", "name", "slug", "image_url", "display_order", "is_active", "created_at", "updated_at") VALUES (1, 'Phòng khách', 'phong-khach', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1200&q=80', 1, TRUE, '2026-10-22T21:38:26.000Z', '2026-10-22T21:38:26.000Z');
INSERT INTO public."spaces" ("id", "name", "slug", "image_url", "display_order", "is_active", "created_at", "updated_at") VALUES (2, 'Phòng ngủ', 'phong-ngu', 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1200&q=80', 2, TRUE, '2026-10-22T21:38:26.000Z', '2026-10-22T21:38:26.000Z');
INSERT INTO public."spaces" ("id", "name", "slug", "image_url", "display_order", "is_active", "created_at", "updated_at") VALUES (3, 'Phòng ăn', 'phong-an', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=1200&q=80', 3, TRUE, '2026-10-22T21:38:26.000Z', '2026-10-22T21:38:26.000Z');
INSERT INTO public."spaces" ("id", "name", "slug", "image_url", "display_order", "is_active", "created_at", "updated_at") VALUES (4, 'Làm việc', 'lam-viec', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=1200&q=80', 4, TRUE, '2026-10-22T21:38:26.000Z', '2026-10-22T21:38:26.000Z');
INSERT INTO public."spaces" ("id", "name", "slug", "image_url", "display_order", "is_active", "created_at", "updated_at") VALUES (5, 'Chiếu sáng', 'chieu-sang', 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=1200&q=80', 5, TRUE, '2026-10-22T21:38:26.000Z', '2026-10-22T21:38:26.000Z');
INSERT INTO public."spaces" ("id", "name", "slug", "image_url", "display_order", "is_active", "created_at", "updated_at") VALUES (6, 'Ngoài trời', 'ngoai-troi', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=1200&q=80', 6, TRUE, '2026-10-22T21:38:26.000Z', '2026-10-22T21:38:26.000Z');

-- ------------------------------------------------------------
-- Cấu trúc bảng: suppliers
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."suppliers" (
    "id" integer DEFAULT nextval('suppliers_id_seq'::regclass) NOT NULL,
    "code" character varying(50) NOT NULL,
    "name" character varying(150) NOT NULL,
    "contact_person" character varying(100),
    "phone" character varying(20),
    "email" character varying(100),
    "address" character varying(255),
    "status" boolean DEFAULT true,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "suppliers_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: suppliers (5 bản ghi)
INSERT INTO public."suppliers" ("id", "code", "name", "contact_person", "phone", "email", "address", "status", "created_at", "updated_at") VALUES (1, 'NCC-GO-BAC-AU', 'Xưởng Nội Thất Châu Âu', 'Trương Chí Vỹ', '0912345678', 'hung.gobackau@noithat.vn', 'HÀ NỘI', TRUE, '2026-10-29T08:47:05.000Z', '2026-10-29T09:52:37.000Z');
INSERT INTO public."suppliers" ("id", "code", "name", "contact_person", "phone", "email", "address", "status", "created_at", "updated_at") VALUES (2, 'NCC-DA-Y-MILANO', 'Công Ty Sofa Cao Cấp Nhà K', 'K Khoa', '0934567890', 'trang.milano@da-y.vn', 'Tân Phú, Hồ Chí Minh', TRUE, '2026-10-29T08:47:05.000Z', '2026-10-29T09:53:44.000Z');
INSERT INTO public."suppliers" ("id", "code", "name", "contact_person", "phone", "email", "address", "status", "created_at", "updated_at") VALUES (3, 'NCC-DA-MARBLE', 'Tá»•ng Kho ÄÃ¡ Tá»± NhiÃªn & BÃ n Ä‚n Carrara', 'LÃª HoÃ ng Long', '0978901234', 'long.carrara@stone-viet.com', 'KCN BiÃªn HÃ²a 2, Äá»“ng Nai', FALSE, '2026-10-29T08:47:05.000Z', '2026-10-29T09:53:52.000Z');
INSERT INTO public."suppliers" ("id", "code", "name", "contact_person", "phone", "email", "address", "status", "created_at", "updated_at") VALUES (4, 'NCC-GOM-DEN', 'XÆ°á»Ÿng ÄÃ¨n Thá»§ CÃ´ng Má»¹ Nghá»‡ & Gá»‘m Sá»©', 'Pháº¡m Minh Äá»©c', '0901239876', 'duc.gomart@noithat.vn', 'LÃ ng Gá»‘m BÃ¡t TrÃ ng, Gia LÃ¢m, HÃ  Ná»™i', FALSE, '2026-10-29T08:47:05.000Z', '2026-10-29T09:54:06.000Z');
INSERT INTO public."suppliers" ("id", "code", "name", "contact_person", "phone", "email", "address", "status", "created_at", "updated_at") VALUES (5, 'NCC-005', 'Xưởng Gỗ Quảng Châu', 'Anh Lợi Hotboi', '0902566063', NULL, 'Hồ Chí Minh', TRUE, '2026-10-29T03:41:02.000Z', '2026-10-29T03:41:02.000Z');

-- ------------------------------------------------------------
-- Cấu trúc bảng: coupons
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."coupons" (
    "id" integer DEFAULT nextval('coupons_id_seq'::regclass) NOT NULL,
    "code" character varying(50) NOT NULL,
    "discount_type" coupons_discount_type NOT NULL,
    "discount_value" numeric NOT NULL,
    "min_order_value" numeric DEFAULT 0.00,
    "max_discount_amount" numeric,
    "start_date" timestamp without time zone NOT NULL,
    "end_date" timestamp without time zone NOT NULL,
    "usage_limit" integer,
    "used_count" integer DEFAULT 0,
    "status" boolean DEFAULT true,
    CONSTRAINT "coupons_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: coupons (5 bản ghi)
INSERT INTO public."coupons" ("id", "code", "discount_type", "discount_value", "min_order_value", "max_discount_amount", "start_date", "end_date", "usage_limit", "used_count", "status") VALUES (1, 'GIAM10', 'percent', '10.00', '500000.00', '500000.00', '2026-10-21T23:47:04.000Z', '2027-01-19T23:47:04.000Z', 100, 0, TRUE);
INSERT INTO public."coupons" ("id", "code", "discount_type", "discount_value", "min_order_value", "max_discount_amount", "start_date", "end_date", "usage_limit", "used_count", "status") VALUES (2, 'NOITHAT50K', 'fixed_amount', '50000.00', '200000.00', NULL, '2026-10-21T23:47:04.000Z', '2027-01-19T23:47:04.000Z', 100, 0, TRUE);
INSERT INTO public."coupons" ("id", "code", "discount_type", "discount_value", "min_order_value", "max_discount_amount", "start_date", "end_date", "usage_limit", "used_count", "status") VALUES (3, 'TRIAN1K', 'fixed_amount', '1000.00', '1000.00', NULL, '2026-10-21T23:47:04.000Z', '2027-01-19T23:47:04.000Z', 100, 0, TRUE);
INSERT INTO public."coupons" ("id", "code", "discount_type", "discount_value", "min_order_value", "max_discount_amount", "start_date", "end_date", "usage_limit", "used_count", "status") VALUES (5, 'MAMOI', 'free_shipping', '50000.00', '0.00', NULL, '2026-10-22T00:15:00.000Z', '2027-01-30T17:00:00.000Z', 20, 14, TRUE);
INSERT INTO public."coupons" ("id", "code", "discount_type", "discount_value", "min_order_value", "max_discount_amount", "start_date", "end_date", "usage_limit", "used_count", "status") VALUES (7, 'FREESHIP', 'free_shipping', '0.00', '0.00', NULL, '2026-10-22T00:30:32.000Z', '2026-12-31T17:00:00.000Z', 100, 2, TRUE);

-- ------------------------------------------------------------
-- Cấu trúc bảng: products
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."products" (
    "id" bigint DEFAULT nextval('products_id_seq'::regclass) NOT NULL,
    "category_id" integer NOT NULL,
    "name" character varying(255) NOT NULL,
    "slug" character varying(255) NOT NULL,
    "short_description" text,
    "content" text,
    "brand" character varying(100),
    "view_count" integer DEFAULT 0,
    "status" boolean DEFAULT true,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" timestamp without time zone,
    CONSTRAINT "products_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: products (22 bản ghi)
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('22', 1, 'S?n ph?m th? nghi?m Phuong �n 3', 'test-pa3-product-1792641888', NULL, NULL, NULL, 0, FALSE, '2026-10-21T21:04:48.000Z', '2026-10-22T04:04:54.000Z', '2026-10-21T21:04:54.000Z');
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('9', 3, 'Ghế ngoài trời gỗ teak', 'ghe-ngoai-troi-go-teak', 'Ghế ngoài trời gỗ teak chống mối mọt và chịu được mưa nắng, phù hợp ban công, sân vườn.', NULL, NULL, 68, TRUE, '2026-10-08T02:00:01.000Z', '2026-11-13T02:45:48.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('19', 7, 'Gương trang trí viền mạ vàng', 'guong-trang-tri-vien-vang', 'Gương trang trí viền hợp kim mạ vàng, treo ngang hoặc dọc đều cân đối cho phòng ngủ.', NULL, NULL, 71, TRUE, '2026-10-08T02:00:02.000Z', '2026-11-13T02:45:49.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('20', 1, 'Sofa da bò Ý cao cấp', 'sofaden-nham', 'Sofa da màu đen nhám quý phái, đệm êm ái cho không gian phòng khách hiện đại.', NULL, NULL, 195, TRUE, '2026-10-15T09:33:12.000Z', '2026-11-13T02:45:49.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('21', 7, 'charm trang trí', 'charm-trang-tri', 'sản phẩm trang trí nổi bật', NULL, NULL, 95, TRUE, '2026-10-21T20:38:08.000Z', '2026-11-13T03:09:31.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('14', 5, 'Kệ sách gỗ thông', 'ke-sach-go-thong', 'Kệ sách gỗ thông năm tầng, thiết kế mở giúp góc làm việc thoáng đãng và dễ sắp xếp.', NULL, NULL, 73, TRUE, '2026-10-08T02:00:02.000Z', '2026-11-13T02:45:49.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('10', 4, 'Giường ngủ bọc nỉ Velvet', 'giuong-boc-ni-velvet', 'Giường bọc nỉ velvet với đầu giường cao, khung gỗ chắc chắn và hệ nan đệm êm ái.', NULL, NULL, 68, TRUE, '2026-10-08T02:00:01.000Z', '2026-11-13T02:45:48.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('1', 1, 'Sofa da Ý Milano', 'sofa-da-y-milano', 'Sofa ba chỗ bọc da bò Ý nguyên tấm, khung gỗ sồi sấy khô và đệm mút đàn hồi cao cấp, giữ phom bền theo thời gian.', NULL, NULL, 76, TRUE, '2026-10-08T02:00:01.000Z', '2026-11-13T02:45:48.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('11', 4, 'Giường gỗ tự nhiên Scandinavian', 'giuong-go-tu-nhien-scandinavian', 'Giường gỗ sồi tự nhiên tối giản, bề mặt phủ dầu mờ an toàn cho sức khỏe và dễ vệ sinh.', NULL, NULL, 68, TRUE, '2026-10-08T02:00:01.000Z', '2026-11-13T02:45:48.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('3', 1, 'Sofa góc Bắc Âu', 'sofa-goc-bac-au', 'Sofa góc chữ L phong cách Bắc Âu, các mô-đun tháo rời và đổi hướng linh hoạt theo bố cục phòng.', NULL, NULL, 78, TRUE, '2026-10-08T02:00:01.000Z', '2026-11-13T02:45:48.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('4', 2, 'Bàn ăn đá marble Carrara', 'ban-an-da-marble-carrara', 'Bàn ăn mặt đá marble Carrara nhập khẩu, chân kim loại mạ titan chống gỉ, mặt bàn được xử lý chống thấm.', NULL, NULL, 79, TRUE, '2026-10-08T02:00:01.000Z', '2026-11-13T02:45:48.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('5', 2, 'Bàn ăn gỗ sồi Nga', 'ban-an-go-soi-nga', 'Bàn ăn gỗ sồi Nga nguyên khối, phủ dầu bảo vệ tự nhiên giữ trọn vân gỗ và độ ấm của chất liệu.', NULL, NULL, 68, TRUE, '2026-10-08T02:00:01.000Z', '2026-11-13T02:45:48.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('6', 3, 'Ghế ăn da bọc Ý', 'ghe-an-da-boc-y', 'Ghế ăn bọc da công nghiệp cao cấp, khung thép chịu lực, đệm êm vừa vặn cho bữa ăn dài.', NULL, NULL, 68, TRUE, '2026-10-08T02:00:01.000Z', '2026-11-13T02:45:48.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('2', 1, 'Sofa vải linen Oslo', 'sofa-vai-linen-oslo', 'Sofa vải linen thoáng mát, đường may tỉ mỉ, chân gỗ chế tác thủ công, phù hợp không gian sống tối giản.', NULL, NULL, 89, TRUE, '2026-10-08T02:00:01.000Z', '2026-11-13T02:45:48.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('7', 3, 'Ghế thư giãn gỗ óc chó', 'ghe-thu-gian-go-oc-cho', 'Ghế thư giãn gỗ óc chó, tựa lưng cong theo cơ thể, đệm vải nhập khẩu tạo cảm giác dễ chịu khi đọc sách.', NULL, NULL, 70, TRUE, '2026-10-08T02:00:01.000Z', '2026-11-13T02:45:48.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('8', 3, 'Ghế công thái học Ergo', 'ghe-cong-thai-hoc-ergo', 'Ghế công thái học lưng lưới, tựa đầu và tay vịn điều chỉnh ba hướng, hỗ trợ cột sống khi làm việc dài.', NULL, NULL, 68, TRUE, '2026-10-08T02:00:01.000Z', '2026-11-13T02:45:48.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('12', 5, 'Tủ quần áo 4 cánh', 'tu-quan-ao-4-canh', 'Tủ quần áo bốn cánh gỗ MDF chống ẩm, ray giảm chấn và hệ ngăn chia tiện dụng.', NULL, NULL, 80, TRUE, '2026-10-08T02:00:02.000Z', '2026-11-13T02:45:49.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('13', 5, 'Kệ tivi treo tường', 'ke-tivi-treo-tuong', 'Kệ tivi treo tường gọn gàng, có lỗ đi dây điện và tải trọng tới 60 kg.', NULL, NULL, 73, TRUE, '2026-10-08T02:00:02.000Z', '2026-11-13T02:45:49.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('15', 6, 'Đèn sàn đồng thau', 'den-san-dong-thau', 'Đèn sàn đồng thau thân mảnh, chao vải tản sáng dịu, tạo điểm nhấn cho góc đọc sách.', NULL, NULL, 71, TRUE, '2026-10-08T02:00:02.000Z', '2026-11-13T02:45:49.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('16', 6, 'Đèn thả trần mây', 'den-tha-tran-may', 'Đèn thả trần đan mây tự nhiên, ánh sáng ấm áp, phù hợp treo trên bàn ăn hoặc đảo bếp.', NULL, NULL, 77, TRUE, '2026-10-08T02:00:02.000Z', '2026-11-13T02:45:49.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('17', 6, 'Đèn bàn gốm', 'den-ban-gom', 'Đèn bàn gốm men mờ, chụp vải, cho ánh sáng vàng ấm phù hợp bàn làm việc và đầu giường.', NULL, NULL, 68, TRUE, '2026-10-08T02:00:02.000Z', '2026-11-13T02:45:49.000Z', NULL);
INSERT INTO public."products" ("id", "category_id", "name", "slug", "short_description", "content", "brand", "view_count", "status", "created_at", "updated_at", "deleted_at") VALUES ('18', 7, 'Bàn trà mặt kính', 'ban-tra-mat-kinh', 'Bàn trà mặt kính cường lực 12 mm, khung inox mạ vàng sang trọng, dễ lau chùi.', NULL, NULL, 68, TRUE, '2026-10-08T02:00:02.000Z', '2026-11-13T02:45:49.000Z', NULL);

-- ------------------------------------------------------------
-- Cấu trúc bảng: product_variants
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."product_variants" (
    "id" bigint DEFAULT nextval('product_variants_id_seq'::regclass) NOT NULL,
    "product_id" bigint NOT NULL,
    "sku" character varying(50) NOT NULL,
    "color" character varying(50),
    "material" character varying(50),
    "price" numeric NOT NULL,
    "cost_price" numeric DEFAULT 0.00 NOT NULL,
    "compare_at_price" numeric,
    "stock_quantity" integer DEFAULT 0,
    "weight_gram" integer,
    "dimensions" character varying(50),
    CONSTRAINT "product_variants_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: product_variants (22 bản ghi)
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('1', '1', 'SKU-SOFA-DA-Y-MILANO', NULL, 'Da bò Ý', '5000.00', '2500.00', NULL, 22, NULL, '240 × 95 × 78 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('2', '2', 'SKU-SOFA-VAI-LINEN-OSLO', NULL, 'Vải linen', '26500000.00', '15370000.00', NULL, 20, NULL, '210 × 88 × 80 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('3', '3', 'SKU-SOFA-GOC-BAC-AU', NULL, 'Vải bố', '32900000.00', '19080000.00', NULL, 20, NULL, '270 × 180 × 82 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('4', '4', 'SKU-BAN-AN-DA-MARBLE-CARRARA', NULL, 'Đá marble', '32500000.00', '18850000.00', NULL, 20, NULL, '180 × 90 × 75 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('5', '5', 'SKU-BAN-AN-GO-SOI-NGA', NULL, 'Gỗ sồi', '18900000.00', '10960000.00', NULL, 20, NULL, '160 × 80 × 75 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('6', '6', 'SKU-GHE-AN-DA-BOC-Y', NULL, 'Da công nghiệp', '4200000.00', '2440000.00', NULL, 20, NULL, '48 × 55 × 88 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('7', '7', 'SKU-GHE-THU-GIAN-GO-OC-CHO', NULL, 'Gỗ óc chó', '18900000.00', '10960000.00', NULL, 20, NULL, '72 × 80 × 95 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('8', '8', 'SKU-GHE-CONG-THAI-HOC-ERGO', NULL, 'Lưới & nhựa', '6900000.00', '4000000.00', NULL, 20, NULL, '66 × 66 × 118 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('9', '9', 'SKU-GHE-NGOAI-TROI-GO-TEAK', NULL, 'Gỗ teak', '8900000.00', '5160000.00', NULL, 20, NULL, '58 × 62 × 85 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('10', '10', 'SKU-GIUONG-BOC-NI-VELVET', NULL, 'Nỉ velvet', '22900000.00', '13280000.00', NULL, 20, NULL, '180 × 200 × 110 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('11', '11', 'SKU-GIUONG-GO-TU-NHIEN-SCANDINAVIAN', NULL, 'Gỗ sồi', '28500000.00', '16530000.00', NULL, 20, NULL, '160 × 200 × 95 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('12', '12', 'SKU-TU-QUAN-AO-4-CANH', NULL, 'Gỗ MDF', '11000000.00', '6380000.00', '12600000.00', 21, NULL, '200 × 60 × 220 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('13', '13', 'SKU-KE-TIVI-TREO-TUONG', NULL, 'Gỗ công nghiệp', '9800000.00', '5680000.00', NULL, 19, NULL, '180 × 35 × 40 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('14', '14', 'SKU-KE-SACH-GO-THONG', NULL, 'Gỗ thông', '7200000.00', '4180000.00', NULL, 20, NULL, '80 × 30 × 180 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('15', '15', 'SKU-DEN-SAN-DONG-THAU', NULL, 'Đồng thau', '7900000.00', '4580000.00', NULL, 20, NULL, 'Ø 40 × 160 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('16', '16', 'SKU-DEN-THA-TRAN-MAY', NULL, 'Mây tự nhiên', '3400000.00', '1970000.00', NULL, 19, NULL, 'Ø 55 × 40 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('17', '17', 'SKU-DEN-BAN-GOM', NULL, 'Gốm', '1900000.00', '1100000.00', NULL, 20, NULL, 'Ø 25 × 45 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('18', '18', 'SKU-BAN-TRA-MAT-KINH', NULL, 'Kính cường lực', '5600000.00', '3250000.00', NULL, 20, NULL, '120 × 60 × 42 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('19', '19', 'SKU-GUONG-TRANG-TRI-VIEN-VANG', NULL, 'Hợp kim mạ', '3100000.00', '1800000.00', NULL, 20, NULL, '60 × 90 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('20', '20', 'SOFADEN_NHAM_001', NULL, 'Da bò Ý', '7500000.00', '4350000.00', NULL, 31, NULL, '220 × 90 × 75 cm');
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('21', '21', 'CHAM_TRANG_TRI_001', NULL, 'gốm', '2000.00', '1000.00', '4000.00', 27, NULL, NULL);
INSERT INTO public."product_variants" ("id", "product_id", "sku", "color", "material", "price", "cost_price", "compare_at_price", "stock_quantity", "weight_gram", "dimensions") VALUES ('22', '22', 'TEST_PA3_PRODUCT_1792641888_001', NULL, NULL, '3500000.00', '2030000.00', NULL, 15, NULL, NULL);

-- ------------------------------------------------------------
-- Cấu trúc bảng: product_images
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."product_images" (
    "id" bigint DEFAULT nextval('product_images_id_seq'::regclass) NOT NULL,
    "product_id" bigint NOT NULL,
    "variant_id" bigint,
    "image_url" text,
    "is_thumbnail" boolean DEFAULT false,
    "sort_order" integer DEFAULT 0,
    CONSTRAINT "product_images_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: product_images (26 bản ghi)
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('5', '20', NULL, 'http://localhost:4000/uploads/prod-anh-NT4-1792120685145-93706.jpg', FALSE, 1);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('6', '20', NULL, 'http://localhost:4000/uploads/prod-anh-NT3-1792120685151-71667.jpg', FALSE, 2);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('7', '20', NULL, 'http://localhost:4000/uploads/prod-anh-NT2-1792120685155-7455.jpg', FALSE, 3);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('8', '1', NULL, 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('9', '2', NULL, 'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('10', '3', NULL, 'https://images.unsplash.com/photo-1540574163026-643ea20ade25?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('11', '4', NULL, 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('12', '5', NULL, 'https://images.unsplash.com/photo-1577140917170-285929fb55b7?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('13', '6', NULL, 'https://images.unsplash.com/photo-1580481077198-c847ad43616b?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('14', '7', NULL, 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('15', '8', NULL, 'https://images.unsplash.com/photo-1505797149-43b0069ec26b?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('16', '9', NULL, 'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('17', '10', NULL, 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('18', '11', NULL, 'https://images.unsplash.com/photo-1540518614846-7ede433c4ef9?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('20', '13', NULL, 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('21', '14', NULL, 'https://images.unsplash.com/photo-1594671581654-278554dd3460?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('22', '15', NULL, 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('23', '16', NULL, 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('24', '17', NULL, 'https://images.unsplash.com/photo-1534349762230-e0cadf78f5da?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('25', '18', NULL, 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('26', '19', NULL, 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('27', '21', NULL, 'http://localhost:4000/uploads/prod-mohinh-1792641014106-54374.jpg', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('28', '22', NULL, 'http://localhost:4000/uploads/test.jpg', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('29', '21', NULL, 'http://localhost:4000/uploads/prod-mohinh-1792649798446-77710.jpg', FALSE, 1);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('1', '20', NULL, 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80', TRUE, 0);
INSERT INTO public."product_images" ("id", "product_id", "variant_id", "image_url", "is_thumbnail", "sort_order") VALUES ('19', '12', NULL, 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=600&q=80', TRUE, 0);

-- ------------------------------------------------------------
-- Cấu trúc bảng: banners
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."banners" (
    "id" integer DEFAULT nextval('banners_id_seq'::regclass) NOT NULL,
    "title" character varying(255) NOT NULL,
    "subtitle" character varying(255),
    "description" text,
    "image_url" text,
    "link_url" character varying(255) DEFAULT '/san-pham'::character varying,
    "button_text" character varying(100) DEFAULT 'KhĂ¡m phĂ¡ ngay'::character varying,
    "position" character varying(50) DEFAULT 'hero'::character varying NOT NULL,
    "display_order" integer DEFAULT 0,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "banners_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: banners (8 bản ghi)
INSERT INTO public."banners" ("id", "title", "subtitle", "description", "image_url", "link_url", "button_text", "position", "display_order", "is_active", "created_at", "updated_at") VALUES (2, 'BỘ SƯU TẬP NỘI THẤT', 'KHÔNG GIAN SỐNG ĐẲNG CẤP', 'Khám phá những thiết kế tinh tế, kết hợp hoàn hảo giữa công năng và thẩm mỹ, mang đến vẻ đẹp vượt thời gian cho ngôi nhà của bạn', 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1920&q=80', '/san-pham', 'Khám phá bộ sưu tập', 'san-pham', 1, TRUE, '2026-10-18T18:23:36.000Z', '2026-10-21T18:15:15.000Z');
INSERT INTO public."banners" ("id", "title", "subtitle", "description", "image_url", "link_url", "button_text", "position", "display_order", "is_active", "created_at", "updated_at") VALUES (3, 'TƯ VẤN PHONG THỦY & BÀI TRÍ NỘI THẤT', 'Ứng Dụng Trí Tuệ Nhân Tạo Gemini AI & Bát Trạch', 'Định hướng sinh khí tài lộc, phối hợp màu sắc ngũ hành và bài trí nội thất chuẩn phong thủy cho gia chủ.', 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1920&q=80', '/phong-thuy', 'Tra cứu cung mệnh ngay', 'phong-thuy', 1, TRUE, '2026-10-18T18:23:36.000Z', '2026-10-18T18:23:36.000Z');
INSERT INTO public."banners" ("id", "title", "subtitle", "description", "image_url", "link_url", "button_text", "position", "display_order", "is_active", "created_at", "updated_at") VALUES (4, 'NỘI THẤT CAO CẤP', 'BỘ SƯU TẬP 2026', 'Nội thất thiết kế cho không gian sống đẳng cấp — tuyển chọn từ những thương hiệu và xưởng chế tác hàng đầu', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1920&q=80', '/san-pham', 'Khám phá ngay', 'hero', 1, TRUE, '2026-10-21T16:26:22.000Z', '2026-10-21T17:52:51.000Z');
INSERT INTO public."banners" ("id", "title", "subtitle", "description", "image_url", "link_url", "button_text", "position", "display_order", "is_active", "created_at", "updated_at") VALUES (8, 'SOFA & KỆ TIVI', 'TÂM ĐIỂM PHÒNG KHÁCH', 'Thả mình vào sự êm ái và sang trọng. Không gian tiếp khách ấm cúng, hoàn hảo cho gia đình bạn', 'http://localhost:4000/uploads/banners/banner-1792655674009-326777258.avif', '/san-pham?khong-gian=phong-khach', 'Xem phòng khách', 'hero', 2, TRUE, '2026-10-21T17:54:43.000Z', '2026-10-21T18:03:08.000Z');
INSERT INTO public."banners" ("id", "title", "subtitle", "description", "image_url", "link_url", "button_text", "position", "display_order", "is_active", "created_at", "updated_at") VALUES (9, 'NGHỆ THUẬT NGHỈ NGƠI', 'NỘI THẤT PHÒNG NGỦ', 'Tái tạo năng lượng sau một ngày dài với bộ sưu tập phòng ngủ mang đậm dấu ấn cá nhân. Sự kết hợp hoàn hảo giữa chất liệu êm ái và thiết kế tinh tế', 'http://localhost:4000/uploads/banners/banner-1792655870396-838715317.avif', '/san-pham?khong-gian=phong-ngu', 'xem phòng ngủ', 'hero', 3, TRUE, '2026-10-21T17:57:52.000Z', '2026-10-21T18:00:40.000Z');
INSERT INTO public."banners" ("id", "title", "subtitle", "description", "image_url", "link_url", "button_text", "position", "display_order", "is_active", "created_at", "updated_at") VALUES (10, 'HÀI HÒA SINH KHÍ', 'TƯ VẤN PHONG THỦY AI', 'Ứng dụng trí tuệ nhân tạo để phân tích bản mệnh, giúp bạn dễ dàng chọn lựa màu sắc, chất liệu và hướng đặt nội thất thu hút tài lộc, bình an', 'http://localhost:4000/uploads/banners/banner-1792655948259-888496089.avif', '/phong-thuy', 'Tư vấn phong thủy', 'hero', 4, TRUE, '2026-10-21T17:59:09.000Z', '2026-10-21T17:59:09.000Z');
INSERT INTO public."banners" ("id", "title", "subtitle", "description", "image_url", "link_url", "button_text", "position", "display_order", "is_active", "created_at", "updated_at") VALUES (11, 'Phòng khách', NULL, NULL, 'http://localhost:4000/uploads/banners/banner-1792657223955-569360333.avif', '/san-pham?khong-gian=phong-khach', 'Khám phá ngay', 'space', 1, TRUE, '2026-10-21T18:20:26.000Z', '2026-10-21T18:20:26.000Z');
INSERT INTO public."banners" ("id", "title", "subtitle", "description", "image_url", "link_url", "button_text", "position", "display_order", "is_active", "created_at", "updated_at") VALUES (12, 'VỀ CHÚNG TÔI — KTUFA', 'Hành Trình Kiến Tạo Không Gian Sống Đẳng Cấp', 'Tuyển chọn vật liệu tự nhiên thượng hạng, chế tác thủ công tinh xảo và triết lý phong thủy Á Đông kiến tạo kiệt tác không gian sống.', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1920&q=80', '/ve-chung-toi#cau-chuyen', 'Khám phá ngay', 've-chung-toi', 1, TRUE, '2026-11-12T12:33:52.000Z', '2026-11-12T12:33:52.000Z');

-- ------------------------------------------------------------
-- Cấu trúc bảng: orders
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."orders" (
    "id" bigint DEFAULT nextval('orders_id_seq'::regclass) NOT NULL,
    "order_code" character varying(50) NOT NULL,
    "user_id" bigint NOT NULL,
    "coupon_id" integer,
    "shipping_address" text NOT NULL,
    "shipping_fee" numeric DEFAULT 0.00,
    "subtotal_amount" numeric NOT NULL,
    "discount_amount" numeric DEFAULT 0.00,
    "total_amount" numeric NOT NULL,
    "payment_method" character varying(50) NOT NULL,
    "payment_status" orders_payment_status DEFAULT 'pending'::orders_payment_status,
    "order_status" orders_order_status DEFAULT 'pending'::orders_order_status,
    "seller_note" text,
    "customer_note" text,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "orders_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: orders (41 bản ghi)
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('5', 'NT-2610-9661', '6', NULL, '543b tĂ¢n phĂº, r, TP. Há»“ ChĂ­ Minh', '0.00', '7500000.00', '0.00', '7500000.00', 'cod', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-15T21:13:03.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('6', 'NT-2610-5385', '6', NULL, '110d tĂ¢n quĂ½, tĂ¢n phĂº, HCM, r, TP. Há»“ ChĂ­ Minh', '0.00', '24500000.00', '0.00', '24500000.00', 'cod', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-16T01:36:49.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('7', 'NT-2610-3221', '7', NULL, '412, TĂ¢n PhĂº, TP. Há»“ ChĂ­ Minh', '0.00', '7500000.00', '0.00', '7500000.00', 'cod', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-18T06:02:12.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('8', 'NT-2610-5947', '8', NULL, '123 Du?ng C?u Gi?y, C?u Gi?y, H� N?i', '0.00', '12000000.00', '0.00', '12000000.00', 'sepay', 'paid', 'confirmed', '[SePay Webhook] Thanh toán thành công 12.000.000 đ qua MBBank (Ref: REF99999) lúc 2026-10-21 11:18:00', NULL, '2026-10-20T21:19:14.000Z', '2026-10-21T04:19:14.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('9', 'NT-2610-4932', '9', NULL, '456 Du?ng C?u Gi?y, C?u Gi?y, H� N?i', '0.00', '8500000.00', '0.00', '8500000.00', 'sepay', 'paid', 'confirmed', '[DEMO TEST] Thanh toán giả lập thành công 8.500.000 đ lúc 11:19:22 21/10/2026', NULL, '2026-10-20T21:19:22.000Z', '2026-10-21T04:19:22.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('10', 'NT-2610-8753', '6', NULL, '765A Tp hcm, r, TP. Hồ Chí Minh', '0.00', '7500000.00', '0.00', '7500000.00', 'sepay', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-20T22:32:28.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('11', 'NT-2610-7863', '6', NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', '0.00', '7500000.00', '0.00', '7500000.00', 'sepay', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-20T22:41:17.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('12', 'NT-2610-5288', '6', NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', '0.00', '15000000.00', '0.00', '15000000.00', 'sepay', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-20T22:57:04.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('13', 'NT-2610-9861', '6', NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', '0.00', '15000000.00', '0.00', '15000000.00', 'sepay', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-20T23:00:38.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('14', 'NT-2610-1738', '6', NULL, '299 trịnh đình trọng, hòa thạnh, tân phú, TP HCM, r, TP. Hồ Chí Minh', '0.00', '7500000.00', '0.00', '7500000.00', 'sepay', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-20T23:05:29.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('15', 'NT-2610-5475', '6', NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', '0.00', '7500000.00', '0.00', '7500000.00', 'sepay', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-20T23:16:28.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('16', 'NT-2610-4750', '6', NULL, '543b tân phú, r, TP. Hồ Chí Minh', '0.00', '7500000.00', '0.00', '7500000.00', 'sepay', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-20T23:20:13.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('17', 'NT-2610-7968', '6', NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', '0.00', '7500000.00', '0.00', '7500000.00', 'sepay', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-20T23:20:29.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('18', 'NT-2610-2647', '6', NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', '50000.00', '2000.00', '0.00', '52000.00', 'sepay', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-21T20:50:43.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('19', 'NT-2610-3033', '11', 3, '123 Phố Huế, Ba Đình, Hà Nội', '50000.00', '2000.00', '1000.00', '51000.00', 'cod', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-21T23:47:49.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('20', 'NT-2610-6180', '6', NULL, '765A Tp hcm, r, TP. Hồ Chí Minh', '50000.00', '2000.00', '0.00', '52000.00', 'sepay', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-22T00:41:30.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('21', 'NT-2610-9063', '6', 7, '765A Tp hcm, r, TP. Hồ Chí Minh', '0.00', '2000.00', '50000.00', '2000.00', 'sepay', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-22T00:41:30.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('24', 'NT-2610-9964', '6', NULL, '765A Tp hcm, r, TP. Hồ Chí Minh', '50000.00', '2000.00', '0.00', '52000.00', 'sepay', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-22T00:44:20.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('25', 'NT-2610-8735', '6', 5, '765A Tp hcm, r, TP. Hồ Chí Minh', '0.00', '2000.00', '50000.00', '2000.00', 'sepay', 'paid', 'confirmed', '[SePay Webhook] Thanh toán thành công 2.000 đ qua MBBank (Ref: FT26295755326490) lúc 2026-10-22 14:45:00', NULL, '2026-10-22T00:45:40.000Z', '2026-10-22T08:15:57.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('26', 'NT-2610-3146', '6', 5, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', '0.00', '2000.00', '50000.00', '2000.00', 'sepay', 'paid', 'confirmed', '[SePay Webhook] Thanh toán thành công 2.000 đ qua MBBank (Ref: FT26295050733038) lúc 2026-10-22 14:52:00', NULL, '2026-10-22T00:52:04.000Z', '2026-10-22T08:15:57.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('27', 'NT-2610-8318', '6', 5, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', '0.00', '2000.00', '50000.00', '2000.00', 'sepay', 'paid', 'confirmed', '[SePay Webhook] Thanh toán thành công 2.000 đ qua MBBank (Ref: FT26295064070640) lúc 2026-10-22 15:09:00', NULL, '2026-10-22T01:09:42.000Z', '2026-10-22T08:15:57.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('28', 'NT-2610-2866', '6', NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', '50000.00', '2000.00', '0.00', '52000.00', 'cod', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-22T01:10:45.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('29', 'NT-2610-2519', '5', NULL, '543b tân phú, r, TP. Hồ Chí Minh', '50000.00', '2000.00', '0.00', '52000.00', 'sepay', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-22T08:34:01.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('30', 'NT-2610-7865', '5', NULL, '110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh', '50000.00', '4000.00', '0.00', '54000.00', 'cod', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-22T09:57:01.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('31', 'NT-2610-5539', '6', NULL, '543b tân phú, r, TP. Hồ Chí Minh', '50000.00', '2000.00', '0.00', '52000.00', 'sepay', 'paid', 'cancelled', '[SePay Webhook] Thanh toán thành công 52.000 đ qua MBBank (Ref: FT26296741390800) lúc 2026-10-23 09:27:00', NULL, '2026-10-22T19:27:01.000Z', '2026-10-27T02:49:01.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('32', 'NT-2610-8123', '13', NULL, '220 nguyễn hồng đào, tân bình, TP. Hồ Chí Minh', '50000.00', '2000.00', '0.00', '52000.00', 'sepay', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-10-26T20:17:55.000Z', '2026-11-05T02:06:43.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('33', 'NT-2610-4939', '13', NULL, '220 nguyễn hồng đào, tân bình, TP. Hồ Chí Minh', '50000.00', '2000.00', '0.00', '52000.00', 'cod', 'paid', 'completed', NULL, NULL, '2026-10-26T20:18:22.000Z', '2026-10-27T03:19:49.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('35', 'NT-2610-5686', '7', NULL, '412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh', '50000.00', '8000.00', '0.00', '58000.00', 'cod', 'paid', 'completed', NULL, NULL, '2026-10-29T01:16:20.000Z', '2026-10-29T08:17:48.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('36', 'NT-2610-6366', '15', NULL, '412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh', '50000.00', '4000.00', '0.00', '54000.00', 'cod', 'pending', 'shipping', NULL, NULL, '2026-10-29T01:18:50.000Z', '2026-10-29T11:30:30.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('37', 'NT-2611-1881', '15', NULL, '412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh', '50000.00', '2000.00', '0.00', '52000.00', 'cod', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', 'ko có', '2026-11-04T01:49:55.000Z', '2026-11-06T07:50:04.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('38', 'NT-2611-6731', '15', NULL, '412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh', '0.00', '7500000.00', '0.00', '7500000.00', 'cod', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', 'ko có', '2026-11-04T01:52:00.000Z', '2026-11-06T07:50:04.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('39', 'NT-2611-8577', '15', NULL, '412, Tân Phú, TP. Hồ Chí Minh', '50000.00', '2000.00', '0.00', '52000.00', 'cod', 'pending', 'cancelled', '[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', 'abc', '2026-11-04T01:59:36.000Z', '2026-11-06T07:50:04.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('40', 'NT-2611-5753', '15', 5, '412, Tân Phú, TP. Hồ Chí Minh', '0.00', '2000.00', '50000.00', '2000.00', 'sepay', 'paid', 'confirmed', '[NOTIFY_EMAIL:huuloi230605@gmail.com]\n[DEMO TEST] Thanh toán giả lập thành công 2.000 đ lúc 08:33:09 5/11/2026', 'test', '2026-11-04T18:29:39.000Z', '2026-11-05T01:36:33.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('41', 'NT-2611-1085', '15', 7, '412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh', '0.00', '7500000.00', '0.00', '7500000.00', 'sepay', 'paid', 'confirmed', '[NOTIFY_EMAIL:huuloi230605@gmail.com]', 'abc', '2026-11-04T19:17:45.000Z', '2026-11-05T02:39:18.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('42', 'NT-2611-9109', '15', NULL, '412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh', '0.00', '9800000.00', '0.00', '9800000.00', 'sepay', 'paid', 'confirmed', '[NOTIFY_EMAIL:huuloi230605@gmail.com]', 'abc', '2026-11-04T19:42:03.000Z', '2026-11-05T02:42:12.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('43', 'NT-2611-9049', '15', NULL, '412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh', '0.00', '7500000.00', '0.00', '7500000.00', 'sepay', 'pending', 'cancelled', '[NOTIFY_EMAIL:huuloi230605@gmail.com]\n[CANCEL_REASON: Tôi đổi ý, muốn chọn sản phẩm khác]', NULL, '2026-11-04T20:05:44.000Z', '2026-11-05T03:34:04.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('44', 'NT-2611-8642', '15', NULL, '412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh', '0.00', '3400000.00', '0.00', '3400000.00', 'sepay', 'paid', 'completed', '[NOTIFY_EMAIL:huuloi230605@gmail.com]', NULL, '2026-11-04T20:43:42.000Z', '2026-11-05T03:54:23.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('45', 'NT-2611-9499', '15', NULL, '412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh', '0.00', '7500000.00', '0.00', '7500000.00', 'sepay', 'paid', 'cancelled', '[NOTIFY_EMAIL:huuloi2005@gmail.com]\n[CANCEL_REASON: Tôi đổi ý, muốn chọn sản phẩm khác]', NULL, '2026-11-06T02:14:09.000Z', '2026-11-06T09:16:06.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('46', 'NT-2611-4068', '15', NULL, '412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh', '0.00', '11000000.00', '0.00', '11000000.00', 'sepay', 'pending', 'cancelled', '[NOTIFY_EMAIL:huuloi2005@gmail.com]\n[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]', NULL, '2026-11-06T02:16:37.000Z', '2026-11-12T12:10:27.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('47', 'NT-2611-9397', '15', NULL, '412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh', '0.00', '11000000.00', '0.00', '11000000.00', 'cod', 'pending', 'cancelled', '[NOTIFY_EMAIL:huuloi2005@gmail.com]\n[CANCEL_REASON: Khách hàng liên hệ yêu cầu hủy đơn hàng]', NULL, '2026-11-06T02:17:27.000Z', '2026-11-06T09:23:56.000Z');
INSERT INTO public."orders" ("id", "order_code", "user_id", "coupon_id", "shipping_address", "shipping_fee", "subtotal_amount", "discount_amount", "total_amount", "payment_method", "payment_status", "order_status", "seller_note", "customer_note", "created_at", "updated_at") VALUES ('48', 'NT-2611-5577', '15', NULL, '412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh', '50000.00', '4000.00', '0.00', '54000.00', 'sepay', 'paid', 'confirmed', '[NOTIFY_EMAIL:huuloi2005@gmail.com]', NULL, '2026-11-17T20:28:22.309Z', '2026-11-17T20:28:22.309Z');

-- ------------------------------------------------------------
-- Cấu trúc bảng: order_items
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."order_items" (
    "id" bigint DEFAULT nextval('order_items_id_seq'::regclass) NOT NULL,
    "order_id" bigint NOT NULL,
    "product_id" bigint,
    "variant_id" bigint,
    "product_name" character varying(255) NOT NULL,
    "variant_name" character varying(255),
    "sku" character varying(50) NOT NULL,
    "quantity" integer NOT NULL,
    "unit_price" numeric NOT NULL,
    "cost_price" numeric DEFAULT 0.00 NOT NULL,
    "total_price" numeric NOT NULL,
    CONSTRAINT "order_items_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: order_items (41 bản ghi)
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('6', '5', '20', '20', 'sofa_Ä‘en nhĂ¡m', NULL, 'SOFADEN_NHAM_001', 1, '7500000.00', '4350000.00', '7500000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('7', '6', '12', '12', 'Tá»§ quáº§n Ă¡o 4 cĂ¡nh', NULL, 'SKU-TU-QUAN-AO-4-CANH', 1, '24500000.00', '6380000.00', '24500000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('8', '7', '20', '20', 'sofa_Ä‘en nhĂ¡m', NULL, 'SOFADEN_NHAM_001', 1, '7500000.00', '4350000.00', '7500000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('9', '8', '1', '1', 'Sofa da � Milano', NULL, 'SKU-SOFA-DA-Y-MILANO', 1, '12000000.00', '34160000.00', '12000000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('10', '9', '3', '3', 'Sofa g�c B?c �u', NULL, 'SKU-SOFA-GOC-BAC-AU', 1, '8500000.00', '19080000.00', '8500000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('11', '10', '20', '20', 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, '7500000.00', '4350000.00', '7500000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('12', '11', '20', '20', 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, '7500000.00', '4350000.00', '7500000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('13', '12', '20', '20', 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 2, '7500000.00', '4350000.00', '15000000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('14', '13', '20', '20', 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 2, '7500000.00', '4350000.00', '15000000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('15', '14', '20', '20', 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, '7500000.00', '4350000.00', '7500000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('16', '15', '20', '20', 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, '7500000.00', '4350000.00', '7500000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('17', '16', '20', '20', 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, '7500000.00', '4350000.00', '7500000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('18', '17', '20', '20', 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, '7500000.00', '4350000.00', '7500000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('38', '38', '20', '20', 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, '7500000.00', '4350000.00', '7500000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('41', '41', '20', '20', 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, '7500000.00', '4350000.00', '7500000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('42', '42', '13', '13', 'Kệ tivi treo tường', NULL, 'SKU-KE-TIVI-TREO-TUONG', 1, '9800000.00', '5680000.00', '9800000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('43', '43', '20', '20', 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, '7500000.00', '4350000.00', '7500000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('44', '44', '16', '16', 'Đèn thả trần mây', NULL, 'SKU-DEN-THA-TRAN-MAY', 1, '3400000.00', '1970000.00', '3400000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('45', '45', '20', '20', 'Sofa da bò Ý cao cấp', NULL, 'SOFADEN_NHAM_001', 1, '7500000.00', '4350000.00', '7500000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('46', '46', '12', '12', 'Tủ quần áo 4 cánh', NULL, 'SKU-TU-QUAN-AO-4-CANH', 1, '11000000.00', '6380000.00', '11000000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('47', '47', '12', '12', 'Tủ quần áo 4 cánh', NULL, 'SKU-TU-QUAN-AO-4-CANH', 1, '11000000.00', '6380000.00', '11000000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('19', '18', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '0.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('20', '19', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '0.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('21', '20', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '0.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('22', '21', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '0.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('25', '24', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '0.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('26', '25', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '0.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('27', '26', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '0.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('28', '27', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '0.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('29', '28', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '0.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('30', '29', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '0.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('31', '30', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 2, '2000.00', '0.00', '4000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('32', '31', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '0.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('33', '32', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '0.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('34', '33', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '0.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('35', '35', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 4, '2000.00', '0.00', '8000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('36', '36', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 2, '2000.00', '0.00', '4000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('37', '37', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '1000.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('39', '39', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '1000.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('40', '40', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 1, '2000.00', '1000.00', '2000.00');
INSERT INTO public."order_items" ("id", "order_id", "product_id", "variant_id", "product_name", "variant_name", "sku", "quantity", "unit_price", "cost_price", "total_price") VALUES ('48', '48', '21', '21', 'charm trang trí', NULL, 'CHAM_TRANG_TRI_001', 2, '2000.00', '1160.00', '4000.00');

-- ------------------------------------------------------------
-- Cấu trúc bảng: reviews
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."reviews" (
    "id" bigint DEFAULT nextval('reviews_id_seq'::regclass) NOT NULL,
    "product_id" bigint NOT NULL,
    "user_id" bigint NOT NULL,
    "order_id" bigint NOT NULL,
    "rating" integer NOT NULL,
    "content" text,
    "status" boolean DEFAULT true,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "reviews_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: reviews (1 bản ghi)
INSERT INTO public."reviews" ("id", "product_id", "user_id", "order_id", "rating", "content", "status", "created_at") VALUES ('2', '21', '13', '31', 5, 'very nice', TRUE, '2026-10-26T20:04:28.000Z');

-- ------------------------------------------------------------
-- Cấu trúc bảng: wishlists
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."wishlists" (
    "id" bigint DEFAULT nextval('wishlists_id_seq'::regclass) NOT NULL,
    "user_id" bigint NOT NULL,
    "product_id" bigint NOT NULL,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "wishlists_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: wishlists (16 bản ghi)
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('2', '4', '13', '2026-10-16T01:09:57.000Z');
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('4', '5', '16', '2026-10-21T19:47:34.000Z');
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('5', '7', '21', '2026-11-04T00:44:02.000Z');
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('6', '7', '20', '2026-11-04T00:44:04.000Z');
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('7', '7', '12', '2026-11-04T00:44:06.000Z');
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('15', '15', '16', '2026-11-12T06:23:16.000Z');
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('16', '15', '17', '2026-11-12T06:23:17.000Z');
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('17', '15', '1', '2026-11-12T06:23:18.000Z');
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('18', '15', '21', '2026-11-12T06:35:01.000Z');
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('19', '15', '12', '2026-11-12T06:35:04.000Z');
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('20', '15', '20', '2026-11-19T19:54:46.072Z');
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('21', '15', '13', '2026-11-19T19:54:50.828Z');
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('22', '15', '14', '2026-11-19T19:54:59.618Z');
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('23', '15', '15', '2026-11-19T19:55:01.654Z');
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('24', '15', '18', '2026-11-19T19:55:05.647Z');
INSERT INTO public."wishlists" ("id", "user_id", "product_id", "created_at") VALUES ('25', '15', '19', '2026-11-19T19:55:07.254Z');

-- ------------------------------------------------------------
-- Cấu trúc bảng: chat_sessions
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."chat_sessions" (
    "id" bigint DEFAULT nextval('chat_sessions_id_seq'::regclass) NOT NULL,
    "user_id" bigint,
    "guest_id" character varying(255),
    "status" chat_sessions_status DEFAULT 'bot_handling'::chat_sessions_status,
    "started_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "ended_at" timestamp without time zone,
    CONSTRAINT "chat_sessions_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: chat_sessions (3 bản ghi)
INSERT INTO public."chat_sessions" ("id", "user_id", "guest_id", "status", "started_at", "ended_at") VALUES ('1', '15', 'guest_mvhqiq99_b6ri', 'bot_handling', '2026-10-29T03:47:11.000Z', NULL);
INSERT INTO public."chat_sessions" ("id", "user_id", "guest_id", "status", "started_at", "ended_at") VALUES ('2', '15', 'guest_mvhqiq99_b6ri', 'bot_handling', '2026-10-29T04:47:31.000Z', NULL);
INSERT INTO public."chat_sessions" ("id", "user_id", "guest_id", "status", "started_at", "ended_at") VALUES ('3', '15', 'guest_mvhqiq99_b6ri', 'bot_handling', '2026-11-12T05:28:21.000Z', NULL);

-- ------------------------------------------------------------
-- Cấu trúc bảng: chat_messages
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."chat_messages" (
    "id" bigint DEFAULT nextval('chat_messages_id_seq'::regclass) NOT NULL,
    "session_id" bigint NOT NULL,
    "sender_type" chat_messages_sender_type NOT NULL,
    "sender_id" bigint,
    "content" text NOT NULL,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "chat_messages_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: chat_messages (6 bản ghi)
INSERT INTO public."chat_messages" ("id", "session_id", "sender_type", "sender_id", "content", "created_at") VALUES ('1', '1', 'customer', '15', 'Sinh năm 1995 (Ất Hợi) nên chọn sofa màu gì?', '2026-10-29T03:47:11.000Z');
INSERT INTO public."chat_messages" ("id", "session_id", "sender_type", "sender_id", "content", "created_at") VALUES ('2', '1', 'ai_bot', NULL, 'Dạ, chào quý khách! Tôi là Chuyên gia tư vấn Phong Thủy & Nội Thất của **KTUFA Luxury Furniture**. Rất vinh hạnh được đồng hành cùng quý khách trên hành trình kiến tạo một không gian sống thịnh vượng và viên mãn.\n\nĐối với gia chủ sinh năm **1995 (tuổi Ất Hợi)**, việc lựa chọn màu sắc cho bộ sofa – trái tim của phòng khách – đóng vai trò vô cùng quan trọng để chiêu tài hút lộc, mang lại bình an và vượng khí cho gia đình. Dưới đây là những tư vấn chuyên sâu từ **KTUFA Luxury Furniture**:\n\n### 1. Phân tích Bản mệnh & Ngũ hành\n* **Năm sinh âm lịch:** 1995 – Ất Hợi (Con lợn).\n* **Ngũ hành nạp âm:** **Sơn Đầu Hỏa** (Lửa trên núi).\n\nTheo quy luật ngũ hành tương sinh - tương khắc, để chọn màu sắc sofa mang lại may mắn, chúng ta ưu tiên các gam màu tương hợp (cùng hành Hỏa) và tương sinh (Hỏa sinh Thổ hoặc Mộc sinh Hỏa).\n\n### 2. Gợi ý màu sắc Sofa chuẩn phong thủy cho tuổi Ất Hợi (1995)\n\n* **Màu tương hợp (Hành Hỏa):** \n  * *Màu sắc:* Đỏ, hồng, tím, cam đậm.\n  * *Ý nghĩa:* Tăng cường năng lượng bản mệnh, mang lại sự nhiệt huyết, may mắn và tài lộc dồi dào. \n  * *Gợi ý từ **KTUFA Luxury Furniture** phối nội thất:* Quý khách có thể chọn các mẫu sofa da cao cấp bọc da tông màu đỏ đô sang trọng hoặc điểm xuyết gối ôm màu cam/hồng trầm để tạo điểm nhấn quyền quý cho phòng khách mà vẫn giữ được sự nhã nhặn.\n\n* **Màu tương sinh (Hành Mộc - Mộc sinh Hỏa):** \n  * *Màu sắc:* Xanh lá cây, xanh rêu, xanh lục.\n  * *Ý nghĩa:* Mộc sinh Hỏa là mối quan hệ sinh trưởng, giúp gia chủ gặp nhiều quý nhân phù trợ, công danh sự nghiệp phát triển vững chắc, sức khỏe hanh thông.\n  * *Gợi ý từ **KTUFA Luxury Furniture** phối nội thất:* Một bộ sofa da bò Ý cao cấp kết hợp với khung gỗ óc chó tự nhiên (Mộc sinh Hỏa cực tốt) hoặc một thiết kế sofa bọc nỉ nhung cao cấp màu xanh rêu trầm sẽ là lựa chọn hoàn hảo, vừa hợp phong thủy vừa mang đậm hơi thở kiến trúc thượng lưu.\n\n### 3. Các màu sắc đại kỵ cần tránh\n* **Màu thuộc hành Thủy (Thủy khắc Hỏa):** Đen, xanh dương, xanh nước biển. \n  * *Lý do:* Nước dập tắt lửa, mang theo năng lượng xung khắc, dễ gây cản trở tài lộc và bất ổn trong gia đạo. Do đó, quý khách tuyệt đối nên tránh chọn sofa có tông màu chủ đạo này.\n* **Màu thuộc hành Kim (Hỏa khắc Kim):** Trắng, xám, ánh kim (mặc dù Hỏa khắc Kim nhưng năng lượng của Hỏa sẽ bị tiêu hao khi \"khắc\", không có lợi cho gia chủ).\n\n### 4. Gợi ý không gian từ KTUFA Luxury Furniture\nĐể tối ưu hóa năng lượng phong thủy cho phòng khách tuổi Ất Hợi 1995, khi bài trí sofa, quý khách cũng nên lưu ý:\n* **Vị trí đặt sofa:** Nên kê sofa tựa lưng vào bức tường vững chãi (tọa sơn) để tạo thế \"vững như bàn thạch\", hướng nhìn ra không gian mở hoặc cửa chính (nhưng không đối diện trực diện) để đón tài khí.\n* **Chất liệu đề xuất:** Các dòng **sofa da thật cao cấp** kết hợp chân gỗ tự nhiên hoặc **sofa bọc vải nhung cao cấp** của **KTUFA Luxury Furniture** không chỉ đạt chuẩn kích thước phong thủy theo Thước Lỗ Ban mà còn mang đến cảm giác êm ái, tụ khí tốt cho ngôi nhà.\n\nMời quý khách ghé thăm website của **KTUFA Luxury Furniture** để tham khảo các bộ sưu tập sofa phòng khách thượng hạng được thiết kế riêng cho từng bản mệnh. Không gian sống đẳng cấp và vượng khí của quý khách đang chờ được hoàn thiện! \n\nQuý khách có cần tôi tư vấn thêm về hướng đặt sofa hay cách phối màu nội thất cho không gian phòng khách này không ạ?', '2026-10-29T03:47:11.000Z');
INSERT INTO public."chat_messages" ("id", "session_id", "sender_type", "sender_id", "content", "created_at") VALUES ('3', '2', 'customer', '15', '[Studio Bát Trạch] Gia chủ Nam mạng sinh năm 2001 · Không gian: Phòng ăn · Cung Càn (Kim)', '2026-10-29T04:47:31.000Z');
INSERT INTO public."chat_messages" ("id", "session_id", "sender_type", "sender_id", "content", "created_at") VALUES ('4', '2', 'ai_bot', NULL, 'Kính chào Quý gia chủ sinh năm 2001 (Nam mạng), thuộc cung Càn, hành Kim. Với tư cách là Chuyên gia Phong thủy của **KTUFA Luxury Furniture**, tôi xin gửi tới anh luận giải chuyên sâu và tinh tế cho không gian **Phòng ăn** – nơi giữ lửa hạnh phúc và vượng khí cho gia đình.\n\n*   **Nhận định phong thủy tổng quan:** Nam mạng sinh năm 2001 thuộc Tây tứ mệnh, hợp với các hướng Tây, Tây Nam, Tây Bắc và Đông Bắc. Phòng ăn là không gian dung dưỡng nguồn năng lượng Thổ (thức ăn) sinh Kim (bản mệnh), tượng trưng cho sự sung túc và bền vững. Việc bố trí phòng ăn tọa lạc ở các cung tốt sẽ giúp gia chủ kích hoạt tài vận, gia đạo hưng thịnh, các mối quan hệ xã hội rộng mở và luôn gặp quý nhân phù trợ.\n*   **Bố trí đồ đạc chiêu tài đón lộc:** \n    *   *Hướng bàn ăn:* Nên đặt bàn ăn quay về các hướng sinh khí như Tây Nam (Diên Niên) hoặc Tây (Sinh Khí) để thu hút tài lộc và sự hòa hợp.\n    *   *Vị trí tựa lưng:* Ghế ngồi của gia chủ khi dùng bữa nên hướng ra cửa chính hoặc đặt ở vị trí có tầm nhìn bao quát, phía sau có tường vững chắc làm \"thế tựa sơn\" tạo sự vững chãi, tự tin trong sự nghiệp.\n    *   *Ánh sáng:* Ưu tiên ánh sáng vàng ấm áp từ hệ thống đèn chùm pha lê đặt giữa bàn ăn, tượng trưng cho sự trọn vẹn, sung túc và giúp kích thích vị giác, gắn kết tình cảm gia đình.\n*   **Chất liệu & Màu sắc nội thất tương sinh:** \n    *   *Màu sắc:* Bản mệnh Kim rất hợp với các tông màu thuần khiết như trắng, bạc, ánh kim, kết hợp hài hòa với màu vàng ấm, nâu đất của hành Thổ (Thổ sinh Kim) như màu gỗ sồi tự nhiên, màu da bò. Tránh các màu khắc như đỏ, hồng thuộc hành Hỏa.\n    *   *Chất liệu:* KTUFA Luxury Furniture khuyên dùng bàn ăn mặt đá marble cao cấp (đại diện cho hành Thổ và Kim) kết hợp chân bàn inox mạ PVD ánh vàng sang trọng, đi kèm ghế bọc da Ý mềm mại. Sự kết hợp này không chỉ nâng tầm đẳng cấp không gian mà còn tạo chuỗi ngũ hành tương sinh hoàn hảo, mang lại bình an và tài lộc viên mãn cho gia chủ trẻ tuổi.', '2026-10-29T04:47:31.000Z');
INSERT INTO public."chat_messages" ("id", "session_id", "sender_type", "sender_id", "content", "created_at") VALUES ('5', '3', 'customer', '15', 'hi', '2026-11-12T05:28:21.000Z');
INSERT INTO public."chat_messages" ("id", "session_id", "sender_type", "sender_id", "content", "created_at") VALUES ('6', '3', 'ai_bot', NULL, 'Dạ, KTUFA Luxury Furniture xin kính chào quý khách! \n\nTôi là Chuyên gia tư vấn Phong Thủy & Nội Thất cao cấp của **KTUFA Luxury Furniture**. Rất hân hạnh được đồng hành cùng quý khách trên hành trình kiến tạo một không gian sống sang trọng, thịnh vượng và chuẩn phong thủy Á Đông.\n\nQuý khách đang quan tâm đến việc bài trí không gian phòng khách, phòng ngủ, hay cần tư vấn màu sắc, chất liệu nội thất hợp bản mệnh nào để mang lại tài lộc và bình an cho gia đình? Hãy chia sẻ với tôi để **KTUFA Luxury Furniture** được phục vụ quý khách chu đáo nhất nhé!', '2026-11-12T05:28:21.000Z');

-- ------------------------------------------------------------
-- Cấu trúc bảng: cash_transactions
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."cash_transactions" (
    "id" bigint DEFAULT nextval('cash_transactions_id_seq'::regclass) NOT NULL,
    "code" character varying(50) NOT NULL,
    "type" cash_transactions_type NOT NULL,
    "category" character varying(100) NOT NULL,
    "amount" numeric DEFAULT 0.00 NOT NULL,
    "payment_method" cash_transactions_payment_method DEFAULT 'cash'::cash_transactions_payment_method NOT NULL,
    "reference_code" character varying(50),
    "performer_id" bigint,
    "recipient_name" character varying(150),
    "note" text,
    "status" character varying(50) DEFAULT 'completed'::character varying NOT NULL,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "cash_transactions_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: cash_transactions (10 bản ghi)
INSERT INTO public."cash_transactions" ("id", "code", "type", "category", "amount", "payment_method", "reference_code", "performer_id", "recipient_name", "note", "status", "created_at") VALUES ('1', 'PC-202609-001', 'expense', 'import_payment', '182000000.00', 'bank', 'PN-202609-001', '1', 'XÆ°á»Ÿng Gá»— Tá»± NhiÃªn Báº¯c Ã‚u', 'Chuyá»ƒn khoáº£n thanh toÃ¡n tiá»n hÃ ng phiáº¿u PN-202609-001', 'completed', '2026-09-10T03:00:00.000Z');
INSERT INTO public."cash_transactions" ("id", "code", "type", "category", "amount", "payment_method", "reference_code", "performer_id", "recipient_name", "note", "status", "created_at") VALUES ('2', 'PC-202610-001', 'expense', 'import_payment', '223000000.00', 'bank', 'PN-202610-001', '1', 'Ná»™i Tháº¥t Da Ã Milano', 'Chuyá»ƒn khoáº£n thanh toÃ¡n phiáº¿u nháº­p PN-202610-001', 'completed', '2026-10-05T08:30:00.000Z');
INSERT INTO public."cash_transactions" ("id", "code", "type", "category", "amount", "payment_method", "reference_code", "performer_id", "recipient_name", "note", "status", "created_at") VALUES ('3', 'PC-202610-002', 'expense', 'import_payment', '100000000.00', 'bank', 'PN-202610-002', '1', 'Tá»•ng Kho ÄÃ¡ Tá»± NhiÃªn Carrara', 'Táº¡m á»©ng Ä‘á»£t 1 phiáº¿u nháº­p PN-202610-002', 'completed', '2026-10-18T04:00:00.000Z');
INSERT INTO public."cash_transactions" ("id", "code", "type", "category", "amount", "payment_method", "reference_code", "performer_id", "recipient_name", "note", "status", "created_at") VALUES ('4', 'PC-202610-003', 'expense', 'import_payment', '46000000.00', 'cash', 'PN-202610-003', '1', 'XÆ°á»Ÿng ÄÃ¨n Thá»§ CÃ´ng BÃ¡t TrÃ ng', 'Chi tiá»n máº·t thanh toÃ¡n trá»±c tiáº¿p táº¡i showroom phiáº¿u PN-202610-003', 'completed', '2026-10-24T09:45:00.000Z');
INSERT INTO public."cash_transactions" ("id", "code", "type", "category", "amount", "payment_method", "reference_code", "performer_id", "recipient_name", "note", "status", "created_at") VALUES ('5', 'PT-202610-001', 'income', 'order_bank', '58900000.00', 'bank', 'DH-20261005-01', '1', 'KhÃ¡ch hÃ ng Tráº§n VÄƒn Test', 'Thanh toÃ¡n chuyá»ƒn khoáº£n VietQR Ä‘Æ¡n hÃ ng DH-20261005-01', 'completed', '2026-10-05T09:20:00.000Z');
INSERT INTO public."cash_transactions" ("id", "code", "type", "category", "amount", "payment_method", "reference_code", "performer_id", "recipient_name", "note", "status", "created_at") VALUES ('6', 'PT-202610-002', 'income', 'order_bank', '32500000.00', 'bank', 'DH-20261012-02', '1', 'KhÃ¡ch hÃ ng Äáº·ng Tháº£o Vy', 'Thanh toÃ¡n chuyá»ƒn khoáº£n VietQR Ä‘Æ¡n hÃ ng DH-20261012-02', 'completed', '2026-10-12T04:15:00.000Z');
INSERT INTO public."cash_transactions" ("id", "code", "type", "category", "amount", "payment_method", "reference_code", "performer_id", "recipient_name", "note", "status", "created_at") VALUES ('7', 'PT-202610-003', 'income', 'order_cod', '18900000.00', 'cash', 'DH-20261015-03', '1', 'Shipper Giao HÃ ng Tiáº¿t Kiá»‡m', 'Thu ngÃ¢n nháº­n tiá»n máº·t COD tá»« shipper Ä‘Æ¡n DH-20261015-03', 'completed', '2026-10-15T10:30:00.000Z');
INSERT INTO public."cash_transactions" ("id", "code", "type", "category", "amount", "payment_method", "reference_code", "performer_id", "recipient_name", "note", "status", "created_at") VALUES ('8', 'PT-202610-004', 'income', 'order_cod', '4420000.00', 'cash', 'DH-20261022-04', '1', 'Shipper Viettel Post', 'Thu ngÃ¢n nháº­n tiá»n máº·t COD tá»« shipper Ä‘Æ¡n DH-20261022-04', 'completed', '2026-10-22T11:00:00.000Z');
INSERT INTO public."cash_transactions" ("id", "code", "type", "category", "amount", "payment_method", "reference_code", "performer_id", "recipient_name", "note", "status", "created_at") VALUES ('9', 'PC-202610-7189', 'expense', 'import_payment', '5000.00', 'cash', 'PN-202610-005', '1', 'Xưởng Nội Thất Châu Âu', 'Chi thanh toán phiếu nhập kho PN-202610-005 cho Xưởng Nội Thất Châu Âu', 'completed', '2026-10-29T03:25:07.000Z');
INSERT INTO public."cash_transactions" ("id", "code", "type", "category", "amount", "payment_method", "reference_code", "performer_id", "recipient_name", "note", "status", "created_at") VALUES ('10', 'PC-202610-6814', 'expense', 'import_payment', '5000.00', 'cash', 'PN-202610-006', '1', 'Công Ty Sofa Cao Cấp Nhà K', 'Chi thanh toán phiếu nhập kho PN-202610-006 cho Công Ty Sofa Cao Cấp Nhà K', 'completed', '2026-10-29T03:39:46.000Z');

-- ------------------------------------------------------------
-- Cấu trúc bảng: email_campaigns
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."email_campaigns" (
    "id" integer DEFAULT nextval('email_campaigns_id_seq'::regclass) NOT NULL,
    "code" character varying(50) NOT NULL,
    "title" character varying(255) NOT NULL,
    "target_audience" character varying(100) DEFAULT 'all'::character varying NOT NULL,
    "recipients_count" integer DEFAULT 0 NOT NULL,
    "action_type" character varying(50) DEFAULT 'send-now'::character varying NOT NULL,
    "status" character varying(50) DEFAULT 'Đã hoàn tất'::character varying NOT NULL,
    "content" text NOT NULL,
    "open_rate" numeric DEFAULT 0.00 NOT NULL,
    "click_rate" numeric DEFAULT 0.00 NOT NULL,
    "sent_count" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "email_campaigns_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: email_campaigns (3 bản ghi)
INSERT INTO public."email_campaigns" ("id", "code", "title", "target_audience", "recipients_count", "action_type", "status", "content", "open_rate", "click_rate", "sent_count", "created_at", "updated_at") VALUES (1, 'CAM-001', 'Chào mừng thành viên mới - Nhận ngay Voucher 10% đơn đầu tiên', 'Tất cả khách hàng', 9, 'send-now', 'Đã hoàn tất', 'Kính gửi Quý khách hàng,\n\nCảm ơn Quý khách đã đăng ký thành viên tại Cửa hàng Nội Thất. Để bắt đầu hành trình kiến tạo không gian sống mơ ước, chúng tôi xin gửi tặng Quý khách mã giảm giá 10% cho đơn hàng đầu tiên: WELCOME2026.\n\nChúc Quý khách có trải nghiệm mua sắm tuyệt vời!', '88.50', '42.00', 9, '2026-10-20T07:59:13.000Z', '2026-10-23T07:59:13.000Z');
INSERT INTO public."email_campaigns" ("id", "code", "title", "target_audience", "recipients_count", "action_type", "status", "content", "open_rate", "click_rate", "sent_count", "created_at", "updated_at") VALUES (2, 'CAM-002', 'Tri ân Hội viên VIP - Ra mắt Bộ sưu tập Gỗ Óc Chó Mùa Thu 2026', 'Hội viên VIP (Kim Cương / Vàng)', 2, 'send-now', 'Đã hoàn tất', 'Kính gửi Hội viên VIP,\n\nNhân dịp ra mắt bộ sưu tập nội thất cao cấp Mùa Thu 2026, Nội Thất trân trọng kính mời Quý khách trải nghiệm những tuyệt tác gỗ tự nhiên mới nhất với ưu đãi đặc quyền lên tới 20% cùng dịch vụ tư vấn thiết kế phong thủy miễn phí.\n\nTrân trọng cảm ơn sự đồng hành của Quý khách!', '95.00', '68.50', 2, '2026-10-22T07:59:13.000Z', '2026-10-23T07:59:13.000Z');
INSERT INTO public."email_campaigns" ("id", "code", "title", "target_audience", "recipients_count", "action_type", "status", "content", "open_rate", "click_rate", "sent_count", "created_at", "updated_at") VALUES (3, 'CAM-003', 'Khuyến mãi cuối tuần - Giảm 15% Sofa & Bàn Ăn', 'Tất cả khách hàng (9 khách)', 9, 'send-now', 'Đã hoàn tất', 'Chương trình ưu đãi giảm 15% toàn bộ sản phẩm Sofa da Ý và Bàn ăn mặt đá cao cấp duy nhất cuối tuần này.', '85.50', '38.00', 9, '2026-10-23T07:59:39.000Z', '2026-10-23T07:59:39.000Z');

-- ------------------------------------------------------------
-- Cấu trúc bảng: import_slips
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."import_slips" (
    "id" bigint DEFAULT nextval('import_slips_id_seq'::regclass) NOT NULL,
    "slip_code" character varying(50) NOT NULL,
    "supplier_id" integer,
    "user_id" bigint,
    "total_items" integer DEFAULT 0 NOT NULL,
    "subtotal_amount" numeric DEFAULT 0.00 NOT NULL,
    "discount_amount" numeric DEFAULT 0.00 NOT NULL,
    "tax_amount" numeric DEFAULT 0.00 NOT NULL,
    "shipping_fee" numeric DEFAULT 0.00 NOT NULL,
    "total_amount" numeric DEFAULT 0.00 NOT NULL,
    "paid_amount" numeric DEFAULT 0.00 NOT NULL,
    "debt_amount" numeric DEFAULT 0.00 NOT NULL,
    "payment_method" character varying(50) DEFAULT 'cash'::character varying NOT NULL,
    "payment_status" character varying(50) DEFAULT 'unpaid'::character varying NOT NULL,
    "status" character varying(50) DEFAULT 'completed'::character varying NOT NULL,
    "import_date" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "note" text,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "import_slips_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: import_slips (6 bản ghi)
INSERT INTO public."import_slips" ("id", "slip_code", "supplier_id", "user_id", "total_items", "subtotal_amount", "discount_amount", "tax_amount", "shipping_fee", "total_amount", "paid_amount", "debt_amount", "payment_method", "payment_status", "status", "import_date", "note", "created_at", "updated_at") VALUES ('1', 'PN-202609-001', 1, '1', 15, '185000000.00', '5000000.00', '0.00', '2000000.00', '182000000.00', '182000000.00', '0.00', 'bank', 'paid', 'completed', '2026-09-10T02:30:00.000Z', 'Nháº­p lÃ´ bÃ n Äƒn gá»— sá»“i vÃ  ká»‡ tivi phá»¥c vá»¥ mÃ¹a cao Ä‘iá»ƒm cuá»‘i nÄƒm', '2026-09-10T02:30:00.000Z', '2026-10-29T08:47:05.000Z');
INSERT INTO public."import_slips" ("id", "slip_code", "supplier_id", "user_id", "total_items", "subtotal_amount", "discount_amount", "tax_amount", "shipping_fee", "total_amount", "paid_amount", "debt_amount", "payment_method", "payment_status", "status", "import_date", "note", "created_at", "updated_at") VALUES ('2', 'PN-202610-001', 2, '1', 10, '220000000.00', '0.00', '0.00', '3000000.00', '223000000.00', '223000000.00', '0.00', 'bank', 'paid', 'completed', '2026-10-05T07:00:00.000Z', 'Nháº­p da bÃ² Ã cao cáº¥p vÃ  khung gháº¿ thÆ° giÃ£n Ã³c chÃ³', '2026-10-05T07:00:00.000Z', '2026-10-29T08:47:05.000Z');
INSERT INTO public."import_slips" ("id", "slip_code", "supplier_id", "user_id", "total_items", "subtotal_amount", "discount_amount", "tax_amount", "shipping_fee", "total_amount", "paid_amount", "debt_amount", "payment_method", "payment_status", "status", "import_date", "note", "created_at", "updated_at") VALUES ('3', 'PN-202610-002', 3, '1', 8, '140000000.00', '2000000.00', '0.00', '1500000.00', '139500000.00', '100000000.00', '39500000.00', 'bank', 'partial', 'completed', '2026-10-18T03:15:00.000Z', 'Nháº­p máº·t Ä‘Ã¡ Carrara, thanh toÃ¡n trÆ°á»›c 100tr, cÃ²n ná»£ 39.5tr Ä‘áº¿n cuá»‘i thÃ¡ng', '2026-10-18T03:15:00.000Z', '2026-10-29T08:47:05.000Z');
INSERT INTO public."import_slips" ("id", "slip_code", "supplier_id", "user_id", "total_items", "subtotal_amount", "discount_amount", "tax_amount", "shipping_fee", "total_amount", "paid_amount", "debt_amount", "payment_method", "payment_status", "status", "import_date", "note", "created_at", "updated_at") VALUES ('4', 'PN-202610-003', 4, '1', 25, '45000000.00', '0.00', '0.00', '1000000.00', '46000000.00', '46000000.00', '0.00', 'cash', 'paid', 'completed', '2026-10-24T09:30:00.000Z', 'Nháº­p Ä‘Ã¨n tháº£ tráº§n vÃ  Ä‘Ã¨n sÃ n Ä‘á»“ng thau tráº£ tiá»n máº·t trá»±c tiáº¿p', '2026-10-24T09:30:00.000Z', '2026-10-29T08:47:05.000Z');
INSERT INTO public."import_slips" ("id", "slip_code", "supplier_id", "user_id", "total_items", "subtotal_amount", "discount_amount", "tax_amount", "shipping_fee", "total_amount", "paid_amount", "debt_amount", "payment_method", "payment_status", "status", "import_date", "note", "created_at", "updated_at") VALUES ('5', 'PN-202610-005', 1, '1', 2, '5000.00', '0.00', '0.00', '0.00', '5000.00', '5000.00', '0.00', 'cash', 'paid', 'completed', '2026-10-28T17:00:00.000Z', NULL, '2026-10-29T03:25:07.000Z', '2026-10-29T03:25:07.000Z');
INSERT INTO public."import_slips" ("id", "slip_code", "supplier_id", "user_id", "total_items", "subtotal_amount", "discount_amount", "tax_amount", "shipping_fee", "total_amount", "paid_amount", "debt_amount", "payment_method", "payment_status", "status", "import_date", "note", "created_at", "updated_at") VALUES ('6', 'PN-202610-006', 2, '1', 5, '5000.00', '0.00', '0.00', '0.00', '5000.00', '5000.00', '0.00', 'cash', 'paid', 'completed', '2026-10-28T17:00:00.000Z', NULL, '2026-10-29T03:39:46.000Z', '2026-10-29T03:39:46.000Z');

-- ------------------------------------------------------------
-- Cấu trúc bảng: import_slip_items
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."import_slip_items" (
    "id" bigint DEFAULT nextval('import_slip_items_id_seq'::regclass) NOT NULL,
    "slip_id" bigint NOT NULL,
    "product_id" bigint,
    "variant_id" bigint,
    "sku" character varying(50) NOT NULL,
    "product_name" character varying(255) NOT NULL,
    "variant_name" character varying(255),
    "quantity" integer DEFAULT 1 NOT NULL,
    "import_price" numeric DEFAULT 0.00 NOT NULL,
    "selling_price" numeric DEFAULT 0.00 NOT NULL,
    "total_price" numeric DEFAULT 0.00 NOT NULL,
    "note" character varying(255),
    CONSTRAINT "import_slip_items_pkey" PRIMARY KEY ("id")
);

-- Dữ liệu cho bảng: import_slip_items (9 bản ghi)
INSERT INTO public."import_slip_items" ("id", "slip_id", "product_id", "variant_id", "sku", "product_name", "variant_name", "quantity", "import_price", "selling_price", "total_price", "note") VALUES ('1', '1', '5', '5', 'SKU-BAN-AN-GO-SOI-NGA', 'BÃ n Ä‚n Gá»— Sá»“i Nga Scandinavian', 'MÃ u Gá»— Tá»± NhiÃªn', 10, '11000000.00', '18900000.00', '110000000.00', NULL);
INSERT INTO public."import_slip_items" ("id", "slip_id", "product_id", "variant_id", "sku", "product_name", "variant_name", "quantity", "import_price", "selling_price", "total_price", "note") VALUES ('2', '1', '14', '14', 'SKU-KE-TIVI-TREO-TUONG', 'Ká»‡ Tivi Treo TÆ°á»ng Hiá»‡n Äáº¡i', 'Gá»— Walnut Sá»“i', 5, '15000000.00', '24500000.00', '75000000.00', NULL);
INSERT INTO public."import_slip_items" ("id", "slip_id", "product_id", "variant_id", "sku", "product_name", "variant_name", "quantity", "import_price", "selling_price", "total_price", "note") VALUES ('3', '2', '1', '1', 'SKU-SOFA-DA-Y-MILANO', 'Sofa Da BÃ² Ã Milano Grand', 'Da BÃ² MÃ u NÃ¢u Háº¡t Dáº»', 4, '34000000.00', '58900000.00', '136000000.00', NULL);
INSERT INTO public."import_slip_items" ("id", "slip_id", "product_id", "variant_id", "sku", "product_name", "variant_name", "quantity", "import_price", "selling_price", "total_price", "note") VALUES ('4', '2', '7', '7', 'SKU-GHE-THU-GIAN-GO-OC-CHO', 'Gháº¿ ThÆ° GiÃ£n Lounge Gá»— Ã“c ChÃ³', 'Gá»— Ã“c ChÃ³ Báº¯c Má»¹', 6, '14000000.00', '24500000.00', '84000000.00', NULL);
INSERT INTO public."import_slip_items" ("id", "slip_id", "product_id", "variant_id", "sku", "product_name", "variant_name", "quantity", "import_price", "selling_price", "total_price", "note") VALUES ('5', '3', '4', '4', 'SKU-BAN-AN-DA-MARBLE-CARRARA', 'BÃ n Ä‚n Máº·t ÄÃ¡ Cáº©m Tháº¡ch Carrara', 'ÄÃ¡ Tráº¯ng Carrara', 8, '17500000.00', '32500000.00', '140000000.00', NULL);
INSERT INTO public."import_slip_items" ("id", "slip_id", "product_id", "variant_id", "sku", "product_name", "variant_name", "quantity", "import_price", "selling_price", "total_price", "note") VALUES ('6', '4', '16', '16', 'SKU-DEN-SAN-DONG-THAU', 'ÄÃ¨n SÃ n Äá»©ng ThÃ¢n Äá»“ng Thau Báº¯c Ã‚u', 'Äá»“ng Thau Cá»• Äiá»ƒn', 15, '1800000.00', '3200000.00', '27000000.00', NULL);
INSERT INTO public."import_slip_items" ("id", "slip_id", "product_id", "variant_id", "sku", "product_name", "variant_name", "quantity", "import_price", "selling_price", "total_price", "note") VALUES ('7', '4', '17', '17', 'SKU-DEN-THA-TRAN-MAY', 'ÄÃ¨n Tháº£ Tráº§n Thá»§ CÃ´ng Sá»£i MÃ¢y Äan', 'MÃ¢y Tre Äan Tá»± NhiÃªn', 10, '1800000.00', '2900000.00', '18000000.00', NULL);
INSERT INTO public."import_slip_items" ("id", "slip_id", "product_id", "variant_id", "sku", "product_name", "variant_name", "quantity", "import_price", "selling_price", "total_price", "note") VALUES ('8', '5', '1', '1', 'SKU-TEST', 'Test Nhập Hàng', 'Da bò Ý', 2, '2500.00', '5000.00', '5000.00', NULL);
INSERT INTO public."import_slip_items" ("id", "slip_id", "product_id", "variant_id", "sku", "product_name", "variant_name", "quantity", "import_price", "selling_price", "total_price", "note") VALUES ('9', '6', '21', '21', 'cham-trang-tri', 'cham trang trí', 'gốm', 5, '1000.00', '2000.00', '5000.00', NULL);

-- ------------------------------------------------------------
-- Cấu trúc bảng: shopping_carts
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."shopping_carts" (
    "id" bigint DEFAULT nextval('shopping_carts_id_seq'::regclass) NOT NULL,
    "user_id" bigint,
    "session_id" character varying(255),
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "shopping_carts_pkey" PRIMARY KEY ("id")
);

-- Bảng shopping_carts hiện chưa có bản ghi nào.

-- ------------------------------------------------------------
-- Cấu trúc bảng: cart_items
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."cart_items" (
    "id" bigint DEFAULT nextval('cart_items_id_seq'::regclass) NOT NULL,
    "cart_id" bigint NOT NULL,
    "variant_id" bigint NOT NULL,
    "quantity" integer NOT NULL,
    CONSTRAINT "cart_items_pkey" PRIMARY KEY ("id")
);

-- Bảng cart_items hiện chưa có bản ghi nào.

-- ------------------------------------------------------------
-- Cấu trúc bảng: showcases
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."showcases" (
    "id" integer DEFAULT nextval('showcases_id_seq'::regclass) NOT NULL,
    "title" character varying(255) NOT NULL,
    "subtitle" character varying(255),
    "image_url" text,
    "link_url" character varying(255) DEFAULT '/san-pham'::character varying,
    "display_order" integer DEFAULT 0,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "showcases_pkey" PRIMARY KEY ("id")
);

-- Bảng showcases hiện chưa có bản ghi nào.

-- ------------------------------------------------------------
-- Cấu trúc bảng: system_logs
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public."system_logs" (
    "id" bigint DEFAULT nextval('system_logs_id_seq'::regclass) NOT NULL,
    "user_id" bigint NOT NULL,
    "action" character varying(100) NOT NULL,
    "description" text,
    "ip_address" character varying(45),
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "system_logs_pkey" PRIMARY KEY ("id")
);

-- Bảng system_logs hiện chưa có bản ghi nào.

-- ------------------------------------------------------------
-- Đồng bộ Sequence cho các cột ID tự tăng (SERIAL / BIGSERIAL)
-- ------------------------------------------------------------
SELECT setval(pg_get_serial_sequence('public."roles"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."roles";
SELECT setval(pg_get_serial_sequence('public."users"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."users";
SELECT setval(pg_get_serial_sequence('public."user_addresses"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."user_addresses";
SELECT setval(pg_get_serial_sequence('public."password_otps"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."password_otps";
SELECT setval(pg_get_serial_sequence('public."bot_prompts"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."bot_prompts";
SELECT setval(pg_get_serial_sequence('public."categories"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."categories";
SELECT setval(pg_get_serial_sequence('public."spaces"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."spaces";
SELECT setval(pg_get_serial_sequence('public."suppliers"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."suppliers";
SELECT setval(pg_get_serial_sequence('public."coupons"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."coupons";
SELECT setval(pg_get_serial_sequence('public."products"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."products";
SELECT setval(pg_get_serial_sequence('public."product_variants"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."product_variants";
SELECT setval(pg_get_serial_sequence('public."product_images"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."product_images";
SELECT setval(pg_get_serial_sequence('public."banners"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."banners";
SELECT setval(pg_get_serial_sequence('public."orders"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."orders";
SELECT setval(pg_get_serial_sequence('public."order_items"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."order_items";
SELECT setval(pg_get_serial_sequence('public."reviews"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."reviews";
SELECT setval(pg_get_serial_sequence('public."wishlists"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."wishlists";
SELECT setval(pg_get_serial_sequence('public."chat_sessions"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."chat_sessions";
SELECT setval(pg_get_serial_sequence('public."chat_messages"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."chat_messages";
SELECT setval(pg_get_serial_sequence('public."cash_transactions"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."cash_transactions";
SELECT setval(pg_get_serial_sequence('public."email_campaigns"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."email_campaigns";
SELECT setval(pg_get_serial_sequence('public."import_slips"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."import_slips";
SELECT setval(pg_get_serial_sequence('public."import_slip_items"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."import_slip_items";
SELECT setval(pg_get_serial_sequence('public."shopping_carts"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."shopping_carts";
SELECT setval(pg_get_serial_sequence('public."cart_items"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."cart_items";
SELECT setval(pg_get_serial_sequence('public."showcases"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."showcases";
SELECT setval(pg_get_serial_sequence('public."system_logs"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."system_logs";
