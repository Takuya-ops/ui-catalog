import { useEffect, useRef, useState } from 'react';
import { Note, Out, useTimedFlag } from './common.jsx';
import {
  IconCheck, IconChevronDown, IconCopy, IconExternal, IconHeart, IconMore, IconShare, IconTrash,
} from '../components/Icons.jsx';

/* ------------------------------------------------------------- primary-button */
export function PrimaryButtonDemo() {
  const [state, setState] = useState('idle');
  const submit = async () => {
    setState('loading');
    await new Promise((r) => setTimeout(r, 1200));
    setState('done');
    setTimeout(() => setState('idle'), 2000);
  };
  return (
    <div className="d-stack">
      <div className="d-row">
        <button className="btn" onClick={submit} disabled={state === 'loading'} aria-busy={state === 'loading'}>
          {state === 'loading' && (
            <span aria-hidden="true" style={{ width: 15, height: 15, borderRadius: '50%', border: '2px solid rgba(255,255,255,.4)', borderTopColor: '#fff', animation: 'spin .7s linear infinite', display: 'inline-block' }} />
          )}
          {state === 'loading' ? '予約を確定しています…' : state === 'done' ? '✓ 予約が確定しました' : '予約を確定する'}
        </button>
        <button className="btn" disabled title="利用規約への同意が必要です">同意して続ける</button>
        <span style={{ fontSize: 12, color: 'var(--text-faint)' }}>← 無効時は理由も伝える</span>
      </div>
      <style>{'@keyframes spin { to { transform: rotate(360deg) } }'}</style>
      <div className="d-row">
        <span className="d-label">階層の例：</span>
        <button className="btn">保存する</button>
        <button className="btn btn--secondary">下書き保存</button>
        <button className="btn btn--ghost">キャンセル</button>
      </div>
      <Note>
        ラベルは「送信」ではなく「予約を確定する」のように動詞＋目的語で。処理中は disabled ＋ 状態表示にして二重送信を防ぎます。
      </Note>
    </div>
  );
}

/* ----------------------------------------------------------- secondary-button */
export function SecondaryButtonDemo() {
  const [choice, setChoice] = useState('');
  return (
    <div className="d-stack">
      <div style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: 16 }}>
        <h3 style={{ fontSize: 15 }}>変更を保存しますか？</h3>
        <p style={{ fontSize: 13, color: 'var(--text-muted)', marginTop: 4 }}>保存しない場合、この編集内容は失われます。</p>
        <div style={{ display: 'flex', gap: 8, marginTop: 14, justifyContent: 'flex-end' }}>
          <button className="btn btn--secondary" onClick={() => setChoice('破棄')}>破棄する</button>
          <button className="btn" onClick={() => setChoice('保存')}>保存する</button>
        </div>
      </div>
      <Out label="選択">{choice || '未選択'}</Out>
      <Note>
        プライマリ（塗り）とセカンダリ（枠線）の視覚差で優先順位を伝えます。推奨アクションを右に置くのが Web/Material の慣習
        （iOS のアラートでは配置が異なるので、プラットフォームに合わせます）。
      </Note>
    </div>
  );
}

/* --------------------------------------------------------------- ghost-button */
export function GhostButtonDemo() {
  const [liked, setLiked] = useState(false);
  return (
    <div className="d-stack">
      <div style={{ border: '1px solid var(--border)', borderRadius: 12, overflow: 'hidden' }}>
        <div style={{ height: 76, background: 'var(--bg-sunken)', display: 'grid', placeItems: 'center', fontSize: 26 }} aria-hidden="true">📰</div>
        <div style={{ padding: 12 }}>
          <div style={{ fontWeight: 700, fontSize: 14 }}>UIコンポーネントの選び方</div>
          <p style={{ fontSize: 12.5, color: 'var(--text-muted)', marginTop: 3 }}>似たUIの使い分けを、判断基準から整理します。</p>
          <div style={{ display: 'flex', gap: 4, marginTop: 10, borderTop: '1px solid var(--border)', paddingTop: 8 }}>
            <button className="btn btn--ghost btn--sm" onClick={() => setLiked((v) => !v)} aria-pressed={liked}>
              <IconHeart size={15} filled={liked} /> {liked ? 'いいね済み' : 'いいね'}
            </button>
            <button className="btn btn--ghost btn--sm"><IconShare size={15} /> 共有</button>
            <button className="btn btn--ghost btn--sm" style={{ marginLeft: 'auto' }}>詳細</button>
          </div>
        </div>
      </div>
      <Note>カード内の補助操作はゴーストボタンが最適。見た目は軽くても、パディングでタップ領域は44pt確保します。</Note>
    </div>
  );
}

