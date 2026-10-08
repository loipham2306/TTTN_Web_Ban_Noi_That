# Nội Thất — Website Bán Nội Thất (Monorepo)

Website thương mại điện tử nội thất kết hợp trợ lý tư vấn phong thủy theo cung mệnh, xây dựng trên kiến trúc Monorepo phân tách **Frontend** và **Backend**.

---

## 1. Công nghệ sử dụng (Tech Stack)

| Tầng | Công nghệ | Chi tiết |
| :--- | :--- | :--- |
| **Frontend** | Astro 7, React 19, Vite | Tối ưu SEO, tốc độ hiển thị, component React tương tác |
| **Styling** | Tailwind CSS v4 | Thiết kế tối giản, sang trọng (walnut/sand/clay), responsive |
| **Backend** | Node.js, Express.js (TypeScript) | RESTful API, cấu trúc controllers/services/routes rõ ràng |
| **ORM & Database** | Prisma ORM, MySQL | Quản lý dữ liệu quan hệ, type-safe query |
| **AI Integration** | Google Gemini API | Tư vấn phong thủy bài trí nội thất |

---

## 2. Cấu trúc thư mục

```text
noi-that/
├── frontend/                   # Ứng dụng giao diện Astro + React + Tailwind
│   ├── public/                 # Ảnh, favicon, tài nguyên tĩnh
│   ├── src/
│   │   ├── components/         # Header, Footer, ProductCard (Astro & React)
│   │   ├── data/               # Nguồn dữ liệu mẫu (products.ts, product-details.ts)
│   │   ├── layouts/            # BaseLayout, AdminLayout
│   │   ├── pages/              # Các route website (/san-pham, /gio-hang, /thanh-toan, /phong-thuy, /admin)
│   │   ├── scripts/            # cart.ts, validate.ts, phong-thuy.ts
│   │   ├── services/           # api.ts (hàm gọi backend API)
│   │   ├── styles/             # global.css (Tailwind design tokens)
│   │   └── types/              # Định nghĩa interface TypeScript dùng chung
│   ├── astro.config.mjs
│   ├── tsconfig.json
│   ├── .env.example
│   └── package.json
│
├── backend/                    # Máy chủ RESTful API Express + TypeScript
│   ├── prisma/
│   │   ├── schema.prisma       # Cấu hình kết nối MySQL và Prisma model
│   │   └── seed.ts             # Script nạp dữ liệu ban đầu
│   ├── src/
│   │   ├── config/             # env.ts, prisma.ts, gemini.ts
│   │   ├── controllers/        # Điều hướng xử lý logic nghiệp vụ
│   │   ├── middlewares/        # Xử lý lỗi, 404, CORS
│   │   ├── routes/             # Định tuyến API (/api/health, products, orders...)
│   │   ├── services/           # Xử lý nghiệp vụ chính
│   │   ├── types/              # Kiểu dữ liệu phía backend
│   │   ├── app.ts              # Khởi tạo Express app
│   │   └── server.ts           # Điểm khởi chạy máy chủ
│   ├── .env.example
│   ├── tsconfig.json
│   └── package.json
│
├── database/                   # Cơ sở dữ liệu
│   └── web_ban_noi_that.sql    # File script SQL tạo bảng và nạp dữ liệu
│
├── .gitignore
├── package.json                # Scripts tiện ích chạy từ thư mục gốc
├── AGENTS.md
├── CLAUDE.md
└── README.md
```

---

## 3. Hướng dẫn cài đặt & Chạy dự án

### Yêu cầu môi trường
- **Node.js**: `>= 22.12.0`
- **npm**
- **MySQL Server** (XAMPP, MySQL Workbench, hoặc Docker)

### Bước 1: Khởi tạo Cơ sở dữ liệu
1. Mở MySQL client (phpMyAdmin hoặc MySQL Workbench).
2. Tạo cơ sở dữ liệu mới (ví dụ: `noi_that_db`).
3. Import file `database/web_ban_noi_that.sql` vào cơ sở dữ liệu vừa tạo.

### Bước 2: Cài đặt thư viện
Tại thư mục gốc của dự án, chạy:
```sh
npm run install:all
```

### Bước 3: Cấu hình biến môi trường
- Tại `backend/`: Copy `.env.example` thành `.env` và cập nhật thông tin:
  ```env
  PORT=4000
  CORS_ORIGIN=http://localhost:4321
  DATABASE_URL="mysql://root:password@localhost:3306/noi_that_db"
  GEMINI_API_KEY="khoa_gemini_cua_ban"
  ```
- Tại `frontend/`: Copy `.env.example` thành `.env`:
  ```env
  PUBLIC_API_URL=http://localhost:4000/api
  ```

### Bước 4: Khởi chạy dự án

Từ thư mục gốc:
- **Chạy Backend**:
  ```sh
  npm run dev:be
  # Backend chạy tại: http://localhost:4000
  # Kiểm tra sức khỏe: http://localhost:4000/api/health
  ```
- **Chạy Frontend**:
  ```sh
  npm run dev:fe
  # Frontend chạy tại: http://localhost:4321
  ```
