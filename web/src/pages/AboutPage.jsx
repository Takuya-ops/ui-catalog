import { components, categories, meta } from '../catalog.js';

export default function AboutPage() {
  return (
    <div>
      <ol className="breadcrumbs">
        <li><a href="#/">ホーム</a></li>
        <li aria-current="page">このアプリの使い方</li>
      </ol>
      <h1 className="page-title">このアプリの使い方</h1>
      <p className="page-lead">
        UI Catalog は、Web／スマホアプリのUIコンポーネントを「名前」「使いどころ」「実例」から学ぶための学習アプリです。
        同じデータ（<code>data/components.json</code>）から Web版 と Flutter版 の両方が動いています。
      </p>

      <div className="panel panel--info section">
        <div className="panel__head">📄 各コンポーネントページの構成</div>
        <ul>
          <li><strong>動くデモ</strong> — 実際に操作して挙動を確かめられます。まずここを触ってください。</li>
          <li><strong>これは何か / 何のために使うか</strong> — 名前・英語名・別名と、そのUIが担う役割。</li>
          <li><strong>使うべき場面 / 使うべきでない場面</strong> — 選択の判断基準。似たUIとの使い分けはここに書かれています。</li>
          <li><strong>実アプリでの採用例</strong> — Gmail・Instagram・iOS など、実際のアプリでの使われ方。</li>
          <li><strong>よくある間違い</strong> — 現場で頻出するアンチパターン。</li>
          <li><strong>アクセシビリティ</strong> — 実装時に外せない配慮。</li>
          <li><strong>実装メモ</strong> — Web（HTML/ARIA）と Flutter（ウィジェット名）の対応。</li>
        </ul>
      </div>

      <div className="panel panel--good">
        <div className="panel__head">⌨️ ショートカット</div>
        <ul>
          <li><kbd>⌘K</kbd> / <kbd>Ctrl+K</kbd> または <kbd>/</kbd> … 横断検索（コマンドパレット）を開く</li>
          <li>検索中は <kbd>↑</kbd><kbd>↓</kbd> で移動、<kbd>Enter</kbd> で開く、<kbd>Esc</kbd> で閉じる</li>
          <li>右上のアイコンでテーマを ライト → ダーク → システム連動 の順に切り替え</li>
        </ul>
      </div>

      <div className="panel panel--warn">
        <div className="panel__head">🧭 学習の進め方（おすすめ）</div>
        <ul>
          <li><strong>1周目</strong>: カテゴリごとに眺め、デモを触って「名前と見た目」を一致させる。</li>
          <li><strong>2周目</strong>: 「使うべきでない場面」だけを読む。似たUIの使い分けが最も実務で効く。</li>
          <li><strong>3周目</strong>: 普段使うアプリを開き、どのコンポーネントが使われているか名前で言えるか試す。</li>
          <li>設計時は「よくある間違い」をチェックリストとして使う。</li>
        </ul>
      </div>

      <div className="panel">
        <div className="panel__head">📊 収録状況</div>
        <div className="kv">
          {categories.map((c) => (
            <div className="kv__row" key={c.id}>
              <div className="kv__k">{c.emoji} {c.name}</div>
              <div>{components.filter((x) => x.category === c.id).length} コンポーネント</div>
            </div>
          ))}
          <div className="kv__row">
            <div className="kv__k">合計</div>
            <div><strong>{components.length}</strong> コンポーネント（データ生成: {meta.generatedAt?.slice(0, 10)}）</div>
          </div>
        </div>
      </div>

      <div className="panel panel--bad">
        <div className="panel__head">⚠️ 注意</div>
        <ul>
          <li>実アプリの採用例は、一般に広く知られた挙動を記載しています。各アプリのUIは更新されるため、実際の最新の画面とは異なる場合があります。</li>
          <li>デモは学習用に単純化しています。本番実装ではアクセシビリティ欄の内容を必ず満たしてください。</li>
        </ul>
      </div>
    </div>
  );
}
