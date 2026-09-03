import { useEffect, useRef, useState } from 'react';
import { Note, Out, Phone } from './common.jsx';
import { IconRefresh, IconTrash, IconCheck, IconMore, IconClose } from '../components/Icons.jsx';

/* ------------------------------------------------------------ pull-to-refresh */
export function PullToRefreshDemo() {
  const [pull, setPull] = useState(0);
  const [refreshing, setRefreshing] = useState(false);
  const [items, setItems] = useState(['最新の投稿 3', '最新の投稿 2', '最新の投稿 1']);
  const startY = useRef(null);
  const scrollRef = useRef(null);
  const THRESHOLD = 64;

  const doRefresh = async () => {
    setRefreshing(true);
    setPull(THRESHOLD);
    await new Promise((r) => setTimeout(r, 1200));
    setItems((p) => [`新着の投稿 ${p.length + 1}`, ...p]);
    setRefreshing(false);
    setPull(0);
  };

  const onStart = (y) => { if ((scrollRef.current?.scrollTop ?? 0) <= 0) startY.current = y; };
  const onMove = (y) => {
    if (startY.current == null || refreshing) return;
    const d = y - startY.current;
    if (d > 0) setPull(Math.min(d * 0.5, 90));
  };
  const onEnd = () => {
    startY.current = null;
    if (refreshing) return;
    if (pull >= THRESHOLD) doRefresh();
    else setPull(0);
  };

  const ready = pull >= THRESHOLD;
  return (
    <div className="d-stack">
      <Phone height={330}>
        <div style={{ height: 42, borderBottom: '1px solid var(--border)', display: 'flex', alignItems: 'center', padding: '0 12px', fontWeight: 700, fontSize: 13.5, background: 'var(--bg-elev)', flex: 'none' }}>
          タイムライン
        </div>
        <div style={{ position: 'relative', flex: 1, overflow: 'hidden' }}>
          <div
            aria-hidden="true"
            style={{
              position: 'absolute', top: 0, left: 0, right: 0, height: pull, display: 'grid', placeItems: 'center',
              color: ready || refreshing ? 'var(--accent)' : 'var(--text-faint)', fontSize: 12, overflow: 'hidden',
              transition: startY.current == null ? 'height .2s ease' : 'none',
            }}
          >
            <span style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
              <span style={{ display: 'inline-block', transform: `rotate(${refreshing ? 0 : pull * 4}deg)`, animation: refreshing ? 'spin .8s linear infinite' : 'none', lineHeight: 0 }}>
                <IconRefresh size={17} />
              </span>
              {refreshing ? '更新中…' : ready ? '離すと更新' : '引っ張って更新'}
            </span>
          </div>
          <div
            ref={scrollRef}
            onTouchStart={(e) => onStart(e.touches[0].clientY)}
            onTouchMove={(e) => onMove(e.touches[0].clientY)}
            onTouchEnd={onEnd}
            onMouseDown={(e) => onStart(e.clientY)}
            onMouseMove={(e) => { if (startY.current != null) onMove(e.clientY); }}
            onMouseUp={onEnd}
            onMouseLeave={onEnd}
            style={{
              height: '100%', overflowY: 'auto', padding: 10, transform: `translateY(${pull}px)`,
              transition: startY.current == null ? 'transform .2s ease' : 'none', cursor: 'grab',
            }}
          >
            {items.map((t, i) => (
              <div key={i} style={{ border: '1px solid var(--border)', borderRadius: 10, padding: 11, marginBottom: 8, fontSize: 13, background: 'var(--bg-elev)' }}>{t}</div>
            ))}
          </div>
        </div>
      </Phone>
      <div className="d-row">
        <button className="btn btn--secondary btn--sm" onClick={doRefresh} disabled={refreshing}>
          <IconRefresh size={14} /> 更新（ボタンからも実行できる）
        </button>
        <span aria-live="polite" style={{ fontSize: 12.5, color: 'var(--text-muted)' }}>{refreshing ? '更新中…' : `${items.length}件`}</span>
      </div>
      <style>{'@keyframes spin { to { transform: rotate(360deg) } }'}</style>
      <Note>
        リスト内をマウスで下方向にドラッグ（スマホでは指でスワイプ）してください。閾値を超えると「離すと更新」に変わります。
        ジェスチャーだけに頼らず、ボタンからも更新できるようにするのが WCAG 2.5.1 の要件です。
      </Note>
    </div>
  );
}

