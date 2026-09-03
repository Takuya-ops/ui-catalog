import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/common.dart';

/* ------------------------------------------------------------- text-field */
class TextFieldDemo extends StatefulWidget {
  const TextFieldDemo({super.key});
  @override
  State<TextFieldDemo> createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  final TextEditingController _c = TextEditingController();
  final FocusNode _focus = FocusNode();
  bool _touched = false;
  String _value = '';

  @override
  void initState() {
    super.initState();
    // blur（フォーカスを外した時）に初めて検証する
    _focus.addListener(() {
      if (!_focus.hasFocus) setState(() => _touched = true);
    });
  }

  @override
  void dispose() {
    _c.dispose();
    _focus.dispose();
    super.dispose();
  }

  bool get _invalid =>
      _touched &&
      _value.isNotEmpty &&
      !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(_value);

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        TextField(
          controller: _c,
          focusNode: _focus,
          keyboardType: TextInputType.emailAddress,
          onChanged: (String v) => setState(() => _value = v),
          decoration: InputDecoration(
            labelText: 'メールアドレス',
            hintText: 'you@example.com',
            helperText: _invalid ? null : 'ログインIDとして使用します',
            errorText: _invalid ? '「@」を含む形式で入力してください（例: you@example.com）' : null,
            border: const OutlineInputBorder(),
          ),
        ),
        DemoOutput(_value.isEmpty ? '（未入力）' : _value, label: '入力値'),
        const DemoNote(
          'ラベル・ヘルプ・エラーの3点セット。エラーはフォーカスを外した（blur）タイミングで初めて出しています。'
          '入力中の1文字目から赤くしないのがポイント。',
        ),
      ],
    );
  }
}

/* --------------------------------------------------------------- textarea */
class TextareaDemo extends StatefulWidget {
  const TextareaDemo({super.key});
  @override
  State<TextareaDemo> createState() => _TextareaDemoState();
}

class _TextareaDemoState extends State<TextareaDemo> {
  final TextEditingController _c = TextEditingController();
  static const int _max = 140;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int len = _c.text.length;
    final bool over = len > _max;
    return DemoStack(
      children: <Widget>[
        TextField(
          controller: _c,
          maxLines: null,
          minLines: 3,
          keyboardType: TextInputType.multiline,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: '投稿本文',
            hintText: 'いま何してる？',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const DemoLabel('入力に合わせて高さが伸びます'),
            Text(
              '$len / $_max',
              style: TextStyle(
                fontSize: 12,
                fontWeight: over ? FontWeight.w700 : FontWeight.w400,
                color: over
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
        FilledButton(
          onPressed: over || len == 0 ? null : () {},
          child: const Text('投稿する'),
        ),
        const DemoNote('超過分は切り捨てず、赤く見せてユーザーに削らせます（切り捨ては書いた内容を黙って失わせる最悪の挙動）。'),
      ],
    );
  }
}

/* --------------------------------------------------------------- checkbox */
class CheckboxDemo extends StatefulWidget {
  const CheckboxDemo({super.key});
  @override
  State<CheckboxDemo> createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<CheckboxDemo> {
  static const List<String> _options = <String>['送料無料', '当日配送', 'セール対象', '新品のみ'];
  final Set<String> _checked = <String>{'送料無料'};

  bool? get _allValue {
    if (_checked.length == _options.length) return true;
    if (_checked.isEmpty) return false;
    return null; // 中間状態（indeterminate）
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outlineVariant),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: <Widget>[
              CheckboxListTile(
                value: _allValue,
                tristate: true,
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  'すべて選択${_allValue == null ? '（一部選択中）' : ''}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13.5),
                ),
                onChanged: (bool? v) => setState(() {
                  if (_checked.length == _options.length) {
                    _checked.clear();
                  } else {
                    _checked
                      ..clear()
                      ..addAll(_options);
                  }
                }),
              ),
              Divider(height: 1, color: scheme.outlineVariant),
              for (final String o in _options)
                CheckboxListTile(
                  value: _checked.contains(o),
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(o, style: const TextStyle(fontSize: 14)),
                  onChanged: (bool? v) => setState(() {
                    if (v ?? false) {
                      _checked.add(o);
                    } else {
                      _checked.remove(o);
                    }
                  }),
                ),
            ],
          ),
        ),
        DemoOutput(
          _checked.isEmpty ? 'なし（0個でも成立するのがチェックボックス）' : _checked.join(' / '),
          label: '選択中',
        ),
        const DemoNote(
          '親チェックの「一部選択中」が tristate（中間状態）。CheckboxListTile なら行全体がタップ領域になります。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------------------ radio */
class RadioDemo extends StatefulWidget {
  const RadioDemo({super.key});
  @override
  State<RadioDemo> createState() => _RadioDemoState();
}

class _RadioDemoState extends State<RadioDemo> {
  String _selected = 'std';

  static const List<List<String>> _plans = <List<String>>[
    <String>['std', '通常配送', '3〜5日で到着', '無料'],
    <String>['exp', 'お急ぎ便', '翌日までに到着', '+500円'],
    <String>['day', '日時指定便', '希望日時を指定', '+800円'],
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        const DemoLabel('配送方法を選択'),
        // Flutter 3.32 以降は RadioGroup で「どのグループか」をまとめて指定する
        RadioGroup<String>(
          groupValue: _selected,
          onChanged: (String? v) => setState(() => _selected = v ?? 'std'),
          child: Column(
            spacing: 8,
            children: <Widget>[
        for (final List<String> p in _plans)
          // 背景色は Material に塗らせる（Container の decoration で塗ると
          // RadioListTile の波紋が隠れてしまう）
          Material(
            color: _selected == p[0]
                ? scheme.primaryContainer
                : scheme.surface,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color:
                    _selected == p[0] ? scheme.primary : scheme.outlineVariant,
              ),
            ),
            child: RadioListTile<String>(
              value: p[0],
              dense: true,
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      p[1],
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
                  Text(
                    p[3],
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ],
              ),
              subtitle: Text(p[2], style: const TextStyle(fontSize: 12.5)),
            ),
          ),
            ],
          ),
        ),
        const DemoNote('選択肢が全部見えているので比較できます。行全体がタップ領域（RadioListTile）。'),
      ],
    );
  }
}

