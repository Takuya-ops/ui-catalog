import { useEffect, useRef, useState } from 'react';
import { Note, Out, Phone, SAMPLE_USERS, initials, useTimedFlag } from './common.jsx';
import {
  IconBell, IconCheck, IconChevronDown, IconChevronLeft, IconChevronRight, IconClose,
  IconHeart, IconInfo, IconMore, IconRefresh, IconStar, IconTrash, IconUser,
} from '../components/Icons.jsx';

/* ----------------------------------------------------------------------- card */
export function CardDemo() {
  const [liked, setLiked] = useState(false);
  return (
    <div className="d-stack">
      <div style={{ display: 'grid', gap: 12, gridTemplateColumns: 'repeat(auto-fill, minmax(210px, 1fr))' }}>
        {[
          { t: '海の見えるコテージ', p: '¥18,400', r: '4.92', n: 128, e: '🏖️' },
          { t: '古民家リノベの宿', p: '¥12,000', r: '4.78', n: 64, e: '🏡' },
        ].map((it) => (
          <article key={it.t} style={{ border: '1px solid var(--border)', borderRadius: 14, overflow: 'hidden', background: 'var(--bg-elev)', boxShadow: 'var(--shadow-sm)' }}>
            <div style={{ height: 108, background: 'var(--bg-sunken)', display: 'grid', placeItems: 'center', fontSize: 40, position: 'relative' }} aria-hidden="true">
              {it.e}
              <button
                onClick={() => setLiked((v) => !v)}
                aria-label={liked ? 'お気に入りから外す' : 'お気に入りに追加'}
                aria-pressed={liked}
                style={{ position: 'absolute', top: 8, right: 8, width: 32, height: 32, borderRadius: '50%', border: 0, cursor: 'pointer', background: 'rgba(255,255,255,.9)', color: liked ? '#e0245e' : '#555', display: 'grid', placeItems: 'center' }}
              >
                <IconHeart size={17} filled={liked} />
              </button>
            </div>
            <div style={{ padding: 11 }}>
              <h3 style={{ fontSize: 13.5, margin: 0 }}>
                <a href="#/u/card" onClick={(e) => e.preventDefault()} style={{ color: 'inherit', textDecoration: 'none' }}>{it.t}</a>
              </h3>
              <div style={{ fontSize: 12, color: 'var(--text-muted)', marginTop: 3, display: 'flex', alignItems: 'center', gap: 4 }}>
                <IconStar size={13} filled /> {it.r}（{it.n}件）
              </div>
              <div style={{ fontSize: 13.5, fontWeight: 700, marginTop: 6 }}>{it.p} <span style={{ fontWeight: 400, fontSize: 12, color: 'var(--text-muted)' }}>/ 泊</span></div>
            </div>
          </article>
        ))}
      </div>
      <Note>
        画像・タイトル・評価・価格・操作を1つの塊として知覚させるのがカード。
        カード全体をリンクにする場合、中のハートボタンとクリック領域が競合しないよう入れ子を避けます。
      </Note>
    </div>
  );
}

