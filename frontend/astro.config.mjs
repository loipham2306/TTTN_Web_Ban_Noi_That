// @ts-check
import { defineConfig } from 'astro/config';
import react from '@astrojs/react';
import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  integrations: [react()],

  server: {
    host: true, // Lắng nghe trên mọi interface mạng (0.0.0.0)
    port: 4321,
  },

  vite: {
    plugins: [tailwindcss()],
    server: {
      host: true,
      allowedHosts: true, // Cho phép truy cập qua devtunnels.ms và các domain forward port
    },
  },
});