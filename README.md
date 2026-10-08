# Ná»™i Tháº¥t â€” Website BÃ¡n Ná»™i Tháº¥t (Monorepo)

Website thÆ°Æ¡ng máº¡i Ä‘iá»‡n tá»­ ná»™i tháº¥t káº¿t há»£p trá»£ lÃ½ tÆ° váº¥n phong thá»§y theo cung má»‡nh, xÃ¢y dá»±ng trÃªn kiáº¿n trÃºc Monorepo phÃ¢n tÃ¡ch **Frontend** vÃ  **Backend**.

---

## 1. CÃ´ng nghá»‡ sá»­ dá»¥ng (Tech Stack)

| Táº§ng | CÃ´ng nghá»‡ | Chi tiáº¿t |
| :--- | :--- | :--- |
| **Frontend** | Astro 7, React 19, Vite | Tá»‘i Æ°u SEO, tá»‘c Ä‘á»™ hiá»ƒn thá»‹, component React tÆ°Æ¡ng tÃ¡c |
| **Styling** | Tailwind CSS v4 | Thiáº¿t káº¿ tá»‘i giáº£n, sang trá»ng (walnut/sand/clay), responsive |
| **Backend** | Node.js, Express.js (TypeScript) | RESTful API, cáº¥u trÃºc controllers/services/routes rÃµ rÃ ng |
| **ORM & Database**| Prisma ORM, MySQL | Quáº£n lÃ½ dá»¯ liá»‡u quan há»‡, type-safe query |
| **AI Integration** | Google Gemini API | TÆ° váº¥n phong thá»§y bÃ i trÃ­ ná»™i tháº¥t |

---

## 2. Cáº¥u trÃºc thÆ° má»¥c

```text
noi-that/
â”œâ”€â”€ frontend/                   # á»¨ng dá»¥ng giao diá»‡n Astro + React + Tailwind
â”‚   â”œâ”€â”€ public/                 # áº¢nh, favicon, tÃ i nguyÃªn tÄ©nh
â”‚   â”œâ”€â”€ src/
â”‚   â”‚   â”œâ”€â”€ components/         # Header, Footer, ProductCard (Astro & React)
â”‚   â”‚   â”œâ”€â”€ data/               # Nguá»“n dá»¯ liá»‡u máº«u (products.ts, product-details.ts)
â”‚   â”‚   â”œâ”€â”€ layouts/            # BaseLayout, AdminLayout
â”‚   â”‚   â”œâ”€â”€ pages/              # CÃ¡c route website (/san-pham, /gio-hang, /thanh-toan, /phong-thuy, /admin)
â”‚   â”‚   â”œâ”€â”€ scripts/            # cart.ts, validate.ts, phong-thuy.ts
â”‚   â”‚   â”œâ”€â”€ services/           # api.ts (hÃ m gá»i backend API)
â”‚   â”‚   â”œâ”€â”€ styles/             # global.css (Tailwind design tokens)
â”‚   â”‚   â””â”€â”€ types/              # Äá»‹nh nghÄ©a interface TypeScript dÃ¹ng chung
â”‚   â”œâ”€â”€ astro.config.mjs
â”‚   â”œâ”€â”€ tsconfig.json
â”‚   â”œâ”€â”€ .env.example
â”‚   â””â”€â”€ package.json
â”‚
â”œâ”€â”€ backend/                    # MÃ¡y chá»§ RESTful API Express + TypeScript
â”‚   â”œâ”€â”€ prisma/
â”‚   â”‚   â”œâ”€â”€ schema.prisma       # Cáº¥u hÃ¬nh káº¿t ná»‘i MySQL vÃ  Prisma model
â”‚   â”‚   â””â”€â”€ seed.ts             # Script náº¡p dá»¯ liá»‡u ban Ä‘áº§u
â”‚   â”œâ”€â”€ src/
â”‚   â”‚   â”œâ”€â”€ config/             # env.ts, prisma.ts, gemini.ts
â”‚   â”‚   â”œâ”€â”€ controllers/        # Äiá»u hÆ°á»›ng xá»­ lÃ½ logic nghiá»‡p vá»¥
â”‚   â”‚   â”œâ”€â”€ middlewares/        # Xá»­ lÃ½ lá»—i, 404, CORS
â”‚   â”‚   â”œâ”€â”€ routes/             # Äá»‹nh tuyáº¿n API (/api/health, products, orders...)
â”‚   â”‚   â”œâ”€â”€ services/           # Xá»­ lÃ½ nghiá»‡p vá»¥ chÃ­nh
â”‚   â”‚   â”œâ”€â”€ types/              # Kiá»ƒu dá»¯ liá»‡u phÃ­a backend
â”‚   â”‚   â”œâ”€â”€ app.ts              # Khá»Ÿi táº¡o Express app
â”‚   â”‚   â””â”€â”€ server.ts           # Äiá»ƒm khá»Ÿi cháº¡y mÃ¡y chá»§
â”‚   â”œâ”€â”€ .env.example
â”‚   â”œâ”€â”€ tsconfig.json
â”‚   â””â”€â”€ package.json
â”‚
â”œâ”€â”€ database/                   # CÆ¡ sá»Ÿ dá»¯ liá»‡u
â”‚   â””â”€â”€ web_ban_noi_that.sql    # File script SQL táº¡o báº£ng vÃ  náº¡p dá»¯ liá»‡u
â”‚
â”œâ”€â”€ .gitignore
â”œâ”€â”€ package.json                # Scripts tiá»‡n Ã­ch cháº¡y tá»« thÆ° má»¥c gá»‘c
â”œâ”€â”€ AGENTS.md
â”œâ”€â”€ CLAUDE.md
â””â”€â”€ README.md
```

