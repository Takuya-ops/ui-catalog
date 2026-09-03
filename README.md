# UI Catalog — 触って学ぶ UI コンポーネント辞典

Web / スマホアプリの **UIコンポーネントの「名前」と「使いどころ」を、実際に動かしながら学ぶ** ための学習アプリです。

**全 72 コンポーネント**を7カテゴリに分類し、それぞれについて次の情報を収録しています。

| 項目 | 内容 |
| --- | --- |
| 🎮 動くデモ | 実際に操作できるインタラクティブなデモ（全コンポーネントに用意） |
| 🏷 名前 / 英語名 / 別名 | 「トグル」＝ Toggle / Switch のように、現場で通じる呼び方を揃える |
| 🎯 何のために使うか | そのUIが担う役割 |
| ✅ 使うべき場面 / ❌ 使うべきでない場面 | 似たUIとの使い分けの判断基準 |
| 📱 実アプリでの採用例 | Gmail・Instagram・iOS・GitHub など、具体名での使用例 |
| ⚠️ よくある間違い | 現場で頻出するアンチパターン |
| ♿ アクセシビリティ | 実装時に外せない配慮（ARIA・タップ領域・キーボード操作など） |
| 🧑‍💻 実装メモ | Web（HTML/ARIA）と Flutter（ウィジェット名）の対応 |

**Web版（React）と スマホアプリ版（Flutter）の2つを同梱**しており、
どちらも `data/components.json`（単一のソース）を読み込んで動きます。

---

## 収録コンポーネント（全72件）

<details open>
<summary><b>✏️ 入力系（15）</b> — ユーザーから値を受け取る</summary>

テキストフィールド / テキストエリア / チェックボックス / ラジオボタン / トグル・スイッチ /
スライダー / ステッパー（数値増減）/ セレクト・ドロップダウン / オートコンプリート /
日付・時刻ピッカー / ファイルアップローダー / 検索バー / タグ入力 / レーティング（星評価）/ PIN・認証コード入力
</details>

<details>
<summary><b>🧭 ナビゲーション系（11）</b> — 「今どこにいるか」「どこへ行けるか」</summary>

ヘッダー・アプリバー / ボトムナビゲーション / タブ / サイドバー・ドロワー / ハンバーガーメニュー /
パンくずリスト / ページネーション / ステッパー・ウィザード / FAB / セグメンテッドコントロール / コマンドパレット
</details>

<details>
<summary><b>📊 情報表示系（14）</b> — 情報を読みやすく構造化する</summary>

カード / リスト / テーブル / アバター / バッジ / チップ / タイムライン / アコーディオン・折りたたみ /
ツールチップ / ポップオーバー / カルーセル / 空状態 / スケルトン / プログレスバー・スピナー
</details>

<details>
<summary><b>🪟 オーバーレイ系（7）</b> — 既存の画面の上に重ねる</summary>

モーダル・ダイアログ / ボトムシート / アクションシート / ドロワー（オーバーレイ）/
トースト・スナックバー / アラート・バナー / コンテキストメニュー
</details>

<details>
<summary><b>🎯 アクション系（9）</b> — 操作を実行する</summary>

プライマリボタン / セカンダリボタン / ゴースト・テキストボタン / デストラクティブボタン / リンク /
アイコンボタン / スプリットボタン / コピーボタン / 共有ボタン
</details>

<details>
<summary><b>📱 ジェスチャー・モバイル特有（6）</b> — タッチと小さい画面ならでは</summary>

プルトゥリフレッシュ / スワイプアクション / 無限スクロール / ロングプレス（長押し）/ セーフエリア / ハプティクス
</details>

<details>
<summary><b>🧩 パターン系（10）</b> — 複数のUIを組み合わせた定番設計</summary>

オンボーディング / ログイン・サインアップ / 検索とフィルタ / ソート（並べ替え）/ Undo（元に戻す）/
確認ダイアログ / バリデーション・エラー表示 / ローディング・エラー・空の3状態 / ダークモード切替 / 通知・権限リクエスト
</details>

---

## ディレクトリ構成

```
ui-catalog/
├── data/
│   ├── categories/            # ★ 単一ソース（ここだけを編集する）
│   │   ├── _meta.json         #   カテゴリ定義
│   │   ├── input.json         #   入力系 15件
│   │   ├── navigation.json    #   ナビゲーション系 11件
│   │   ├── display.json       #   情報表示系 14件
│   │   ├── overlay.json       #   オーバーレイ系 7件
│   │   ├── action.json        #   アクション系 9件
│   │   ├── mobile.json        #   モバイル特有 6件
│   │   └── pattern.json       #   パターン系 10件
│   └── components.json        # 生成物（Web版が読み込む）
│
├── scripts/
│   └── build-data.mjs         # categories/*.json をマージ・検証して配布（依存パッケージなし）
│
├── web/                       # Web版（React + Vite、依存は react / react-dom / vite のみ）
│   ├── index.html
│   ├── vite.config.js
│   └── src/
│       ├── App.jsx            # 外枠（ヘッダー・サイドバー・ボトムナビ・検索）
│       ├── catalog.js         # データ読み込みと横断検索
│       ├── router.js          # 依存なしのハッシュルーター / テーマ管理
│       ├── styles.css         # デザイントークン（ライト・ダーク）
│       ├── pages/             # ホーム / カテゴリ / 詳細 / 全一覧 / 使い方
│       ├── components/        # 検索オーバーレイ・アイコン
│       └── demos/             # ★ 72個の動くデモ（カテゴリごとに1ファイル）
│           ├── index.jsx      #   id → デモ の対応表
│           ├── input.jsx  navigation.jsx  display.jsx
│           ├── overlay.jsx  action.jsx  mobile.jsx  pattern.jsx
│           └── common.jsx     #   デモ共通パーツ
│
└── flutter_app/               # スマホアプリ版（Flutter、追加パッケージなし）
    ├── pubspec.yaml
    ├── assets/components.json # data/components.json のコピー（build-data.mjs が更新）
    ├── test/                  # スモークテスト + 全デモの描画テスト
    └── lib/
        ├── main.dart
        ├── theme.dart         # ライト/ダーク/システム連動
        ├── models/            # JSON のモデル定義
        ├── data/              # assets からの読み込み
        ├── screens/           # シェル / ホーム / カテゴリ / 詳細 / 一覧 / 検索 / 使い方
        ├── widgets/common.dart
        └── demos/             # ★ 72個の動くデモ（registry.dart が id → ウィジェット）
```

