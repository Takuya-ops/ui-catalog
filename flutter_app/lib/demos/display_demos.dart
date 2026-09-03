import 'package:flutter/material.dart';

import '../widgets/common.dart';

/* ------------------------------------------------------------------- card */
class CardDemo extends StatefulWidget {
  const CardDemo({super.key});
  @override
  State<CardDemo> createState() => _CardDemoState();
}

class _CardDemoState extends State<CardDemo> {
  final Set<int> _liked = <int>{};

  static const List<List<String>> _items = <List<String>>[
    <String>['海の見えるコテージ', '¥18,400', '4.92', '128', '🏖️'],
    <String>['古民家リノベの宿', '¥12,000', '4.78', '64', '🏡'],
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        for (int i = 0; i < _items.length; i++)
          AppCard(
            margin: const EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.zero,
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 96,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(13),
                          topRight: Radius.circular(13),
                        ),
                      ),
                      child: Text(_items[i][4],
                          style: const TextStyle(fontSize: 38)),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: IconButton.filledTonal(
                        tooltip: _liked.contains(i) ? 'お気に入りから外す' : 'お気に入りに追加',
                        iconSize: 18,
                        onPressed: () => setState(() {
                          if (!_liked.add(i)) _liked.remove(i);
                        }),
                        icon: Icon(
                          _liked.contains(i)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _liked.contains(i)
                              ? const Color(0xFFE0245E)
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_items[i][0],
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14)),
                      const SizedBox(height: 3),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.star,
                              size: 13, color: Color(0xFFF5A623)),
                          const SizedBox(width: 3),
                          Text('${_items[i][2]}（${_items[i][3]}件）',
                              style: TextStyle(
                                  fontSize: 12, color: scheme.onSurfaceVariant)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                              text: _items[i][1],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            TextSpan(
                              text: ' / 泊',
                              style: TextStyle(
                                  fontSize: 12, color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const DemoNote(
          '画像・タイトル・評価・価格・操作を1つの塊として知覚させるのがカード。'
          'カード全体をタップ可能にする場合、中のボタンとタップ領域が競合しないよう設計します。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------------------- list */
class ListDemo extends StatefulWidget {
  const ListDemo({super.key});
  @override
  State<ListDemo> createState() => _ListDemoState();
}

class _ListDemoState extends State<ListDemo> {
  final Set<int> _read = <int>{2};

  static const List<List<String>> _chats = <List<String>>[
    <String>['1', '佐藤 花子', '明日の打ち合わせ、13時で大丈夫ですか？', '12:04', '2'],
    <String>['2', '開発チーム', 'リリースノートを更新しました', '11:20', '0'],
    <String>['3', '鈴木 一郎', '資料ありがとうございました！', '昨日', '5'],
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              for (int i = 0; i < _chats.length; i++) ...<Widget>[
                if (i > 0) Divider(height: 1, color: scheme.outlineVariant),
                ListTile(
                  onTap: () => setState(() => _read.add(int.parse(_chats[i][0]))),
                  leading: CircleAvatar(
                    backgroundColor: scheme.primary,
                    child: Text(
                      _chats[i][1].substring(0, 1),
                      style: TextStyle(color: scheme.onPrimary, fontSize: 14),
                    ),
                  ),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _chats[i][1],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                !_read.contains(int.parse(_chats[i][0])) &&
                                        _chats[i][4] != '0'
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(_chats[i][3],
                          style:
                              TextStyle(fontSize: 11, color: scheme.outline)),
                    ],
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _chats[i][2],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12.5),
                        ),
                      ),
                      if (!_read.contains(int.parse(_chats[i][0])) &&
                          _chats[i][4] != '0')
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _chats[i][4],
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: scheme.onPrimary),
                          ),
                        ),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right,
                      size: 18, color: scheme.outline),
                ),
              ],
            ],
          ),
        ),
        const DemoNote(
          '行をタップすると既読になります。ListTile（leading / title / subtitle / trailing）が'
          '典型的な行構成そのもの。件数が多いときは ListView.builder で遅延生成します。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------------------ table */
class TableDemo extends StatefulWidget {
  const TableDemo({super.key});
  @override
  State<TableDemo> createState() => _TableDemoState();
}

class _TableDemoState extends State<TableDemo> {
  int _sortColumn = 0;
  bool _asc = true;

  final List<Map<String, Object>> _rows = <Map<String, Object>>[
    <String, Object>{'name': 'ノートPC', 'cat': '電子機器', 'stock': 12, 'price': 128000},
    <String, Object>{'name': 'デスクチェア', 'cat': '家具', 'stock': 3, 'price': 42800},
    <String, Object>{'name': 'モニター 27"', 'cat': '電子機器', 'stock': 0, 'price': 39800},
    <String, Object>{'name': 'キーボード', 'cat': '周辺機器', 'stock': 45, 'price': 12800},
  ];

  List<Map<String, Object>> get _sorted {
    const List<String> keys = <String>['name', 'cat', 'stock', 'price'];
    final String key = keys[_sortColumn];
    final List<Map<String, Object>> list = List<Map<String, Object>>.from(_rows);
    list.sort((Map<String, Object> a, Map<String, Object> b) {
      final Object x = a[key]!;
      final Object y = b[key]!;
      final int r = x is num ? x.compareTo(y as num) : '$x'.compareTo('$y');
      return _asc ? r : -r;
    });
    return list;
  }

  void _onSort(int col, bool asc) => setState(() {
        _sortColumn = col;
        _asc = asc;
      });

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortColumnIndex: _sortColumn,
            sortAscending: _asc,
            columnSpacing: 22,
            headingRowHeight: 42,
            dataRowMinHeight: 40,
            dataRowMaxHeight: 46,
            columns: <DataColumn>[
              DataColumn(
                label: const Text('商品名'),
                onSort: (int i, bool asc) => _onSort(i, asc),
              ),
              DataColumn(
                label: const Text('カテゴリ'),
                onSort: (int i, bool asc) => _onSort(i, asc),
              ),
              DataColumn(
                label: const Text('在庫'),
                numeric: true,
                onSort: (int i, bool asc) => _onSort(i, asc),
              ),
              DataColumn(
                label: const Text('価格'),
                numeric: true,
                onSort: (int i, bool asc) => _onSort(i, asc),
              ),
            ],
            rows: <DataRow>[
              for (final Map<String, Object> r in _sorted)
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('${r['name']}')),
                    DataCell(Text('${r['cat']}')),
                    DataCell(
                      Text(
                        r['stock'] == 0 ? '在庫なし' : '${r['stock']}',
                        style: TextStyle(
                          color: r['stock'] == 0 ? scheme.error : null,
                          fontWeight: r['stock'] == 0
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    DataCell(Text('¥${r['price']}')),
                  ],
                ),
            ],
          ),
        ),
        const DemoNote(
          '列ヘッダをタップすると並べ替えられます（sortColumnIndex / sortAscending）。'
          '数値列は numeric: true で右寄せに。モバイルでは横スクロールにするか、カード形式へ組み替えます。',
        ),
      ],
    );
  }
}