/* --------------------------------------------------------------- swipe-actions */
function SwipeRow({ label, onArchive, onDelete }) {
  const [x, setX] = useState(0);
  const start = useRef(null);
  const MAX = 150;
  const end = () => {
    if (start.current == null) return;
    start.current = null;
    if (x <= -MAX) { onDelete(); return; }
    if (x >= MAX) { onArchive(); return; }
    setX(0);
  };
  return (
    <div style={{ position: 'relative', overflow: 'hidden', borderBottom: '1px solid var(--border)', background: x > 0 ? 'var(--success)' : x < 0 ? 'var(--danger)' : 'transparent' }}>
      <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: x > 0 ? 'flex-start' : 'flex-end', padding: '0 16px', color: '#fff', fontWeight: 700, fontSize: 12.5, gap: 6 }} aria-hidden="true">
        {x > 0 ? <><IconCheck size={17} /> アーカイブ</> : x < 0 ? <>削除 <IconTrash size={17} /></> : null}
      </div>
      <div
        onTouchStart={(e) => { start.current = e.touches[0].clientX - x; }}
        onTouchMove={(e) => { if (start.current != null) setX(e.touches[0].clientX - start.current); }}
        onTouchEnd={end}
        onMouseDown={(e) => { start.current = e.clientX - x; }}
        onMouseMove={(e) => { if (start.current != null) setX(e.clientX - start.current); }}
        onMouseUp={end}
        onMouseLeave={end}
        style={{
          display: 'flex', alignItems: 'center', gap: 10, padding: '13px 13px', background: 'var(--bg-elev)',
          transform: `translateX(${x}px)`, transition: start.current == null ? 'transform .2s ease' : 'none',
          cursor: 'grab', userSelect: 'none', position: 'relative',
        }}
      >
        <span style={{ flex: 1, fontSize: 13.5 }}>{label}</span>
        {/* ジェスチャーの代替手段（必須） */}
        <button className="iconbtn" style={{ width: 30, height: 30 }} onClick={onArchive} aria-label={`${label} をアーカイブ`}><IconCheck size={16} /></button>
        <button className="iconbtn" style={{ width: 30, height: 30, color: 'var(--danger)' }} onClick={onDelete} aria-label={`${label} を削除`}><IconTrash size={16} /></button>
      </div>
    </div>
  );
}

export function SwipeActionsDemo() {
  const [mails, setMails] = useState(['請求書のご確認', '週次レポート', '打ち合わせの日程調整']);
  const [toast, setToast] = useState(null);
  const remove = (m, kind) => {
    setMails((p) => p.filter((x) => x !== m));
    setToast({ m, kind });
    setTimeout(() => setToast((t) => (t?.m === m ? null : t)), 4500);
  };
  return (
    <div className="d-stack">
      <div style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', overflow: 'hidden' }}>
        {mails.map((m) => (
          <SwipeRow key={m} label={m} onArchive={() => remove(m, 'アーカイブ')} onDelete={() => remove(m, '削除')} />
        ))}
        {mails.length === 0 && <div style={{ padding: 20, textAlign: 'center', fontSize: 13, color: 'var(--text-muted)' }}>すべて処理しました 🎉</div>}
      </div>
      {toast && (
        <div role="status" style={{ display: 'flex', alignItems: 'center', gap: 12, background: 'var(--text)', color: 'var(--bg-elev)', borderRadius: 10, padding: '10px 14px', fontSize: 13 }}>
          <span style={{ flex: 1 }}>「{toast.m}」を{toast.kind}しました</span>
          <button onClick={() => { setMails((p) => [toast.m, ...p]); setToast(null); }} style={{ border: 0, background: 'transparent', color: 'var(--accent)', fontWeight: 800, cursor: 'pointer' }}>元に戻す</button>
        </div>
      )}
      <Note>
        行を左右にドラッグしてください（右＝アーカイブ／左＝削除）。実行後は必ず Undo を出します。
        右端のボタンは、スワイプできない人のための代替手段です。
      </Note>
    </div>
  );
}

