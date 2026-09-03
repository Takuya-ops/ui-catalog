import { useMemo, useState } from 'react';
import { categories, categoryById, components } from '../catalog.js';
import { IconChevronRight, IconSearch } from '../components/Icons.jsx';

/** 全コンポーネント一覧。チップによる絞り込み（search-and-filter パターンの実演） */
export default function AllPage() {
  const [activeCats, setActiveCats] = useState([]);
  const [q, setQ] = useState('');

  const filtered = useMemo(() => {
    const query = q.trim().toLowerCase();
    return components.filter((c) => {
      if (activeCats.length && !activeCats.includes(c.category)) return false;
      if (!query) return true;
      const hay = [c.name, c.enName, c.summary, ...(c.aliases ?? []), ...(c.keywords ?? [])].join(' ').toLowerCase();
      return hay.includes(query);
    });
  }, [activeCats, q]);

  const toggleCat = (id) =>
    setActiveCats((prev) => (prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]));

  return (
    <div>
      <ol className="breadcrumbs">
        <li><a href="#/">ホーム</a></li>
        <li aria-current="page">全コンポーネント</li>
      </ol>
      <h1 className="page-title">全コンポーネント一覧</h1>
      <p className="page-lead">{components.length} 件。カテゴリチップとキーワードで絞り込めます。</p>

      <div style={{ position: 'relative', marginTop: 14 }}>
        <span style={{ position: 'absolute', left: 11, top: 11, color: 'var(--text-faint)' }}><IconSearch size={17} /></span>
        <input
          className="input"
          type="search"
          value={q}
          onChange={(e) => setQ(e.target.value)}
          placeholder="名前や別名で絞り込む"
          aria-label="コンポーネント名で絞り込む"
          style={{ paddingLeft: 36 }}
        />
      </div>

      <div className="tagrow" style={{ marginTop: 10 }} role="group" aria-label="カテゴリで絞り込み">
        {categories.map((cat) => {
          const on = activeCats.includes(cat.id);
          return (
            <button
              key={cat.id}
              className="mini-chip"
              aria-pressed={on}
              onClick={() => toggleCat(cat.id)}
              style={{
                cursor: 'pointer',
                background: on ? 'var(--accent-soft)' : 'var(--bg-sunken)',
                borderColor: on ? 'var(--accent)' : 'var(--border)',
                color: on ? 'var(--accent)' : 'var(--text-muted)',
                fontWeight: on ? 700 : 400,
                padding: '4px 10px',
              }}
            >
              {cat.emoji} {cat.name}
            </button>
          );
        })}
        {(activeCats.length > 0 || q) && (
          <button className="mini-chip" style={{ cursor: 'pointer', padding: '4px 10px' }} onClick={() => { setActiveCats([]); setQ(''); }}>
            すべてクリア
          </button>
        )}
      </div>

      <p aria-live="polite" style={{ fontSize: 12.5, color: 'var(--text-faint)', margin: '12px 0 8px' }}>
        {filtered.length} 件を表示中
      </p>

      {filtered.length === 0 ? (
        <div className="panel" style={{ textAlign: 'center', padding: '34px 16px' }}>
          <div style={{ fontSize: 30 }} aria-hidden="true">🗂️</div>
          <p style={{ fontWeight: 700, marginTop: 8 }}>条件に合うコンポーネントがありません</p>
          <p style={{ fontSize: 13, color: 'var(--text-muted)', marginTop: 4 }}>キーワードを短くするか、カテゴリの絞り込みを解除してみてください。</p>
          <button className="btn btn--secondary btn--sm" style={{ marginTop: 12 }} onClick={() => { setActiveCats([]); setQ(''); }}>絞り込みを解除</button>
        </div>
      ) : (
        <div className="comp-list">
          {filtered.map((c) => (
            <a key={c.id} className="comp-row" href={`#/u/${c.id}`}>
              <span aria-hidden="true" style={{ fontSize: 18 }}>{categoryById[c.category]?.emoji}</span>
              <div className="comp-row__body">
                <div className="comp-row__name">{c.name}</div>
                <div className="comp-row__en">{c.enName}</div>
                <div className="comp-row__sum">{c.summary}</div>
              </div>
              <span className="comp-row__chev"><IconChevronRight size={18} /></span>
            </a>
          ))}
        </div>
      )}
    </div>
  );
}