/* ----------------------------------------------------------------- avatar */
class AvatarDemo extends StatefulWidget {
  const AvatarDemo({super.key});
  @override
  State<AvatarDemo> createState() => _AvatarDemoState();
}

class _AvatarDemoState extends State<AvatarDemo> {
  bool _hasImage = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        Wrap(
          spacing: 22,
          runSpacing: 14,
          children: <Widget>[
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: scheme.primary,
                      child: Text('佐',
                          style: TextStyle(
                              color: scheme.onPrimary,
                              fontWeight: FontWeight.w700)),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E8A53),
                          shape: BoxShape.circle,
                          border: Border.all(color: scheme.surface, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const DemoLabel('状態ドット付き'),
              ],
            ),
            Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 24,
                  backgroundColor: _hasImage
                      ? const Color(0xFF0E8A53)
                      : scheme.surfaceContainerHighest,
                  child: _hasImage
                      ? const Text('鈴',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700))
                      : Icon(Icons.person, color: scheme.outline),
                ),
                const SizedBox(height: 4),
                DemoLabel(_hasImage ? 'イニシャル' : '既定アイコン'),
              ],
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                  width: 108,
                  child: Stack(
                    children: <Widget>[
                      for (int i = 0; i < 3; i++)
                        Positioned(
                          left: i * 23,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: scheme.surface,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: <Color>[
                                const Color(0xFF3B5BFD),
                                const Color(0xFF0E8A53),
                                const Color(0xFFB46B00),
                              ][i],
                              child: Text('${i + 1}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ),
                          ),
                        ),
                      Positioned(
                        left: 69,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: scheme.surface,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: scheme.surfaceContainerHighest,
                            child: const Text('+2',
                                style: TextStyle(fontSize: 11)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const DemoLabel('Avatar Group'),
              ],
            ),
          ],
        ),
        OutlinedButton(
          onPressed: () => setState(() => _hasImage = !_hasImage),
          child: const Text('画像の有無を切り替える（フォールバック確認）'),
        ),
        const DemoNote('画像がない場合はイニシャルや既定アイコンへフォールバック。形とサイズは常に一定に保ちます。'),
      ],
    );
  }
}

