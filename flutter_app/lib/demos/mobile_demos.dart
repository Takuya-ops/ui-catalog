import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/common.dart';

/* -------------------------------------------------------- pull-to-refresh */
class PullToRefreshDemo extends StatefulWidget {
  const PullToRefreshDemo({super.key});
  @override
  State<PullToRefreshDemo> createState() => _PullToRefreshDemoState();
}

class _PullToRefreshDemoState extends State<PullToRefreshDemo> {
  List<String> _items = <String>['最新の投稿 3', '最新の投稿 2', '最新の投稿 1'];
  bool _refreshing = false;

  Future<void> _refresh() async {
    setState(() => _refreshing = true);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _items = <String>['新着の投稿 ${_items.length + 1}', ..._items];
      _refreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        PhoneFrame(
          height: 320,
          child: Column(
            children: <Widget>[
              Container(
                height: 42,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  border: Border(
                      bottom: BorderSide(color: scheme.outlineVariant)),
                ),
                child: const Text('タイムライン',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13.5)),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _items.length,
                    itemBuilder: (BuildContext context, int i) => AppCard(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(11),
                      child:
                          Text(_items[i], style: const TextStyle(fontSize: 13)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            OutlinedButton.icon(
              onPressed: _refreshing ? null : _refresh,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('更新（ボタンからも実行できる）'),
            ),
            const SizedBox(width: 10),
            Text(_refreshing ? '更新中…' : '${_items.length}件',
                style: const TextStyle(fontSize: 12.5)),
          ],
        ),
        const DemoNote(
          'スマホ枠の中のリストを下へ引っ張ってください。RefreshIndicator が'
          'インジケータの表示と閾値判定を担当します。ジェスチャーだけに頼らず、'
          'ボタンからの更新も必ず用意します。',
        ),
      ],
    );
  }
}

/* ---------------------------------------------------------- swipe-actions */
class SwipeActionsDemo extends StatefulWidget {
  const SwipeActionsDemo({super.key});
  @override
  State<SwipeActionsDemo> createState() => _SwipeActionsDemoState();
}

class _SwipeActionsDemoState extends State<SwipeActionsDemo> {
  List<String> _mails = <String>['請求書のご確認', '週次レポート', '打ち合わせの日程調整'];

