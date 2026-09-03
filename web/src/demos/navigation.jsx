import { useEffect, useMemo, useRef, useState } from 'react';
import { Note, Out, Phone } from './common.jsx';
import {
  IconBell, IconChevronLeft, IconChevronRight, IconClose, IconGrid, IconHome, IconMenu,
  IconMore, IconPlus, IconSearch, IconUser, IconCheck, IconCode,
} from '../components/Icons.jsx';

/* -------------------------------------------------------------------- app-bar */
export function AppBarDemo() {
  const [scrolled, setScrolled] = useState(false);
  const scroller = useRef(null);
  return (
    <div className="d-stack">
      <Phone height={320}>
        <div
          style={{
            display: 'flex', alignItems: 'center', gap: 6, padding: '0 8px',
            height: scrolled ? 46 : 78, background: 'var(--bg-elev)', borderBottom: '1px solid var(--border)',
            transition: 'height .2s ease', flex: 'none', position: 'relative',
          }}
        >
          <button className="iconbtn" aria-label="戻る"><IconChevronLeft size={20} /></button>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontSize: scrolled ? 15 : 22, fontWeight: 800, transition: 'font-size .2s ease', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
              受信トレイ
            </div>
          </div>
          <button className="iconbtn" aria-label="検索"><IconSearch size={19} /></button>
          <button className="iconbtn" aria-label="その他のメニュー"><IconMore size={19} /></button>
        </div>
        <div
          ref={scroller}
          onScroll={(e) => setScrolled(e.currentTarget.scrollTop > 12)}
          style={{ flex: 1, overflowY: 'auto', padding: 10 }}
        >
          {Array.from({ length: 12 }).map((_, i) => (
            <div key={i} style={{ padding: '10px 6px', borderBottom: '1px solid var(--border)', fontSize: 13 }}>
              <strong>差出人 {i + 1}</strong>
              <div style={{ color: 'var(--text-muted)', fontSize: 12 }}>件名のサンプルテキストです</div>
            </div>
          ))}
        </div>
      </Phone>
      <Out label="状態">{scrolled ? 'スクロール中：ラージタイトルが縮小' : '最上部：ラージタイトル表示'}</Out>
      <Note>
        中のリストをスクロールしてください。iOS のラージタイトルのように、スクロールでヘッダーが縮みます。
        左＝戻る／中央＝タイトル／右＝アクション（3個以内）が世界共通の配置です。
      </Note>
    </div>
  );
}

/* --------------------------------------------------------- bottom-navigation */
const TABS = [
  { id: 'home', label: 'ホーム', Icon: IconHome, badge: 0 },
  { id: 'search', label: '検索', Icon: IconSearch, badge: 0 },
  { id: 'notif', label: 'お知らせ', Icon: IconBell, badge: 3 },
  { id: 'me', label: 'マイページ', Icon: IconUser, badge: 0 },
];

export function BottomNavigationDemo() {
  const [tab, setTab] = useState('home');
  // 各タブのスクロール位置を保持する（タブ切替で状態を失わないのが原則）
  const [scrollPos, setScrollPos] = useState({});
  const ref = useRef(null);

  const switchTo = (id) => {
    setScrollPos((p) => ({ ...p, [tab]: ref.current?.scrollTop ?? 0 }));
    setTab(id);
  };
  useEffect(() => {
    if (ref.current) ref.current.scrollTop = scrollPos[tab] ?? 0;
  }, [tab]); // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <div className="d-stack">
      <Phone height={340}>
        <div ref={ref} style={{ flex: 1, overflowY: 'auto', padding: 12 }}>
          <div style={{ fontWeight: 800, fontSize: 15, marginBottom: 8 }}>{TABS.find((t) => t.id === tab).label}</div>
          {Array.from({ length: 14 }).map((_, i) => (
            <div key={i} style={{ padding: '9px 0', borderBottom: '1px solid var(--border)', fontSize: 13, color: 'var(--text-muted)' }}>
              {TABS.find((t) => t.id === tab).label} の項目 {i + 1}
            </div>
          ))}
        </div>
        <nav
          aria-label="デモ用ボトムナビゲーション"
          style={{ display: 'flex', borderTop: '1px solid var(--border)', background: 'var(--bg-elev)', flex: 'none' }}
        >
          {TABS.map(({ id, label, Icon, badge }) => {
            const on = tab === id;
            return (
              <button
                key={id}
                onClick={() => switchTo(id)}
                aria-current={on ? 'page' : undefined}
                aria-label={badge ? `${label}、未読${badge}件` : label}
                style={{
                  flex: 1, border: 0, background: 'transparent', cursor: 'pointer',
                  padding: '8px 0 10px', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 2,
                  color: on ? 'var(--accent)' : 'var(--text-muted)', fontWeight: on ? 700 : 400, fontSize: 10.5,
                }}
              >
                <span style={{ position: 'relative', lineHeight: 0 }}>
                  <Icon size={22} />
                  {badge > 0 && (
                    <span aria-hidden="true" style={{ position: 'absolute', top: -4, right: -7, minWidth: 16, height: 16, padding: '0 4px', borderRadius: 999, background: 'var(--danger)', color: '#fff', fontSize: 10, fontWeight: 700, display: 'grid', placeItems: 'center' }}>
                      {badge}
                    </span>
                  )}
                </span>
                {label}
              </button>
            );
          })}
        </nav>
      </Phone>
      <Note>
        タブを切り替えても、各タブのスクロール位置が保持されます（元のタブに戻ると続きから）。
        これができていないアプリは非常に多い、代表的な作り込みポイントです。
      </Note>
    </div>
  );
}