/* ------------------------------------------------------------------ badge */
class BadgeDemo extends StatefulWidget {
  const BadgeDemo({super.key});
  @override
  State<BadgeDemo> createState() => _BadgeDemoState();
}

class _BadgeDemoState extends State<BadgeDemo> {
  int _count = 3;

  @override
  Widget build(BuildContext context) {
    final String display = _count > 99 ? '99+' : '$_count';
    return DemoStack(
      children: <Widget>[
        Row(
          children: <Widget>[
            Badge(
              isLabelVisible: _count > 0,
              label: Text(display),
              child: const Icon(Icons.notifications_outlined, size: 28),
            ),
            const SizedBox(width: 26),
            Badge(
              isLabelVisible: _count > 0,
              child: const Icon(Icons.notifications_outlined, size: 28),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: DemoLabel('左: 数値バッジ / 右: ドットバッジ'),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          children: <Widget>[
            OutlinedButton(
                onPressed: () => setState(() => _count++), child: const Text('+1')),
            OutlinedButton(
                onPressed: () => setState(() => _count += 50),
                child: const Text('+50')),
            OutlinedButton(
                onPressed: () => setState(() => _count = 0),
                child: const Text('既読にする')),
          ],
        ),
        DemoOutput('$_count（表示: ${_count > 0 ? display : 'なし'}）', label: '件数'),
        const DemoNote('100件を超えたら「99+」に丸めます。件数が重要でないならドットバッジで十分です。'),
      ],
    );
  }
}

/* ------------------------------------------------------------------- chip */
class ChipDemo extends StatefulWidget {
  const ChipDemo({super.key});
  @override
  State<ChipDemo> createState() => _ChipDemoState();
}

class _ChipDemoState extends State<ChipDemo> {
  final Set<String> _on = <String>{'未読'};
  static const List<String> _filters = <String>[
    '未読', '添付あり', 'スター付き', '今週', '重要',
  ];

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              for (final String f in _filters)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(f),
                    selected: _on.contains(f),
                    onSelected: (bool v) => setState(() {
                      if (v) {
                        _on.add(f);
                      } else {
                        _on.remove(f);
                      }
                    }),
                  ),
                ),
            ],
          ),
        ),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            const DemoLabel('適用中:'),
            if (_on.isEmpty) const Text('なし', style: TextStyle(fontSize: 12.5)),
            for (final String f in _on)
              InputChip(
                label: Text(f),
                onDeleted: () => setState(() => _on.remove(f)),
                deleteButtonTooltipMessage: '$f の絞り込みを解除',
              ),
          ],
        ),
        const DemoNote(
          'FilterChip は選択時にチェックアイコンが付くため、色だけに頼らない表現になります。'
          '用途で FilterChip / ChoiceChip / InputChip / ActionChip を使い分けます。',
        ),
      ],
    );
  }
}

/* --------------------------------------------------------------- timeline */
class TimelineDemo extends StatelessWidget {
  const TimelineDemo({super.key});