/* -------------------------------------------------------------- infinite-scroll */
export function InfiniteScrollDemo() {
  const [items, setItems] = useState(Array.from({ length: 8 }, (_, i) => `投稿 ${i + 1}`));
  const [loading, setLoading] = useState(false);
  const [done, setDone] = useState(false);
  const sentinel = useRef(null);
  const rootRef = useRef(null);

  const loadMore = () => {
    if (loading || done) return;
    setLoading(true);
    setTimeout(() => {
      setItems((p) => {
        const next = [...p, ...Array.from({ length: 6 }, (_, i) => `投稿 ${p.length + i + 1}`)];
        if (next.length >= 26) setDone(true);
        return next;
      });
      setLoading(false);
    }, 900);
  };

  useEffect(() => {
    const el = sentinel.current;
    if (!el) return;
    const io = new IntersectionObserver((entries) => { if (entries[0].isIntersecting) loadMore(); }, { root: rootRef.current, rootMargin: '80px' });
    io.observe(el);
    return () => io.disconnect();
  }); // 依存を意図的に省略：最新のクロージャで監視する

  return (
    <div className="d-stack">
      <div ref={rootRef} style={{ height: 280, overflowY: 'auto', border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: 10 }}>
        {items.map((t) => (
          <div key={t} style={{ padding: '11px 12px', border: '1px solid var(--border)', borderRadius: 9, marginBottom: 7, fontSize: 13, background: 'var(--bg-elev)' }}>{t}</div>
        ))}
        <div ref={sentinel} style={{ height: 1 }} />
        <div aria-live="polite" style={{ textAlign: 'center', padding: 10, fontSize: 12.5, color: 'var(--text-muted)' }}>
          {loading && '読み込み中…'}
          {done && !loading && '— これ以上ありません —'}
          {!loading && !done && <button className="btn btn--secondary btn--sm" onClick={loadMore}>さらに読み込む</button>}
        </div>
      </div>
      <Out label="読み込み済み">{items.length} 件{done ? '（全件）' : ''}</Out>
      <Note>
        末尾のセンチネルを IntersectionObserver で監視して自動読み込み。
        「さらに読み込む」ボタンも併設し、末尾（これ以上ない）も必ず明示します。
      </Note>
    </div>
  );
}