/* -------------------------------------------------------------------- tab-bar */
export function TabBarDemo() {
  const tabs = [
    { id: 'overview', label: '概要', body: '商品の概要説明。タブは「同じものの別の見方」を切り替えるUIです。' },
    { id: 'spec', label: '仕様', body: 'サイズ: 120×80×35mm / 重量: 240g / 電源: USB-C' },
    { id: 'review', label: 'レビュー(128)', body: '★4.3 — 「思ったより軽くて驚きました」ほか127件。' },
    { id: 'qa', label: 'Q&A', body: 'Q. 保証期間は？ A. お買い上げから1年間です。' },
  ];
  const [active, setActive] = useState('overview');
  const refs = useRef({});

  const onKeyDown = (e) => {
    const i = tabs.findIndex((t) => t.id === active);
    let next = null;
    if (e.key === 'ArrowRight') next = tabs[(i + 1) % tabs.length];
    if (e.key === 'ArrowLeft') next = tabs[(i - 1 + tabs.length) % tabs.length];
    if (e.key === 'Home') next = tabs[0];
    if (e.key === 'End') next = tabs[tabs.length - 1];
    if (next) { e.preventDefault(); setActive(next.id); refs.current[next.id]?.focus(); }
  };

  return (
    <div className="d-stack">
      <div style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', overflow: 'hidden' }}>
        <div role="tablist" aria-label="商品情報" onKeyDown={onKeyDown} style={{ display: 'flex', overflowX: 'auto', borderBottom: '1px solid var(--border)', background: 'var(--bg-sunken)' }}>
          {tabs.map((t) => {
            const on = active === t.id;
            return (
              <button
                key={t.id}
                ref={(el) => (refs.current[t.id] = el)}
                role="tab"
                id={`tab-${t.id}`}
                aria-selected={on}
                aria-controls={`panel-${t.id}`}
                tabIndex={on ? 0 : -1}
                onClick={() => setActive(t.id)}
                style={{
                  border: 0, background: 'transparent', cursor: 'pointer', padding: '11px 15px',
                  fontSize: 13.5, fontWeight: on ? 700 : 500, whiteSpace: 'nowrap',
                  color: on ? 'var(--accent)' : 'var(--text-muted)',
                  borderBottom: `2px solid ${on ? 'var(--accent)' : 'transparent'}`, marginBottom: -1,
                }}
              >
                {t.label}
              </button>
            );
          })}
        </div>
        {tabs.map((t) => (
          <div
            key={t.id}
            role="tabpanel"
            id={`panel-${t.id}`}
            aria-labelledby={`tab-${t.id}`}
            hidden={active !== t.id}
            tabIndex={0}
            style={{ padding: 16, fontSize: 13.5, lineHeight: 1.8, minHeight: 90 }}
          >
            {t.body}
          </div>
        ))}
      </div>
      <Note>タブにフォーカスして ← → キーを押すと、タブ間を移動できます（WAI-ARIA の tabs パターン）。</Note>
    </div>
  );
}

