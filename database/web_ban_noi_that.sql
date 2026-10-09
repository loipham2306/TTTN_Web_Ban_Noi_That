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
INSERT INTO `bot_prompts` VALUES (1,'system_prompt','Bß║ín l├á trß╗ú l├╜ AI ß║úo cß╗ºa cß╗¡a h├áng Trai ─Éß║╣p B├ín Nß╗Öi Thß║Ñt. H├úy t╞░ vß║Ñn lß╗ïch sß╗▒, ngß║»n gß╗ìn v├á hß╗»u ├¡ch cho kh├ích h├áng. X╞░ng h├┤ l├á dß║í/th╞░a.',1),(2,'shipping_policy','Giao h├áng miß╗àn ph├¡ nß╗Öi th├ánh cho ─æ╞ín tß╗½ 2 triß╗çu. C├íc tß╗ënh kh├íc ph├¡ ship mß║╖c ─æß╗ïnh 100k.',1);
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
INSERT INTO `categories` VALUES (1,NULL,'Sofa','sofa',NULL,1),(2,NULL,'B├án ─ân','ban-an',NULL,1),(3,NULL,'Ghß║┐','ghe',NULL,1),(4,NULL,'Gi╞░ß╗¥ng','giuong',NULL,1),(5,NULL,'Tß╗º & Kß╗ç','tu-ke',NULL,1),(6,NULL,'─É├¿n','den',NULL,1),(7,NULL,'Trang tr├¡','trang-tri',NULL,1);
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
  `sender_id` bigint(20) unsigned DEFAULT NULL COMMENT 'ID cß╗ºa user hoß║╖c seller nß║┐u c├│',
  `content` text NOT NULL COMMENT 'Nß╗Öi dung tin nhß║»n',
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
  `guest_id` varchar(255) DEFAULT NULL COMMENT 'Cookie/Session ID cho kh├ích v├úng lai',
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
  `product_name` varchar(255) NOT NULL COMMENT 'T├¬n l╞░u cß╗⌐ng l├║c mua',
  `variant_name` varchar(255) DEFAULT NULL COMMENT 'M├áu/Chß║Ñt liß╗çu l╞░u cß╗⌐ng',
  `sku` varchar(50) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL COMMENT 'Gi├í l╞░u cß╗⌐ng l├║c mua',
  `total_price` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  KEY `variant_id` (`variant_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL,
  CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,1,1,'Sofa Da ├¥ Milano',NULL,'SKU-SOFA-DA-Y-MILANO',1,28500000.00,28500000.00),(2,2,3,3,'Sofa g├│c Bß║»c ├éu',NULL,'SKU-SOFA-GOC-BAC-AU',1,32900000.00,32900000.00);
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
  `shipping_address` text NOT NULL COMMENT 'L╞░u cß╗⌐ng ─æß╗ïa chß╗ë text/JSON l├║c ─æß║╖t',
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'NT-2610-5562',2,NULL,'123 ─É╞░ß╗¥ng Cß║ºu Giß║Ñy, Cß║ºu Giß║Ñy, H├á Nß╗Öi',0.00,28500000.00,0.00,28500000.00,'cod','pending','pending',NULL,'─É╞ín h├áng kiß╗âm thß╗¡ hß╗ç thß╗æng','2026-10-09 06:45:38','2026-10-09 06:45:38'),(2,'NT-2610-1702',3,NULL,'110d t├ón qu├╜, t├ón ph├║, HCM, r, H├á Nß╗Öi',0.00,32900000.00,0.00,32900000.00,'cod','pending','pending',NULL,'s','2026-10-09 07:29:42','2026-10-09 07:29:42');
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
  `image_url` varchar(255) NOT NULL,
  `is_thumbnail` tinyint(1) DEFAULT 0,
  `sort_order` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `variant_id` (`variant_id`),
  CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_images_ibfk_2` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
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
  `weight_gram` int(11) DEFAULT NULL COMMENT 'D├╣ng ─æß╗â t├¡nh ph├¡ ship',
  `dimensions` varchar(50) DEFAULT NULL COMMENT 'D├ái x Rß╗Öng x Cao',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sku` (`sku`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_variants_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_variants`
--

LOCK TABLES `product_variants` WRITE;
/*!40000 ALTER TABLE `product_variants` DISABLE KEYS */;
INSERT INTO `product_variants` VALUES (1,1,'SKU-SOFA-DA-Y-MILANO',NULL,'Da b├▓ ├¥',58900000.00,NULL,20,NULL,'240 ├ù 95 ├ù 78 cm'),(2,2,'SKU-SOFA-VAI-LINEN-OSLO',NULL,'Vß║úi linen',26500000.00,NULL,20,NULL,'210 ├ù 88 ├ù 80 cm'),(3,3,'SKU-SOFA-GOC-BAC-AU',NULL,'Vß║úi bß╗æ',32900000.00,NULL,20,NULL,'270 ├ù 180 ├ù 82 cm'),(4,4,'SKU-BAN-AN-DA-MARBLE-CARRARA',NULL,'─É├í marble',32500000.00,NULL,20,NULL,'180 ├ù 90 ├ù 75 cm'),(5,5,'SKU-BAN-AN-GO-SOI-NGA',NULL,'Gß╗ù sß╗ôi',18900000.00,NULL,20,NULL,'160 ├ù 80 ├ù 75 cm'),(6,6,'SKU-GHE-AN-DA-BOC-Y',NULL,'Da c├┤ng nghiß╗çp',4200000.00,NULL,20,NULL,'48 ├ù 55 ├ù 88 cm'),(7,7,'SKU-GHE-THU-GIAN-GO-OC-CHO',NULL,'Gß╗ù ├│c ch├│',18900000.00,NULL,20,NULL,'72 ├ù 80 ├ù 95 cm'),(8,8,'SKU-GHE-CONG-THAI-HOC-ERGO',NULL,'L╞░ß╗¢i & nhß╗▒a',6900000.00,NULL,20,NULL,'66 ├ù 66 ├ù 118 cm'),(9,9,'SKU-GHE-NGOAI-TROI-GO-TEAK',NULL,'Gß╗ù teak',8900000.00,NULL,20,NULL,'58 ├ù 62 ├ù 85 cm'),(10,10,'SKU-GIUONG-BOC-NI-VELVET',NULL,'Nß╗ë velvet',22900000.00,NULL,20,NULL,'180 ├ù 200 ├ù 110 cm'),(11,11,'SKU-GIUONG-GO-TU-NHIEN-SCANDINAVIAN',NULL,'Gß╗ù sß╗ôi',28500000.00,NULL,20,NULL,'160 ├ù 200 ├ù 95 cm'),(12,12,'SKU-TU-QUAN-AO-4-CANH',NULL,'Gß╗ù MDF',24500000.00,NULL,20,NULL,'200 ├ù 60 ├ù 220 cm'),(13,13,'SKU-KE-TIVI-TREO-TUONG',NULL,'Gß╗ù c├┤ng nghiß╗çp',9800000.00,NULL,20,NULL,'180 ├ù 35 ├ù 40 cm'),(14,14,'SKU-KE-SACH-GO-THONG',NULL,'Gß╗ù th├┤ng',7200000.00,NULL,20,NULL,'80 ├ù 30 ├ù 180 cm'),(15,15,'SKU-DEN-SAN-DONG-THAU',NULL,'─Éß╗ông thau',7900000.00,NULL,20,NULL,'├ÿ 40 ├ù 160 cm'),(16,16,'SKU-DEN-THA-TRAN-MAY',NULL,'M├óy tß╗▒ nhi├¬n',3400000.00,NULL,20,NULL,'├ÿ 55 ├ù 40 cm'),(17,17,'SKU-DEN-BAN-GOM',NULL,'Gß╗æm',1900000.00,NULL,20,NULL,'├ÿ 25 ├ù 45 cm'),(18,18,'SKU-BAN-TRA-MAT-KINH',NULL,'K├¡nh c╞░ß╗¥ng lß╗▒c',5600000.00,NULL,20,NULL,'120 ├ù 60 ├ù 42 cm'),(19,19,'SKU-GUONG-TRANG-TRI-VIEN-VANG',NULL,'Hß╗úp kim mß║í',3100000.00,NULL,20,NULL,'60 ├ù 90 cm');
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
  `status` tinyint(1) DEFAULT 1 COMMENT '1: ─Éang b├ín, 0: Ngß╗½ng b├ín',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,1,'Sofa da ├¥ Milano','sofa-da-y-milano','Sofa ba chß╗ù bß╗ìc da b├▓ ├¥ nguy├¬n tß║Ñm, khung gß╗ù sß╗ôi sß║Ñy kh├┤ v├á ─æß╗çm m├║t ─æ├án hß╗ôi cao cß║Ñp, giß╗» phom bß╗ün theo thß╗¥i gian.',NULL,NULL,3,1,'2026-10-08 09:00:01','2026-10-09 13:48:40',NULL),(2,1,'Sofa vß║úi linen Oslo','sofa-vai-linen-oslo','Sofa vß║úi linen tho├íng m├ít, ─æ╞░ß╗¥ng may tß╗ë mß╗ë, ch├ón gß╗ù chß║┐ t├íc thß╗º c├┤ng, ph├╣ hß╗úp kh├┤ng gian sß╗æng tß╗æi giß║ún.',NULL,NULL,2,1,'2026-10-08 09:00:01','2026-10-09 13:48:22',NULL),(3,1,'Sofa g├│c Bß║»c ├éu','sofa-goc-bac-au','Sofa g├│c chß╗» L phong c├ích Bß║»c ├éu, c├íc m├┤-─æun th├ío rß╗¥i v├á ─æß╗òi h╞░ß╗¢ng linh hoß║ít theo bß╗æ cß╗Ñc ph├▓ng.',NULL,NULL,2,1,'2026-10-08 09:00:01','2026-10-09 13:48:22',NULL),(4,2,'B├án ─ân ─æ├í marble Carrara','ban-an-da-marble-carrara','B├án ─ân mß║╖t ─æ├í marble Carrara nhß║¡p khß║⌐u, ch├ón kim loß║íi mß║í titan chß╗æng gß╗ë, mß║╖t b├án ─æ╞░ß╗úc xß╗¡ l├╜ chß╗æng thß║Ñm.',NULL,NULL,1,1,'2026-10-08 09:00:01','2026-10-09 13:48:22',NULL),(5,2,'B├án ─ân gß╗ù sß╗ôi Nga','ban-an-go-soi-nga','B├án ─ân gß╗ù sß╗ôi Nga nguy├¬n khß╗æi, phß╗º dß║ºu bß║úo vß╗ç tß╗▒ nhi├¬n giß╗» trß╗ìn v├ón gß╗ù v├á ─æß╗Ö ß║Ñm cß╗ºa chß║Ñt liß╗çu.',NULL,NULL,1,1,'2026-10-08 09:00:01','2026-10-09 13:48:22',NULL),(6,3,'Ghß║┐ ─ân da bß╗ìc ├¥','ghe-an-da-boc-y','Ghß║┐ ─ân bß╗ìc da c├┤ng nghiß╗çp cao cß║Ñp, khung th├⌐p chß╗ïu lß╗▒c, ─æß╗çm ├¬m vß╗½a vß║╖n cho bß╗»a ─ân d├ái.',NULL,NULL,1,1,'2026-10-08 09:00:01','2026-10-09 13:48:22',NULL),(7,3,'Ghß║┐ th╞░ gi├ún gß╗ù ├│c ch├│','ghe-thu-gian-go-oc-cho','Ghß║┐ th╞░ gi├ún gß╗ù ├│c ch├│, tß╗▒a l╞░ng cong theo c╞í thß╗â, ─æß╗çm vß║úi nhß║¡p khß║⌐u tß║ío cß║úm gi├íc dß╗à chß╗ïu khi ─æß╗ìc s├ích.',NULL,NULL,2,1,'2026-10-08 09:00:01','2026-10-09 13:48:22',NULL),(8,3,'Ghß║┐ c├┤ng th├íi hß╗ìc Ergo','ghe-cong-thai-hoc-ergo','Ghß║┐ c├┤ng th├íi hß╗ìc l╞░ng l╞░ß╗¢i, tß╗▒a ─æß║ºu v├á tay vß╗ïn ─æiß╗üu chß╗ënh ba h╞░ß╗¢ng, hß╗ù trß╗ú cß╗Öt sß╗æng khi l├ám viß╗çc d├ái.',NULL,NULL,1,1,'2026-10-08 09:00:01','2026-10-09 13:48:22',NULL),(9,3,'Ghß║┐ ngo├ái trß╗¥i gß╗ù teak','ghe-ngoai-troi-go-teak','Ghß║┐ ngo├ái trß╗¥i gß╗ù teak chß╗æng mß╗æi mß╗ìt v├á chß╗ïu ─æ╞░ß╗úc m╞░a nß║»ng, ph├╣ hß╗úp ban c├┤ng, s├ón v╞░ß╗¥n.',NULL,NULL,1,1,'2026-10-08 09:00:01','2026-10-09 13:48:22',NULL),(10,4,'Gi╞░ß╗¥ng ngß╗º bß╗ìc nß╗ë Velvet','giuong-boc-ni-velvet','Gi╞░ß╗¥ng bß╗ìc nß╗ë velvet vß╗¢i ─æß║ºu gi╞░ß╗¥ng cao, khung gß╗ù chß║»c chß║»n v├á hß╗ç nan ─æß╗çm ├¬m ├íi.',NULL,NULL,1,1,'2026-10-08 09:00:01','2026-10-09 13:48:22',NULL),(11,4,'Gi╞░ß╗¥ng gß╗ù tß╗▒ nhi├¬n Scandinavian','giuong-go-tu-nhien-scandinavian','Gi╞░ß╗¥ng gß╗ù sß╗ôi tß╗▒ nhi├¬n tß╗æi giß║ún, bß╗ü mß║╖t phß╗º dß║ºu mß╗¥ an to├án cho sß╗⌐c khß╗Åe v├á dß╗à vß╗ç sinh.',NULL,NULL,1,1,'2026-10-08 09:00:01','2026-10-09 13:48:22',NULL),(12,5,'Tß╗º quß║ºn ├ío 4 c├ính','tu-quan-ao-4-canh','Tß╗º quß║ºn ├ío bß╗æn c├ính gß╗ù MDF chß╗æng ß║⌐m, ray giß║úm chß║Ñn v├á hß╗ç ng─ân chia tiß╗çn dß╗Ñng.',NULL,NULL,1,1,'2026-10-08 09:00:02','2026-10-09 13:48:22',NULL),(13,5,'Kß╗ç tivi treo t╞░ß╗¥ng','ke-tivi-treo-tuong','Kß╗ç tivi treo t╞░ß╗¥ng gß╗ìn g├áng, c├│ lß╗ù ─æi d├óy ─æiß╗çn v├á tß║úi trß╗ìng tß╗¢i 60 kg.',NULL,NULL,1,1,'2026-10-08 09:00:02','2026-10-09 13:48:22',NULL),(14,5,'Kß╗ç s├ích gß╗ù th├┤ng','ke-sach-go-thong','Kß╗ç s├ích gß╗ù th├┤ng n─âm tß║ºng, thiß║┐t kß║┐ mß╗ƒ gi├║p g├│c l├ám viß╗çc tho├íng ─æ├úng v├á dß╗à sß║»p xß║┐p.',NULL,NULL,1,1,'2026-10-08 09:00:02','2026-10-09 13:48:22',NULL),(15,6,'─É├¿n s├án ─æß╗ông thau','den-san-dong-thau','─É├¿n s├án ─æß╗ông thau th├ón mß║únh, chao vß║úi tß║ún s├íng dß╗ïu, tß║ío ─æiß╗âm nhß║Ñn cho g├│c ─æß╗ìc s├ích.',NULL,NULL,1,1,'2026-10-08 09:00:02','2026-10-09 13:48:22',NULL),(16,6,'─É├¿n thß║ú trß║ºn m├óy','den-tha-tran-may','─É├¿n thß║ú trß║ºn ─æan m├óy tß╗▒ nhi├¬n, ├ính s├íng ß║Ñm ├íp, ph├╣ hß╗úp treo tr├¬n b├án ─ân hoß║╖c ─æß║úo bß║┐p.',NULL,NULL,1,1,'2026-10-08 09:00:02','2026-10-09 13:48:22',NULL),(17,6,'─É├¿n b├án gß╗æm','den-ban-gom','─É├¿n b├án gß╗æm men mß╗¥, chß╗Ñp vß║úi, cho ├ính s├íng v├áng ß║Ñm ph├╣ hß╗úp b├án l├ám viß╗çc v├á ─æß║ºu gi╞░ß╗¥ng.',NULL,NULL,1,1,'2026-10-08 09:00:02','2026-10-09 13:48:22',NULL),(18,7,'B├án tr├á mß║╖t k├¡nh','ban-tra-mat-kinh','B├án tr├á mß║╖t k├¡nh c╞░ß╗¥ng lß╗▒c 12 mm, khung inox mß║í v├áng sang trß╗ìng, dß╗à lau ch├╣i.',NULL,NULL,1,1,'2026-10-08 09:00:02','2026-10-09 13:48:22',NULL),(19,7,'G╞░╞íng trang tr├¡ viß╗ün mß║í v├áng','guong-trang-tri-vien-vang','G╞░╞íng trang tr├¡ viß╗ün hß╗úp kim mß║í v├áng, treo ngang hoß║╖c dß╗ìc ─æß╗üu c├ón ─æß╗æi cho ph├▓ng ngß╗º.',NULL,NULL,1,1,'2026-10-08 09:00:02','2026-10-09 13:48:22',NULL);
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
INSERT INTO `roles` VALUES (1,'admin','Quß║ún trß╗ï vi├¬n to├án quyß╗ün'),(2,'seller','Ng╞░ß╗¥i b├ín h├áng, quß║ún l├╜ sß║ún phß║⌐m, ─æ╞ín h├áng'),(3,'customer','Kh├ích mua h├áng');
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
  `session_id` varchar(255) DEFAULT NULL COMMENT 'D├ánh cho kh├ích ch╞░a ─æ─âng nhß║¡p',
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,3,'hi@gmail.com','12345678','hi','0903456789',NULL,1,'2026-10-09 06:18:11','2026-10-09 06:18:11',NULL),(2,3,'test@gmail.com','guest_no_login','Nguyß╗àn V─ân Test','0988776655',NULL,1,'2026-10-09 06:45:38','2026-10-09 06:45:38',NULL),(3,3,'truongvy6272005@gmail.com','guest_no_login','vy truong','0123456789',NULL,1,'2026-10-09 07:29:42','2026-10-09 07:29:42',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
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

-- Dump completed on 2026-10-09 14:34:23
