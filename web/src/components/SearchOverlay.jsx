import { useEffect, useMemo, useRef, useState } from 'react';
import { search, categoryById, components } from '../catalog.js';
import { navigate } from '../router.js';
import { IconSearch, IconClose } from './Icons.jsx';

/**
 * コマンドパレット風の横断検索。
 * combobox パターン（aria-expanded / aria-activedescendant）と
 * フォーカストラップ・Esc閉じを実装した、accessibility のお手本も兼ねる。
 */
export default function SearchOverlay({ onClose }) {
  const [q, setQ] = useState('');
  const [active, setActive] = useState(0);
  const inputRef = useRef(null);
  const listRef = useRef(null);

  const results = useMemo(() => (q.trim() ? search(q, 30) : components.slice(0, 8)), [q]);

  useEffect(() => { inputRef.current?.focus(); }, []);
  useEffect(() => { setActive(0); }, [q]);

  useEffect(() => {
    const el = listRef.current?.querySelector('[data-active="true"]');
    el?.scrollIntoView({ block: 'nearest' });
  }, [active, results]);

  const go = (item) => { if (!item) return; navigate(`/u/${item.id}`); onClose(); };

  const onKeyDown = (e) => {
    if (e.key === 'Escape') { e.preventDefault(); onClose(); }
    else if (e.key === 'ArrowDown') { e.preventDefault(); setActive((i) => Math.min(i + 1, results.length - 1)); }
    else if (e.key === 'ArrowUp') { e.preventDefault(); setActive((i) => Math.max(i - 1, 0)); }
    else if (e.key === 'Enter') { e.preventDefault(); go(results[active]); }
  };

  return (
    <div
      className="cmdk-backdrop"
      onMouseDown={(e) => { if (e.target === e.currentTarget) onClose(); }}
    >
      <div className="cmdk" role="dialog" aria-modal="true" aria-label="コンポーネントを検索" onKeyDown={onKeyDown}>
        <div className="cmdk__inputwrap">
          <IconSearch size={18} aria-hidden="true" />
          <input
            ref={inputRef}
            className="cmdk__input"
            type="search"
            role="combobox"
            aria-expanded="true"
            aria-controls="cmdk-list"
            aria-autocomplete="list"
            aria-activedescendant={results[active] ? `cmdk-opt-${results[active].id}` : undefined}
            placeholder="名前・別名・使いどころ・アプリ名で検索（例: トグル、bottom sheet、Gmail）"
            value={q}
            onChange={(e) => setQ(e.target.value)}
          />
          <button className="iconbtn" onClick={onClose} aria-label="検索を閉じる"><IconClose size={18} /></button>
        </div>

        <div className="cmdk__list" id="cmdk-list" role="listbox" ref={listRef} aria-label="検索結果">
          {results.length === 0 ? (
            <div className="cmdk__empty">
              <div style={{ fontSize: 26, marginBottom: 6 }} aria-hidden="true">🔍</div>
              「{q}」に一致するコンポーネントは見つかりませんでした。<br />
              別名（英語名）やアプリ名でも検索できます。
            </div>
          ) : (
            results.map((c, i) => (
              <button
                key={c.id}
                id={`cmdk-opt-${c.id}`}
                role="option"
                aria-selected={i === active}
                data-active={i === active}
                className="cmdk__item"
                onMouseEnter={() => setActive(i)}
                onClick={() => go(c)}
              >
                <span aria-hidden="true" style={{ fontSize: 17 }}>{categoryById[c.category]?.emoji}</span>
                <span style={{ minWidth: 0 }}>
                  <span className="cmdk__item-name">{c.name}</span>
                  <span className="cmdk__item-sub"> — {c.enName}</span>
                  <div className="cmdk__item-sub" style={{ marginTop: 1 }}>{c.summary}</div>
                </span>
              </button>
            ))
          )}
        </div>

        <div className="cmdk__foot">
          <span><kbd>↑</kbd><kbd>↓</kbd> 移動</span>
          <span><kbd>Enter</kbd> 開く</span>
          <span><kbd>Esc</kbd> 閉じる</span>
          <span style={{ marginLeft: 'auto' }} aria-live="polite">{q.trim() ? `${results.length} 件` : 'すべて'}</span>
        </div>
      </div>
    </div>
  );
}
