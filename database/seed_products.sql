-- ================================================================
-- SEED DATA: web_ban_noi_that
-- Chay file nay SAU KHI da import web_ban_noi_that.sql
-- ================================================================
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------
-- 1. ROLES
-- ----------------------------------------------------------------
INSERT IGNORE INTO `roles` (`id`, `name`, `description`) VALUES
(1, 'admin',    'Quan tri vien he thong'),
(2, 'customer', 'Khach hang');

-- ----------------------------------------------------------------
-- 2. CATEGORIES
-- ----------------------------------------------------------------
INSERT IGNORE INTO `categories` (`id`, `parent_id`, `name`, `slug`, `image_url`, `status`) VALUES
(1,  NULL, 'Sofa',       'sofa',       NULL, 1),
(2,  NULL, 'Ban an',     'ban-an',     NULL, 1),
(3,  NULL, 'Ghe',        'ghe',        NULL, 1),
(4,  NULL, 'Giuong',     'giuong',     NULL, 1),
(5,  NULL, 'Tu & Ke',    'tu-ke',      NULL, 1),
(6,  NULL, 'Den',        'den',        NULL, 1),
(7,  NULL, 'Trang tri',  'trang-tri',  NULL, 1);

-- ----------------------------------------------------------------
-- 3. PRODUCTS (19 san pham)
-- ----------------------------------------------------------------
INSERT IGNORE INTO `products`
  (`id`, `category_id`, `name`, `slug`, `short_description`, `brand`, `status`, `created_at`, `updated_at`)
VALUES
(1,  1, 'Sofa da Y Milano',               'sofa-da-y-milano',              'Sofa da bo Y cao cap, duong may thu cong tinh te, khung go soi nguyen khoi.',             'Milano Home',   1, NOW(), NOW()),
(2,  1, 'Sofa vai linen Oslo',             'sofa-vai-linen-oslo',           'Sofa vai linen tu nhien phong cach Bac Au, nhe nhang va thoang mat.',                    'Nordic Living', 1, NOW(), NOW()),
(3,  1, 'Sofa goc Bac Au',                 'sofa-goc-bac-au',               'Sofa goc chu L vai bo cao cap, thiet ke modular linh hoat.',                             'Nordic Living', 1, NOW(), NOW()),
(4,  2, 'Ban an da marble Carrara',         'ban-an-da-marble-carrara',      'Ban an mat da marble Carrara nhap khau Y, chan thep ma vang.',                           'Luxe Table',    1, NOW(), NOW()),
(5,  2, 'Ban an go soi Nga',               'ban-an-go-soi-nga',             'Ban an go soi Nga nguyen khoi, van go tu nhien dep mat.',                                'Wooden Craft',  1, NOW(), NOW()),
(6,  3, 'Ghe an da boc Y',                 'ghe-an-da-boc-y',               'Ghe an boc da cong nghiep cao cap, chan inox danh bong.',                                'Milano Home',   1, NOW(), NOW()),
(7,  3, 'Ghe thu gian go oc cho',           'ghe-thu-gian-go-oc-cho',        'Ghe thu gian go oc cho tu nhien, dem bong cao cap.',                                    'Nature Wood',   1, NOW(), NOW()),
(8,  3, 'Ghe cong thai hoc Ergo',           'ghe-cong-thai-hoc-ergo',        'Ghe van phong cong thai hoc, dieu chinh 5 chieu, lung luoi thoang.',                   'ErgoPlus',      1, NOW(), NOW()),
(9,  3, 'Ghe ngoai troi go teak',           'ghe-ngoai-troi-go-teak',        'Ghe ngoai troi go teak tu nhien, chiu nuoc, ben voi thoi tiet.',                       'OutdoorLux',    1, NOW(), NOW()),
(10, 4, 'Giuong ngu boc ni Velvet',         'giuong-boc-ni-velvet',          'Giuong ngu boc ni nhung Velvet cao cap, dau giuong op nut boc.',                        'Sleep King',    1, NOW(), NOW()),
(11, 4, 'Giuong go tu nhien Scandinavian',  'giuong-go-tu-nhien-scandinavian','Giuong go soi phong cach Scandinavian toi gian, thanh lich.',                          'Nordic Living', 1, NOW(), NOW()),
(12, 5, 'Tu quan ao 4 canh',               'tu-quan-ao-4-canh',             'Tu quan ao 4 canh go MDF phu Melamine, co guong soi.',                                  'Home Storage',  1, NOW(), NOW()),
(13, 5, 'Ke tivi treo tuong',              'ke-tivi-treo-tuong',            'Ke tivi treo tuong go cong nghiep, toi gian hien dai.',                                 'ModernShelf',   1, NOW(), NOW()),
(14, 5, 'Ke sach go thong',               'ke-sach-go-thong',              'Ke sach go thong tu nhien 5 tang, phu hop phong lam viec.',                             'Wooden Craft',  1, NOW(), NOW()),
(15, 6, 'Den san dong thau',              'den-san-dong-thau',             'Den san chat lieu dong thau cao cap, anh sang vang am.',                                'LightLux',      1, NOW(), NOW()),
(16, 6, 'Den tha tran may',               'den-tha-tran-may',              'Den tha tran dan may tu nhien thu cong, phu hop phong an.',                             'NaturalLight',  1, NOW(), NOW()),
(17, 6, 'Den ban gom',                    'den-ban-gom',                   'Den ban than gom thu cong, chup vai linen am cung.',                                    'CeramicArt',    1, NOW(), NOW()),
(18, 7, 'Ban tra mat kinh',               'ban-tra-mat-kinh',              'Ban tra mat kinh cuong luc 10mm, chan thep son tinh dien.',                             'GlassHome',     1, NOW(), NOW()),
(19, 7, 'Guong trang tri vien ma vang',   'guong-trang-tri-vien-vang',     'Guong trang tri vien hop kim ma vang, thiet ke bo tron thanh lich.',                   'Mirror Art',    1, NOW(), NOW());