/* -------------------------------------------------------------------- long-press */
export function LongPressDemo() {
  const [menu, setMenu] = useState(false);
  const [progress, setProgress] = useState(0);
  const [log, setLog] = useState('（アイコンを500ms以上押し続けてください）');
  const timer = useRef(null);
  const raf = useRef(null);

  const start = () => {
    const t0 = Date.now();
    const tick = () => {
      const p = Math.min(1, (Date.now() - t0) / 500);
      setProgress(p);
      if (p < 1) raf.current = requestAnimationFrame(tick);
    };
    raf.current = requestAnimationFrame(tick);
    timer.current = setTimeout(() => { setMenu(true); setLog('長押しが成立しました（実機ならここで振動）'); }, 500);
  };
  const cancel = () => {
    clearTimeout(timer.current);
    cancelAnimationFrame(raf.current);
    setProgress(0);
  };
  useEffect(() => () => cancel(), []);

  return (
    <div className="d-stack">
      <div style={{ display: 'flex', gap: 16, alignItems: 'flex-start', padding: '10px 0 120px', position: 'relative' }}>
        <div style={{ position: 'relative', width: 66 }}>
          <button
            onMouseDown={start}
            onMouseUp={cancel}
            onMouseLeave={cancel}
            onTouchStart={start}
            onTouchEnd={cancel}
            onContextMenu={(e) => e.preventDefault()}
            aria-haspopup="menu"
            style={{
              width: 62, height: 62, borderRadius: 16, border: '1px solid var(--border)', cursor: 'pointer',
              background: 'linear-gradient(135deg, #7c92ff, #b06bff)', color: '#fff', fontSize: 26,
              transform: `scale(${1 - progress * 0.08})`, transition: 'transform .05s linear',
            }}
          >
            📅
          </button>
          <div style={{ fontSize: 11, textAlign: 'center', marginTop: 5, color: 'var(--text-muted)' }}>カレンダー</div>
          {progress > 0 && progress < 1 && (
            <div aria-hidden="true" style={{ position: 'absolute', left: 0, right: 0, bottom: -6, height: 3, background: 'var(--border)', borderRadius: 999 }}>
              <div style={{ height: '100%', width: `${progress * 100}%`, background: 'var(--accent)', borderRadius: 999 }} />
            </div>
          )}
          {menu && (
            <div role="menu" style={{ position: 'absolute', top: 92, left: 0, width: 190, background: 'var(--bg-elev)', border: '1px solid var(--border-strong)', borderRadius: 12, boxShadow: 'var(--shadow-lg)', padding: 5, zIndex: 5 }}>
              {['新しい予定', '今日の予定を見る', 'アプリを削除'].map((a, i) => (
                <button key={a} role="menuitem" onClick={() => { setLog(`選択: ${a}`); setMenu(false); }} style={{ display: 'block', width: '100%', textAlign: 'left', border: 0, background: 'transparent', cursor: 'pointer', padding: '9px 10px', borderRadius: 7, fontSize: 13, color: i === 2 ? 'var(--danger)' : 'inherit' }}>
                  {a}
                </button>
              ))}
            </div>
          )}
        </div>
        <div style={{ flex: 1 }}>
          <Out label="ログ">{log}</Out>
          <button className="btn btn--secondary btn--sm" style={{ marginTop: 8 }} onClick={() => setMenu((v) => !v)}>
            長押しの代替：メニューボタン
          </button>
        </div>
      </div>
      <Note>押し続けている間の縮小アニメと進捗バーが「効いている」というフィードバック。500ms前後が標準的な閾値です。</Note>
    </div>
  );
}