/* ------------------------------------------------------------- drawer-sidebar */
export function DrawerSidebarDemo() {
  const [open, setOpen] = useState(false);
  const [current, setCurrent] = useState('受信トレイ');
  const items = [
    { group: 'メール', links: ['受信トレイ', 'スター付き', '送信済み', '下書き'] },
    { group: 'ラベル', links: ['仕事', 'プライベート', '請求書'] },
  ];
  return (
    <div className="d-stack">
      <Phone height={330}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, padding: '0 8px', height: 48, borderBottom: '1px solid var(--border)', background: 'var(--bg-elev)', flex: 'none' }}>
          <button className="iconbtn" onClick={() => setOpen(true)} aria-label="ナビゲーションを開く" aria-expanded={open}><IconMenu size={20} /></button>
          <strong style={{ fontSize: 14 }}>{current}</strong>
        </div>
        <div style={{ flex: 1, padding: 12, fontSize: 13, color: 'var(--text-muted)', overflow: 'hidden' }}>
          「{current}」の一覧がここに表示されます。
        </div>

        {open && (
          <>
            <div onClick={() => setOpen(false)} style={{ position: 'absolute', inset: 0, background: 'rgba(0,0,0,.45)', zIndex: 2 }} />
            <nav
              aria-label="デモ用ドロワー"
              style={{
                position: 'absolute', inset: '0 auto 0 0', width: '74%', zIndex: 3, background: 'var(--bg-elev)',
                borderRight: '1px solid var(--border)', padding: 10, overflowY: 'auto', animation: 'slideIn .18s ease',
              }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '2px 4px 8px' }}>
                <strong style={{ fontSize: 13.5 }}>メニュー</strong>
                <button className="iconbtn" style={{ width: 30, height: 30 }} onClick={() => setOpen(false)} aria-label="閉じる"><IconClose size={16} /></button>
              </div>
              {items.map((g) => (
                <div key={g.group}>
                  <div className="sidebar__title" style={{ padding: '8px 8px 2px' }}>{g.group}</div>
                  {g.links.map((l) => (
                    <button
                      key={l}
                      onClick={() => { setCurrent(l); setOpen(false); }}
                      aria-current={current === l ? 'page' : undefined}
                      style={{
                        display: 'block', width: '100%', textAlign: 'left', border: 0, cursor: 'pointer',
                        padding: '9px 10px', borderRadius: 8, fontSize: 13.5,
                        background: current === l ? 'var(--accent-soft)' : 'transparent',
                        color: current === l ? 'var(--accent)' : 'var(--text)',
                        fontWeight: current === l ? 700 : 400,
                      }}
                    >
                      {l}
                    </button>
                  ))}
                </div>
              ))}
            </nav>
          </>
        )}
      </Phone>
      <Note>背景の暗幕タップでも閉じられます。実装では Esc キーとフォーカストラップも必須（このアプリ本体のドロワーは対応済み）。</Note>
    </div>
  );
}

/* ------------------------------------------------------------- hamburger-menu */
export function HamburgerMenuDemo() {
  const [open, setOpen] = useState(false);
  return (
    <div className="d-stack">
      <div style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', overflow: 'hidden' }}>
        <div style={{ display: 'flex', alignItems: 'center', padding: '8px 10px', borderBottom: '1px solid var(--border)', background: 'var(--bg-sunken)' }}>
          <strong style={{ fontSize: 14, flex: 1 }}>Example Corp.</strong>
          <button
            onClick={() => setOpen((v) => !v)}
            aria-label={open ? 'メニューを閉じる' : 'メニューを開く'}
            aria-expanded={open}
            aria-controls="hb-panel"
            className="btn btn--secondary btn--sm"
            style={{ gap: 6 }}
          >
            {open ? <IconClose size={16} /> : <IconMenu size={16} />}
            <span style={{ fontSize: 12 }}>MENU</span>
          </button>
        </div>
        <div id="hb-panel" hidden={!open} style={{ padding: 8 }}>
          {['ホーム', 'サービス', '導入事例', '料金', 'お問い合わせ'].map((l) => (
            <a key={l} href="#/u/hamburger-menu" onClick={(e) => e.preventDefault()} style={{ display: 'block', padding: '10px 8px', fontSize: 13.5, textDecoration: 'none', color: 'var(--text)', borderBottom: '1px solid var(--border)' }}>
              {l}
            </a>
          ))}
        </div>
        {!open && <div style={{ padding: 16, fontSize: 13, color: 'var(--text-muted)' }}>ページ本文。狭い画面ではナビゲーションを畳んでいます。</div>}
      </div>
      <Out label="aria-expanded">{String(open)}</Out>
      <Note>開いている間はアイコンを × に変える、「MENU」の文字を添える、の2点で認知率が上がります。</Note>
    </div>
  );
}

