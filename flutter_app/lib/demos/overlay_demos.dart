import 'package:flutter/material.dart';

import '../widgets/common.dart';

/* ----------------------------------------------------------- modal-dialog */
class ModalDialogDemo extends StatefulWidget {
  const ModalDialogDemo({super.key});
  @override
  State<ModalDialogDemo> createState() => _ModalDialogDemoState();
}

class _ModalDialogDemoState extends State<ModalDialogDemo> {
  String _saved = '';

  Future<void> _open() async {
    final TextEditingController controller = TextEditingController();
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('新しいプロジェクト'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'プロジェクト名',
            hintText: '例: 2026年上期リニューアル',
            border: OutlineInputBorder(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('作成する'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null && result.isNotEmpty && mounted) {
      setState(() => _saved = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        FilledButton(onPressed: _open, child: const Text('プロジェクトを作成（モーダルを開く）')),
        DemoOutput(_saved.isEmpty ? 'まだ作成されていません' : _saved, label: '作成結果'),
        const DemoNote(
          'showDialog はフォーカス管理・背面の暗幕・戻るキーでの閉じるを標準で備えています。'
          'barrierDismissible: false にすると外側タップで閉じなくなります（必ず閉じる手段は別途用意）。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------------ bottom-sheet */
class BottomSheetDemo extends StatelessWidget {
  const BottomSheetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        FilledButton.icon(
          icon: const Icon(Icons.map_outlined, size: 18),
          label: const Text('場所の詳細をボトムシートで開く'),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true, // 高さを自由に取れるようにする
              showDragHandle: true, // ドラッグ用ハンドル（重要な視覚的手がかり）
              builder: (BuildContext context) => DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.42,
                minChildSize: 0.28,
                maxChildSize: 0.9,
                builder: (BuildContext context, ScrollController controller) {
                  return ListView(
                    controller: controller,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    children: <Widget>[
                      const Text('中央公園',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      const Text('★ 4.5（1,204件）· 公園 · 24時間営業',
                          style: TextStyle(fontSize: 12.5)),
                      const SizedBox(height: 14),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.directions, size: 18),
                              label: const Text('経路'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.bookmark_border, size: 18),
                              label: const Text('保存'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        '上へドラッグするとシートが広がり、下へドラッグすると閉じます。\n\n'
                        '背景の文脈（地図）を残したまま情報を重ねられるのがボトムシートの価値です。'
                        '写真・レビュー・営業時間などの詳細がこの下に続きます。',
                        style: TextStyle(fontSize: 13, height: 1.9),
                      ),
                      const SizedBox(height: 400),
                      const Text('（ここが最下部です）',
                          style: TextStyle(fontSize: 12)),
                    ],
                  );
                },
              ),
            );
          },
        ),
        const DemoNote(
          'showModalBottomSheet(isScrollControlled: true) + DraggableScrollableSheet が'
          '「ピーク→半分→全画面」の可変高さシートの定番実装。showDragHandle: true でハンドルが出ます。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------------ action-sheet */
class ActionSheetDemo extends StatefulWidget {
  const ActionSheetDemo({super.key});
  @override
  State<ActionSheetDemo> createState() => _ActionSheetDemoState();
}

class _ActionSheetDemoState extends State<ActionSheetDemo> {
  String _log = '（「…」を押してください）';

  Future<void> _open() async {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String? picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text('IMG_2035.jpg', style: TextStyle(fontSize: 12)),
            ),
            ListTile(
              leading: const Icon(Icons.ios_share),
              title: const Text('共有'),
              onTap: () => Navigator.of(context).pop('共有'),
            ),
            ListTile(
              leading: const Icon(Icons.add_photo_alternate_outlined),
              title: const Text('アルバムに追加'),
              onTap: () => Navigator.of(context).pop('アルバムに追加'),
            ),
            ListTile(
              leading: const Icon(Icons.copy_all_outlined),
              title: const Text('複製'),
              onTap: () => Navigator.of(context).pop('複製'),
            ),
            ListTile(
              // 破壊的操作は色で区別し、下部に置く
              leading: Icon(Icons.delete_outline, color: scheme.error),
              title: Text('写真を削除',
                  style: TextStyle(
                      color: scheme.error, fontWeight: FontWeight.w700)),
              onTap: () => Navigator.of(context).pop('削除'),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('キャンセル'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (picked != null && mounted) setState(() => _log = '選択: $picked');
  }

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        AppCard(
          padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
          child: Row(
            children: <Widget>[
              const Text('📷', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('IMG_2035.jpg', style: TextStyle(fontSize: 13.5)),
              ),
              IconButton(
                tooltip: 'この写真の操作メニューを開く',
                icon: const Icon(Icons.more_vert),
                onPressed: _open,
              ),
            ],
          ),
        ),
        DemoOutput(_log, label: '結果'),
        const DemoNote(
          '破壊的操作は赤字で下部に、キャンセルは区切って分離。'
          'iOS 風にするなら showCupertinoModalPopup + CupertinoActionSheet を使います。',
        ),
      ],
    );
  }
}

/* ---------------------------------------------------------- drawer-overlay */
class DrawerOverlayDemo extends StatefulWidget {
  const DrawerOverlayDemo({super.key});
  @override
  State<DrawerOverlayDemo> createState() => _DrawerOverlayDemoState();
}

class _DrawerOverlayDemoState extends State<DrawerOverlayDemo> {
  double _appliedPrice = 5000;
  Set<String> _appliedCats = <String>{'トップス'};

  Future<void> _openFilter() async {
    double price = _appliedPrice;
    Set<String> cats = <String>{..._appliedCats};

    final bool? applied = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setSheetState) {
          final int count =
              (128 - cats.length * 12 - (price / 500).round()).clamp(0, 999).toInt();
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('絞り込み',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Text('上限価格：¥${price.round()}'),
                Slider(
                  value: price,
                  min: 1000,
                  max: 10000,
                  divisions: 18,
                  label: '¥${price.round()}',
                  onChanged: (double v) => setSheetState(() => price = v),
                ),
                const SizedBox(height: 4),
                const Text('カテゴリ'),
                Wrap(
                  spacing: 6,
                  children: <Widget>[
                    for (final String c
                        in <String>['トップス', 'ボトムス', 'シューズ', 'バッグ'])
                      FilterChip(
                        label: Text(c),
                        selected: cats.contains(c),
                        onSelected: (bool v) => setSheetState(() {
                          if (v) {
                            cats.add(c);
                          } else {
                            cats.remove(c);
                          }
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () => setSheetState(() {
                        price = 10000;
                        cats = <String>{};
                      }),
                      child: const Text('すべてクリア'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          _appliedPrice = price;
                          _appliedCats = cats;
                          Navigator.of(context).pop(true);
                        },
                        // 適用前に結果件数を見せるのがフィルタUIの定石
                        child: Text('$count件を表示'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
    if (applied == true && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        OutlinedButton.icon(
          onPressed: _openFilter,
          icon: const Icon(Icons.filter_list, size: 18),
          label: const Text('絞り込み'),
        ),
        DemoOutput(
          '¥${_appliedPrice.round()}以下 / '
          '${_appliedCats.isEmpty ? '全カテゴリ' : _appliedCats.join('・')}',
          label: '適用中',
        ),
        const DemoNote(
          'モバイルでは横からのドロワーよりボトムシートの方が扱いやすいことが多いです。'
          '適用ボタンに件数を出すと、0件になる前に気づけます。',
        ),
      ],
    );
  }
}

/* --------------------------------------------------------- toast-snackbar */
class ToastSnackbarDemo extends StatefulWidget {
  const ToastSnackbarDemo({super.key});
  @override
  State<ToastSnackbarDemo> createState() => _ToastSnackbarDemoState();
}

class _ToastSnackbarDemoState extends State<ToastSnackbarDemo> {
  final List<String> _mails = <String>['請求書のご確認', '週次レポート', 'イベントのお知らせ'];

  void _archive(String mail) {
    final int index = _mails.indexOf(mail);
    setState(() => _mails.remove(mail));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('「$mail」をアーカイブしました'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: '元に戻す',
          onPressed: () => setState(() => _mails.insert(index, mail)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              if (_mails.isEmpty)
                const ListTile(
                  dense: true,
                  title: Text('メールはありません', style: TextStyle(fontSize: 13)),
                ),
              for (final String m in _mails)
                ListTile(
                  dense: true,
                  title: Text(m, style: const TextStyle(fontSize: 13.5)),
                  trailing: OutlinedButton(
                    onPressed: () => _archive(m),
                    child: const Text('アーカイブ'),
                  ),
                ),
            ],
          ),
        ),
        if (_mails.length < 3)
          OutlinedButton(
            onPressed: () => setState(() {
              _mails
                ..clear()
                ..addAll(<String>['請求書のご確認', '週次レポート', 'イベントのお知らせ']);
            }),
            child: const Text('デモをリセット'),
          ),
        const DemoNote(
          'ScaffoldMessenger.showSnackBar + SnackBarAction が Flutter の標準実装。'
          'Gmail と同じ「削除 → 取り消し」で、確認ダイアログを省略できます。',
        ),
      ],
    );
  }
}

/* ----------------------------------------------------------- alert-banner */
class AlertBannerDemo extends StatefulWidget {
  const AlertBannerDemo({super.key});
  @override
  State<AlertBannerDemo> createState() => _AlertBannerDemoState();
}

class _AlertBannerDemoState extends State<AlertBannerDemo> {
  final Set<String> _dismissed = <String>{};

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<Map<String, Object>> banners = <Map<String, Object>>[
      <String, Object>{
        'id': 'info',
        'color': const Color(0xFF0B6BCB),
        'icon': Icons.info_outline,
        'title': 'メンテナンスのお知らせ',
        'body': '9月10日 2:00〜4:00 に定期メンテナンスを実施します。',
        'dismissible': true,
      },
      <String, Object>{
        'id': 'warn',
        'color': const Color(0xFFB46B00),
        'icon': Icons.warning_amber_outlined,
        'title': 'お支払い方法の有効期限が近づいています',
        'body': '2026年10月末で期限切れになります。更新してください。',
        'action': 'カードを更新',
        'dismissible': false,
      },
      <String, Object>{
        'id': 'err',
        'color': scheme.error,
        'icon': Icons.error_outline,
        'title': '同期に失敗しました',
        'body': 'ネットワーク接続を確認してから、再試行してください。',
        'action': '再試行',
        'dismissible': true,
      },
      <String, Object>{
        'id': 'ok',
        'color': const Color(0xFF0E8A53),
        'icon': Icons.check_circle_outline,
        'title': '設定を保存しました',
        'body': '変更はすべてのデバイスに反映されます。',
        'dismissible': true,
      },
    ];

    return DemoStack(
      children: <Widget>[
        for (final Map<String, Object> b in banners)
          if (!_dismissed.contains(b['id']))
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: (b['color']! as Color).withValues(alpha: 0.08),
                border: Border.all(
                    color: (b['color']! as Color).withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(10),
              ),
              // 左端の太いアクセント線は、辺ごとに色を変えず「内側のバー」で表現する
              child: IntrinsicHeight(
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(width: 4, color: b['color']! as Color),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Icon(b['icon']! as IconData,
                        size: 18, color: b['color']! as Color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${b['title']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13.5)),
                        const SizedBox(height: 2),
                        Text('${b['body']}',
                            style: TextStyle(
                                fontSize: 12.5,
                                height: 1.6,
                                color: scheme.onSurfaceVariant)),
                        if (b['action'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: b['color']! as Color,
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () {},
                              child: Text('${b['action']}'),
                            ),
                          ),
                      ],
                    ),
                    ),
                  ),
                  if (b['dismissible'] == true)
                    IconButton(
                      tooltip: '${b['title']} を閉じる',
                      iconSize: 16,
                      onPressed: () =>
                          setState(() => _dismissed.add('${b['id']}')),
                      icon: const Icon(Icons.close),
                    ),
                ],
              ),
              ),
            ),
        if (_dismissed.isNotEmpty)
          TextButton(
            onPressed: () => setState(() => _dismissed.clear()),
            child: const Text('閉じたバナーを戻す'),
          ),
        const DemoNote(
          '色だけでなくアイコンと見出し文言でも深刻度を伝えます。'
          '解決が必要な警告（2番目）は閉じられない設計にしています。Flutter には MaterialBanner もあります。',
        ),
      ],
    );
  }
}