/* --------------------------------------------------------- destructive-button */
export function DestructiveButtonDemo() {
  const [open, setOpen] = useState(false);
  const [confirmText, setConfirmText] = useState('');
  const [deleted, setDeleted] = useState(false);
  const TARGET = 'my-project';
  return (
    <div className="d-stack">
      {deleted ? (
        <Out label="結果">🗑️ 「{TARGET}」を削除しました（この操作は取り消せません）</Out>
      ) : (
        <div style={{ border: '1px solid var(--danger)', borderRadius: 'var(--radius)', padding: 14, background: 'var(--danger-soft)' }}>
          <div style={{ fontWeight: 800, fontSize: 13.5, color: 'var(--danger)' }}>危険な操作（Danger Zone）</div>
          <p style={{ fontSize: 12.5, color: 'var(--text-muted)', marginTop: 4 }}>
            プロジェクトを削除すると、すべてのデータが完全に失われます。この操作は取り消せません。
          </p>
          <button className="btn btn--danger" style={{ marginTop: 10 }} onClick={() => setOpen(true)}>
            <IconTrash size={16} /> プロジェクトを削除
          </button>
        </div>
      )}

      {open && (
        <div onMouseDown={(e) => { if (e.target === e.currentTarget) setOpen(false); }} style={{ position: 'fixed', inset: 0, zIndex: 80, background: 'rgba(8,11,22,.55)', display: 'grid', placeItems: 'center', padding: 16 }}>
          <div role="alertdialog" aria-modal="true" aria-labelledby="dz-t" aria-describedby="dz-d" style={{ width: 'min(360px, 92vw)', background: 'var(--bg-elev)', border: '1px solid var(--border-strong)', borderRadius: 14, padding: 18, boxShadow: 'var(--shadow-lg)' }}>
            <h3 id="dz-t" style={{ fontSize: 15.5 }}>本当に削除しますか？</h3>
            <p id="dz-d" style={{ fontSize: 13, color: 'var(--text-muted)', marginTop: 6 }}>
              確認のため <code>{TARGET}</code> と入力してください。
            </p>
            <input className="input" style={{ marginTop: 10 }} value={confirmText} onChange={(e) => setConfirmText(e.target.value)} aria-label="プロジェクト名を入力して確認" placeholder={TARGET} />
            <div style={{ display: 'flex', gap: 8, marginTop: 14, justifyContent: 'flex-end' }}>
              <button className="btn btn--secondary" onClick={() => { setOpen(false); setConfirmText(''); }} autoFocus>やめる</button>
              <button className="btn btn--danger" disabled={confirmText !== TARGET} onClick={() => { setDeleted(true); setOpen(false); }}>
                完全に削除する
              </button>
            </div>
          </div>
        </div>
      )}
      {deleted && <button className="btn btn--secondary btn--sm" onClick={() => { setDeleted(false); setConfirmText(''); }}>デモをリセット</button>}
      <Note>
        GitHub と同じ「名前を入力させる確認（type-to-confirm）」。初期フォーカスは安全な「やめる」に置いています。
        ボタンは「OK」ではなく「完全に削除する」と動詞で書きます。
      </Note>
    </div>
  );
}

