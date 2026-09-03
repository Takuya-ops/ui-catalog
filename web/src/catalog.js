import data from '@data';

export const meta = {
  title: data.title,
  subtitle: data.subtitle,
  version: data.version,
  generatedAt: data.generatedAt,
};
export const categories = data.categories;
export const components = data.components;

export const byId = Object.fromEntries(components.map((c) => [c.id, c]));
export const categoryById = Object.fromEntries(categories.map((c) => [c.id, c]));

export const componentsOf = (categoryId) => components.filter((c) => c.category === categoryId);

/** 全カテゴリを定義順に連結した「通し」の並び。前後移動に使う */
export const flatOrder = categories.flatMap((cat) => componentsOf(cat.id));

export function neighbors(id) {
  const i = flatOrder.findIndex((c) => c.id === id);
  return {
    prev: i > 0 ? flatOrder[i - 1] : null,
    next: i >= 0 && i < flatOrder.length - 1 ? flatOrder[i + 1] : null,
  };
}

const norm = (s) => (s ?? '').toString().toLowerCase();

/** 名前・別名・キーワード・要約を横断するあいまい検索（依存なしの簡易スコアリング） */
export function search(query, limit = 40) {
  const q = norm(query).trim();
  if (!q) return [];
  const terms = q.split(/\s+/).filter(Boolean);
  const scored = [];
  for (const c of components) {
    const haystacks = [
      { text: norm(c.name), weight: 10 },
      { text: norm(c.enName), weight: 9 },
      { text: norm((c.aliases ?? []).join(' ')), weight: 7 },
      { text: norm((c.keywords ?? []).join(' ')), weight: 6 },
      { text: norm(c.summary), weight: 3 },
      { text: norm(c.purpose), weight: 1 },
      { text: norm((c.realWorldExamples ?? []).map((e) => e.app + ' ' + e.usage).join(' ')), weight: 2 },
      { text: norm(categoryById[c.category]?.name), weight: 2 },
    ];
    let score = 0;
    let matchedAll = true;
    for (const t of terms) {
      let best = 0;
      for (const h of haystacks) {
        const idx = h.text.indexOf(t);
        if (idx === -1) continue;
        best = Math.max(best, h.weight * (idx === 0 ? 1.6 : 1));
      }
      if (best === 0) matchedAll = false;
      score += best;
    }
    if (matchedAll && score > 0) scored.push({ component: c, score });
  }
  scored.sort((a, b) => b.score - a.score || a.component.name.localeCompare(b.component.name, 'ja'));
  return scored.slice(0, limit).map((s) => s.component);
}