/* --------------------------------------------------------------- breadcrumbs */
export function BreadcrumbsDemo() {
  const full = ['ホーム', '家電', 'キッチン家電', '電気ケトル', 'ステンレス電気ケトル 1.0L'];
  const [narrow, setNarrow] = useState(false);
  const shown = narrow ? [full[0], '…', full[full.length - 2], full[full.length - 1]] : full;
  return (
    <div className="d-stack">
      <div style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: '10px 12px' }}>
        <nav aria-label="パンくずリスト">
          <ol style={{ display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: 4, listStyle: 'none', margin: 0, padding: 0, fontSize: 12.5 }}>
            {shown.map((item, i) => {
              const isLast = i === shown.length - 1;
              return (
                <li key={i} style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
                  {i > 0 && <span aria-hidden="true" style={{ color: 'var(--text-faint)' }}>›</span>}
                  {isLast ? (
                    <span aria-current="page" style={{ color: 'var(--text)', fontWeight: 700 }}>{item}</span>
                  ) : item === '…' ? (
                    <span style={{ color: 'var(--text-faint)' }}>…</span>
                  ) : (
                    <a href="#/u/breadcrumbs" onClick={(e) => e.preventDefault()} style={{ color: 'var(--text-muted)' }}>{item}</a>
                  )}
                </li>
              );
            })}
          </ol>
        </nav>
      </div>
      <button className="btn btn--secondary btn--sm" onClick={() => setNarrow((v) => !v)}>
        {narrow ? '全階層を表示' : 'モバイル幅を想定して省略表示'}
      </button>
      <Note>最後の要素（現在地）はリンクにしません。狭い幅では中間を「…」で省略します。</Note>
    </div>
  );
}

/* ---------------------------------------------------------------- pagination */
export function PaginationDemo() {
  const total = 12;
  const [page, setPage] = useState(1);
  const pages = useMemo(() => {
    const out = [];
    for (let i = 1; i <= total; i++) {
      if (i === 1 || i === total || Math.abs(i - page) <= 1) out.push(i);
      else if (out[out.length - 1] !== '…') out.push('…');
    }
    return out;
  }, [page]);
  const items = Array.from({ length: 4 }).map((_, i) => `商品 ${(page - 1) * 4 + i + 1}`);

  return (
    <div className="d-stack">
      <div className="d-list">
        {items.map((t) => <div className="d-list__item" key={t}><span style={{ fontSize: 13.5 }}>{t}</span></div>)}
      </div>
      <nav aria-label="ページネーション" style={{ display: 'flex', gap: 4, flexWrap: 'wrap', justifyContent: 'center', alignItems: 'center' }}>
        <button className="btn btn--secondary btn--sm" onClick={() => setPage((p) => Math.max(1, p - 1))} disabled={page === 1} aria-label="前のページへ">
          <IconChevronLeft size={15} />
        </button>
        {pages.map((p, i) =>
          p === '…' ? (
            <span key={`e${i}`} style={{ padding: '0 4px', color: 'var(--text-faint)' }}>…</span>
          ) : (
            <button
              key={p}
              onClick={() => setPage(p)}
              aria-current={p === page ? 'page' : undefined}
              aria-label={`${p}ページ目へ`}
              className={p === page ? 'btn btn--sm' : 'btn btn--secondary btn--sm'}
              style={{ minWidth: 34, padding: '0 8px' }}
            >
              {p}
            </button>
          )
        )}
        <button className="btn btn--secondary btn--sm" onClick={() => setPage((p) => Math.min(total, p + 1))} disabled={page === total} aria-label="次のページへ">
          <IconChevronRight size={15} />
        </button>
      </nav>
      <Out label="現在">{page} / {total} ページ（全{total * 4}件）</Out>
      <Note>ページ数が多くても、前後1ページ＋最初/最後＋「…」に省略。全体量が分かるのが無限スクロールとの違いです。</Note>
    </div>
  );
}