### データの流れ

```
data/categories/*.json  ──[ scripts/build-data.mjs ]──┬──> data/components.json           ──> Web版
   （唯一の編集対象）        重複ID・必須項目・         └──> flutter_app/assets/components.json ──> Flutter版
                            related の参照先を検証
```

コンポーネントを追加・修正するときは **`data/categories/*.json` だけを編集**し、
`node scripts/build-data.mjs` を実行すれば Web版・Flutter版の両方に反映されます。
（デモの実装だけは、各プラットフォームのデモファイルにそれぞれ追加します）

---

## セットアップと起動

### Web版

```bash
cd web
npm install
npm run dev          # → http://localhost:5173
```

- `npm run dev` / `npm run build` の前に `scripts/build-data.mjs` が自動実行され、データが最新化されます。
- 本番ビルドは `npm run build`（出力先 `web/dist`）、確認は `npm run preview`。
- 依存は `react` / `react-dom` / `vite` / `@vitejs/plugin-react` のみです（UIライブラリ・ルーター・アイコンはすべて自前）。

**操作**

| 操作 | 内容 |
| --- | --- |
| `⌘K` / `Ctrl+K` または `/` | 横断検索（コマンドパレット）を開く |
| `↑` `↓` → `Enter` | 検索結果を移動 / 開く |
| `Esc` | 検索を閉じる |
| 右上のアイコン | ライト → ダーク → システム連動 の順にテーマ切替 |

モバイル幅ではサイドバーがハンバーガー＋ドロワーに、下部にボトムナビが表示される
レスポンシブ構成です（アプリ自体がカタログの内容を実践しています）。

### スマホアプリ版（Flutter）

```bash
cd flutter_app
flutter pub get
flutter run          # 接続中の iOS / Android 端末・シミュレータで起動
```

- 追加パッケージは使っていません（`flutter` SDK のみ）。`flutter run -d chrome` で Web でも動きます。
- 検証環境: **Flutter 3.47.2 / Dart 3.13.2**（`flutter analyze` は警告0、`flutter test` は全パス）。
- `data/components.json` を更新した場合は、リポジトリ直下で `node scripts/build-data.mjs` を実行すると
  `flutter_app/assets/components.json` も同時に更新されます。

```bash
flutter analyze      # 静的解析
flutter test         # データ整合性 + 全72デモの描画テスト
```

> **補足:** Flutter Web で実行した場合、日本語の字形は CanvasKit が Google Fonts から
> 動的に取得します。オフライン環境では漢字が □ で表示されることがありますが、
> iOS / Android のネイティブ実行では端末のフォントが使われるため発生しません。

---

## このアプリ自身がカタログの実践例です

説明しているパターンを、アプリ自身が実装しています。

- **ボトムナビゲーション** — タブを切り替えてもスクロール位置と遷移履歴を保持（Web: 状態保持 / Flutter: タブごとの `Navigator`）
- **コマンドパレット** — `⌘K` での横断検索、combobox の ARIA パターン、フォーカストラップ
- **ダークモード切替** — 色をすべてトークン化し、ライト / ダーク / システム連動の3択
- **検索とフィルタ** — 一覧画面のチップ絞り込み、適用中条件の可視化、0件時の空状態
- **アクセシビリティ** — ランドマーク、`aria-current`、キーボード操作、44pt以上のタップ領域

---

## 学習の進め方（おすすめ）

1. **1周目** — カテゴリごとに眺め、デモを触って「名前と見た目」を一致させる
2. **2周目** — 「使うべきでない場面」だけを読む。似たUIの使い分けが最も実務で効く
3. **3周目** — 普段使うアプリを開き、どのコンポーネントが使われているか名前で言えるか試す
4. **設計時** — 「よくある間違い」をチェックリストとして使う

---

## 注意

- 実アプリの採用例は、一般に広く知られた挙動を記載しています。各アプリのUIは更新されるため、
  最新の画面とは異なる場合があります。
- デモは学習用に単純化しています。本番実装では各ページの「アクセシビリティ」欄の内容を満たしてください。

## ライセンス

MIT
