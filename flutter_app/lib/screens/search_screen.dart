import 'package:flutter/material.dart';

import '../models/ui_component.dart';

/// 横断検索。SearchDelegate を使うと、戻る・キーボード・履歴の扱いが標準で整う。
class ComponentSearchDelegate extends SearchDelegate<UiComponent?> {
  ComponentSearchDelegate(this.catalog)
      : super(
          searchFieldLabel: '名前・別名・アプリ名で検索',
          textInputAction: TextInputAction.search,
        );

  final Catalog catalog;

  @override
  List<Widget> buildActions(BuildContext context) => <Widget>[
        if (query.isNotEmpty)
          IconButton(
            tooltip: '検索キーワードをクリア',
            icon: const Icon(Icons.close),
            onPressed: () => query = '',
          ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        tooltip: '戻る',
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _list(context);

  @override
  Widget buildSuggestions(BuildContext context) => _list(context);

  Widget _list(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<UiComponent> results = query.trim().isEmpty
        ? catalog.components.take(10).toList()
        : catalog.search(query);

    if (results.isEmpty) {
      // 0件で行き止まりにしない（empty-state の項で説明している通り）
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('🔍', style: TextStyle(fontSize: 30)),
              const SizedBox(height: 10),
              Text(
                '「$query」に一致するコンポーネントは見つかりませんでした',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                '英語名（例: bottom sheet）やアプリ名（例: Gmail）でも検索できます。',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 6,
                children: <Widget>[
                  for (final String k in <String>['トグル', 'シート', 'Gmail'])
                    ActionChip(
                      label: Text(k),
                      onPressed: () => query = k,
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: scheme.outlineVariant),
      itemBuilder: (BuildContext context, int i) {
        final UiComponent c = results[i];
        final UiCategory? cat = catalog.categoryById(c.category);
        return ListTile(
          leading: Text(cat?.emoji ?? '•', style: const TextStyle(fontSize: 20)),
          title: Text(
            c.name,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
          ),
          subtitle: Text(
            '${c.enName}\n${c.summary}',
            style: const TextStyle(fontSize: 12),
          ),
          isThreeLine: true,
          onTap: () => close(context, c),
        );
      },
    );
  }
}
