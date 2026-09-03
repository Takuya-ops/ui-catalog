import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { categories, categoryById, componentsOf, meta } from './catalog.js';
import { navigate, useRoute, useScrollTopOnRouteChange, useTheme } from './router.js';
import HomePage from './pages/HomePage.jsx';
import CategoryPage from './pages/CategoryPage.jsx';
import ComponentPage from './pages/ComponentPage.jsx';
import AllPage from './pages/AllPage.jsx';
import AboutPage from './pages/AboutPage.jsx';
import SearchOverlay from './components/SearchOverlay.jsx';
import {
  IconAuto, IconClose, IconGrid, IconHome, IconMenu, IconMoon, IconSearch, IconSun, IconBook,
} from './components/Icons.jsx';

export default function App() {
  const route = useRoute();
  const [drawerOpen, setDrawerOpen] = useState(false);
  const [searchOpen, setSearchOpen] = useState(false);
  const { theme, cycle } = useTheme();
  const menuBtnRef = useRef(null);

  useScrollTopOnRouteChange(JSON.stringify(route));
  useEffect(() => setDrawerOpen(false), [JSON.stringify(route)]);

  // コマンドパレット（⌘K / Ctrl+K）— navigation/command-palette の実演も兼ねる
  useEffect(() => {
    const onKey = (e) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'k') {
        e.preventDefault();
        setSearchOpen((v) => !v);
      }
      if (e.key === '/' && !/^(INPUT|TEXTAREA)$/.test(document.activeElement?.tagName ?? '')) {
        e.preventDefault();
        setSearchOpen(true);
      }
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, []);

  useEffect(() => {
    document.body.style.overflow = drawerOpen || searchOpen ? 'hidden' : '';
    return () => { document.body.style.overflow = ''; };
  }, [drawerOpen, searchOpen]);

  const activeCategoryId = useMemo(() => {
    if (route.name === 'category') return route.categoryId;
    if (route.name === 'component') {
      const list = categories.find((cat) => componentsOf(cat.id).some((c) => c.id === route.componentId));
      return list?.id;
    }
    return null;
  }, [route]);

  const closeDrawer = useCallback(() => {
    setDrawerOpen(false);
    menuBtnRef.current?.focus();
  }, []);

  const ThemeIcon = theme === 'light' ? IconSun : theme === 'dark' ? IconMoon : IconAuto;
  const themeLabel = theme === 'light' ? 'ライト' : theme === 'dark' ? 'ダーク' : 'システム連動';

  return (
    <div className="app">
      <header className="header">
        <button
          ref={menuBtnRef}
          className="iconbtn"
          style={{ display: 'var(--menu-display, grid)' }}
          onClick={() => setDrawerOpen(true)}
          aria-label="カテゴリメニューを開く"
          aria-expanded={drawerOpen}
          aria-controls="mobile-drawer"
          data-mobile-only="true"
        >
          <IconMenu />
        </button>

        <a className="header__brand" href="#/">
          <span className="header__logo" aria-hidden="true">UI</span>
          <span>UI Catalog</span>
        </a>

        <div className="header__spacer" />

        <button className="header__search" onClick={() => setSearchOpen(true)} aria-label="コンポーネントを検索">
          <IconSearch size={16} />
          <span className="header__search-label">検索…</span>
          <span className="header__spacer" />
          <kbd className="header__search-label">⌘K</kbd>
        </button>

        <button className="iconbtn" onClick={cycle} aria-label={`表示テーマ: ${themeLabel}（クリックで切替）`} title={`テーマ: ${themeLabel}`}>
          <ThemeIcon />
        </button>
      </header>

      <div className="layout">
        <Sidebar activeCategoryId={activeCategoryId} route={route} />

        <main className="main" id="main">
          {route.name === 'home' && <HomePage />}
          {route.name === 'category' && <CategoryPage categoryId={route.categoryId} />}
          {route.name === 'component' && <ComponentPage componentId={route.componentId} />}
          {route.name === 'all' && <AllPage />}
          {route.name === 'about' && <AboutPage />}
          {route.name === 'search' && <SearchRedirect onOpen={() => setSearchOpen(true)} />}
          {route.name === 'notfound' && <NotFound />}
        </main>
      </div>

      <nav className="bottomnav" aria-label="メインナビゲーション">
        <a className="bottomnav__item" href="#/" aria-current={route.name === 'home' ? 'page' : undefined}>
          <IconHome /><span>ホーム</span>
        </a>
        <a className="bottomnav__item" href="#/all" aria-current={route.name === 'all' ? 'page' : undefined}>
          <IconGrid /><span>一覧</span>
        </a>
        <button className="bottomnav__item" onClick={() => setSearchOpen(true)}>
          <IconSearch /><span>検索</span>
        </button>
        <a className="bottomnav__item" href="#/about" aria-current={route.name === 'about' ? 'page' : undefined}>
          <IconBook /><span>使い方</span>
        </a>
      </nav>

      {drawerOpen && (
        <>
          <div className="drawer-backdrop" onClick={closeDrawer} />
          <FocusTrap onEscape={closeDrawer}>
            <div className="drawer" id="mobile-drawer" role="dialog" aria-modal="true" aria-label="カテゴリ">
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '0 6px 8px' }}>
                <strong style={{ fontSize: 14 }}>カテゴリ</strong>
                <button className="iconbtn" onClick={closeDrawer} aria-label="メニューを閉じる"><IconClose /></button>
              </div>
              <SidebarLinks activeCategoryId={activeCategoryId} route={route} onNavigate={closeDrawer} />
            </div>
          </FocusTrap>
        </>
      )}

      {searchOpen && <SearchOverlay onClose={() => setSearchOpen(false)} />}

      <style>{`
        @media (min-width: 901px) { [data-mobile-only='true'] { display: none !important; } }
      `}</style>
    </div>
  );
}