/* ----------------------------------------------------------------------- list */
export function ListDemo() {
  const [read, setRead] = useState([2]);
  const chats = [
    { id: 1, name: '佐藤 花子', msg: '明日の打ち合わせ、13時で大丈夫ですか？', time: '12:04', unread: 2 },
    { id: 2, name: '開発チーム', msg: 'リリースノートを更新しました', time: '11:20', unread: 0 },
    { id: 3, name: '鈴木 一郎', msg: '資料ありがとうございました！', time: '昨日', unread: 5 },
  ];
  return (
    <div className="d-stack">
      <ul className="d-list" style={{ listStyle: 'none', padding: 0, margin: 0 }}>
        {chats.map((c) => {
          const isRead = read.includes(c.id);
          return (
            <li key={c.id}>
              <button
                onClick={() => setRead((p) => [...new Set([...p, c.id])])}
                style={{ display: 'flex', gap: 11, alignItems: 'center', width: '100%', textAlign: 'left', border: 0, background: 'transparent', cursor: 'pointer', padding: '11px 13px', borderBottom: '1px solid var(--border)', minHeight: 60 }}
              >
                <span className="d-avatar" style={{ background: SAMPLE_USERS[c.id % 5].color }} aria-hidden="true">{initials(c.name)}</span>
                <span style={{ flex: 1, minWidth: 0 }}>
                  <span style={{ display: 'flex', justifyContent: 'space-between', gap: 8 }}>
                    <span style={{ fontSize: 14, fontWeight: !isRead && c.unread ? 800 : 600 }}>{c.name}</span>
                    <span style={{ fontSize: 11, color: 'var(--text-faint)', flex: 'none' }}>{c.time}</span>
                  </span>
                  <span style={{ display: 'flex', justifyContent: 'space-between', gap: 8, alignItems: 'center' }}>
                    <span style={{ fontSize: 12.5, color: !isRead && c.unread ? 'var(--text)' : 'var(--text-muted)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{c.msg}</span>
                    {!isRead && c.unread > 0 && (
                      <span style={{ flex: 'none', minWidth: 19, height: 19, padding: '0 5px', borderRadius: 999, background: 'var(--accent)', color: 'var(--accent-text)', fontSize: 11, fontWeight: 700, display: 'grid', placeItems: 'center' }}>
                        {c.unread}
                      </span>
                    )}
                  </span>
                </span>
                <IconChevronRight size={16} style={{ color: 'var(--text-faint)', flex: 'none' }} />
              </button>
            </li>
          );
        })}
      </ul>
      <Note>行をタップすると既読になります。アイコン＋主テキスト＋補助テキスト＋時刻＋バッジ＋シェブロン、が典型的な行構成。</Note>
    </div>
  );
}

/* ---------------------------------------------------------------------- table */
export function TableDemo() {
  const rows = [
    { name: 'ノートPC', cat: '電子機器', stock: 12, price: 128000 },
    { name: 'デスクチェア', cat: '家具', stock: 3, price: 42800 },
    { name: 'モニター 27"', cat: '電子機器', stock: 0, price: 39800 },
    { name: 'キーボード', cat: '周辺機器', stock: 45, price: 12800 },
  ];
  const [sort, setSort] = useState({ key: 'name', dir: 'asc' });
  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key], y = b[sort.key];
    const r = typeof x === 'number' ? x - y : String(x).localeCompare(String(y), 'ja');
    return sort.dir === 'asc' ? r : -r;
  });
  const th = (key, label, numeric) => (
    <th scope="col" aria-sort={sort.key === key ? (sort.dir === 'asc' ? 'ascending' : 'descending') : 'none'} style={{ textAlign: numeric ? 'right' : 'left', padding: 0, borderBottom: '1px solid var(--border)', background: 'var(--bg-sunken)', position: 'sticky', top: 0 }}>
      <button
        onClick={() => setSort((s) => ({ key, dir: s.key === key && s.dir === 'asc' ? 'desc' : 'asc' }))}
        style={{ width: '100%', border: 0, background: 'transparent', cursor: 'pointer', padding: '9px 11px', fontSize: 12, fontWeight: 700, textAlign: 'inherit', color: 'var(--text-muted)' }}
      >
        {label}{sort.key === key ? (sort.dir === 'asc' ? ' ↑' : ' ↓') : ''}
      </button>
    </th>
  );
  return (
    <div className="d-stack">
      <div role="region" aria-label="在庫一覧（横スクロール可）" tabIndex={0} style={{ overflowX: 'auto', border: '1px solid var(--border)', borderRadius: 'var(--radius)' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse', minWidth: 420, fontSize: 13.5 }}>
          <caption className="sr-only">商品の在庫と価格の一覧。列見出しをクリックすると並べ替えできます。</caption>
          <thead>
            <tr>{th('name', '商品名')}{th('cat', 'カテゴリ')}{th('stock', '在庫', true)}{th('price', '価格', true)}</tr>
          </thead>
          <tbody>
            {sorted.map((r) => (
              <tr key={r.name} style={{ borderBottom: '1px solid var(--border)' }}>
                <td style={{ padding: '9px 11px' }}>{r.name}</td>
                <td style={{ padding: '9px 11px', color: 'var(--text-muted)' }}>{r.cat}</td>
                <td style={{ padding: '9px 11px', textAlign: 'right', fontVariantNumeric: 'tabular-nums', color: r.stock === 0 ? 'var(--danger)' : 'inherit', fontWeight: r.stock === 0 ? 700 : 400 }}>
                  {r.stock === 0 ? '在庫なし' : r.stock}
                </td>
                <td style={{ padding: '9px 11px', textAlign: 'right', fontVariantNumeric: 'tabular-nums' }}>¥{r.price.toLocaleString()}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <Note>ヘッダは sticky で固定、数値は右寄せ＋等幅数字。<code>aria-sort</code> で並べ替え状態を支援技術にも伝えています。</Note>
    </div>
  );
}

/* --------------------------------------------------------------------- avatar */
export function AvatarDemo() {
  const [broken, setBroken] = useState(true);
  return (
    <div className="d-stack">
      <div className="d-row" style={{ gap: 18 }}>
        <div style={{ textAlign: 'center' }}>
          <div style={{ position: 'relative', width: 48, height: 48 }}>
            <div className="d-avatar" style={{ width: 48, height: 48, fontSize: 17, background: SAMPLE_USERS[0].color }}>佐</div>
            <span aria-hidden="true" style={{ position: 'absolute', right: 0, bottom: 0, width: 13, height: 13, borderRadius: '50%', background: 'var(--success)', border: '2px solid var(--bg-elev)' }} />
            <span className="sr-only">佐藤 花子（オンライン）</span>
          </div>
          <div style={{ fontSize: 11, color: 'var(--text-faint)', marginTop: 4 }}>状態ドット付き</div>
        </div>

        <div style={{ textAlign: 'center' }}>
          <div className="d-avatar" style={{ width: 48, height: 48, fontSize: 17, background: broken ? 'var(--bg-sunken)' : SAMPLE_USERS[1].color, color: broken ? 'var(--text-muted)' : '#fff' }}>
            {broken ? <IconUser size={24} /> : '鈴'}
          </div>
          <div style={{ fontSize: 11, color: 'var(--text-faint)', marginTop: 4 }}>画像なし</div>
        </div>

        <div style={{ textAlign: 'center' }}>
          <div style={{ display: 'flex' }}>
            {SAMPLE_USERS.slice(0, 3).map((u, i) => (
              <span key={u.id} className="d-avatar" style={{ width: 34, height: 34, background: u.color, border: '2px solid var(--bg-elev)', marginLeft: i ? -11 : 0 }}>{initials(u.name)}</span>
            ))}
            <span className="d-avatar" style={{ width: 34, height: 34, background: 'var(--bg-sunken)', color: 'var(--text-muted)', border: '2px solid var(--bg-elev)', marginLeft: -11, fontSize: 11 }} aria-label="他2名">+2</span>
          </div>
          <div style={{ fontSize: 11, color: 'var(--text-faint)', marginTop: 4 }}>Avatar Group</div>
        </div>
      </div>
      <button className="btn btn--secondary btn--sm" onClick={() => setBroken((v) => !v)}>
        画像の有無を切り替える（フォールバック確認）
      </button>
      <Note>画像がない場合は「壊れた画像」ではなくイニシャル／既定アイコンへフォールバックします。形とサイズは常に一定に。</Note>
    </div>
  );
}

/* ---------------------------------------------------------------------- badge */
export function BadgeDemo() {
  const [count, setCount] = useState(3);
  const display = count > 99 ? '99+' : String(count);
  return (
    <div className="d-stack">
      <div className="d-row" style={{ gap: 24 }}>
        <span style={{ position: 'relative', display: 'inline-block' }}>
          <IconBell size={28} />
          {count > 0 && (
            <span aria-hidden="true" style={{ position: 'absolute', top: -3, right: -8, minWidth: 18, height: 18, padding: '0 5px', borderRadius: 999, background: 'var(--danger)', color: '#fff', fontSize: 10.5, fontWeight: 700, display: 'grid', placeItems: 'center' }}>
              {display}
            </span>
          )}
          <span className="sr-only">通知{count > 0 ? `、未読${count}件` : '、未読なし'}</span>
        </span>

        <span style={{ position: 'relative', display: 'inline-block' }}>
          <IconBell size={28} />
          {count > 0 && <span aria-hidden="true" style={{ position: 'absolute', top: 0, right: 0, width: 9, height: 9, borderRadius: 999, background: 'var(--danger)', border: '2px solid var(--bg-elev)' }} />}
          <span className="sr-only">通知{count > 0 ? '、新着あり' : '、新着なし'}</span>
        </span>
        <span style={{ fontSize: 12, color: 'var(--text-faint)' }}>← 左: 数値バッジ / 右: ドットバッジ</span>
      </div>

      <div className="d-row">
        <button className="btn btn--secondary btn--sm" onClick={() => setCount((c) => c + 1)}>+1</button>
        <button className="btn btn--secondary btn--sm" onClick={() => setCount((c) => c + 50)}>+50</button>
        <button className="btn btn--secondary btn--sm" onClick={() => setCount(0)}>既読にする</button>
        <Out label="件数">{count}（表示: {count > 0 ? display : 'なし'}）</Out>
      </div>
      <Note>100件を超えたら「99+」に丸めます。件数が重要でないならドットバッジで十分。読み上げ用テキストも忘れずに。</Note>
    </div>
  );
}

/* ----------------------------------------------------------------------- chip */
export function ChipDemo() {
  const filters = ['未読', '添付あり', 'スター付き', '今週', '重要'];
  const [on, setOn] = useState(['未読']);
  return (
    <div className="d-stack">
      <div style={{ display: 'flex', gap: 7, overflowX: 'auto', paddingBottom: 4 }} role="group" aria-label="絞り込み">
        {filters.map((f) => {
          const active = on.includes(f);
          return (
            <button
              key={f}
              aria-pressed={active}
              onClick={() => setOn((p) => (p.includes(f) ? p.filter((x) => x !== f) : [...p, f]))}
              style={{
                display: 'inline-flex', alignItems: 'center', gap: 5, whiteSpace: 'nowrap', cursor: 'pointer',
                padding: '6px 13px', borderRadius: 999, fontSize: 13, minHeight: 34,
                border: `1px solid ${active ? 'var(--accent)' : 'var(--border-strong)'}`,
                background: active ? 'var(--accent-soft)' : 'var(--bg-elev)',
                color: active ? 'var(--accent)' : 'var(--text-muted)', fontWeight: active ? 700 : 400,
              }}
            >
              {active && <IconCheck size={14} />}{f}
            </button>
          );
        })}
      </div>
      <div className="d-row" style={{ gap: 6 }}>
        <span className="d-label">適用中:</span>
        {on.length === 0 && <span style={{ fontSize: 12.5, color: 'var(--text-faint)' }}>なし</span>}
        {on.map((f) => (
          <span key={f} style={{ display: 'inline-flex', alignItems: 'center', gap: 3, background: 'var(--bg-sunken)', border: '1px solid var(--border)', borderRadius: 999, padding: '3px 4px 3px 10px', fontSize: 12 }}>
            {f}
            <button onClick={() => setOn((p) => p.filter((x) => x !== f))} aria-label={`${f} の絞り込みを解除`} style={{ border: 0, background: 'transparent', cursor: 'pointer', color: 'inherit', width: 20, height: 20, display: 'grid', placeItems: 'center', borderRadius: '50%' }}>
              <IconClose size={12} />
            </button>
          </span>
        ))}
      </div>
      <Note>選択状態は「枠線＋背景＋チェックアイコン」の三重で表現。色だけでは色覚特性のあるユーザーに伝わりません。</Note>
    </div>
  );
}

/* ------------------------------------------------------------------- timeline */
export function TimelineDemo() {
  const steps = [
    { t: '注文受付', d: '9/1 10:24', done: true },
    { t: '発送準備中', d: '9/1 18:02', done: true },
    { t: '輸送中', d: '9/2 07:40', done: true },
    { t: '配達中', d: '本日 09:15', current: true },
    { t: '配達完了', d: '本日 中に到着予定', done: false },
  ];
  return (
    <div className="d-stack">
      <ol style={{ listStyle: 'none', margin: 0, padding: 0 }}>
        {steps.map((s, i) => {
          const color = s.current ? 'var(--accent)' : s.done ? 'var(--success)' : 'var(--border-strong)';
          return (
            <li key={s.t} style={{ display: 'flex', gap: 12 }}>
              <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', flex: 'none' }}>
                <span style={{ width: 15, height: 15, borderRadius: '50%', background: s.done || s.current ? color : 'var(--bg-elev)', border: `2px solid ${color}`, display: 'grid', placeItems: 'center', color: '#fff', fontSize: 9 }} aria-hidden="true">
                  {s.done ? '✓' : ''}
                </span>
                {i < steps.length - 1 && <span style={{ width: 2, flex: 1, minHeight: 26, background: s.done ? 'var(--success)' : 'var(--border)' }} aria-hidden="true" />}
              </div>
              <div style={{ paddingBottom: 16 }}>
                <div style={{ fontSize: 13.5, fontWeight: s.current ? 800 : 600, color: s.current ? 'var(--accent)' : 'inherit' }}>
                  {s.t}{s.current && '（現在）'}
                </div>
                <time style={{ fontSize: 12, color: 'var(--text-muted)' }}>{s.d}</time>
              </div>
            </li>
          );
        })}
      </ol>
      <Note>完了／現在／未着手を、色・塗り・チェックの3点で区別。相対時刻だけでなく絶対時刻も併記します。</Note>
    </div>
  );
}

/* ------------------------------------------------------------------ accordion */
export function AccordionDemo() {
  const items = [
    { q: '送料はいくらですか？', a: '3,000円以上のご注文で送料無料です。それ以外は全国一律500円です。' },
    { q: '返品はできますか？', a: '商品到着後7日以内であれば、未使用に限り返品を承ります。' },
    { q: '支払い方法は？', a: 'クレジットカード、コンビニ払い、各種QRコード決済に対応しています。' },
  ];
  const [open, setOpen] = useState([0]);
  const [exclusive, setExclusive] = useState(false);
  const toggle = (i) => {
    setOpen((p) => {
      if (exclusive) return p.includes(i) ? [] : [i];
      return p.includes(i) ? p.filter((x) => x !== i) : [...p, i];
    });
  };
  return (
    <div className="d-stack">
      <div style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', overflow: 'hidden' }}>
        {items.map((it, i) => {
          const isOpen = open.includes(i);
          return (
            <div key={i} style={{ borderBottom: i < items.length - 1 ? '1px solid var(--border)' : 0 }}>
              <h3 style={{ margin: 0 }}>
                <button
                  aria-expanded={isOpen}
                  aria-controls={`acc-panel-${i}`}
                  id={`acc-head-${i}`}
                  onClick={() => toggle(i)}
                  style={{ display: 'flex', alignItems: 'center', gap: 10, width: '100%', textAlign: 'left', border: 0, background: isOpen ? 'var(--bg-sunken)' : 'transparent', cursor: 'pointer', padding: '13px 14px', fontSize: 13.5, fontWeight: 700, minHeight: 48 }}
                >
                  <span style={{ transform: isOpen ? 'rotate(180deg)' : 'none', transition: 'transform .18s ease', lineHeight: 0, color: 'var(--text-muted)' }} aria-hidden="true">
                    <IconChevronDown size={17} />
                  </span>
                  {it.q}
                </button>
              </h3>
              <div
                id={`acc-panel-${i}`}
                role="region"
                aria-labelledby={`acc-head-${i}`}
                hidden={!isOpen}
                style={{ padding: '0 14px 14px 41px', fontSize: 13.5, color: 'var(--text-muted)', lineHeight: 1.85 }}
              >
                {it.a}
              </div>
            </div>
          );
        })}
      </div>
      <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 12.5 }}>
        <input type="checkbox" checked={exclusive} onChange={(e) => { setExclusive(e.target.checked); setOpen([]); }} />
        1つだけ開く（排他モード）に切り替える
      </label>
      <Note>
        Notion のトグルリストや FAQ でおなじみ。見出しは <code>&lt;button aria-expanded&gt;</code> にするのが必須要件です。
        排他モードは「他が勝手に閉じる」ため、比較したいユーザーには不便になることも。
      </Note>
    </div>
  );
}

/* -------------------------------------------------------------------- tooltip */
export function TooltipDemo() {
  const [show, setShow] = useState(false);
  const [pinned, setPinned] = useState(false);
  const visible = show || pinned;
  return (
    <div className="d-stack">
      <div style={{ display: 'flex', gap: 10, alignItems: 'center', padding: '30px 0 34px', justifyContent: 'center' }}>
        <span style={{ position: 'relative', display: 'inline-block' }}>
          <button
            className="btn btn--secondary"
            aria-label="アーカイブ"
            aria-describedby={visible ? 'tip-1' : undefined}
            onMouseEnter={() => setShow(true)}
            onMouseLeave={() => setShow(false)}
            onFocus={() => setShow(true)}
            onBlur={() => setShow(false)}
            onClick={() => setPinned((v) => !v)}
            onKeyDown={(e) => { if (e.key === 'Escape') { setShow(false); setPinned(false); } }}
            style={{ width: 44, padding: 0 }}
          >
            📦
          </button>
          {visible && (
            <span
              role="tooltip"
              id="tip-1"
              style={{
                position: 'absolute', bottom: 'calc(100% + 8px)', left: '50%', transform: 'translateX(-50%)',
                background: 'var(--text)', color: 'var(--bg-elev)', fontSize: 12, padding: '5px 9px',
                borderRadius: 6, whiteSpace: 'nowrap', boxShadow: 'var(--shadow-md)', zIndex: 3,
              }}
            >
              アーカイブ（E）
            </span>
          )}
        </span>
        <span style={{ fontSize: 12.5, color: 'var(--text-muted)' }}>
          ホバー／Tabキーでのフォーカスの両方で出ます
        </span>
      </div>
      <Note>
        タッチ端末ではホバーが存在しないため、ツールチップだけに情報を入れてはいけません。
        必ず <code>aria-label</code> でも名前を与えます。Esc で閉じられることも WCAG の要件です。
      </Note>
    </div>
  );
}

/* -------------------------------------------------------------------- popover */
export function PopoverDemo() {
  const [open, setOpen] = useState(false);
  const wrapRef = useRef(null);
  useEffect(() => {
    if (!open) return;
    const onDoc = (e) => { if (!wrapRef.current?.contains(e.target)) setOpen(false); };
    const onKey = (e) => { if (e.key === 'Escape') setOpen(false); };
    document.addEventListener('mousedown', onDoc);
    document.addEventListener('keydown', onKey);
    return () => { document.removeEventListener('mousedown', onDoc); document.removeEventListener('keydown', onKey); };
  }, [open]);

  return (
    <div className="d-stack">
      <div style={{ position: 'relative', display: 'inline-block', padding: '10px 0 130px' }} ref={wrapRef}>
        <button
          className="btn btn--secondary btn--sm"
          aria-expanded={open}
          aria-haspopup="dialog"
          onClick={() => setOpen((v) => !v)}
          style={{ gap: 8 }}
        >
          <span className="d-avatar" style={{ width: 22, height: 22, fontSize: 11 }} aria-hidden="true">佐</span>
          佐藤 花子
        </button>
        {open && (
          <div
            role="dialog"
            aria-label="佐藤 花子 のプロフィール"
            style={{
              position: 'absolute', top: 'calc(100% + 8px)', left: 0, width: 250, zIndex: 5,
              background: 'var(--bg-elev)', border: '1px solid var(--border-strong)', borderRadius: 12,
              boxShadow: 'var(--shadow-lg)', padding: 14,
            }}
          >
            <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
              <span className="d-avatar" style={{ width: 42, height: 42, fontSize: 16 }} aria-hidden="true">佐</span>
              <div>
                <div style={{ fontWeight: 700, fontSize: 14 }}>佐藤 花子</div>
                <div style={{ fontSize: 12, color: 'var(--text-muted)' }}>プロダクトデザイナー</div>
              </div>
            </div>
            <p style={{ fontSize: 12.5, color: 'var(--text-muted)', marginTop: 8 }}>デザインシステムとアクセシビリティ担当。</p>
            <div style={{ display: 'flex', gap: 6, marginTop: 10 }}>
              <button className="btn btn--sm" style={{ flex: 1 }}>メッセージ</button>
              <button className="btn btn--secondary btn--sm" onClick={() => setOpen(false)}>閉じる</button>
            </div>
          </div>
        )}
      </div>
      <Note>外側クリック・Esc の両方で閉じます。ツールチップと違い、中にボタンを置けるのがポップオーバー。</Note>
    </div>
  );
}

/* ------------------------------------------------------------------- carousel */
export function CarouselDemo() {
  const items = ['🎬 アクション', '😂 コメディ', '👻 ホラー', '💘 ロマンス', '🚀 SF', '🎭 ドラマ'];
  const ref = useRef(null);
  const [idx, setIdx] = useState(0);
  const scrollTo = (i) => {
    const n = Math.max(0, Math.min(items.length - 1, i));
    setIdx(n);
    const child = ref.current?.children[n];
    child?.scrollIntoView({ behavior: 'smooth', inline: 'start', block: 'nearest' });
  };
  return (
    <div className="d-stack">
      <div style={{ position: 'relative' }}>
        <div
          ref={ref}
          role="region"
          aria-label="おすすめカテゴリ（横スクロール）"
          tabIndex={0}
          onScroll={(e) => setIdx(Math.round(e.currentTarget.scrollLeft / 152))}
          style={{ display: 'flex', gap: 10, overflowX: 'auto', scrollSnapType: 'x mandatory', paddingBottom: 8 }}
        >
          {items.map((it) => (
            <div key={it} style={{ flex: 'none', width: 142, height: 96, scrollSnapAlign: 'start', borderRadius: 12, background: 'var(--bg-sunken)', border: '1px solid var(--border)', display: 'grid', placeItems: 'center', fontSize: 13.5, fontWeight: 700 }}>
              {it}
            </div>
          ))}
          <div style={{ flex: 'none', width: 1 }} />
        </div>
        <button className="btn btn--secondary btn--sm" onClick={() => scrollTo(idx - 1)} aria-label="前へ" style={{ position: 'absolute', left: -6, top: 30, width: 32, padding: 0, borderRadius: '50%' }}>
          <IconChevronLeft size={16} />
        </button>
        <button className="btn btn--secondary btn--sm" onClick={() => scrollTo(idx + 1)} aria-label="次へ" style={{ position: 'absolute', right: -6, top: 30, width: 32, padding: 0, borderRadius: '50%' }}>
          <IconChevronRight size={16} />
        </button>
      </div>
      <div style={{ display: 'flex', gap: 5, justifyContent: 'center' }} aria-hidden="true">
        {items.map((_, i) => (
          <span key={i} style={{ width: i === idx ? 16 : 6, height: 6, borderRadius: 999, background: i === idx ? 'var(--accent)' : 'var(--border-strong)', transition: 'width .2s ease' }} />
        ))}
      </div>
      <Note>
        次のアイテムを端から少し覗かせる（peek）ことで「まだ続きがある」と伝えます。
        自動再生は入れていません（入れる場合は一時停止ボタンが WCAG の必須要件）。
      </Note>
    </div>
  );
}

/* ---------------------------------------------------------------- empty-state */
export function EmptyStateDemo() {
  const [mode, setMode] = useState('first');
  const modes = {
    first: { icon: '📝', title: 'まだメモがありません', desc: '最初のメモを作成して、アイデアを書き留めましょう。', cta: 'メモを作成' },
    noresult: { icon: '🔍', title: '「経費精算」に一致する結果はありません', desc: 'キーワードを短くするか、フィルタを解除してみてください。', cta: 'フィルタを解除' },
    done: { icon: '🎉', title: 'すべて完了しました', desc: '今日のタスクは残っていません。お疲れさまでした。', cta: '完了済みを見る' },
  };
  const m = modes[mode];
  return (
    <div className="d-stack">
      <div className="d-row">
        {Object.entries({ first: '初回利用', noresult: '検索0件', done: '全部完了' }).map(([k, l]) => (
          <button key={k} className={mode === k ? 'btn btn--sm' : 'btn btn--secondary btn--sm'} onClick={() => setMode(k)}>{l}</button>
        ))}
      </div>
      <div style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius-lg)', padding: '34px 18px', textAlign: 'center', background: 'var(--bg-sunken)' }}>
        <div style={{ fontSize: 36 }} aria-hidden="true">{m.icon}</div>
        <h3 style={{ fontSize: 15, marginTop: 8 }}>{m.title}</h3>
        <p style={{ fontSize: 13, color: 'var(--text-muted)', marginTop: 6 }}>{m.desc}</p>
        <button className="btn" style={{ marginTop: 14 }}>{m.cta}</button>
      </div>
      <Note>空状態は1種類ではありません。「初回」「0件」「完了」で文言もCTAも変えるのが正解です。</Note>
    </div>
  );
}

/* ------------------------------------------------------------------- skeleton */
export function SkeletonDemo() {
  const [loading, setLoading] = useState(true);
  const reload = () => { setLoading(true); setTimeout(() => setLoading(false), 1800); };
  useEffect(() => { const t = setTimeout(() => setLoading(false), 1800); return () => clearTimeout(t); }, []);
  return (
    <div className="d-stack">
      <div aria-busy={loading} style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: 14 }}>
        {loading ? (
          <div aria-hidden="true">
            <span className="sr-only">読み込み中</span>
            {[0, 1].map((i) => (
              <div key={i} style={{ display: 'flex', gap: 11, marginBottom: 14 }}>
                <div className="d-skel" style={{ width: 44, height: 44, borderRadius: '50%', flex: 'none' }} />
                <div style={{ flex: 1 }}>
                  <div className="d-skel" style={{ height: 12, width: '42%', marginBottom: 7 }} />
                  <div className="d-skel" style={{ height: 10, width: '92%', marginBottom: 5 }} />
                  <div className="d-skel" style={{ height: 10, width: '70%' }} />
                </div>
              </div>
            ))}
          </div>
        ) : (
          SAMPLE_USERS.slice(0, 2).map((u) => (
            <div key={u.id} style={{ display: 'flex', gap: 11, marginBottom: 14 }}>
              <span className="d-avatar" style={{ width: 44, height: 44, background: u.color, fontSize: 16 }} aria-hidden="true">{initials(u.name)}</span>
              <div>
                <div style={{ fontWeight: 700, fontSize: 13.5 }}>{u.name}</div>
                <div style={{ fontSize: 12.5, color: 'var(--text-muted)' }}>スケルトンと同じ位置・同じ行数で表示されるので、画面が飛びません。</div>
              </div>
            </div>
          ))
        )}
      </div>
      <button className="btn btn--secondary btn--sm" onClick={reload} style={{ gap: 6 }}><IconRefresh size={15} /> もう一度読み込む</button>
      <Note>スケルトンの形＝実データの形にすること。ズレているとレイアウトシフトが起き、かえって不快になります。</Note>
    </div>
  );
}

