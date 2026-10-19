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
  `button_text` varchar(100) DEFAULT 'KhĂ¡m phĂ¡ ngay',
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
INSERT INTO `banners` VALUES (1,'Ná»˜I THáº¤T','Bá»™ sÆ°u táº­p 2026','Ná»™i tháº¥t thiáº¿t káº¿ cho khĂ´ng gian sá»‘ng Ä‘áº³ng cáº¥p â€” tuyá»ƒn chá»n tá»« nhá»¯ng thÆ°Æ¡ng hiá»‡u vĂ  xÆ°á»Ÿng cháº¿ tĂ¡c hĂ ng Ä‘áº§u.','https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1920&q=80','/san-pham','KhĂ¡m phĂ¡ ngay','hero',1,1,'2026-10-15 21:20:02','2026-10-15 21:20:02'),(2,'Bá»˜ SÆ¯U Táº¬P Ná»˜I THáº¤T CAO Cáº¤P','KhĂ´ng Gian Sá»‘ng Nghá»‡ Thuáº­t & Äáº³ng Cáº¥p','Tuyá»ƒn chá»n hÆ¡n 500+ máº«u thiáº¿t káº¿ tinh xáº£o tá»« gá»— tá»± nhiĂªn, da Ă cao cáº¥p vĂ  kim loáº¡i máº¡ vĂ ng sang trá»ng.','https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1920&q=80','/san-pham','KhĂ¡m phĂ¡ bá»™ sÆ°u táº­p','san-pham',1,1,'2026-10-19 01:23:36','2026-10-19 01:23:36'),(3,'TÆ¯ Váº¤N PHONG THá»¦Y & BĂ€I TRĂ Ná»˜I THáº¤T','á»¨ng Dá»¥ng TrĂ­ Tuá»‡ NhĂ¢n Táº¡o Gemini AI & BĂ¡t Tráº¡ch','Äá»‹nh hÆ°á»›ng sinh khĂ­ tĂ i lá»™c, phá»‘i há»£p mĂ u sáº¯c ngÅ© hĂ nh vĂ  bĂ i trĂ­ ná»™i tháº¥t chuáº©n phong thá»§y cho gia chá»§.','https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1920&q=80','/phong-thuy','Tra cá»©u cung má»‡nh ngay','phong-thuy',1,1,'2026-10-19 01:23:36','2026-10-19 01:23:36');
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
INSERT INTO `bot_prompts` VALUES (1,'system_prompt','Báº¡n lĂ  trá»£ lĂ½ AI áº£o cá»§a cá»­a hĂ ng Trai Äáº¹p BĂ¡n Ná»™i Tháº¥t. HĂ£y tÆ° váº¥n lá»‹ch sá»±, ngáº¯n gá»n vĂ  há»¯u Ă­ch cho khĂ¡ch hĂ ng. XÆ°ng hĂ´ lĂ  dáº¡/thÆ°a.',1),(2,'shipping_policy','Giao hĂ ng miá»…n phĂ­ ná»™i thĂ nh cho Ä‘Æ¡n tá»« 2 triá»‡u. CĂ¡c tá»‰nh khĂ¡c phĂ­ ship máº·c Ä‘á»‹nh 100k.',1);
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
INSERT INTO `categories` VALUES (1,NULL,'Sofa','sofa',NULL,1),(2,NULL,'BĂ n Äƒn','ban-an',NULL,1),(3,NULL,'Gháº¿','ghe',NULL,1),(4,NULL,'GiÆ°á»ng','giuong',NULL,1),(5,NULL,'Tá»§ & Ká»‡','tu-ke',NULL,1),(6,NULL,'ÄĂ¨n','den',NULL,1),(7,NULL,'Trang trĂ­','trang-tri',NULL,1);
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
  `guest_id` varchar(255) DEFAULT NULL COMMENT 'Cookie/Session ID cho khĂ¡ch vĂ£ng lai',
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
  `product_name` varchar(255) NOT NULL COMMENT 'TĂªn lÆ°u cá»©ng lĂºc mua',
  `variant_name` varchar(255) DEFAULT NULL COMMENT 'MĂ u/Cháº¥t liá»‡u lÆ°u cá»©ng',
  `sku` varchar(50) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL COMMENT 'GiĂ¡ lÆ°u cá»©ng lĂºc mua',
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
INSERT INTO `order_items` VALUES (6,5,20,20,'sofa_Ä‘en nhĂ¡m',NULL,'SOFADEN_NHAM_001',1,7500000.00,7500000.00),(7,6,12,12,'Tá»§ quáº§n Ă¡o 4 cĂ¡nh',NULL,'SKU-TU-QUAN-AO-4-CANH',1,24500000.00,24500000.00),(8,7,20,20,'sofa_Ä‘en nhĂ¡m',NULL,'SOFADEN_NHAM_001',1,7500000.00,7500000.00);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (5,'NT-2610-9661',3,NULL,'543b tĂ¢n phĂº, r, TP. Há»“ ChĂ­ Minh',0.00,7500000.00,0.00,7500000.00,'cod','pending','pending',NULL,NULL,'2026-10-16 04:13:03','2026-10-16 04:13:03'),(6,'NT-2610-5385',3,NULL,'110d tĂ¢n quĂ½, tĂ¢n phĂº, HCM, r, TP. Há»“ ChĂ­ Minh',0.00,24500000.00,0.00,24500000.00,'cod','pending','pending',NULL,NULL,'2026-10-16 08:36:49','2026-10-16 08:36:49'),(7,'NT-2610-3221',7,NULL,'412, TĂ¢n PhĂº, TP. Há»“ ChĂ­ Minh',0.00,7500000.00,0.00,7500000.00,'cod','pending','pending',NULL,NULL,'2026-10-18 13:02:12','2026-10-18 13:02:12');
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
  `weight_gram` int(11) DEFAULT NULL COMMENT 'DĂ¹ng Ä‘á»ƒ tĂ­nh phĂ­ ship',
  `dimensions` varchar(50) DEFAULT NULL COMMENT 'DĂ i x Rá»™ng x Cao',
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
INSERT INTO `product_variants` VALUES (1,1,'SKU-SOFA-DA-Y-MILANO',NULL,'Da bĂ² Ă',58900000.00,NULL,20,NULL,'240 Ă— 95 Ă— 78 cm'),(2,2,'SKU-SOFA-VAI-LINEN-OSLO',NULL,'Váº£i linen',26500000.00,NULL,20,NULL,'210 Ă— 88 Ă— 80 cm'),(3,3,'SKU-SOFA-GOC-BAC-AU',NULL,'Váº£i bá»‘',32900000.00,NULL,20,NULL,'270 Ă— 180 Ă— 82 cm'),(4,4,'SKU-BAN-AN-DA-MARBLE-CARRARA',NULL,'ÄĂ¡ marble',32500000.00,NULL,20,NULL,'180 Ă— 90 Ă— 75 cm'),(5,5,'SKU-BAN-AN-GO-SOI-NGA',NULL,'Gá»— sá»“i',18900000.00,NULL,20,NULL,'160 Ă— 80 Ă— 75 cm'),(6,6,'SKU-GHE-AN-DA-BOC-Y',NULL,'Da cĂ´ng nghiá»‡p',4200000.00,NULL,20,NULL,'48 Ă— 55 Ă— 88 cm'),(7,7,'SKU-GHE-THU-GIAN-GO-OC-CHO',NULL,'Gá»— Ă³c chĂ³',18900000.00,NULL,20,NULL,'72 Ă— 80 Ă— 95 cm'),(8,8,'SKU-GHE-CONG-THAI-HOC-ERGO',NULL,'LÆ°á»›i & nhá»±a',6900000.00,NULL,20,NULL,'66 Ă— 66 Ă— 118 cm'),(9,9,'SKU-GHE-NGOAI-TROI-GO-TEAK',NULL,'Gá»— teak',8900000.00,NULL,20,NULL,'58 Ă— 62 Ă— 85 cm'),(10,10,'SKU-GIUONG-BOC-NI-VELVET',NULL,'Ná»‰ velvet',22900000.00,NULL,20,NULL,'180 Ă— 200 Ă— 110 cm'),(11,11,'SKU-GIUONG-GO-TU-NHIEN-SCANDINAVIAN',NULL,'Gá»— sá»“i',28500000.00,NULL,20,NULL,'160 Ă— 200 Ă— 95 cm'),(12,12,'SKU-TU-QUAN-AO-4-CANH',NULL,'Gá»— MDF',11000000.00,NULL,20,NULL,'200 Ă— 60 Ă— 220 cm'),(13,13,'SKU-KE-TIVI-TREO-TUONG',NULL,'Gá»— cĂ´ng nghiá»‡p',9800000.00,NULL,20,NULL,'180 Ă— 35 Ă— 40 cm'),(14,14,'SKU-KE-SACH-GO-THONG',NULL,'Gá»— thĂ´ng',7200000.00,NULL,20,NULL,'80 Ă— 30 Ă— 180 cm'),(15,15,'SKU-DEN-SAN-DONG-THAU',NULL,'Äá»“ng thau',7900000.00,NULL,20,NULL,'Ă˜ 40 Ă— 160 cm'),(16,16,'SKU-DEN-THA-TRAN-MAY',NULL,'MĂ¢y tá»± nhiĂªn',3400000.00,NULL,20,NULL,'Ă˜ 55 Ă— 40 cm'),(17,17,'SKU-DEN-BAN-GOM',NULL,'Gá»‘m',1900000.00,NULL,20,NULL,'Ă˜ 25 Ă— 45 cm'),(18,18,'SKU-BAN-TRA-MAT-KINH',NULL,'KĂ­nh cÆ°á»ng lá»±c',5600000.00,NULL,20,NULL,'120 Ă— 60 Ă— 42 cm'),(19,19,'SKU-GUONG-TRANG-TRI-VIEN-VANG',NULL,'Há»£p kim máº¡',3100000.00,NULL,20,NULL,'60 Ă— 90 cm'),(20,20,'SOFADEN_NHAM_001',NULL,'da bĂ²',7500000.00,NULL,20,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,1,'Sofa da Ă Milano','sofa-da-y-milano','Sofa ba chá»— bá»c da bĂ² Ă nguyĂªn táº¥m, khung gá»— sá»“i sáº¥y khĂ´ vĂ  Ä‘á»‡m mĂºt Ä‘Ă n há»“i cao cáº¥p, giá»¯ phom bá»n theo thá»i gian.',NULL,NULL,26,1,'2026-10-08 09:00:01','2026-10-19 14:41:04',NULL),(2,1,'Sofa váº£i linen Oslo','sofa-vai-linen-oslo','Sofa váº£i linen thoĂ¡ng mĂ¡t, Ä‘Æ°á»ng may tá»‰ má»‰, chĂ¢n gá»— cháº¿ tĂ¡c thá»§ cĂ´ng, phĂ¹ há»£p khĂ´ng gian sá»‘ng tá»‘i giáº£n.',NULL,NULL,33,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(3,1,'Sofa gĂ³c Báº¯c Ă‚u','sofa-goc-bac-au','Sofa gĂ³c chá»¯ L phong cĂ¡ch Báº¯c Ă‚u, cĂ¡c mĂ´-Ä‘un thĂ¡o rá»i vĂ  Ä‘á»•i hÆ°á»›ng linh hoáº¡t theo bá»‘ cá»¥c phĂ²ng.',NULL,NULL,30,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(4,2,'BĂ n Äƒn Ä‘Ă¡ marble Carrara','ban-an-da-marble-carrara','BĂ n Äƒn máº·t Ä‘Ă¡ marble Carrara nháº­p kháº©u, chĂ¢n kim loáº¡i máº¡ titan chá»‘ng gá»‰, máº·t bĂ n Ä‘Æ°á»£c xá»­ lĂ½ chá»‘ng tháº¥m.',NULL,NULL,31,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(5,2,'BĂ n Äƒn gá»— sá»“i Nga','ban-an-go-soi-nga','BĂ n Äƒn gá»— sá»“i Nga nguyĂªn khá»‘i, phá»§ dáº§u báº£o vá»‡ tá»± nhiĂªn giá»¯ trá»n vĂ¢n gá»— vĂ  Ä‘á»™ áº¥m cá»§a cháº¥t liá»‡u.',NULL,NULL,22,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(6,3,'Gháº¿ Äƒn da bá»c Ă','ghe-an-da-boc-y','Gháº¿ Äƒn bá»c da cĂ´ng nghiá»‡p cao cáº¥p, khung thĂ©p chá»‹u lá»±c, Ä‘á»‡m Ăªm vá»«a váº·n cho bá»¯a Äƒn dĂ i.',NULL,NULL,22,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(7,3,'Gháº¿ thÆ° giĂ£n gá»— Ă³c chĂ³','ghe-thu-gian-go-oc-cho','Gháº¿ thÆ° giĂ£n gá»— Ă³c chĂ³, tá»±a lÆ°ng cong theo cÆ¡ thá»ƒ, Ä‘á»‡m váº£i nháº­p kháº©u táº¡o cáº£m giĂ¡c dá»… chá»‹u khi Ä‘á»c sĂ¡ch.',NULL,NULL,24,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(8,3,'Gháº¿ cĂ´ng thĂ¡i há»c Ergo','ghe-cong-thai-hoc-ergo','Gháº¿ cĂ´ng thĂ¡i há»c lÆ°ng lÆ°á»›i, tá»±a Ä‘áº§u vĂ  tay vá»‹n Ä‘iá»u chá»‰nh ba hÆ°á»›ng, há»— trá»£ cá»™t sá»‘ng khi lĂ m viá»‡c dĂ i.',NULL,NULL,22,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(9,3,'Gháº¿ ngoĂ i trá»i gá»— teak','ghe-ngoai-troi-go-teak','Gháº¿ ngoĂ i trá»i gá»— teak chá»‘ng má»‘i má»t vĂ  chá»‹u Ä‘Æ°á»£c mÆ°a náº¯ng, phĂ¹ há»£p ban cĂ´ng, sĂ¢n vÆ°á»n.',NULL,NULL,22,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(10,4,'GiÆ°á»ng ngá»§ bá»c ná»‰ Velvet','giuong-boc-ni-velvet','GiÆ°á»ng bá»c ná»‰ velvet vá»›i Ä‘áº§u giÆ°á»ng cao, khung gá»— cháº¯c cháº¯n vĂ  há»‡ nan Ä‘á»‡m Ăªm Ă¡i.',NULL,NULL,22,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(11,4,'GiÆ°á»ng gá»— tá»± nhiĂªn Scandinavian','giuong-go-tu-nhien-scandinavian','GiÆ°á»ng gá»— sá»“i tá»± nhiĂªn tá»‘i giáº£n, bá» máº·t phá»§ dáº§u má» an toĂ n cho sá»©c khá»e vĂ  dá»… vá»‡ sinh.',NULL,NULL,22,1,'2026-10-08 09:00:01','2026-10-18 19:49:55',NULL),(12,5,'Tá»§ quáº§n Ă¡o 4 cĂ¡nh','tu-quan-ao-4-canh','Tá»§ quáº§n Ă¡o bá»‘n cĂ¡nh gá»— MDF chá»‘ng áº©m, ray giáº£m cháº¥n vĂ  há»‡ ngÄƒn chia tiá»‡n dá»¥ng.',NULL,NULL,30,1,'2026-10-08 09:00:02','2026-10-19 15:16:34',NULL),(13,5,'Ká»‡ tivi treo tÆ°á»ng','ke-tivi-treo-tuong','Ká»‡ tivi treo tÆ°á»ng gá»n gĂ ng, cĂ³ lá»— Ä‘i dĂ¢y Ä‘iá»‡n vĂ  táº£i trá»ng tá»›i 60 kg.',NULL,NULL,25,1,'2026-10-08 09:00:02','2026-10-19 15:06:45',NULL),(14,5,'Ká»‡ sĂ¡ch gá»— thĂ´ng','ke-sach-go-thong','Ká»‡ sĂ¡ch gá»— thĂ´ng nÄƒm táº§ng, thiáº¿t káº¿ má»Ÿ giĂºp gĂ³c lĂ m viá»‡c thoĂ¡ng Ä‘Ă£ng vĂ  dá»… sáº¯p xáº¿p.',NULL,NULL,22,1,'2026-10-08 09:00:02','2026-10-18 19:49:55',NULL),(15,6,'ÄĂ¨n sĂ n Ä‘á»“ng thau','den-san-dong-thau','ÄĂ¨n sĂ n Ä‘á»“ng thau thĂ¢n máº£nh, chao váº£i táº£n sĂ¡ng dá»‹u, táº¡o Ä‘iá»ƒm nháº¥n cho gĂ³c Ä‘á»c sĂ¡ch.',NULL,NULL,22,1,'2026-10-08 09:00:02','2026-10-18 19:49:55',NULL),(16,6,'ÄĂ¨n tháº£ tráº§n mĂ¢y','den-tha-tran-may','ÄĂ¨n tháº£ tráº§n Ä‘an mĂ¢y tá»± nhiĂªn, Ă¡nh sĂ¡ng áº¥m Ă¡p, phĂ¹ há»£p treo trĂªn bĂ n Äƒn hoáº·c Ä‘áº£o báº¿p.',NULL,NULL,22,1,'2026-10-08 09:00:02','2026-10-18 19:49:55',NULL),(17,6,'ÄĂ¨n bĂ n gá»‘m','den-ban-gom','ÄĂ¨n bĂ n gá»‘m men má», chá»¥p váº£i, cho Ă¡nh sĂ¡ng vĂ ng áº¥m phĂ¹ há»£p bĂ n lĂ m viá»‡c vĂ  Ä‘áº§u giÆ°á»ng.',NULL,NULL,22,1,'2026-10-08 09:00:02','2026-10-18 19:49:55',NULL),(18,7,'BĂ n trĂ  máº·t kĂ­nh','ban-tra-mat-kinh','BĂ n trĂ  máº·t kĂ­nh cÆ°á»ng lá»±c 12 mm, khung inox máº¡ vĂ ng sang trá»ng, dá»… lau chĂ¹i.',NULL,NULL,22,1,'2026-10-08 09:00:02','2026-10-18 19:49:55',NULL),(19,7,'GÆ°Æ¡ng trang trĂ­ viá»n máº¡ vĂ ng','guong-trang-tri-vien-vang','GÆ°Æ¡ng trang trĂ­ viá»n há»£p kim máº¡ vĂ ng, treo ngang hoáº·c dá»c Ä‘á»u cĂ¢n Ä‘á»‘i cho phĂ²ng ngá»§.',NULL,NULL,22,1,'2026-10-08 09:00:02','2026-10-18 19:49:55',NULL),(20,1,'Sofa Äen NhĂ¡m','sofaden-nham','sofa cao cáº¥p',NULL,NULL,111,1,'2026-10-15 16:33:12','2026-10-19 07:46:28',NULL);
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
INSERT INTO `roles` VALUES (1,'admin','Quáº£n trá»‹ viĂªn toĂ n quyá»n'),(2,'seller','NgÆ°á»i bĂ¡n hĂ ng, quáº£n lĂ½ sáº£n pháº©m, Ä‘Æ¡n hĂ ng'),(3,'customer','KhĂ¡ch mua hĂ ng');
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
INSERT INTO `users` VALUES (1,3,'hi@gmail.com','$2b$10$H3ndNj83h9RJ8QOHeiDei.5W0.REvZ.zcKgKV10Tv5AJTcL3QLnH.','hi','0903456789',NULL,1,'2026-10-09 06:18:11','2026-10-16 12:13:46',NULL),(2,3,'test@gmail.com','guest_no_login','Nguyá»…n VÄƒn Test','0988776655',NULL,1,'2026-10-09 06:45:38','2026-10-09 06:45:38',NULL),(3,3,'truongvy6272005@gmail.com','guest_no_login','vy truong','0123456789',NULL,1,'2026-10-09 07:29:42','2026-10-09 07:29:42',NULL),(4,3,'truongvy2762005@gmail.com','GOOGLE_OAUTH_ACCOUNT','Vá»¹ kC',NULL,'https://lh3.googleusercontent.com/a/ACg8ocJ2NPbtjfbyyXQ6uch4KEjQnd--kzitj9wQpAmn2toz_4Tn4Bo=s96-c',1,'2026-10-15 05:57:00','2026-10-15 05:57:00',NULL),(5,3,'truongvy1022@gmail.com','GOOGLE_OAUTH_ACCOUNT','TC Vá»¹',NULL,'https://lh3.googleusercontent.com/a/ACg8ocLhZ6L4w2K-WVrG7afxpApEK-nu_0Wpy6X0FIBpJWPBMPTP2KQ=s96-c',1,'2026-10-15 06:20:28','2026-10-15 06:20:28',NULL),(6,1,'admin@noithat.vn','$2b$10$pZW98jYWOjFUbibKOUiAPuAIEQyHsLYFTzkVF4oowryYGtmgu0agG','Quáº£n Trá»‹ ViĂªn Cáº¥p Cao',NULL,NULL,1,'2026-10-16 05:07:04','2026-10-16 05:07:04',NULL),(7,1,'huuloi230605@gmail.com','$2b$10$eEOn1NBbmWBILnUzlZ6qHepjpy2xYhXV9ecPFrZYj7vOURP07GlDq','Pháº¡m Há»¯u Lá»£i',NULL,'https://lh3.googleusercontent.com/a/ACg8ocLzhk1m_1LhcUGjj9gfktop0CQekD7_cbSo3lFwSz1ZgAnUK4_EBA=s96-c',1,'2026-10-18 12:53:49','2026-10-18 20:10:05',NULL);
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

-- Dump completed on 2026-10-19 15:59:00
