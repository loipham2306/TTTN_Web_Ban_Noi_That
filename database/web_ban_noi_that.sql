-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: web_ban_noi_that
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `web_ban_noi_that`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `web_ban_noi_that` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `web_ban_noi_that`;

--
-- Table structure for table `banners`
--

DROP TABLE IF EXISTS `banners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `banners` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banners`
--

LOCK TABLES `banners` WRITE;
/*!40000 ALTER TABLE `banners` DISABLE KEYS */;
INSERT INTO `banners` VALUES (2,'BỘ SƯU TẬP NỘI THẤT','KHÔNG GIAN SỐNG ĐẲNG CẤP','Khám phá những thiết kế tinh tế, kết hợp hoàn hảo giữa công năng và thẩm mỹ, mang đến vẻ đẹp vượt thời gian cho ngôi nhà của bạn','https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1920&q=80','/san-pham','Khám phá bộ sưu tập','san-pham',1,1,'2026-10-19 01:23:36','2026-10-22 01:15:15'),(3,'TƯ VẤN PHONG THỦY & BÀI TRÍ NỘI THẤT','Ứng Dụng Trí Tuệ Nhân Tạo Gemini AI & Bát Trạch','Định hướng sinh khí tài lộc, phối hợp màu sắc ngũ hành và bài trí nội thất chuẩn phong thủy cho gia chủ.','https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1920&q=80','/phong-thuy','Tra cứu cung mệnh ngay','phong-thuy',1,1,'2026-10-19 01:23:36','2026-10-19 01:23:36'),(4,'NỘI THẤT CAO CẤP','BỘ SƯU TẬP 2026','Nội thất thiết kế cho không gian sống đẳng cấp — tuyển chọn từ những thương hiệu và xưởng chế tác hàng đầu','https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1920&q=80','/san-pham','Khám phá ngay','hero',1,1,'2026-10-21 23:26:22','2026-10-22 00:52:51'),(8,'SOFA & KỆ TIVI','TÂM ĐIỂM PHÒNG KHÁCH','Thả mình vào sự êm ái và sang trọng. Không gian tiếp khách ấm cúng, hoàn hảo cho gia đình bạn','http://localhost:4000/uploads/banners/banner-1792655674009-326777258.avif','/san-pham?khong-gian=phong-khach','Xem phòng khách','hero',2,1,'2026-10-22 00:54:43','2026-10-22 01:03:08'),(9,'NGHỆ THUẬT NGHỈ NGƠI','NỘI THẤT PHÒNG NGỦ','Tái tạo năng lượng sau một ngày dài với bộ sưu tập phòng ngủ mang đậm dấu ấn cá nhân. Sự kết hợp hoàn hảo giữa chất liệu êm ái và thiết kế tinh tế','http://localhost:4000/uploads/banners/banner-1792655870396-838715317.avif','/san-pham?khong-gian=phong-ngu','xem phòng ngủ','hero',3,1,'2026-10-22 00:57:52','2026-10-22 01:00:40'),(10,'HÀI HÒA SINH KHÍ','TƯ VẤN PHONG THỦY AI','Ứng dụng trí tuệ nhân tạo để phân tích bản mệnh, giúp bạn dễ dàng chọn lựa màu sắc, chất liệu và hướng đặt nội thất thu hút tài lộc, bình an','http://localhost:4000/uploads/banners/banner-1792655948259-888496089.avif','/phong-thuy','Tư vấn phong thủy','hero',4,1,'2026-10-22 00:59:09','2026-10-22 00:59:09'),(11,'Phòng khách',NULL,NULL,'http://localhost:4000/uploads/banners/banner-1792657223955-569360333.avif','/san-pham?khong-gian=phong-khach','Khám phá ngay','space',1,1,'2026-10-22 01:20:26','2026-10-22 01:20:26');
/*!40000 ALTER TABLE `banners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bot_prompts`
--

DROP TABLE IF EXISTS `bot_prompts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bot_prompts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `context_key` varchar(50) NOT NULL COMMENT 'system_prompt, return_policy, etc.',
  `content` text NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `context_key` (`context_key`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bot_prompts`
--

LOCK TABLES `bot_prompts` WRITE;
/*!40000 ALTER TABLE `bot_prompts` DISABLE KEYS */;
INSERT INTO `bot_prompts` VALUES (1,'system_prompt','Bạn là trợ lý AI ảo của thương hiệu Nội thất KTUFA Luxury Furniture. Hãy tư vấn lịch sự, chuẩn phong thủy, ngắn gọn và hữu ích cho khách hàng. Xưng hô là dạ/thưa.',1),(2,'shipping_policy','Giao hàng miễn phí nội thành cho đơn từ 2 triệu. Các tỉnh khác hỗ trợ vận chuyển chuyên nghiệp.',1);
/*!40000 ALTER TABLE `bot_prompts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cart_id` bigint(20) unsigned NOT NULL,
  `variant_id` bigint(20) unsigned NOT NULL,
  `quantity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_id` (`cart_id`),
  KEY `variant_id` (`variant_id`),
  CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `shopping_carts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cash_transactions`
--

DROP TABLE IF EXISTS `cash_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cash_transactions`
--

LOCK TABLES `cash_transactions` WRITE;
/*!40000 ALTER TABLE `cash_transactions` DISABLE KEYS */;
INSERT INTO `cash_transactions` VALUES (1,'PC-202609-001','expense','import_payment',182000000.00,'bank','PN-202609-001',1,'XÆ°á»Ÿng Gá»— Tá»± NhiÃªn Báº¯c Ã‚u','Chuyá»ƒn khoáº£n thanh toÃ¡n tiá»n hÃ ng phiáº¿u PN-202609-001','completed','2026-09-10 10:00:00'),(2,'PC-202610-001','expense','import_payment',223000000.00,'bank','PN-202610-001',1,'Ná»™i Tháº¥t Da Ã Milano','Chuyá»ƒn khoáº£n thanh toÃ¡n phiáº¿u nháº­p PN-202610-001','completed','2026-10-05 15:30:00'),(3,'PC-202610-002','expense','import_payment',100000000.00,'bank','PN-202610-002',1,'Tá»•ng Kho ÄÃ¡ Tá»± NhiÃªn Carrara','Táº¡m á»©ng Ä‘á»£t 1 phiáº¿u nháº­p PN-202610-002','completed','2026-10-18 11:00:00'),(4,'PC-202610-003','expense','import_payment',46000000.00,'cash','PN-202610-003',1,'XÆ°á»Ÿng ÄÃ¨n Thá»§ CÃ´ng BÃ¡t TrÃ ng','Chi tiá»n máº·t thanh toÃ¡n trá»±c tiáº¿p táº¡i showroom phiáº¿u PN-202610-003','completed','2026-10-24 16:45:00'),(5,'PT-202610-001','income','order_bank',58900000.00,'bank','DH-20261005-01',1,'KhÃ¡ch hÃ ng Tráº§n VÄƒn Test','Thanh toÃ¡n chuyá»ƒn khoáº£n VietQR Ä‘Æ¡n hÃ ng DH-20261005-01','completed','2026-10-05 16:20:00'),(6,'PT-202610-002','income','order_bank',32500000.00,'bank','DH-20261012-02',1,'KhÃ¡ch hÃ ng Äáº·ng Tháº£o Vy','Thanh toÃ¡n chuyá»ƒn khoáº£n VietQR Ä‘Æ¡n hÃ ng DH-20261012-02','completed','2026-10-12 11:15:00'),(7,'PT-202610-003','income','order_cod',18900000.00,'cash','DH-20261015-03',1,'Shipper Giao HÃ ng Tiáº¿t Kiá»‡m','Thu ngÃ¢n nháº­n tiá»n máº·t COD tá»« shipper Ä‘Æ¡n DH-20261015-03','completed','2026-10-15 17:30:00'),(8,'PT-202610-004','income','order_cod',4420000.00,'cash','DH-20261022-04',1,'Shipper Viettel Post','Thu ngÃ¢n nháº­n tiá»n máº·t COD tá»« shipper Ä‘Æ¡n DH-20261022-04','completed','2026-10-22 18:00:00'),(9,'PC-202610-7189','expense','import_payment',5000.00,'cash','PN-202610-005',1,'Xưởng Nội Thất Châu Âu','Chi thanh toán phiếu nhập kho PN-202610-005 cho Xưởng Nội Thất Châu Âu','completed','2026-10-29 10:25:07'),(10,'PC-202610-6814','expense','import_payment',5000.00,'cash','PN-202610-006',1,'Công Ty Sofa Cao Cấp Nhà K','Chi thanh toán phiếu nhập kho PN-202610-006 cho Công Ty Sofa Cao Cấp Nhà K','completed','2026-10-29 10:39:46');
/*!40000 ALTER TABLE `cash_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,NULL,'Sofa','sofa',NULL,1),(2,NULL,'Bàn ăn','ban-an',NULL,1),(3,NULL,'Ghế','ghe',NULL,1),(4,NULL,'Giường','giuong',NULL,1),(5,NULL,'Tủ & Kệ','tu-ke',NULL,1),(6,NULL,'Đèn','den',NULL,1),(7,NULL,'Trang trí','trang-tri',NULL,1);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_messages`
--

DROP TABLE IF EXISTS `chat_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chat_messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `session_id` bigint(20) unsigned NOT NULL,
  `sender_type` enum('customer','ai_bot','seller') NOT NULL,
  `sender_id` bigint(20) unsigned DEFAULT NULL COMMENT 'ID cá»§a user hoáº·c seller náº¿u cĂ³',
  `content` text NOT NULL COMMENT 'Ná»™i dung tin nháº¯n',
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  KEY `sender_id` (`sender_id`),
  CONSTRAINT `chat_messages_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `chat_sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chat_messages_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_messages`
--

LOCK TABLES `chat_messages` WRITE;
/*!40000 ALTER TABLE `chat_messages` DISABLE KEYS */;
INSERT INTO `chat_messages` VALUES (1,1,'customer',15,'Sinh năm 1995 (Ất Hợi) nên chọn sofa màu gì?','2026-10-29 10:47:11'),(2,1,'ai_bot',NULL,'Dạ, chào quý khách! Tôi là Chuyên gia tư vấn Phong Thủy & Nội Thất của **KTUFA Luxury Furniture**. Rất vinh hạnh được đồng hành cùng quý khách trên hành trình kiến tạo một không gian sống thịnh vượng và viên mãn.\n\nĐối với gia chủ sinh năm **1995 (tuổi Ất Hợi)**, việc lựa chọn màu sắc cho bộ sofa – trái tim của phòng khách – đóng vai trò vô cùng quan trọng để chiêu tài hút lộc, mang lại bình an và vượng khí cho gia đình. Dưới đây là những tư vấn chuyên sâu từ **KTUFA Luxury Furniture**:\n\n### 1. Phân tích Bản mệnh & Ngũ hành\n* **Năm sinh âm lịch:** 1995 – Ất Hợi (Con lợn).\n* **Ngũ hành nạp âm:** **Sơn Đầu Hỏa** (Lửa trên núi).\n\nTheo quy luật ngũ hành tương sinh - tương khắc, để chọn màu sắc sofa mang lại may mắn, chúng ta ưu tiên các gam màu tương hợp (cùng hành Hỏa) và tương sinh (Hỏa sinh Thổ hoặc Mộc sinh Hỏa).\n\n### 2. Gợi ý màu sắc Sofa chuẩn phong thủy cho tuổi Ất Hợi (1995)\n\n* **Màu tương hợp (Hành Hỏa):** \n  * *Màu sắc:* Đỏ, hồng, tím, cam đậm.\n  * *Ý nghĩa:* Tăng cường năng lượng bản mệnh, mang lại sự nhiệt huyết, may mắn và tài lộc dồi dào. \n  * *Gợi ý từ **KTUFA Luxury Furniture** phối nội thất:* Quý khách có thể chọn các mẫu sofa da cao cấp bọc da tông màu đỏ đô sang trọng hoặc điểm xuyết gối ôm màu cam/hồng trầm để tạo điểm nhấn quyền quý cho phòng khách mà vẫn giữ được sự nhã nhặn.\n\n* **Màu tương sinh (Hành Mộc - Mộc sinh Hỏa):** \n  * *Màu sắc:* Xanh lá cây, xanh rêu, xanh lục.\n  * *Ý nghĩa:* Mộc sinh Hỏa là mối quan hệ sinh trưởng, giúp gia chủ gặp nhiều quý nhân phù trợ, công danh sự nghiệp phát triển vững chắc, sức khỏe hanh thông.\n  * *Gợi ý từ **KTUFA Luxury Furniture** phối nội thất:* Một bộ sofa da bò Ý cao cấp kết hợp với khung gỗ óc chó tự nhiên (Mộc sinh Hỏa cực tốt) hoặc một thiết kế sofa bọc nỉ nhung cao cấp màu xanh rêu trầm sẽ là lựa chọn hoàn hảo, vừa hợp phong thủy vừa mang đậm hơi thở kiến trúc thượng lưu.\n\n### 3. Các màu sắc đại kỵ cần tránh\n* **Màu thuộc hành Thủy (Thủy khắc Hỏa):** Đen, xanh dương, xanh nước biển. \n  * *Lý do:* Nước dập tắt lửa, mang theo năng lượng xung khắc, dễ gây cản trở tài lộc và bất ổn trong gia đạo. Do đó, quý khách tuyệt đối nên tránh chọn sofa có tông màu chủ đạo này.\n* **Màu thuộc hành Kim (Hỏa khắc Kim):** Trắng, xám, ánh kim (mặc dù Hỏa khắc Kim nhưng năng lượng của Hỏa sẽ bị tiêu hao khi \"khắc\", không có lợi cho gia chủ).\n\n### 4. Gợi ý không gian từ KTUFA Luxury Furniture\nĐể tối ưu hóa năng lượng phong thủy cho phòng khách tuổi Ất Hợi 1995, khi bài trí sofa, quý khách cũng nên lưu ý:\n* **Vị trí đặt sofa:** Nên kê sofa tựa lưng vào bức tường vững chãi (tọa sơn) để tạo thế \"vững như bàn thạch\", hướng nhìn ra không gian mở hoặc cửa chính (nhưng không đối diện trực diện) để đón tài khí.\n* **Chất liệu đề xuất:** Các dòng **sofa da thật cao cấp** kết hợp chân gỗ tự nhiên hoặc **sofa bọc vải nhung cao cấp** của **KTUFA Luxury Furniture** không chỉ đạt chuẩn kích thước phong thủy theo Thước Lỗ Ban mà còn mang đến cảm giác êm ái, tụ khí tốt cho ngôi nhà.\n\nMời quý khách ghé thăm website của **KTUFA Luxury Furniture** để tham khảo các bộ sưu tập sofa phòng khách thượng hạng được thiết kế riêng cho từng bản mệnh. Không gian sống đẳng cấp và vượng khí của quý khách đang chờ được hoàn thiện! \n\nQuý khách có cần tôi tư vấn thêm về hướng đặt sofa hay cách phối màu nội thất cho không gian phòng khách này không ạ?','2026-10-29 10:47:11'),(3,2,'customer',15,'[Studio Bát Trạch] Gia chủ Nam mạng sinh năm 2001 · Không gian: Phòng ăn · Cung Càn (Kim)','2026-10-29 11:47:31'),(4,2,'ai_bot',NULL,'Kính chào Quý gia chủ sinh năm 2001 (Nam mạng), thuộc cung Càn, hành Kim. Với tư cách là Chuyên gia Phong thủy của **KTUFA Luxury Furniture**, tôi xin gửi tới anh luận giải chuyên sâu và tinh tế cho không gian **Phòng ăn** – nơi giữ lửa hạnh phúc và vượng khí cho gia đình.\n\n*   **Nhận định phong thủy tổng quan:** Nam mạng sinh năm 2001 thuộc Tây tứ mệnh, hợp với các hướng Tây, Tây Nam, Tây Bắc và Đông Bắc. Phòng ăn là không gian dung dưỡng nguồn năng lượng Thổ (thức ăn) sinh Kim (bản mệnh), tượng trưng cho sự sung túc và bền vững. Việc bố trí phòng ăn tọa lạc ở các cung tốt sẽ giúp gia chủ kích hoạt tài vận, gia đạo hưng thịnh, các mối quan hệ xã hội rộng mở và luôn gặp quý nhân phù trợ.\n*   **Bố trí đồ đạc chiêu tài đón lộc:** \n    *   *Hướng bàn ăn:* Nên đặt bàn ăn quay về các hướng sinh khí như Tây Nam (Diên Niên) hoặc Tây (Sinh Khí) để thu hút tài lộc và sự hòa hợp.\n    *   *Vị trí tựa lưng:* Ghế ngồi của gia chủ khi dùng bữa nên hướng ra cửa chính hoặc đặt ở vị trí có tầm nhìn bao quát, phía sau có tường vững chắc làm \"thế tựa sơn\" tạo sự vững chãi, tự tin trong sự nghiệp.\n    *   *Ánh sáng:* Ưu tiên ánh sáng vàng ấm áp từ hệ thống đèn chùm pha lê đặt giữa bàn ăn, tượng trưng cho sự trọn vẹn, sung túc và giúp kích thích vị giác, gắn kết tình cảm gia đình.\n*   **Chất liệu & Màu sắc nội thất tương sinh:** \n    *   *Màu sắc:* Bản mệnh Kim rất hợp với các tông màu thuần khiết như trắng, bạc, ánh kim, kết hợp hài hòa với màu vàng ấm, nâu đất của hành Thổ (Thổ sinh Kim) như màu gỗ sồi tự nhiên, màu da bò. Tránh các màu khắc như đỏ, hồng thuộc hành Hỏa.\n    *   *Chất liệu:* KTUFA Luxury Furniture khuyên dùng bàn ăn mặt đá marble cao cấp (đại diện cho hành Thổ và Kim) kết hợp chân bàn inox mạ PVD ánh vàng sang trọng, đi kèm ghế bọc da Ý mềm mại. Sự kết hợp này không chỉ nâng tầm đẳng cấp không gian mà còn tạo chuỗi ngũ hành tương sinh hoàn hảo, mang lại bình an và tài lộc viên mãn cho gia chủ trẻ tuổi.','2026-10-29 11:47:31');
/*!40000 ALTER TABLE `chat_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_sessions`
--

DROP TABLE IF EXISTS `chat_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chat_sessions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `guest_id` varchar(255) DEFAULT NULL COMMENT 'Cookie/Session ID cho khĂ¡ch vĂ£ng lai',
  `status` enum('bot_handling','human_requested','human_handling','closed') DEFAULT 'bot_handling',
  `started_at` datetime DEFAULT current_timestamp(),
  `ended_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `chat_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_sessions`
--

LOCK TABLES `chat_sessions` WRITE;
/*!40000 ALTER TABLE `chat_sessions` DISABLE KEYS */;
INSERT INTO `chat_sessions` VALUES (1,15,'guest_mvhqiq99_b6ri','bot_handling','2026-10-29 10:47:11',NULL),(2,15,'guest_mvhqiq99_b6ri','bot_handling','2026-10-29 11:47:31',NULL);
/*!40000 ALTER TABLE `chat_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupons`
--

DROP TABLE IF EXISTS `coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coupons` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `discount_type` enum('percent','fixed_amount','free_shipping') NOT NULL,
  `discount_value` decimal(15,2) NOT NULL,
  `min_order_value` decimal(15,2) DEFAULT 0.00,
  `max_discount_amount` decimal(15,2) DEFAULT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `usage_limit` int(11) DEFAULT NULL,
  `used_count` int(11) DEFAULT 0,
  `status` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupons`
--

LOCK TABLES `coupons` WRITE;
/*!40000 ALTER TABLE `coupons` DISABLE KEYS */;
INSERT INTO `coupons` VALUES (1,'GIAM10','percent',10.00,500000.00,500000.00,'2026-10-22 06:47:04','2027-01-20 06:47:04',100,0,1),(2,'NOITHAT50K','fixed_amount',50000.00,200000.00,NULL,'2026-10-22 06:47:04','2027-01-20 06:47:04',100,0,1),(3,'TRIAN1K','fixed_amount',1000.00,1000.00,NULL,'2026-10-22 06:47:04','2027-01-20 06:47:04',100,0,1),(5,'MAMOI','free_shipping',50000.00,0.00,NULL,'2026-10-22 07:15:00','2027-01-31 00:00:00',20,14,1),(7,'FREESHIP','free_shipping',0.00,0.00,NULL,'2026-10-22 07:30:32','2027-01-01 00:00:00',100,2,1);
/*!40000 ALTER TABLE `coupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_campaigns`
--

DROP TABLE IF EXISTS `email_campaigns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_campaigns` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
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
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_campaign_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_campaigns`
--

LOCK TABLES `email_campaigns` WRITE;
/*!40000 ALTER TABLE `email_campaigns` DISABLE KEYS */;
INSERT INTO `email_campaigns` VALUES (1,'CAM-001','Chào mừng thành viên mới - Nhận ngay Voucher 10% đơn đầu tiên','Tất cả khách hàng',9,'send-now','Đã hoàn tất','Kính gửi Quý khách hàng,\n\nCảm ơn Quý khách đã đăng ký thành viên tại Cửa hàng Nội Thất. Để bắt đầu hành trình kiến tạo không gian sống mơ ước, chúng tôi xin gửi tặng Quý khách mã giảm giá 10% cho đơn hàng đầu tiên: WELCOME2026.\n\nChúc Quý khách có trải nghiệm mua sắm tuyệt vời!',88.50,42.00,9,'2026-10-20 14:59:13','2026-10-23 14:59:13'),(2,'CAM-002','Tri ân Hội viên VIP - Ra mắt Bộ sưu tập Gỗ Óc Chó Mùa Thu 2026','Hội viên VIP (Kim Cương / Vàng)',2,'send-now','Đã hoàn tất','Kính gửi Hội viên VIP,\n\nNhân dịp ra mắt bộ sưu tập nội thất cao cấp Mùa Thu 2026, Nội Thất trân trọng kính mời Quý khách trải nghiệm những tuyệt tác gỗ tự nhiên mới nhất với ưu đãi đặc quyền lên tới 20% cùng dịch vụ tư vấn thiết kế phong thủy miễn phí.\n\nTrân trọng cảm ơn sự đồng hành của Quý khách!',95.00,68.50,2,'2026-10-22 14:59:13','2026-10-23 14:59:13'),(3,'CAM-003','Khuyến mãi cuối tuần - Giảm 15% Sofa & Bàn Ăn','Tất cả khách hàng (9 khách)',9,'send-now','Đã hoàn tất','Chương trình ưu đãi giảm 15% toàn bộ sản phẩm Sofa da Ý và Bàn ăn mặt đá cao cấp duy nhất cuối tuần này.',85.50,38.00,9,'2026-10-23 14:59:39','2026-10-23 14:59:39');
/*!40000 ALTER TABLE `email_campaigns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_slip_items`
--

DROP TABLE IF EXISTS `import_slip_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_slip_items`
--

LOCK TABLES `import_slip_items` WRITE;
/*!40000 ALTER TABLE `import_slip_items` DISABLE KEYS */;
INSERT INTO `import_slip_items` VALUES (1,1,5,5,'SKU-BAN-AN-GO-SOI-NGA','BÃ n Ä‚n Gá»— Sá»“i Nga Scandinavian','MÃ u Gá»— Tá»± NhiÃªn',10,11000000.00,18900000.00,110000000.00,NULL),(2,1,14,14,'SKU-KE-TIVI-TREO-TUONG','Ká»‡ Tivi Treo TÆ°á»ng Hiá»‡n Äáº¡i','Gá»— Walnut Sá»“i',5,15000000.00,24500000.00,75000000.00,NULL),(3,2,1,1,'SKU-SOFA-DA-Y-MILANO','Sofa Da BÃ² Ã Milano Grand','Da BÃ² MÃ u NÃ¢u Háº¡t Dáº»',4,34000000.00,58900000.00,136000000.00,NULL),(4,2,7,7,'SKU-GHE-THU-GIAN-GO-OC-CHO','Gháº¿ ThÆ° GiÃ£n Lounge Gá»— Ã“c ChÃ³','Gá»— Ã“c ChÃ³ Báº¯c Má»¹',6,14000000.00,24500000.00,84000000.00,NULL),(5,3,4,4,'SKU-BAN-AN-DA-MARBLE-CARRARA','BÃ n Ä‚n Máº·t ÄÃ¡ Cáº©m Tháº¡ch Carrara','ÄÃ¡ Tráº¯ng Carrara',8,17500000.00,32500000.00,140000000.00,NULL),(6,4,16,16,'SKU-DEN-SAN-DONG-THAU','ÄÃ¨n SÃ n Äá»©ng ThÃ¢n Äá»“ng Thau Báº¯c Ã‚u','Äá»“ng Thau Cá»• Äiá»ƒn',15,1800000.00,3200000.00,27000000.00,NULL),(7,4,17,17,'SKU-DEN-THA-TRAN-MAY','ÄÃ¨n Tháº£ Tráº§n Thá»§ CÃ´ng Sá»£i MÃ¢y Äan','MÃ¢y Tre Äan Tá»± NhiÃªn',10,1800000.00,2900000.00,18000000.00,NULL),(8,5,1,1,'SKU-TEST','Test Nhập Hàng','Da bò Ý',2,2500.00,5000.00,5000.00,NULL),(9,6,21,21,'cham-trang-tri','cham trang trí','gốm',5,1000.00,2000.00,5000.00,NULL);
/*!40000 ALTER TABLE `import_slip_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_slips`
--

DROP TABLE IF EXISTS `import_slips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_slips`
--

LOCK TABLES `import_slips` WRITE;
/*!40000 ALTER TABLE `import_slips` DISABLE KEYS */;
INSERT INTO `import_slips` VALUES (1,'PN-202609-001',1,1,15,185000000.00,5000000.00,0.00,2000000.00,182000000.00,182000000.00,0.00,'bank','paid','completed','2026-09-10 09:30:00','Nháº­p lÃ´ bÃ n Äƒn gá»— sá»“i vÃ  ká»‡ tivi phá»¥c vá»¥ mÃ¹a cao Ä‘iá»ƒm cuá»‘i nÄƒm','2026-09-10 09:30:00','2026-10-29 15:47:05'),(2,'PN-202610-001',2,1,10,220000000.00,0.00,0.00,3000000.00,223000000.00,223000000.00,0.00,'bank','paid','completed','2026-10-05 14:00:00','Nháº­p da bÃ² Ã cao cáº¥p vÃ  khung gháº¿ thÆ° giÃ£n Ã³c chÃ³','2026-10-05 14:00:00','2026-10-29 15:47:05'),(3,'PN-202610-002',3,1,8,140000000.00,2000000.00,0.00,1500000.00,139500000.00,100000000.00,39500000.00,'bank','partial','completed','2026-10-18 10:15:00','Nháº­p máº·t Ä‘Ã¡ Carrara, thanh toÃ¡n trÆ°á»›c 100tr, cÃ²n ná»£ 39.5tr Ä‘áº¿n cuá»‘i thÃ¡ng','2026-10-18 10:15:00','2026-10-29 15:47:05'),(4,'PN-202610-003',4,1,25,45000000.00,0.00,0.00,1000000.00,46000000.00,46000000.00,0.00,'cash','paid','completed','2026-10-24 16:30:00','Nháº­p Ä‘Ã¨n tháº£ tráº§n vÃ  Ä‘Ã¨n sÃ n Ä‘á»“ng thau tráº£ tiá»n máº·t trá»±c tiáº¿p','2026-10-24 16:30:00','2026-10-29 15:47:05'),(5,'PN-202610-005',1,1,2,5000.00,0.00,0.00,0.00,5000.00,5000.00,0.00,'cash','paid','completed','2026-10-29 00:00:00',NULL,'2026-10-29 10:25:07','2026-10-29 10:25:07'),(6,'PN-202610-006',2,1,5,5000.00,0.00,0.00,0.00,5000.00,5000.00,0.00,'cash','paid','completed','2026-10-29 00:00:00',NULL,'2026-10-29 10:39:46','2026-10-29 10:39:46');
/*!40000 ALTER TABLE `import_slips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned DEFAULT NULL,
  `variant_id` bigint(20) unsigned DEFAULT NULL,
  `product_name` varchar(255) NOT NULL COMMENT 'TĂªn lÆ°u cá»©ng lĂºc mua',
  `variant_name` varchar(255) DEFAULT NULL COMMENT 'MĂ u/Cháº¥t liá»‡u lÆ°u cá»©ng',
  `sku` varchar(50) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL COMMENT 'GiĂ¡ lÆ°u cá»©ng lĂºc mua',
  `cost_price` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_price` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  KEY `variant_id` (`variant_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL,
  CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (6,5,20,20,'sofa_Ä‘en nhĂ¡m',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(7,6,12,12,'Tá»§ quáº§n Ă¡o 4 cĂ¡nh',NULL,'SKU-TU-QUAN-AO-4-CANH',1,24500000.00,6380000.00,24500000.00),(8,7,20,20,'sofa_Ä‘en nhĂ¡m',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(9,8,1,1,'Sofa da � Milano',NULL,'SKU-SOFA-DA-Y-MILANO',1,12000000.00,34160000.00,12000000.00),(10,9,3,3,'Sofa g�c B?c �u',NULL,'SKU-SOFA-GOC-BAC-AU',1,8500000.00,19080000.00,8500000.00),(11,10,20,20,'Sofa da bò Ý cao cấp',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(12,11,20,20,'Sofa da bò Ý cao cấp',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(13,12,20,20,'Sofa da bò Ý cao cấp',NULL,'SOFADEN_NHAM_001',2,7500000.00,4350000.00,15000000.00),(14,13,20,20,'Sofa da bò Ý cao cấp',NULL,'SOFADEN_NHAM_001',2,7500000.00,4350000.00,15000000.00),(15,14,20,20,'Sofa da bò Ý cao cấp',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(16,15,20,20,'Sofa da bò Ý cao cấp',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(17,16,20,20,'Sofa da bò Ý cao cấp',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(18,17,20,20,'Sofa da bò Ý cao cấp',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(19,18,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(20,19,21,21,'Châm trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(21,20,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(22,21,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(25,24,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(26,25,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(27,26,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(28,27,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(29,28,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(30,29,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(31,30,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',2,2000.00,0.00,4000.00),(32,31,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(33,32,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(34,33,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(35,35,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',4,2000.00,0.00,8000.00),(36,36,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',2,2000.00,0.00,4000.00),(37,37,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,1000.00,2000.00),(38,38,20,20,'Sofa da bò Ý cao cấp',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(39,39,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,1000.00,2000.00),(40,40,21,21,'cham trang trí',NULL,'CHAM_TRANG_TRI_001',1,2000.00,1000.00,2000.00),(41,41,20,20,'Sofa da bò Ý cao cấp',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(42,42,13,13,'Kệ tivi treo tường',NULL,'SKU-KE-TIVI-TREO-TUONG',1,9800000.00,5680000.00,9800000.00);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_code` varchar(50) NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `coupon_id` int(10) unsigned DEFAULT NULL,
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
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_code` (`order_code`),
  KEY `user_id` (`user_id`),
  KEY `coupon_id` (`coupon_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (5,'NT-2610-9661',6,NULL,'543b tĂ¢n phĂº, r, TP. Há»“ ChĂ­ Minh',0.00,7500000.00,0.00,7500000.00,'cod','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-16 04:13:03','2026-11-05 09:06:43'),(6,'NT-2610-5385',6,NULL,'110d tĂ¢n quĂ½, tĂ¢n phĂº, HCM, r, TP. Há»“ ChĂ­ Minh',0.00,24500000.00,0.00,24500000.00,'cod','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-16 08:36:49','2026-11-05 09:06:43'),(7,'NT-2610-3221',7,NULL,'412, TĂ¢n PhĂº, TP. Há»“ ChĂ­ Minh',0.00,7500000.00,0.00,7500000.00,'cod','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-18 13:02:12','2026-11-05 09:06:43'),(8,'NT-2610-5947',8,NULL,'123 Du?ng C?u Gi?y, C?u Gi?y, H� N?i',0.00,12000000.00,0.00,12000000.00,'sepay','paid','confirmed','[SePay Webhook] Thanh toán thành công 12.000.000 đ qua MBBank (Ref: REF99999) lúc 2026-10-21 11:18:00',NULL,'2026-10-21 04:19:14','2026-10-21 11:19:14'),(9,'NT-2610-4932',9,NULL,'456 Du?ng C?u Gi?y, C?u Gi?y, H� N?i',0.00,8500000.00,0.00,8500000.00,'sepay','paid','confirmed','[DEMO TEST] Thanh toán giả lập thành công 8.500.000 đ lúc 11:19:22 21/10/2026',NULL,'2026-10-21 04:19:22','2026-10-21 11:19:22'),(10,'NT-2610-8753',6,NULL,'765A Tp hcm, r, TP. Hồ Chí Minh',0.00,7500000.00,0.00,7500000.00,'sepay','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-21 05:32:28','2026-11-05 09:06:43'),(11,'NT-2610-7863',6,NULL,'110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh',0.00,7500000.00,0.00,7500000.00,'sepay','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-21 05:41:17','2026-11-05 09:06:43'),(12,'NT-2610-5288',6,NULL,'110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh',0.00,15000000.00,0.00,15000000.00,'sepay','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-21 05:57:04','2026-11-05 09:06:43'),(13,'NT-2610-9861',6,NULL,'110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh',0.00,15000000.00,0.00,15000000.00,'sepay','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-21 06:00:38','2026-11-05 09:06:43'),(14,'NT-2610-1738',6,NULL,'299 trịnh đình trọng, hòa thạnh, tân phú, TP HCM, r, TP. Hồ Chí Minh',0.00,7500000.00,0.00,7500000.00,'sepay','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-21 06:05:29','2026-11-05 09:06:43'),(15,'NT-2610-5475',6,NULL,'110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh',0.00,7500000.00,0.00,7500000.00,'sepay','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-21 06:16:28','2026-11-05 09:06:43'),(16,'NT-2610-4750',6,NULL,'543b tân phú, r, TP. Hồ Chí Minh',0.00,7500000.00,0.00,7500000.00,'sepay','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-21 06:20:13','2026-11-05 09:06:43'),(17,'NT-2610-7968',6,NULL,'110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh',0.00,7500000.00,0.00,7500000.00,'sepay','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-21 06:20:29','2026-11-05 09:06:43'),(18,'NT-2610-2647',6,NULL,'110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh',50000.00,2000.00,0.00,52000.00,'sepay','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-22 03:50:43','2026-11-05 09:06:43'),(19,'NT-2610-3033',11,3,'123 Phố Huế, Ba Đình, Hà Nội',50000.00,2000.00,1000.00,51000.00,'cod','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-22 06:47:49','2026-11-05 09:06:43'),(20,'NT-2610-6180',6,NULL,'765A Tp hcm, r, TP. Hồ Chí Minh',50000.00,2000.00,0.00,52000.00,'sepay','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-22 07:41:30','2026-11-05 09:06:43'),(21,'NT-2610-9063',6,7,'765A Tp hcm, r, TP. Hồ Chí Minh',0.00,2000.00,50000.00,2000.00,'sepay','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-22 07:41:30','2026-11-05 09:06:43'),(24,'NT-2610-9964',6,NULL,'765A Tp hcm, r, TP. Hồ Chí Minh',50000.00,2000.00,0.00,52000.00,'sepay','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-22 07:44:20','2026-11-05 09:06:43'),(25,'NT-2610-8735',6,5,'765A Tp hcm, r, TP. Hồ Chí Minh',0.00,2000.00,50000.00,2000.00,'sepay','paid','confirmed','[SePay Webhook] Thanh toán thành công 2.000 đ qua MBBank (Ref: FT26295755326490) lúc 2026-10-22 14:45:00',NULL,'2026-10-22 07:45:40','2026-10-22 15:15:57'),(26,'NT-2610-3146',6,5,'110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh',0.00,2000.00,50000.00,2000.00,'sepay','paid','confirmed','[SePay Webhook] Thanh toán thành công 2.000 đ qua MBBank (Ref: FT26295050733038) lúc 2026-10-22 14:52:00',NULL,'2026-10-22 07:52:04','2026-10-22 15:15:57'),(27,'NT-2610-8318',6,5,'110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh',0.00,2000.00,50000.00,2000.00,'sepay','paid','confirmed','[SePay Webhook] Thanh toán thành công 2.000 đ qua MBBank (Ref: FT26295064070640) lúc 2026-10-22 15:09:00',NULL,'2026-10-22 08:09:42','2026-10-22 15:15:57'),(28,'NT-2610-2866',6,NULL,'110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh',50000.00,2000.00,0.00,52000.00,'cod','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-22 08:10:45','2026-11-05 09:06:43'),(29,'NT-2610-2519',5,NULL,'543b tân phú, r, TP. Hồ Chí Minh',50000.00,2000.00,0.00,52000.00,'sepay','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-22 15:34:01','2026-11-05 09:06:43'),(30,'NT-2610-7865',5,NULL,'110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh',50000.00,4000.00,0.00,54000.00,'cod','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-22 16:57:01','2026-11-05 09:06:43'),(31,'NT-2610-5539',6,NULL,'543b tân phú, r, TP. Hồ Chí Minh',50000.00,2000.00,0.00,52000.00,'sepay','paid','cancelled','[SePay Webhook] Thanh toán thành công 52.000 đ qua MBBank (Ref: FT26296741390800) lúc 2026-10-23 09:27:00',NULL,'2026-10-23 02:27:01','2026-10-27 09:49:01'),(32,'NT-2610-8123',13,NULL,'220 nguyễn hồng đào, tân bình, TP. Hồ Chí Minh',50000.00,2000.00,0.00,52000.00,'sepay','pending','cancelled','[CANCEL_REASON: Đơn hàng tự động hủy do quá thời hạn thanh toán 24 giờ (chưa thanh toán).]',NULL,'2026-10-27 03:17:55','2026-11-05 09:06:43'),(33,'NT-2610-4939',13,NULL,'220 nguyễn hồng đào, tân bình, TP. Hồ Chí Minh',50000.00,2000.00,0.00,52000.00,'cod','paid','completed',NULL,NULL,'2026-10-27 03:18:22','2026-10-27 10:19:49'),(35,'NT-2610-5686',7,NULL,'412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh',50000.00,8000.00,0.00,58000.00,'cod','paid','completed',NULL,NULL,'2026-10-29 08:16:20','2026-10-29 15:17:48'),(36,'NT-2610-6366',15,NULL,'412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh',50000.00,4000.00,0.00,54000.00,'cod','pending','shipping',NULL,NULL,'2026-10-29 08:18:50','2026-10-29 18:30:30'),(37,'NT-2611-1881',15,NULL,'412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh',50000.00,2000.00,0.00,52000.00,'cod','pending','pending',NULL,'ko có','2026-11-04 08:49:55','2026-11-04 08:49:55'),(38,'NT-2611-6731',15,NULL,'412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh',0.00,7500000.00,0.00,7500000.00,'cod','pending','pending',NULL,'ko có','2026-11-04 08:52:00','2026-11-04 08:52:00'),(39,'NT-2611-8577',15,NULL,'412, Tân Phú, TP. Hồ Chí Minh',50000.00,2000.00,0.00,52000.00,'cod','pending','pending',NULL,'abc','2026-11-04 08:59:36','2026-11-04 08:59:36'),(40,'NT-2611-5753',15,5,'412, Tân Phú, TP. Hồ Chí Minh',0.00,2000.00,50000.00,2000.00,'sepay','paid','confirmed','[NOTIFY_EMAIL:huuloi230605@gmail.com]\n[DEMO TEST] Thanh toán giả lập thành công 2.000 đ lúc 08:33:09 5/11/2026','test','2026-11-05 01:29:39','2026-11-05 08:36:33'),(41,'NT-2611-1085',15,7,'412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh',0.00,7500000.00,0.00,7500000.00,'sepay','paid','confirmed','[NOTIFY_EMAIL:huuloi230605@gmail.com]','abc','2026-11-05 02:17:45','2026-11-05 09:39:18'),(42,'NT-2611-9109',15,NULL,'412 Lũy Bán Bích, Tân Phú, TP. Hồ Chí Minh',0.00,9800000.00,0.00,9800000.00,'sepay','paid','confirmed','[NOTIFY_EMAIL:huuloi230605@gmail.com]','abc','2026-11-05 02:42:03','2026-11-05 09:42:12');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_otps`
--

DROP TABLE IF EXISTS `password_otps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_otps` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `otp_hash` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `attempts` int(11) NOT NULL DEFAULT 0,
  `used_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `password_otps_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_otps`
--

LOCK TABLES `password_otps` WRITE;
/*!40000 ALTER TABLE `password_otps` DISABLE KEYS */;
INSERT INTO `password_otps` VALUES (1,31,'5d5a9a8de376fecc729ab35616a8094cbbbe4b7703f836ff6cbf1d447d82b6c3','2026-10-28 23:25:09',0,'2026-10-28 23:21:17','2026-10-28 23:20:09'),(2,31,'75146e81d7f4fbefb3b4015de106336f0857aa44c333ae104e5634ee24c151d2','2026-10-28 23:26:17',0,'2026-10-28 23:22:20','2026-10-28 23:21:17'),(3,31,'d0246b0cd49b6e74b1de74afe527241e0247dc8794b5737777ba95cb965ccf73','2026-10-28 23:27:20',0,'2026-10-28 23:29:17','2026-10-28 23:22:20'),(4,31,'2c0030f6be770b6d5ec126259c0df52890d1be564a67d1edbc215d1492146baf','2026-10-28 23:34:17',0,'2026-10-28 23:37:08','2026-10-28 23:29:17'),(5,31,'feaf0b56e50541bd9e0cad060fc754b64cb25369ebfb31a8a023157e73805209','2026-10-28 23:42:08',0,NULL,'2026-10-28 23:37:08'),(6,32,'bb0314f2497653906843e3b0759991b035b964cf7ce6d0572fb30ecf0ecd94a2','2026-10-29 00:24:10',0,'2026-10-29 00:20:19','2026-10-29 00:19:10');
/*!40000 ALTER TABLE `password_otps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_images` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) unsigned NOT NULL,
  `variant_id` bigint(20) unsigned DEFAULT NULL,
  `image_url` text DEFAULT NULL,
  `is_thumbnail` tinyint(1) DEFAULT 0,
  `sort_order` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `variant_id` (`variant_id`),
  CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_images_ibfk_2` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES (1,20,NULL,'https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcRki-yI52sFUUgMgey0RaCVX8DJkX5Vs2qx1TZhr0wbKwUYbS5Mo_2IviRrNzQOG3xih_u-xAldpoQGMviu9ia-Fx1kC0j0d6Am1I5dDVktCDHeadrSxaSBkA&usqp=CAc',1,0),(5,20,NULL,'http://localhost:4000/uploads/prod-anh-NT4-1792120685145-93706.jpg',0,1),(6,20,NULL,'http://localhost:4000/uploads/prod-anh-NT3-1792120685151-71667.jpg',0,2),(7,20,NULL,'http://localhost:4000/uploads/prod-anh-NT2-1792120685155-7455.jpg',0,3),(8,1,NULL,'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80',1,0),(9,2,NULL,'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?auto=format&fit=crop&w=600&q=80',1,0),(10,3,NULL,'https://images.unsplash.com/photo-1540574163026-643ea20ade25?auto=format&fit=crop&w=600&q=80',1,0),(11,4,NULL,'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=600&q=80',1,0),(12,5,NULL,'https://images.unsplash.com/photo-1577140917170-285929fb55b7?auto=format&fit=crop&w=600&q=80',1,0),(13,6,NULL,'https://images.unsplash.com/photo-1580481077198-c847ad43616b?auto=format&fit=crop&w=600&q=80',1,0),(14,7,NULL,'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=600&q=80',1,0),(15,8,NULL,'https://images.unsplash.com/photo-1505797149-43b0069ec26b?auto=format&fit=crop&w=600&q=80',1,0),(16,9,NULL,'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=600&q=80',1,0),(17,10,NULL,'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=600&q=80',1,0),(18,11,NULL,'https://images.unsplash.com/photo-1540518614846-7ede433c4ef9?auto=format&fit=crop&w=600&q=80',1,0),(19,12,NULL,'https://www.noithatkaya.com/wp-content/uploads/2023/09/Tu-Quan-Ao-17.jpg',1,0),(20,13,NULL,'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=600&q=80',1,0),(21,14,NULL,'https://images.unsplash.com/photo-1594671581654-278554dd3460?auto=format&fit=crop&w=600&q=80',1,0),(22,15,NULL,'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=600&q=80',1,0),(23,16,NULL,'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&w=600&q=80',1,0),(24,17,NULL,'https://images.unsplash.com/photo-1534349762230-e0cadf78f5da?auto=format&fit=crop&w=600&q=80',1,0),(25,18,NULL,'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?auto=format&fit=crop&w=600&q=80',1,0),(26,19,NULL,'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=600&q=80',1,0),(27,21,NULL,'http://localhost:4000/uploads/prod-mohinh-1792641014106-54374.jpg',1,0),(28,22,NULL,'http://localhost:4000/uploads/test.jpg',1,0),(29,21,NULL,'http://localhost:4000/uploads/prod-mohinh-1792649798446-77710.jpg',0,1);
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_variants`
--

DROP TABLE IF EXISTS `product_variants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_variants` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) unsigned NOT NULL,
  `sku` varchar(50) NOT NULL,
  `color` varchar(50) DEFAULT NULL,
  `material` varchar(50) DEFAULT NULL,
  `price` decimal(15,2) NOT NULL,
  `cost_price` decimal(15,2) NOT NULL DEFAULT 0.00,
  `compare_at_price` decimal(15,2) DEFAULT NULL,
  `stock_quantity` int(11) DEFAULT 0,
  `weight_gram` int(11) DEFAULT NULL COMMENT 'DĂ¹ng Ä‘á»ƒ tĂ­nh phĂ­ ship',
  `dimensions` varchar(50) DEFAULT NULL COMMENT 'DĂ i x Rá»™ng x Cao',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sku` (`sku`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_variants_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_variants`
--

LOCK TABLES `product_variants` WRITE;
/*!40000 ALTER TABLE `product_variants` DISABLE KEYS */;
INSERT INTO `product_variants` VALUES (1,1,'SKU-SOFA-DA-Y-MILANO',NULL,'Da bò Ý',5000.00,2500.00,NULL,22,NULL,'240 × 95 × 78 cm'),(2,2,'SKU-SOFA-VAI-LINEN-OSLO',NULL,'Vải linen',26500000.00,15370000.00,NULL,20,NULL,'210 × 88 × 80 cm'),(3,3,'SKU-SOFA-GOC-BAC-AU',NULL,'Vải bố',32900000.00,19080000.00,NULL,20,NULL,'270 × 180 × 82 cm'),(4,4,'SKU-BAN-AN-DA-MARBLE-CARRARA',NULL,'Đá marble',32500000.00,18850000.00,NULL,20,NULL,'180 × 90 × 75 cm'),(5,5,'SKU-BAN-AN-GO-SOI-NGA',NULL,'Gỗ sồi',18900000.00,10960000.00,NULL,20,NULL,'160 × 80 × 75 cm'),(6,6,'SKU-GHE-AN-DA-BOC-Y',NULL,'Da công nghiệp',4200000.00,2440000.00,NULL,20,NULL,'48 × 55 × 88 cm'),(7,7,'SKU-GHE-THU-GIAN-GO-OC-CHO',NULL,'Gỗ óc chó',18900000.00,10960000.00,NULL,20,NULL,'72 × 80 × 95 cm'),(8,8,'SKU-GHE-CONG-THAI-HOC-ERGO',NULL,'Lưới & nhựa',6900000.00,4000000.00,NULL,20,NULL,'66 × 66 × 118 cm'),(9,9,'SKU-GHE-NGOAI-TROI-GO-TEAK',NULL,'Gỗ teak',8900000.00,5160000.00,NULL,20,NULL,'58 × 62 × 85 cm'),(10,10,'SKU-GIUONG-BOC-NI-VELVET',NULL,'Nỉ velvet',22900000.00,13280000.00,NULL,20,NULL,'180 × 200 × 110 cm'),(11,11,'SKU-GIUONG-GO-TU-NHIEN-SCANDINAVIAN',NULL,'Gỗ sồi',28500000.00,16530000.00,NULL,20,NULL,'160 × 200 × 95 cm'),(12,12,'SKU-TU-QUAN-AO-4-CANH',NULL,'Gỗ MDF',11000000.00,6380000.00,12600000.00,21,NULL,'200 × 60 × 220 cm'),(13,13,'SKU-KE-TIVI-TREO-TUONG',NULL,'Gỗ công nghiệp',9800000.00,5680000.00,NULL,19,NULL,'180 × 35 × 40 cm'),(14,14,'SKU-KE-SACH-GO-THONG',NULL,'Gỗ thông',7200000.00,4180000.00,NULL,20,NULL,'80 × 30 × 180 cm'),(15,15,'SKU-DEN-SAN-DONG-THAU',NULL,'Đồng thau',7900000.00,4580000.00,NULL,20,NULL,'Ø 40 × 160 cm'),(16,16,'SKU-DEN-THA-TRAN-MAY',NULL,'Mây tự nhiên',3400000.00,1970000.00,NULL,20,NULL,'Ø 55 × 40 cm'),(17,17,'SKU-DEN-BAN-GOM',NULL,'Gốm',1900000.00,1100000.00,NULL,20,NULL,'Ø 25 × 45 cm'),(18,18,'SKU-BAN-TRA-MAT-KINH',NULL,'Kính cường lực',5600000.00,3250000.00,NULL,20,NULL,'120 × 60 × 42 cm'),(19,19,'SKU-GUONG-TRANG-TRI-VIEN-VANG',NULL,'Hợp kim mạ',3100000.00,1800000.00,NULL,20,NULL,'60 × 90 cm'),(20,20,'SOFADEN_NHAM_001',NULL,'Da bò Ý',7500000.00,4350000.00,NULL,30,NULL,'220 × 90 × 75 cm'),(21,21,'CHAM_TRANG_TRI_001',NULL,'gốm',2000.00,1000.00,4000.00,25,NULL,NULL),(22,22,'TEST_PA3_PRODUCT_1792641888_001',NULL,NULL,3500000.00,2030000.00,NULL,15,NULL,NULL);
/*!40000 ALTER TABLE `product_variants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `short_description` text DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `view_count` int(11) DEFAULT 0,
  `status` tinyint(1) DEFAULT 1 COMMENT '1: Äang bĂ¡n, 0: Ngá»«ng bĂ¡n',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,1,'Sofa da Ý Milano','sofa-da-y-milano','Sofa ba chỗ bọc da bò Ý nguyên tấm, khung gỗ sồi sấy khô và đệm mút đàn hồi cao cấp, giữ phom bền theo thời gian.',NULL,NULL,70,1,'2026-10-08 09:00:01','2026-11-04 15:49:05',NULL),(2,1,'Sofa vải linen Oslo','sofa-vai-linen-oslo','Sofa vải linen thoáng mát, đường may tỉ mỉ, chân gỗ chế tác thủ công, phù hợp không gian sống tối giản.',NULL,NULL,75,1,'2026-10-08 09:00:01','2026-11-04 14:51:45',NULL),(3,1,'Sofa góc Bắc Âu','sofa-goc-bac-au','Sofa góc chữ L phong cách Bắc Âu, các mô-đun tháo rời và đổi hướng linh hoạt theo bố cục phòng.',NULL,NULL,73,1,'2026-10-08 09:00:01','2026-11-04 15:49:05',NULL),(4,2,'Bàn ăn đá marble Carrara','ban-an-da-marble-carrara','Bàn ăn mặt đá marble Carrara nhập khẩu, chân kim loại mạ titan chống gỉ, mặt bàn được xử lý chống thấm.',NULL,NULL,74,1,'2026-10-08 09:00:01','2026-11-04 15:49:05',NULL),(5,2,'Bàn ăn gỗ sồi Nga','ban-an-go-soi-nga','Bàn ăn gỗ sồi Nga nguyên khối, phủ dầu bảo vệ tự nhiên giữ trọn vân gỗ và độ ấm của chất liệu.',NULL,NULL,63,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(6,3,'Ghế ăn da bọc Ý','ghe-an-da-boc-y','Ghế ăn bọc da công nghiệp cao cấp, khung thép chịu lực, đệm êm vừa vặn cho bữa ăn dài.',NULL,NULL,63,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(7,3,'Ghế thư giãn gỗ óc chó','ghe-thu-gian-go-oc-cho','Ghế thư giãn gỗ óc chó, tựa lưng cong theo cơ thể, đệm vải nhập khẩu tạo cảm giác dễ chịu khi đọc sách.',NULL,NULL,65,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(8,3,'Ghế công thái học Ergo','ghe-cong-thai-hoc-ergo','Ghế công thái học lưng lưới, tựa đầu và tay vịn điều chỉnh ba hướng, hỗ trợ cột sống khi làm việc dài.',NULL,NULL,63,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(9,3,'Ghế ngoài trời gỗ teak','ghe-ngoai-troi-go-teak','Ghế ngoài trời gỗ teak chống mối mọt và chịu được mưa nắng, phù hợp ban công, sân vườn.',NULL,NULL,63,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(10,4,'Giường ngủ bọc nỉ Velvet','giuong-boc-ni-velvet','Giường bọc nỉ velvet với đầu giường cao, khung gỗ chắc chắn và hệ nan đệm êm ái.',NULL,NULL,63,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(11,4,'Giường gỗ tự nhiên Scandinavian','giuong-go-tu-nhien-scandinavian','Giường gỗ sồi tự nhiên tối giản, bề mặt phủ dầu mờ an toàn cho sức khỏe và dễ vệ sinh.',NULL,NULL,63,1,'2026-10-08 09:00:01','2026-10-29 19:01:29',NULL),(12,5,'Tủ quần áo 4 cánh','tu-quan-ao-4-canh','Tủ quần áo bốn cánh gỗ MDF chống ẩm, ray giảm chấn và hệ ngăn chia tiện dụng.',NULL,NULL,73,1,'2026-10-08 09:00:02','2026-10-29 19:01:29',NULL),(13,5,'Kệ tivi treo tường','ke-tivi-treo-tuong','Kệ tivi treo tường gọn gàng, có lỗ đi dây điện và tải trọng tới 60 kg.',NULL,NULL,67,1,'2026-10-08 09:00:02','2026-11-05 09:41:43',NULL),(14,5,'Kệ sách gỗ thông','ke-sach-go-thong','Kệ sách gỗ thông năm tầng, thiết kế mở giúp góc làm việc thoáng đãng và dễ sắp xếp.',NULL,NULL,66,1,'2026-10-08 09:00:02','2026-10-29 19:01:29',NULL),(15,6,'Đèn sàn đồng thau','den-san-dong-thau','Đèn sàn đồng thau thân mảnh, chao vải tản sáng dịu, tạo điểm nhấn cho góc đọc sách.',NULL,NULL,63,1,'2026-10-08 09:00:02','2026-10-29 19:01:29',NULL),(16,6,'Đèn thả trần mây','den-tha-tran-may','Đèn thả trần đan mây tự nhiên, ánh sáng ấm áp, phù hợp treo trên bàn ăn hoặc đảo bếp.',NULL,NULL,67,1,'2026-10-08 09:00:02','2026-10-29 19:01:29',NULL),(17,6,'Đèn bàn gốm','den-ban-gom','Đèn bàn gốm men mờ, chụp vải, cho ánh sáng vàng ấm phù hợp bàn làm việc và đầu giường.',NULL,NULL,63,1,'2026-10-08 09:00:02','2026-10-29 19:01:29',NULL),(18,7,'Bàn trà mặt kính','ban-tra-mat-kinh','Bàn trà mặt kính cường lực 12 mm, khung inox mạ vàng sang trọng, dễ lau chùi.',NULL,NULL,63,1,'2026-10-08 09:00:02','2026-10-29 19:01:29',NULL),(19,7,'Gương trang trí viền mạ vàng','guong-trang-tri-vien-vang','Gương trang trí viền hợp kim mạ vàng, treo ngang hoặc dọc đều cân đối cho phòng ngủ.',NULL,NULL,63,1,'2026-10-08 09:00:02','2026-10-29 19:01:29',NULL),(20,1,'Sofa da bò Ý cao cấp','sofaden-nham','Sofa da màu đen nhám quý phái, đệm êm ái cho không gian phòng khách hiện đại.',NULL,NULL,181,1,'2026-10-15 16:33:12','2026-11-05 09:41:32',NULL),(21,7,'cham trang trí','cham-trang-tri','sản phẩm trang trí nổi bật',NULL,NULL,77,1,'2026-10-22 03:38:08','2026-11-05 08:29:03',NULL),(22,1,'S?n ph?m th? nghi?m Phuong �n 3','test-pa3-product-1792641888',NULL,NULL,NULL,0,0,'2026-10-22 04:04:48','2026-10-22 11:04:54','2026-10-22 04:04:54');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reviews` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `order_id` bigint(20) unsigned NOT NULL,
  `rating` tinyint(4) NOT NULL CHECK (`rating` between 1 and 5),
  `content` text DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `user_id` (`user_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (2,21,13,31,5,'very nice',1,'2026-10-27 03:04:28');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin','Quáº£n trá»‹ viĂªn toĂ n quyá»n'),(2,'seller','NgÆ°á»i bĂ¡n hĂ ng, quáº£n lĂ½ sáº£n pháº©m, Ä‘Æ¡n hĂ ng'),(3,'customer','KhĂ¡ch mua hĂ ng'),(4,'consultant','Chuyên viên tư vấn phong thủy'),(5,'warehouse','Thủ kho & vận chuyển'),(6,'marketing','Marketing & truyền thông'),(7,'cashier','Thu ngÃ¢n & Káº¿ toÃ¡n quá»¹, quáº£n lÃ½ dÃ²ng tiá»n vÃ  Ä‘á»‘i soÃ¡t');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shopping_carts`
--

DROP TABLE IF EXISTS `shopping_carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shopping_carts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `session_id` varchar(255) DEFAULT NULL COMMENT 'DĂ nh cho khĂ¡ch chÆ°a Ä‘Äƒng nháº­p',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `shopping_carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shopping_carts`
--

LOCK TABLES `shopping_carts` WRITE;
/*!40000 ALTER TABLE `shopping_carts` DISABLE KEYS */;
/*!40000 ALTER TABLE `shopping_carts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `showcases`
--

DROP TABLE IF EXISTS `showcases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `showcases` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `image_url` text DEFAULT NULL,
  `link_url` varchar(255) DEFAULT '/san-pham',
  `display_order` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `showcases`
--

LOCK TABLES `showcases` WRITE;
/*!40000 ALTER TABLE `showcases` DISABLE KEYS */;
/*!40000 ALTER TABLE `showcases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spaces`
--

DROP TABLE IF EXISTS `spaces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spaces` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `image_url` text DEFAULT NULL,
  `display_order` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spaces`
--

LOCK TABLES `spaces` WRITE;
/*!40000 ALTER TABLE `spaces` DISABLE KEYS */;
INSERT INTO `spaces` VALUES (1,'Phòng khách','phong-khach','https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1200&q=80',1,1,'2026-10-23 04:38:26','2026-10-23 04:38:26'),(2,'Phòng ngủ','phong-ngu','https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1200&q=80',2,1,'2026-10-23 04:38:26','2026-10-23 04:38:26'),(3,'Phòng ăn','phong-an','https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=1200&q=80',3,1,'2026-10-23 04:38:26','2026-10-23 04:38:26'),(4,'Làm việc','lam-viec','https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=1200&q=80',4,1,'2026-10-23 04:38:26','2026-10-23 04:38:26'),(5,'Chiếu sáng','chieu-sang','https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=1200&q=80',5,1,'2026-10-23 04:38:26','2026-10-23 04:38:26'),(6,'Ngoài trời','ngoai-troi','https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=1200&q=80',6,1,'2026-10-23 04:38:26','2026-10-23 04:38:26');
/*!40000 ALTER TABLE `spaces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'NCC-GO-BAC-AU','Xưởng Nội Thất Châu Âu','Trương Chí Vỹ','0912345678','hung.gobackau@noithat.vn','HÀ NỘI',1,'2026-10-29 15:47:05','2026-10-29 16:52:37'),(2,'NCC-DA-Y-MILANO','Công Ty Sofa Cao Cấp Nhà K','K Khoa','0934567890','trang.milano@da-y.vn','Tân Phú, Hồ Chí Minh',1,'2026-10-29 15:47:05','2026-10-29 16:53:44'),(3,'NCC-DA-MARBLE','Tá»•ng Kho ÄÃ¡ Tá»± NhiÃªn & BÃ n Ä‚n Carrara','LÃª HoÃ ng Long','0978901234','long.carrara@stone-viet.com','KCN BiÃªn HÃ²a 2, Äá»“ng Nai',0,'2026-10-29 15:47:05','2026-10-29 16:53:52'),(4,'NCC-GOM-DEN','XÆ°á»Ÿng ÄÃ¨n Thá»§ CÃ´ng Má»¹ Nghá»‡ & Gá»‘m Sá»©','Pháº¡m Minh Äá»©c','0901239876','duc.gomart@noithat.vn','LÃ ng Gá»‘m BÃ¡t TrÃ ng, Gia LÃ¢m, HÃ  Ná»™i',0,'2026-10-29 15:47:05','2026-10-29 16:54:06'),(5,'NCC-005','Xưởng Gỗ Quảng Châu','Anh Lợi Hotboi','0902566063',NULL,'Hồ Chí Minh',1,'2026-10-29 10:41:02','2026-10-29 10:41:02');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_logs`
--

DROP TABLE IF EXISTS `system_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `action` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `system_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_logs`
--

LOCK TABLES `system_logs` WRITE;
/*!40000 ALTER TABLE `system_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_addresses`
--

DROP TABLE IF EXISTS `user_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_addresses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `receiver_name` varchar(100) NOT NULL,
  `receiver_phone` varchar(20) NOT NULL,
  `province` varchar(100) NOT NULL,
  `district` varchar(100) NOT NULL,
  `ward` varchar(100) NOT NULL,
  `specific_address` varchar(255) NOT NULL,
  `is_default` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_addresses`
--

LOCK TABLES `user_addresses` WRITE;
/*!40000 ALTER TABLE `user_addresses` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar_url` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1 COMMENT '1: Active, 0: Banned',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,3,'hi@gmail.com','$2b$10$H3ndNj83h9RJ8QOHeiDei.5W0.REvZ.zcKgKV10Tv5AJTcL3QLnH.','hi','0903456789',NULL,1,'2026-10-09 06:18:11','2026-10-16 12:13:46',NULL),(2,3,'test@gmail.com','guest_no_login','Nguyễn Văn Test','0988776655',NULL,1,'2026-10-09 06:45:38','2026-10-22 09:28:50',NULL),(3,3,'truongvy6272005@gmail.com','guest_no_login','vy truong','0123456789',NULL,1,'2026-10-09 07:29:42','2026-10-09 07:29:42',NULL),(4,3,'truongvy2762005@gmail.com','GOOGLE_OAUTH_ACCOUNT','Vỹ kC',NULL,'https://lh3.googleusercontent.com/a/ACg8ocJ2NPbtjfbyyXQ6uch4KEjQnd--kzitj9wQpAmn2toz_4Tn4Bo=s96-c',1,'2026-10-15 05:57:00','2026-10-22 09:28:50',NULL),(5,3,'truongvy1022@gmail.com','GOOGLE_OAUTH_ACCOUNT','TC Vỹ',NULL,'https://lh3.googleusercontent.com/a/ACg8ocLhZ6L4w2K-WVrG7afxpApEK-nu_0Wpy6X0FIBpJWPBMPTP2KQ=s96-c',1,'2026-10-15 06:20:28','2026-10-22 09:28:50',NULL),(6,1,'admin@noithat.vn','$2b$10$pZW98jYWOjFUbibKOUiAPuAIEQyHsLYFTzkVF4oowryYGtmgu0agG','Quản Trị Viên','0359180209',NULL,1,'2026-10-16 05:07:04','2026-10-23 09:27:01',NULL),(7,1,'huuloi230605@gmail.com','$2b$10$eEOn1NBbmWBILnUzlZ6qHepjpy2xYhXV9ecPFrZYj7vOURP07GlDq','Phạm Hữu Lợi','0902455063','https://lh3.googleusercontent.com/a/ACg8ocLzhk1m_1LhcUGjj9gfktop0CQekD7_cbSo3lFwSz1ZgAnUK4_EBA=s96-c',1,'2026-10-18 12:53:49','2026-10-30 06:46:18',NULL),(8,3,'test@example.com','guest_no_login','Trần Văn Test VIP','0988777666',NULL,1,'2026-10-21 04:19:14','2026-10-23 14:47:58',NULL),(9,3,'testsim@example.com','guest_no_login','Tran Van Test Simulator','0988777999',NULL,1,'2026-10-21 04:19:22','2026-10-21 04:19:22',NULL),(10,3,'vabshop2026@gmail.com','$2b$10$kdtOAo.Wc18c8O7Ux6.JrufiviFJOIoiljjW.m8xYx1x7o56Vq41S','Vab Shop',NULL,'https://lh3.googleusercontent.com/a/ACg8ocJGscgmOMruAxUDT96bPa4yVCtZ8kUztI6RDwngAFTzFlJB1qk=s96-c',1,'2026-10-21 06:50:32','2026-10-21 06:50:32',NULL),(11,3,'khach_1792651669064@noithat.local','guest_no_login','Khách Test Coupon','0987654321',NULL,1,'2026-10-22 06:47:49','2026-10-22 06:47:49',NULL),(12,2,'vy.dang@noithat.vn','$2b$10$pqyJbU4XM/qEuQ3eWFCKoeP1.27WnKaTxXLcxHPe0Gj41jc/dcI6e','Đặng Thảo Vy','0909003003',NULL,1,'2026-10-23 07:29:41','2026-10-23 14:29:56',NULL),(13,3,'kkhoa2304@gmail.com','$2b$10$t.8oOrU25q8lSoxmSkReWOChoemJ.PMoAS6HzQ/MMPKWpSSOe3t1m','K Khoa','0877766122',NULL,1,'2026-10-27 02:22:57','2026-10-27 02:43:46',NULL),(14,3,'khach_1793067441199_269@noithat.local','guest_review','Nguyễn Văn Test','0901234567',NULL,1,'2026-10-27 02:17:21','2026-10-27 02:17:21',NULL),(15,3,'huuloi2005@gmail.com','$2b$10$OeapyVSWs1605d2VWuQGfe7KHgXztqCgUMM9qx8Vpcp/k2enQZDsO','Phạm Lợi','0902455060',NULL,1,'2026-10-28 02:55:10','2026-10-28 10:43:17',NULL),(30,3,'nhi@gmail.com','$2b$10$U2byzlPlD9J8vxO6cHYA7u1HTj2p.KU733QGZXdJq9lKob0tBrWbK','nhi','0123456799',NULL,1,'2026-10-28 10:31:14','2026-10-28 10:31:14',NULL),(31,3,'truongchivy9a4.19.20.nts1@gmail.com','$2b$10$Ugskhk8aR5yq0jnqOiyem.6yV0G.eI73UMSLSfLU5MUsfpTeiTlU6','truong chí vỹ','0348571843',NULL,1,'2026-10-28 23:16:58','2026-10-28 23:16:58',NULL),(32,3,'truongchivy27000@gmail.com','$2b$10$I2yzNfFICapQmnSdDx5bJ.Ux7Ku7T4tHCS.hZ1vRLnU8hyzztd2fS','truong chi vy','0359180208',NULL,1,'2026-10-29 00:18:03','2026-10-29 00:20:38',NULL),(33,3,'truongchivy27001@gmail.com','$2b$10$q4MNPUudU6Zzlyb3iqzGfOsUu1kKq8Q2jqV8k3rZ1FymNsrq8ppDm','truong chi vy','0359180207',NULL,1,'2026-10-29 01:06:46','2026-10-29 01:06:46',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlists`
--

DROP TABLE IF EXISTS `wishlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wishlists` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_product_wishlist` (`user_id`,`product_id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `wishlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wishlists_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlists`
--

LOCK TABLES `wishlists` WRITE;
/*!40000 ALTER TABLE `wishlists` DISABLE KEYS */;
INSERT INTO `wishlists` VALUES (2,4,13,'2026-10-16 08:09:57'),(4,5,16,'2026-10-22 02:47:34'),(5,7,21,'2026-11-04 07:44:02'),(6,7,20,'2026-11-04 07:44:04'),(7,7,12,'2026-11-04 07:44:06');
/*!40000 ALTER TABLE `wishlists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'web_ban_noi_that'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-05  9:51:53