/* ------------------------------------------------------------- wizard-stepper */
export function WizardStepperDemo() {
  const steps = ['配送先', '配送方法', '支払い', '確認'];
  const [step, setStep] = useState(0);
  const [form, setForm] = useState({ addr: '', ship: 'std', pay: 'card' });
  const canNext = step !== 0 || form.addr.trim().length > 0;

  return (
    <div className="d-stack">
      <ol style={{ display: 'flex', listStyle: 'none', padding: 0, margin: 0, gap: 4 }}>
        {steps.map((s, i) => {
          const state = i < step ? 'done' : i === step ? 'current' : 'todo';
          return (
            <li key={s} style={{ flex: 1, textAlign: 'center' }} aria-current={state === 'current' ? 'step' : undefined}>
              <div
                style={{
                  height: 4, borderRadius: 999, marginBottom: 6,
                  background: state === 'todo' ? 'var(--border)' : 'var(--accent)',
                }}
              />
              <div style={{ fontSize: 11.5, fontWeight: state === 'current' ? 700 : 400, color: state === 'todo' ? 'var(--text-faint)' : state === 'current' ? 'var(--accent)' : 'var(--text-muted)' }}>
                {state === 'done' ? '✓ ' : ''}{s}
              </div>
            </li>
          );
        })}
      </ol>

      <div style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: 14, minHeight: 140 }}>
        <div style={{ fontSize: 12, color: 'var(--text-faint)', marginBottom: 8 }}>ステップ {step + 1} / {steps.length}</div>
        {step === 0 && (
          <div className="field">
            <label className="field__label" htmlFor="wz-addr">お届け先住所</label>
            <input id="wz-addr" className="input" value={form.addr} onChange={(e) => setForm({ ...form, addr: e.target.value })} placeholder="東京都千代田区…" />
            <span className="field__hint">入力すると「次へ」が押せるようになります</span>
          </div>
        )}
        {step === 1 && (
          <div className="d-stack" style={{ gap: 6 }}>
            {[['std', '通常配送（無料）'], ['exp', 'お急ぎ便（+500円）']].map(([v, l]) => (
              <label key={v} style={{ display: 'flex', gap: 8, alignItems: 'center', fontSize: 13.5 }}>
                <input type="radio" name="wz-ship" checked={form.ship === v} onChange={() => setForm({ ...form, ship: v })} />{l}
              </label>
            ))}
          </div>
        )}
        {step === 2 && (
          <div className="d-stack" style={{ gap: 6 }}>
            {[['card', 'クレジットカード'], ['cvs', 'コンビニ払い']].map(([v, l]) => (
              <label key={v} style={{ display: 'flex', gap: 8, alignItems: 'center', fontSize: 13.5 }}>
                <input type="radio" name="wz-pay" checked={form.pay === v} onChange={() => setForm({ ...form, pay: v })} />{l}
              </label>
            ))}
          </div>
        )}
        {step === 3 && (
          <div style={{ fontSize: 13.5, lineHeight: 2 }}>
            <div><span style={{ color: 'var(--text-faint)' }}>お届け先：</span>{form.addr || '（未入力）'}</div>
            <div><span style={{ color: 'var(--text-faint)' }}>配送方法：</span>{form.ship === 'std' ? '通常配送' : 'お急ぎ便'}</div>
            <div><span style={{ color: 'var(--text-faint)' }}>支払い：</span>{form.pay === 'card' ? 'クレジットカード' : 'コンビニ払い'}</div>
            <button className="btn btn--ghost btn--sm" style={{ marginTop: 6 }} onClick={() => setStep(0)}>修正する</button>
          </div>
        )}
      </div>

      <div style={{ display: 'flex', gap: 8 }}>
        <button className="btn btn--secondary" onClick={() => setStep((s) => Math.max(0, s - 1))} disabled={step === 0}>戻る</button>
        <button className="btn" style={{ flex: 1 }} onClick={() => setStep((s) => Math.min(steps.length - 1, s + 1))} disabled={step === steps.length - 1 || !canNext}>
          {step === steps.length - 2 ? '確認へ進む' : '次へ'}
        </button>
      </div>
      <Note>「戻る」を押しても入力内容は保持されます。最終ステップに確認画面と「修正する」導線を置くのが定石。</Note>
    </div>
  );
}

