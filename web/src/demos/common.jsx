import { useEffect, useRef, useState } from 'react';

/** デモ共通の説明ラベル + 出力表示 */
export const Out = ({ label, children }) => (
  <div className="d-out">
    {label && <span style={{ color: 'var(--text-faint)' }}>{label}: </span>}
    {children}
  </div>
);

export const Note = ({ children }) => (
  <p style={{ fontSize: 12.5, color: 'var(--text-faint)', lineHeight: 1.7 }}>{children}</p>
);

/** スマホ画面の枠。モバイル特有のUIを見せるときに使う */
export const Phone = ({ children, height = 360 }) => (
  <div className="d-phone">
    <div className="d-phone__screen" style={{ height }}>{children}</div>
  </div>
);

/** 比較デモ用の2カラム（良い例 / 悪い例） */
export const Compare = ({ good, bad, goodLabel = '👍 良い例', badLabel = '👎 悪い例' }) => (
  <div style={{ display: 'grid', gap: 12, gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))' }}>
    <div>
      <div className="d-label" style={{ color: 'var(--success)', marginBottom: 6 }}>{goodLabel}</div>
      {good}
    </div>
    <div>
      <div className="d-label" style={{ color: 'var(--danger)', marginBottom: 6 }}>{badLabel}</div>
      {bad}
    </div>
  </div>
);

/** 一定時間後に自動で false に戻るフラグ（コピー完了表示など） */
export function useTimedFlag(duration = 1800) {
  const [on, setOn] = useState(false);
  const timer = useRef(null);
  useEffect(() => () => clearTimeout(timer.current), []);
  const fire = () => {
    setOn(true);
    clearTimeout(timer.current);
    timer.current = setTimeout(() => setOn(false), duration);
  };
  return [on, fire];
}

/** 疑似的な非同期処理 */
export const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

export const SAMPLE_USERS = [
  { id: 1, name: '佐藤 花子', mail: 'sato@example.com', color: '#3b5bfd' },
  { id: 2, name: '鈴木 一郎', mail: 'suzuki@example.com', color: '#0e8a53' },
  { id: 3, name: '高橋 みなみ', mail: 'takahashi@example.com', color: '#b46b00' },
  { id: 4, name: '田中 健', mail: 'tanaka@example.com', color: '#d7263d' },
  { id: 5, name: '伊藤 さくら', mail: 'ito@example.com', color: '#7c3aed' },
];

export const PREFECTURES = [
  '北海道', '青森県', '岩手県', '宮城県', '秋田県', '山形県', '福島県', '茨城県', '栃木県', '群馬県',
  '埼玉県', '千葉県', '東京都', '神奈川県', '新潟県', '富山県', '石川県', '福井県', '山梨県', '長野県',
  '岐阜県', '静岡県', '愛知県', '三重県', '滋賀県', '京都府', '大阪府', '兵庫県', '奈良県', '和歌山県',
];

export const initials = (name) => name.replace(/\s/g, '').slice(0, 1);