/* ----------------------------------------------------------- context-menu */
class ContextMenuDemo extends StatefulWidget {
  const ContextMenuDemo({super.key});
  @override
  State<ContextMenuDemo> createState() => _ContextMenuDemoState();
}

class _ContextMenuDemoState extends State<ContextMenuDemo> {
  String _log = '（行を長押し、または「⋮」をタップ）';
  static const List<String> _files = <String>['提案書.pdf', '見積書.xlsx', '議事録.docx'];

  Future<void> _showMenu(String file, Offset position) async {
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
        const PopupMenuItem<String>(value: '開く', child: Text('開く')),
        const PopupMenuItem<String>(value: '名前を変更', child: Text('名前を変更')),
        const PopupMenuItem<String>(value: 'コピーを作成', child: Text('コピーを作成')),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: '削除',
          child: Row(
            children: <Widget>[
              Icon(Icons.delete_outline, size: 17, color: scheme.error),
              const SizedBox(width: 8),
              Text('削除',
                  style: TextStyle(
                      color: scheme.error, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
    if (picked != null && mounted) setState(() => _log = '$file → $picked');
  }

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              for (final String f in _files)
                ListTile(
                  dense: true,
                  leading: const Text('📄', style: TextStyle(fontSize: 17)),
                  title: Text(f, style: const TextStyle(fontSize: 13.5)),
                  onLongPress: () => _showMenu(f, const Offset(80, 260)),
                  trailing: Builder(
                    builder: (BuildContext buttonContext) => IconButton(
                      tooltip: '$f の操作メニュー',
                      icon: const Icon(Icons.more_vert, size: 18),
                      onPressed: () {
                        final RenderBox box =
                            buttonContext.findRenderObject()! as RenderBox;
                        final Offset pos =
                            box.localToGlobal(Offset(0, box.size.height));
                        _showMenu(f, pos);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
        DemoOutput(_log, label: '実行'),
        const DemoNote(
          '長押しだけに頼らず「⋮」ボタンも併設（発見可能性と、長押しが難しい人への配慮）。'
          '破壊的操作は区切り線の下・エラー色にして誤タップを防ぎます。',
        ),
      ],
    );
  }
}