/* --------------------------------------------------------- progress-indicator */
export function ProgressIndicatorDemo() {
  const [p, setP] = useState(0);
  const [running, setRunning] = useState(false);
  useEffect(() => {
    if (!running) return;
    const iv = setInterval(() => {
      setP((v) => {
        if (v >= 100) { clearInterval(iv); setRunning(false); return 100; }
        return v + 4;
      });
    }, 90);
    return () => clearInterval(iv);
  }, [running]);

  return (
    <div className="d-stack">
      <div>
        <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 12.5, marginBottom: 5 }}>
          <span>確定型（進捗が分かる）</span>
          <span style={{ fontVariantNumeric: 'tabular-nums', fontWeight: 700 }}>{p}%</span>
        </div>
        <div role="progressbar" aria-valuenow={p} aria-valuemin={0} aria-valuemax={100} aria-label="アップロードの進捗" style={{ height: 8, background: 'var(--bg-sunken)', borderRadius: 999, overflow: 'hidden' }}>
          <div style={{ height: '100%', width: `${p}%`, background: p === 100 ? 'var(--success)' : 'var(--accent)', transition: 'width .09s linear' }} />
        </div>
      </div>

      <div className="d-row" style={{ gap: 14 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 12.5 }}>
          <span
            aria-hidden="true"
            style={{ width: 20, height: 20, borderRadius: '50%', border: '2.5px solid var(--border-strong)', borderTopColor: 'var(--accent)', animation: 'spin .8s linear infinite', display: 'inline-block' }}
          />
          不確定型（所要時間が読めない）
        </div>
        <style>{'@keyframes spin { to { transform: rotate(360deg) } } @media (prefers-reduced-motion: reduce) { [style*="spin"] { animation: none !important } }'}</style>
      </div>

      <div className="d-row">
        <button className="btn btn--sm" onClick={() => { setP(0); setRunning(true); }} disabled={running}>
          {running ? 'アップロード中…' : 'アップロード開始'}
        </button>
        <span aria-live="polite" style={{ fontSize: 12.5, color: 'var(--text-muted)' }}>
          {p === 100 ? '✅ アップロードが完了しました' : running ? `${p}% 完了` : ''}
        </span>
      </div>
      <Note>処理中はボタンを disabled にして二重送信を防ぎ、完了は aria-live で伝えます。進捗が計算できるならスピナーで済ませない。</Note>
    </div>
  );
}
