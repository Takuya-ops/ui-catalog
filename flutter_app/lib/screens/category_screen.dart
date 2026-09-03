import 'package:flutter/material.dart';

import '../models/ui_component.dart';
import '../widgets/common.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({
    super.key,
    required this.catalog,
    required this.category,
  });

  final Catalog catalog;
  final UiCategory category;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<UiComponent> list = catalog.byCategory(category.id);
    final int index =
        catalog.categories.indexWhere((UiCategory c) => c.id == category.id);
    final UiCategory? prev = index > 0 ? catalog.categories[index - 1] : null;
    final UiCategory? next = index >= 0 && index < catalog.categories.length - 1
        ? catalog.categories[index + 1]
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(category.emoji, style: const TextStyle(fontSize: 30)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      category.name,
                      style: const TextStyle(
                          fontSize: 21, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      '${category.enName} · ${list.length} コンポーネント',
                      style: TextStyle(fontSize: 11.5, color: scheme.outline),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            category.description,
            style: TextStyle(
              fontSize: 13,
              height: 1.8,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          for (final UiComponent c in list)
            ComponentTile(catalog: catalog, component: c),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              if (prev != null)
                Expanded(
                  child: _CategoryNavButton(
                    catalog: catalog,
                    category: prev,
                    label: '← 前のカテゴリ',
                  ),
                ),
              if (prev != null && next != null) const SizedBox(width: 8),
              if (next != null)
                Expanded(
                  child: _CategoryNavButton(
                    catalog: catalog,
                    category: next,
                    label: '次のカテゴリ →',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryNavButton extends StatelessWidget {
  const _CategoryNavButton({
    required this.catalog,
    required this.category,
    required this.label,
  });

  final Catalog catalog;
  final UiCategory category;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      onTap: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => CategoryScreen(catalog: catalog, category: category),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: TextStyle(fontSize: 11, color: scheme.outline)),
          Text(
            '${category.emoji} ${category.name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
