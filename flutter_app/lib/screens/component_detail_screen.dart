import 'package:flutter/material.dart';

import '../demos/registry.dart';
import '../models/ui_component.dart';
import '../widgets/common.dart';

/// コンポーネント1件の詳細。
/// 「動くデモ → 目的 → 使いどころ → 実例 → アンチパターン → a11y → 実装メモ → 関連」の順で構成する。
class ComponentDetailScreen extends StatelessWidget {
  const ComponentDetailScreen({
    super.key,
    required this.catalog,
    required this.component,
  });

  final Catalog catalog;
  final UiComponent component;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final UiCategory? cat = catalog.categoryById(component.category);
    final List<UiComponent> order = catalog.flatOrder;
    final int idx = order.indexWhere((UiComponent c) => c.id == component.id);
    final UiComponent? prev = idx > 0 ? order[idx - 1] : null;
    final UiComponent? next =
        idx >= 0 && idx < order.length - 1 ? order[idx + 1] : null;
    final Widget? demo = DemoRegistry.build(component.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(component.name),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
              child: Text(
                '${cat?.emoji ?? ''} ${cat?.name ?? ''} / ${component.enName}',
                style: TextStyle(fontSize: 11, color: scheme.outline),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
        children: <Widget>[
          Text(
            component.summary,
            style: TextStyle(
              fontSize: 14,
              height: 1.8,
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (component.aliases.isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: <Widget>[
                const DemoLabel('別名'),
                for (final String a in component.aliases)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Text(a, style: const TextStyle(fontSize: 11)),
                  ),
              ],
            ),
          ],

          // ---- 動くデモ ----
          const SectionTitle('触って動かすデモ', icon: Icons.auto_awesome),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    border: Border(
                      bottom: BorderSide(color: scheme.outlineVariant),
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(13),
                      topRight: Radius.circular(13),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0E8A53),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Live demo — 実際に操作できます',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                  child: demo ??
                      Text(
                        'このコンポーネントのデモは準備中です。',
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                ),
              ],
            ),
          ),

          // ---- 目的 ----
          const SectionTitle('何のために使うか', icon: Icons.info_outline),
          AppCard(
            leftAccent: scheme.primary,
            child: Text(
              component.purpose,
              style: const TextStyle(fontSize: 13.5, height: 1.9),
            ),
          ),

          // ---- 使う / 使わない ----
          const SectionTitle('使いどころの判断'),
          BulletPanel(
            title: '使うべき場面',
            icon: Icons.check_circle_outline,
            accent: const Color(0xFF0E8A53),
            items: component.whenToUse,
          ),
          const SizedBox(height: 10),
          BulletPanel(
            title: '使うべきでない場面',
            icon: Icons.highlight_off,
            accent: const Color(0xFFD7263D),
            items: component.whenNotToUse,
          ),

          // ---- 実アプリ ----
          const SectionTitle('実アプリでの採用例', icon: Icons.smartphone),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (int i = 0; i < component.realWorldExamples.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom:
                          i == component.realWorldExamples.length - 1 ? 0 : 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '▸ ${component.realWorldExamples[i].app}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          component.realWorldExamples[i].usage,
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.7,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // ---- アンチパターン ----
          const SectionTitle('よくある間違い・アンチパターン',
              icon: Icons.warning_amber_outlined),
          BulletPanel(
            items: component.antiPatterns,
            accent: const Color(0xFFB46B00),
          ),

          // ---- a11y ----
          const SectionTitle('アクセシビリティの注意点', icon: Icons.accessibility_new),
          BulletPanel(
            items: component.accessibility,
            accent: const Color(0xFF0E8A53),
          ),

          // ---- 実装メモ ----
          const SectionTitle('実装メモ', icon: Icons.code),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _NoteRow(label: 'Web', text: component.webNote),
                const SizedBox(height: 10),
                _NoteRow(label: 'Flutter', text: component.flutterNote),
              ],
            ),
          ),

          // ---- 関連 ----
          if (component.related.isNotEmpty) ...<Widget>[
            const SectionTitle('関連するコンポーネント'),
            for (final String rid in component.related)
              if (catalog.byId(rid) != null)
                ComponentTile(
                  catalog: catalog,
                  component: catalog.byId(rid)!,
                  showEmoji: true,
                ),
          ],

          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              if (prev != null)
                Expanded(
                  child: _NavButton(
                    catalog: catalog,
                    component: prev,
                    label: '← 前',
                  ),
                ),
              if (prev != null && next != null) const SizedBox(width: 8),
              if (next != null)
                Expanded(
                  child: _NavButton(
                    catalog: catalog,
                    component: next,
                    label: '次 →',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NoteRow extends StatelessWidget {
  const _NoteRow({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 62,
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: scheme.outline),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.75,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.catalog,
    required this.component,
    required this.label,
  });

  final Catalog catalog;
  final UiComponent component;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      onTap: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) =>
              ComponentDetailScreen(catalog: catalog, component: component),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: TextStyle(fontSize: 11, color: scheme.outline)),
          Text(
            component.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
