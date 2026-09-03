import { useEffect, useRef, useState } from 'react';
import { Note, Out, Phone } from './common.jsx';
import { IconAlert, IconCheck, IconClose, IconInfo, IconMore, IconShare, IconTrash } from '../components/Icons.jsx';

/** デモ内で使う簡易フォーカストラップ付きダイアログ */
function DemoDialog({ open, onClose, labelledBy, children, align = 'center', width = 340 }) {
  const ref = useRef(null);
  useEffect(() => {
    if (!open) return;
    const prev = document.activeElement;
    const node = ref.current;
    const focusables = () => [...(node?.querySelectorAll('button, a[href], input, select, textarea, [tabindex]:not([tabindex="-1"])') ?? [])];
    focusables()[0]?.focus();
    const onKey = (e) => {
      if (e.key === 'Escape') { e.preventDefault(); onClose(); return; }
      if (e.key !== 'Tab') return;
      const list = focusables();
      if (!list.length) return;
      const [first, last] = [list[0], list[list.length - 1]];
      if (e.shiftKey && document.activeElement === first) { e.preventDefault(); last.focus(); }
      else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first.focus(); }
    };
    document.addEventListener('keydown', onKey);
    return () => { document.removeEventListener('keydown', onKey); if (prev instanceof HTMLElement) prev.focus(); };
  }, [open, onClose]);

  if (!open) return null;
  return (
    <div
      onMouseDown={(e) => { if (e.target === e.currentTarget) onClose(); }}
      style={{
        position: 'fixed', inset: 0, zIndex: 80, background: 'rgba(8,11,22,.55)',
        display: 'flex', justifyContent: 'center',
        alignItems: align === 'bottom' ? 'flex-end' : 'center', padding: align === 'bottom' ? 0 : 16,
      }}
    >
      <div
        ref={ref}
        role="dialog"
        aria-modal="true"
        aria-labelledby={labelledBy}
        style={{
          width: align === 'bottom' ? '100%' : `min(${width}px, 92vw)`,
          maxWidth: align === 'bottom' ? 460 : undefined,
          background: 'var(--bg-elev)', border: '1px solid var(--border-strong)',
          borderRadius: align === 'bottom' ? '18px 18px 0 0' : 14,
          boxShadow: 'var(--shadow-lg)', padding: 18,
          animation: align === 'bottom' ? 'sheetUp .2s ease' : 'none',
        }}
      >
        {children}
      </div>
      <style>{'@keyframes sheetUp { from { transform: translateY(100%) } to { transform: none } }'}</style>
    </div>
  );
}

/* --------------------------------------------------------------- modal-dialog */
export function ModalDialogDemo() {
  const [open, setOpen] = useState(false);
  const [name, setName] = useState('');
  const [saved, setSaved] = useState('');
  return (
    <div className="d-stack">
      <button className="btn" onClick={() => setOpen(true)}>プロジェクトを作成（モーダルを開く）</button>
      <DemoDialog open={open} onClose={() => setOpen(false)} labelledBy="md-title">
        <div style={{ display: 'flex', alignItems: 'flex-start', gap: 10 }}>
          <h3 id="md-title" style={{ fontSize: 16, flex: 1 }}>新しいプロジェクト</h3>
          <button className="iconbtn" style={{ width: 30, height: 30 }} onClick={() => setOpen(false)} aria-label="閉じる"><IconClose size={17} /></button>
        </div>
        <div className="field" style={{ marginTop: 12 }}>
          <label className="field__label" htmlFor="md-name">プロジェクト名</label>
          <input id="md-name" className="input" value={name} onChange={(e) => setName(e.target.value)} placeholder="例: 2026年上期リニューアル" />
        </div>
        <div style={{ display: 'flex', gap: 8, marginTop: 16, justifyContent: 'flex-end' }}>
          <button className="btn btn--secondary" onClick={() => setOpen(false)}>キャンセル</button>
          <button className="btn" onClick={() => { setSaved(name); setOpen(false); }} disabled={!name.trim()}>作成する</button>
        </div>
      </DemoDialog>
      <Out label="作成結果">{saved || 'まだ作成されていません'}</Out>
      <Note>
        Esc・×・背景クリック・キャンセルの4つで閉じられます。開くとフォーカスがモーダル内へ入り、閉じると元のボタンへ戻ります（Tab を押し続けても外に出ません）。
      </Note>
    </div>
  );
}

