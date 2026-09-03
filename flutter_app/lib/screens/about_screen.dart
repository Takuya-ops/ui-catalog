import 'package:flutter/material.dart';

import '../models/ui_component.dart';
import '../widgets/common.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, required this.catalog});

  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CatalogAppBar(catalog: catalog, title: 'このアプリの使い方'),
      drawer: CatalogDrawer(catalog: catalog),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
        children: <Widget>[
          Text(
            'UI Catalog は、Web／スマホアプリのUIコンポーネントを'
            '「名前」「使いどころ」「実例」から学ぶための学習アプリです。'
            'Web版と Flutter版が、同じ1つのデータ（data/components.json）から動いています。',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.9,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SectionTitle('各コンポーネントページの構成'),
          const BulletPanel(
            items: <String>[
              '動くデモ — 実際に操作して挙動を確かめられます。まずここを触ってください。',
              '何のために使うか — 名前・英語名・別名と、そのUIが担う役割。',
              '使うべき場面 / 使うべきでない場面 — 似たUIとの使い分けの判断基準。',
              '実アプリでの採用例 — Gmail・Instagram・iOS など、実際の使われ方。',
              'よくある間違い — 現場で頻出するアンチパターン。',
              'アクセシビリティ — 実装時に外せない配慮。',
              '実装メモ — Web（HTML/ARIA）と Flutter（ウィジェット名）の対応。',
            ],
          ),
          const SectionTitle('学習の進め方（おすすめ）'),
          const BulletPanel(
            accent: Color(0xFFB46B00),
            items: <String>[
              '1周目: カテゴリごとに眺め、デモを触って「名前と見た目」を一致させる。',
              '2周目: 「使うべきでない場面」だけを読む。似たUIの使い分けが最も実務で効く。',
              '3周目: 普段使うアプリを開き、どのコンポーネントが使われているか名前で言えるか試す。',
              '設計時は「よくある間違い」をチェックリストとして使う。',
            ],
          ),
          const SectionTitle('操作のヒント'),
          const BulletPanel(
            items: <String>[
              '右上の🔍から、名前・別名・アプリ名で横断検索できます。',
              '右上のアイコンで、テーマを ライト → ダーク → システム連動 の順に切り替えられます。',
              '左上のメニュー（≡）からカテゴリのドロワーを開けます。',
              'タブを切り替えても、各タブの表示位置は保持されます（bottom-navigation の項を参照）。',
            ],
          ),
          const SectionTitle('収録状況'),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (final UiCategory cat in catalog.categories)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${cat.emoji} ${cat.name}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Text(
                          '${catalog.byCategory(cat.id).length} 件',
                          style: TextStyle(
                            fontSize: 13,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                Divider(color: scheme.outlineVariant),
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        '合計',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      '${catalog.components.length} 件',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SectionTitle('注意'),
          const BulletPanel(
            accent: Color(0xFFD7263D),
            items: <String>[
              '実アプリの採用例は、一般に広く知られた挙動を記載しています。各アプリのUIは更新されるため、最新の画面とは異なる場合があります。',
              'デモは学習用に単純化しています。本番実装ではアクセシビリティ欄の内容を必ず満たしてください。',
            ],
          ),
        ],
      ),
    );
  }
}
