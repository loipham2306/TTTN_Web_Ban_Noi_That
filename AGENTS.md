# Development Guide

Dá»± Ã¡n Ä‘Æ°á»£c tá»• chá»©c theo cáº¥u trÃºc monorepo: `frontend/`, `backend/`, `database/`.

## Development Commands

- **Cháº¡y cáº£ 2 tá»« gá»‘c**:
  - Frontend: `npm run dev:fe` (cá»•ng 4321)
  - Backend: `npm run dev:be` (cá»•ng 4000)

- **Frontend (Astro + React)**:
  - `cd frontend`
  - Cháº¡y dev server: `npm run dev` hoáº·c cháº¿ Ä‘á»™ ná»n `npx astro dev --background`
  - Quáº£n lÃ½ dev ná»n: `npx astro dev stop`, `npx astro dev status`, `npx astro dev logs`
  - Build: `npm run build`

- **Backend (Express + TypeScript + Prisma)**:
  - `cd backend`
  - Cháº¡y dev server: `npm run dev`
  - Build: `npm run build`
  - Sinh client Prisma: `npm run prisma:generate`

## Documentation

- Astro Docs: https://docs.astro.build
  - [Adding pages, dynamic routes, or middleware](https://docs.astro.build/en/guides/routing/)
  - [Working with Astro components](https://docs.astro.build/en/basics/astro-components/)
  - [Using React components](https://docs.astro.build/en/guides/framework-components/)
  - [Adding styles or using Tailwind](https://docs.astro.build/en/guides/styling/)
- Express Docs: https://expressjs.com/
- Prisma Docs: https://www.prisma.io/docs/