import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';

/* -------------------------------------------------------------- onboarding */
class OnboardingDemo extends StatefulWidget {
  const OnboardingDemo({super.key});
  @override
  State<OnboardingDemo> createState() => _OnboardingDemoState();
}

class _OnboardingDemoState extends State<OnboardingDemo> {
  final PageController _controller = PageController();
  int _page = 0;
  bool _finished = false;
  final Set<String> _interests = <String>{};

  static const List<List<String>> _slides = <List<String>>[
    <String>['👋', 'ようこそ', 'UI Catalog は、UIの名前と使いどころを学ぶアプリです。'],
    <String>['🎯', '興味のある分野は？', '選んだ内容に合わせて、おすすめのコンポーネントを表示します。'],
    <String>['🔔', '新着をお知らせします', '新しいコンポーネントが追加されたときにお知らせします。あとから変更できます。'],
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    if (_finished) {
      return DemoStack(
        children: <Widget>[
          DemoOutput(
            'オンボーディングを終了しました'
            '（選択: ${_interests.isEmpty ? 'なし' : _interests.join('・')}）',
            label: '完了',
          ),
          OutlinedButton(
            onPressed: () => setState(() {
              _finished = false;
              _page = 0;
              _interests.clear();
              _controller.jumpToPage(0);
            }),
            child: const Text('もう一度見る'),
          ),
        ],
      );
    }

    return DemoStack(
      children: <Widget>[
        PhoneFrame(
          height: 370,
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() => _finished = true),
                  child: const Text('スキップ'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (int i) => setState(() => _page = i),
                  itemBuilder: (BuildContext context, int i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(_slides[i][0],
                            style: const TextStyle(fontSize: 44)),
                        const SizedBox(height: 12),
                        Text(_slides[i][1],
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Text(_slides[i][2],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                height: 1.8,
                                color: scheme.onSurfaceVariant)),
                        if (i == 1) ...<Widget>[
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 6,
                            alignment: WrapAlignment.center,
                            children: <Widget>[
                              for (final String t
                                  in <String>['入力', 'ナビ', '表示', 'モバイル'])
                                FilterChip(
                                  label: Text(t),
                                  selected: _interests.contains(t),
                                  onSelected: (bool v) => setState(() {
                                    if (v) {
                                      _interests.add(t);
                                    } else {
                                      _interests.remove(t);
                                    }
                                  }),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < _slides.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 2.5),
                            width: i == _page ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: i == _page
                                  ? scheme.primary
                                  : scheme.outlineVariant,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        if (_page > 0)
                          OutlinedButton(
                            onPressed: () => _controller.previousPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                            ),
                            child: const Text('戻る'),
                          ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              if (_page == _slides.length - 1) {
                                setState(() => _finished = true);
                              } else {
                                _controller.nextPage(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOut,
                                );
                              }
                            },
                            child: Text(
                                _page == _slides.length - 1 ? 'はじめる' : '次へ'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('${_page + 1} / ${_slides.length}',
                        style:
                            TextStyle(fontSize: 11, color: scheme.outline)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const DemoNote('スキップは常に見える位置に。3枚以内に収め、途中で最初の価値を体験させるのが離脱を防ぐコツ。'),
      ],
    );
  }
}

/* --------------------------------------------------------------- auth-form */
class AuthFormDemo extends StatefulWidget {
  const AuthFormDemo({super.key});
  @override
  State<AuthFormDemo> createState() => _AuthFormDemoState();
}

class _AuthFormDemoState extends State<AuthFormDemo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mail = TextEditingController();
  final TextEditingController _pw = TextEditingController();
  bool _login = true;
  bool _obscure = true;
  bool _loading = false;
  String _error = '';
  String _done = '';

  @override
  void dispose() {
    _mail.dispose();
    _pw.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = '';
      _done = '';
    });
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _loading = false;
      if (_login && _pw.text != 'password1') {
        _error = 'メールアドレスまたはパスワードが正しくありません。入力内容は残しています。';
      } else {
        _done = _login ? 'ログインしました' : 'アカウントを作成しました';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<List<Object>> rules = <List<Object>>[
      <Object>['8文字以上', _pw.text.length >= 8],
      <Object>['数字を含む', RegExp(r'\d').hasMatch(_pw.text)],
      <Object>['英字を含む', RegExp(r'[a-zA-Z]').hasMatch(_pw.text)],
    ];

    return DemoStack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: SegmentedButton<bool>(
            segments: const <ButtonSegment<bool>>[
              ButtonSegment<bool>(value: true, label: Text('ログイン')),
              ButtonSegment<bool>(value: false, label: Text('新規登録')),
            ],
            selected: <bool>{_login},
            onSelectionChanged: (Set<bool> s) => setState(() {
              _login = s.first;
              _error = '';
              _done = '';
            }),
          ),
        ),
        AppCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (_error.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: scheme.errorContainer.withValues(alpha: 0.4),
                      border: Border.all(color: scheme.error),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_error,
                        style: TextStyle(
                            fontSize: 12.5,
                            color: scheme.error,
                            fontWeight: FontWeight.w600)),
                  ),
                if (_done.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E8A53).withValues(alpha: 0.12),
                      border: Border.all(color: const Color(0xFF0E8A53)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('✅ $_done',
                        style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF0E8A53),
                            fontWeight: FontWeight.w700)),
                  ),
                TextFormField(
                  controller: _mail,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'メールアドレス',
                    hintText: 'you@example.com',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'メールアドレスを入力してください';
                    }
                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) {
                      return '「@」を含む形式で入力してください（例: you@example.com）';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _pw,
                  obscureText: _obscure,
                  onChanged: (_) => setState(() {}),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText:
                        'パスワード${_login ? '（デモの正解: password1）' : ''}',
                    border: const OutlineInputBorder(),
                    suffixIcon: TextButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      child: Text(_obscure ? '表示' : '隠す',
                          style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                  validator: (String? v) =>
                      (v == null || v.isEmpty) ? 'パスワードを入力してください' : null,
                ),
                if (!_login)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 12,
                      children: <Widget>[
                        for (final List<Object> r in rules)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                r[1] == true
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                size: 13,
                                color: r[1] == true
                                    ? const Color(0xFF0E8A53)
                                    : scheme.outline,
                              ),
                              const SizedBox(width: 3),
                              Text('${r[0]}',
                                  style: TextStyle(
                                      fontSize: 11.5,
                                      color: r[1] == true
                                          ? const Color(0xFF0E8A53)
                                          : scheme.outline)),
                            ],
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: Text(_loading
                      ? '処理中…'
                      : _login
                          ? 'ログイン'
                          : 'アカウントを作成'),
                ),
                const SizedBox(height: 8),
                Text('または',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: scheme.outline)),
                const SizedBox(height: 8),
                OutlinedButton(
                    onPressed: () {}, child: const Text('Google で続ける')),
              ],
            ),
          ),
        ),
        const DemoNote(
          'パスワードは「確認用にもう1回」ではなく表示切替ボタンで。'
          'Form + TextFormField(validator) と autovalidateMode: onUserInteraction が Flutter の定石です。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------- search-and-filter */
class SearchAndFilterDemo extends StatefulWidget {
  const SearchAndFilterDemo({super.key});
  @override
  State<SearchAndFilterDemo> createState() => _SearchAndFilterDemoState();
}

const List<List<Object>> _products = <List<Object>>[
  <Object>['ワイヤレスイヤホン', '電子機器', 12800, 4.5],
  <Object>['デスクライト', '家具', 4800, 4.1],
  <Object>['ノートPCスタンド', '周辺機器', 3200, 4.7],
  <Object>['メカニカルキーボード', '周辺機器', 15800, 4.3],
  <Object>['オフィスチェア', '家具', 42800, 4.6],
  <Object>['モバイルバッテリー', '電子機器', 3980, 3.9],
];

class _SearchAndFilterDemoState extends State<SearchAndFilterDemo> {
  final TextEditingController _q = TextEditingController();
  final Set<String> _cats = <String>{};
  double _maxPrice = 50000;

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  List<List<Object>> get _results => _products.where((List<Object> p) {
        if (_q.text.isNotEmpty && !'${p[0]}'.contains(_q.text)) return false;
        if (_cats.isNotEmpty && !_cats.contains(p[1])) return false;
        return (p[2] as int) <= _maxPrice;
      }).toList();

  int _catCount(String c) => _products
      .where((List<Object> p) =>
          p[1] == c &&
          (p[2] as int) <= _maxPrice &&
          (_q.text.isEmpty || '${p[0]}'.contains(_q.text)))
      .length;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<List<Object>> results = _results;
    final bool hasFilter =
        _q.text.isNotEmpty || _cats.isNotEmpty || _maxPrice < 50000;

    return DemoStack(
      children: <Widget>[
        TextField(
          controller: _q,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            hintText: '商品名で検索',
            prefixIcon: Icon(Icons.search, size: 20),
            border: OutlineInputBorder(),
          ),
        ),
        Wrap(
          spacing: 6,
          children: <Widget>[
            for (final String c in <String>['電子機器', '家具', '周辺機器'])
              FilterChip(
                label: Text('$c（${_catCount(c)}）'),
                selected: _cats.contains(c),
                // 0件になる条件は選べなくする
                onSelected: _catCount(c) == 0 && !_cats.contains(c)
                    ? null
                    : (bool v) => setState(() {
                          if (v) {
                            _cats.add(c);
                          } else {
                            _cats.remove(c);
                          }
                        }),
              ),
          ],
        ),
        Text('上限価格：¥${_maxPrice.round()}',
            style: const TextStyle(fontSize: 12.5)),
        Slider(
          value: _maxPrice,
          min: 3000,
          max: 50000,
          divisions: 47,
          label: '¥${_maxPrice.round()}',
          onChanged: (double v) => setState(() => _maxPrice = v),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text('${results.length} 件が該当',
                  style: const TextStyle(fontSize: 12.5)),
            ),
            if (hasFilter)
              TextButton(
                onPressed: () => setState(() {
                  _q.clear();
                  _cats.clear();
                  _maxPrice = 50000;
                }),
                child: const Text('すべてクリア'),
              ),
          ],
        ),
        if (results.isEmpty)
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              border: Border.all(color: scheme.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: <Widget>[
                const Text('🔍', style: TextStyle(fontSize: 26)),
                const SizedBox(height: 6),
                const Text('条件に合う商品がありません',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => setState(() {
                    _cats.clear();
                    _maxPrice = 50000;
                  }),
                  child: const Text('絞り込みを緩める'),
                ),
              ],
            ),
          )
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                for (final List<Object> p in results)
                  ListTile(
                    dense: true,
                    title: Text('${p[0]}',
                        style: const TextStyle(fontSize: 13.5)),
                    subtitle: Text('${p[1]} · ★${p[3]}',
                        style: const TextStyle(fontSize: 11.5)),
                    trailing: Text('¥${p[2]}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13.5)),
                  ),
              ],
            ),
          ),
        const DemoNote(
          '各カテゴリチップに該当件数を表示し、0件になる条件は選べなくしています（0件地獄の予防）。'
          '適用中の条件はすべて画面に見えていて、「すべてクリア」がいつでも押せます。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------------------- sort */
class SortDemo extends StatefulWidget {
  const SortDemo({super.key});
  @override
  State<SortDemo> createState() => _SortDemoState();
}

class _SortDemoState extends State<SortDemo> {
  String _sort = 'recommended';

  static const Map<String, String> _options = <String, String>{
    'recommended': 'おすすめ順',
    'price_asc': '価格の安い順',
    'price_desc': '価格の高い順',
    'rating': '評価の高い順',
  };

  List<List<Object>> get _sorted {
    final List<List<Object>> list = List<List<Object>>.from(_products);
    switch (_sort) {
      case 'price_asc':
        list.sort((List<Object> a, List<Object> b) =>
            (a[2] as int).compareTo(b[2] as int));
      case 'price_desc':
        list.sort((List<Object> a, List<Object> b) =>
            (b[2] as int).compareTo(a[2] as int));
      case 'rating':
        list.sort((List<Object> a, List<Object> b) =>
            (b[3] as double).compareTo(a[3] as double));
      default:
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text('${_products.length}件の商品',
                  style: const TextStyle(fontSize: 12.5)),
            ),
            DropdownButton<String>(
              value: _sort,
              underline: const SizedBox.shrink(),
              items: <DropdownMenuItem<String>>[
                for (final MapEntry<String, String> e in _options.entries)
                  DropdownMenuItem<String>(
                    value: e.key,
                    child: Text(e.value, style: const TextStyle(fontSize: 13)),
                  ),
              ],
              onChanged: (String? v) => setState(() => _sort = v ?? 'recommended'),
            ),
          ],
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              for (int i = 0; i < _sorted.length; i++)
                ListTile(
                  dense: true,
                  leading: Text('${i + 1}',
                      style: const TextStyle(fontSize: 12)),
                  title: Text('${_sorted[i][0]}',
                      style: const TextStyle(fontSize: 13.5)),
                  subtitle: Text('★${_sorted[i][3]}',
                      style: const TextStyle(fontSize: 11.5)),
                  trailing: Text('¥${_sorted[i][2]}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 13.5)),
                ),
            ],
          ),
        ),
        DemoOutput(_options[_sort]!, label: '現在の並び順'),
        const DemoNote('現在の並び順を必ず画面に表示すること。ソートを変えてもフィルタ条件は保持します。'),
      ],
    );
  }
}

