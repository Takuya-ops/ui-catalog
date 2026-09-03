import { useEffect, useState, useCallback } from 'react';

/** 依存を増やさないハッシュルーター。#/c/:cat, #/u/:id, #/search?q= を扱う */
export function parseHash(hash = window.location.hash) {
  const raw = hash.replace(/^#/, '') || '/';
  const [path, queryString] = raw.split('?');
  const query = Object.fromEntries(new URLSearchParams(queryString ?? ''));
  const parts = path.split('/').filter(Boolean);
  if (parts.length === 0) return { name: 'home', query };
  if (parts[0] === 'c' && parts[1]) return { name: 'category', categoryId: parts[1], query };
  if (parts[0] === 'u' && parts[1]) return { name: 'component', componentId: parts[1], query };
  if (parts[0] === 'search') return { name: 'search', query };
  if (parts[0] === 'all') return { name: 'all', query };
  if (parts[0] === 'about') return { name: 'about', query };
  return { name: 'notfound', query };
}

export function useRoute() {
  const [route, setRoute] = useState(() => parseHash());
  useEffect(() => {
    const onChange = () => setRoute(parseHash());
    window.addEventListener('hashchange', onChange);
    return () => window.removeEventListener('hashchange', onChange);
  }, []);
  return route;
}

export function navigate(to) {
  if (window.location.hash === '#' + to) return;
  window.location.hash = to;
}

export function useScrollTopOnRouteChange(key) {
  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'instant' in window ? 'instant' : 'auto' });
  }, [key]);
}

export function useTheme() {
  const [theme, setTheme] = useState(() => {
    try {
      return localStorage.getItem('ui-catalog-theme') ?? 'system';
    } catch {
      return 'system';
    }
  });
  useEffect(() => {
    const root = document.documentElement;
    if (theme === 'system') root.removeAttribute('data-theme');
    else root.setAttribute('data-theme', theme);
    try {
      if (theme === 'system') localStorage.removeItem('ui-catalog-theme');
      else localStorage.setItem('ui-catalog-theme', theme);
    } catch {}
  }, [theme]);
  const cycle = useCallback(() => {
    setTheme((t) => (t === 'system' ? 'light' : t === 'light' ? 'dark' : 'system'));
  }, []);
  return { theme, setTheme, cycle };
}
