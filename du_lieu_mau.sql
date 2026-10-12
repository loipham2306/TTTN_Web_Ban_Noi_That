-- ============================================================
-- DỮ LIỆU MẪU (SEED DATA) CHO WEBSITE BÁN NỘI THẤT
-- File: du_lieu_mau.sql
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

-- 1. NẠP TÀI KHOẢN MẪU (Mật khẩu mặc định: 123456)
-- Hash bcrypt tương ứng với '123456': $2y$10$wO3nCcmUuI9q0Y34Qh7FheGqI6f3a3j8UuK3hE/J3QxYy2e.8q7kK
INSERT INTO `users` (`id`, `role_id`, `email`, `password_hash`, `full_name`, `phone`, `status`, `created_at`) VALUES
(1, 1, 'admin@noithat.com', '$2y$10$wO3nCcmUuI9q0Y34Qh7FheGqI6f3a3j8UuK3hE/J3QxYy2e.8q7kK', 'Phạm Hữu Lợi (Admin)', '0901234567', 1, NOW()),
(2, 2, 'seller@noithat.com', '$2y$10$wO3nCcmUuI9q0Y34Qh7FheGqI6f3a3j8UuK3hE/J3QxYy2e.8q7kK', 'Nguyễn Văn Quản Lý Kho', '0912345678', 1, NOW()),
(3, 3, 'khachhang@gmail.com', '$2y$10$wO3nCcmUuI9q0Y34Qh7FheGqI6f3a3j8UuK3hE/J3QxYy2e.8q7kK', 'Trần Thị Mua Hàng', '0987654321', 1, NOW())
ON DUPLICATE KEY UPDATE `email` = VALUES(`email`);

-- 2. NẠP ĐỊA CHỈ NHẬN HÀNG MẪU CHO KHÁCH HÀNG
INSERT INTO `user_addresses` (`id`, `user_id`, `receiver_name`, `receiver_phone`, `province`, `district`, `ward`, `specific_address`, `is_default`) VALUES
(1, 3, 'Trần Thị Mua Hàng', '0987654321', 'Thành phố Hà Nội', 'Quận Cầu Giấy', 'Phường Dịch Vọng', 'Số 18, Ngõ 86 phố Trần Thái Tông', 1),
(2, 3, 'Trần Thị Mua Hàng (Văn phòng)', '0987654321', 'Thành phố Hồ Chí Minh', 'Quận 1', 'Phường Bến Nghé', 'Tầng 5, Tòa nhà Bitexco, số 2 Hải Triều', 0)
ON DUPLICATE KEY UPDATE `receiver_name` = VALUES(`receiver_name`);

