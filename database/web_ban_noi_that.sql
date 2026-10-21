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
  `button_text` varchar(100) DEFAULT 'Khám phá ngay',
  `position` varchar(50) NOT NULL DEFAULT 'hero',
  `display_order` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banners`
--

LOCK TABLES `banners` WRITE;
/*!40000 ALTER TABLE `banners` DISABLE KEYS */;
INSERT INTO `banners` VALUES (1,'NỘI THẤT','Bộ sưu tập 2026','Nội thất thiết kế cho không gian sống đẳng cấp — tuyển chọn từ những thương hiệu và xưởng chế tác hàng đầu.','https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1920&q=80','/san-pham','Khám phá ngay','hero',1,1,'2026-10-15 21:20:02','2026-10-15 21:20:02'),(2,'BỘ SƯU TẬP NỘI THẤT CAO CẤP','Không Gian Sống Nghệ Thuật & Đẳng Cấp','Tuyển chọn hơn 500+ mẫu thiết kế tinh xảo từ gỗ tự nhiên, da Ý cao cấp và kim loại mạ vàng sang trọng.','https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1920&q=80','/san-pham','Khám phá bộ sưu tập','san-pham',1,1,'2026-10-19 01:23:36','2026-10-19 01:23:36'),(3,'TƯ VẤN PHONG THỦY & BÀI TRÍ NỘI THẤT','Ứng Dụng Trí Tuệ Nhân Tạo Gemini AI & Bát Trạch','Định hướng sinh khí tài lộc, phối hợp màu sắc ngũ hành và bài trí nội thất chuẩn phong thủy cho gia chủ.','https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1920&q=80','/phong-thuy','Tra cứu cung mệnh ngay','phong-thuy',1,1,'2026-10-19 01:23:36','2026-10-19 01:23:36');
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
INSERT INTO `bot_prompts` VALUES (1,'system_prompt','Bạn là trợ lý AI ảo của cửa hàng Trai Đẹp Bán Nội Thất. Hãy tư vấn lịch sự, ngắn gọn và hữu ích cho khách hàng. Xưng hô là dạ/thưa.',1),(2,'shipping_policy','Giao hàng miễn phí nội thành cho đơn từ 2 triệu. Các tỉnh khác phí ship mặc định 100k.',1);
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
  `sender_id` bigint(20) unsigned DEFAULT NULL COMMENT 'ID của user hoặc seller nếu có',
  `content` text NOT NULL COMMENT 'Nội dung tin nhắn',
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  KEY `sender_id` (`sender_id`),
  CONSTRAINT `chat_messages_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `chat_sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chat_messages_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_messages`
--

LOCK TABLES `chat_messages` WRITE;
/*!40000 ALTER TABLE `chat_messages` DISABLE KEYS */;
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
  `guest_id` varchar(255) DEFAULT NULL COMMENT 'Cookie/Session ID cho khách vãng lai',
  `status` enum('bot_handling','human_requested','human_handling','closed') DEFAULT 'bot_handling',
  `started_at` datetime DEFAULT current_timestamp(),
  `ended_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `chat_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_sessions`
--

LOCK TABLES `chat_sessions` WRITE;
/*!40000 ALTER TABLE `chat_sessions` DISABLE KEYS */;
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
  `discount_type` enum('percent','fixed_amount') NOT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupons`
--