/* ---------------------------------------------------------- toggle-switch */
class ToggleSwitchDemo extends StatefulWidget {
  const ToggleSwitchDemo({super.key});
  @override
  State<ToggleSwitchDemo> createState() => _ToggleSwitchDemoState();
}

class _ToggleSwitchDemoState extends State<ToggleSwitchDemo> {
  bool _notify = true;
  bool _sound = false;
  bool _saving = false;
  String _log = '（切り替えると即座に反映されます）';

  Future<void> _changeNotify(bool v) async {
    setState(() {
      _notify = v;
      _saving = true;
      _log = 'サーバーへ保存中…';
    });
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _saving = false;
      _log = '通知を「${v ? 'ON' : 'OFF'}」で保存しました（保存ボタンは不要）';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outlineVariant),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: <Widget>[
              SwitchListTile(
                value: _notify,
                title: const Text('プッシュ通知'),
                onChanged: _saving ? null : _changeNotify,
              ),
              Divider(height: 1, color: scheme.outlineVariant),
              SwitchListTile(
                value: _sound,
                title: const Text('サウンド'),
                onChanged: (bool v) => setState(() => _sound = v),
              ),
            ],
          ),
        ),
        DemoOutput(_log, label: '状態'),
        const DemoNote(
          'トグルは「押した瞬間に効く」もの。通信中は onChanged: null で無効化して二度押しを防いでいます。'
          '保存ボタンを押して初めて反映されるなら、チェックボックスを使うべきです。',
        ),
      ],
    );
  }
}