-- ----------------------------------------------------------------
-- 4. PRODUCT VARIANTS
-- ----------------------------------------------------------------
INSERT IGNORE INTO `product_variants`
  (`id`, `product_id`, `sku`, `color`, `material`, `price`, `compare_at_price`, `stock_quantity`)
VALUES
(1,  1,  'SOFA-MILANO-001',   'Nau den',    'Da bo Y',          58900000, 65000000,  5),
(2,  2,  'SOFA-OSLO-001',     'Xam nhat',   'Vai linen',        26500000, 29000000, 10),
(3,  3,  'SOFA-BAU-001',      'Xam dam',    'Vai bo',           32900000, 36000000,  8),
(4,  4,  'BAN-MARBLE-001',    'Trang',      'Da marble',        32500000, 38000000,  3),
(5,  5,  'BAN-SOI-001',       'Tu nhien',   'Go soi',           18900000, 22000000,  7),
(6,  6,  'GHE-DA-Y-001',      'Nau',        'Da cong nghiep',    4200000,  5000000, 20),
(7,  7,  'GHE-OC-CHO-001',    'Tu nhien',   'Go oc cho',        18900000, 22000000,  6),
(8,  8,  'GHE-ERGO-001',      'Den',        'Luoi & nhua',       6900000,  7900000, 15),
(9,  9,  'GHE-TEAK-001',      'Teak',       'Go teak',           8900000, 10000000,  0),
(10, 10, 'GIUONG-VEL-001',    'Xam',        'Ni velvet',        22900000, 26000000,  4),
(11, 11, 'GIUONG-SOI-001',    'Tu nhien',   'Go soi',           28500000, 32000000,  5),
(12, 12, 'TU-4C-001',         'Trang',      'Go MDF',           24500000, 28000000,  8),
(13, 13, 'KE-TIVI-001',       'Walnut',     'Go cong nghiep',    9800000, 11000000, 10),
(14, 14, 'KE-SACH-001',       'Tu nhien',   'Go thong',          7200000,  8500000, 12),
(15, 15, 'DEN-DONG-001',      'Vang',       'Dong thau',         7900000,  9500000,  8),
(16, 16, 'DEN-MAY-001',       'Tu nhien',   'May tu nhien',      3400000,  4000000, 15),
(17, 17, 'DEN-GOM-001',       'Trang nga',  'Gom',               1900000,  2500000,  0),
(18, 18, 'BAN-TRA-001',       'Trong suot', 'Kinh cuong luc',    5600000,  6500000, 10),
(19, 19, 'GUONG-VANG-001',    'Vang',       'Hop kim ma vang',   3100000,  3800000,  0);

-- ----------------------------------------------------------------
-- 5. PRODUCT IMAGES
-- ----------------------------------------------------------------
INSERT IGNORE INTO `product_images`
  (`id`, `product_id`, `variant_id`, `image_url`, `is_thumbnail`, `sort_order`)
VALUES
(1,  1,  1,  '/images/products/sofa-da-y-milano.jpg',              1, 0),
(2,  2,  2,  '/images/products/sofa-vai-linen-oslo.jpg',           1, 0),
(3,  3,  3,  '/images/products/sofa-goc-bac-au.jpg',               1, 0),
(4,  4,  4,  '/images/products/ban-an-da-marble-carrara.jpg',      1, 0),
(5,  5,  5,  '/images/products/ban-an-go-soi-nga.jpg',             1, 0),
(6,  6,  6,  '/images/products/ghe-an-da-boc-y.jpg',               1, 0),
(7,  7,  7,  '/images/products/ghe-thu-gian-go-oc-cho.jpg',        1, 0),
(8,  8,  8,  '/images/products/ghe-cong-thai-hoc-ergo.jpg',        1, 0),
(9,  9,  9,  '/images/products/ghe-ngoai-troi-go-teak.jpg',        1, 0),
(10, 10, 10, '/images/products/giuong-boc-ni-velvet.jpg',          1, 0),
(11, 11, 11, '/images/products/giuong-go-tu-nhien-scandinavian.jpg', 1, 0),
(12, 12, 12, '/images/products/tu-quan-ao-4-canh.jpg',             1, 0),
(13, 13, 13, '/images/products/ke-tivi-treo-tuong.jpg',            1, 0),
(14, 14, 14, '/images/products/ke-sach-go-thong.jpg',              1, 0),
(15, 15, 15, '/images/products/den-san-dong-thau.jpg',             1, 0),
(16, 16, 16, '/images/products/den-tha-tran-may.jpg',              1, 0),
(17, 17, 17, '/images/products/den-ban-gom.jpg',                   1, 0),
(18, 18, 18, '/images/products/ban-tra-mat-kinh.jpg',              1, 0),
(19, 19, 19, '/images/products/guong-trang-tri-vien-vang.jpg',     1, 0);

SET FOREIGN_KEY_CHECKS = 1;
-- DONE! 19 san pham da duoc insert thanh cong.