/* ---------------------------------------------------------------- bottom-sheet */
export function BottomSheetDemo() {
  const [state, setState] = useState('closed'); // closed | peek | full
  return (
    <div className="d-stack">
      <Phone height={340}>
        <div style={{ flex: 1, background: 'linear-gradient(160deg, #cfe8d8, #a9cfe0)', position: 'relative', display: 'grid', placeItems: 'center' }}>
          <span style={{ fontSize: 30 }} aria-hidden="true">🗺️</span>
          <button className="btn btn--sm" style={{ position: 'absolute', top: 12, left: 12 }} onClick={() => setState('peek')}>
            地図上の場所をタップ
          </button>

          {state !== 'closed' && (
            <>
              {state === 'full' && <div onClick={() => setState('peek')} style={{ position: 'absolute', inset: 0, background: 'rgba(0,0,0,.35)' }} />}
              <div
                role="dialog"
                aria-label="場所の詳細"
                style={{
                  position: 'absolute', left: 0, right: 0, bottom: 0,
                  height: state === 'full' ? '86%' : 130,
                  background: 'var(--bg-elev)', borderRadius: '16px 16px 0 0',
                  boxShadow: '0 -6px 24px rgba(0,0,0,.2)', transition: 'height .22s ease',
                  padding: '8px 14px 14px', overflowY: 'auto',
                }}
              >
                <button
                  onClick={() => setState(state === 'full' ? 'peek' : 'full')}
                  aria-label={state === 'full' ? 'シートを縮める' : 'シートを広げる'}
                  style={{ display: 'block', width: 40, height: 5, borderRadius: 999, background: 'var(--border-strong)', border: 0, margin: '2px auto 10px', cursor: 'pointer' }}
                />
                <div style={{ fontWeight: 800, fontSize: 15 }}>中央公園</div>
                <div style={{ fontSize: 12, color: 'var(--text-muted)' }}>★ 4.5（1,204件）· 公園 · 24時間営業</div>
                <div style={{ display: 'flex', gap: 7, marginTop: 10 }}>
                  <button className="btn btn--sm" style={{ flex: 1 }}>経路</button>
                  <button className="btn btn--secondary btn--sm" style={{ flex: 1 }}>保存</button>
                  <button className="btn btn--secondary btn--sm" onClick={() => setState('closed')}>閉じる</button>
                </div>
                {state === 'full' && (
                  <div style={{ marginTop: 14, fontSize: 13, color: 'var(--text-muted)', lineHeight: 1.9 }}>
                    <p>広い芝生とランニングコースがある都市公園です。</p>
                    <p style={{ marginTop: 8 }}>ハンドル（上の横棒）をタップすると高さが切り替わります。実機ではドラッグで連続的に変えられます。</p>
                    <p style={{ marginTop: 8 }}>写真・レビュー・営業時間などの詳細が続きます。</p>
                  </div>
                )}
              </div>
            </>
          )}
        </div>
      </Phone>
      <Out label="シートの状態">{state === 'closed' ? '非表示' : state === 'peek' ? 'ピーク（背景が見える）' : '全画面'}</Out>
      <Note>背景（地図）の文脈を残したまま情報を重ねられるのがボトムシートの価値。ドラッグ用のハンドルは必須の視覚的手がかりです。</Note>
    </div>
  );
}