  void _remove(String mail, String kind) {
    final int index = _mails.indexOf(mail);
    setState(() => _mails = List<String>.from(_mails)..remove(mail));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('「$mail」を$kindしました'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: '元に戻す',
          onPressed: () =>
              setState(() => _mails = List<String>.from(_mails)..insert(index, mail)),
        ),
      ),
    );
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
              if (_mails.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('すべて処理しました 🎉'),
                ),
              for (final String m in _mails)
                Dismissible(
                  key: ValueKey<String>(m),
                  background: Container(
                    color: const Color(0xFF0E8A53),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.archive, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text('アーカイブ',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    color: scheme.error,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('削除',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                        SizedBox(width: 6),
                        Icon(Icons.delete, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                  onDismissed: (DismissDirection dir) => _remove(
                    m,
                    dir == DismissDirection.startToEnd ? 'アーカイブ' : '削除',
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text(m, style: const TextStyle(fontSize: 13.5)),
                    // ジェスチャーの代替手段（WCAG 2.5.1）
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          tooltip: '$m をアーカイブ',
                          icon: const Icon(Icons.archive_outlined, size: 18),
                          onPressed: () => _remove(m, 'アーカイブ'),
                        ),
                        IconButton(
                          tooltip: '$m を削除',
                          icon: Icon(Icons.delete_outline,
                              size: 18, color: scheme.error),
                          onPressed: () => _remove(m, '削除'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_mails.length < 3)
          OutlinedButton(
            onPressed: () => setState(() => _mails = <String>[
                  '請求書のご確認',
                  '週次レポート',
                  '打ち合わせの日程調整',
                ]),
            child: const Text('デモをリセット'),
          ),
        const DemoNote(
          '行を左右にスワイプしてください（右＝アーカイブ／左＝削除）。'
          'Dismissible が実装の基本形で、複数アクションを出したい場合は flutter_slidable を使います。'
          '実行後は必ず Undo を出します。',
        ),
      ],
    );
  }
}

/* -------------------------------------------------------- infinite-scroll */
class InfiniteScrollDemo extends StatefulWidget {
  const InfiniteScrollDemo({super.key});
  @override
  State<InfiniteScrollDemo> createState() => _InfiniteScrollDemoState();
}

class _InfiniteScrollDemoState extends State<InfiniteScrollDemo> {
  final ScrollController _controller = ScrollController();
  final List<String> _items =
      List<String>.generate(8, (int i) => '投稿 ${i + 1}');
  bool _loading = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 80) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    if (_loading || _done) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _items.addAll(
        List<String>.generate(6, (int i) => '投稿 ${_items.length + i + 1}'),
      );
      _loading = false;
      if (_items.length >= 26) _done = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        Container(
          height: 280,
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: ListView.builder(
            controller: _controller,
            padding: const EdgeInsets.all(10),
            itemCount: _items.length + 1,
            itemBuilder: (BuildContext context, int i) {
              if (i == _items.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.4),
                          )
                        : _done
                            ? Text('— これ以上ありません —',
                                style: TextStyle(
                                    fontSize: 12.5, color: scheme.outline))
                            : OutlinedButton(
                                onPressed: _loadMore,
                                child: const Text('さらに読み込む'),
                              ),
                  ),
                );
              }
              return AppCard(
                margin: const EdgeInsets.only(bottom: 7),
                padding: const EdgeInsets.all(11),
                child: Text(_items[i], style: const TextStyle(fontSize: 13)),
              );
            },
          ),
        ),
        DemoOutput('${_items.length} 件${_done ? '（全件）' : ''}', label: '読み込み済み'),
        const DemoNote(
          'ScrollController で末尾への接近を検知して自動読み込み。'
          '「さらに読み込む」ボタンも併設し、末尾（これ以上ない）も必ず明示します。',
        ),
      ],
    );
  }
}

/* -------------------------------------------------------------- long-press */
class LongPressDemo extends StatefulWidget {
  const LongPressDemo({super.key});
  @override
  State<LongPressDemo> createState() => _LongPressDemoState();
}

class _LongPressDemoState extends State<LongPressDemo> {
  String _log = '（アイコンを長押ししてください）';

