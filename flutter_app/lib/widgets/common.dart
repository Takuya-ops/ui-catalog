import 'package:flutter/material.dart';

import '../models/ui_component.dart';
import '../screens/category_screen.dart';
import '../screens/component_detail_screen.dart';
import '../screens/search_screen.dart';
import '../theme.dart';

/// 各ルート画面で共有する AppBar（検索・テーマ切替つき）。
class CatalogAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CatalogAppBar({
    super.key,
    required this.catalog,
    required this.title,
    this.showDrawerButton = true,
  });

  final Catalog catalog;
  final String title;
  final bool showDrawerButton;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final ThemeController theme = ThemeScope.of(context);
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
      ),
      actions: <Widget>[
        IconButton(
          tooltip: 'コンポーネントを検索',
          icon: const Icon(Icons.search),
          onPressed: () async {
            final UiComponent? picked = await showSearch<UiComponent?>(
              context: context,
              delegate: ComponentSearchDelegate(catalog),
            );
            if (picked != null && context.mounted) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ComponentDetailScreen(
                    catalog: catalog,
                    component: picked,
                  ),
                ),
              );
            }
          },
        ),
        IconButton(
          tooltip: '表示テーマ: ${theme.label}',
          icon: Icon(theme.icon),
          onPressed: theme.cycle,
        ),
      ],
    );
  }
}

/// カテゴリ一覧のドロワー（drawer-sidebar の実演も兼ねる）。
class CatalogDrawer extends StatelessWidget {
  const CatalogDrawer({super.key, required this.catalog});

  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Text(
                'カテゴリ',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
            for (final UiCategory cat in catalog.categories)
              ListTile(
                leading: Text(cat.emoji, style: const TextStyle(fontSize: 20)),
                title: Text(cat.name),
                subtitle: Text(
                  '${cat.enName} · ${catalog.byCategory(cat.id).length}件',
                  style: const TextStyle(fontSize: 11),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          CategoryScreen(catalog: catalog, category: cat),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}


/// 枠線つきのカード。ThemeData の CardTheme に依存しないよう自前で組む。
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderColor,
    this.leftAccent,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? leftAccent;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final BorderRadius radius = BorderRadius.circular(14);
    final Color line = borderColor ?? scheme.outlineVariant;

    Widget inner = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(14),
      child: child,
    );

    // 左端のアクセント線。Border の色を辺ごとに変えると borderRadius と
    // 併用できない（Flutter の制約）ため、内側にバーを重ねて描く。
    if (leftAccent != null) {
      inner = Stack(
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(left: 3), child: inner),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(width: 3, color: leftAccent),
          ),
        ],
      );
    }

    // 背景色は Material に塗らせる。Container の decoration で塗ると、
    // 中に置いた ListTile / InkWell の波紋（ink splash）が隠れてしまう。
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: scheme.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: line),
        ),
        child: onTap == null
            ? inner
            : InkWell(onTap: onTap, child: inner),
      ),
    );
  }
}

/// 見出し（セクションタイトル）
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.icon});

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 22, 2, 10),
      child: Row(
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 15, color: scheme.onSurfaceVariant),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// 箇条書きパネル（良い例／悪い例などの色分けつき）
class BulletPanel extends StatelessWidget {
  const BulletPanel({
    super.key,
    required this.items,
    this.title,
    this.icon,
    this.accent,
  });

  final List<String> items;
  final String? title;
  final IconData? icon;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color color = accent ?? scheme.primary;
    return AppCard(
      leftAccent: color,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: <Widget>[
                    if (icon != null) ...<Widget>[
                      Icon(icon, size: 16, color: color),
                      const SizedBox(width: 6),
                    ],
                    Expanded(
                      child: Text(
                        title!,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            for (final String item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 8),
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: scheme.onSurfaceVariant,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.7,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// コンポーネント1件の行（一覧で使う）
class ComponentTile extends StatelessWidget {
  const ComponentTile({
    super.key,
    required this.catalog,
    required this.component,
    this.showEmoji = false,
  });

  final Catalog catalog;
  final UiComponent component;
  final bool showEmoji;

  @override
  Widget build(BuildContext context) {
    final UiCategory? cat = catalog.categoryById(component.category);
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              ComponentDetailScreen(catalog: catalog, component: component),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (showEmoji && cat != null) ...<Widget>[
            Text(cat.emoji, style: const TextStyle(fontSize: 19)),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  component.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14.5),
                ),
                Text(
                  component.enName,
                  style: TextStyle(fontSize: 11, color: scheme.outline),
                ),
                const SizedBox(height: 3),
                Text(
                  component.summary,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 20, color: scheme.outline),
        ],
      ),
    );
  }
}

/// デモの下に置く補足説明
class DemoNote extends StatelessWidget {
  const DemoNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.lightbulb_outline, size: 15, color: scheme.outline),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                height: 1.7,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// デモの状態表示（出力欄）
class DemoOutput extends StatelessWidget {
  const DemoOutput(this.text, {super.key, this.label});

  final String text;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            if (label != null)
              TextSpan(
                text: '$label: ',
                style: TextStyle(color: scheme.outline),
              ),
            TextSpan(text: text),
          ],
        ),
        style: const TextStyle(fontSize: 12.5, height: 1.6),
      ),
    );
  }
}

/// スマホ枠（モバイル特有UIのデモで使う）
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.child, this.height = 340});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        width: 300,
        height: height,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: scheme.outlineVariant, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}

/// デモ間の縦方向の余白つき Column
class DemoStack extends StatelessWidget {
  const DemoStack({super.key, required this.children, this.gap = 12});

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < children.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    );
  }
}

/// 小さなラベル
class DemoLabel extends StatelessWidget {
  const DemoLabel(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: color ?? Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