/* ----------------------------------------------------------------------- link */
export function LinkDemo() {
  return (
    <div className="d-stack">
      <div style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: 14, fontSize: 13.5, lineHeight: 2 }}>
        <p>
          UIの設計原則については <a href="#/u/link" onClick={(e) => e.preventDefault()} style={{ textDecoration: 'underline' }}>アクセシビリティのガイドライン（WCAG 2.2）</a> を参照してください。
        </p>
        <p style={{ marginTop: 8 }}>
          外部サイトへ移動する場合は
          <a href="#/u/link" onClick={(e) => e.preventDefault()} style={{ textDecoration: 'underline', display: 'inline-flex', alignItems: 'center', gap: 3, marginLeft: 4 }}>
            公式ドキュメント<IconExternal size={13} /><span className="sr-only">（新しいタブで開きます）</span>
          </a>
          のようにアイコンで予告します。
        </p>
      </div>
      <div style={{ display: 'grid', gap: 10, gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))' }}>
        <div style={{ border: '1px solid var(--success)', borderRadius: 'var(--radius)', padding: 11 }}>
          <div className="d-label" style={{ color: 'var(--success)', marginBottom: 5 }}>👍 リンク単体で意味が通る</div>
          <a href="#/u/link" onClick={(e) => e.preventDefault()} style={{ fontSize: 13, textDecoration: 'underline' }}>返品ポリシーを確認する</a>
        </div>
        <div style={{ border: '1px solid var(--danger)', borderRadius: 'var(--radius)', padding: 11 }}>
          <div className="d-label" style={{ color: 'var(--danger)', marginBottom: 5 }}>👎 「こちら」だけ</div>
          <span style={{ fontSize: 13 }}>詳しくは <a href="#/u/link" onClick={(e) => e.preventDefault()} style={{ textDecoration: 'underline' }}>こちら</a></span>
        </div>
      </div>
      <Note>スクリーンリーダーは「リンクだけを一覧で読み上げる」機能を持ちます。「こちら」が並ぶと何のリンクか分かりません。</Note>
    </div>
  );
}

/* ---------------------------------------------------------------- icon-button */
export function IconButtonDemo() {
  const [liked, setLiked] = useState(false);
  const [count, setCount] = useState(24);
  return (
    <div className="d-stack">
      <div style={{ display: 'flex', gap: 4, alignItems: 'center', border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: 10 }}>
        <button className="iconbtn" aria-label="返信" title="返信">💬</button>
        <button className="iconbtn" aria-label="リポスト" title="リポスト">🔁</button>
        <button
          className="iconbtn"
          aria-label={liked ? 'いいねを取り消す' : 'いいね'}
          aria-pressed={liked}
          title="いいね"
          onClick={() => { setLiked((v) => !v); setCount((c) => (liked ? c - 1 : c + 1)); }}
          style={{ color: liked ? '#e0245e' : undefined }}
        >
          <IconHeart size={19} filled={liked} />
        </button>
        <span style={{ fontSize: 12.5, color: 'var(--text-muted)', fontVariantNumeric: 'tabular-nums' }}>{count}</span>
        <button className="iconbtn" aria-label="共有" title="共有" style={{ marginLeft: 'auto' }}><IconShare size={18} /></button>
      </div>
      <Out label="状態">{liked ? 'いいね済み（aria-pressed=true）' : '未いいね（aria-pressed=false）'}</Out>
      <Note>
        アイコンのみのボタンには必ず <code>aria-label</code> を。トグル型は <code>aria-pressed</code> で状態を伝えます。
        見た目が小さくても、パディングで44pt四方のタップ領域を確保します。
      </Note>
    </div>
  );
}

/* --------------------------------------------------------------- split-button */
export function SplitButtonDemo() {
  const [open, setOpen] = useState(false);
  const [log, setLog] = useState('（既定の操作は「マージ」）');
  const wrap = useRef(null);
  useEffect(() => {
    if (!open) return;
    const onDoc = (e) => { if (!wrap.current?.contains(e.target)) setOpen(false); };
    const onKey = (e) => { if (e.key === 'Escape') setOpen(false); };
    document.addEventListener('mousedown', onDoc);
    document.addEventListener('keydown', onKey);
    return () => { document.removeEventListener('mousedown', onDoc); document.removeEventListener('keydown', onKey); };
  }, [open]);

  return (
    <div className="d-stack">
      <div ref={wrap} style={{ position: 'relative', display: 'inline-flex', paddingBottom: open ? 130 : 0 }}>
        <div style={{ display: 'inline-flex' }}>
          <button className="btn" style={{ borderRadius: 'var(--radius) 0 0 var(--radius)' }} onClick={() => setLog('実行: マージ（Merge commit）')}>
            マージする
          </button>
          <button
            className="btn"
            aria-label="マージ方法を選択"
            aria-haspopup="menu"
            aria-expanded={open}
            onClick={() => setOpen((v) => !v)}
            style={{ borderRadius: '0 var(--radius) var(--radius) 0', borderLeft: '1px solid rgba(255,255,255,.35)', paddingInline: 10 }}
          >
            <IconChevronDown size={16} />
          </button>
        </div>
        {open && (
          <div role="menu" style={{ position: 'absolute', top: '100%', left: 0, marginTop: 5, width: 230, background: 'var(--bg-elev)', border: '1px solid var(--border-strong)', borderRadius: 10, boxShadow: 'var(--shadow-lg)', padding: 5, zIndex: 5 }}>
            {['マージ（Merge commit）', 'スカッシュしてマージ', 'リベースしてマージ'].map((a) => (
              <button key={a} role="menuitem" onClick={() => { setLog(`実行: ${a}`); setOpen(false); }} style={{ display: 'block', width: '100%', textAlign: 'left', border: 0, background: 'transparent', cursor: 'pointer', padding: '9px 10px', borderRadius: 7, fontSize: 13 }}>
                {a}
              </button>
            ))}
          </div>
        )}
      </div>
      <Out label="ログ">{log}</Out>
      <Note>左＝既定の操作を1クリックで、右＝派生の選択肢。境界線を入れて、押し間違いを防ぎます（GitHub のマージボタンが典型例）。</Note>
    </div>
  );
}

