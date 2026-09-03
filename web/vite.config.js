import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'node:path';

// data/components.json（リポジトリ直下の単一ソース）を web から参照するため、
// 親ディレクトリへのアクセスを許可し、@data エイリアスを張る。
export default defineConfig({
  base: './',
  plugins: [react()],
  resolve: {
    alias: { '@data': resolve(__dirname, '../data/components.json') },
  },
  server: {
    fs: { allow: [resolve(__dirname, '..')] },
  },
});