/* ----------------------------------------------------------------- slider */
class SliderDemo extends StatefulWidget {
  const SliderDemo({super.key});
  @override
  State<SliderDemo> createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo> {
  double _volume = 60;
  RangeValues _price = const RangeValues(2000, 8000);

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        const DemoLabel('音量'),
        Row(
          children: <Widget>[
            Expanded(
              child: Slider(
                value: _volume,
                max: 100,
                divisions: 20,
                label: '${_volume.round()}%',
                onChanged: (double v) => setState(() => _volume = v),
              ),
            ),
            SizedBox(
              width: 46,
              child: Text('${_volume.round()}%',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const DemoLabel('価格帯（レンジスライダー）'),
        RangeSlider(
          values: _price,
          min: 0,
          max: 10000,
          divisions: 20,
          labels: RangeLabels(
            '¥${_price.start.round()}',
            '¥${_price.end.round()}',
          ),
          onChanged: (RangeValues v) => setState(() => _price = v),
        ),
        DemoOutput(
          '¥${_price.start.round()} 〜 ¥${_price.end.round()}',
          label: '絞り込み',
        ),
        const DemoNote('現在値を必ず数値でも表示すること。divisions で刻みを、label でつまみ上の値を指定できます。'),
      ],
    );
  }
}

/* ---------------------------------------------------------- stepper-input */
class StepperInputDemo extends StatefulWidget {
  const StepperInputDemo({super.key});
  @override
  State<StepperInputDemo> createState() => _StepperInputDemoState();
}

class _StepperInputDemoState extends State<StepperInputDemo> {
  int _qty = 1;
  static const int _max = 5;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        AppCard(
          child: Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('🍱', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('日替わり弁当',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    Text('¥880 / 個（お一人様 5 個まで）',
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              IconButton.outlined(
                tooltip: '数量を1つ減らす',
                onPressed: _qty <= 0 ? null : () => setState(() => _qty--),
                icon: const Icon(Icons.remove, size: 18),
              ),
              SizedBox(
                width: 34,
                child: Text(
                  '$_qty',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
              IconButton.outlined(
                tooltip: '数量を1つ増やす',
                onPressed: _qty >= _max ? null : () => setState(() => _qty++),
                icon: const Icon(Icons.add, size: 18),
              ),
            ],
          ),
        ),
        DemoOutput(
          '¥${_qty * 880}${_qty >= _max ? '（上限に達しました）' : ''}',
          label: '小計',
        ),
        const DemoNote('上限・下限に達したらボタンを無効化（onPressed: null）。各ボタンに tooltip で名前を与えます。'),
      ],
    );
  }
}

/* ----------------------------------------------------------------- select */
class SelectDemo extends StatefulWidget {
  const SelectDemo({super.key});
  @override
  State<SelectDemo> createState() => _SelectDemoState();
}

class _SelectDemoState extends State<SelectDemo> {
  String? _pref;

  static const List<String> _prefectures = <String>[
    '北海道', '青森県', '岩手県', '宮城県', '秋田県', '山形県', '福島県',
    '茨城県', '栃木県', '群馬県', '埼玉県', '千葉県', '東京都', '神奈川県',
    '新潟県', '富山県', '石川県', '福井県', '山梨県', '長野県',
  ];

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        DropdownButtonFormField<String>(
          initialValue: _pref,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: '都道府県',
            border: OutlineInputBorder(),
            helperText: '選択肢が多いときは、畳んで省スペースにする',
          ),
          hint: const Text('選択してください'),
          items: <DropdownMenuItem<String>>[
            for (final String p in _prefectures)
              DropdownMenuItem<String>(value: p, child: Text(p)),
          ],
          onChanged: (String? v) => setState(() => _pref = v),
        ),
        DemoOutput(_pref ?? '未選択', label: '選択値'),
        const DemoNote(
          'モバイルでは DropdownButton の他に、showModalBottomSheet でのリスト選択や '
          'CupertinoPicker（ホイール）も有力な選択肢です。',
        ),
      ],
    );
  }
}

/* ----------------------------------------------------------- autocomplete */
class AutocompleteDemo extends StatefulWidget {
  const AutocompleteDemo({super.key});
  @override
  State<AutocompleteDemo> createState() => _AutocompleteDemoState();
}

