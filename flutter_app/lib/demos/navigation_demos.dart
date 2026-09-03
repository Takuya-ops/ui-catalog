import 'package:flutter/material.dart';

import '../widgets/common.dart';

/* ---------------------------------------------------------------- app-bar */
class AppBarDemo extends StatefulWidget {
  const AppBarDemo({super.key});
  @override
  State<AppBarDemo> createState() => _AppBarDemoState();
}

class _AppBarDemoState extends State<AppBarDemo> {
  bool _scrolled = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        PhoneFrame(
          height: 320,
          child: Column(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: _scrolled ? 48 : 78,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  border: Border(
                      bottom: BorderSide(color: scheme.outlineVariant)),
                ),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      tooltip: '戻る',
                      icon: const Icon(Icons.arrow_back, size: 20),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: _scrolled ? 15 : 22,
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurface,
                        ),
                        child: const Text('受信トレイ'),
                      ),
                    ),
                    IconButton(
                      tooltip: '検索',
                      icon: const Icon(Icons.search, size: 20),
                      onPressed: () {},
                    ),
                    IconButton(
                      tooltip: 'その他のメニュー',
                      icon: const Icon(Icons.more_vert, size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification n) {
                    final bool s = n.metrics.pixels > 12;
                    if (s != _scrolled) setState(() => _scrolled = s);
                    return false;
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: 12,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: scheme.outlineVariant),
                    itemBuilder: (BuildContext context, int i) => ListTile(
                      dense: true,
                      title: Text('差出人 ${i + 1}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700)),
                      subtitle: const Text('件名のサンプルテキストです',
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        DemoOutput(
          _scrolled ? 'スクロール中：ラージタイトルが縮小' : '最上部：ラージタイトル表示',
          label: '状態',
        ),
        const DemoNote(
          '中のリストをスクロールしてください。Flutter では SliverAppBar(pinned/floating/expandedHeight) で'
          '同じ挙動を宣言的に書けます。左＝戻る／中央＝タイトル／右＝アクション（3個以内）が配置の慣習。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------- bottom-navigation */
class BottomNavigationDemo extends StatefulWidget {
  const BottomNavigationDemo({super.key});
  @override
  State<BottomNavigationDemo> createState() => _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigationDemo> {
  int _index = 0;
  static const List<String> _labels = <String>['ホーム', '検索', 'お知らせ', 'マイページ'];

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        PhoneFrame(
          height: 340,
          child: Column(
            children: <Widget>[
              Expanded(
                // IndexedStack なのでタブを切り替えてもスクロール位置が保持される
                child: IndexedStack(
                  index: _index,
                  children: <Widget>[
                    for (final String label in _labels)
                      ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: 16,
                        itemBuilder: (BuildContext context, int i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Text('$label の項目 ${i + 1}',
                              style: const TextStyle(fontSize: 13)),
                        ),
                      ),
                  ],
                ),
              ),
              NavigationBar(
                height: 62,
                selectedIndex: _index,
                onDestinationSelected: (int i) => setState(() => _index = i),
                destinations: const <NavigationDestination>[
                  NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'ホーム'),
                  NavigationDestination(
                      icon: Icon(Icons.search), label: '検索'),
                  NavigationDestination(
                    icon: Badge(
                      label: Text('3'),
                      child: Icon(Icons.notifications_outlined),
                    ),
                    label: 'お知らせ',
                  ),
                  NavigationDestination(
                      icon: Icon(Icons.person_outline), label: 'マイページ'),
                ],
              ),
            ],
          ),
        ),
        DemoOutput('選択中: ${_labels[_index]}', label: 'タブ'),
        DemoNote(
          'タブを切り替えてスクロールし、元のタブに戻ってみてください。位置が保持されます'
          '（IndexedStack を使うのが最も簡単な方法）。'
          'このアプリ本体のボトムナビも、タブごとに Navigator を分けて履歴を保持しています。',
        ),
      ],
    );
  }
}

/* ---------------------------------------------------------------- tab-bar */
class TabBarDemo extends StatelessWidget {
  const TabBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    const List<String> tabs = <String>['概要', '仕様', 'レビュー(128)', 'Q&A'];
    const List<String> bodies = <String>[
      '商品の概要説明。タブは「同じものの別の見方」を切り替えるUIです。',
      'サイズ: 120×80×35mm / 重量: 240g / 電源: USB-C',
      '★4.3 —「思ったより軽くて驚きました」ほか127件。',
      'Q. 保証期間は？ A. お買い上げから1年間です。',
    ];
    return DemoStack(
      children: <Widget>[
        DefaultTabController(
          length: tabs.length,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: scheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                ColoredBox(
                  color: scheme.surfaceContainerHighest,
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: <Widget>[
                      for (final String t in tabs) Tab(text: t),
                    ],
                  ),
                ),
                SizedBox(
                  height: 110,
                  child: TabBarView(
                    children: <Widget>[
                      for (final String b in bodies)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(b,
                              style:
                                  const TextStyle(fontSize: 13.5, height: 1.8)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const DemoNote(
          'TabBar + TabBarView + DefaultTabController の3点セット。'
          '左右スワイプでも切り替わります（TabBarView が標準で対応）。',
        ),
      ],
    );
  }
}

/* --------------------------------------------------------- drawer-sidebar */
class DrawerSidebarDemo extends StatefulWidget {
  const DrawerSidebarDemo({super.key});
  @override
  State<DrawerSidebarDemo> createState() => _DrawerSidebarDemoState();
}

class _DrawerSidebarDemoState extends State<DrawerSidebarDemo> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  String _current = '受信トレイ';

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        PhoneFrame(
          height: 330,
          child: Scaffold(
            key: _key,
            // デモ内の Scaffold なので、ドロワーもこの枠の中で開く
            drawer: Drawer(
              width: 210,
              child: ListView(
                padding: const EdgeInsets.only(top: 12),
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text('メール',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                  for (final String l in <String>['受信トレイ', 'スター付き', '送信済み', '下書き'])
                    ListTile(
                      dense: true,
                      selected: _current == l,
                      title: Text(l, style: const TextStyle(fontSize: 13.5)),
                      onTap: () {
                        setState(() => _current = l);
                        Navigator.of(context).pop();
                      },
                    ),
                ],
              ),
            ),
            appBar: AppBar(
              toolbarHeight: 48,
              title: Text(_current, style: const TextStyle(fontSize: 15)),
            ),
            body: Center(
              child: Text('「$_current」の一覧',
                  style: const TextStyle(fontSize: 13)),
            ),
          ),
        ),
        const DemoNote(
          'Scaffold に drawer を渡すだけで、AppBar のハンバーガー・スワイプで開く操作・'
          '暗幕タップで閉じる・戻るキー対応が自動で手に入ります。',
        ),
      ],
    );
  }
}

