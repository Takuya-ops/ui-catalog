import 'package:flutter/material.dart';

import 'data/catalog_loader.dart';
import 'models/ui_component.dart';
import 'screens/shell_screen.dart';
import 'theme.dart';

void main() {
  runApp(const UiCatalogApp());
}

class UiCatalogApp extends StatefulWidget {
  const UiCatalogApp({super.key});

  @override
  State<UiCatalogApp> createState() => _UiCatalogAppState();
}

class _UiCatalogAppState extends State<UiCatalogApp> {
  final ThemeController _theme = ThemeController();
  late final Future<Catalog> _future = CatalogLoader.load();

  @override
  void dispose() {
    _theme.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: _theme,
      child: AnimatedBuilder(
        animation: _theme,
        builder: (BuildContext context, Widget? _) {
          return MaterialApp(
            title: 'UI Catalog',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: _theme.mode,
            home: FutureBuilder<Catalog>(
              future: _future,
              builder:
                  (BuildContext context, AsyncSnapshot<Catalog> snapshot) {
                // three-states パターン：ローディング / エラー / 成功を必ず分岐する
                if (snapshot.connectionState != ConnectionState.done) {
                  return const _BootScaffold(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return _BootScaffold(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(Icons.error_outline, size: 40),
                        const SizedBox(height: 12),
                        const Text('カタログデータを読み込めませんでした'),
                        const SizedBox(height: 6),
                        Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => setState(() {}),
                          child: const Text('再試行'),
                        ),
                      ],
                    ),
                  );
                }
                return ShellScreen(catalog: snapshot.data!);
              },
            ),
          );
        },
      ),
    );
  }
}

class _BootScaffold extends StatelessWidget {
  const _BootScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }
}
