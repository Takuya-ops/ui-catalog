/// data/components.json（Web版と共通の単一ソース）に対応するモデル。
class RealWorldExample {
  final String app;
  final String usage;

  const RealWorldExample({required this.app, required this.usage});

  factory RealWorldExample.fromJson(Map<String, dynamic> json) =>
      RealWorldExample(
        app: json['app'] as String? ?? '',
        usage: json['usage'] as String? ?? '',
      );
}

class UiCategory {
  final String id;
  final String name;
  final String enName;
  final String emoji;
  final String colorHex;
  final String description;

  const UiCategory({
    required this.id,
    required this.name,
    required this.enName,
    required this.emoji,
    required this.colorHex,
    required this.description,
  });

  factory UiCategory.fromJson(Map<String, dynamic> json) => UiCategory(
        id: json['id'] as String,
        name: json['name'] as String,
        enName: json['enName'] as String? ?? '',
        emoji: json['emoji'] as String? ?? '',
        colorHex: json['color'] as String? ?? '#3b5bfd',
        description: json['description'] as String? ?? '',
      );

  int get colorValue {
    final hex = colorHex.replaceAll('#', '');
    return int.parse(hex.length == 6 ? 'FF$hex' : hex, radix: 16);
  }
}

class UiComponent {
  final String id;
  final String category;
  final String name;
  final String enName;
  final List<String> aliases;
  final String summary;
  final String purpose;
  final List<String> whenToUse;
  final List<String> whenNotToUse;
  final List<RealWorldExample> realWorldExamples;
  final List<String> antiPatterns;
  final List<String> accessibility;
  final String webNote;
  final String flutterNote;
  final List<String> related;
  final List<String> keywords;

  const UiComponent({
    required this.id,
    required this.category,
    required this.name,
    required this.enName,
    required this.aliases,
    required this.summary,
    required this.purpose,
    required this.whenToUse,
    required this.whenNotToUse,
    required this.realWorldExamples,
    required this.antiPatterns,
    required this.accessibility,
    required this.webNote,
    required this.flutterNote,
    required this.related,
    required this.keywords,
  });

  static List<String> _strings(dynamic value) =>
      (value as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic e) => e.toString())
          .toList();

  factory UiComponent.fromJson(Map<String, dynamic> json) {
    final notes = json['platformNotes'] as Map<String, dynamic>? ??
        const <String, dynamic>{};
    return UiComponent(
      id: json['id'] as String,
      category: json['category'] as String,
      name: json['name'] as String,
      enName: json['enName'] as String? ?? '',
      aliases: _strings(json['aliases']),
      summary: json['summary'] as String? ?? '',
      purpose: json['purpose'] as String? ?? '',
      whenToUse: _strings(json['whenToUse']),
      whenNotToUse: _strings(json['whenNotToUse']),
      realWorldExamples: (json['realWorldExamples'] as List<dynamic>? ??
              const <dynamic>[])
          .map((dynamic e) =>
              RealWorldExample.fromJson(e as Map<String, dynamic>))
          .toList(),
      antiPatterns: _strings(json['antiPatterns']),
      accessibility: _strings(json['accessibility']),
      webNote: notes['web'] as String? ?? '',
      flutterNote: notes['flutter'] as String? ?? '',
      related: _strings(json['related']),
      keywords: _strings(json['keywords']),
    );
  }

  /// 検索用の連結テキスト
  String get searchHaystack => <String>[
        name,
        enName,
        summary,
        purpose,
        ...aliases,
        ...keywords,
        ...realWorldExamples.map((RealWorldExample e) => '${e.app} ${e.usage}'),
      ].join(' ').toLowerCase();
}

class Catalog {
  final String title;
  final String subtitle;
  final String version;
  final List<UiCategory> categories;
  final List<UiComponent> components;

  const Catalog({
    required this.title,
    required this.subtitle,
    required this.version,
    required this.categories,
    required this.components,
  });

  factory Catalog.fromJson(Map<String, dynamic> json) {
    final cats = (json['categories'] as List<dynamic>)
        .map((dynamic e) => UiCategory.fromJson(e as Map<String, dynamic>))
        .toList();
    final comps = (json['components'] as List<dynamic>)
        .map((dynamic e) => UiComponent.fromJson(e as Map<String, dynamic>))
        .toList();
    return Catalog(
      title: json['title'] as String? ?? 'UI Catalog',
      subtitle: json['subtitle'] as String? ?? '',
      version: json['version'] as String? ?? '1.0.0',
      categories: cats,
      components: comps,
    );
  }

  List<UiComponent> byCategory(String categoryId) =>
      components.where((UiComponent c) => c.category == categoryId).toList();

  UiComponent? byId(String id) {
    for (final UiComponent c in components) {
      if (c.id == id) return c;
    }
    return null;
  }

  UiCategory? categoryById(String id) {
    for (final UiCategory c in categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// カテゴリ定義順に並べた通し一覧（前後移動に使う）
  List<UiComponent> get flatOrder =>
      categories.expand((UiCategory cat) => byCategory(cat.id)).toList();

  List<UiComponent> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const <UiComponent>[];
    final terms = q.split(RegExp(r'\s+'));
    final List<MapEntry<UiComponent, int>> scored =
        <MapEntry<UiComponent, int>>[];
    for (final UiComponent c in components) {
      int score = 0;
      bool all = true;
      for (final String t in terms) {
        if (c.name.toLowerCase().contains(t)) {
          score += 10;
        } else if (c.enName.toLowerCase().contains(t)) {
          score += 8;
        } else if (c.aliases.join(' ').toLowerCase().contains(t)) {
          score += 6;
        } else if (c.keywords.join(' ').toLowerCase().contains(t)) {
          score += 5;
        } else if (c.searchHaystack.contains(t)) {
          score += 2;
        } else {
          all = false;
        }
      }
      if (all && score > 0) {
        scored.add(MapEntry<UiComponent, int>(c, score));
      }
    }
    scored.sort((MapEntry<UiComponent, int> a, MapEntry<UiComponent, int> b) =>
        b.value.compareTo(a.value));
    return scored.map((MapEntry<UiComponent, int> e) => e.key).toList();
  }
}