/* ---------------------------------------------------------------- action-sheet */
export function ActionSheetDemo() {
  const [open, setOpen] = useState(false);
  const [log, setLog] = useState('（「…」を押してください）');
  const act = (label) => { setLog(`選択: ${label}`); setOpen(false); };
  return (
    <div className="d-stack">
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: '11px 13px' }}>
        <span style={{ fontSize: 22 }} aria-hidden="true">📷</span>
        <span style={{ flex: 1, fontSize: 13.5 }}>IMG_2035.jpg</span>
        <button className="iconbtn" onClick={() => setOpen(true)} aria-label="この写真の操作メニューを開く" aria-haspopup="dialog">
          <IconMore size={19} />
        </button>
      </div>

      <DemoDialog open={open} onClose={() => setOpen(false)} labelledBy="as-title" align="bottom">
        <div id="as-title" style={{ textAlign: 'center', fontSize: 12.5, color: 'var(--text-faint)', paddingBottom: 8 }}>IMG_2035.jpg</div>
        <div style={{ display: 'grid', gap: 1, background: 'var(--border)', borderRadius: 12, overflow: 'hidden' }}>
          {[['共有', <IconShare size={17} key="s" />], ['アルバムに追加', '＋'], ['複製', '⧉']].map(([label, icon]) => (
            <button key={label} onClick={() => act(label)} style={{ display: 'flex', alignItems: 'center', gap: 10, border: 0, background: 'var(--bg-elev)', cursor: 'pointer', padding: '14px 16px', fontSize: 14.5, minHeight: 50 }}>
              <span style={{ width: 20, display: 'grid', placeItems: 'center' }} aria-hidden="true">{icon}</span>{label}
            </button>
          ))}
          <button onClick={() => act('削除')} style={{ display: 'flex', alignItems: 'center', gap: 10, border: 0, background: 'var(--bg-elev)', cursor: 'pointer', padding: '14px 16px', fontSize: 14.5, color: 'var(--danger)', fontWeight: 700, minHeight: 50 }}>
            <span style={{ width: 20, display: 'grid', placeItems: 'center' }} aria-hidden="true"><IconTrash size={17} /></span>写真を削除
          </button>
        </div>
        <button className="btn btn--secondary" style={{ width: '100%', marginTop: 8, minHeight: 48 }} onClick={() => setOpen(false)}>キャンセル</button>
      </DemoDialog>

      <Out label="結果">{log}</Out>
      <Note>破壊的操作は赤字で最下部近くに、キャンセルは隙間を空けて分離。これが iOS のアクションシートの視覚的な約束事です。</Note>
    </div>
  );
}

/* --------------------------------------------------------------- drawer-overlay */
export function DrawerOverlayDemo() {
  const [open, setOpen] = useState(false);
  const [price, setPrice] = useState(5000);
  const [cats, setCats] = useState(['トップス']);
  const [applied, setApplied] = useState({ price: 5000, cats: ['トップス'] });
  const count = 128 - cats.length * 12 - Math.floor(price / 500);

  return (
    <div className="d-stack">
      <div className="d-row">
        <button className="btn btn--secondary" onClick={() => setOpen(true)} aria-expanded={open}>絞り込み</button>
        <Out label="適用中">¥{applied.price.toLocaleString()}以下 / {applied.cats.join('・') || '全カテゴリ'}</Out>
      </div>

      {open && (
        <>
          <div onClick={() => setOpen(false)} style={{ position: 'fixed', inset: 0, background: 'rgba(8,11,22,.5)', zIndex: 80 }} />
          <div
            role="dialog"
            aria-modal="true"
            aria-label="絞り込み条件"
            style={{
              position: 'fixed', top: 0, right: 0, bottom: 0, width: 'min(320px, 88vw)', zIndex: 81,
              background: 'var(--bg-elev)', borderLeft: '1px solid var(--border-strong)', padding: 16,
              boxShadow: 'var(--shadow-lg)', display: 'flex', flexDirection: 'column',
            }}
          >
            <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 14 }}>
              <strong style={{ flex: 1, fontSize: 15 }}>絞り込み</strong>
              <button className="iconbtn" onClick={() => setOpen(false)} aria-label="閉じる"><IconClose size={18} /></button>
            </div>

            <div className="field" style={{ marginBottom: 16 }}>
              <label className="field__label" htmlFor="dw-price">上限価格：¥{price.toLocaleString()}</label>
              <input id="dw-price" type="range" min="1000" max="10000" step="500" value={price} onChange={(e) => setPrice(+e.target.value)} />
            </div>

            <fieldset style={{ border: 0, padding: 0, margin: 0 }}>
              <legend className="field__label" style={{ marginBottom: 6 }}>カテゴリ</legend>
              {['トップス', 'ボトムス', 'シューズ', 'バッグ'].map((c) => (
                <label key={c} style={{ display: 'flex', gap: 8, alignItems: 'center', padding: '6px 0', fontSize: 13.5 }}>
                  <input
                    type="checkbox"
                    checked={cats.includes(c)}
                    onChange={(e) => setCats((p) => (e.target.checked ? [...p, c] : p.filter((x) => x !== c)))}
                  />
                  {c}
                </label>
              ))}
            </fieldset>

            <div style={{ marginTop: 'auto', paddingTop: 14, display: 'flex', gap: 8 }}>
              <button className="btn btn--secondary" onClick={() => { setPrice(10000); setCats([]); }}>すべてクリア</button>
              <button className="btn" style={{ flex: 1 }} onClick={() => { setApplied({ price, cats }); setOpen(false); }}>
                {Math.max(count, 0)}件を表示
              </button>
            </div>
          </div>
        </>
      )}
      <Note>適用ボタンに「〇件を表示」と結果件数を出すのが、絞り込みドロワーの定石（0件になる前に気づける）。</Note>
    </div>
  );
}

