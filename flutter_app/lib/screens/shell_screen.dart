import 'package:flutter/material.dart';

import '../models/ui_component.dart';
import 'about_screen.dart';
import 'all_screen.dart';
import 'home_screen.dart';

/// ボトムナビゲーション + タブごとの Navigator を持つアプリの外枠。
///
/// タブを切り替えても各タブのスクロール位置・遷移履歴が保持される。
/// これは bottom-navigation の項で「原則」と説明している挙動を、
/// このアプリ自身で実装したもの（IndexedStack + タブ別 Navigator）。
class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key, required this.catalog});

  final Catalog catalog;

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;
  final List<GlobalKey<NavigatorState>> _navKeys = <GlobalKey<NavigatorState>>[
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onTap(int i) {
    if (i == _index) {
      // 同じタブの再タップ → そのタブのルートまで戻る（各OS共通の慣習）
      _navKeys[i].currentState?.popUntil((Route<dynamic> r) => r.isFirst);
      return;
    }
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        final NavigatorState? nav = _navKeys[_index].currentState;
        if (nav != null && nav.canPop()) {
          nav.pop();
        } else if (_index != 0) {
          setState(() => _index = 0);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: <Widget>[
            _TabNavigator(
              navigatorKey: _navKeys[0],
              builder: (_) => HomeScreen(catalog: widget.catalog),
            ),
            _TabNavigator(
              navigatorKey: _navKeys[1],
              builder: (_) => AllComponentsScreen(catalog: widget.catalog),
            ),
            _TabNavigator(
              navigatorKey: _navKeys[2],
              builder: (_) => AboutScreen(catalog: widget.catalog),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _onTap,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'ホーム',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view),
              label: '一覧',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: '使い方',
            ),
          ],
        ),
      ),
    );
  }
}

class _TabNavigator extends StatelessWidget {
  const _TabNavigator({required this.navigatorKey, required this.builder});

  final GlobalKey<NavigatorState> navigatorKey;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (RouteSettings settings) =>
          MaterialPageRoute<void>(builder: builder),
    );
  }
}