/* ------------------------------------------------------------------- undo */
class UndoDemo extends StatefulWidget {
  const UndoDemo({super.key});
  @override
  State<UndoDemo> createState() => _UndoDemoState();
}

class _UndoDemoState extends State<UndoDemo> {
  List<String> _tasks = <String>['週次レポートを書く', 'デザインレビュー', '請求書を送付'];

  void _remove(String task) {
    final int index = _tasks.indexOf(task);
    setState(() => _tasks = List<String>.from(_tasks)..remove(task));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('「$task」を削除しました'),
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: '元に戻す',
          onPressed: () => setState(
              () => _tasks = List<String>.from(_tasks)..insert(index, task)),
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
              if (_tasks.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(18),
                  child: Text('タスクはありません'),
                ),
              for (final String t in _tasks)
                ListTile(
                  dense: true,
                  title: Text(t, style: const TextStyle(fontSize: 13.5)),
                  trailing: IconButton(
                    tooltip: '$t を削除',
                    icon: Icon(Icons.delete_outline,
                        size: 18, color: scheme.error),
                    onPressed: () => _remove(t),
                  ),
                ),
            ],
          ),
        ),
        if (_tasks.length < 3)
          OutlinedButton(
            onPressed: () => setState(() => _tasks = <String>[
                  '週次レポートを書く',
                  'デザインレビュー',
                  '請求書を送付',
                ]),
            child: const Text('デモをリセット'),
          ),
        const DemoNote(
          '確認ダイアログを出さずに削除し、6秒間だけ取り消せるようにしています。'
          '実装のコツは「削除ボタンを押した時点ではサーバへ送らず、猶予時間の経過後に確定する」こと。',
        ),
      ],
    );
  }
}

