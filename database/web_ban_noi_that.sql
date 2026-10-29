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
  `button_text` varchar(100) DEFAULT 'KhÄ‚Â¡m phÄ‚Â¡ ngay',
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
INSERT INTO `banners` VALUES (2,'Bá»˜ SÆ¯U Táº¬P Ná»˜I THáº¤T','KHĂ”NG GIAN Sá»NG Äáº²NG Cáº¤P','KhĂ¡m phĂ¡ nhá»¯ng thiáº¿t káº¿ tinh táº¿, káº¿t há»£p hoĂ n háº£o giá»¯a cĂ´ng nÄƒng vĂ  tháº©m má»¹, mang Ä‘áº¿n váº» Ä‘áº¹p vÆ°á»£t thá»i gian cho ngĂ´i nhĂ  cá»§a báº¡n','https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1920&q=80','/san-pham','KhĂ¡m phĂ¡ bá»™ sÆ°u táº­p','san-pham',1,1,'2026-10-19 01:23:36','2026-10-22 01:15:15'),(3,'TÆ¯ Váº¤N PHONG THá»¦Y & BĂ€I TRĂ Ná»˜I THáº¤T','á»¨ng Dá»¥ng TrĂ­ Tuá»‡ NhĂ¢n Táº¡o Gemini AI & BĂ¡t Tráº¡ch','Äá»‹nh hÆ°á»›ng sinh khĂ­ tĂ i lá»™c, phá»‘i há»£p mĂ u sáº¯c ngÅ© hĂ nh vĂ  bĂ i trĂ­ ná»™i tháº¥t chuáº©n phong thá»§y cho gia chá»§.','https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1920&q=80','/phong-thuy','Tra cá»©u cung má»‡nh ngay','phong-thuy',1,1,'2026-10-19 01:23:36','2026-10-19 01:23:36'),(4,'Ná»˜I THáº¤T CAO Cáº¤P','Bá»˜ SÆ¯U Táº¬P 2026','Ná»™i tháº¥t thiáº¿t káº¿ cho khĂ´ng gian sá»‘ng Ä‘áº³ng cáº¥p â€” tuyá»ƒn chá»n tá»« nhá»¯ng thÆ°Æ¡ng hiá»‡u vĂ  xÆ°á»Ÿng cháº¿ tĂ¡c hĂ ng Ä‘áº§u','https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1920&q=80','/san-pham','KhĂ¡m phĂ¡ ngay','hero',1,1,'2026-10-21 23:26:22','2026-10-22 00:52:51'),(8,'SOFA & Ká»† TIVI','TĂ‚M ÄIá»‚M PHĂ’NG KHĂCH','Tháº£ mĂ¬nh vĂ o sá»± Ăªm Ă¡i vĂ  sang trá»ng. KhĂ´ng gian tiáº¿p khĂ¡ch áº¥m cĂºng, hoĂ n háº£o cho gia Ä‘Ă¬nh báº¡n','http://localhost:4000/uploads/banners/banner-1792655674009-326777258.avif','/san-pham?khong-gian=phong-khach','Xem phĂ²ng khĂ¡ch','hero',2,1,'2026-10-22 00:54:43','2026-10-22 01:03:08'),(9,'NGHá»† THUáº¬T NGHá»ˆ NGÆ I','Ná»˜I THáº¤T PHĂ’NG NGá»¦','TĂ¡i táº¡o nÄƒng lÆ°á»£ng sau má»™t ngĂ y dĂ i vá»›i bá»™ sÆ°u táº­p phĂ²ng ngá»§ mang Ä‘áº­m dáº¥u áº¥n cĂ¡ nhĂ¢n. Sá»± káº¿t há»£p hoĂ n háº£o giá»¯a cháº¥t liá»‡u Ăªm Ă¡i vĂ  thiáº¿t káº¿ tinh táº¿','http://localhost:4000/uploads/banners/banner-1792655870396-838715317.avif','/san-pham?khong-gian=phong-ngu','xem phĂ²ng ngá»§','hero',3,1,'2026-10-22 00:57:52','2026-10-22 01:00:40'),(10,'HĂ€I HĂ’A SINH KHĂ','TÆ¯ Váº¤N PHONG THá»¦Y AI','á»¨ng dá»¥ng trĂ­ tuá»‡ nhĂ¢n táº¡o Ä‘á»ƒ phĂ¢n tĂ­ch báº£n má»‡nh, giĂºp báº¡n dá»… dĂ ng chá»n lá»±a mĂ u sáº¯c, cháº¥t liá»‡u vĂ  hÆ°á»›ng Ä‘áº·t ná»™i tháº¥t thu hĂºt tĂ i lá»™c, bĂ¬nh an','http://localhost:4000/uploads/banners/banner-1792655948259-888496089.avif','/phong-thuy','TÆ° váº¥n phong thá»§y','hero',4,1,'2026-10-22 00:59:09','2026-10-22 00:59:09'),(11,'PhĂ²ng khĂ¡ch',NULL,NULL,'http://localhost:4000/uploads/banners/banner-1792657223955-569360333.avif','/san-pham?khong-gian=phong-khach','KhĂ¡m phĂ¡ ngay','space',1,1,'2026-10-22 01:20:26','2026-10-22 01:20:26');
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
INSERT INTO `bot_prompts` VALUES (1,'system_prompt','Báº¡n lĂ  trá»£ lĂ½ AI áº£o cá»§a thÆ°Æ¡ng hiá»‡u Ná»™i tháº¥t KTUFA Luxury Furniture. HĂ£y tÆ° váº¥n lá»‹ch sá»±, chuáº©n phong thá»§y, ngáº¯n gá»n vĂ  há»¯u Ă­ch cho khĂ¡ch hĂ ng. XÆ°ng hĂ´ lĂ  dáº¡/thÆ°a.',1),(2,'shipping_policy','Giao hĂ ng miá»…n phĂ­ ná»™i thĂ nh cho Ä‘Æ¡n tá»« 2 triá»‡u. CĂ¡c tá»‰nh khĂ¡c há»— trá»£ váº­n chuyá»ƒn chuyĂªn nghiá»‡p.',1);
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
INSERT INTO `cash_transactions` VALUES (1,'PC-202609-001','expense','import_payment',182000000.00,'bank','PN-202609-001',1,'XĂ†Â°Ă¡Â»Å¸ng GĂ¡Â»â€” TĂ¡Â»Â± NhiĂƒÂªn BĂ¡ÂºÂ¯c Ăƒâ€u','ChuyĂ¡Â»Æ’n khoĂ¡ÂºÂ£n thanh toĂƒÂ¡n tiĂ¡Â»Ân hĂƒÂ ng phiĂ¡ÂºÂ¿u PN-202609-001','completed','2026-09-10 10:00:00'),(2,'PC-202610-001','expense','import_payment',223000000.00,'bank','PN-202610-001',1,'NĂ¡Â»â„¢i ThĂ¡ÂºÂ¥t Da ĂƒÂ Milano','ChuyĂ¡Â»Æ’n khoĂ¡ÂºÂ£n thanh toĂƒÂ¡n phiĂ¡ÂºÂ¿u nhĂ¡ÂºÂ­p PN-202610-001','completed','2026-10-05 15:30:00'),(3,'PC-202610-002','expense','import_payment',100000000.00,'bank','PN-202610-002',1,'TĂ¡Â»â€¢ng Kho Ă„ÂĂƒÂ¡ TĂ¡Â»Â± NhiĂƒÂªn Carrara','TĂ¡ÂºÂ¡m Ă¡Â»Â©ng Ă„â€˜Ă¡Â»Â£t 1 phiĂ¡ÂºÂ¿u nhĂ¡ÂºÂ­p PN-202610-002','completed','2026-10-18 11:00:00'),(4,'PC-202610-003','expense','import_payment',46000000.00,'cash','PN-202610-003',1,'XĂ†Â°Ă¡Â»Å¸ng Ă„ÂĂƒÂ¨n ThĂ¡Â»Â§ CĂƒÂ´ng BĂƒÂ¡t TrĂƒÂ ng','Chi tiĂ¡Â»Ân mĂ¡ÂºÂ·t thanh toĂƒÂ¡n trĂ¡Â»Â±c tiĂ¡ÂºÂ¿p tĂ¡ÂºÂ¡i showroom phiĂ¡ÂºÂ¿u PN-202610-003','completed','2026-10-24 16:45:00'),(5,'PT-202610-001','income','order_bank',58900000.00,'bank','DH-20261005-01',1,'KhĂƒÂ¡ch hĂƒÂ ng TrĂ¡ÂºÂ§n VĂ„Æ’n Test','Thanh toĂƒÂ¡n chuyĂ¡Â»Æ’n khoĂ¡ÂºÂ£n VietQR Ă„â€˜Ă†Â¡n hĂƒÂ ng DH-20261005-01','completed','2026-10-05 16:20:00'),(6,'PT-202610-002','income','order_bank',32500000.00,'bank','DH-20261012-02',1,'KhĂƒÂ¡ch hĂƒÂ ng Ă„ÂĂ¡ÂºÂ·ng ThĂ¡ÂºÂ£o Vy','Thanh toĂƒÂ¡n chuyĂ¡Â»Æ’n khoĂ¡ÂºÂ£n VietQR Ă„â€˜Ă†Â¡n hĂƒÂ ng DH-20261012-02','completed','2026-10-12 11:15:00'),(7,'PT-202610-003','income','order_cod',18900000.00,'cash','DH-20261015-03',1,'Shipper Giao HĂƒÂ ng TiĂ¡ÂºÂ¿t KiĂ¡Â»â€¡m','Thu ngĂƒÂ¢n nhĂ¡ÂºÂ­n tiĂ¡Â»Ân mĂ¡ÂºÂ·t COD tĂ¡Â»Â« shipper Ă„â€˜Ă†Â¡n DH-20261015-03','completed','2026-10-15 17:30:00'),(8,'PT-202610-004','income','order_cod',4420000.00,'cash','DH-20261022-04',1,'Shipper Viettel Post','Thu ngĂƒÂ¢n nhĂ¡ÂºÂ­n tiĂ¡Â»Ân mĂ¡ÂºÂ·t COD tĂ¡Â»Â« shipper Ă„â€˜Ă†Â¡n DH-20261022-04','completed','2026-10-22 18:00:00'),(9,'PC-202610-7189','expense','import_payment',5000.00,'cash','PN-202610-005',1,'XÆ°á»Ÿng Ná»™i Tháº¥t ChĂ¢u Ă‚u','Chi thanh toĂ¡n phiáº¿u nháº­p kho PN-202610-005 cho XÆ°á»Ÿng Ná»™i Tháº¥t ChĂ¢u Ă‚u','completed','2026-10-29 10:25:07'),(10,'PC-202610-6814','expense','import_payment',5000.00,'cash','PN-202610-006',1,'CĂ´ng Ty Sofa Cao Cáº¥p NhĂ  K','Chi thanh toĂ¡n phiáº¿u nháº­p kho PN-202610-006 cho CĂ´ng Ty Sofa Cao Cáº¥p NhĂ  K','completed','2026-10-29 10:39:46');
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
  `sender_id` bigint(20) unsigned DEFAULT NULL COMMENT 'ID cĂ¡Â»Â§a user hoĂ¡ÂºÂ·c seller nĂ¡ÂºÂ¿u cÄ‚Â³',
  `content` text NOT NULL COMMENT 'NĂ¡Â»â„¢i dung tin nhĂ¡ÂºÂ¯n',
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
INSERT INTO `chat_messages` VALUES (1,1,'customer',15,'Sinh nÄƒm 1995 (áº¤t Há»£i) nĂªn chá»n sofa mĂ u gĂ¬?','2026-10-29 10:47:11'),(2,1,'ai_bot',NULL,'Dáº¡, chĂ o quĂ½ khĂ¡ch! TĂ´i lĂ  ChuyĂªn gia tÆ° váº¥n Phong Thá»§y & Ná»™i Tháº¥t cá»§a **KTUFA Luxury Furniture**. Ráº¥t vinh háº¡nh Ä‘Æ°á»£c Ä‘á»“ng hĂ nh cĂ¹ng quĂ½ khĂ¡ch trĂªn hĂ nh trĂ¬nh kiáº¿n táº¡o má»™t khĂ´ng gian sá»‘ng thá»‹nh vÆ°á»£ng vĂ  viĂªn mĂ£n.\n\nÄá»‘i vá»›i gia chá»§ sinh nÄƒm **1995 (tuá»•i áº¤t Há»£i)**, viá»‡c lá»±a chá»n mĂ u sáº¯c cho bá»™ sofa â€“ trĂ¡i tim cá»§a phĂ²ng khĂ¡ch â€“ Ä‘Ă³ng vai trĂ² vĂ´ cĂ¹ng quan trá»ng Ä‘á»ƒ chiĂªu tĂ i hĂºt lá»™c, mang láº¡i bĂ¬nh an vĂ  vÆ°á»£ng khĂ­ cho gia Ä‘Ă¬nh. DÆ°á»›i Ä‘Ă¢y lĂ  nhá»¯ng tÆ° váº¥n chuyĂªn sĂ¢u tá»« **KTUFA Luxury Furniture**:\n\n### 1. PhĂ¢n tĂ­ch Báº£n má»‡nh & NgÅ© hĂ nh\n* **NÄƒm sinh Ă¢m lá»‹ch:** 1995 â€“ áº¤t Há»£i (Con lá»£n).\n* **NgÅ© hĂ nh náº¡p Ă¢m:** **SÆ¡n Äáº§u Há»a** (Lá»­a trĂªn nĂºi).\n\nTheo quy luáº­t ngÅ© hĂ nh tÆ°Æ¡ng sinh - tÆ°Æ¡ng kháº¯c, Ä‘á»ƒ chá»n mĂ u sáº¯c sofa mang láº¡i may máº¯n, chĂºng ta Æ°u tiĂªn cĂ¡c gam mĂ u tÆ°Æ¡ng há»£p (cĂ¹ng hĂ nh Há»a) vĂ  tÆ°Æ¡ng sinh (Há»a sinh Thá»• hoáº·c Má»™c sinh Há»a).\n\n### 2. Gá»£i Ă½ mĂ u sáº¯c Sofa chuáº©n phong thá»§y cho tuá»•i áº¤t Há»£i (1995)\n\n* **MĂ u tÆ°Æ¡ng há»£p (HĂ nh Há»a):** \n  * *MĂ u sáº¯c:* Äá», há»“ng, tĂ­m, cam Ä‘áº­m.\n  * *Ă nghÄ©a:* TÄƒng cÆ°á»ng nÄƒng lÆ°á»£ng báº£n má»‡nh, mang láº¡i sá»± nhiá»‡t huyáº¿t, may máº¯n vĂ  tĂ i lá»™c dá»“i dĂ o. \n  * *Gá»£i Ă½ tá»« **KTUFA Luxury Furniture** phá»‘i ná»™i tháº¥t:* QuĂ½ khĂ¡ch cĂ³ thá»ƒ chá»n cĂ¡c máº«u sofa da cao cáº¥p bá»c da tĂ´ng mĂ u Ä‘á» Ä‘Ă´ sang trá»ng hoáº·c Ä‘iá»ƒm xuyáº¿t gá»‘i Ă´m mĂ u cam/há»“ng tráº§m Ä‘á»ƒ táº¡o Ä‘iá»ƒm nháº¥n quyá»n quĂ½ cho phĂ²ng khĂ¡ch mĂ  váº«n giá»¯ Ä‘Æ°á»£c sá»± nhĂ£ nháº·n.\n\n* **MĂ u tÆ°Æ¡ng sinh (HĂ nh Má»™c - Má»™c sinh Há»a):** \n  * *MĂ u sáº¯c:* Xanh lĂ¡ cĂ¢y, xanh rĂªu, xanh lá»¥c.\n  * *Ă nghÄ©a:* Má»™c sinh Há»a lĂ  má»‘i quan há»‡ sinh trÆ°á»Ÿng, giĂºp gia chá»§ gáº·p nhiá»u quĂ½ nhĂ¢n phĂ¹ trá»£, cĂ´ng danh sá»± nghiá»‡p phĂ¡t triá»ƒn vá»¯ng cháº¯c, sá»©c khá»e hanh thĂ´ng.\n  * *Gá»£i Ă½ tá»« **KTUFA Luxury Furniture** phá»‘i ná»™i tháº¥t:* Má»™t bá»™ sofa da bĂ² Ă cao cáº¥p káº¿t há»£p vá»›i khung gá»— Ă³c chĂ³ tá»± nhiĂªn (Má»™c sinh Há»a cá»±c tá»‘t) hoáº·c má»™t thiáº¿t káº¿ sofa bá»c ná»‰ nhung cao cáº¥p mĂ u xanh rĂªu tráº§m sáº½ lĂ  lá»±a chá»n hoĂ n háº£o, vá»«a há»£p phong thá»§y vá»«a mang Ä‘áº­m hÆ¡i thá»Ÿ kiáº¿n trĂºc thÆ°á»£ng lÆ°u.\n\n### 3. CĂ¡c mĂ u sáº¯c Ä‘áº¡i ká»µ cáº§n trĂ¡nh\n* **MĂ u thuá»™c hĂ nh Thá»§y (Thá»§y kháº¯c Há»a):** Äen, xanh dÆ°Æ¡ng, xanh nÆ°á»›c biá»ƒn. \n  * *LĂ½ do:* NÆ°á»›c dáº­p táº¯t lá»­a, mang theo nÄƒng lÆ°á»£ng xung kháº¯c, dá»… gĂ¢y cáº£n trá»Ÿ tĂ i lá»™c vĂ  báº¥t á»•n trong gia Ä‘áº¡o. Do Ä‘Ă³, quĂ½ khĂ¡ch tuyá»‡t Ä‘á»‘i nĂªn trĂ¡nh chá»n sofa cĂ³ tĂ´ng mĂ u chá»§ Ä‘áº¡o nĂ y.\n* **MĂ u thuá»™c hĂ nh Kim (Há»a kháº¯c Kim):** Tráº¯ng, xĂ¡m, Ă¡nh kim (máº·c dĂ¹ Há»a kháº¯c Kim nhÆ°ng nÄƒng lÆ°á»£ng cá»§a Há»a sáº½ bá»‹ tiĂªu hao khi \"kháº¯c\", khĂ´ng cĂ³ lá»£i cho gia chá»§).\n\n### 4. Gá»£i Ă½ khĂ´ng gian tá»« KTUFA Luxury Furniture\nÄá»ƒ tá»‘i Æ°u hĂ³a nÄƒng lÆ°á»£ng phong thá»§y cho phĂ²ng khĂ¡ch tuá»•i áº¤t Há»£i 1995, khi bĂ i trĂ­ sofa, quĂ½ khĂ¡ch cÅ©ng nĂªn lÆ°u Ă½:\n* **Vá»‹ trĂ­ Ä‘áº·t sofa:** NĂªn kĂª sofa tá»±a lÆ°ng vĂ o bá»©c tÆ°á»ng vá»¯ng chĂ£i (tá»a sÆ¡n) Ä‘á»ƒ táº¡o tháº¿ \"vá»¯ng nhÆ° bĂ n tháº¡ch\", hÆ°á»›ng nhĂ¬n ra khĂ´ng gian má»Ÿ hoáº·c cá»­a chĂ­nh (nhÆ°ng khĂ´ng Ä‘á»‘i diá»‡n trá»±c diá»‡n) Ä‘á»ƒ Ä‘Ă³n tĂ i khĂ­.\n* **Cháº¥t liá»‡u Ä‘á» xuáº¥t:** CĂ¡c dĂ²ng **sofa da tháº­t cao cáº¥p** káº¿t há»£p chĂ¢n gá»— tá»± nhiĂªn hoáº·c **sofa bá»c váº£i nhung cao cáº¥p** cá»§a **KTUFA Luxury Furniture** khĂ´ng chá»‰ Ä‘áº¡t chuáº©n kĂ­ch thÆ°á»›c phong thá»§y theo ThÆ°á»›c Lá»— Ban mĂ  cĂ²n mang Ä‘áº¿n cáº£m giĂ¡c Ăªm Ă¡i, tá»¥ khĂ­ tá»‘t cho ngĂ´i nhĂ .\n\nMá»i quĂ½ khĂ¡ch ghĂ© thÄƒm website cá»§a **KTUFA Luxury Furniture** Ä‘á»ƒ tham kháº£o cĂ¡c bá»™ sÆ°u táº­p sofa phĂ²ng khĂ¡ch thÆ°á»£ng háº¡ng Ä‘Æ°á»£c thiáº¿t káº¿ riĂªng cho tá»«ng báº£n má»‡nh. KhĂ´ng gian sá»‘ng Ä‘áº³ng cáº¥p vĂ  vÆ°á»£ng khĂ­ cá»§a quĂ½ khĂ¡ch Ä‘ang chá» Ä‘Æ°á»£c hoĂ n thiá»‡n! \n\nQuĂ½ khĂ¡ch cĂ³ cáº§n tĂ´i tÆ° váº¥n thĂªm vá» hÆ°á»›ng Ä‘áº·t sofa hay cĂ¡ch phá»‘i mĂ u ná»™i tháº¥t cho khĂ´ng gian phĂ²ng khĂ¡ch nĂ y khĂ´ng áº¡?','2026-10-29 10:47:11'),(3,2,'customer',15,'[Studio BĂ¡t Tráº¡ch] Gia chá»§ Nam máº¡ng sinh nÄƒm 2001 Â· KhĂ´ng gian: PhĂ²ng Äƒn Â· Cung CĂ n (Kim)','2026-10-29 11:47:31'),(4,2,'ai_bot',NULL,'KĂ­nh chĂ o QuĂ½ gia chá»§ sinh nÄƒm 2001 (Nam máº¡ng), thuá»™c cung CĂ n, hĂ nh Kim. Vá»›i tÆ° cĂ¡ch lĂ  ChuyĂªn gia Phong thá»§y cá»§a **KTUFA Luxury Furniture**, tĂ´i xin gá»­i tá»›i anh luáº­n giáº£i chuyĂªn sĂ¢u vĂ  tinh táº¿ cho khĂ´ng gian **PhĂ²ng Äƒn** â€“ nÆ¡i giá»¯ lá»­a háº¡nh phĂºc vĂ  vÆ°á»£ng khĂ­ cho gia Ä‘Ă¬nh.\n\n*   **Nháº­n Ä‘á»‹nh phong thá»§y tá»•ng quan:** Nam máº¡ng sinh nÄƒm 2001 thuá»™c TĂ¢y tá»© má»‡nh, há»£p vá»›i cĂ¡c hÆ°á»›ng TĂ¢y, TĂ¢y Nam, TĂ¢y Báº¯c vĂ  ÄĂ´ng Báº¯c. PhĂ²ng Äƒn lĂ  khĂ´ng gian dung dÆ°á»¡ng nguá»“n nÄƒng lÆ°á»£ng Thá»• (thá»©c Äƒn) sinh Kim (báº£n má»‡nh), tÆ°á»£ng trÆ°ng cho sá»± sung tĂºc vĂ  bá»n vá»¯ng. Viá»‡c bá»‘ trĂ­ phĂ²ng Äƒn tá»a láº¡c á»Ÿ cĂ¡c cung tá»‘t sáº½ giĂºp gia chá»§ kĂ­ch hoáº¡t tĂ i váº­n, gia Ä‘áº¡o hÆ°ng thá»‹nh, cĂ¡c má»‘i quan há»‡ xĂ£ há»™i rá»™ng má»Ÿ vĂ  luĂ´n gáº·p quĂ½ nhĂ¢n phĂ¹ trá»£.\n*   **Bá»‘ trĂ­ Ä‘á»“ Ä‘áº¡c chiĂªu tĂ i Ä‘Ă³n lá»™c:** \n    *   *HÆ°á»›ng bĂ n Äƒn:* NĂªn Ä‘áº·t bĂ n Äƒn quay vá» cĂ¡c hÆ°á»›ng sinh khĂ­ nhÆ° TĂ¢y Nam (DiĂªn NiĂªn) hoáº·c TĂ¢y (Sinh KhĂ­) Ä‘á»ƒ thu hĂºt tĂ i lá»™c vĂ  sá»± hĂ²a há»£p.\n    *   *Vá»‹ trĂ­ tá»±a lÆ°ng:* Gháº¿ ngá»“i cá»§a gia chá»§ khi dĂ¹ng bá»¯a nĂªn hÆ°á»›ng ra cá»­a chĂ­nh hoáº·c Ä‘áº·t á»Ÿ vá»‹ trĂ­ cĂ³ táº§m nhĂ¬n bao quĂ¡t, phĂ­a sau cĂ³ tÆ°á»ng vá»¯ng cháº¯c lĂ m \"tháº¿ tá»±a sÆ¡n\" táº¡o sá»± vá»¯ng chĂ£i, tá»± tin trong sá»± nghiá»‡p.\n    *   *Ănh sĂ¡ng:* Æ¯u tiĂªn Ă¡nh sĂ¡ng vĂ ng áº¥m Ă¡p tá»« há»‡ thá»‘ng Ä‘Ă¨n chĂ¹m pha lĂª Ä‘áº·t giá»¯a bĂ n Äƒn, tÆ°á»£ng trÆ°ng cho sá»± trá»n váº¹n, sung tĂºc vĂ  giĂºp kĂ­ch thĂ­ch vá»‹ giĂ¡c, gáº¯n káº¿t tĂ¬nh cáº£m gia Ä‘Ă¬nh.\n*   **Cháº¥t liá»‡u & MĂ u sáº¯c ná»™i tháº¥t tÆ°Æ¡ng sinh:** \n    *   *MĂ u sáº¯c:* Báº£n má»‡nh Kim ráº¥t há»£p vá»›i cĂ¡c tĂ´ng mĂ u thuáº§n khiáº¿t nhÆ° tráº¯ng, báº¡c, Ă¡nh kim, káº¿t há»£p hĂ i hĂ²a vá»›i mĂ u vĂ ng áº¥m, nĂ¢u Ä‘áº¥t cá»§a hĂ nh Thá»• (Thá»• sinh Kim) nhÆ° mĂ u gá»— sá»“i tá»± nhiĂªn, mĂ u da bĂ². TrĂ¡nh cĂ¡c mĂ u kháº¯c nhÆ° Ä‘á», há»“ng thuá»™c hĂ nh Há»a.\n    *   *Cháº¥t liá»‡u:* KTUFA Luxury Furniture khuyĂªn dĂ¹ng bĂ n Äƒn máº·t Ä‘Ă¡ marble cao cáº¥p (Ä‘áº¡i diá»‡n cho hĂ nh Thá»• vĂ  Kim) káº¿t há»£p chĂ¢n bĂ n inox máº¡ PVD Ă¡nh vĂ ng sang trá»ng, Ä‘i kĂ¨m gháº¿ bá»c da Ă má»m máº¡i. Sá»± káº¿t há»£p nĂ y khĂ´ng chá»‰ nĂ¢ng táº§m Ä‘áº³ng cáº¥p khĂ´ng gian mĂ  cĂ²n táº¡o chuá»—i ngÅ© hĂ nh tÆ°Æ¡ng sinh hoĂ n háº£o, mang láº¡i bĂ¬nh an vĂ  tĂ i lá»™c viĂªn mĂ£n cho gia chá»§ tráº» tuá»•i.','2026-10-29 11:47:31');
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
  `guest_id` varchar(255) DEFAULT NULL COMMENT 'Cookie/Session ID cho khÄ‚Â¡ch vÄ‚Â£ng lai',
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
INSERT INTO `coupons` VALUES (1,'GIAM10','percent',10.00,500000.00,500000.00,'2026-10-22 06:47:04','2027-01-20 06:47:04',100,0,1),(2,'NOITHAT50K','fixed_amount',50000.00,200000.00,NULL,'2026-10-22 06:47:04','2027-01-20 06:47:04',100,0,1),(3,'TRIAN1K','fixed_amount',1000.00,1000.00,NULL,'2026-10-22 06:47:04','2027-01-20 06:47:04',100,1,1),(5,'MAMOI','free_shipping',50000.00,0.00,NULL,'2026-10-22 07:15:00','2027-01-31 00:00:00',20,13,1),(7,'FREESHIP','free_shipping',0.00,0.00,NULL,'2026-10-22 07:30:32','2027-01-01 00:00:00',100,2,1);
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
  `status` varchar(50) NOT NULL DEFAULT 'ÄĂ£ hoĂ n táº¥t',
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
INSERT INTO `email_campaigns` VALUES (1,'CAM-001','ChĂ o má»«ng thĂ nh viĂªn má»›i - Nháº­n ngay Voucher 10% Ä‘Æ¡n Ä‘áº§u tiĂªn','Táº¥t cáº£ khĂ¡ch hĂ ng',9,'send-now','ÄĂ£ hoĂ n táº¥t','KĂ­nh gá»­i QuĂ½ khĂ¡ch hĂ ng,\n\nCáº£m Æ¡n QuĂ½ khĂ¡ch Ä‘Ă£ Ä‘Äƒng kĂ½ thĂ nh viĂªn táº¡i Cá»­a hĂ ng Ná»™i Tháº¥t. Äá»ƒ báº¯t Ä‘áº§u hĂ nh trĂ¬nh kiáº¿n táº¡o khĂ´ng gian sá»‘ng mÆ¡ Æ°á»›c, chĂºng tĂ´i xin gá»­i táº·ng QuĂ½ khĂ¡ch mĂ£ giáº£m giĂ¡ 10% cho Ä‘Æ¡n hĂ ng Ä‘áº§u tiĂªn: WELCOME2026.\n\nChĂºc QuĂ½ khĂ¡ch cĂ³ tráº£i nghiá»‡m mua sáº¯m tuyá»‡t vá»i!',88.50,42.00,9,'2026-10-20 14:59:13','2026-10-23 14:59:13'),(2,'CAM-002','Tri Ă¢n Há»™i viĂªn VIP - Ra máº¯t Bá»™ sÆ°u táº­p Gá»— Ă“c ChĂ³ MĂ¹a Thu 2026','Há»™i viĂªn VIP (Kim CÆ°Æ¡ng / VĂ ng)',2,'send-now','ÄĂ£ hoĂ n táº¥t','KĂ­nh gá»­i Há»™i viĂªn VIP,\n\nNhĂ¢n dá»‹p ra máº¯t bá»™ sÆ°u táº­p ná»™i tháº¥t cao cáº¥p MĂ¹a Thu 2026, Ná»™i Tháº¥t trĂ¢n trá»ng kĂ­nh má»i QuĂ½ khĂ¡ch tráº£i nghiá»‡m nhá»¯ng tuyá»‡t tĂ¡c gá»— tá»± nhiĂªn má»›i nháº¥t vá»›i Æ°u Ä‘Ă£i Ä‘áº·c quyá»n lĂªn tá»›i 20% cĂ¹ng dá»‹ch vá»¥ tÆ° váº¥n thiáº¿t káº¿ phong thá»§y miá»…n phĂ­.\n\nTrĂ¢n trá»ng cáº£m Æ¡n sá»± Ä‘á»“ng hĂ nh cá»§a QuĂ½ khĂ¡ch!',95.00,68.50,2,'2026-10-22 14:59:13','2026-10-23 14:59:13'),(3,'CAM-003','Khuyáº¿n mĂ£i cuá»‘i tuáº§n - Giáº£m 15% Sofa & BĂ n Ä‚n','Táº¥t cáº£ khĂ¡ch hĂ ng (9 khĂ¡ch)',9,'send-now','ÄĂ£ hoĂ n táº¥t','ChÆ°Æ¡ng trĂ¬nh Æ°u Ä‘Ă£i giáº£m 15% toĂ n bá»™ sáº£n pháº©m Sofa da Ă vĂ  BĂ n Äƒn máº·t Ä‘Ă¡ cao cáº¥p duy nháº¥t cuá»‘i tuáº§n nĂ y.',85.50,38.00,9,'2026-10-23 14:59:39','2026-10-23 14:59:39');
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
INSERT INTO `import_slip_items` VALUES (1,1,5,5,'SKU-BAN-AN-GO-SOI-NGA','BĂƒÂ n Ă„â€n GĂ¡Â»â€” SĂ¡Â»â€œi Nga Scandinavian','MĂƒÂ u GĂ¡Â»â€” TĂ¡Â»Â± NhiĂƒÂªn',10,11000000.00,18900000.00,110000000.00,NULL),(2,1,14,14,'SKU-KE-TIVI-TREO-TUONG','KĂ¡Â»â€¡ Tivi Treo TĂ†Â°Ă¡Â»Âng HiĂ¡Â»â€¡n Ă„ÂĂ¡ÂºÂ¡i','GĂ¡Â»â€” Walnut SĂ¡Â»â€œi',5,15000000.00,24500000.00,75000000.00,NULL),(3,2,1,1,'SKU-SOFA-DA-Y-MILANO','Sofa Da BĂƒÂ² ĂƒÂ Milano Grand','Da BĂƒÂ² MĂƒÂ u NĂƒÂ¢u HĂ¡ÂºÂ¡t DĂ¡ÂºÂ»',4,34000000.00,58900000.00,136000000.00,NULL),(4,2,7,7,'SKU-GHE-THU-GIAN-GO-OC-CHO','GhĂ¡ÂºÂ¿ ThĂ†Â° GiĂƒÂ£n Lounge GĂ¡Â»â€” Ăƒâ€œc ChĂƒÂ³','GĂ¡Â»â€” Ăƒâ€œc ChĂƒÂ³ BĂ¡ÂºÂ¯c MĂ¡Â»Â¹',6,14000000.00,24500000.00,84000000.00,NULL),(5,3,4,4,'SKU-BAN-AN-DA-MARBLE-CARRARA','BĂƒÂ n Ă„â€n MĂ¡ÂºÂ·t Ă„ÂĂƒÂ¡ CĂ¡ÂºÂ©m ThĂ¡ÂºÂ¡ch Carrara','Ă„ÂĂƒÂ¡ TrĂ¡ÂºÂ¯ng Carrara',8,17500000.00,32500000.00,140000000.00,NULL),(6,4,16,16,'SKU-DEN-SAN-DONG-THAU','Ă„ÂĂƒÂ¨n SĂƒÂ n Ă„ÂĂ¡Â»Â©ng ThĂƒÂ¢n Ă„ÂĂ¡Â»â€œng Thau BĂ¡ÂºÂ¯c Ăƒâ€u','Ă„ÂĂ¡Â»â€œng Thau CĂ¡Â»â€¢ Ă„ÂiĂ¡Â»Æ’n',15,1800000.00,3200000.00,27000000.00,NULL),(7,4,17,17,'SKU-DEN-THA-TRAN-MAY','Ă„ÂĂƒÂ¨n ThĂ¡ÂºÂ£ TrĂ¡ÂºÂ§n ThĂ¡Â»Â§ CĂƒÂ´ng SĂ¡Â»Â£i MĂƒÂ¢y Ă„Âan','MĂƒÂ¢y Tre Ă„Âan TĂ¡Â»Â± NhiĂƒÂªn',10,1800000.00,2900000.00,18000000.00,NULL),(8,5,1,1,'SKU-TEST','Test Nháº­p HĂ ng','Da bĂ² Ă',2,2500.00,5000.00,5000.00,NULL),(9,6,21,21,'cham-trang-tri','cham trang trĂ­','gá»‘m',5,1000.00,2000.00,5000.00,NULL);
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
INSERT INTO `import_slips` VALUES (1,'PN-202609-001',1,1,15,185000000.00,5000000.00,0.00,2000000.00,182000000.00,182000000.00,0.00,'bank','paid','completed','2026-09-10 09:30:00','NhĂ¡ÂºÂ­p lĂƒÂ´ bĂƒÂ n Ă„Æ’n gĂ¡Â»â€” sĂ¡Â»â€œi vĂƒÂ  kĂ¡Â»â€¡ tivi phĂ¡Â»Â¥c vĂ¡Â»Â¥ mĂƒÂ¹a cao Ă„â€˜iĂ¡Â»Æ’m cuĂ¡Â»â€˜i nĂ„Æ’m','2026-09-10 09:30:00','2026-10-29 15:47:05'),(2,'PN-202610-001',2,1,10,220000000.00,0.00,0.00,3000000.00,223000000.00,223000000.00,0.00,'bank','paid','completed','2026-10-05 14:00:00','NhĂ¡ÂºÂ­p da bĂƒÂ² ĂƒÂ cao cĂ¡ÂºÂ¥p vĂƒÂ  khung ghĂ¡ÂºÂ¿ thĂ†Â° giĂƒÂ£n ĂƒÂ³c chĂƒÂ³','2026-10-05 14:00:00','2026-10-29 15:47:05'),(3,'PN-202610-002',3,1,8,140000000.00,2000000.00,0.00,1500000.00,139500000.00,100000000.00,39500000.00,'bank','partial','completed','2026-10-18 10:15:00','NhĂ¡ÂºÂ­p mĂ¡ÂºÂ·t Ă„â€˜ĂƒÂ¡ Carrara, thanh toĂƒÂ¡n trĂ†Â°Ă¡Â»â€ºc 100tr, cĂƒÂ²n nĂ¡Â»Â£ 39.5tr Ă„â€˜Ă¡ÂºÂ¿n cuĂ¡Â»â€˜i thĂƒÂ¡ng','2026-10-18 10:15:00','2026-10-29 15:47:05'),(4,'PN-202610-003',4,1,25,45000000.00,0.00,0.00,1000000.00,46000000.00,46000000.00,0.00,'cash','paid','completed','2026-10-24 16:30:00','NhĂ¡ÂºÂ­p Ă„â€˜ĂƒÂ¨n thĂ¡ÂºÂ£ trĂ¡ÂºÂ§n vĂƒÂ  Ă„â€˜ĂƒÂ¨n sĂƒÂ n Ă„â€˜Ă¡Â»â€œng thau trĂ¡ÂºÂ£ tiĂ¡Â»Ân mĂ¡ÂºÂ·t trĂ¡Â»Â±c tiĂ¡ÂºÂ¿p','2026-10-24 16:30:00','2026-10-29 15:47:05'),(5,'PN-202610-005',1,1,2,5000.00,0.00,0.00,0.00,5000.00,5000.00,0.00,'cash','paid','completed','2026-10-29 00:00:00',NULL,'2026-10-29 10:25:07','2026-10-29 10:25:07'),(6,'PN-202610-006',2,1,5,5000.00,0.00,0.00,0.00,5000.00,5000.00,0.00,'cash','paid','completed','2026-10-29 00:00:00',NULL,'2026-10-29 10:39:46','2026-10-29 10:39:46');
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
  `product_name` varchar(255) NOT NULL COMMENT 'TÄ‚Âªn lĂ†Â°u cĂ¡Â»Â©ng lÄ‚Âºc mua',
  `variant_name` varchar(255) DEFAULT NULL COMMENT 'MÄ‚Â u/ChĂ¡ÂºÂ¥t liĂ¡Â»â€¡u lĂ†Â°u cĂ¡Â»Â©ng',
  `sku` varchar(50) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL COMMENT 'GiÄ‚Â¡ lĂ†Â°u cĂ¡Â»Â©ng lÄ‚Âºc mua',
  `cost_price` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_price` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  KEY `variant_id` (`variant_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL,
  CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (6,5,20,20,'sofa_Ă„â€˜en nhÄ‚Â¡m',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(7,6,12,12,'TĂ¡Â»Â§ quĂ¡ÂºÂ§n Ä‚Â¡o 4 cÄ‚Â¡nh',NULL,'SKU-TU-QUAN-AO-4-CANH',1,24500000.00,6380000.00,24500000.00),(8,7,20,20,'sofa_Ă„â€˜en nhÄ‚Â¡m',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(9,8,1,1,'Sofa da ï¿½ Milano',NULL,'SKU-SOFA-DA-Y-MILANO',1,12000000.00,34160000.00,12000000.00),(10,9,3,3,'Sofa gï¿½c B?c ï¿½u',NULL,'SKU-SOFA-GOC-BAC-AU',1,8500000.00,19080000.00,8500000.00),(11,10,20,20,'Sofa da bĂ² Ă cao cáº¥p',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(12,11,20,20,'Sofa da bĂ² Ă cao cáº¥p',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(13,12,20,20,'Sofa da bĂ² Ă cao cáº¥p',NULL,'SOFADEN_NHAM_001',2,7500000.00,4350000.00,15000000.00),(14,13,20,20,'Sofa da bĂ² Ă cao cáº¥p',NULL,'SOFADEN_NHAM_001',2,7500000.00,4350000.00,15000000.00),(15,14,20,20,'Sofa da bĂ² Ă cao cáº¥p',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(16,15,20,20,'Sofa da bĂ² Ă cao cáº¥p',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(17,16,20,20,'Sofa da bĂ² Ă cao cáº¥p',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(18,17,20,20,'Sofa da bĂ² Ă cao cáº¥p',NULL,'SOFADEN_NHAM_001',1,7500000.00,4350000.00,7500000.00),(19,18,21,21,'cham trang trĂ­',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(20,19,21,21,'ChĂ¢m trang trĂ­',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(21,20,21,21,'cham trang trĂ­',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(22,21,21,21,'cham trang trĂ­',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(25,24,21,21,'cham trang trĂ­',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(26,25,21,21,'cham trang trĂ­',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(27,26,21,21,'cham trang trĂ­',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(28,27,21,21,'cham trang trĂ­',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(29,28,21,21,'cham trang trĂ­',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(30,29,21,21,'cham trang trĂ­',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(31,30,21,21,'cham trang trĂ­',NULL,'CHAM_TRANG_TRI_001',2,2000.00,0.00,4000.00),(32,31,21,21,'cham trang trĂ­',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(33,32,21,21,'cham trang trĂ­',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(34,33,21,21,'cham trang trĂ­',NULL,'CHAM_TRANG_TRI_001',1,2000.00,0.00,2000.00),(35,35,21,21,'cham trang trĂ­',NULL,'CHAM_TRANG_TRI_001',4,2000.00,0.00,8000.00),(36,36,21,21,'cham trang trĂ­',NULL,'CHAM_TRANG_TRI_001',2,2000.00,0.00,4000.00);
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
  `shipping_address` text NOT NULL COMMENT 'LĂ†Â°u cĂ¡Â»Â©ng Ă„â€˜Ă¡Â»â€¹a chĂ¡Â»â€° text/JSON lÄ‚Âºc Ă„â€˜Ă¡ÂºÂ·t',
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
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (5,'NT-2610-9661',6,NULL,'543b tÄ‚Â¢n phÄ‚Âº, r, TP. HĂ¡Â»â€œ ChÄ‚Â­ Minh',0.00,7500000.00,0.00,7500000.00,'cod','pending','pending',NULL,NULL,'2026-10-16 04:13:03','2026-10-22 15:15:57'),(6,'NT-2610-5385',6,NULL,'110d tÄ‚Â¢n quÄ‚Â½, tÄ‚Â¢n phÄ‚Âº, HCM, r, TP. HĂ¡Â»â€œ ChÄ‚Â­ Minh',0.00,24500000.00,0.00,24500000.00,'cod','pending','pending',NULL,NULL,'2026-10-16 08:36:49','2026-10-22 15:15:57'),(7,'NT-2610-3221',7,NULL,'412, TÄ‚Â¢n PhÄ‚Âº, TP. HĂ¡Â»â€œ ChÄ‚Â­ Minh',0.00,7500000.00,0.00,7500000.00,'cod','pending','pending',NULL,NULL,'2026-10-18 13:02:12','2026-10-18 13:02:12'),(8,'NT-2610-5947',8,NULL,'123 Du?ng C?u Gi?y, C?u Gi?y, Hï¿½ N?i',0.00,12000000.00,0.00,12000000.00,'sepay','paid','confirmed','[SePay Webhook] Thanh toĂ¡n thĂ nh cĂ´ng 12.000.000 Ä‘ qua MBBank (Ref: REF99999) lĂºc 2026-10-21 11:18:00',NULL,'2026-10-21 04:19:14','2026-10-21 11:19:14'),(9,'NT-2610-4932',9,NULL,'456 Du?ng C?u Gi?y, C?u Gi?y, Hï¿½ N?i',0.00,8500000.00,0.00,8500000.00,'sepay','paid','confirmed','[DEMO TEST] Thanh toĂ¡n giáº£ láº­p thĂ nh cĂ´ng 8.500.000 Ä‘ lĂºc 11:19:22 21/10/2026',NULL,'2026-10-21 04:19:22','2026-10-21 11:19:22'),(10,'NT-2610-8753',6,NULL,'765A Tp hcm, r, TP. Há»“ ChĂ­ Minh',0.00,7500000.00,0.00,7500000.00,'sepay','pending','pending',NULL,NULL,'2026-10-21 05:32:28','2026-10-22 15:15:57'),(11,'NT-2610-7863',6,NULL,'110d tĂ¢n quĂ½, tĂ¢n phĂº, HCM, r, TP. Há»“ ChĂ­ Minh',0.00,7500000.00,0.00,7500000.00,'sepay','pending','pending',NULL,NULL,'2026-10-21 05:41:17','2026-10-22 15:15:57'),(12,'NT-2610-5288',6,NULL,'110d tĂ¢n quĂ½, tĂ¢n phĂº, HCM, r, TP. Há»“ ChĂ­ Minh',0.00,15000000.00,0.00,15000000.00,'sepay','pending','pending',NULL,NULL,'2026-10-21 05:57:04','2026-10-22 15:15:57'),(13,'NT-2610-9861',6,NULL,'110d tĂ¢n quĂ½, tĂ¢n phĂº, HCM, r, TP. Há»“ ChĂ­ Minh',0.00,15000000.00,0.00,15000000.00,'sepay','pending','pending',NULL,NULL,'2026-10-21 06:00:38','2026-10-22 15:15:57'),(14,'NT-2610-1738',6,NULL,'299 trá»‹nh Ä‘Ă¬nh trá»ng, hĂ²a tháº¡nh, tĂ¢n phĂº, TP HCM, r, TP. Há»“ ChĂ­ Minh',0.00,7500000.00,0.00,7500000.00,'sepay','pending','pending',NULL,NULL,'2026-10-21 06:05:29','2026-10-22 15:15:57'),(15,'NT-2610-5475',6,NULL,'110d tĂ¢n quĂ½, tĂ¢n phĂº, HCM, r, TP. Há»“ ChĂ­ Minh',0.00,7500000.00,0.00,7500000.00,'sepay','pending','pending',NULL,NULL,'2026-10-21 06:16:28','2026-10-22 15:15:57'),(16,'NT-2610-4750',6,NULL,'543b tĂ¢n phĂº, r, TP. Há»“ ChĂ­ Minh',0.00,7500000.00,0.00,7500000.00,'sepay','pending','pending',NULL,NULL,'2026-10-21 06:20:13','2026-10-22 15:15:57'),(17,'NT-2610-7968',6,NULL,'110d tĂ¢n quĂ½, tĂ¢n phĂº, HCM, r, TP. Há»“ ChĂ­ Minh',0.00,7500000.00,0.00,7500000.00,'sepay','pending','pending',NULL,NULL,'2026-10-21 06:20:29','2026-10-22 15:15:57'),(18,'NT-2610-2647',6,NULL,'110d tĂ¢n quĂ½, tĂ¢n phĂº, HCM, r, TP. Há»“ ChĂ­ Minh',50000.00,2000.00,0.00,52000.00,'sepay','pending','pending',NULL,NULL,'2026-10-22 03:50:43','2026-10-22 15:15:57'),(19,'NT-2610-3033',11,3,'123 Phá»‘ Huáº¿, Ba ÄĂ¬nh, HĂ  Ná»™i',50000.00,2000.00,1000.00,51000.00,'cod','pending','pending',NULL,NULL,'2026-10-22 06:47:49','2026-10-22 06:47:49'),(20,'NT-2610-6180',6,NULL,'765A Tp hcm, r, TP. Há»“ ChĂ­ Minh',50000.00,2000.00,0.00,52000.00,'sepay','pending','pending',NULL,NULL,'2026-10-22 07:41:30','2026-10-22 15:15:57'),(21,'NT-2610-9063',6,7,'765A Tp hcm, r, TP. Há»“ ChĂ­ Minh',0.00,2000.00,50000.00,2000.00,'sepay','pending','pending',NULL,NULL,'2026-10-22 07:41:30','2026-10-22 15:15:57'),(24,'NT-2610-9964',6,NULL,'765A Tp hcm, r, TP. Há»“ ChĂ­ Minh',50000.00,2000.00,0.00,52000.00,'sepay','pending','pending',NULL,NULL,'2026-10-22 07:44:20','2026-10-22 15:15:57'),(25,'NT-2610-8735',6,5,'765A Tp hcm, r, TP. Há»“ ChĂ­ Minh',0.00,2000.00,50000.00,2000.00,'sepay','paid','confirmed','[SePay Webhook] Thanh toĂ¡n thĂ nh cĂ´ng 2.000 Ä‘ qua MBBank (Ref: FT26295755326490) lĂºc 2026-10-22 14:45:00',NULL,'2026-10-22 07:45:40','2026-10-22 15:15:57'),(26,'NT-2610-3146',6,5,'110d tĂ¢n quĂ½, tĂ¢n phĂº, HCM, r, TP. Há»“ ChĂ­ Minh',0.00,2000.00,50000.00,2000.00,'sepay','paid','confirmed','[SePay Webhook] Thanh toĂ¡n thĂ nh cĂ´ng 2.000 Ä‘ qua MBBank (Ref: FT26295050733038) lĂºc 2026-10-22 14:52:00',NULL,'2026-10-22 07:52:04','2026-10-22 15:15:57'),(27,'NT-2610-8318',6,5,'110d tĂ¢n quĂ½, tĂ¢n phĂº, HCM, r, TP. Há»“ ChĂ­ Minh',0.00,2000.00,50000.00,2000.00,'sepay','paid','confirmed','[SePay Webhook] Thanh toĂ¡n thĂ nh cĂ´ng 2.000 Ä‘ qua MBBank (Ref: FT26295064070640) lĂºc 2026-10-22 15:09:00',NULL,'2026-10-22 08:09:42','2026-10-22 15:15:57'),(28,'NT-2610-2866',6,NULL,'110d tĂ¢n quĂ½, tĂ¢n phĂº, HCM, r, TP. Há»“ ChĂ­ Minh',50000.00,2000.00,0.00,52000.00,'cod','pending','pending',NULL,NULL,'2026-10-22 08:10:45','2026-10-22 15:15:57'),(29,'NT-2610-2519',5,NULL,'543b tĂ¢n phĂº, r, TP. Há»“ ChĂ­ Minh',50000.00,2000.00,0.00,52000.00,'sepay','pending','pending',NULL,NULL,'2026-10-22 15:34:01','2026-10-22 15:34:01'),(30,'NT-2610-7865',5,NULL,'110d tĂ¢n quĂ½, tĂ¢n phĂº, HCM, r, TP. Há»“ ChĂ­ Minh',50000.00,4000.00,0.00,54000.00,'cod','pending','pending',NULL,NULL,'2026-10-22 16:57:01','2026-10-22 16:57:01'),(31,'NT-2610-5539',6,NULL,'543b tĂ¢n phĂº, r, TP. Há»“ ChĂ­ Minh',50000.00,2000.00,0.00,52000.00,'sepay','paid','cancelled','[SePay Webhook] Thanh toĂ¡n thĂ nh cĂ´ng 52.000 Ä‘ qua MBBank (Ref: FT26296741390800) lĂºc 2026-10-23 09:27:00',NULL,'2026-10-23 02:27:01','2026-10-27 09:49:01'),(32,'NT-2610-8123',13,NULL,'220 nguyá»…n há»“ng Ä‘Ă o, tĂ¢n bĂ¬nh, TP. Há»“ ChĂ­ Minh',50000.00,2000.00,0.00,52000.00,'sepay','pending','pending',NULL,NULL,'2026-10-27 03:17:55','2026-10-27 03:17:55'),(33,'NT-2610-4939',13,NULL,'220 nguyá»…n há»“ng Ä‘Ă o, tĂ¢n bĂ¬nh, TP. Há»“ ChĂ­ Minh',50000.00,2000.00,0.00,52000.00,'cod','paid','completed',NULL,NULL,'2026-10-27 03:18:22','2026-10-27 10:19:49'),(35,'NT-2610-5686',7,NULL,'412 LÅ©y BĂ¡n BĂ­ch, TĂ¢n PhĂº, TP. Há»“ ChĂ­ Minh',50000.00,8000.00,0.00,58000.00,'cod','paid','completed',NULL,NULL,'2026-10-29 08:16:20','2026-10-29 15:17:48'),(36,'NT-2610-6366',15,NULL,'412 LÅ©y BĂ¡n BĂ­ch, TĂ¢n PhĂº, TP. Há»“ ChĂ­ Minh',50000.00,4000.00,0.00,54000.00,'cod','pending','shipping',NULL,NULL,'2026-10-29 08:18:50','2026-10-29 18:30:30');
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
  `weight_gram` int(11) DEFAULT NULL COMMENT 'DÄ‚Â¹ng Ă„â€˜Ă¡Â»Æ’ tÄ‚Â­nh phÄ‚Â­ ship',
  `dimensions` varchar(50) DEFAULT NULL COMMENT 'DÄ‚Â i x RĂ¡Â»â„¢ng x Cao',
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
INSERT INTO `product_variants` VALUES (1,1,'SKU-SOFA-DA-Y-MILANO',NULL,'Da bĂ² Ă',5000.00,2500.00,NULL,22,NULL,'240 Ă— 95 Ă— 78 cm'),(2,2,'SKU-SOFA-VAI-LINEN-OSLO',NULL,'Váº£i linen',26500000.00,15370000.00,NULL,20,NULL,'210 Ă— 88 Ă— 80 cm'),(3,3,'SKU-SOFA-GOC-BAC-AU',NULL,'Váº£i bá»‘',32900000.00,19080000.00,NULL,20,NULL,'270 Ă— 180 Ă— 82 cm'),(4,4,'SKU-BAN-AN-DA-MARBLE-CARRARA',NULL,'ÄĂ¡ marble',32500000.00,18850000.00,NULL,20,NULL,'180 Ă— 90 Ă— 75 cm'),(5,5,'SKU-BAN-AN-GO-SOI-NGA',NULL,'Gá»— sá»“i',18900000.00,10960000.00,NULL,20,NULL,'160 Ă— 80 Ă— 75 cm'),(6,6,'SKU-GHE-AN-DA-BOC-Y',NULL,'Da cĂ´ng nghiá»‡p',4200000.00,2440000.00,NULL,20,NULL,'48 Ă— 55 Ă— 88 cm'),(7,7,'SKU-GHE-THU-GIAN-GO-OC-CHO',NULL,'Gá»— Ă³c chĂ³',18900000.00,10960000.00,NULL,20,NULL,'72 Ă— 80 Ă— 95 cm'),(8,8,'SKU-GHE-CONG-THAI-HOC-ERGO',NULL,'LÆ°á»›i & nhá»±a',6900000.00,4000000.00,NULL,20,NULL,'66 Ă— 66 Ă— 118 cm'),(9,9,'SKU-GHE-NGOAI-TROI-GO-TEAK',NULL,'Gá»— teak',8900000.00,5160000.00,NULL,20,NULL,'58 Ă— 62 Ă— 85 cm'),(10,10,'SKU-GIUONG-BOC-NI-VELVET',NULL,'Ná»‰ velvet',22900000.00,13280000.00,NULL,20,NULL,'180 Ă— 200 Ă— 110 cm'),(11,11,'SKU-GIUONG-GO-TU-NHIEN-SCANDINAVIAN',NULL,'Gá»— sá»“i',28500000.00,16530000.00,NULL,20,NULL,'160 Ă— 200 Ă— 95 cm'),(12,12,'SKU-TU-QUAN-AO-4-CANH',NULL,'Gá»— MDF',11000000.00,6380000.00,12600000.00,20,NULL,'200 Ă— 60 Ă— 220 cm'),(13,13,'SKU-KE-TIVI-TREO-TUONG',NULL,'Gá»— cĂ´ng nghiá»‡p',9800000.00,5680000.00,NULL,20,NULL,'180 Ă— 35 Ă— 40 cm'),(14,14,'SKU-KE-SACH-GO-THONG',NULL,'Gá»— thĂ´ng',7200000.00,4180000.00,NULL,20,NULL,'80 Ă— 30 Ă— 180 cm'),(15,15,'SKU-DEN-SAN-DONG-THAU',NULL,'Äá»“ng thau',7900000.00,4580000.00,NULL,20,NULL,'Ă˜ 40 Ă— 160 cm'),(16,16,'SKU-DEN-THA-TRAN-MAY',NULL,'MĂ¢y tá»± nhiĂªn',3400000.00,1970000.00,NULL,20,NULL,'Ă˜ 55 Ă— 40 cm'),(17,17,'SKU-DEN-BAN-GOM',NULL,'Gá»‘m',1900000.00,1100000.00,NULL,20,NULL,'Ă˜ 25 Ă— 45 cm'),(18,18,'SKU-BAN-TRA-MAT-KINH',NULL,'KĂ­nh cÆ°á»ng lá»±c',5600000.00,3250000.00,NULL,20,NULL,'120 Ă— 60 Ă— 42 cm'),(19,19,'SKU-GUONG-TRANG-TRI-VIEN-VANG',NULL,'Há»£p kim máº¡',3100000.00,1800000.00,NULL,20,NULL,'60 Ă— 90 cm'),(20,20,'SOFADEN_NHAM_001',NULL,'Da bĂ² Ă',7500000.00,4350000.00,NULL,20,NULL,'220 Ă— 90 Ă— 75 cm'),(21,21,'CHAM_TRANG_TRI_001',NULL,'gá»‘m',2000.00,1000.00,4000.00,18,NULL,NULL),(22,22,'TEST_PA3_PRODUCT_1792641888_001',NULL,NULL,3500000.00,2030000.00,NULL,15,NULL,NULL);
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
  `status` tinyint(1) DEFAULT 1 COMMENT '1: Ă„Âang bÄ‚Â¡n, 0: NgĂ¡Â»Â«ng bÄ‚Â¡n',
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
INSERT INTO `products` VALUES (1,1,'Sofa da Ă Milano','sofa-da-y-milano','Sofa ba chá»— bá»c da bĂ² Ă nguyĂªn táº¥m, khung gá»— sá»“i sáº¥y khĂ´ vĂ  Ä‘á»‡m mĂºt Ä‘Ă n há»“i cao cáº¥p, giá»¯ phom bá»n theo thá»i gian.',NULL,NULL,68,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(2,1,'Sofa váº£i linen Oslo','sofa-vai-linen-oslo','Sofa váº£i linen thoĂ¡ng mĂ¡t, Ä‘Æ°á»ng may tá»‰ má»‰, chĂ¢n gá»— cháº¿ tĂ¡c thá»§ cĂ´ng, phĂ¹ há»£p khĂ´ng gian sá»‘ng tá»‘i giáº£n.',NULL,NULL,74,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(3,1,'Sofa gĂ³c Báº¯c Ă‚u','sofa-goc-bac-au','Sofa gĂ³c chá»¯ L phong cĂ¡ch Báº¯c Ă‚u, cĂ¡c mĂ´-Ä‘un thĂ¡o rá»i vĂ  Ä‘á»•i hÆ°á»›ng linh hoáº¡t theo bá»‘ cá»¥c phĂ²ng.',NULL,NULL,71,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(4,2,'BĂ n Äƒn Ä‘Ă¡ marble Carrara','ban-an-da-marble-carrara','BĂ n Äƒn máº·t Ä‘Ă¡ marble Carrara nháº­p kháº©u, chĂ¢n kim loáº¡i máº¡ titan chá»‘ng gá»‰, máº·t bĂ n Ä‘Æ°á»£c xá»­ lĂ½ chá»‘ng tháº¥m.',NULL,NULL,72,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(5,2,'BĂ n Äƒn gá»— sá»“i Nga','ban-an-go-soi-nga','BĂ n Äƒn gá»— sá»“i Nga nguyĂªn khá»‘i, phá»§ dáº§u báº£o vá»‡ tá»± nhiĂªn giá»¯ trá»n vĂ¢n gá»— vĂ  Ä‘á»™ áº¥m cá»§a cháº¥t liá»‡u.',NULL,NULL,63,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(6,3,'Gháº¿ Äƒn da bá»c Ă','ghe-an-da-boc-y','Gháº¿ Äƒn bá»c da cĂ´ng nghiá»‡p cao cáº¥p, khung thĂ©p chá»‹u lá»±c, Ä‘á»‡m Ăªm vá»«a váº·n cho bá»¯a Äƒn dĂ i.',NULL,NULL,63,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(7,3,'Gháº¿ thÆ° giĂ£n gá»— Ă³c chĂ³','ghe-thu-gian-go-oc-cho','Gháº¿ thÆ° giĂ£n gá»— Ă³c chĂ³, tá»±a lÆ°ng cong theo cÆ¡ thá»ƒ, Ä‘á»‡m váº£i nháº­p kháº©u táº¡o cáº£m giĂ¡c dá»… chá»‹u khi Ä‘á»c sĂ¡ch.',NULL,NULL,65,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(8,3,'Gháº¿ cĂ´ng thĂ¡i há»c Ergo','ghe-cong-thai-hoc-ergo','Gháº¿ cĂ´ng thĂ¡i há»c lÆ°ng lÆ°á»›i, tá»±a Ä‘áº§u vĂ  tay vá»‹n Ä‘iá»u chá»‰nh ba hÆ°á»›ng, há»— trá»£ cá»™t sá»‘ng khi lĂ m viá»‡c dĂ i.',NULL,NULL,63,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(9,3,'Gháº¿ ngoĂ i trá»i gá»— teak','ghe-ngoai-troi-go-teak','Gháº¿ ngoĂ i trá»i gá»— teak chá»‘ng má»‘i má»t vĂ  chá»‹u Ä‘Æ°á»£c mÆ°a náº¯ng, phĂ¹ há»£p ban cĂ´ng, sĂ¢n vÆ°á»n.',NULL,NULL,63,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(10,4,'GiÆ°á»ng ngá»§ bá»c ná»‰ Velvet','giuong-boc-ni-velvet','GiÆ°á»ng bá»c ná»‰ velvet vá»›i Ä‘áº§u giÆ°á»ng cao, khung gá»— cháº¯c cháº¯n vĂ  há»‡ nan Ä‘á»‡m Ăªm Ă¡i.',NULL,NULL,63,1,'2026-10-08 09:00:01','2026-10-29 19:01:28',NULL),(11,4,'GiÆ°á»ng gá»— tá»± nhiĂªn Scandinavian','giuong-go-tu-nhien-scandinavian','GiÆ°á»ng gá»— sá»“i tá»± nhiĂªn tá»‘i giáº£n, bá» máº·t phá»§ dáº§u má» an toĂ n cho sá»©c khá»e vĂ  dá»… vá»‡ sinh.',NULL,NULL,63,1,'2026-10-08 09:00:01','2026-10-29 19:01:29',NULL),(12,5,'Tá»§ quáº§n Ă¡o 4 cĂ¡nh','tu-quan-ao-4-canh','Tá»§ quáº§n Ă¡o bá»‘n cĂ¡nh gá»— MDF chá»‘ng áº©m, ray giáº£m cháº¥n vĂ  há»‡ ngÄƒn chia tiá»‡n dá»¥ng.',NULL,NULL,73,1,'2026-10-08 09:00:02','2026-10-29 19:01:29',NULL),(13,5,'Ká»‡ tivi treo tÆ°á»ng','ke-tivi-treo-tuong','Ká»‡ tivi treo tÆ°á»ng gá»n gĂ ng, cĂ³ lá»— Ä‘i dĂ¢y Ä‘iá»‡n vĂ  táº£i trá»ng tá»›i 60 kg.',NULL,NULL,66,1,'2026-10-08 09:00:02','2026-10-29 19:01:29',NULL),(14,5,'Ká»‡ sĂ¡ch gá»— thĂ´ng','ke-sach-go-thong','Ká»‡ sĂ¡ch gá»— thĂ´ng nÄƒm táº§ng, thiáº¿t káº¿ má»Ÿ giĂºp gĂ³c lĂ m viá»‡c thoĂ¡ng Ä‘Ă£ng vĂ  dá»… sáº¯p xáº¿p.',NULL,NULL,66,1,'2026-10-08 09:00:02','2026-10-29 19:01:29',NULL),(15,6,'ÄĂ¨n sĂ n Ä‘á»“ng thau','den-san-dong-thau','ÄĂ¨n sĂ n Ä‘á»“ng thau thĂ¢n máº£nh, chao váº£i táº£n sĂ¡ng dá»‹u, táº¡o Ä‘iá»ƒm nháº¥n cho gĂ³c Ä‘á»c sĂ¡ch.',NULL,NULL,63,1,'2026-10-08 09:00:02','2026-10-29 19:01:29',NULL),(16,6,'ÄĂ¨n tháº£ tráº§n mĂ¢y','den-tha-tran-may','ÄĂ¨n tháº£ tráº§n Ä‘an mĂ¢y tá»± nhiĂªn, Ă¡nh sĂ¡ng áº¥m Ă¡p, phĂ¹ há»£p treo trĂªn bĂ n Äƒn hoáº·c Ä‘áº£o báº¿p.',NULL,NULL,67,1,'2026-10-08 09:00:02','2026-10-29 19:01:29',NULL),(17,6,'ÄĂ¨n bĂ n gá»‘m','den-ban-gom','ÄĂ¨n bĂ n gá»‘m men má», chá»¥p váº£i, cho Ă¡nh sĂ¡ng vĂ ng áº¥m phĂ¹ há»£p bĂ n lĂ m viá»‡c vĂ  Ä‘áº§u giÆ°á»ng.',NULL,NULL,63,1,'2026-10-08 09:00:02','2026-10-29 19:01:29',NULL),(18,7,'BĂ n trĂ  máº·t kĂ­nh','ban-tra-mat-kinh','BĂ n trĂ  máº·t kĂ­nh cÆ°á»ng lá»±c 12 mm, khung inox máº¡ vĂ ng sang trá»ng, dá»… lau chĂ¹i.',NULL,NULL,63,1,'2026-10-08 09:00:02','2026-10-29 19:01:29',NULL),(19,7,'GÆ°Æ¡ng trang trĂ­ viá»n máº¡ vĂ ng','guong-trang-tri-vien-vang','GÆ°Æ¡ng trang trĂ­ viá»n há»£p kim máº¡ vĂ ng, treo ngang hoáº·c dá»c Ä‘á»u cĂ¢n Ä‘á»‘i cho phĂ²ng ngá»§.',NULL,NULL,63,1,'2026-10-08 09:00:02','2026-10-29 19:01:29',NULL),(20,1,'Sofa da bĂ² Ă cao cáº¥p','sofaden-nham','Sofa da mĂ u Ä‘en nhĂ¡m quĂ½ phĂ¡i, Ä‘á»‡m Ăªm Ă¡i cho khĂ´ng gian phĂ²ng khĂ¡ch hiá»‡n Ä‘áº¡i.',NULL,NULL,177,1,'2026-10-15 16:33:12','2026-10-29 19:01:29',NULL),(21,7,'cham trang trĂ­','cham-trang-tri','sáº£n pháº©m trang trĂ­ ná»•i báº­t',NULL,NULL,71,1,'2026-10-22 03:38:08','2026-10-29 19:01:29',NULL),(22,1,'S?n ph?m th? nghi?m Phuong ï¿½n 3','test-pa3-product-1792641888',NULL,NULL,NULL,0,0,'2026-10-22 04:04:48','2026-10-22 11:04:54','2026-10-22 04:04:54');
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
INSERT INTO `roles` VALUES (1,'admin','QuĂ¡ÂºÂ£n trĂ¡Â»â€¹ viÄ‚Âªn toÄ‚Â n quyĂ¡Â»Ân'),(2,'seller','NgĂ†Â°Ă¡Â»Âi bÄ‚Â¡n hÄ‚Â ng, quĂ¡ÂºÂ£n lÄ‚Â½ sĂ¡ÂºÂ£n phĂ¡ÂºÂ©m, Ă„â€˜Ă†Â¡n hÄ‚Â ng'),(3,'customer','KhÄ‚Â¡ch mua hÄ‚Â ng'),(4,'consultant','ChuyĂªn viĂªn tÆ° váº¥n phong thá»§y'),(5,'warehouse','Thá»§ kho & váº­n chuyá»ƒn'),(6,'marketing','Marketing & truyá»n thĂ´ng'),(7,'cashier','Thu ngĂƒÂ¢n & KĂ¡ÂºÂ¿ toĂƒÂ¡n quĂ¡Â»Â¹, quĂ¡ÂºÂ£n lĂƒÂ½ dĂƒÂ²ng tiĂ¡Â»Ân vĂƒÂ  Ă„â€˜Ă¡Â»â€˜i soĂƒÂ¡t');
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
  `session_id` varchar(255) DEFAULT NULL COMMENT 'DÄ‚Â nh cho khÄ‚Â¡ch chĂ†Â°a Ă„â€˜Ă„Æ’ng nhĂ¡ÂºÂ­p',
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
INSERT INTO `spaces` VALUES (1,'PhĂ²ng khĂ¡ch','phong-khach','https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1200&q=80',1,1,'2026-10-23 04:38:26','2026-10-23 04:38:26'),(2,'PhĂ²ng ngá»§','phong-ngu','https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1200&q=80',2,1,'2026-10-23 04:38:26','2026-10-23 04:38:26'),(3,'PhĂ²ng Äƒn','phong-an','https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=1200&q=80',3,1,'2026-10-23 04:38:26','2026-10-23 04:38:26'),(4,'LĂ m viá»‡c','lam-viec','https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=1200&q=80',4,1,'2026-10-23 04:38:26','2026-10-23 04:38:26'),(5,'Chiáº¿u sĂ¡ng','chieu-sang','https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=1200&q=80',5,1,'2026-10-23 04:38:26','2026-10-23 04:38:26'),(6,'NgoĂ i trá»i','ngoai-troi','https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=1200&q=80',6,1,'2026-10-23 04:38:26','2026-10-23 04:38:26');
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
INSERT INTO `suppliers` VALUES (1,'NCC-GO-BAC-AU','XÆ°á»Ÿng Ná»™i Tháº¥t ChĂ¢u Ă‚u','TrÆ°Æ¡ng ChĂ­ Vá»¹','0912345678','hung.gobackau@noithat.vn','HĂ€ Ná»˜I',1,'2026-10-29 15:47:05','2026-10-29 16:52:37'),(2,'NCC-DA-Y-MILANO','CĂ´ng Ty Sofa Cao Cáº¥p NhĂ  K','K Khoa','0934567890','trang.milano@da-y.vn','TĂ¢n PhĂº, Há»“ ChĂ­ Minh',1,'2026-10-29 15:47:05','2026-10-29 16:53:44'),(3,'NCC-DA-MARBLE','TĂ¡Â»â€¢ng Kho Ă„ÂĂƒÂ¡ TĂ¡Â»Â± NhiĂƒÂªn & BĂƒÂ n Ă„â€n Carrara','LĂƒÂª HoĂƒÂ ng Long','0978901234','long.carrara@stone-viet.com','KCN BiĂƒÂªn HĂƒÂ²a 2, Ă„ÂĂ¡Â»â€œng Nai',0,'2026-10-29 15:47:05','2026-10-29 16:53:52'),(4,'NCC-GOM-DEN','XĂ†Â°Ă¡Â»Å¸ng Ă„ÂĂƒÂ¨n ThĂ¡Â»Â§ CĂƒÂ´ng MĂ¡Â»Â¹ NghĂ¡Â»â€¡ & GĂ¡Â»â€˜m SĂ¡Â»Â©','PhĂ¡ÂºÂ¡m Minh Ă„ÂĂ¡Â»Â©c','0901239876','duc.gomart@noithat.vn','LĂƒÂ ng GĂ¡Â»â€˜m BĂƒÂ¡t TrĂƒÂ ng, Gia LĂƒÂ¢m, HĂƒÂ  NĂ¡Â»â„¢i',0,'2026-10-29 15:47:05','2026-10-29 16:54:06'),(5,'NCC-005','XÆ°á»Ÿng Gá»— Quáº£ng ChĂ¢u','Anh Lá»£i Hotboi','0902566063',NULL,'Há»“ ChĂ­ Minh',1,'2026-10-29 10:41:02','2026-10-29 10:41:02');
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,3,'hi@gmail.com','$2b$10$H3ndNj83h9RJ8QOHeiDei.5W0.REvZ.zcKgKV10Tv5AJTcL3QLnH.','hi','0903456789',NULL,1,'2026-10-09 06:18:11','2026-10-16 12:13:46',NULL),(2,3,'test@gmail.com','guest_no_login','Nguyá»…n VÄƒn Test','0988776655',NULL,1,'2026-10-09 06:45:38','2026-10-22 09:28:50',NULL),(3,3,'truongvy6272005@gmail.com','guest_no_login','vy truong','0123456789',NULL,1,'2026-10-09 07:29:42','2026-10-09 07:29:42',NULL),(4,3,'truongvy2762005@gmail.com','GOOGLE_OAUTH_ACCOUNT','Vá»¹ kC',NULL,'https://lh3.googleusercontent.com/a/ACg8ocJ2NPbtjfbyyXQ6uch4KEjQnd--kzitj9wQpAmn2toz_4Tn4Bo=s96-c',1,'2026-10-15 05:57:00','2026-10-22 09:28:50',NULL),(5,3,'truongvy1022@gmail.com','GOOGLE_OAUTH_ACCOUNT','TC Vá»¹',NULL,'https://lh3.googleusercontent.com/a/ACg8ocLhZ6L4w2K-WVrG7afxpApEK-nu_0Wpy6X0FIBpJWPBMPTP2KQ=s96-c',1,'2026-10-15 06:20:28','2026-10-22 09:28:50',NULL),(6,1,'admin@noithat.vn','$2b$10$pZW98jYWOjFUbibKOUiAPuAIEQyHsLYFTzkVF4oowryYGtmgu0agG','Quáº£n Trá»‹ ViĂªn','0359180209',NULL,1,'2026-10-16 05:07:04','2026-10-23 09:27:01',NULL),(7,1,'huuloi230605@gmail.com','$2b$10$eEOn1NBbmWBILnUzlZ6qHepjpy2xYhXV9ecPFrZYj7vOURP07GlDq','Pháº¡m Há»¯u Lá»£i','0902455063','https://lh3.googleusercontent.com/a/ACg8ocLzhk1m_1LhcUGjj9gfktop0CQekD7_cbSo3lFwSz1ZgAnUK4_EBA=s96-c',1,'2026-10-18 12:53:49','2026-10-22 09:28:50',NULL),(8,3,'test@example.com','guest_no_login','Tráº§n VÄƒn Test VIP','0988777666',NULL,1,'2026-10-21 04:19:14','2026-10-23 14:47:58',NULL),(9,3,'testsim@example.com','guest_no_login','Tran Van Test Simulator','0988777999',NULL,1,'2026-10-21 04:19:22','2026-10-21 04:19:22',NULL),(10,3,'vabshop2026@gmail.com','$2b$10$kdtOAo.Wc18c8O7Ux6.JrufiviFJOIoiljjW.m8xYx1x7o56Vq41S','Vab Shop',NULL,'https://lh3.googleusercontent.com/a/ACg8ocJGscgmOMruAxUDT96bPa4yVCtZ8kUztI6RDwngAFTzFlJB1qk=s96-c',1,'2026-10-21 06:50:32','2026-10-21 06:50:32',NULL),(11,3,'khach_1792651669064@noithat.local','guest_no_login','KhĂ¡ch Test Coupon','0987654321',NULL,1,'2026-10-22 06:47:49','2026-10-22 06:47:49',NULL),(12,2,'vy.dang@noithat.vn','$2b$10$pqyJbU4XM/qEuQ3eWFCKoeP1.27WnKaTxXLcxHPe0Gj41jc/dcI6e','Äáº·ng Tháº£o Vy','0909003003',NULL,1,'2026-10-23 07:29:41','2026-10-23 14:29:56',NULL),(13,3,'kkhoa2304@gmail.com','$2b$10$t.8oOrU25q8lSoxmSkReWOChoemJ.PMoAS6HzQ/MMPKWpSSOe3t1m','K Khoa','0877766122',NULL,1,'2026-10-27 02:22:57','2026-10-27 02:43:46',NULL),(14,3,'khach_1793067441199_269@noithat.local','guest_review','Nguyá»…n VÄƒn Test','0901234567',NULL,1,'2026-10-27 02:17:21','2026-10-27 02:17:21',NULL),(15,3,'huuloi2005@gmail.com','$2b$10$OeapyVSWs1605d2VWuQGfe7KHgXztqCgUMM9qx8Vpcp/k2enQZDsO','Pháº¡m Lá»£i','0902455060',NULL,1,'2026-10-28 02:55:10','2026-10-28 10:43:17',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlists`
--

LOCK TABLES `wishlists` WRITE;
/*!40000 ALTER TABLE `wishlists` DISABLE KEYS */;
INSERT INTO `wishlists` VALUES (2,4,13,'2026-10-16 08:09:57'),(4,5,16,'2026-10-22 02:47:34');
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

-- Dump completed on 2026-10-29 19:06:13
