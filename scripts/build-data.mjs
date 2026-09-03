#!/usr/bin/env node
/**
 * data/categories/*.json（単一ソース）をマージして
 *  - data/components.json           … 生成物（Web が import する）
 *  - flutter_app/assets/components.json … Flutter の rootBundle 用コピー
 * を出力する。依存パッケージなし。`node scripts/build-data.mjs` で実行。
 */
import { readFileSync, writeFileSync, readdirSync, mkdirSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const catDir = join(root, 'data', 'categories');

const meta = JSON.parse(readFileSync(join(catDir, '_meta.json'), 'utf8'));
const order = meta.categories.map((c) => c.id);

const files = readdirSync(catDir).filter((f) => f.endsWith('.json') && f !== '_meta.json');
const components = [];
for (const f of files) {
  const arr = JSON.parse(readFileSync(join(catDir, f), 'utf8'));
  if (!Array.isArray(arr)) throw new Error(`${f}: 配列である必要があります`);
  components.push(...arr);
}

// --- バリデーション ---------------------------------------------------------
const required = [
  'id', 'category', 'name', 'enName', 'summary', 'purpose',
  'whenToUse', 'whenNotToUse', 'realWorldExamples', 'antiPatterns',
  'accessibility', 'platformNotes',
];
const seen = new Set();
const errors = [];
for (const c of components) {
  for (const key of required) {
    if (c[key] === undefined || c[key] === null) errors.push(`${c.id ?? '(no id)'}: ${key} がありません`);
  }
  if (seen.has(c.id)) errors.push(`重複した id: ${c.id}`);
  seen.add(c.id);
  if (!order.includes(c.category)) errors.push(`${c.id}: 未知のカテゴリ '${c.category}'`);
}
for (const c of components) {
  for (const r of c.related ?? []) {
    if (!seen.has(r)) errors.push(`${c.id}: related の '${r}' は存在しません`);
  }
}
if (errors.length) {
  console.error('データ検証エラー:\n' + errors.map((e) => '  - ' + e).join('\n'));
  process.exit(1);
}

// --- 並び順をカテゴリ定義順にそろえる ---------------------------------------
components.sort((a, b) => order.indexOf(a.category) - order.indexOf(b.category));

const out = {
  ...meta,
  generatedAt: new Date().toISOString(),
  componentCount: components.length,
  components,
};
const json = JSON.stringify(out, null, 2) + '\n';

const targets = [
  join(root, 'data', 'components.json'),
  join(root, 'flutter_app', 'assets', 'components.json'),
];
for (const t of targets) {
  mkdirSync(dirname(t), { recursive: true });
  writeFileSync(t, json, 'utf8');
  console.log('written:', t.replace(root + '/', ''));
}

const byCat = Object.fromEntries(order.map((id) => [id, components.filter((c) => c.category === id).length]));
console.log(`OK: ${components.length} components`, byCat);