/* -------------------------------------------------------- hamburger-menu */
class HamburgerMenuDemo extends StatefulWidget {
  const HamburgerMenuDemo({super.key});
  @override
  State<HamburgerMenuDemo> createState() => _HamburgerMenuDemoState();
}

class _HamburgerMenuDemoState extends State<HamburgerMenuDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  border: Border(
                      bottom: BorderSide(color: scheme.outlineVariant)),
                ),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text('Example Corp.',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14)),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _open = !_open),
                      icon: Icon(_open ? Icons.close : Icons.menu, size: 17),
                      label: const Text('MENU', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 180),
                crossFadeState: _open
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Column(
                  children: <Widget>[
                    for (final String l
                        in <String>['ホーム', 'サービス', '導入事例', '料金', 'お問い合わせ'])
                      ListTile(
                        dense: true,
                        title: Text(l, style: const TextStyle(fontSize: 13.5)),
                        onTap: () {},
                      ),
                  ],
                ),
                secondChild: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('ページ本文。狭い画面ではナビゲーションを畳んでいます。',
                      style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
        DemoOutput(_open ? '開いている（アイコンは × に変化）' : '閉じている', label: '状態'),
        const DemoNote('開いている間はアイコンを × に変える、「MENU」の文字を添える、の2点で認知率が上がります。'),
      ],
    );
  }
}

/* ------------------------------------------------------------ breadcrumbs */
class BreadcrumbsDemo extends StatefulWidget {
  const BreadcrumbsDemo({super.key});
  @override
  State<BreadcrumbsDemo> createState() => _BreadcrumbsDemoState();
}