/* ------------------------------------------------------------------------ fab */
export function FabDemo() {
  const [notes, setNotes] = useState(['買い物メモ', '会議の議事録']);
  const [shrunk, setShrunk] = useState(false);
  return (
    <div className="d-stack">
      <Phone height={320}>
        <div
          onScroll={(e) => setShrunk(e.currentTarget.scrollTop > 20)}
          style={{ flex: 1, overflowY: 'auto', padding: 12, paddingBottom: 78 }}
        >
          {notes.map((n, i) => (
            <div key={i} style={{ border: '1px solid var(--border)', borderRadius: 10, padding: 11, marginBottom: 8, fontSize: 13.5, background: 'var(--bg-elev)' }}>{n}</div>
          ))}
          {notes.length === 0 && <div style={{ fontSize: 13, color: 'var(--text-muted)', textAlign: 'center', paddingTop: 40 }}>メモがありません</div>}
          <div style={{ height: 20 }} />
        </div>
        <button
          onClick={() => setNotes((p) => [...p, `新しいメモ ${p.length + 1}`])}
          aria-label="新しいメモを作成"
          style={{
            position: 'absolute', right: 14, bottom: 16, zIndex: 2,
            height: 52, borderRadius: 999, border: 0, cursor: 'pointer',
            background: 'var(--accent)', color: 'var(--accent-text)', boxShadow: 'var(--shadow-md)',
            display: 'flex', alignItems: 'center', gap: 8, padding: shrunk ? 0 : '0 20px', width: shrunk ? 52 : 'auto',
            justifyContent: 'center', fontWeight: 700, fontSize: 14, transition: 'width .2s ease, padding .2s ease',
          }}
        >
          <IconPlus size={22} />
          {!shrunk && <span>作成</span>}
        </button>
      </Phone>
      <Note>
        スクロールすると Extended FAB がアイコンのみに縮みます。リスト下部に余白を確保して、最終行を隠さないのが重要。
      </Note>
    </div>
  );
}

/* ---------------------------------------------------------- segmented-control */
export function SegmentedControlDemo() {
  const options = ['日', '週', '月'];
  const [sel, setSel] = useState('週');
  const refs = useRef({});
  return (
    <div className="d-stack">
      <div
        role="radiogroup"
        aria-label="表示単位"
        onKeyDown={(e) => {
          const i = options.indexOf(sel);
          let n = null;
          if (e.key === 'ArrowRight') n = options[(i + 1) % options.length];
          if (e.key === 'ArrowLeft') n = options[(i - 1 + options.length) % options.length];
          if (n) { e.preventDefault(); setSel(n); refs.current[n]?.focus(); }
        }}
        style={{ display: 'inline-flex', background: 'var(--bg-sunken)', border: '1px solid var(--border)', borderRadius: 10, padding: 3, gap: 2 }}
      >
        {options.map((o) => {
          const on = sel === o;
          return (
            <button
              key={o}
              ref={(el) => (refs.current[o] = el)}
              role="radio"
              aria-checked={on}
              tabIndex={on ? 0 : -1}
              onClick={() => setSel(o)}
              style={{
                border: 0, cursor: 'pointer', minWidth: 62, padding: '7px 14px', borderRadius: 8, fontSize: 13.5,
                fontWeight: on ? 700 : 500,
                background: on ? 'var(--bg-elev)' : 'transparent',
                color: on ? 'var(--text)' : 'var(--text-muted)',
                boxShadow: on ? 'var(--shadow-sm)' : 'none', transition: 'background .15s ease',
              }}
            >
              {o}
            </button>
          );
        })}
      </div>
      <div style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: 16, fontSize: 13.5 }}>
        {sel === '日' && '2026年9月4日（木）の予定を表示しています。'}
        {sel === '週' && '2026年9月1日〜9月7日の予定を表示しています。'}
        {sel === '月' && '2026年9月の予定を表示しています。'}
      </div>
      <Note>← → キーでも切り替えられます。選択中は背景色＋文字色＋影の3点で差をつけ、色だけに頼りません。</Note>
    </div>
  );
}

/* ------------------------------------------------------------ command-palette */
const COMMANDS = [
  { id: 1, label: '新しいページを作成', hint: 'コマンド', icon: '＋' },
  { id: 2, label: '設定を開く', hint: 'コマンド', icon: '⚙' },
  { id: 3, label: 'ダークモードを切り替える', hint: 'コマンド', icon: '◐' },
  { id: 4, label: '週次レポート 2026-09', hint: 'ページ', icon: '📄' },
  { id: 5, label: 'デザインガイドライン', hint: 'ページ', icon: '📄' },
  { id: 6, label: 'メンバーを招待', hint: 'コマンド', icon: '👤' },
];

