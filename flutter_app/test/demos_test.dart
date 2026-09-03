// 72個すべてのデモウィジェットが例外なく描画できることを確認する。
// （レイアウトのオーバーフローや null 参照を、詳細画面に載せる前に検出する）

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ui_catalog/demos/registry.dart';
import 'package:ui_catalog/theme.dart';

void main() {
  for (final String id in DemoRegistry.ids) {
    testWidgets('デモが描画できる: $id', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ThemeScope(
          controller: ThemeController(),
          child: MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: DemoRegistry.build(id),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));
      // initState 内の Future.delayed（スケルトンや3状態デモ）を消化させる
      await tester.pump(const Duration(seconds: 3));
      expect(tester.takeException(), isNull);
    });
  }
}