class _AutocompleteDemoState extends State<AutocompleteDemo> {
  static const List<String> _fruits = <String>[
    'りんご', 'いちご', 'みかん', 'ぶどう', 'もも', 'なし',
    'メロン', 'すいか', 'バナナ', 'キウイ', 'マンゴー', 'パイナップル',
  ];
  String _selected = '';

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue value) {
            if (value.text.isEmpty) return _fruits;
            return _fruits.where((String f) => f.contains(value.text));
          },
          onSelected: (String v) => setState(() => _selected = v),
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController controller,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              onSubmitted: (_) => onFieldSubmitted(),
              decoration: const InputDecoration(
                labelText: '好きな果物',
                hintText: '入力すると候補が絞り込まれます',
                prefixIcon: Icon(Icons.search, size: 20),
                border: OutlineInputBorder(),
              ),
            );
          },
        ),
        DemoOutput(_selected.isEmpty ? '未確定' : _selected, label: '確定値'),
        const DemoNote(
          'Flutter の Autocomplete<T> は候補の絞り込みとオーバーレイ表示を担当します。'
          '実サービスではデバウンス（入力が止まってから検索）と、古いレスポンスの破棄が必須です。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------- date-time-picker */
class DateTimePickerDemo extends StatefulWidget {
  const DateTimePickerDemo({super.key});
  @override
  State<DateTimePickerDemo> createState() => _DateTimePickerDemoState();
}

class _DateTimePickerDemoState extends State<DateTimePickerDemo> {
  DateTimeRange? _range;
  TimeOfDay _time = const TimeOfDay(hour: 19, minute: 0);

  Future<void> _pickRange() async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: _range,
      helpText: '宿泊期間を選択',
      saveText: '決定',
    );
    if (picked != null) setState(() => _range = picked);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  String _fmt(DateTime d) =>
      '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final DateTimeRange? r = _range;
    return DemoStack(
      children: <Widget>[
        OutlinedButton.icon(
          onPressed: _pickRange,
          icon: const Icon(Icons.calendar_month_outlined, size: 18),
          label: Text(
            r == null ? 'チェックイン / チェックアウトを選ぶ' : '${_fmt(r.start)} 〜 ${_fmt(r.end)}',
          ),
        ),
        OutlinedButton.icon(
          onPressed: _pickTime,
          icon: const Icon(Icons.schedule, size: 18),
          label: Text('到着予定時刻: ${_time.format(context)}'),
        ),
        DemoOutput(
          r == null
              ? '日付を選択してください'
              : '${_fmt(r.start)} 〜 ${_fmt(r.end)}（${r.duration.inDays}泊） / 到着 ${_time.format(context)}',
          label: '予約内容',
        ),
        const DemoNote(
          'showDateRangePicker は firstDate 以降しか選べないため、過去日や逆転した期間を構造的に防げます。'
          'テキスト入力も併用できるとキーボード派に親切です。',
        ),
      ],
    );
  }
}

/* -------------------------------------------------------- file-uploader */
class FileUploaderDemo extends StatefulWidget {
  const FileUploaderDemo({super.key});
  @override
  State<FileUploaderDemo> createState() => _FileUploaderDemoState();
}

class _UploadItem {
  _UploadItem(this.name, this.sizeKb, {this.error});
  final String name;
  final int sizeKb;
  final String? error;
  double progress = 0;
}

class _FileUploaderDemoState extends State<FileUploaderDemo> {
  final List<_UploadItem> _files = <_UploadItem>[];
  int _counter = 0;

  Future<void> _add({bool tooBig = false}) async {
    _counter++;
    final _UploadItem item = _UploadItem(
      'IMG_${1000 + _counter}.jpg',
      tooBig ? 3200 : 480,
      error: tooBig ? 'サイズが2MBを超えています' : null,
    );
    setState(() => _files.add(item));
    if (item.error != null) return;
    for (int i = 0; i <= 10; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 130));
      if (!mounted) return;
      setState(() => item.progress = i / 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        DottedBox(
          child: Column(
            children: <Widget>[
              Icon(Icons.cloud_upload_outlined,
                  size: 28, color: scheme.outline),
              const SizedBox(height: 6),
              const Text(
                'ファイルを選択、またはドラッグ&ドロップ',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () => _add(),
                    child: const Text('ファイルを選択'),
                  ),
                  OutlinedButton(
                    onPressed: () => _add(tooBig: true),
                    child: const Text('大きすぎるファイルを試す'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '対応形式: 画像 / 1ファイル 2MB まで',
                style: TextStyle(fontSize: 11, color: scheme.outline),
              ),
            ],
          ),
        ),
        if (_files.isEmpty)
          const DemoOutput('まだファイルがありません')
        else
          for (final _UploadItem f in _files)
            AppCard(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(f.name,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                      Text('${f.sizeKb} KB',
                          style:
                              TextStyle(fontSize: 11, color: scheme.outline)),
                      IconButton(
                        tooltip: '${f.name} を削除',
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () => setState(() => _files.remove(f)),
                      ),
                    ],
                  ),
                  if (f.error != null)
                    Text('✕ ${f.error}',
                        style: TextStyle(
                            fontSize: 12,
                            color: scheme.error,
                            fontWeight: FontWeight.w600))
                  else
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: f.progress,
                        minHeight: 5,
                      ),
                    ),
                ],
              ),
            ),
        const DemoNote('対応形式・上限を事前に明示し、失敗したファイルは理由付きで残します（黙って捨てない）。'),
      ],
    );
  }
}

