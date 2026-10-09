# Website Thương Mại Điện Tử Nội Thất & Tư Vấn Phong Thủy AI

Hệ thống thương mại điện tử chuyên cung cấp nội thất cao cấp kết hợp tính năng tư vấn bài trí phong thủy theo bản mệnh ngũ hành, được phát triển trên kiến trúc **Monorepo** phân tách rõ ràng giữa **Frontend** và **Backend RESTful API**.

---

## 1. Công Nghệ Sử Dụng (Tech Stack)

| Tầng hệ thống | Công nghệ | Chi tiết triển khai |
| :--- | :--- | :--- |
| **Frontend** | Astro 5, React 19, Vite | Tối ưu hóa SEO, Static Site Generation (SSG), React Island Architecture |
| **Styling** | Tailwind CSS | Hệ màu sang trọng, tối giản (*walnut/sand/clay*), responsive đa thiết bị |
| **Backend** | Node.js, Express, TypeScript | RESTful API, kiểm soát kiểu dữ liệu chặt chẽ (Type-Safe) |
| **ORM & Database** | Prisma ORM, MySQL (XAMPP) | Quản lý quan hệ 17 bảng (3NF), Type-Safe Database Client |
| **AI Integration** | Google Gemini API / Heuristic AI | Tư vấn bản mệnh ngũ hành (Kim, Mộc, Thủy, Hỏa, Thổ) và hướng nhà |

---

## 2. Cấu Trúc Thư Mục Monorepo

```text
Website-Noi-That/
├── frontend/                     # Ứng dụng giao diện Astro + React + Tailwind
│   ├── public/                   # Tài nguyên tĩnh (ảnh, favicon, icons)
│   ├── src/
│   │   ├── components/           # Navbar, Footer, ProductCard, Modals
│   │   ├── data/                 # Dữ liệu sản phẩm mẫu (products.ts, product-details.ts)
│   │   ├── layouts/              # BaseLayout (Khách hàng), AdminLayout (Quản trị)
│   │   ├── pages/
│   │   │   ├── index.astro       # Trang chủ giới thiệu
│   │   │   ├── san-pham/         # Danh mục & Chi tiết sản phẩm
│   │   │   ├── gio-hang/         # Giỏ hàng mua sắm
│   │   │   ├── thanh-toan/       # Thanh toán COD & VietQR
│   │   │   ├── dang-ky/          # Đăng ký (đo độ mạnh mật khẩu)
│   │   │   ├── dang-nhap/        # Đăng nhập (Google 1-click)
│   │   │   ├── phong-thuy/       # Trợ lý AI tư vấn phong thủy
│   │   │   └── admin/            # Toàn diện 4 phân hệ Quản trị viên
│   │   ├── scripts/              # Xử lý giỏ hàng, xác thực form
│   │   └── styles/               # global.css, cấu hình Tailwind
│   └── package.json
│
├── backend/                      # Máy chủ API Node.js + Express + TypeScript
│   ├── prisma/
│   │   ├── schema.prisma         # Mô hình 17 bảng dữ liệu quan hệ
│   │   └── seed.ts               # Kịch bản nạp dữ liệu mẫu ban đầu
│   ├── src/
│   │   ├── config/               # Cấu hình biến môi trường, Prisma, Gemini
│   │   ├── routes/               # Bộ định tuyến API (auth, products, orders...)
│   │   ├── middlewares/          # Xử lý lỗi, CORS, kiểm soát truy cập
│   │   ├── app.ts                # Cấu hình Express app
│   │   └── server.ts             # Khởi chạy máy chủ HTTP (cổng 4000)
│   ├── .env.example              # Mẫu cấu hình môi trường
│   └── package.json
│
├── database/                     # Bản sao lưu Cơ sở dữ liệu
│   └── web_ban_noi_that.sql      # File SQL nhập dữ liệu trực tiếp vào phpMyAdmin
│
├── .gitignore                    # Bộ lọc file rác và biến môi trường
├── package.json                  # Quản lý script điều hành toàn bộ Monorepo
└── README.md                     # Tài liệu hướng dẫn dự án
```

---

## 3. Hướng Dẫn Cài Đặt & Khởi Chạy

### Yêu cầu hệ thống:
- **Node.js**: Phiên bản 18 trở lên.
- **XAMPP**: Đang bật module Apache và MySQL (cổng 3306).

### Bước 1: Cài đặt toàn bộ thư viện
Tại thư mục gốc của dự án, mở terminal và chạy:
```bash
npm run install:all
```

### Bước 2: Thiết lập Cơ sở dữ liệu MySQL
1. Mở **XAMPP Control Panel** và nhấn **Start** cho MySQL.
2. Truy cập **phpMyAdmin** tại `http://localhost/phpmyadmin`.
3. Tạo cơ sở dữ liệu mới với tên: `web_ban_noi_that` (bảng mã `utf8mb4_unicode_ci`).
4. Nhập (Import) tệp `database/web_ban_noi_that.sql` vào cơ sở dữ liệu vừa tạo.

*(Hoặc dùng lệnh nạp dữ liệu tự động bằng Prisma):*
```bash
cd backend
npm run prisma:seed
```

### Bước 3: Khởi chạy dự án
Tại thư mục gốc, chạy lệnh để bật ứng dụng:
```bash
npm run dev
```
- **Giao diện Website**: `http://localhost:4321`
- **Bảng Quản Trị Admin**: `http://localhost:4321/admin`
- **Máy chủ Backend API**: `http://localhost:4000`

---

## 4. Các Phân Hệ Chính Của Hệ Thống

### A. Phía Khách Hàng (Storefront):
- **Trang chủ & Danh mục**: Bộ sưu tập nội thất phân chia theo không gian (Phòng khách, Phòng ăn, Phòng ngủ, Decor).
- **Chi tiết sản phẩm**: Kích thước, chất liệu, bảo hành, màu sắc biến thể.
- **Giỏ hàng thông minh**: Quản lý số lượng, lưu trữ Client-side chống spam CSDL.
- **Thanh toán & Vận chuyển**: Hỗ trợ giao tiêu chuẩn và hỏa tốc 2H, thanh toán COD hoặc mã QR ngân hàng.
- **Đăng ký & Đăng nhập**: Đo độ mạnh mật khẩu (Yếu / Trung bình / Mạnh), hỗ trợ đăng nhập 1-click qua Gmail.
- **Tư vấn Phong Thủy AI**: Tra cứu ngũ hành, hướng đặt nội thất hợp tuổi gia chủ.

### B. Phía Quản Trị Viên (Admin Dashboard):
- **Tổng quan**: Báo cáo KPI, biểu đồ doanh thu tuần, cơ cấu danh mục.
- **Quản lý**: CRUD Sản phẩm (kèm tải ảnh), Đơn hàng & vận chuyển, Danh mục, Khách hàng, Nhân viên, Lịch sử Phong Thủy.
- **Tiếp thị**: Mã giảm giá, Đánh giá sản phẩm, Chiến dịch Email & Thông báo, Báo cáo tài chính.
- **Hệ thống**: Cấu hình showroom, chính sách giao hàng, kiểm tra kết nối MySQL.

---

## 5. Giấy Phép & Bản Quyền
Dự án được xây dựng phục vụ mục đích nghiên cứu, học tập và triển khai đồ án thực tập chuyên ngành Công nghệ Phần mềm.