---

## 3. HÆ°á»›ng dáº«n cÃ i Ä‘áº·t & Cháº¡y dá»± Ã¡n

### YÃªu cáº§u mÃ´i trÆ°á»ng
- **Node.js**: `>= 22.12.0`
- **npm**
- **MySQL Server** (XAMPP, MySQL Workbench, hoáº·c Docker)

### BÆ°á»›c 1: Khá»Ÿi táº¡o CÆ¡ sá»Ÿ dá»¯ liá»‡u
1. Má»Ÿ MySQL client (phpMyAdmin hoáº·c MySQL Workbench).
2. Táº¡o cÆ¡ sá»Ÿ dá»¯ liá»‡u má»›i (vÃ­ dá»¥: `noi_that_db`).
3. Import file `database/web_ban_noi_that.sql` vÃ o cÆ¡ sá»Ÿ dá»¯ liá»‡u vá»«a táº¡o.

### BÆ°á»›c 2: CÃ i Ä‘áº·t thÆ° viá»‡n
Táº¡i thÆ° má»¥c gá»‘c cá»§a dá»± Ã¡n, cháº¡y:
```sh
npm run install:all
```
*(Hoáº·c cháº¡y `npm install` riÃªng trong tá»«ng thÆ° má»¥c `frontend` vÃ  `backend`)*

### BÆ°á»›c 3: Cáº¥u hÃ¬nh biáº¿n mÃ´i trÆ°á»ng
- Táº¡i `backend/`: Copy `.env.example` thÃ nh `.env` vÃ  cáº­p nháº­t thÃ´ng tin:
  ```env
  PORT=4000
  CORS_ORIGIN=http://localhost:4321
  DATABASE_URL="mysql://root:password@localhost:3306/noi_that_db"
  GEMINI_API_KEY="khoa_gemini_cua_ban"
  ```
- Táº¡i `frontend/`: Copy `.env.example` thÃ nh `.env`:
  ```env
  PUBLIC_API_URL=http://localhost:4000/api
  ```

### BÆ°á»›c 4: Khá»Ÿi cháº¡y dá»± Ã¡n

Tá»« thÆ° má»¥c gá»‘c:
- **Cháº¡y Backend**:
  ```sh
  npm run dev:be
  # Backend cháº¡y táº¡i: http://localhost:4000
  # Kiá»ƒm tra sá»©c khá»e: http://localhost:4000/api/health
  ```
- **Cháº¡y Frontend**:
  ```sh
  npm run dev:fe
  # Frontend cháº¡y táº¡i: http://localhost:4321
  ```