import 'package:flutter/material.dart';

import '../models/ui_component.dart';
import '../widgets/common.dart';
import 'category_screen.dart';
import 'component_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.catalog});

  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CatalogAppBar(catalog: catalog, title: 'UI Catalog'),
      drawer: CatalogDrawer(catalog: catalog),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  scheme.primaryContainer,
                  scheme.surface,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.auto_awesome, size: 15, color: scheme.primary),
                    const SizedBox(width: 5),
                    Text(
                      '触って学ぶ UI 辞典',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'UIの「名前」と「使いどころ」を、\n動くデモで身につける',
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.45,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${catalog.subtitle}。全 ${catalog.components.length} コンポーネントに、'
                  '実際に操作できるデモ・実アプリでの採用例・よくある間違い・'
                  'アクセシビリティの注意点をまとめています。',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.75,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    FilledButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => CategoryScreen(
                            catalog: catalog,
                            category: catalog.categories.first,
                          ),
                        ),
                      ),
                      child: const Text('入力系から始める'),
                    ),
                    Builder(
                      // Scaffold.of は Scaffold の子孫の context が必要なので Builder を挟む
                      builder: (BuildContext innerContext) => OutlinedButton(
                        onPressed: () => Scaffold.of(innerContext).openDrawer(),
                        child: const Text('カテゴリを見る'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SectionTitle('カテゴリから探す'),
          for (final UiCategory cat in catalog.categories)
            _CategoryCard(catalog: catalog, category: cat),
          const SectionTitle('迷ったときの選び方（早見表）'),
          _CheatSheet(catalog: catalog),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.catalog, required this.category});

  final Catalog catalog;
  final UiCategory category;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<UiComponent> list = catalog.byCategory(category.id);
    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CategoryScreen(catalog: catalog, category: category),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(11),
                ),
                child:
                    Text(category.emoji, style: const TextStyle(fontSize: 19)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      category.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    Text(
                      '${category.enName} · ${list.length}件',
                      style: TextStyle(fontSize: 11, color: scheme.outline),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: scheme.outline),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            category.description,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.7,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: <Widget>[
              for (final UiComponent c in list.take(4))
                _MiniChip(text: c.name),
              if (list.length > 4) _MiniChip(text: '+${list.length - 4}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
      ),
    );
  }
}

class _CheatSheet extends StatelessWidget {
  const _CheatSheet({required this.catalog});

  final Catalog catalog;

  static const List<List<String>> _rows = <List<String>>[
    <String>[
      'ON/OFF を切り替えたい',
      '即時反映なら「トグル」、保存ボタンで確定なら「チェックボックス」',
      'toggle-switch',
    ],
    <String>[
      '1つだけ選ばせたい',
      '2〜6個は「ラジオ」／2〜5個の表示切替は「セグメンテッドコントロール」／7個以上は「セレクト」／数十以上は「オートコンプリート」',
      'radio',
    ],
    <String>[
      '情報を隠して整理したい',
      '縦に畳むなら「アコーディオン」、横に並べるなら「タブ」',
      'accordion',
    ],
    <String>[
      '操作結果を伝えたい',
      '消えてよいなら「トースト」、残すべきなら「バナー」、止めるべきなら「モーダル」',
      'toast-snackbar',
    ],
    <String>[
      '危険な操作',
      '取り消せるなら「Undo」、取り消せないなら「確認ダイアログ」',
      'undo',
    ],
    <String>[
      '一覧の続きを見せたい',
      '位置の把握が重要なら「ページネーション」、探索的なフィードなら「無限スクロール」',
      'pagination',
    ],
    <String>[
      '読み込み中の表示',
      '形が決まっているなら「スケルトン」、進捗が出せるなら「プログレスバー」',
      'skeleton',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          for (int i = 0; i < _rows.length; i++)
            InkWell(
              onTap: () {
                final UiComponent? c = catalog.byId(_rows[i][2]);
                if (c == null) return;
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ComponentDetailScreen(
                      catalog: catalog,
                      component: c,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: i == _rows.length - 1
                          ? Colors.transparent
                          : scheme.outlineVariant,
                    ),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _rows[i][0],
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _rows[i][1],
                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.65,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 18, color: scheme.outline),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
