import { categoryById, componentsOf, categories } from '../catalog.js';
import { IconChevronRight } from '../components/Icons.jsx';

export default function CategoryPage({ categoryId }) {
  const cat = categoryById[categoryId];
  if (!cat) {
    return (
      <div>
        <h1 className="page-title">カテゴリが見つかりません</h1>
        <p className="page-lead"><a href="#/">ホームへ戻る</a></p>
      </div>
    );
  }
  const list = componentsOf(cat.id);
  const idx = categories.findIndex((c) => c.id === cat.id);
  const prev = categories[idx - 1];
  const next = categories[idx + 1];

  return (
    <div>
      <ol className="breadcrumbs">
        <li><a href="#/">ホーム</a></li>
        <li aria-current="page">{cat.name}</li>
      </ol>

      <div style={{ display: 'flex', gap: 12, alignItems: 'flex-start' }}>
        <span className="cat-card__emoji" aria-hidden="true" style={{ width: 46, height: 46, fontSize: 23 }}>{cat.emoji}</span>
        <div>
          <h1 className="page-title">{cat.name}</h1>
          <div className="cat-card__en">{cat.enName} · {list.length} コンポーネント</div>
        </div>
      </div>
      <p className="page-lead">{cat.description}</p>

      <div className="comp-list" style={{ marginTop: 18 }}>
        {list.map((c) => (
          <a key={c.id} className="comp-row" href={`#/u/${c.id}`}>
            <div className="comp-row__body">
              <div className="comp-row__name">{c.name}</div>
              <div className="comp-row__en">{c.enName}</div>
              <div className="comp-row__sum">{c.summary}</div>
            </div>
            <span className="comp-row__chev"><IconChevronRight size={18} /></span>
          </a>
        ))}
      </div>

      <div className="pager">
        {prev ? (
          <a className="pager__btn" href={`#/c/${prev.id}`}>
            <div className="pager__label">← 前のカテゴリ</div>
            <div className="pager__name">{prev.emoji} {prev.name}</div>
          </a>
        ) : <span style={{ flex: 1 }} />}
        {next ? (
          <a className="pager__btn" href={`#/c/${next.id}`} style={{ textAlign: 'right' }}>
            <div className="pager__label">次のカテゴリ →</div>
            <div className="pager__name">{next.emoji} {next.name}</div>
          </a>
        ) : <span style={{ flex: 1 }} />}
      </div>
    </div>
  );
}
