import 'package:flutter/material.dart';

/// テーマ定義。
///
/// ThemeData のサブテーマ（CardTheme など）は Flutter のバージョンによって
/// 型名が変わることがあるため、ここでは安定した項目だけを設定し、
/// 見た目の詳細は widgets/common.dart の AppCard などで組み立てている。
class AppTheme {
  static const Color seed = Color(0xFF3B5BFD);

  static ThemeData light() => _base(Brightness.light);
  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: brightness == Brightness.light
          ? const Color(0xFFF6F7FB)
          : const Color(0xFF0B0E17),
      visualDensity: VisualDensity.standard,
      // フォントは OS 既定に任せる（iOS/Android は日本語フォントを内蔵している）。
      // Flutter Web の場合、CanvasKit が必要な字形を Google Fonts から自動取得するため、
      // オフライン環境では日本語が □ になることがある（ネイティブ実行では発生しない）。
    );
  }
}

/// 全画面で共有する表示テーマの状態（ライト / ダーク / システム連動）。
class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  void set(ThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }

  void cycle() {
    switch (_mode) {
      case ThemeMode.system:
        set(ThemeMode.light);
      case ThemeMode.light:
        set(ThemeMode.dark);
      case ThemeMode.dark:
        set(ThemeMode.system);
    }
  }

  String get label {
    switch (_mode) {
      case ThemeMode.system:
        return 'システム連動';
      case ThemeMode.light:
        return 'ライト';
      case ThemeMode.dark:
        return 'ダーク';
    }
  }

  IconData get icon {
    switch (_mode) {
      case ThemeMode.system:
        return Icons.brightness_auto_outlined;
      case ThemeMode.light:
        return Icons.light_mode_outlined;
      case ThemeMode.dark:
        return Icons.dark_mode_outlined;
    }
  }
}

/// ThemeController を子孫へ配る。依存パッケージを増やさないため InheritedNotifier を使う。
class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final ThemeScope? scope =
        context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope が見つかりません');
    return scope!.notifier!;
  }
}