/* --------------------------------------------------------- confirm-dialog */
class ConfirmDialogDemo extends StatefulWidget {
  const ConfirmDialogDemo({super.key});
  @override
  State<ConfirmDialogDemo> createState() => _ConfirmDialogDemoState();
}

class _ConfirmDialogDemoState extends State<ConfirmDialogDemo> {
  String _log = '';

  Future<void> _confirm() async {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('アカウントを解約しますか？'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('解約すると、以下がすべて失われます。',
                style: TextStyle(fontSize: 13)),
            SizedBox(height: 8),
            Text('・保存済みのプロジェクト 24件\n'
                '・チームメンバーの共有設定\n'
                '・残り18日分の利用期間（返金はありません）',
                style: TextStyle(fontSize: 12.5, height: 1.8)),
          ],
        ),
        actions: <Widget>[
          // 初期フォーカスは安全な選択肢側に置く
          TextButton(
            autofocus: true,
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('解約しない'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: scheme.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('解約する'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    setState(() => _log = ok == true ? 'アカウントを解約しました' : 'キャンセルしました');
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: scheme.error, foregroundColor: scheme.onError),
          onPressed: _confirm,
          child: const Text('アカウントを解約する'),
        ),
        DemoOutput(_log.isEmpty ? '未実行' : _log, label: '結果'),
        const DemoNote(
          '「OK / キャンセル」ではなく「解約する / 解約しない」と動詞で。'
          '何が失われるかを具体的に列挙し、初期フォーカスは安全な側に置きます。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------- validation-error */
class ValidationErrorDemo extends StatefulWidget {
  const ValidationErrorDemo({super.key});
  @override
  State<ValidationErrorDemo> createState() => _ValidationErrorDemoState();
}

class _ValidationErrorDemoState extends State<ValidationErrorDemo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _mail = TextEditingController();
  final TextEditingController _tel = TextEditingController();
  bool _agree = false;
  bool _submitted = false;

  @override
  void dispose() {
    _name.dispose();
    _mail.dispose();
    _tel.dispose();
    super.dispose();
  }

  /// 全角数字・ハイフンを弾かずに正規化する（受け取ってから整える）
  String _normalize(String s) {
    final StringBuffer buffer = StringBuffer();
    for (final int code in s.runes) {
      if (code >= 0xFF10 && code <= 0xFF19) {
        buffer.writeCharCode(code - 0xFEE0);
      } else if (code != 0x2D && code != 0x20) {
        buffer.writeCharCode(code);
      }
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        AppCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (_submitted && !_agree)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: scheme.errorContainer.withValues(alpha: 0.4),
                      border: Border.all(color: scheme.error),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('入力エラーがあります：利用規約への同意が必要です',
                        style: TextStyle(
                            fontSize: 12.5,
                            color: scheme.error,
                            fontWeight: FontWeight.w700)),
                  ),
                TextFormField(
                  controller: _name,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'お名前 *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? v) =>
                      (v == null || v.trim().isEmpty) ? 'お名前を入力してください' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _mail,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'メールアドレス *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'メールアドレスを入力してください';
                    }
                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) {
                      return '「@」を含む形式で入力してください（例: you@example.com）';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _tel,
                  keyboardType: TextInputType.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: '電話番号',
                    hintText: '090-1234-5678',
                    helperText: 'ハイフン・全角数字はこちらで自動的に整形します',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? v) {
                    if (v == null || v.isEmpty) return null;
                    final String n = _normalize(v);
                    return RegExp(r'^0\d{9,10}$').hasMatch(n)
                        ? null
                        : '電話番号は10〜11桁の数字で入力してください';
                  },
                ),
                CheckboxListTile(
                  value: _agree,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('利用規約に同意します *',
                      style: TextStyle(fontSize: 13)),
                  subtitle: _submitted && !_agree
                      ? Text('✕ 利用規約への同意が必要です',
                          style: TextStyle(fontSize: 11.5, color: scheme.error))
                      : null,
                  onChanged: (bool? v) => setState(() => _agree = v ?? false),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() => _submitted = true);
                    final bool ok =
                        (_formKey.currentState?.validate() ?? false) && _agree;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(ok ? '送信しました' : '入力内容を確認してください'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('送信する'),
                ),
              ],
            ),
          ),
        ),
        const DemoNote(
          'autovalidateMode: onUserInteraction なら、入力途中の1文字目から赤くならず、'
          '一度触った後にリアルタイム検証されます。電話番号のハイフンや全角数字は弾かずに正規化します。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------------ three-states */
class ThreeStatesDemo extends StatefulWidget {
  const ThreeStatesDemo({super.key});
  @override
  State<ThreeStatesDemo> createState() => _ThreeStatesDemoState();
}

class _ThreeStatesDemoState extends State<ThreeStatesDemo> {
  String _state = 'loading';

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _state = 'success');
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        Wrap(
          spacing: 6,
          children: <Widget>[
            for (final MapEntry<String, String> e in const <String, String>{
              'loading': '読み込み中',
              'success': '成功',
              'empty': '空（0件）',
              'error': 'エラー',
            }.entries)
              ChoiceChip(
                label: Text(e.value),
                selected: _state == e.key,
                onSelected: (_) => setState(() => _state = e.key),
              ),
          ],
        ),
        Container(
          height: 200,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: switch (_state) {
            'loading' => const Center(child: CircularProgressIndicator()),
            'success' => Column(
                children: <Widget>[
                  for (final String t in <String>['プロジェクトA', 'プロジェクトB', 'プロジェクトC'])
                    ListTile(
                      dense: true,
                      title: Text(t, style: const TextStyle(fontSize: 13.5)),
                      trailing: const Icon(Icons.chevron_right, size: 18),
                    ),
                ],
              ),
            'empty' => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('📂', style: TextStyle(fontSize: 30)),
                    const SizedBox(height: 8),
                    const Text('プロジェクトがまだありません',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('最初のプロジェクトを作成して始めましょう。',
                        style: TextStyle(
                            fontSize: 12.5, color: scheme.onSurfaceVariant)),
                    const SizedBox(height: 12),
                    FilledButton(
                        onPressed: () {}, child: const Text('プロジェクトを作成')),
                  ],
                ),
              ),
            _ => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.error_outline, size: 32, color: scheme.error),
                    const SizedBox(height: 8),
                    const Text('データを読み込めませんでした',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('ネットワーク接続を確認してください。',
                        style: TextStyle(
                            fontSize: 12.5, color: scheme.onSurfaceVariant)),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () {
                        setState(() => _state = 'loading');
                        Future<void>.delayed(
                          const Duration(seconds: 1),
                          () {
                            if (mounted) setState(() => _state = 'success');
                          },
                        );
                      },
                      icon: const Icon(Icons.refresh, size: 17),
                      label: const Text('再試行'),
                    ),
                  ],
                ),
              ),
          },
        ),
        const DemoNote(
          '4つの状態を切り替えてみてください。「エラー」と「空」を混同しないのが最重要。'
          'FutureBuilder では connectionState / hasError / データ0件 の3分岐を必ず書きます。',
        ),
      ],
    );
  }
}