LOCK TABLES `coupons` WRITE;
/*!40000 ALTER TABLE `coupons` DISABLE KEYS */;
/*!40000 ALTER TABLE `coupons` ENABLE KEYS */;
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
  `product_name` varchar(255) NOT NULL COMMENT 'Tên lưu cứng lúc mua',
  `variant_name` varchar(255) DEFAULT NULL COMMENT 'Màu/Chất liệu lưu cứng',
  `sku` varchar(50) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL COMMENT 'Giá lưu cứng lúc mua',
  `total_price` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  KEY `variant_id` (`variant_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL,
  CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (6,5,20,20,'sofa_đen nhám',NULL,'SOFADEN_NHAM_001',1,7500000.00,7500000.00),(7,6,12,12,'Tủ quần áo 4 cánh',NULL,'SKU-TU-QUAN-AO-4-CANH',1,24500000.00,24500000.00),(8,7,20,20,'sofa_đen nhám',NULL,'SOFADEN_NHAM_001',1,7500000.00,7500000.00);
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
  `shipping_address` text NOT NULL COMMENT 'Lưu cứng địa chỉ text/JSON lúc đặt',
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (5,'NT-2610-9661',3,NULL,'543b tân phú, r, TP. Hồ Chí Minh',0.00,7500000.00,0.00,7500000.00,'cod','pending','pending',NULL,NULL,'2026-10-16 04:13:03','2026-10-16 04:13:03'),(6,'NT-2610-5385',3,NULL,'110d tân quý, tân phú, HCM, r, TP. Hồ Chí Minh',0.00,24500000.00,0.00,24500000.00,'cod','pending','pending',NULL,NULL,'2026-10-16 08:36:49','2026-10-16 08:36:49'),(7,'NT-2610-3221',7,NULL,'412, Tân Phú, TP. Hồ Chí Minh',0.00,7500000.00,0.00,7500000.00,'cod','pending','pending',NULL,NULL,'2026-10-18 13:02:12','2026-10-18 13:02:12');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES (1,20,NULL,'https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcRki-yI52sFUUgMgey0RaCVX8DJkX5Vs2qx1TZhr0wbKwUYbS5Mo_2IviRrNzQOG3xih_u-xAldpoQGMviu9ia-Fx1kC0j0d6Am1I5dDVktCDHeadrSxaSBkA&usqp=CAc',1,0),(5,20,NULL,'http://localhost:4000/uploads/prod-anh-NT4-1792120685145-93706.jpg',0,1),(6,20,NULL,'http://localhost:4000/uploads/prod-anh-NT3-1792120685151-71667.jpg',0,2),(7,20,NULL,'http://localhost:4000/uploads/prod-anh-NT2-1792120685155-7455.jpg',0,3),(8,1,NULL,'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80',1,0),(9,2,NULL,'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?auto=format&fit=crop&w=600&q=80',1,0),(10,3,NULL,'https://images.unsplash.com/photo-1540574163026-643ea20ade25?auto=format&fit=crop&w=600&q=80',1,0),(11,4,NULL,'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=600&q=80',1,0),(12,5,NULL,'https://images.unsplash.com/photo-1577140917170-285929fb55b7?auto=format&fit=crop&w=600&q=80',1,0),(13,6,NULL,'https://images.unsplash.com/photo-1580481077198-c847ad43616b?auto=format&fit=crop&w=600&q=80',1,0),(14,7,NULL,'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=600&q=80',1,0),(15,8,NULL,'https://images.unsplash.com/photo-1505797149-43b0069ec26b?auto=format&fit=crop&w=600&q=80',1,0),(16,9,NULL,'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=600&q=80',1,0),(17,10,NULL,'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=600&q=80',1,0),(18,11,NULL,'https://images.unsplash.com/photo-1540518614846-7ede433c4ef9?auto=format&fit=crop&w=600&q=80',1,0),(19,12,NULL,'https://www.noithatkaya.com/wp-content/uploads/2023/09/Tu-Quan-Ao-17.jpg',1,0),(20,13,NULL,'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=600&q=80',1,0),(21,14,NULL,'https://images.unsplash.com/photo-1594671581654-278554dd3460?auto=format&fit=crop&w=600&q=80',1,0),(22,15,NULL,'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=600&q=80',1,0),(23,16,NULL,'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&w=600&q=80',1,0),(24,17,NULL,'https://images.unsplash.com/photo-1534349762230-e0cadf78f5da?auto=format&fit=crop&w=600&q=80',1,0),(25,18,NULL,'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?auto=format&fit=crop&w=600&q=80',1,0),(26,19,NULL,'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=600&q=80',1,0);
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
  `compare_at_price` decimal(15,2) DEFAULT NULL,
  `stock_quantity` int(11) DEFAULT 0,
  `weight_gram` int(11) DEFAULT NULL COMMENT 'Dùng để tính phí ship',
  `dimensions` varchar(50) DEFAULT NULL COMMENT 'Dài x Rộng x Cao',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sku` (`sku`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_variants_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_variants`
--

LOCK TABLES `product_variants` WRITE;
/*!40000 ALTER TABLE `product_variants` DISABLE KEYS */;
INSERT INTO `product_variants` VALUES (1,1,'SKU-SOFA-DA-Y-MILANO',NULL,'Da bò Ý',58900000.00,NULL,20,NULL,'240 × 95 × 78 cm'),(2,2,'SKU-SOFA-VAI-LINEN-OSLO',NULL,'Vải linen',26500000.00,NULL,20,NULL,'210 × 88 × 80 cm'),(3,3,'SKU-SOFA-GOC-BAC-AU',NULL,'Vải bố',32900000.00,NULL,20,NULL,'270 × 180 × 82 cm'),(4,4,'SKU-BAN-AN-DA-MARBLE-CARRARA',NULL,'Đá marble',32500000.00,NULL,20,NULL,'180 × 90 × 75 cm'),(5,5,'SKU-BAN-AN-GO-SOI-NGA',NULL,'Gỗ sồi',18900000.00,NULL,20,NULL,'160 × 80 × 75 cm'),(6,6,'SKU-GHE-AN-DA-BOC-Y',NULL,'Da công nghiệp',4200000.00,NULL,20,NULL,'48 × 55 × 88 cm'),(7,7,'SKU-GHE-THU-GIAN-GO-OC-CHO',NULL,'Gỗ óc chó',18900000.00,NULL,20,NULL,'72 × 80 × 95 cm'),(8,8,'SKU-GHE-CONG-THAI-HOC-ERGO',NULL,'Lưới & nhựa',6900000.00,NULL,20,NULL,'66 × 66 × 118 cm'),(9,9,'SKU-GHE-NGOAI-TROI-GO-TEAK',NULL,'Gỗ teak',8900000.00,NULL,20,NULL,'58 × 62 × 85 cm'),(10,10,'SKU-GIUONG-BOC-NI-VELVET',NULL,'Nỉ velvet',22900000.00,NULL,20,NULL,'180 × 200 × 110 cm'),(11,11,'SKU-GIUONG-GO-TU-NHIEN-SCANDINAVIAN',NULL,'Gỗ sồi',28500000.00,NULL,20,NULL,'160 × 200 × 95 cm'),(12,12,'SKU-TU-QUAN-AO-4-CANH',NULL,'Gỗ MDF',11000000.00,NULL,20,NULL,'200 × 60 × 220 cm'),(13,13,'SKU-KE-TIVI-TREO-TUONG',NULL,'Gỗ công nghiệp',9800000.00,NULL,20,NULL,'180 × 35 × 40 cm'),(14,14,'SKU-KE-SACH-GO-THONG',NULL,'Gỗ thông',7200000.00,NULL,20,NULL,'80 × 30 × 180 cm'),(15,15,'SKU-DEN-SAN-DONG-THAU',NULL,'Đồng thau',7900000.00,NULL,20,NULL,'Ø 40 × 160 cm'),(16,16,'SKU-DEN-THA-TRAN-MAY',NULL,'Mây tự nhiên',3400000.00,NULL,20,NULL,'Ø 55 × 40 cm'),(17,17,'SKU-DEN-BAN-GOM',NULL,'Gốm',1900000.00,NULL,20,NULL,'Ø 25 × 45 cm'),(18,18,'SKU-BAN-TRA-MAT-KINH',NULL,'Kính cường lực',5600000.00,NULL,20,NULL,'120 × 60 × 42 cm'),(19,19,'SKU-GUONG-TRANG-TRI-VIEN-VANG',NULL,'Hợp kim mạ',3100000.00,NULL,20,NULL,'60 × 90 cm'),(20,20,'SOFADEN_NHAM_001',NULL,'da bò',7500000.00,NULL,20,NULL,NULL);
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
  `status` tinyint(1) DEFAULT 1 COMMENT '1: Đang bán, 0: Ngừng bán',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,1,'Sofa da Ý Milano','sofa-da-y-milano','Sofa ba chỗ bọc da bò Ý nguyên tấm, khung gỗ sồi sấy khô và đệm mút đàn hồi cao cấp, giữ phom bền theo thời gian.',NULL,NULL,28,1,'2026-10-08 09:00:01','2026-10-21 10:45:37',NULL),(2,1,'Sofa vải linen Oslo','sofa-vai-linen-oslo','Sofa vải linen thoáng mát, đường may tỉ mỉ, chân gỗ chế tác thủ công, phù hợp không gian sống tối giản.',NULL,NULL,33,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(3,1,'Sofa góc Bắc Âu','sofa-goc-bac-au','Sofa góc chữ L phong cách Bắc Âu, các mô-đun tháo rời và đổi hướng linh hoạt theo bố cục phòng.',NULL,NULL,30,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(4,2,'Bàn ăn đá marble Carrara','ban-an-da-marble-carrara','Bàn ăn mặt đá marble Carrara nhập khẩu, chân kim loại mạ titan chống gỉ, mặt bàn được xử lý chống thấm.',NULL,NULL,31,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(5,2,'Bàn ăn gỗ sồi Nga','ban-an-go-soi-nga','Bàn ăn gỗ sồi Nga nguyên khối, phủ dầu bảo vệ tự nhiên giữ trọn vân gỗ và độ ấm của chất liệu.',NULL,NULL,22,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(6,3,'Ghế ăn da bọc Ý','ghe-an-da-boc-y','Ghế ăn bọc da công nghiệp cao cấp, khung thép chịu lực, đệm êm vừa vặn cho bữa ăn dài.',NULL,NULL,22,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(7,3,'Ghế thư giãn gỗ óc chó','ghe-thu-gian-go-oc-cho','Ghế thư giãn gỗ óc chó, tựa lưng cong theo cơ thể, đệm vải nhập khẩu tạo cảm giác dễ chịu khi đọc sách.',NULL,NULL,24,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(8,3,'Ghế công thái học Ergo','ghe-cong-thai-hoc-ergo','Ghế công thái học lưng lưới, tựa đầu và tay vịn điều chỉnh ba hướng, hỗ trợ cột sống khi làm việc dài.',NULL,NULL,22,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(9,3,'Ghế ngoài trời gỗ teak','ghe-ngoai-troi-go-teak','Ghế ngoài trời gỗ teak chống mối mọt và chịu được mưa nắng, phù hợp ban công, sân vườn.',NULL,NULL,22,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(10,4,'Giường ngủ bọc nỉ Velvet','giuong-boc-ni-velvet','Giường bọc nỉ velvet với đầu giường cao, khung gỗ chắc chắn và hệ nan đệm êm ái.',NULL,NULL,22,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(11,4,'Giường gỗ tự nhiên Scandinavian','giuong-go-tu-nhien-scandinavian','Giường gỗ sồi tự nhiên tối giản, bề mặt phủ dầu mờ an toàn cho sức khỏe và dễ vệ sinh.',NULL,NULL,22,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(12,5,'Tủ quần áo 4 cánh','tu-quan-ao-4-canh','Tủ quần áo bốn cánh gỗ MDF chống ẩm, ray giảm chấn và hệ ngăn chia tiện dụng.',NULL,NULL,31,1,'2026-10-08 09:00:02','2026-10-21 10:25:39',NULL),(13,5,'Kệ tivi treo tường','ke-tivi-treo-tuong','Kệ tivi treo tường gọn gàng, có lỗ đi dây điện và tải trọng tới 60 kg.',NULL,NULL,25,1,'2026-10-08 09:00:02','2026-10-19 15:06:45',NULL),(14,5,'Kệ sách gỗ thông','ke-sach-go-thong','Kệ sách gỗ thông năm tầng, thiết kế mở giúp góc làm việc thoáng đãng và dễ sắp xếp.',NULL,NULL,22,1,'2026-10-08 09:00:02','2026-10-18 19:49:55',NULL),(15,6,'Đèn sàn đồng thau','den-san-dong-thau','Đèn sàn đồng thau thân mảnh, chao vải tản sáng dịu, tạo điểm nhấn cho góc đọc sách.',NULL,NULL,22,1,'2026-10-08 09:00:02','2026-10-18 19:49:55',NULL),(16,6,'Đèn thả trần mây','den-tha-tran-may','Đèn thả trần đan mây tự nhiên, ánh sáng ấm áp, phù hợp treo trên bàn ăn hoặc đảo bếp.',NULL,NULL,22,1,'2026-10-08 09:00:02','2026-10-18 19:49:55',NULL),(17,6,'Đèn bàn gốm','den-ban-gom','Đèn bàn gốm men mờ, chụp vải, cho ánh sáng vàng ấm phù hợp bàn làm việc và đầu giường.',NULL,NULL,22,1,'2026-10-08 09:00:02','2026-10-18 19:49:55',NULL),(18,7,'Bàn trà mặt kính','ban-tra-mat-kinh','Bàn trà mặt kính cường lực 12 mm, khung inox mạ vàng sang trọng, dễ lau chùi.',NULL,NULL,22,1,'2026-10-08 09:00:02','2026-10-18 19:49:55',NULL),(19,7,'Gương trang trí viền mạ vàng','guong-trang-tri-vien-vang','Gương trang trí viền hợp kim mạ vàng, treo ngang hoặc dọc đều cân đối cho phòng ngủ.',NULL,NULL,22,1,'2026-10-08 09:00:02','2026-10-18 19:49:55',NULL),(20,1,'Sofa Đen Nhám','sofaden-nham','sofa cao cấp',NULL,NULL,111,1,'2026-10-15 16:33:12','2026-10-19 07:46:28',NULL);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin','Quản trị viên toàn quyền'),(2,'seller','Người bán hàng, quản lý sản phẩm, đơn hàng'),(3,'customer','Khách mua hàng');
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
  `session_id` varchar(255) DEFAULT NULL COMMENT 'Dành cho khách chưa đăng nhập',
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,3,'hi@gmail.com','$2b$10$H3ndNj83h9RJ8QOHeiDei.5W0.REvZ.zcKgKV10Tv5AJTcL3QLnH.','hi','0903456789',NULL,1,'2026-10-09 06:18:11','2026-10-16 12:13:46',NULL),(2,3,'test@gmail.com','guest_no_login','Nguyễn Văn Test','0988776655',NULL,1,'2026-10-09 06:45:38','2026-10-09 06:45:38',NULL),(3,3,'truongvy6272005@gmail.com','guest_no_login','vy truong','0123456789',NULL,1,'2026-10-09 07:29:42','2026-10-09 07:29:42',NULL),(4,3,'truongvy2762005@gmail.com','GOOGLE_OAUTH_ACCOUNT','Vỹ kC',NULL,'https://lh3.googleusercontent.com/a/ACg8ocJ2NPbtjfbyyXQ6uch4KEjQnd--kzitj9wQpAmn2toz_4Tn4Bo=s96-c',1,'2026-10-15 05:57:00','2026-10-15 05:57:00',NULL),(5,3,'truongvy1022@gmail.com','GOOGLE_OAUTH_ACCOUNT','TC Vỹ',NULL,'https://lh3.googleusercontent.com/a/ACg8ocLhZ6L4w2K-WVrG7afxpApEK-nu_0Wpy6X0FIBpJWPBMPTP2KQ=s96-c',1,'2026-10-15 06:20:28','2026-10-15 06:20:28',NULL),(6,1,'admin@noithat.vn','$2b$10$pZW98jYWOjFUbibKOUiAPuAIEQyHsLYFTzkVF4oowryYGtmgu0agG','Quản Trị Viên Cấp Cao',NULL,NULL,1,'2026-10-16 05:07:04','2026-10-16 05:07:04',NULL),(7,1,'huuloi230605@gmail.com','$2b$10$eEOn1NBbmWBILnUzlZ6qHepjpy2xYhXV9ecPFrZYj7vOURP07GlDq','Phạm Hữu Lợi',NULL,'https://lh3.googleusercontent.com/a/ACg8ocLzhk1m_1LhcUGjj9gfktop0CQekD7_cbSo3lFwSz1ZgAnUK4_EBA=s96-c',1,'2026-10-18 12:53:49','2026-10-18 20:10:05',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlists`
--

LOCK TABLES `wishlists` WRITE;
/*!40000 ALTER TABLE `wishlists` DISABLE KEYS */;
INSERT INTO `wishlists` VALUES (2,4,13,'2026-10-16 08:09:57');
/*!40000 ALTER TABLE `wishlists` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-21 10:46:22
