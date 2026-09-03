import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/common.dart';

/* --------------------------------------------------------- primary-button */
class PrimaryButtonDemo extends StatefulWidget {
  const PrimaryButtonDemo({super.key});
  @override
  State<PrimaryButtonDemo> createState() => _PrimaryButtonDemoState();
}

class _PrimaryButtonDemoState extends State<PrimaryButtonDemo> {
  String _state = 'idle';

  Future<void> _submit() async {
    setState(() => _state = 'loading');
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _state = 'done');
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _state = 'idle');
  }

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        FilledButton(
          onPressed: _state == 'loading' ? null : _submit,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (_state == 'loading') ...<Widget>[
                const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                _state == 'loading'
                    ? '予約を確定しています…'
                    : _state == 'done'
                        ? '✓ 予約が確定しました'
                        : '予約を確定する',
              ),
            ],
          ),
        ),
        Tooltip(
          message: '利用規約への同意が必要です',
          child: FilledButton(
            onPressed: null,
            child: const Text('同意して続ける（無効の例）'),
          ),
        ),
        const DemoLabel('視覚的な階層'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            FilledButton(onPressed: () {}, child: const Text('保存する')),
            OutlinedButton(onPressed: () {}, child: const Text('下書き保存')),
            TextButton(onPressed: () {}, child: const Text('キャンセル')),
          ],
        ),
        const DemoNote(
          'ラベルは「送信」ではなく「予約を確定する」のように動詞＋目的語で。'
          '処理中は onPressed: null にして二重送信を防ぎます。無効にする時は理由も伝えます。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------- secondary-button */
class SecondaryButtonDemo extends StatefulWidget {
  const SecondaryButtonDemo({super.key});
  @override
  State<SecondaryButtonDemo> createState() => _SecondaryButtonDemoState();
}

class _SecondaryButtonDemoState extends State<SecondaryButtonDemo> {
  String _choice = '';

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('変更を保存しますか？',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text('保存しない場合、この編集内容は失われます。',
                  style: TextStyle(fontSize: 13)),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () => setState(() => _choice = '破棄'),
                    child: const Text('破棄する'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => setState(() => _choice = '保存'),
                    child: const Text('保存する'),
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoOutput(_choice.isEmpty ? '未選択' : _choice, label: '選択'),
        const DemoNote(
          'FilledButton（塗り）と OutlinedButton（枠線）の視覚差で優先順位を伝えます。'
          '推奨アクションを右に置くのが Material の慣習（iOS のアラートは配置が異なります）。',
        ),
      ],
    );
  }
}

/* ----------------------------------------------------------- ghost-button */
class GhostButtonDemo extends StatefulWidget {
  const GhostButtonDemo({super.key});
  @override
  State<GhostButtonDemo> createState() => _GhostButtonDemoState();
}

class _GhostButtonDemoState extends State<GhostButtonDemo> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 72,
                width: double.infinity,
                alignment: Alignment.center,
                color: scheme.surfaceContainerHighest,
                child: const Text('📰', style: TextStyle(fontSize: 26)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('UIコンポーネントの選び方',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(height: 3),
                    Text('似たUIの使い分けを、判断基準から整理します。',
                        style: TextStyle(
                            fontSize: 12.5, color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Divider(height: 1, color: scheme.outlineVariant),
              Row(
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () => setState(() => _liked = !_liked),
                    icon: Icon(
                      _liked ? Icons.favorite : Icons.favorite_border,
                      size: 17,
                    ),
                    label: Text(_liked ? 'いいね済み' : 'いいね'),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.ios_share, size: 17),
                    label: const Text('共有'),
                  ),
                  const Spacer(),
                  TextButton(onPressed: () {}, child: const Text('詳細')),
                ],
              ),
            ],
          ),
        ),
        const DemoNote(
          'カード内の補助操作は TextButton が最適。見た目は軽くても、'
          'Flutter の TextButton は既定で十分なタップ領域（48dp）を確保します。',
        ),
      ],
    );
  }
}

/* ----------------------------------------------------- destructive-button */
class DestructiveButtonDemo extends StatefulWidget {
  const DestructiveButtonDemo({super.key});
  @override
  State<DestructiveButtonDemo> createState() => _DestructiveButtonDemoState();
}

class _DestructiveButtonDemoState extends State<DestructiveButtonDemo> {
  bool _deleted = false;
  static const String _target = 'my-project';

