# Development Guide

Dự án được tổ chức theo cấu trúc monorepo: `frontend/`, `backend/`, `database/`.

## Development Commands

- **Chạy cả 2 từ gốc**:
  - Frontend: `npm run dev:fe` (cổng 4321)
  - Backend: `npm run dev:be` (cổng 4000)

- **Frontend (Astro + React)**:
  - `cd frontend`
  - Chạy dev server: `npm run dev` hoặc chế độ nền `npx astro dev --background`
  - Quản lý dev nền: `npx astro dev stop`, `npx astro dev status`, `npx astro dev logs`
  - Build: `npm run build`

- **Backend (Express + TypeScript + Prisma)**:
  - `cd backend`
  - Chạy dev server: `npm run dev`
  - Build: `npm run build`
  - Sinh client Prisma: `npm run prisma:generate`

## Documentation

- Astro Docs: https://docs.astro.build
- Express Docs: https://expressjs.com/
- Prisma Docs: https://www.prisma.io/docs/
