import 'package:flutter/material.dart';

import '../models/ui_component.dart';
import '../widgets/common.dart';

/// 全コンポーネント一覧 + 絞り込み（search-and-filter パターンの実演）。
class AllComponentsScreen extends StatefulWidget {
  const AllComponentsScreen({super.key, required this.catalog});

  final Catalog catalog;

  @override
  State<AllComponentsScreen> createState() => _AllComponentsScreenState();
}

class _AllComponentsScreenState extends State<AllComponentsScreen> {
  final TextEditingController _controller = TextEditingController();
  final Set<String> _activeCategories = <String>{};
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<UiComponent> get _filtered {
    final String q = _query.trim().toLowerCase();
    return widget.catalog.components.where((UiComponent c) {
      if (_activeCategories.isNotEmpty &&
          !_activeCategories.contains(c.category)) {
        return false;
      }
      if (q.isEmpty) return true;
      return c.searchHaystack.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<UiComponent> results = _filtered;
    final bool hasFilter = _activeCategories.isNotEmpty || _query.isNotEmpty;

    return Scaffold(
      appBar: CatalogAppBar(catalog: widget.catalog, title: '全コンポーネント'),
      drawer: CatalogDrawer(catalog: widget.catalog),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: TextField(
              controller: _controller,
              onChanged: (String v) => setState(() => _query = v),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: '名前や別名で絞り込む',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        tooltip: '検索キーワードをクリア',
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                isDense: true,
              ),
            ),
          ),
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              children: <Widget>[
                for (final UiCategory cat in widget.catalog.categories)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text('${cat.emoji} ${cat.name}'),
                      selected: _activeCategories.contains(cat.id),
                      onSelected: (bool on) => setState(() {
                        if (on) {
                          _activeCategories.add(cat.id);
                        } else {
                          _activeCategories.remove(cat.id);
                        }
                      }),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 12, 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${results.length} 件を表示中',
                    style: TextStyle(fontSize: 12, color: scheme.outline),
                  ),
                ),
                if (hasFilter)
                  TextButton(
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _query = '';
                        _activeCategories.clear();
                      });
                    },
                    child: const Text('すべてクリア'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? _EmptyResult(
                    onClear: () {
                      _controller.clear();
                      setState(() {
                        _query = '';
                        _activeCategories.clear();
                      });
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
                    itemCount: results.length,
                    itemBuilder: (BuildContext context, int i) => ComponentTile(
                      catalog: widget.catalog,
                      component: results[i],
                      showEmoji: true,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('🗂️', style: TextStyle(fontSize: 34)),
            const SizedBox(height: 10),
            const Text(
              '条件に合うコンポーネントがありません',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              'キーワードを短くするか、カテゴリの絞り込みを解除してみてください。',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 14),
            OutlinedButton(onPressed: onClear, child: const Text('絞り込みを解除')),
          ],
        ),
      ),
    );
  }
}