/// 破線風の枠（点線描画を避け、薄い枠で代用）
class DottedBox extends StatelessWidget {
  const DottedBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: Border.all(color: scheme.outline, width: 1.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}

/* ------------------------------------------------------------- search-bar */
class SearchBarDemo extends StatefulWidget {
  const SearchBarDemo({super.key});
  @override
  State<SearchBarDemo> createState() => _SearchBarDemoState();
}

class _SearchBarDemoState extends State<SearchBarDemo> {
  static const List<String> _articles = <String>[
    'UIデザインの基本',
    'アクセシビリティ入門',
    'Flutter で作るモバイルUI',
    '色のコントラスト比',
    'フォーム設計の原則',
  ];
  final TextEditingController _c = TextEditingController();
  String? _submitted;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _submit(String v) => setState(() {
        _submitted = v.trim();
        _c.text = v;
      });

  @override
  Widget build(BuildContext context) {
    final List<String>? results = _submitted == null
        ? null
        : _articles.where((String a) => a.contains(_submitted!)).toList();
    return DemoStack(
      children: <Widget>[
        TextField(
          controller: _c,
          textInputAction: TextInputAction.search,
          onSubmitted: _submit,
          decoration: InputDecoration(
            hintText: '記事を検索',
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: _c.text.isEmpty
                ? null
                : IconButton(
                    tooltip: '検索キーワードをクリア',
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => setState(() {
                      _c.clear();
                      _submitted = null;
                    }),
                  ),
            border: const OutlineInputBorder(),
          ),
          onChanged: (_) => setState(() {}),
        ),
        if (results == null)
          const DemoOutput('キーワードを入力して検索してください（例: UI）')
        else if (results.isEmpty)
          AppCard(
            child: Column(
              children: <Widget>[
                Text('「$_submitted」に一致する記事はありません',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text('人気のキーワード:', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: <Widget>[
                    for (final String k in <String>['UI', '色', 'Flutter'])
                      ActionChip(label: Text(k), onPressed: () => _submit(k)),
                  ],
                ),
              ],
            ),
          )
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                for (final String r in results)
                  ListTile(dense: true, title: Text(r)),
              ],
            ),
          ),
        const DemoNote('0件で行き止まりにせず、次の一歩（人気キーワード）を提示。×でのクリアも必須です。'),
      ],
    );
  }
}

/* -------------------------------------------------------------- tag-input */
class TagInputDemo extends StatefulWidget {
  const TagInputDemo({super.key});
  @override
  State<TagInputDemo> createState() => _TagInputDemoState();
}

class _TagInputDemoState extends State<TagInputDemo> {
  final List<String> _tags = <String>['UI', 'アクセシビリティ'];
  final TextEditingController _c = TextEditingController();
  static const int _max = 5;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _add(String raw) {
    final String t = raw.trim().replaceAll(',', '');
    if (t.isEmpty || _tags.contains(t) || _tags.length >= _max) return;
    setState(() {
      _tags.add(t);
      _c.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        const DemoLabel('タグ（最大5個）'),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: <Widget>[
            for (final String t in _tags)
              InputChip(
                label: Text(t),
                onDeleted: () => setState(() => _tags.remove(t)),
                deleteButtonTooltipMessage: '$t を削除',
              ),
          ],
        ),
        TextField(
          controller: _c,
          onSubmitted: _add,
          enabled: _tags.length < _max,
          decoration: InputDecoration(
            hintText: _tags.length >= _max ? '上限に達しました' : 'Enter で追加',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              tooltip: 'タグを追加',
              icon: const Icon(Icons.add, size: 20),
              onPressed: () => _add(_c.text),
            ),
          ),
        ),
        DemoOutput(_tags.toString(), label: '送信される値'),
        const DemoNote(
          'InputChip の onDeleted で個別削除。日本語入力（IME）の変換確定 Enter でタグが確定してしまわないよう、'
          '実装では TextInputAction と composing の扱いに注意します。',
        ),
      ],
    );
  }
}

/* ----------------------------------------------------------------- rating */
class RatingDemo extends StatefulWidget {
  const RatingDemo({super.key});
  @override
  State<RatingDemo> createState() => _RatingDemoState();
}