  Future<void> _confirm() async {
    final TextEditingController controller = TextEditingController();
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) =>
            AlertDialog(
          title: const Text('本当に削除しますか？'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('確認のため「$_target」と入力してください。',
                  style: TextStyle(fontSize: 13)),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                autofocus: true,
                onChanged: (_) => setDialogState(() {}),
                decoration: const InputDecoration(
                  hintText: _target,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('やめる'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: controller.text == _target
                  ? () => Navigator.of(context).pop(true)
                  : null,
              child: const Text('完全に削除する'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (ok == true && mounted) setState(() => _deleted = true);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        if (_deleted)
          DemoOutput('🗑️「$_target」を削除しました（この操作は取り消せません）', label: '結果')
        else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scheme.errorContainer.withValues(alpha: 0.35),
              border: Border.all(color: scheme.error),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('危険な操作（Danger Zone）',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        color: scheme.error)),
                const SizedBox(height: 4),
                const Text(
                  'プロジェクトを削除すると、すべてのデータが完全に失われます。この操作は取り消せません。',
                  style: TextStyle(fontSize: 12.5, height: 1.6),
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                      backgroundColor: scheme.error,
                      foregroundColor: scheme.onError),
                  onPressed: _confirm,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('プロジェクトを削除'),
                ),
              ],
            ),
          ),
        if (_deleted)
          OutlinedButton(
            onPressed: () => setState(() => _deleted = false),
            child: const Text('デモをリセット'),
          ),
        const DemoNote(
          'GitHub と同じ「名前を入力させる確認（type-to-confirm）」。'
          'ボタンは「OK」ではなく「完全に削除する」と動詞で書きます。',
        ),
      ],
    );
  }
}

/* -------------------------------------------------------------------- link */
class LinkDemo extends StatelessWidget {
  const LinkDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    const TextSpan(text: 'UIの設計原則については '),
                    TextSpan(
                      text: 'アクセシビリティのガイドライン（WCAG 2.2）',
                      style: TextStyle(
                        color: scheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' を参照してください。'),
                  ],
                ),
                style: const TextStyle(fontSize: 13.5, height: 1.9),
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Text(
                    '公式ドキュメント',
                    style: TextStyle(
                      color: scheme.primary,
                      fontSize: 13.5,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(Icons.open_in_new, size: 13, color: scheme.primary),
                  const SizedBox(width: 6),
                  Text('（外部サイトへ移動する場合はアイコンで予告）',
                      style: TextStyle(
                          fontSize: 11, color: scheme.onSurfaceVariant)),
                ],
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: AppCard(
                leftAccent: const Color(0xFF0E8A53),
                padding: const EdgeInsets.all(11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const DemoLabel('👍 リンク単体で意味が通る',
                        color: Color(0xFF0E8A53)),
                    const SizedBox(height: 4),
                    Text('返品ポリシーを確認する',
                        style: TextStyle(
                            fontSize: 13,
                            color: scheme.primary,
                            decoration: TextDecoration.underline)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppCard(
                leftAccent: scheme.error,
                padding: const EdgeInsets.all(11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DemoLabel('👎「こちら」だけ', color: scheme.error),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          const TextSpan(text: '詳しくは '),
                          TextSpan(
                            text: 'こちら',
                            style: TextStyle(
                                color: scheme.primary,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const DemoNote(
          'スクリーンリーダーは「リンクだけを一覧で読み上げる」機能を持ちます。'
          '「こちら」が並ぶと何のリンクか分かりません。Flutter では url_launcher で外部リンクを開きます。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------------ icon-button */
class IconButtonDemo extends StatefulWidget {
  const IconButtonDemo({super.key});
  @override
  State<IconButtonDemo> createState() => _IconButtonDemoState();
}

class _IconButtonDemoState extends State<IconButtonDemo> {
  bool _liked = false;
  int _count = 24;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            children: <Widget>[
              IconButton(
                tooltip: '返信',
                onPressed: () {},
                icon: const Icon(Icons.mode_comment_outlined, size: 19),
              ),
              IconButton(
                tooltip: 'リポスト',
                onPressed: () {},
                icon: const Icon(Icons.repeat, size: 19),
              ),
              IconButton(
                tooltip: _liked ? 'いいねを取り消す' : 'いいね',
                onPressed: () => setState(() {
                  _liked = !_liked;
                  _count += _liked ? 1 : -1;
                }),
                icon: Icon(
                  _liked ? Icons.favorite : Icons.favorite_border,
                  size: 19,
                  color: _liked ? const Color(0xFFE0245E) : null,
                ),
              ),
              Text('$_count',
                  style: TextStyle(
                      fontSize: 12.5, color: scheme.onSurfaceVariant)),
              const Spacer(),
              IconButton(
                tooltip: '共有',
                onPressed: () {},
                icon: const Icon(Icons.ios_share, size: 18),
              ),
            ],
          ),
        ),
        DemoOutput(_liked ? 'いいね済み' : '未いいね', label: '状態'),
        const DemoNote(
          'IconButton の tooltip は、マウスのホバー表示とスクリーンリーダー用の名前を兼ねます。'
          'アイコンのみのボタンでは必ず指定してください。',
        ),
      ],
    );
  }
}

/* ----------------------------------------------------------- split-button */
class SplitButtonDemo extends StatefulWidget {
  const SplitButtonDemo({super.key});
  @override
  State<SplitButtonDemo> createState() => _SplitButtonDemoState();
}

class _SplitButtonDemoState extends State<SplitButtonDemo> {
  String _log = '（既定の操作は「マージ」）';

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FilledButton(
                style: FilledButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(10),
                    ),
                  ),
                ),
                onPressed: () =>
                    setState(() => _log = '実行: マージ（Merge commit）'),
                child: const Text('マージする'),
              ),
              const SizedBox(width: 1.5),
              PopupMenuButton<String>(
                tooltip: 'マージ方法を選択',
                position: PopupMenuPosition.under,
                onSelected: (String v) => setState(() => _log = '実行: $v'),
                itemBuilder: (BuildContext context) => const <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                      value: 'マージ（Merge commit）', child: Text('マージ（Merge commit）')),
                  PopupMenuItem<String>(
                      value: 'スカッシュしてマージ', child: Text('スカッシュしてマージ')),
                  PopupMenuItem<String>(
                      value: 'リベースしてマージ', child: Text('リベースしてマージ')),
                ],
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(10),
                    ),
                  ),
                  child: Icon(Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        ),
        DemoOutput(_log, label: 'ログ'),
        const DemoNote(
          '左＝既定の操作を1タップで、右＝派生の選択肢。境界線（隙間）を入れて押し間違いを防ぎます。'
          'GitHub のマージボタンが典型例です。',
        ),
      ],
    );
  }
}