function Sidebar({ activeCategoryId, route }) {
  return (
    <aside className="sidebar">
      <SidebarLinks activeCategoryId={activeCategoryId} route={route} />
    </aside>
  );
}

function SidebarLinks({ activeCategoryId, route, onNavigate }) {
  return (
    <nav aria-label="カテゴリ">
      <div className="sidebar__title">はじめに</div>
      <a className="sidebar__link" href="#/" aria-current={route.name === 'home' ? 'page' : undefined} onClick={onNavigate}>
        <span aria-hidden="true">🏠</span> ホーム
      </a>
      <a className="sidebar__link" href="#/all" aria-current={route.name === 'all' ? 'page' : undefined} onClick={onNavigate}>
        <span aria-hidden="true">🗂️</span> 全コンポーネント
      </a>
      <a className="sidebar__link" href="#/about" aria-current={route.name === 'about' ? 'page' : undefined} onClick={onNavigate}>
        <span aria-hidden="true">📖</span> このアプリの使い方
      </a>

      <div className="sidebar__title" style={{ marginTop: 14 }}>カテゴリ</div>
      {categories.map((cat) => (
        <a
          key={cat.id}
          className="sidebar__link"
          href={`#/c/${cat.id}`}
          aria-current={activeCategoryId === cat.id ? 'page' : undefined}
          onClick={onNavigate}
        >
          <span aria-hidden="true">{cat.emoji}</span>
          <span>{cat.name}</span>
          <span className="sidebar__count">{componentsOf(cat.id).length}</span>
        </a>
      ))}
    </nav>
  );
}

/** ドロワー/モーダル用の簡易フォーカストラップ（overlay 系のお手本実装） */
export function FocusTrap({ children, onEscape }) {
  const ref = useRef(null);
  useEffect(() => {
    const node = ref.current;
    if (!node) return;
    const prev = document.activeElement;
    const focusables = () =>
      [...node.querySelectorAll('a[href], button:not([disabled]), input, select, textarea, [tabindex]:not([tabindex="-1"])')]
        .filter((el) => el.offsetParent !== null);
    focusables()[0]?.focus();
    const onKey = (e) => {
      if (e.key === 'Escape') { e.stopPropagation(); onEscape?.(); return; }
      if (e.key !== 'Tab') return;
      const list = focusables();
      if (list.length === 0) return;
      const first = list[0];
      const last = list[list.length - 1];
      if (e.shiftKey && document.activeElement === first) { e.preventDefault(); last.focus(); }
      else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first.focus(); }
    };
    node.addEventListener('keydown', onKey);
    return () => {
      node.removeEventListener('keydown', onKey);
      if (prev instanceof HTMLElement) prev.focus();
    };
  }, [onEscape]);
  return <div ref={ref}>{children}</div>;
}

function SearchRedirect({ onOpen }) {
  useEffect(() => { onOpen(); navigate('/'); }, [onOpen]);
  return null;
}

function NotFound() {
  return (
    <div style={{ textAlign: 'center', padding: '60px 12px' }}>
      <div style={{ fontSize: 40 }} aria-hidden="true">🧭</div>
      <h1 className="page-title" style={{ marginTop: 10 }}>ページが見つかりません</h1>
      <p className="page-lead">URLが変わったか、削除された可能性があります。</p>
      <p style={{ marginTop: 16 }}><a className="btn" href="#/">ホームへ戻る</a></p>
    </div>
  );
}

export { categoryById, meta };