class _BreadcrumbsDemoState extends State<BreadcrumbsDemo> {
  bool _narrow = false;

  static const List<String> _full = <String>[
    'ホーム', '家電', 'キッチン家電', '電気ケトル', 'ステンレス電気ケトル 1.0L',
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<String> shown = _narrow
        ? <String>[_full.first, '…', _full[_full.length - 2], _full.last]
        : _full;
    return DemoStack(
      children: <Widget>[
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              for (int i = 0; i < shown.length; i++) ...<Widget>[
                if (i > 0)
                  Text('›', style: TextStyle(color: scheme.outline)),
                if (i == shown.length - 1)
                  Text(shown[i],
                      style: const TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.w700))
                else if (shown[i] == '…')
                  Text('…', style: TextStyle(color: scheme.outline))
                else
                  InkWell(
                    onTap: () {},
                    child: Text(
                      shown[i],
                      style: TextStyle(fontSize: 12.5, color: scheme.primary),
                    ),
                  ),
              ],
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () => setState(() => _narrow = !_narrow),
          child: Text(_narrow ? '全階層を表示' : 'モバイル幅を想定して省略表示'),
        ),
        const DemoNote('最後の要素（現在地）はリンクにしません。狭い幅では中間を「…」で省略します。'),
      ],
    );
  }
}

/* ------------------------------------------------------------- pagination */
class PaginationDemo extends StatefulWidget {
  const PaginationDemo({super.key});
  @override
  State<PaginationDemo> createState() => _PaginationDemoState();
}

class _PaginationDemoState extends State<PaginationDemo> {
  int _page = 1;
  static const int _total = 12;

  List<String> get _pages {
    final List<String> out = <String>[];
    for (int i = 1; i <= _total; i++) {
      if (i == 1 || i == _total || (i - _page).abs() <= 1) {
        out.add('$i');
      } else if (out.isEmpty || out.last != '…') {
        out.add('…');
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              for (int i = 0; i < 4; i++)
                ListTile(
                  dense: true,
                  title: Text('商品 ${(_page - 1) * 4 + i + 1}',
                      style: const TextStyle(fontSize: 13.5)),
                ),
            ],
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 4,
          runSpacing: 4,
          children: <Widget>[
            IconButton.outlined(
              tooltip: '前のページへ',
              onPressed: _page == 1 ? null : () => setState(() => _page--),
              icon: const Icon(Icons.chevron_left, size: 18),
            ),
            for (final String p in _pages)
              if (p == '…')
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text('…', style: TextStyle(color: scheme.outline)),
                )
              else if (int.parse(p) == _page)
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(40, 40),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(p),
                )
              else
                OutlinedButton(
                  onPressed: () => setState(() => _page = int.parse(p)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(40, 40),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(p),
                ),
            IconButton.outlined(
              tooltip: '次のページへ',
              onPressed: _page == _total ? null : () => setState(() => _page++),
              icon: const Icon(Icons.chevron_right, size: 18),
            ),
          ],
        ),
        DemoOutput('$_page / $_total ページ（全${_total * 4}件）', label: '現在'),
        const DemoNote('前後1ページ＋最初/最後＋「…」に省略。全体量が分かるのが無限スクロールとの違いです。'),
      ],
    );
  }
}

/* --------------------------------------------------------- wizard-stepper */
class WizardStepperDemo extends StatefulWidget {
  const WizardStepperDemo({super.key});
  @override
  State<WizardStepperDemo> createState() => _WizardStepperDemoState();
}

class _WizardStepperDemoState extends State<WizardStepperDemo> {
  int _step = 0;
  final TextEditingController _addr = TextEditingController();
  String _ship = 'std';
  String _pay = 'card';

  @override
  void dispose() {
    _addr.dispose();
    super.dispose();
  }