/* ------------------------------------------------------------- toast-snackbar */
export function ToastSnackbarDemo() {
  const [items, setItems] = useState([]);
  const [mails, setMails] = useState(['請求書のご確認', '週次レポート', 'イベントのお知らせ']);
  const idRef = useRef(0);

  const push = (msg, action) => {
    const id = ++idRef.current;
    setItems((p) => [...p, { id, msg, action }]);
    setTimeout(() => setItems((p) => p.filter((x) => x.id !== id)), 5000);
  };

  const archive = (m) => {
    setMails((p) => p.filter((x) => x !== m));
    push(`「${m}」をアーカイブしました`, () => {
      setMails((p) => [m, ...p]);
      push('元に戻しました');
    });
  };

  return (
    <div className="d-stack">
      <div className="d-list">
        {mails.map((m) => (
          <div className="d-list__item" key={m}>
            <span style={{ flex: 1, fontSize: 13.5 }}>{m}</span>
            <button className="btn btn--secondary btn--sm" onClick={() => archive(m)}>アーカイブ</button>
          </div>
        ))}
        {mails.length === 0 && <div className="d-list__item" style={{ color: 'var(--text-muted)', fontSize: 13 }}>メールはありません</div>}
      </div>

      <div role="status" aria-live="polite" style={{ position: 'fixed', left: '50%', bottom: 'calc(24px + env(safe-area-inset-bottom))', transform: 'translateX(-50%)', zIndex: 90, display: 'flex', flexDirection: 'column', gap: 8, width: 'min(400px, 92vw)' }}>
        {items.map((t) => (
          <div key={t.id} style={{ display: 'flex', alignItems: 'center', gap: 12, background: 'var(--text)', color: 'var(--bg-elev)', borderRadius: 10, padding: '11px 14px', boxShadow: 'var(--shadow-lg)', fontSize: 13.5 }}>
            <span style={{ flex: 1 }}>{t.msg}</span>
            {t.action && (
              <button onClick={() => { t.action(); setItems((p) => p.filter((x) => x.id !== t.id)); }} style={{ border: 0, background: 'transparent', color: 'var(--accent)', fontWeight: 800, cursor: 'pointer', fontSize: 13.5 }}>
                元に戻す
              </button>
            )}
          </div>
        ))}
      </div>
      <Note>
        Gmail と同じ「削除 → スナックバーで取り消し」パターン。確認ダイアログを出さずに安全性を確保できます（5秒で自動的に消えます）。
      </Note>
    </div>
  );
}

/* ---------------------------------------------------------------- alert-banner */
export function AlertBannerDemo() {
  const [dismissed, setDismissed] = useState([]);
  const banners = [
    { id: 'info', tone: 'info', icon: <IconInfo size={17} />, title: 'メンテナンスのお知らせ', body: '9月10日 2:00〜4:00 に定期メンテナンスを実施します。', dismissible: true },
    { id: 'warn', tone: 'warning', icon: <IconAlert size={17} />, title: 'お支払い方法の有効期限が近づいています', body: '2026年10月末で期限切れになります。更新してください。', action: 'カードを更新', dismissible: false },
    { id: 'err', tone: 'danger', icon: <IconAlert size={17} />, title: '同期に失敗しました', body: 'ネットワーク接続を確認してから、再試行してください。', action: '再試行', dismissible: true },
    { id: 'ok', tone: 'success', icon: <IconCheck size={17} />, title: '設定を保存しました', body: '変更はすべてのデバイスに反映されます。', dismissible: true },
  ];
  const colors = {
    info: ['var(--info)', 'var(--info-soft)'],
    warning: ['var(--warning)', 'var(--warning-soft)'],
    danger: ['var(--danger)', 'var(--danger-soft)'],
    success: ['var(--success)', 'var(--success-soft)'],
  };
  return (
    <div className="d-stack">
      {banners.filter((b) => !dismissed.includes(b.id)).map((b) => {
        const [fg, bg] = colors[b.tone];
        return (
          <div
            key={b.id}
            role={b.tone === 'danger' ? 'alert' : 'status'}
            style={{ display: 'flex', gap: 10, alignItems: 'flex-start', background: bg, border: `1px solid ${fg}`, borderLeft: `4px solid ${fg}`, borderRadius: 'var(--radius)', padding: '11px 13px' }}
          >
            <span style={{ color: fg, lineHeight: 0, marginTop: 2 }} aria-hidden="true">{b.icon}</span>
            <div style={{ flex: 1 }}>
              <div style={{ fontWeight: 700, fontSize: 13.5 }}>{b.title}</div>
              <div style={{ fontSize: 12.5, color: 'var(--text-muted)', marginTop: 2 }}>{b.body}</div>
              {b.action && <button className="btn btn--sm" style={{ marginTop: 9, background: fg, color: '#fff' }}>{b.action}</button>}
            </div>
            {b.dismissible && (
              <button className="iconbtn" style={{ width: 28, height: 28 }} onClick={() => setDismissed((p) => [...p, b.id])} aria-label={`${b.title} を閉じる`}>
                <IconClose size={15} />
              </button>
            )}
          </div>
        );
      })}
      {dismissed.length > 0 && <button className="btn btn--ghost btn--sm" onClick={() => setDismissed([])}>閉じたバナーを戻す</button>}
      <Note>色だけでなくアイコンと見出し文言でも深刻度を伝えます。解決が必要な警告（2番目）は閉じられない設計にしています。</Note>
    </div>
  );
}