class _RatingDemoState extends State<RatingDemo> {
  int _rating = 0;
  static const List<String> _labels = <String>[
    '', '不満', 'いまいち', 'ふつう', '満足', '非常に満足',
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        const DemoLabel('この商品の評価'),
        Row(
          children: <Widget>[
            for (int n = 1; n <= 5; n++)
              IconButton(
                tooltip: '$n点：${_labels[n]}',
                onPressed: () => setState(() => _rating = n),
                icon: Icon(
                  n <= _rating ? Icons.star : Icons.star_border,
                  color: n <= _rating ? const Color(0xFFF5A623) : scheme.outline,
                  size: 30,
                ),
              ),
            const SizedBox(width: 6),
            Text(
              _rating == 0 ? '未評価' : '$_rating.0 ${_labels[_rating]}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ],
        ),
        AppCard(
          child: Row(
            children: <Widget>[
              const Text('4.3',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(width: 8),
              for (int n = 1; n <= 5; n++)
                Icon(
                  n <= 4 ? Icons.star : Icons.star_border,
                  size: 17,
                  color: const Color(0xFFF5A623),
                ),
              const SizedBox(width: 8),
              Text('1,284件の評価',
                  style: TextStyle(fontSize: 12, color: scheme.outline)),
            ],
          ),
        ),
        const DemoNote('件数の併記は必須。1件の5.0と1000件の4.3では意味が全く違います。'),
      ],
    );
  }
}

/* -------------------------------------------------------------- pin-input */
class PinInputDemo extends StatefulWidget {
  const PinInputDemo({super.key});
  @override
  State<PinInputDemo> createState() => _PinInputDemoState();
}

class _PinInputDemoState extends State<PinInputDemo> {
  static const int _len = 6;
  final List<TextEditingController> _controllers = List<TextEditingController>
      .generate(_len, (int _) => TextEditingController());
  final List<FocusNode> _nodes =
      List<FocusNode>.generate(_len, (int _) => FocusNode());
  String _status = '';

  @override
  void dispose() {
    for (final TextEditingController c in _controllers) {
      c.dispose();
    }
    for (final FocusNode n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((TextEditingController c) => c.text).join();

  void _onChanged(int i, String v) {
    if (v.length > 1) {
      // ペースト：1マスに複数桁が入ったら分配する
      final String digits = v.replaceAll(RegExp(r'\D'), '');
      for (int k = 0; k < _len - i; k++) {
        if (k < digits.length) _controllers[i + k].text = digits[k];
      }
      final int last = (i + digits.length).clamp(0, _len - 1);
      _nodes[last].requestFocus();
    } else if (v.isNotEmpty && i < _len - 1) {
      _nodes[i + 1].requestFocus();
    }
    setState(() {
      if (_code.length == _len) {
        _status = _code == '123456' ? 'ok' : 'ng';
      } else {
        _status = '';
      }
    });
  }

  void _reset() {
    for (final TextEditingController c in _controllers) {
      c.clear();
    }
    setState(() => _status = '');
    _nodes.first.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        const DemoLabel('SMSで届いた6桁のコード（デモの正解: 123456）'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            for (int i = 0; i < _len; i++)
              SizedBox(
                width: 44,
                child: TextField(
                  controller: _controllers[i],
                  focusNode: _nodes[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: const OutlineInputBorder(),
                    enabledBorder: _status == 'ng'
                        ? OutlineInputBorder(
                            borderSide: BorderSide(color: scheme.error))
                        : null,
                  ),
                  onChanged: (String v) => _onChanged(i, v),
                ),
              ),
          ],
        ),
        if (_status == 'ok')
          const DemoOutput('✅ 認証に成功しました', label: '結果')
        else if (_status == 'ng')
          Text('コードが正しくありません。入力内容は消さずに残しています。',
              style: TextStyle(
                  color: scheme.error,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600))
        else
          const DemoOutput('6桁すべて入力すると自動で検証します'),
        Row(
          children: <Widget>[
            TextButton(onPressed: _reset, child: const Text('入力し直す')),
            const SizedBox(width: 8),
            Text('コードは10分間有効です',
                style: TextStyle(fontSize: 11.5, color: scheme.outline)),
          ],
        ),
        const DemoNote(
          'ペースト対応（1マスに複数桁が入ったら分配）と自動フォーカス移動が実装の肝。'
          '実機では autofillHints: [AutofillHints.oneTimeCode] でSMS自動入力にも対応します。',
        ),
      ],
    );
  }
}
