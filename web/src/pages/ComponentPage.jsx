import { byId, categoryById, neighbors } from '../catalog.js';
import { demos } from '../demos/index.jsx';
import {
  IconAccessibility, IconAlert, IconCheck, IconClose, IconCode, IconInfo, IconSparkle,
} from '../components/Icons.jsx';

export default function ComponentPage({ componentId }) {
  const c = byId[componentId];
  if (!c) {
    return (
      <div>
        <h1 className="page-title">コンポーネントが見つかりません</h1>
        <p className="page-lead">
          <code>{componentId}</code> は登録されていません。<a href="#/all">一覧から探す</a>
        </p>
      </div>
    );
  }
  const cat = categoryById[c.category];
  const { prev, next } = neighbors(c.id);
  const Demo = demos[c.id];

  return (
    <article>
      <ol className="breadcrumbs">
        <li><a href="#/">ホーム</a></li>
        <li><a href={`#/c/${cat.id}`}>{cat.emoji} {cat.name}</a></li>
        <li aria-current="page">{c.name}</li>
      </ol>

      <header>
        <h1 className="page-title">{c.name}</h1>
        <div style={{ fontSize: 13, color: 'var(--text-faint)', marginTop: 2 }}>{c.enName}</div>
        <p className="page-lead">{c.summary}</p>
        {c.aliases?.length > 0 && (
          <div className="tagrow" style={{ marginTop: 10 }}>
            <span className="d-label" style={{ alignSelf: 'center' }}>別名</span>
            {c.aliases.map((a) => (<span className="mini-chip" key={a}>{a}</span>))}
          </div>
        )}
      </header>

      {/* ---- 動くデモ ---- */}
      <section className="section" aria-labelledby="demo-heading">
        <h2 className="section__title" id="demo-heading"><IconSparkle size={15} /> 触って動かすデモ</h2>
        <div className="demo-stage">
          <div className="demo-stage__bar">
            <span className="demo-stage__dot" aria-hidden="true" />
            <span>Live demo — 実際に操作できます</span>
          </div>
          <div className="demo-stage__body">
            {Demo ? <Demo /> : <p style={{ color: 'var(--text-muted)', fontSize: 13 }}>このコンポーネントのデモは準備中です。</p>}
          </div>
        </div>
      </section>

      {/* ---- 何のために使うか ---- */}
      <section className="section" aria-labelledby="purpose-heading">
        <h2 className="section__title" id="purpose-heading"><IconInfo size={15} /> 何のために使うか</h2>
        <div className="panel panel--info">
          <p style={{ fontSize: 14, lineHeight: 1.85 }}>{c.purpose}</p>
        </div>
      </section>

      {/* ---- 使う / 使わない ---- */}
      <section className="section" aria-labelledby="when-heading">
        <h2 className="section__title" id="when-heading">使いどころの判断</h2>
        <div style={{ display: 'grid', gap: 12, gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))' }}>
          <div className="panel panel--good">
            <div className="panel__head" style={{ color: 'var(--success)' }}><IconCheck size={16} /> 使うべき場面</div>
            <ul>{c.whenToUse.map((t, i) => <li key={i}>{t}</li>)}</ul>
          </div>
          <div className="panel panel--bad">
            <div className="panel__head" style={{ color: 'var(--danger)' }}><IconClose size={16} /> 使うべきでない場面</div>
            <ul>{c.whenNotToUse.map((t, i) => <li key={i}>{t}</li>)}</ul>
          </div>
        </div>
      </section>

      {/* ---- 実アプリ ---- */}
      <section className="section" aria-labelledby="real-heading">
        <h2 className="section__title" id="real-heading">📱 実アプリでの採用例</h2>
        <div className="panel">
          {c.realWorldExamples.map((ex, i) => (
            <div className="example-item" key={i}>
              <div className="example-item__app"><span aria-hidden="true">▸</span>{ex.app}</div>
              <div className="example-item__use">{ex.usage}</div>
            </div>
          ))}
        </div>
      </section>

      {/* ---- アンチパターン ---- */}
      <section className="section" aria-labelledby="anti-heading">
        <h2 className="section__title" id="anti-heading"><IconAlert size={15} /> よくある間違い・アンチパターン</h2>
        <div className="panel panel--warn">
          <ul>{c.antiPatterns.map((t, i) => <li key={i}>{t}</li>)}</ul>
        </div>
      </section>

      {/* ---- a11y ---- */}
      <section className="section" aria-labelledby="a11y-heading">
        <h2 className="section__title" id="a11y-heading"><IconAccessibility size={15} /> アクセシビリティの注意点</h2>
        <div className="panel panel--good">
          <ul>{c.accessibility.map((t, i) => <li key={i}>{t}</li>)}</ul>
        </div>
      </section>

      {/* ---- 実装メモ ---- */}
      <section className="section" aria-labelledby="impl-heading">
        <h2 className="section__title" id="impl-heading"><IconCode size={15} /> 実装メモ</h2>
        <div className="panel">
          <div className="kv">
            <div className="kv__row">
              <div className="kv__k">Web</div>
              <div style={{ fontSize: 13.5, color: 'var(--text-muted)' }}>{c.platformNotes.web}</div>
            </div>
            <div className="kv__row">
              <div className="kv__k">Flutter</div>
              <div style={{ fontSize: 13.5, color: 'var(--text-muted)' }}>{c.platformNotes.flutter}</div>
            </div>
          </div>
        </div>
      </section>

      {/* ---- 関連 ---- */}
      {c.related?.length > 0 && (
        <section className="section" aria-labelledby="rel-heading">
          <h2 className="section__title" id="rel-heading">関連するコンポーネント</h2>
          <div className="comp-list">
            {c.related.map((rid) => {
              const r = byId[rid];
              if (!r) return null;
              return (
                <a className="comp-row" key={rid} href={`#/u/${rid}`}>
                  <span aria-hidden="true" style={{ fontSize: 17 }}>{categoryById[r.category]?.emoji}</span>
                  <div className="comp-row__body">
                    <div className="comp-row__name">{r.name}</div>
                    <div className="comp-row__sum">{r.summary}</div>
                  </div>
                </a>
              );
            })}
          </div>
        </section>
      )}

      <nav className="pager" aria-label="前後のコンポーネント">
        {prev ? (
          <a className="pager__btn" href={`#/u/${prev.id}`}>
            <div className="pager__label">← 前</div>
            <div className="pager__name">{prev.name}</div>
          </a>
        ) : <span style={{ flex: 1 }} />}
        {next ? (
          <a className="pager__btn" href={`#/u/${next.id}`} style={{ textAlign: 'right' }}>
            <div className="pager__label">次 →</div>
            <div className="pager__name">{next.name}</div>
          </a>
        ) : <span style={{ flex: 1 }} />}
      </nav>
    </article>
  );
}
