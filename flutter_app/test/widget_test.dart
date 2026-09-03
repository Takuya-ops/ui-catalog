// UI Catalog のスモークテスト。
// カタログデータ（assets/components.json）を読み込み、ホーム画面が表示されることを確認する。

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ui_catalog/data/catalog_loader.dart';
import 'package:ui_catalog/demos/registry.dart';
import 'package:ui_catalog/main.dart';
import 'package:ui_catalog/models/ui_component.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('カタログデータを読み込める', () async {
    final Catalog catalog = await CatalogLoader.load();
    expect(catalog.components.length, greaterThanOrEqualTo(70));
    expect(catalog.categories.length, 7);
  });

  test('全コンポーネントにデモが登録されている', () async {
    final Catalog catalog = await CatalogLoader.load();
    final Set<String> demoIds = DemoRegistry.ids.toSet();
    final List<String> missing = catalog.components
        .map((UiComponent c) => c.id)
        .where((String id) => !demoIds.contains(id))
        .toList();
    expect(missing, isEmpty, reason: 'デモ未登録: $missing');
    expect(DemoRegistry.count, catalog.components.length);
  });

  test('related の参照先がすべて存在する', () async {
    final Catalog catalog = await CatalogLoader.load();
    for (final UiComponent c in catalog.components) {
      for (final String r in c.related) {
        expect(catalog.byId(r), isNotNull, reason: '${c.id} → $r が見つかりません');
      }
    }
  });

  testWidgets('起動するとホーム画面とボトムナビが表示される', (WidgetTester tester) async {
    await tester.pumpWidget(const UiCatalogApp());
    // データ読み込み（rootBundle）が終わるのを待つ
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('カテゴリから探す'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('入力系'), findsWidgets);
  });

  testWidgets('ホーム → カテゴリ → コンポーネント詳細 まで遷移できる',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2600);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    // assets の読み込み（実 I/O）を先に済ませてキャッシュを温めておく
    await tester.runAsync(CatalogLoader.load);

    await tester.pumpWidget(const UiCatalogApp());
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // ホームの「入力系」カテゴリカードをタップ
    await tester.tap(find.text('入力系').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('テキストフィールド'), findsWidgets);

    // 一覧から「トグル / スイッチ」の詳細へ
    await tester.tap(find.text('トグル / スイッチ').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // 詳細画面の主要セクションが揃っていること（ListView は遅延生成なので上部から確認）
    expect(find.text('Live demo — 実際に操作できます'), findsOneWidget);
    expect(find.text('何のために使うか'), findsOneWidget);
    expect(find.text('使うべき場面'), findsOneWidget);
    expect(find.text('使うべきでない場面'), findsOneWidget);

    // デモのスイッチが実際に動くこと
    final Finder switches = find.byType(SwitchListTile);
    expect(switches, findsWidgets);
    final bool before = tester.widget<SwitchListTile>(switches.at(1)).value;
    await tester.tap(switches.at(1));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.widget<SwitchListTile>(switches.at(1)).value, !before);

    // 下部のセクションまでスクロールして確認する
    await tester.scrollUntilVisible(
      find.text('実装メモ'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('実装メモ'), findsOneWidget);
    expect(find.text('アクセシビリティの注意点'), findsOneWidget);
  });
}