/* ------------------------------------------------------------------- safe-area */
export function SafeAreaDemo() {
  const [safe, setSafe] = useState(true);
  return (
    <div className="d-stack">
      <div style={{ width: 250, margin: '0 auto', border: '2px solid var(--border-strong)', borderRadius: 30, overflow: 'hidden', position: 'relative', background: '#1b2030', height: 340 }}>
        {/* ノッチ */}
        <div style={{ position: 'absolute', top: 0, left: '50%', transform: 'translateX(-50%)', width: 96, height: 24, background: '#000', borderRadius: '0 0 14px 14px', zIndex: 5 }} aria-hidden="true" />
        {/* ホームインジケータ */}
        <div style={{ position: 'absolute', bottom: 7, left: '50%', transform: 'translateX(-50%)', width: 100, height: 4, background: '#fff', borderRadius: 999, zIndex: 5, opacity: .9 }} aria-hidden="true" />

        {/* 背景は端まで（これは常に正しい） */}
        <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(160deg, #3b5bfd, #9b6bff)' }} aria-hidden="true" />

        <div style={{ position: 'absolute', inset: 0, paddingTop: safe ? 30 : 0, paddingBottom: safe ? 22 : 0, display: 'flex', flexDirection: 'column' }}>
          <div style={{ background: 'rgba(255,255,255,.92)', color: '#12141c', padding: '9px 12px', fontSize: 12.5, fontWeight: 700, display: 'flex', alignItems: 'center', gap: 6 }}>
            <span>← 戻る</span><span style={{ flex: 1, textAlign: 'center' }}>タイトル</span><span>⋯</span>
          </div>
          <div style={{ flex: 1 }} />
          <div style={{ background: 'rgba(255,255,255,.92)', color: '#12141c', display: 'flex' }}>
            {['ホーム', '検索', 'マイページ'].map((t) => (
              <div key={t} style={{ flex: 1, textAlign: 'center', padding: '9px 0', fontSize: 11 }}>{t}</div>
            ))}
          </div>
        </div>
      </div>
      <div className="d-row" style={{ justifyContent: 'center' }}>
        <button className={safe ? 'btn btn--sm' : 'btn btn--secondary btn--sm'} onClick={() => setSafe(true)}>SafeArea あり</button>
        <button className={!safe ? 'btn btn--danger btn--sm' : 'btn btn--secondary btn--sm'} onClick={() => setSafe(false)}>SafeArea なし</button>
      </div>
      <Out label="状態">{safe ? 'ヘッダー/タブがノッチ・ホームインジケータを避けています' : 'ヘッダーがノッチに隠れ、タブがホームインジケータと重なっています'}</Out>
      <Note>背景（グラデーション）は端まで広げ、操作要素だけをセーフエリア内に置く、が正解です。</Note>
    </div>
  );
}

/* -------------------------------------------------------------------- haptics */
export function HapticsDemo() {
  const supported = typeof navigator !== 'undefined' && 'vibrate' in navigator;
  const [log, setLog] = useState('');
  const [on, setOn] = useState(false);
  const buzz = (pattern, label) => {
    if (supported) { try { navigator.vibrate(pattern); } catch {} }
    setLog(`${label} → ${supported ? '振動を実行しました（対応端末のみ体感できます）' : 'この環境は振動に非対応。視覚フィードバックのみで伝えます'}`);
  };
  return (
    <div className="d-stack">
      <div className="d-row">
        <button className="btn btn--secondary btn--sm" onClick={() => buzz(10, '軽い（selection）')}>軽い刻み</button>
        <button className="btn btn--secondary btn--sm" onClick={() => buzz(30, '中くらい（impact）')}>中くらい</button>
        <button className="btn btn--secondary btn--sm" onClick={() => buzz([20, 60, 20], '成功パターン')}>成功パターン</button>
        <button className="btn btn--secondary btn--sm" onClick={() => buzz([60, 40, 60, 40, 60], 'エラーパターン')}>エラーパターン</button>
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: '10px 13px' }}>
        <span style={{ flex: 1, fontSize: 13.5 }}>トグル操作でも軽い触覚が返る</span>
        <button
          role="switch"
          aria-checked={on}
          onClick={() => { setOn((v) => !v); buzz(10, 'トグル切替'); }}
          style={{ width: 48, height: 28, borderRadius: 999, border: '1px solid var(--border-strong)', background: on ? 'var(--accent)' : 'var(--bg-sunken)', position: 'relative', cursor: 'pointer' }}
        >
          <span aria-hidden="true" style={{ position: 'absolute', top: 2, left: on ? 22 : 2, width: 22, height: 22, borderRadius: '50%', background: '#fff', transition: 'left .18s ease' }} />
        </button>
      </div>
      <Out label="結果">{log || `この環境の navigator.vibrate: ${supported ? '対応' : '非対応（iOS Safari など）'}`}</Out>
      <Note>
        振動はあくまで補助。必ず視覚的フィードバックと併用し、OSの触覚設定をオフにしているユーザーにも情報が伝わるようにします。
        Flutter では <code>HapticFeedback.lightImpact()</code> などを使います。
      </Note>
    </div>
  );
}
