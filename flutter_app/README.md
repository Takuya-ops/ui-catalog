# UI Catalog — Flutter版

UIコンポーネント学習アプリ「UI Catalog」のスマホアプリ版です。
プロジェクト全体の説明は[リポジトリ直下の README](../README.md) を参照してください。

## 起動

```bash
flutter pub get
flutter run            # 接続中の iOS / Android 端末・シミュレータ
flutter run -d chrome  # Web でも動きます
```

追加パッケージは使っていません（Flutter SDK のみ）。

## 検証

```bash
flutter analyze        # 静的解析（警告0を維持）
flutter test           # データ整合性 + 全72デモの描画 + 画面遷移
```

## 構成

| パス | 役割 |
| --- | --- |
| `lib/main.dart` | エントリポイント。データ読み込みと3状態（ローディング/エラー/成功）の分岐 |
| `lib/theme.dart` | ライト/ダーク/システム連動のテーマ管理（`ThemeController` / `ThemeScope`） |
| `lib/models/ui_component.dart` | `assets/components.json` に対応するモデルと横断検索 |
| `lib/data/catalog_loader.dart` | rootBundle からの読み込み（キャッシュあり） |
| `lib/screens/` | シェル（ボトムナビ）/ ホーム / カテゴリ / 詳細 / 全一覧 / 検索 / 使い方 |
| `lib/demos/` | 72個の動くデモ。`registry.dart` が id → ウィジェットを解決 |
| `lib/widgets/common.dart` | AppCard・BulletPanel・PhoneFrame などの共通パーツ |

## データについて

`assets/components.json` は **生成物** です。編集する場合はリポジトリ直下の
`data/categories/*.json` を書き換えて、次を実行してください。

```bash
cd .. && node scripts/build-data.mjs
```
