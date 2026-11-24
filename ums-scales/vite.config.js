import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'node:path';

export default defineConfig({
  base: './',
  plugins: [react()],
  build: {
    rollupOptions: {
      input: {
        main: resolve(import.meta.dirname, 'index.html'),
        sequenceEmbed: resolve(import.meta.dirname, 'demo/sequence-embed.html'),
        embed: resolve(import.meta.dirname, 'demo/embed.html'),
        independent: resolve(import.meta.dirname, 'demo/asset.html')
      }
    }
  }
});