  static const List<List<String>> _steps = <List<String>>[
    <String>['注文受付', '9/1 10:24', 'done'],
    <String>['発送準備中', '9/1 18:02', 'done'],
    <String>['輸送中', '9/2 07:40', 'done'],
    <String>['配達中', '本日 09:15', 'current'],
    <String>['配達完了', '本日 中に到着予定', 'todo'],
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        Column(
          children: <Widget>[
            for (int i = 0; i < _steps.length; i++)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _steps[i][2] == 'todo'
                                ? scheme.surface
                                : _steps[i][2] == 'current'
                                    ? scheme.primary
                                    : const Color(0xFF0E8A53),
                            border: Border.all(
                              color: _steps[i][2] == 'todo'
                                  ? scheme.outline
                                  : _steps[i][2] == 'current'
                                      ? scheme.primary
                                      : const Color(0xFF0E8A53),
                              width: 2,
                            ),
                          ),
                          child: _steps[i][2] == 'done'
                              ? const Icon(Icons.check,
                                  size: 9, color: Colors.white)
                              : null,
                        ),
                        if (i < _steps.length - 1)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: _steps[i][2] == 'done'
                                  ? const Color(0xFF0E8A53)
                                  : scheme.outlineVariant,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _steps[i][0] +
                                  (_steps[i][2] == 'current' ? '（現在）' : ''),
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: _steps[i][2] == 'current'
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: _steps[i][2] == 'current'
                                    ? scheme.primary
                                    : null,
                              ),
                            ),
                            Text(_steps[i][1],
                                style: TextStyle(
                                    fontSize: 12,
                                    color: scheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const DemoNote('完了／現在／未着手を、色・塗り・チェックの3点で区別。相対時刻だけでなく絶対時刻も併記します。'),
      ],
    );
  }
}

/* -------------------------------------------------------------- accordion */
class AccordionDemo extends StatefulWidget {
  const AccordionDemo({super.key});
  @override
  State<AccordionDemo> createState() => _AccordionDemoState();
}

class _AccordionDemoState extends State<AccordionDemo> {
  static const List<List<String>> _items = <List<String>>[
    <String>['送料はいくらですか？', '3,000円以上のご注文で送料無料です。それ以外は全国一律500円です。'],
    <String>['返品はできますか？', '商品到着後7日以内であれば、未使用に限り返品を承ります。'],
    <String>['支払い方法は？', 'クレジットカード、コンビニ払い、各種QRコード決済に対応しています。'],
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              for (int i = 0; i < _items.length; i++) ...<Widget>[
                if (i > 0) Divider(height: 1, color: scheme.outlineVariant),
                ExpansionTile(
                  initiallyExpanded: i == 0,
                  shape: const Border(),
                  collapsedShape: const Border(),
                  title: Text(
                    _items[i][0],
                    style: const TextStyle(
                        fontSize: 13.5, fontWeight: FontWeight.w700),
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _items[i][1],
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.8,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const DemoNote(
          'Flutter では ExpansionTile が開閉アイコンの回転とアニメーションを標準で持っています。'
          '複数を排他にしたい場合は ExpansionPanelList を使います。',
        ),
      ],
    );
  }
}

/* ---------------------------------------------------------------- tooltip */
class TooltipDemo extends StatelessWidget {
  const TooltipDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        Row(
          children: <Widget>[
            Tooltip(
              message: 'アーカイブ（E）',
              child: OutlinedButton(
                onPressed: () {},
                child: const Icon(Icons.archive_outlined, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'マウスならホバー、タッチなら長押しでツールチップが出ます',
                style: TextStyle(fontSize: 12.5),
              ),
            ),
          ],
        ),
        const DemoNote(
          'Flutter の Tooltip は長押しでも表示されるため、タッチ端末でも機能します。'
          'ただし重要な情報をここだけに入れてはいけません。IconButton なら tooltip 引数が'
          'セマンティクスラベルも兼ねます。',
        ),
      ],
    );
  }
}

