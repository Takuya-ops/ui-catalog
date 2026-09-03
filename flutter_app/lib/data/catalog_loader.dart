import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/ui_component.dart';

/// assets/components.json を読み込む。
/// このファイルは scripts/build-data.mjs が data/categories/*.json から生成する。
class CatalogLoader {
  static Catalog? _cache;

  static Future<Catalog> load() async {
    final Catalog? cached = _cache;
    if (cached != null) return cached;
    final String raw = await rootBundle.loadString('assets/components.json');
    final Map<String, dynamic> json =
        jsonDecode(raw) as Map<String, dynamic>;
    final Catalog catalog = Catalog.fromJson(json);
    _cache = catalog;
    return catalog;
  }
}