  bool get _canNext => _step != 0 || _addr.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        SizedBox(
          height: 330,
          child: Stepper(
            currentStep: _step,
            type: StepperType.vertical,
            onStepTapped: (int i) {
              if (i <= _step) setState(() => _step = i);
            },
            onStepContinue: _canNext && _step < 3
                ? () => setState(() => _step++)
                : null,
            onStepCancel: _step > 0 ? () => setState(() => _step--) : null,
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    if (details.onStepContinue != null)
                      FilledButton(
                        onPressed: details.onStepContinue,
                        child: Text(_step == 2 ? '確認へ進む' : '次へ'),
                      ),
                    const SizedBox(width: 8),
                    if (details.onStepCancel != null)
                      OutlinedButton(
                        onPressed: details.onStepCancel,
                        child: const Text('戻る'),
                      ),
                  ],
                ),
              );
            },
            steps: <Step>[
              Step(
                title: const Text('配送先'),
                isActive: _step >= 0,
                state: _step > 0 ? StepState.complete : StepState.indexed,
                content: TextField(
                  controller: _addr,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'お届け先住所',
                    hintText: '東京都千代田区…',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Step(
                title: const Text('配送方法'),
                isActive: _step >= 1,
                state: _step > 1 ? StepState.complete : StepState.indexed,
                content: RadioGroup<String>(
                  groupValue: _ship,
                  onChanged: (String? v) => setState(() => _ship = v ?? 'std'),
                  child: const Column(
                    children: <Widget>[
                      RadioListTile<String>(
                        dense: true,
                        value: 'std',
                        title: Text('通常配送（無料）'),
                      ),
                      RadioListTile<String>(
                        dense: true,
                        value: 'exp',
                        title: Text('お急ぎ便（+500円）'),
                      ),
                    ],
                  ),
                ),
              ),
              Step(
                title: const Text('支払い'),
                isActive: _step >= 2,
                state: _step > 2 ? StepState.complete : StepState.indexed,
                content: RadioGroup<String>(
                  groupValue: _pay,
                  onChanged: (String? v) => setState(() => _pay = v ?? 'card'),
                  child: const Column(
                    children: <Widget>[
                      RadioListTile<String>(
                        dense: true,
                        value: 'card',
                        title: Text('クレジットカード'),
                      ),
                      RadioListTile<String>(
                        dense: true,
                        value: 'cvs',
                        title: Text('コンビニ払い'),
                      ),
                    ],
                  ),
                ),
              ),
              Step(
                title: const Text('確認'),
                isActive: _step >= 3,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('お届け先：${_addr.text.isEmpty ? '（未入力）' : _addr.text}'),
                    Text('配送方法：${_ship == 'std' ? '通常配送' : 'お急ぎ便'}'),
                    Text('支払い：${_pay == 'card' ? 'クレジットカード' : 'コンビニ払い'}'),
                    TextButton(
                      onPressed: () => setState(() => _step = 0),
                      child: const Text('修正する'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const DemoNote(
          '「戻る」を押しても入力内容は保持されます。StepState.complete で完了ステップにチェックが付きます。',
        ),
      ],
    );
  }
}

/* -------------------------------------------------------------------- fab */
class FabDemo extends StatefulWidget {
  const FabDemo({super.key});
  @override
  State<FabDemo> createState() => _FabDemoState();
}

class _FabDemoState extends State<FabDemo> {
  final List<String> _notes = <String>['買い物メモ', '会議の議事録'];
  bool _extended = true;

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        PhoneFrame(
          height: 320,
          child: Scaffold(
            body: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification n) {
                final bool ext = n.metrics.pixels <= 20;
                if (ext != _extended) setState(() => _extended = ext);
                return false;
              },
              child: ListView(
                // FAB が最終行を隠さないよう、下に余白を確保する
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 86),
                children: <Widget>[
                  for (final String n in _notes)
                    AppCard(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(11),
                      child: Text(n, style: const TextStyle(fontSize: 13.5)),
                    ),
                ],
              ),
            ),
            floatingActionButton: _extended
                ? FloatingActionButton.extended(
                    onPressed: () => setState(
                        () => _notes.add('新しいメモ ${_notes.length + 1}')),
                    icon: const Icon(Icons.add),
                    label: const Text('作成'),
                  )
                : FloatingActionButton(
                    tooltip: '新しいメモを作成',
                    onPressed: () => setState(
                        () => _notes.add('新しいメモ ${_notes.length + 1}')),
                    child: const Icon(Icons.add),
                  ),
          ),
        ),
        const DemoNote(
          'スクロールすると Extended FAB がアイコンのみに縮みます。'
          'リスト下部の padding で最終行が隠れないようにするのが実装のコツ。',
        ),
      ],
    );
  }
}