/* ---------------------------------------------------------------- popover */
class PopoverDemo extends StatelessWidget {
  const PopoverDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: PopupMenuButton<String>(
            tooltip: '佐藤 花子 のプロフィールを開く',
            position: PopupMenuPosition.under,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                enabled: false,
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: scheme.primary,
                      child: Text('佐',
                          style: TextStyle(color: scheme.onPrimary)),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('佐藤 花子',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14)),
                        Text('プロダクトデザイナー',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'message',
                child: Text('メッセージを送る'),
              ),
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('プロフィールを見る'),
              ),
            ],
            onSelected: (String v) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('選択: $v')),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: scheme.outline),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircleAvatar(
                    radius: 11,
                    backgroundColor: scheme.primary,
                    child: Text('佐',
                        style: TextStyle(
                            fontSize: 10, color: scheme.onPrimary)),
                  ),
                  const SizedBox(width: 8),
                  const Text('佐藤 花子', style: TextStyle(fontSize: 13.5)),
                ],
              ),
            ),
          ),
        ),
        const DemoNote(
          '起点の要素にぶら下がって開くのがポップオーバー。Flutter では PopupMenuButton や '
          'Overlay + CompositedTransformFollower で実装します。外側タップと戻るキーで閉じます。',
        ),
      ],
    );
  }
}

/* --------------------------------------------------------------- carousel */
class CarouselDemo extends StatefulWidget {
  const CarouselDemo({super.key});
  @override
  State<CarouselDemo> createState() => _CarouselDemoState();
}

class _CarouselDemoState extends State<CarouselDemo> {
  final PageController _controller =
      PageController(viewportFraction: 0.62); // 次のカードを覗かせる（peek）
  int _index = 0;

