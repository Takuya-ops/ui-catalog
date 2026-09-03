import { categories, componentsOf, components, meta } from '../catalog.js';
import { IconChevronRight, IconSparkle } from '../components/Icons.jsx';

export default function HomePage() {
  const total = components.length;
  return (
    <div>
      <section
        style={{
          background: 'linear-gradient(135deg, var(--accent-soft), transparent 70%)',
          border: '1px solid var(--border)',
          borderRadius: 'var(--radius-lg)',
          padding: '22px 18px',
        }}
      >
        <div style={{ display: 'inline-flex', alignItems: 'center', gap: 6, fontSize: 12, fontWeight: 700, color: 'var(--accent)' }}>
          <IconSparkle size={15} /> 触って学ぶ UI 辞典
        </div>
        <h1 className="page-title" style={{ marginTop: 8 }}>
          UIの「名前」と「使いどころ」を、<br />動くデモで身につける
        </h1>
        <p className="page-lead">
          {meta.subtitle}。全 <strong>{total}</strong> コンポーネントに、実際に操作できるデモ・実アプリでの採用例・
          よくある間違い・アクセシビリティの注意点をまとめています。
        </p>
        <div className="tagrow" style={{ marginTop: 14 }}>
          <a className="btn" href={`#/c/${categories[0].id}`}>入力系から始める</a>
          <a className="btn btn--secondary" href="#/all">全{total}件を一覧で見る</a>
        </div>
      </section>

      <section className="section">
        <h2 className="section__title">カテゴリから探す</h2>
        <div className="card-grid">
          {categories.map((cat) => {
            const list = componentsOf(cat.id);
            return (
              <a key={cat.id} className="cat-card" href={`#/c/${cat.id}`}>
                <div className="cat-card__top">
                  <span className="cat-card__emoji" aria-hidden="true">{cat.emoji}</span>
                  <span style={{ minWidth: 0 }}>
                    <div className="cat-card__name">{cat.name}</div>
                    <div className="cat-card__en">{cat.enName} · {list.length}件</div>
                  </span>
                  <span style={{ marginLeft: 'auto', color: 'var(--text-faint)' }}><IconChevronRight size={18} /></span>
                </div>
                <p className="cat-card__desc">{cat.description}</p>
                <div className="cat-card__chips">
                  {list.slice(0, 4).map((c) => (<span key={c.id} className="mini-chip">{c.name}</span>))}
                  {list.length > 4 && <span className="mini-chip">+{list.length - 4}</span>}
                </div>
              </a>
            );
          })}
        </div>
      </section>

      <section className="section">
        <h2 className="section__title">迷ったときの選び方（早見表）</h2>
        <div className="panel">
          <ul style={{ paddingLeft: '1.15em' }}>
            <li><strong>ON/OFF を切り替えたい</strong> … 即時反映なら <a href="#/u/toggle-switch">トグル</a>、保存ボタンで確定なら <a href="#/u/checkbox">チェックボックス</a></li>
            <li><strong>1つだけ選ばせたい</strong> … 選択肢2〜6個は <a href="#/u/radio">ラジオ</a>／2〜5個で表示切替なら <a href="#/u/segmented-control">セグメンテッドコントロール</a>／7個以上は <a href="#/u/select">セレクト</a>／数十以上は <a href="#/u/autocomplete">オートコンプリート</a></li>
            <li><strong>情報を隠して整理したい</strong> … 縦に畳むなら <a href="#/u/accordion">アコーディオン</a>、横に並べるなら <a href="#/u/tab-bar">タブ</a></li>
            <li><strong>操作結果を伝えたい</strong> … 消えてよいなら <a href="#/u/toast-snackbar">トースト</a>、残すべきなら <a href="#/u/alert-banner">バナー</a>、止めるべきなら <a href="#/u/modal-dialog">モーダル</a></li>
            <li><strong>危険な操作</strong> … 取り消せるなら <a href="#/u/undo">Undo</a>、取り消せないなら <a href="#/u/confirm-dialog">確認ダイアログ</a></li>
            <li><strong>一覧の続きを見せたい</strong> … 位置の把握が重要なら <a href="#/u/pagination">ページネーション</a>、探索的なフィードなら <a href="#/u/infinite-scroll">無限スクロール</a></li>
            <li><strong>読み込み中の表示</strong> … 形が決まっているなら <a href="#/u/skeleton">スケルトン</a>、進捗が出せるなら <a href="#/u/progress-indicator">プログレスバー</a></li>
          </ul>
        </div>
      </section>
    </div>
  );
}