/* ---------------------------------------------------------------- copy-button */
export function CopyButtonDemo() {
  const [copied, fire] = useTimedFlag(2000);
  const [error, setError] = useState('');
  const text = 'https://example.com/invite/8f3a-92kd-1p0z';

  const copy = async () => {
    setError('');
    try {
      await navigator.clipboard.writeText(text);
      fire();
    } catch {
      // 非セキュアコンテキストなどでのフォールバック
      const ta = document.createElement('textarea');
      ta.value = text;
      document.body.appendChild(ta);
      ta.select();
      try { document.execCommand('copy'); fire(); } catch { setError('コピーできませんでした。手動で選択してコピーしてください。'); }
      ta.remove();
    }
  };

  return (
    <div className="d-stack">
      <div style={{ display: 'flex', gap: 6, alignItems: 'center', border: '1px solid var(--border-strong)', borderRadius: 'var(--radius)', padding: '7px 7px 7px 12px', background: 'var(--bg-sunken)' }}>
        <code style={{ flex: 1, background: 'transparent', border: 0, fontSize: 12.5, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{text}</code>
        <button className="btn btn--secondary btn--sm" onClick={copy} aria-label="招待リンクをコピー" style={{ background: 'var(--bg-elev)' }}>
          {copied ? <><IconCheck size={15} /> コピー済み</> : <><IconCopy size={15} /> コピー</>}
        </button>
      </div>
      <div aria-live="polite" style={{ fontSize: 12.5, color: error ? 'var(--danger)' : 'var(--success)', minHeight: 20 }}>
        {error || (copied ? '✅ 招待リンクをクリップボードにコピーしました' : '')}
      </div>
      <Note>アイコンの変化だけでは支援技術に伝わりません。<code>aria-live</code> の領域でも完了を通知し、2秒で元に戻します。</Note>
    </div>
  );
}

/* --------------------------------------------------------------- share-button */
export function ShareButtonDemo() {
  const [log, setLog] = useState('');
  const [copied, fire] = useTimedFlag(2000);
  const canShare = typeof navigator !== 'undefined' && !!navigator.share;

  const share = async () => {
    const payload = { title: 'UI Catalog', text: 'UIコンポーネントを学べるカタログ', url: window.location.href };
    if (canShare) {
      try {
        await navigator.share(payload);
        setLog('OSの共有シートで共有しました');
      } catch (e) {
        setLog('共有はキャンセルされました');
      }
    } else {
      try { await navigator.clipboard.writeText(payload.url); fire(); setLog('この環境は Web Share API 非対応のため、リンクをコピーしました'); }
      catch { setLog('共有もコピーもできませんでした'); }
    }
  };

  return (
    <div className="d-stack">
      <div className="d-row">
        <button className="btn" onClick={share} aria-label="このページを共有">
          <IconShare size={17} /> 共有する
        </button>
        <span style={{ fontSize: 12, color: 'var(--text-faint)' }}>
          {canShare ? 'この環境は Web Share API に対応しています' : 'この環境は Web Share API 非対応 → コピーにフォールバック'}
        </span>
      </div>
      <div aria-live="polite" style={{ fontSize: 12.5, color: 'var(--text-muted)', minHeight: 20 }}>{copied ? '✅ リンクをコピーしました' : log}</div>
      <Note>
        独自のSNSボタンを並べるのではなく、OSの共有シートに委ねるのが現代的。
        非対応環境では「リンクをコピー」へ確実にフォールバックさせます。
      </Note>
    </div>
  );
}