  Future<void> _openMenu(Offset position) async {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final String? picked = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(position.dx, position.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(value: '新しい予定', child: Text('新しい予定')),
        const PopupMenuItem<String>(value: '今日の予定を見る', child: Text('今日の予定を見る')),
        PopupMenuItem<String>(
          value: 'アプリを削除',
          child: Text('アプリを削除', style: TextStyle(color: scheme.error)),
        ),
      ],
    );
    if (picked != null && mounted) setState(() => _log = '選択: $picked');
  }

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                Builder(
                  builder: (BuildContext iconContext) => GestureDetector(
                    onLongPress: () {
                      // 長押し成立の瞬間に触覚フィードバックを返す
                      HapticFeedback.mediumImpact();
                      final RenderBox box =
                          iconContext.findRenderObject()! as RenderBox;
                      _openMenu(
                          box.localToGlobal(Offset(0, box.size.height + 4)));
                    },
                    child: Container(
                      width: 62,
                      height: 62,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: <Color>[Color(0xFF7C92FF), Color(0xFFB06BFF)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text('📅', style: TextStyle(fontSize: 26)),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const DemoLabel('カレンダー'),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DemoOutput(_log, label: 'ログ'),
                  const SizedBox(height: 8),
                  Builder(
                    builder: (BuildContext btnContext) => OutlinedButton(
                      onPressed: () {
                        final RenderBox box =
                            btnContext.findRenderObject()! as RenderBox;
                        _openMenu(
                            box.localToGlobal(Offset(0, box.size.height)));
                      },
                      child: const Text('長押しの代替：メニューボタン'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const DemoNote(
          'Flutter では GestureDetector(onLongPress:) / InkWell(onLongPress:) で実装します。'
          '長押しは発見しづらいので、同じ操作へ到達できるボタンを必ず併設します。',
        ),
      ],
    );
  }
}

/* --------------------------------------------------------------- safe-area */
class SafeAreaDemo extends StatefulWidget {
  const SafeAreaDemo({super.key});
  @override
  State<SafeAreaDemo> createState() => _SafeAreaDemoState();
}

class _SafeAreaDemoState extends State<SafeAreaDemo> {
  bool _safe = true;

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        Center(
          child: Container(
            width: 250,
            height: 330,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outline, width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                // 背景は端まで広げる（これは常に正しい）
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Color(0xFF3B5BFD), Color(0xFF9B6BFF)],
                    ),
                  ),
                ),
                // 操作要素はセーフエリア内に置く
                Padding(
                  padding: EdgeInsets.only(
                    top: _safe ? 28 : 0,
                    bottom: _safe ? 22 : 0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.white.withValues(alpha: 0.92),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 9),
                        child: const Row(
                          children: <Widget>[
                            Text('← 戻る',
                                style: TextStyle(
                                    fontSize: 12.5,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700)),
                            Expanded(
                              child: Text('タイトル',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700)),
                            ),
                            Text('⋯',
                                style: TextStyle(
                                    fontSize: 12.5, color: Colors.black87)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        color: Colors.white.withValues(alpha: 0.92),
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        child: const Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('ホーム',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.black87)),
                            ),
                            Expanded(
                              child: Text('検索',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.black87)),
                            ),
                            Expanded(
                              child: Text('マイページ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.black87)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // ノッチ
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 96,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(14)),
                    ),
                  ),
                ),
                // ホームインジケータ
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 7),
                    width: 100,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ChoiceChip(
              label: const Text('SafeArea あり'),
              selected: _safe,
              onSelected: (_) => setState(() => _safe = true),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('SafeArea なし'),
              selected: !_safe,
              onSelected: (_) => setState(() => _safe = false),
            ),
          ],
        ),
        DemoOutput(
          _safe
              ? 'ヘッダー/タブがノッチ・ホームインジケータを避けています'
              : 'ヘッダーがノッチに隠れ、タブがホームインジケータと重なっています',
          label: '状態',
        ),
        const DemoNote(
          'Flutter では SafeArea ウィジェットで包むだけ。背景は SafeArea の外側に置き、'
          '操作要素だけを内側に入れるのが正解です。',
        ),
      ],
    );
  }
}

/* ---------------------------------------------------------------- haptics */
class HapticsDemo extends StatefulWidget {
  const HapticsDemo({super.key});
  @override
  State<HapticsDemo> createState() => _HapticsDemoState();
}

class _HapticsDemoState extends State<HapticsDemo> {
  String _log = '';
  bool _on = false;

  void _fire(Future<void> Function() action, String label) {
    action();
    setState(() => _log = '$label を実行しました（実機の対応端末で体感できます）');
  }

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            OutlinedButton(
              onPressed: () =>
                  _fire(HapticFeedback.selectionClick, 'selectionClick（軽い刻み）'),
              child: const Text('軽い刻み'),
            ),
            OutlinedButton(
              onPressed: () =>
                  _fire(HapticFeedback.lightImpact, 'lightImpact'),
              child: const Text('lightImpact'),
            ),
            OutlinedButton(
              onPressed: () =>
                  _fire(HapticFeedback.mediumImpact, 'mediumImpact'),
              child: const Text('mediumImpact'),
            ),
            OutlinedButton(
              onPressed: () =>
                  _fire(HapticFeedback.heavyImpact, 'heavyImpact'),
              child: const Text('heavyImpact'),
            ),
          ],
        ),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _on,
            title: const Text('トグル操作でも軽い触覚が返る',
                style: TextStyle(fontSize: 13.5)),
            onChanged: (bool v) {
              HapticFeedback.selectionClick();
              setState(() {
                _on = v;
                _log = 'トグル切替時に selectionClick を実行しました';
              });
            },
          ),
        ),
        DemoOutput(_log.isEmpty ? 'ボタンを押してください' : _log, label: '結果'),
        const DemoNote(
          'HapticFeedback.selectionClick() / lightImpact() / mediumImpact() / heavyImpact() を'
          '使い分けます。振動はあくまで補助であり、必ず視覚的フィードバックと併用します。',
        ),
      ],
    );
  }
}