/* ------------------------------------------------------------ copy-button */
class CopyButtonDemo extends StatefulWidget {
  const CopyButtonDemo({super.key});
  @override
  State<CopyButtonDemo> createState() => _CopyButtonDemoState();
}

class _CopyButtonDemoState extends State<CopyButtonDemo> {
  bool _copied = false;
  static const String _text = 'https://example.com/invite/8f3a-92kd-1p0z';

  Future<void> _copy() async {
    await Clipboard.setData(const ClipboardData(text: _text));
    if (!mounted) return;
    setState(() => _copied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('招待リンクをクリップボードにコピーしました'),
        duration: Duration(seconds: 2),
      ),
    );
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DemoStack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
            border: Border.all(color: scheme.outlineVariant),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  _text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.5, fontFamily: 'monospace'),
                ),
              ),
              OutlinedButton.icon(
                onPressed: _copy,
                icon: Icon(_copied ? Icons.check : Icons.copy, size: 16),
                label: Text(_copied ? 'コピー済み' : 'コピー'),
              ),
            ],
          ),
        ),
        const DemoNote(
          'アイコンの変化だけでは伝わりにくいので、SnackBar でも完了を通知しています。'
          'Flutter では Clipboard.setData(ClipboardData(text: ...)) を使います。',
        ),
      ],
    );
  }
}

/* ----------------------------------------------------------- share-button */
class ShareButtonDemo extends StatefulWidget {
  const ShareButtonDemo({super.key});
  @override
  State<ShareButtonDemo> createState() => _ShareButtonDemoState();
}

class _ShareButtonDemoState extends State<ShareButtonDemo> {
  String _log = '';

  Future<void> _share() async {
    // 実アプリでは share_plus パッケージで OS の共有シートを開く。
    // ここでは依存を増やさないため、フォールバック（リンクのコピー）を実演する。
    await Clipboard.setData(
      const ClipboardData(text: 'https://example.com/ui-catalog'),
    );
    if (!mounted) return;
    setState(() => _log = 'OSの共有シートが使えない場合のフォールバック：リンクをコピーしました');
  }

  @override
  Widget build(BuildContext context) {
    return DemoStack(
      children: <Widget>[
        FilledButton.icon(
          onPressed: _share,
          icon: const Icon(Icons.ios_share, size: 18),
          label: const Text('共有する'),
        ),
        DemoOutput(_log.isEmpty ? 'ボタンを押してください' : _log, label: '結果'),
        const DemoNote(
          '独自のSNSボタンを並べるのではなく、OSの共有シートに委ねるのが現代的。'
          'Flutter では share_plus パッケージの Share.share() を使い、'
          '使えない環境では必ずリンクのコピーへフォールバックします。',
        ),
      ],
    );
  }
}