export function CommandPaletteDemo() {
  const [open, setOpen] = useState(false);
  const [q, setQ] = useState('');
  const [active, setActive] = useState(0);
  const [log, setLog] = useState('（⌘K でも開けます — このアプリ本体の検索も同じ仕組みです）');
  const inputRef = useRef(null);

  const results = useMemo(
    () => COMMANDS.filter((c) => c.label.toLowerCase().includes(q.toLowerCase())),
    [q]
  );

  useEffect(() => { if (open) inputRef.current?.focus(); }, [open]);
  useEffect(() => setActive(0), [q]);

  const run = (c) => { if (!c) return; setLog(`実行: ${c.label}`); setOpen(false); setQ(''); };

  return (
    <div className="d-stack">
      <button className="btn btn--secondary" onClick={() => setOpen(true)} style={{ justifyContent: 'space-between', width: '100%', maxWidth: 340 }}>
        <span style={{ display: 'flex', alignItems: 'center', gap: 8 }}><IconSearch size={16} /> コマンドを検索…</span>
        <kbd style={{ fontSize: 11 }}>⌘K</kbd>
      </button>

      {open && (
        <div
          onMouseDown={(e) => { if (e.target === e.currentTarget) setOpen(false); }}
          style={{ position: 'fixed', inset: 0, zIndex: 70, background: 'rgba(8,11,22,.5)', display: 'flex', justifyContent: 'center', paddingTop: '14vh' }}
        >
          <div
            role="dialog"
            aria-modal="true"
            aria-label="コマンドパレット"
            style={{ width: 'min(460px, 92vw)', height: 'fit-content', maxHeight: '60vh', display: 'flex', flexDirection: 'column', background: 'var(--bg-elev)', border: '1px solid var(--border-strong)', borderRadius: 14, boxShadow: 'var(--shadow-lg)', overflow: 'hidden' }}
            onKeyDown={(e) => {
              if (e.key === 'Escape') setOpen(false);
              if (e.key === 'ArrowDown') { e.preventDefault(); setActive((i) => Math.min(i + 1, results.length - 1)); }
              if (e.key === 'ArrowUp') { e.preventDefault(); setActive((i) => Math.max(i - 1, 0)); }
              if (e.key === 'Enter') { e.preventDefault(); run(results[active]); }
            }}
          >
            <div style={{ display: 'flex', alignItems: 'center', gap: 9, padding: '11px 13px', borderBottom: '1px solid var(--border)' }}>
              <IconSearch size={17} />
              <input
                ref={inputRef}
                value={q}
                onChange={(e) => setQ(e.target.value)}
                placeholder="コマンドやページ名を入力…"
                aria-label="コマンドを検索"
                style={{ flex: 1, border: 0, background: 'transparent', outline: 'none', fontSize: 15, color: 'var(--text)' }}
              />
            </div>
            <div style={{ overflowY: 'auto', padding: 5 }} role="listbox" aria-label="候補">
              {results.length === 0 && <div style={{ padding: 20, textAlign: 'center', fontSize: 13, color: 'var(--text-muted)' }}>一致するコマンドがありません</div>}
              {results.map((c, i) => (
                <button
                  key={c.id}
                  role="option"
                  aria-selected={i === active}
                  onMouseEnter={() => setActive(i)}
                  onClick={() => run(c)}
                  style={{
                    display: 'flex', alignItems: 'center', gap: 10, width: '100%', textAlign: 'left',
                    border: 0, cursor: 'pointer', padding: '9px 10px', borderRadius: 8, fontSize: 13.5,
                    background: i === active ? 'var(--accent-soft)' : 'transparent',
                  }}
                >
                  <span aria-hidden="true" style={{ width: 20, textAlign: 'center' }}>{c.icon}</span>
                  <span style={{ flex: 1 }}>{c.label}</span>
                  <span style={{ fontSize: 11, color: 'var(--text-faint)' }}>{c.hint}</span>
                </button>
              ))}
            </div>
          </div>
        </div>
      )}
      <Out label="ログ">{log}</Out>
      <Note>実行できる「コマンド」と移動先の「ページ」を右側のラベルで区別しています。⌘K の表示自体が発見可能性を担保します。</Note>
    </div>
  );
}