/* -------------------------------------------------------- dark-mode-toggle */
class DarkModeToggleDemo extends StatelessWidget {
  const DarkModeToggleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController controller = ThemeScope.of(context);
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: SegmentedButton<ThemeMode>(
            segments: const <ButtonSegment<ThemeMode>>[
              ButtonSegment<ThemeMode>(
                  value: ThemeMode.light, label: Text('ライト')),
              ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark, label: Text('ダーク')),
              ButtonSegment<ThemeMode>(
                  value: ThemeMode.system, label: Text('システム')),
            ],
            selected: <ThemeMode>{controller.mode},
            onSelectionChanged: (Set<ThemeMode> s) => controller.set(s.first),
          ),
        ),
        DemoOutput(
          '${controller.label}（この切り替えはアプリ全体に即座に反映されます）',
          label: '現在',
        ),
        Row(
          children: <Widget>[
            for (final List<Object> t in <List<Object>>[
              <Object>['本文テキスト', scheme.onSurface, scheme.surface],
              <Object>['補助テキスト', scheme.onSurfaceVariant, scheme.surface],
              <Object>['アクセント', scheme.onPrimary, scheme.primary],
            ])
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: t[2] as Color,
                    border: Border.all(color: scheme.outlineVariant),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${t[0]}',
                      style: TextStyle(fontSize: 11.5, color: t[1] as Color)),
                ),
              ),
          ],
        ),
        const DemoNote(
          '3択（ライト／ダーク／システム連動）が現代の標準。Flutter では '
          'MaterialApp(theme:, darkTheme:, themeMode:) と ColorScheme.fromSeed で'
          '両モードの色を一貫して生成できます。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------- permission-prompt */
class PermissionPromptDemo extends StatefulWidget {
  const PermissionPromptDemo({super.key});
  @override
  State<PermissionPromptDemo> createState() => _PermissionPromptDemoState();
}

class _PermissionPromptDemoState extends State<PermissionPromptDemo> {
  String _status = 'idle';

  Future<void> _flow() async {
    // 1) まず自社のプライミング画面で理由を説明する
    final bool? wants = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        icon: const Icon(Icons.notifications_active_outlined, size: 30),
        title: const Text('返信をすぐ受け取りませんか？', textAlign: TextAlign.center),
        content: const Text(
          '通知をオンにすると、新しいメッセージが届いたときにお知らせします。'
          'あとから設定で変更できます。',
          style: TextStyle(fontSize: 13, height: 1.7),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('今はしない'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('オンにする'),
          ),
        ],
      ),
    );
    if (wants != true) {
      if (mounted) setState(() => _status = 'denied');
      return;
    }
    if (!mounted) return;

    // 2) その後で OS の許可ダイアログを出す（1度しか出せない貴重な機会）
    final bool? granted = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('“ChatApp”は通知を送信します。よろしいですか？',
            style: TextStyle(fontSize: 15)),
        content: const Text('通知方法：テキスト、サウンド、アイコンバッジ',
            style: TextStyle(fontSize: 12.5)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('許可しない'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('許可',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (mounted) {
      setState(() => _status = granted == true ? 'granted' : 'denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('チャット',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              const SizedBox(height: 8),
              for (final String m in <String>['佐藤さん: 資料できました', '鈴木さん: 了解です！'])
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(m, style: const TextStyle(fontSize: 12.5)),
                ),
              const SizedBox(height: 8),
              if (_status == 'idle')
                FilledButton(
                  onPressed: _flow,
                  child: const Text('3通目を受け取る（ここで初めて通知を求める）'),
                ),
              if (_status == 'granted')
                Text('✅ 通知が有効になりました',
                    style: const TextStyle(
                        color: Color(0xFF0E8A53), fontWeight: FontWeight.w700)),
              if (_status == 'denied')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('通知はオフのままです。アプリ内バッジでお知らせします。',
                        style: TextStyle(
                            fontSize: 12.5, color: scheme.onSurfaceVariant)),
                    TextButton(
                      onPressed: () => setState(() => _status = 'idle'),
                      child: const Text('デモをやり直す'),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const DemoNote(
          '起動直後ではなく「価値を体験した後」に、まず自社のプライミング画面で理由を説明してから'
          'OS ダイアログを出します。「今はしない」なら OS の許可は消費されず、後から再度求められます。',
        ),
      ],
    );
  }
}