/* ---------------------------------------------------- segmented-control */
class SegmentedControlDemo extends StatefulWidget {
  const SegmentedControlDemo({super.key});
  @override
  State<SegmentedControlDemo> createState() => _SegmentedControlDemoState();
}

class _SegmentedControlDemoState extends State<SegmentedControlDemo> {
  String _value = 'week';

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: SegmentedButton<String>(
            segments: const <ButtonSegment<String>>[
              ButtonSegment<String>(value: 'day', label: Text('日')),
              ButtonSegment<String>(value: 'week', label: Text('週')),
              ButtonSegment<String>(value: 'month', label: Text('月')),
            ],
            selected: <String>{_value},
            onSelectionChanged: (Set<String> s) =>
                setState(() => _value = s.first),
          ),
        ),
        AppCard(
          child: Text(
            switch (_value) {
              'day' => '2026年9月4日（木）の予定を表示しています。',
              'week' => '2026年9月1日〜9月7日の予定を表示しています。',
              _ => '2026年9月の予定を表示しています。',
            },
            style: const TextStyle(fontSize: 13.5),
          ),
        ),
        const DemoNote(
          'Material 3 の SegmentedButton は、選択中セグメントにチェックアイコンを自動で付けます'
          '（色だけに頼らない表現）。iOS 風にするなら CupertinoSlidingSegmentedControl。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------- command-palette */
class CommandPaletteDemo extends StatefulWidget {
  const CommandPaletteDemo({super.key});
  @override
  State<CommandPaletteDemo> createState() => _CommandPaletteDemoState();
}

class _CommandPaletteDemoState extends State<CommandPaletteDemo> {
  String _log = '（ボタンを押してコマンドパレットを開いてください）';

  static const List<List<String>> _commands = <List<String>>[
    <String>['＋', '新しいページを作成', 'コマンド'],
    <String>['⚙', '設定を開く', 'コマンド'],
    <String>['◐', 'ダークモードを切り替える', 'コマンド'],
    <String>['📄', '週次レポート 2026-09', 'ページ'],
    <String>['📄', 'デザインガイドライン', 'ページ'],
    <String>['👤', 'メンバーを招待', 'コマンド'],
  ];

  Future<void> _open() async {
    final String? picked = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => const _PaletteDialog(_commands),
    );
    if (picked != null && mounted) setState(() => _log = '実行: $picked');
  }

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        OutlinedButton.icon(
          onPressed: _open,
          icon: const Icon(Icons.search, size: 18),
          label: const Text('コマンドを検索…（⌘K）'),
        ),
        DemoOutput(_log, label: 'ログ'),
        const DemoNote(
          '実行できる「コマンド」と移動先の「ページ」を右側のラベルで区別しています。'
          'デスクトップ版 Flutter では Shortcuts / Actions でキーバインドを定義できます。',
        ),
      ],
    );
  }
}

class _PaletteDialog extends StatefulWidget {
  const _PaletteDialog(this.commands);

  final List<List<String>> commands;

  @override
  State<_PaletteDialog> createState() => _PaletteDialogState();
}

class _PaletteDialogState extends State<_PaletteDialog> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<List<String>> results = widget.commands
        .where((List<String> c) => c[1].contains(_query))
        .toList();
    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.fromLTRB(16, 90, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: TextField(
              autofocus: true,
              onChanged: (String v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'コマンドやページ名を入力…',
                prefixIcon: Icon(Icons.search, size: 20),
                border: InputBorder.none,
              ),
            ),
          ),
          Divider(height: 1, color: scheme.outlineVariant),
          if (results.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('一致するコマンドがありません'),
            )
          else
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  for (final List<String> c in results)
                    ListTile(
                      dense: true,
                      leading: Text(c[0], style: const TextStyle(fontSize: 16)),
                      title: Text(c[1], style: const TextStyle(fontSize: 13.5)),
                      trailing: Text(c[2],
                          style:
                              TextStyle(fontSize: 11, color: scheme.outline)),
                      onTap: () => Navigator.of(context).pop(c[1]),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