-- 3. NẠP DANH MỤC NỘI THẤT (CÂY DANH MỤC ĐA CẤP)
-- Danh mục gốc (Cấp 1)
INSERT INTO `categories` (`id`, `parent_id`, `name`, `slug`, `image_url`, `status`) VALUES
(1, NULL, 'Phòng Khách', 'phong-khach', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500', 1),
(2, NULL, 'Phòng Ngủ', 'phong-ngu', 'https://images.unsplash.com/photo-1540518614846-7ede433c4ef0?w=500', 1),
(3, NULL, 'Phòng Bếp & Bàn Ăn', 'phong-bep-ban-an', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?w=500', 1),
(4, NULL, 'Phòng Làm Việc', 'phong-lam-viec', 'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?w=500', 1),
-- Danh mục con (Cấp 2)
(5, 1, 'Ghế Sofa', 'ghe-sofa', 'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=500', 1),
(6, 1, 'Bàn Trà & Kệ Tivi', 'ban-tra-ke-tivi', 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?w=500', 1),
(7, 2, 'Giường Ngủ', 'giuong-ngu', 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=500', 1),
(8, 2, 'Tủ Quần Áo', 'tu-quan-ao', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?w=500', 1),
(9, 3, 'Bàn Ghế Ăn', 'ban-ghe-an', 'https://images.unsplash.com/photo-1615066390971-03e4e1c36ddf?w=500', 1),
(10, 4, 'Bàn Ghế Làm Việc', 'ban-ghe-lam-viec', 'https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=500', 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- 4. NẠP SẢN PHẨM NỘI THẤT
INSERT INTO `products` (`id`, `category_id`, `name`, `slug`, `short_description`, `content`, `brand`, `view_count`, `status`) VALUES
(1, 5, 'Sofa Băng Da Bò Ý Scandinavian', 'sofa-bang-da-bo-y-scandinavian', 
 'Ghế sofa băng 3 chỗ ngồi đệm mút D40 êm ái, bọc da bò cao cấp phong cách Bắc Âu.', 
 'Sofa băng Scandinavian mang vẻ đẹp thanh lịch, khung gỗ thông đã qua tẩm sấy chống mối mọt. Nệm mút D40 nguyên khối giữ form dáng dài lâu.', 'Nordic Living', 128, 1),

(2, 6, 'Bàn Trà Tròn Đôi Mặt Đá Marble', 'ban-tra-tron-doi-mat-da-marble', 
 'Bộ bàn trà đôi thông minh lồng ghép, mặt đá phiến chống trầy chịu nhiệt, chân thép sơn tĩnh điện.', 
 'Thiết kế bàn lồng tiết kiệm không gian, phù hợp cho căn hộ chung cư hiện đại.', 'HomeDecor', 85, 1),

(3, 7, 'Giường Ngủ Gỗ Sồi Nga Tự Nhiên', 'giuong-ngu-go-soi-nga-tu-nhien', 
 'Giường ngủ 1m8x2m gỗ sồi tự nhiên chắc chắn, dát phản cao cấp.', 
 'Gỗ sồi nhập khẩu vân gỗ sáng màu, hoàn thiện phủ sơn PU bóng mờ cao cấp an toàn cho sức khỏe.', 'Mộc Việt', 240, 1),

(4, 9, 'Bộ Bàn Ăn Thông Minh Kéo Dài 6 Ghế', 'bo-ban-an-thong-minh-keo-dai-6-ghe', 
 'Bàn ăn mở rộng linh hoạt từ 1m2 lên 1m6 kèm 6 ghế Monet đệm da êm ái.', 
 'Cơ chế mở rộng cơ học mượt mà, khung hợp kim siêu chịu lực.', 'Kaza Home', 190, 1),

(5, 10, 'Bàn Làm Việc Nâng Hạ Công Thái Học Ergonomic', 'ban-lam-viec-nang-ha-cong-thai-hoc', 
 'Bàn làm việc thông minh 2 động cơ điện êm ái, ghi nhớ 4 vị trí chiều cao.', 
 'Hỗ trợ thay đổi tư thế đứng - ngồi làm việc linh hoạt, bảo vệ cột sống và tăng năng suất công việc.', 'ErgoLife', 310, 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- 5. NẠP BIẾN THỂ SẢN PHẨM (VARIANTS - Có Cân Nặng & Kích Thước để tính ship)
INSERT INTO `product_variants` (`id`, `product_id`, `sku`, `color`, `material`, `price`, `compare_at_price`, `stock_quantity`, `weight_gram`, `dimensions`) VALUES
-- Biến thể Sofa
(1, 1, 'SF-SCAN-BROWN', 'Nâu Bò', 'Da Bò Ý Cao Cấp', 14500000.00, 16000000.00, 10, 48000, '210 x 85 x 78 cm'),
(2, 1, 'SF-SCAN-GREY', 'Xám Khói', 'Vải Nỉ Thô Nhập Khẩu', 11900000.00, 13500000.00, 15, 42000, '210 x 85 x 78 cm'),

-- Biến thể Bàn Trà
(3, 2, 'BT-MARBLE-WHITE', 'Mặt Trắng Vân Mây', 'Đá Marble Ceramic', 3200000.00, 3800000.00, 20, 22000, 'Lớn 70x45cm - Nhỏ 50x40cm'),
(4, 2, 'BT-MARBLE-BLACK', 'Mặt Đen Tia Chớp', 'Đá Marble Ceramic', 3200000.00, 3800000.00, 12, 22000, 'Lớn 70x45cm - Nhỏ 50x40cm'),

-- Biến thể Giường Ngủ
(5, 3, 'GN-OAK-1820', 'Vàng Tự Nhiên', 'Gỗ Sồi Nga', 8900000.00, 10500000.00, 8, 75000, '180 x 200 x 95 cm'),
(6, 3, 'GN-OAK-1620', 'Vàng Tự Nhiên', 'Gỗ Sồi Nga', 7900000.00, 9200000.00, 12, 68000, '160 x 200 x 95 cm'),

-- Biến thể Bàn Ăn
(7, 4, 'BA-SMART-GREY', 'Ghi Xám', 'Mặt Đá Phiến + Chân Thép', 9500000.00, 11000000.00, 5, 55000, '120-160 x 80 x 75 cm'),

-- Biến thể Bàn Nâng Hạ
(8, 5, 'BLV-ERGO-WALNUT', 'Mặt Gỗ Óc Chó', 'Mặt Gỗ MDF + Khung Thép', 6800000.00, 7500000.00, 25, 32000, '140 x 70 x 72-118 cm'),
(9, 5, 'BLV-ERGO-WHITE', 'Mặt Trắng', 'Mặt Gỗ MDF + Khung Thép', 6500000.00, 7200000.00, 18, 32000, '140 x 70 x 72-118 cm')
ON DUPLICATE KEY UPDATE `sku` = VALUES(`sku`);

-- 6. NẠP HÌNH ẢNH SẢN PHẨM & BIẾN THỂ
INSERT INTO `product_images` (`id`, `product_id`, `variant_id`, `image_url`, `is_thumbnail`, `sort_order`) VALUES
(1, 1, 1, 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800', 1, 1),
(2, 1, 2, 'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=800', 0, 2),
(3, 2, 3, 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?w=800', 1, 1),
(4, 3, 5, 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=800', 1, 1),
(5, 4, 7, 'https://images.unsplash.com/photo-1615066390971-03e4e1c36ddf?w=800', 1, 1),
(6, 5, 8, 'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?w=800', 1, 1)
ON DUPLICATE KEY UPDATE `image_url` = VALUES(`image_url`);

-- 7. NẠP MÃ GIẢM GIÁ (COUPONS)
INSERT INTO `coupons` (`id`, `code`, `discount_type`, `discount_value`, `min_order_value`, `max_discount_amount`, `start_date`, `end_date`, `usage_limit`, `used_count`, `status`) VALUES
(1, 'NOITHAT2026', 'percent', 10.00, 2000000.00, 1000000.00, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 100, 5, 1),
(2, 'FREESHIP', 'fixed_amount', 100000.00, 3000000.00, 100000.00, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 200, 12, 1)
ON DUPLICATE KEY UPDATE `code` = VALUES(`code`);

SET FOREIGN_KEY_CHECKS = 1;