  static const List<String> _items = <String>[
    '🎬 アクション', '😂 コメディ', '👻 ホラー', '💘 ロマンス', '🚀 SF',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        SizedBox(
          height: 110,
          child: PageView.builder(
            controller: _controller,
            itemCount: _items.length,
            onPageChanged: (int i) => setState(() => _index = i),
            itemBuilder: (BuildContext context, int i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  border: Border.all(color: scheme.outlineVariant),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(_items[i],
                    style: const TextStyle(
                        fontSize: 13.5, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              tooltip: '前へ',
              onPressed: _index == 0
                  ? null
                  : () => _controller.previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      ),
              icon: const Icon(Icons.chevron_left),
            ),
            for (int i = 0; i < _items.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                width: i == _index ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == _index ? scheme.primary : scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            IconButton(
              tooltip: '次へ',
              onPressed: _index == _items.length - 1
                  ? null
                  : () => _controller.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      ),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const DemoNote(
          'viewportFraction を1未満にすると次のカードが端から覗き、「まだ続きがある」と伝わります。'
          '自動再生は入れていません（入れる場合は一時停止手段が必須）。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------------ empty-state */
class EmptyStateDemo extends StatefulWidget {
  const EmptyStateDemo({super.key});
  @override
  State<EmptyStateDemo> createState() => _EmptyStateDemoState();
}

class _EmptyStateDemoState extends State<EmptyStateDemo> {
  String _mode = 'first';

  static const Map<String, List<String>> _modes = <String, List<String>>{
    'first': <String>['📝', 'まだメモがありません', '最初のメモを作成して、アイデアを書き留めましょう。', 'メモを作成'],
    'noresult': <String>[
      '🔍', '「経費精算」に一致する結果はありません', 'キーワードを短くするか、フィルタを解除してみてください。', 'フィルタを解除',
    ],
    'done': <String>['🎉', 'すべて完了しました', '今日のタスクは残っていません。お疲れさまでした。', '完了済みを見る'],
  };

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<String> m = _modes[_mode]!;
    return DemoStack(
      children: <Widget>[
        Wrap(
          spacing: 6,
          children: <Widget>[
            for (final MapEntry<String, String> e
                in <String, String>{'first': '初回利用', 'noresult': '検索0件', 'done': '全部完了'}
                    .entries)
              ChoiceChip(
                label: Text(e.value),
                selected: _mode == e.key,
                onSelected: (_) => setState(() => _mode = e.key),
              ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            children: <Widget>[
              Text(m[0], style: const TextStyle(fontSize: 34)),
              const SizedBox(height: 8),
              Text(m[1],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14.5)),
              const SizedBox(height: 6),
              Text(m[2],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.5, color: scheme.onSurfaceVariant)),
              const SizedBox(height: 14),
              FilledButton(onPressed: () {}, child: Text(m[3])),
            ],
          ),
        ),
        const DemoNote('空状態は1種類ではありません。「初回」「0件」「完了」で文言もCTAも変えるのが正解です。'),
      ],
    );
  }
}

/* --------------------------------------------------------------- skeleton */
class SkeletonDemo extends StatefulWidget {
  const SkeletonDemo({super.key});
  @override
  State<SkeletonDemo> createState() => _SkeletonDemoState();
}

class _SkeletonDemoState extends State<SkeletonDemo>
    with SingleTickerProviderStateMixin {
  bool _loading = true;
  late final AnimationController _shimmer = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        AppCard(
          child: _loading
              ? Column(
                  children: <Widget>[
                    for (int i = 0; i < 2; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _Shimmer(
                              controller: _shimmer,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: scheme.surfaceContainerHighest,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _SkelBar(controller: _shimmer, widthFactor: 0.42),
                                  const SizedBox(height: 7),
                                  _SkelBar(controller: _shimmer, widthFactor: 0.92),
                                  const SizedBox(height: 5),
                                  _SkelBar(controller: _shimmer, widthFactor: 0.7),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                )
              : Column(
                  children: <Widget>[
                    for (final List<String> u in <List<String>>[
                      <String>['佐', '佐藤 花子', 'スケルトンと同じ位置・同じ行数で表示されるので、画面が飛びません。'],
                      <String>['鈴', '鈴木 一郎', 'レイアウトシフトが起きないのがスケルトンの最大の価値です。'],
                    ])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: scheme.primary,
                              child: Text(u[0],
                                  style: TextStyle(color: scheme.onPrimary)),
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(u[1],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13.5)),
                                  Text(u[2],
                                      style: TextStyle(
                                          fontSize: 12.5,
                                          color: scheme.onSurfaceVariant)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
        OutlinedButton.icon(
          onPressed: _loading ? null : _reload,
          icon: const Icon(Icons.refresh, size: 17),
          label: const Text('もう一度読み込む'),
        ),
        const DemoNote('スケルトンの形＝実データの形にすること。ズレているとレイアウトシフトが起きます。'),
      ],
    );
  }
}

class _SkelBar extends StatelessWidget {
  const _SkelBar({required this.controller, required this.widthFactor});

  final AnimationController controller;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: _Shimmer(
        controller: controller,
        child: Container(
          height: 11,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  const _Shimmer({required this.controller, required this.child});

  final AnimationController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? c) => Opacity(
        opacity: 0.55 + 0.45 * (1 - (controller.value - 0.5).abs() * 2),
        child: c,
      ),
      child: child,
    );
  }
}

/* ----------------------------------------------------- progress-indicator */
class ProgressIndicatorDemo extends StatefulWidget {
  const ProgressIndicatorDemo({super.key});
  @override
  State<ProgressIndicatorDemo> createState() => _ProgressIndicatorDemoState();
}

class _ProgressIndicatorDemoState extends State<ProgressIndicatorDemo> {
  double _progress = 0;
  bool _running = false;

  Future<void> _start() async {
    setState(() {
      _running = true;
      _progress = 0;
    });
    while (_progress < 1) {
      await Future<void>.delayed(const Duration(milliseconds: 110));
      if (!mounted) return;
      setState(() => _progress = (_progress + 0.05).clamp(0.0, 1.0).toDouble());
    }
    if (mounted) setState(() => _running = false);
  }

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const DemoLabel('確定型（進捗が分かる）'),
            Text('${(_progress * 100).round()}%',
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(value: _progress, minHeight: 8),
        ),
        const Row(
          children: <Widget>[
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            SizedBox(width: 10),
            Expanded(child: DemoLabel('不確定型（所要時間が読めない）')),
          ],
        ),
        Row(
          children: <Widget>[
            FilledButton(
              onPressed: _running ? null : _start,
              child: Text(_running ? 'アップロード中…' : 'アップロード開始'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _progress >= 1
                    ? '✅ アップロードが完了しました'
                    : _running
                        ? '${(_progress * 100).round()}% 完了'
                        : '',
                style: const TextStyle(fontSize: 12.5),
              ),
            ),
          ],
        ),
        const DemoNote(
          'value を渡すと確定型、null にすると不確定型になります。'
          '処理中はボタンを無効化して二重送信を防ぎます。',
        ),
      ],
    );
  }
}