/* --------------------------------------------------------------- context-menu */
export function ContextMenuDemo() {
  const [menu, setMenu] = useState(null); // {x, y, target}
  const [log, setLog] = useState('（右クリック、またはモバイルは長押し／「⋮」ボタン）');
  const files = ['提案書.pdf', '見積書.xlsx', '議事録.docx'];
  const wrapRef = useRef(null);

  useEffect(() => {
    if (!menu) return;
    const close = () => setMenu(null);
    const onKey = (e) => { if (e.key === 'Escape') setMenu(null); };
    document.addEventListener('click', close);
    document.addEventListener('keydown', onKey);
    return () => { document.removeEventListener('click', close); document.removeEventListener('keydown', onKey); };
  }, [menu]);

  const open = (e, file) => {
    e.preventDefault();
    const rect = wrapRef.current.getBoundingClientRect();
    setMenu({ x: e.clientX - rect.left, y: e.clientY - rect.top, file });
  };

  return (
    <div className="d-stack">
      <div ref={wrapRef} style={{ position: 'relative' }}>
        <div className="d-list">
          {files.map((f) => (
            <div key={f} className="d-list__item" onContextMenu={(e) => open(e, f)}>
              <span aria-hidden="true">📄</span>
              <span style={{ flex: 1, fontSize: 13.5 }}>{f}</span>
              <button
                className="iconbtn"
                style={{ width: 30, height: 30 }}
                aria-label={`${f} の操作メニュー`}
                aria-haspopup="menu"
                onClick={(e) => { e.stopPropagation(); open(e, f); }}
              >
                <IconMore size={17} />
              </button>
            </div>
          ))}
        </div>

        {menu && (
          <div
            role="menu"
            aria-label={`${menu.file} の操作`}
            onClick={(e) => e.stopPropagation()}
            style={{
              position: 'absolute', top: Math.min(menu.y, 120), left: Math.min(menu.x, 160), zIndex: 10, width: 190,
              background: 'var(--bg-elev)', border: '1px solid var(--border-strong)', borderRadius: 10,
              boxShadow: 'var(--shadow-lg)', padding: 5,
            }}
          >
            {['開く', '名前を変更', 'コピーを作成', 'ダウンロード'].map((a) => (
              <button key={a} role="menuitem" onClick={() => { setLog(`${menu.file} → ${a}`); setMenu(null); }} style={{ display: 'block', width: '100%', textAlign: 'left', border: 0, background: 'transparent', cursor: 'pointer', padding: '8px 10px', borderRadius: 7, fontSize: 13.5 }}>
                {a}
              </button>
            ))}
            <div style={{ height: 1, background: 'var(--border)', margin: '4px 0' }} />
            <button role="menuitem" onClick={() => { setLog(`${menu.file} → 削除`); setMenu(null); }} style={{ display: 'flex', alignItems: 'center', gap: 7, width: '100%', textAlign: 'left', border: 0, background: 'transparent', cursor: 'pointer', padding: '8px 10px', borderRadius: 7, fontSize: 13.5, color: 'var(--danger)', fontWeight: 600 }}>
              <IconTrash size={15} /> 削除
            </button>
          </div>
        )}
      </div>
      <Out label="実行">{log}</Out>
      <Note>右クリックだけに頼らず「⋮」ボタンも併設。破壊的操作は区切り線の下・赤字にして誤タップを防ぎます。</Note>
    </div>
  );
}
