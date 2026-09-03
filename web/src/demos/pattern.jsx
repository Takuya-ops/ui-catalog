import { useEffect, useMemo, useRef, useState } from 'react';
import { Note, Out, Phone } from './common.jsx';
import { IconCheck, IconClose, IconChevronRight, IconBell, IconAlert, IconRefresh, IconSearch, IconTrash } from '../components/Icons.jsx';

/* ----------------------------------------------------------------- onboarding */
export function OnboardingDemo() {
  const slides = [
    { icon: '👋', title: 'ようこそ', body: 'UI Catalog は、UIの名前と使いどころを学ぶアプリです。' },
    { icon: '🎯', title: '興味のある分野は？', body: '選んだ内容に合わせて、おすすめのコンポーネントを表示します。' },
    { icon: '🔔', title: '新着をお知らせします', body: '新しいコンポーネントが追加されたときにお知らせします。あとから変更できます。' },
  ];
  const [i, setI] = useState(0);
  const [interests, setInterests] = useState([]);
  const [finished, setFinished] = useState(false);

  if (finished) {
    return (
      <div className="d-stack">
        <Out label="完了">オンボーディングを終了しました（選択: {interests.join('・') || 'なし'}）</Out>
        <button className="btn btn--secondary btn--sm" onClick={() => { setFinished(false); setI(0); setInterests([]); }}>もう一度見る</button>
      </div>
    );
  }

  return (
    <div className="d-stack">
      <Phone height={370}>
        <div style={{ display: 'flex', justifyContent: 'flex-end', padding: 10 }}>
          <button className="btn btn--ghost btn--sm" onClick={() => setFinished(true)}>スキップ</button>
        </div>
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '0 22px', textAlign: 'center' }}>
          <div style={{ fontSize: 46 }} aria-hidden="true">{slides[i].icon}</div>
          <h3 style={{ fontSize: 17, marginTop: 12 }}>{slides[i].title}</h3>
          <p style={{ fontSize: 13, color: 'var(--text-muted)', marginTop: 8, lineHeight: 1.8 }}>{slides[i].body}</p>
          {i === 1 && (
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6, justifyContent: 'center', marginTop: 14 }}>
              {['入力', 'ナビ', '表示', 'モバイル'].map((t) => {
                const on = interests.includes(t);
                return (
                  <button
                    key={t}
                    aria-pressed={on}
                    onClick={() => setInterests((p) => (on ? p.filter((x) => x !== t) : [...p, t]))}
                    style={{ padding: '6px 13px', borderRadius: 999, fontSize: 12.5, cursor: 'pointer', border: `1px solid ${on ? 'var(--accent)' : 'var(--border-strong)'}`, background: on ? 'var(--accent-soft)' : 'transparent', color: on ? 'var(--accent)' : 'var(--text-muted)' }}
                  >
                    {on ? '✓ ' : ''}{t}
                  </button>
                );
              })}
            </div>
          )}
        </div>
        <div style={{ padding: 16 }}>
          <div style={{ display: 'flex', gap: 5, justifyContent: 'center', marginBottom: 12 }} aria-hidden="true">
            {slides.map((_, n) => (
              <span key={n} style={{ width: n === i ? 18 : 6, height: 6, borderRadius: 999, background: n === i ? 'var(--accent)' : 'var(--border-strong)', transition: 'width .2s' }} />
            ))}
          </div>
          <div style={{ display: 'flex', gap: 8 }}>
            {i > 0 && <button className="btn btn--secondary" onClick={() => setI(i - 1)}>戻る</button>}
            <button className="btn" style={{ flex: 1 }} onClick={() => (i === slides.length - 1 ? setFinished(true) : setI(i + 1))}>
              {i === slides.length - 1 ? 'はじめる' : '次へ'}
            </button>
          </div>
          <div style={{ textAlign: 'center', fontSize: 11, color: 'var(--text-faint)', marginTop: 8 }} aria-live="polite">{i + 1} / {slides.length}</div>
        </div>
      </Phone>
      <Note>スキップは常に見える位置に。3枚以内に収め、途中で「最初の価値」を体験させるのが離脱を防ぐコツです。</Note>
    </div>
  );
}

/* ------------------------------------------------------------------- auth-form */
export function AuthFormDemo() {
  const [mode, setMode] = useState('login');
  const [mail, setMail] = useState('');
  const [pw, setPw] = useState('');
  const [show, setShow] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [done, setDone] = useState('');

  const rules = [
    { label: '8文字以上', ok: pw.length >= 8 },
    { label: '数字を含む', ok: /\d/.test(pw) },
    { label: '英字を含む', ok: /[a-zA-Z]/.test(pw) },
  ];

  const submit = async (e) => {
    e.preventDefault();
    setError(''); setDone('');
    setLoading(true);
    await new Promise((r) => setTimeout(r, 900));
    setLoading(false);
    if (mode === 'login' && pw !== 'password1') {
      setError('メールアドレスまたはパスワードが正しくありません。入力内容は残しています。');
      return;
    }
    setDone(mode === 'login' ? 'ログインしました' : 'アカウントを作成しました');
  };

  return (
    <div className="d-stack">
      <div style={{ display: 'inline-flex', background: 'var(--bg-sunken)', border: '1px solid var(--border)', borderRadius: 10, padding: 3, gap: 2, alignSelf: 'flex-start' }}>
        {[['login', 'ログイン'], ['signup', '新規登録']].map(([v, l]) => (
          <button key={v} onClick={() => { setMode(v); setError(''); setDone(''); }} style={{ border: 0, cursor: 'pointer', padding: '6px 16px', borderRadius: 8, fontSize: 13, fontWeight: mode === v ? 700 : 500, background: mode === v ? 'var(--bg-elev)' : 'transparent', color: mode === v ? 'var(--text)' : 'var(--text-muted)' }}>
            {l}
          </button>
        ))}
      </div>

      <form onSubmit={submit} className="d-stack" style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: 16 }}>
        {error && <div role="alert" style={{ background: 'var(--danger-soft)', border: '1px solid var(--danger)', color: 'var(--danger)', borderRadius: 8, padding: '9px 12px', fontSize: 12.5, fontWeight: 600 }}>{error}</div>}
        {done && <div role="status" style={{ background: 'var(--success-soft)', border: '1px solid var(--success)', color: 'var(--success)', borderRadius: 8, padding: '9px 12px', fontSize: 12.5, fontWeight: 600 }}>✅ {done}</div>}

        <div className="field">
          <label className="field__label" htmlFor="af-mail">メールアドレス</label>
          <input id="af-mail" className="input" type="email" autoComplete="username" value={mail} onChange={(e) => setMail(e.target.value)} placeholder="you@example.com" required />
        </div>

        <div className="field">
          <label className="field__label" htmlFor="af-pw">パスワード{mode === 'login' && '（デモの正解: password1）'}</label>
          <div style={{ position: 'relative' }}>
            <input
              id="af-pw"
              className="input"
              type={show ? 'text' : 'password'}
              autoComplete={mode === 'login' ? 'current-password' : 'new-password'}
              value={pw}
              onChange={(e) => setPw(e.target.value)}
              style={{ paddingRight: 74 }}
              required
            />
            <button
              type="button"
              onClick={() => setShow((v) => !v)}
              aria-pressed={show}
              style={{ position: 'absolute', right: 6, top: 6, border: 0, background: 'transparent', cursor: 'pointer', fontSize: 12, color: 'var(--accent)', fontWeight: 700, padding: '4px 6px' }}
            >
              {show ? '隠す' : '表示'}
            </button>
          </div>
          {mode === 'signup' && (
            <ul style={{ listStyle: 'none', padding: 0, margin: '6px 0 0', display: 'flex', gap: 10, flexWrap: 'wrap' }}>
              {rules.map((r) => (
                <li key={r.label} style={{ fontSize: 11.5, color: r.ok ? 'var(--success)' : 'var(--text-faint)', display: 'flex', alignItems: 'center', gap: 3 }}>
                  {r.ok ? <IconCheck size={13} /> : <span style={{ width: 13, textAlign: 'center' }}>○</span>}{r.label}
                </li>
              ))}
            </ul>
          )}
        </div>

        <button className="btn" type="submit" disabled={loading}>
          {loading ? '処理中…' : mode === 'login' ? 'ログイン' : 'アカウントを作成'}
        </button>
        <div style={{ textAlign: 'center', fontSize: 12, color: 'var(--text-faint)' }}>または</div>
        <button type="button" className="btn btn--secondary">Google で続ける</button>
        {mode === 'login' && <a href="#/u/auth-form" onClick={(e) => e.preventDefault()} style={{ fontSize: 12.5, textAlign: 'center' }}>パスワードをお忘れですか？</a>}
      </form>
      <Note>
        パスワードは「確認用にもう1回」ではなく表示切替ボタンで。<code>autocomplete</code> 属性を正しく付けると
        パスワードマネージャが機能し、完了率が上がります。エラー時も入力は消しません。
      </Note>
    </div>
  );
}

/* ----------------------------------------------------------- search-and-filter */
const PRODUCTS = [
  { n: 'ワイヤレスイヤホン', c: '電子機器', p: 12800, r: 4.5 },
  { n: 'デスクライト', c: '家具', p: 4800, r: 4.1 },
  { n: 'ノートPCスタンド', c: '周辺機器', p: 3200, r: 4.7 },
  { n: 'メカニカルキーボード', c: '周辺機器', p: 15800, r: 4.3 },
  { n: 'オフィスチェア', c: '家具', p: 42800, r: 4.6 },
  { n: 'モバイルバッテリー', c: '電子機器', p: 3980, r: 3.9 },
];

export function SearchAndFilterDemo() {
  const [q, setQ] = useState('');
  const [cats, setCats] = useState([]);
  const [maxPrice, setMaxPrice] = useState(50000);

  const results = useMemo(
    () => PRODUCTS.filter((p) => (!q || p.n.includes(q)) && (cats.length === 0 || cats.includes(p.c)) && p.p <= maxPrice),
    [q, cats, maxPrice]
  );
  const catCount = (c) => PRODUCTS.filter((p) => p.c === c && p.p <= maxPrice && (!q || p.n.includes(q))).length;
  const hasFilter = q || cats.length || maxPrice < 50000;

  return (
    <div className="d-stack">
      <div style={{ position: 'relative' }}>
        <span style={{ position: 'absolute', left: 11, top: 10, color: 'var(--text-faint)' }}><IconSearch size={17} /></span>
        <input className="input" type="search" value={q} onChange={(e) => setQ(e.target.value)} placeholder="商品名で検索" aria-label="商品名で検索" style={{ paddingLeft: 36 }} />
      </div>

      <div className="d-row" style={{ gap: 6 }}>
        {['電子機器', '家具', '周辺機器'].map((c) => {
          const on = cats.includes(c);
          const n = catCount(c);
          return (
            <button
              key={c}
              aria-pressed={on}
              disabled={n === 0 && !on}
              onClick={() => setCats((p) => (on ? p.filter((x) => x !== c) : [...p, c]))}
              style={{
                padding: '5px 12px', borderRadius: 999, fontSize: 12.5, cursor: n === 0 && !on ? 'not-allowed' : 'pointer',
                border: `1px solid ${on ? 'var(--accent)' : 'var(--border-strong)'}`,
                background: on ? 'var(--accent-soft)' : 'transparent',
                color: on ? 'var(--accent)' : 'var(--text-muted)', opacity: n === 0 && !on ? .45 : 1,
              }}
            >
              {c}（{n}）
            </button>
          );
        })}
      </div>

      <div className="field">
        <label className="field__label" htmlFor="sf-price">上限価格：¥{maxPrice.toLocaleString()}</label>
        <input id="sf-price" type="range" min="3000" max="50000" step="1000" value={maxPrice} onChange={(e) => setMaxPrice(+e.target.value)} />
      </div>

      <div className="d-row" style={{ justifyContent: 'space-between' }}>
        <span aria-live="polite" style={{ fontSize: 12.5, color: 'var(--text-muted)' }}><strong>{results.length}</strong> 件が該当</span>
        {hasFilter && <button className="btn btn--ghost btn--sm" onClick={() => { setQ(''); setCats([]); setMaxPrice(50000); }}>すべてクリア</button>}
      </div>

      {results.length === 0 ? (
        <div style={{ border: '1px dashed var(--border-strong)', borderRadius: 'var(--radius)', padding: 22, textAlign: 'center' }}>
          <div style={{ fontSize: 26 }} aria-hidden="true">🔍</div>
          <p style={{ fontSize: 13, fontWeight: 700, marginTop: 6 }}>条件に合う商品がありません</p>
          <button className="btn btn--secondary btn--sm" style={{ marginTop: 10 }} onClick={() => { setCats([]); setMaxPrice(50000); }}>絞り込みを緩める</button>
        </div>
      ) : (
        <div className="d-list">
          {results.map((p) => (
            <div className="d-list__item" key={p.n}>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 13.5, fontWeight: 600 }}>{p.n}</div>
                <div style={{ fontSize: 11.5, color: 'var(--text-faint)' }}>{p.c} · ★{p.r}</div>
              </div>
              <div style={{ fontSize: 13.5, fontWeight: 700 }}>¥{p.p.toLocaleString()}</div>
            </div>
          ))}
        </div>
      )}
      <Note>
        各カテゴリチップに該当件数を表示し、0件になる条件は選べなくしています（0件地獄の予防）。
        適用中の条件はすべて画面に見えていて、「すべてクリア」がいつでも押せます。
      </Note>
    </div>
  );
}

/* ------------------------------------------------------------------------ sort */
export function SortDemo() {
  const [sort, setSort] = useState('recommended');
  const [announce, setAnnounce] = useState('');
  const opts = {
    recommended: 'おすすめ順',
    price_asc: '価格の安い順',
    price_desc: '価格の高い順',
    rating: '評価の高い順',
  };
  const sorted = useMemo(() => {
    const a = [...PRODUCTS];
    if (sort === 'price_asc') a.sort((x, y) => x.p - y.p);
    if (sort === 'price_desc') a.sort((x, y) => y.p - x.p);
    if (sort === 'rating') a.sort((x, y) => y.r - x.r);
    return a;
  }, [sort]);

  return (
    <div className="d-stack">
      <div className="d-row" style={{ justifyContent: 'space-between' }}>
        <span style={{ fontSize: 12.5, color: 'var(--text-muted)' }}>{PRODUCTS.length}件の商品</span>
        <div className="field" style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
          <label className="field__label" htmlFor="sort-sel" style={{ whiteSpace: 'nowrap' }}>並べ替え</label>
          <select
            id="sort-sel"
            className="select"
            value={sort}
            onChange={(e) => { setSort(e.target.value); setAnnounce(`${opts[e.target.value]}に並べ替えました`); }}
            style={{ width: 'auto', minWidth: 150 }}
          >
            {Object.entries(opts).map(([v, l]) => <option key={v} value={v}>{l}</option>)}
          </select>
        </div>
      </div>
      <div aria-live="polite" className="sr-only">{announce}</div>
      <div className="d-list">
        {sorted.map((p, i) => (
          <div className="d-list__item" key={p.n}>
            <span style={{ width: 20, fontSize: 11.5, color: 'var(--text-faint)' }}>{i + 1}</span>
            <span style={{ flex: 1, fontSize: 13.5 }}>{p.n}</span>
            <span style={{ fontSize: 12, color: 'var(--text-muted)' }}>★{p.r}</span>
            <span style={{ fontSize: 13.5, fontWeight: 700, minWidth: 72, textAlign: 'right' }}>¥{p.p.toLocaleString()}</span>
          </div>
        ))}
      </div>
      <Out label="現在の並び順">{opts[sort]}</Out>
      <Note>現在の並び順を必ず画面に表示すること。並べ替えの結果は aria-live で読み上げユーザーにも伝えます。</Note>
    </div>
  );
}

/* ------------------------------------------------------------------------ undo */
export function UndoDemo() {
  const [tasks, setTasks] = useState([
    { id: 1, t: '週次レポートを書く', done: false },
    { id: 2, t: 'デザインレビュー', done: false },
    { id: 3, t: '請求書を送付', done: false },
  ]);
  const [trash, setTrash] = useState(null);
  const timer = useRef(null);

  const remove = (task) => {
    setTasks((p) => p.filter((x) => x.id !== task.id));
    setTrash(task);
    clearTimeout(timer.current);
    timer.current = setTimeout(() => setTrash(null), 6000); // 6秒後に確定（この間はサーバへ送らない）
  };
  const undo = () => {
    clearTimeout(timer.current);
    setTasks((p) => [trash, ...p].sort((a, b) => a.id - b.id));
    setTrash(null);
  };
  useEffect(() => () => clearTimeout(timer.current), []);

  return (
    <div className="d-stack">
      <div className="d-list">
        {tasks.map((t) => (
          <div className="d-list__item" key={t.id}>
            <span style={{ flex: 1, fontSize: 13.5 }}>{t.t}</span>
            <button className="iconbtn" style={{ width: 30, height: 30, color: 'var(--danger)' }} onClick={() => remove(t)} aria-label={`${t.t} を削除`}>
              <IconTrash size={16} />
            </button>
          </div>
        ))}
        {tasks.length === 0 && <div className="d-list__item" style={{ fontSize: 13, color: 'var(--text-muted)' }}>タスクはありません</div>}
      </div>
      {trash && (
        <div role="status" style={{ display: 'flex', alignItems: 'center', gap: 12, background: 'var(--text)', color: 'var(--bg-elev)', borderRadius: 10, padding: '11px 14px', fontSize: 13 }}>
          <span style={{ flex: 1 }}>「{trash.t}」を削除しました</span>
          <button onClick={undo} style={{ border: 0, background: 'transparent', color: 'var(--accent)', fontWeight: 800, cursor: 'pointer', fontSize: 13.5 }}>元に戻す</button>
        </div>
      )}
      <Note>
        確認ダイアログを出さずに削除し、6秒間だけ取り消せるようにしています。
        実装のコツは「削除ボタンを押した時点ではサーバへ送らず、猶予時間の経過後に確定する」こと。
      </Note>
    </div>
  );
}

/* -------------------------------------------------------------- confirm-dialog */
export function ConfirmDialogDemo() {
  const [open, setOpen] = useState(false);
  const [log, setLog] = useState('');
  const cancelRef = useRef(null);
  useEffect(() => { if (open) cancelRef.current?.focus(); }, [open]);

  return (
    <div className="d-stack">
      <button className="btn btn--danger" onClick={() => setOpen(true)}>アカウントを解約する</button>
      <Out label="結果">{log || '未実行'}</Out>

      {open && (
        <div
          onMouseDown={(e) => { if (e.target === e.currentTarget) setOpen(false); }}
          style={{ position: 'fixed', inset: 0, zIndex: 80, background: 'rgba(8,11,22,.55)', display: 'grid', placeItems: 'center', padding: 16 }}
        >
          <div
            role="alertdialog"
            aria-modal="true"
            aria-labelledby="cf-t"
            aria-describedby="cf-d"
            onKeyDown={(e) => { if (e.key === 'Escape') setOpen(false); }}
            style={{ width: 'min(370px, 92vw)', background: 'var(--bg-elev)', border: '1px solid var(--border-strong)', borderRadius: 14, padding: 18, boxShadow: 'var(--shadow-lg)' }}
          >
            <h3 id="cf-t" style={{ fontSize: 15.5 }}>アカウントを解約しますか？</h3>
            <div id="cf-d" style={{ fontSize: 13, color: 'var(--text-muted)', marginTop: 8, lineHeight: 1.9 }}>
              解約すると、以下が<strong style={{ color: 'var(--danger)' }}>すべて失われます</strong>。
              <ul style={{ paddingLeft: '1.2em', marginTop: 6 }}>
                <li>保存済みのプロジェクト 24件</li>
                <li>チームメンバーの共有設定</li>
                <li>残り18日分の利用期間（返金はありません）</li>
              </ul>
            </div>
            <div style={{ display: 'flex', gap: 8, marginTop: 16, justifyContent: 'flex-end' }}>
              <button ref={cancelRef} className="btn btn--secondary" onClick={() => setOpen(false)}>解約しない</button>
              <button className="btn btn--danger" onClick={() => { setLog('アカウントを解約しました'); setOpen(false); }}>解約する</button>
            </div>
          </div>
        </div>
      )}
      <Note>
        「OK / キャンセル」ではなく「解約する / 解約しない」と動詞で。何が失われるかを具体的に列挙し、
        初期フォーカスは安全な側に置きます。
      </Note>
    </div>
  );
}

/* ------------------------------------------------------------ validation-error */
export function ValidationErrorDemo() {
  const [form, setForm] = useState({ name: '', mail: '', tel: '', agree: false });
  const [touched, setTouched] = useState({});
  const [submitted, setSubmitted] = useState(false);
  const summaryRef = useRef(null);

  const normalize = (s) => s.replace(/[０-９]/g, (c) => String.fromCharCode(c.charCodeAt(0) - 0xfee0)).replace(/[-\s]/g, '');
  const errors = {
    name: !form.name.trim() ? 'お名前を入力してください' : null,
    mail: !form.mail.trim() ? 'メールアドレスを入力してください' : !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(form.mail) ? '「@」を含む形式で入力してください（例: you@example.com）' : null,
    tel: form.tel && !/^0\d{9,10}$/.test(normalize(form.tel)) ? '電話番号は10〜11桁の数字で入力してください（ハイフンあり・全角でもOK）' : null,
    agree: !form.agree ? '利用規約への同意が必要です' : null,
  };
  const errorList = Object.entries(errors).filter(([, v]) => v);
  const showError = (k) => (touched[k] || submitted) && errors[k];

  const onSubmit = (e) => {
    e.preventDefault();
    setSubmitted(true);
    if (errorList.length) {
      setTimeout(() => summaryRef.current?.focus(), 0);
    }
  };

  const labels = { name: 'お名前', mail: 'メールアドレス', tel: '電話番号', agree: '利用規約' };

  return (
    <div className="d-stack">
      <form onSubmit={onSubmit} noValidate className="d-stack" style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: 16 }}>
        {submitted && errorList.length > 0 && (
          <div ref={summaryRef} tabIndex={-1} role="alert" style={{ background: 'var(--danger-soft)', border: '1px solid var(--danger)', borderRadius: 8, padding: '10px 13px' }}>
            <strong style={{ fontSize: 13, color: 'var(--danger)' }}>{errorList.length}件の入力エラーがあります</strong>
            <ul style={{ paddingLeft: '1.2em', margin: '5px 0 0' }}>
              {errorList.map(([k, v]) => (
                <li key={k} style={{ fontSize: 12.5 }}>
                  <a href={`#field-${k}`} onClick={(e) => { e.preventDefault(); document.getElementById(`field-${k}`)?.focus(); }} style={{ color: 'var(--danger)' }}>
                    {labels[k]}: {v}
                  </a>
                </li>
              ))}
            </ul>
          </div>
        )}
        {submitted && errorList.length === 0 && (
          <div role="status" style={{ background: 'var(--success-soft)', border: '1px solid var(--success)', borderRadius: 8, padding: '10px 13px', fontSize: 13, color: 'var(--success)', fontWeight: 700 }}>
            ✅ 送信しました
          </div>
        )}

        {['name', 'mail', 'tel'].map((k) => (
          <div className="field" key={k}>
            <label className="field__label" htmlFor={`field-${k}`}>
              {labels[k]}{k !== 'tel' && <span style={{ color: 'var(--danger)' }}> *</span>}
            </label>
            <input
              id={`field-${k}`}
              className="input"
              value={form[k]}
              onChange={(e) => setForm({ ...form, [k]: e.target.value })}
              onBlur={() => setTouched((t) => ({ ...t, [k]: true }))}
              aria-invalid={!!showError(k)}
              aria-describedby={showError(k) ? `err-${k}` : k === 'tel' ? 'hint-tel' : undefined}
              placeholder={k === 'tel' ? '090-1234-5678' : ''}
            />
            {showError(k) ? (
              <span className="field__error" id={`err-${k}`}>✕ {errors[k]}</span>
            ) : k === 'tel' ? (
              <span className="field__hint" id="hint-tel">ハイフン・全角数字はこちらで自動的に整形します</span>
            ) : null}
          </div>
        ))}

        <label style={{ display: 'flex', gap: 8, alignItems: 'flex-start', fontSize: 13 }}>
          <input
            id="field-agree"
            type="checkbox"
            checked={form.agree}
            onChange={(e) => { setForm({ ...form, agree: e.target.checked }); setTouched((t) => ({ ...t, agree: true })); }}
            aria-invalid={!!showError('agree')}
            style={{ marginTop: 3 }}
          />
          <span>
            利用規約に同意します<span style={{ color: 'var(--danger)' }}> *</span>
            {showError('agree') && <div className="field__error">✕ {errors.agree}</div>}
          </span>
        </label>

        <button className="btn" type="submit">送信する</button>
        <span className="field__hint">
          ボタンは常に押せます。押せない理由を伝えられないまま無効化するより、押させてエラーを示す方が親切です。
        </span>
      </form>
      <Note>
        エラーは blur（入力欄から離れた時）で表示。送信時はサマリを出し、フォーカスをそこへ移動、各項目へジャンプできます。
        電話番号のハイフンや全角数字は弾かずに正規化します。
      </Note>
    </div>
  );
}

/* ------------------------------------------------------------------ three-states */
export function ThreeStatesDemo() {
  const [state, setState] = useState('loading');
  useEffect(() => { const t = setTimeout(() => setState('success'), 1200); return () => clearTimeout(t); }, []);
  const retry = () => { setState('loading'); setTimeout(() => setState('success'), 1000); };

  return (
    <div className="d-stack">
      <div className="d-row">
        {[['loading', '読み込み中'], ['success', '成功'], ['empty', '空（0件）'], ['error', 'エラー']].map(([k, l]) => (
          <button key={k} className={state === k ? 'btn btn--sm' : 'btn btn--secondary btn--sm'} onClick={() => setState(k)}>{l}</button>
        ))}
      </div>

      <div style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', minHeight: 190, padding: 14 }} aria-busy={state === 'loading'} aria-live="polite">
        {state === 'loading' && (
          <div aria-hidden="true">
            {[0, 1, 2].map((i) => (
              <div key={i} style={{ display: 'flex', gap: 10, marginBottom: 12 }}>
                <div className="d-skel" style={{ width: 38, height: 38, borderRadius: 8, flex: 'none' }} />
                <div style={{ flex: 1 }}>
                  <div className="d-skel" style={{ height: 11, width: '48%', marginBottom: 6 }} />
                  <div className="d-skel" style={{ height: 9, width: '84%' }} />
                </div>
              </div>
            ))}
          </div>
        )}
        {state === 'success' && (
          <div className="d-list" style={{ border: 0 }}>
            {['プロジェクトA', 'プロジェクトB', 'プロジェクトC'].map((t) => (
              <div className="d-list__item" key={t}><span style={{ fontSize: 13.5 }}>{t}</span><IconChevronRight size={16} style={{ color: 'var(--text-faint)' }} /></div>
            ))}
          </div>
        )}
        {state === 'empty' && (
          <div style={{ textAlign: 'center', padding: '30px 10px' }}>
            <div style={{ fontSize: 32 }} aria-hidden="true">📂</div>
            <p style={{ fontWeight: 700, fontSize: 14, marginTop: 8 }}>プロジェクトがまだありません</p>
            <p style={{ fontSize: 12.5, color: 'var(--text-muted)', marginTop: 4 }}>最初のプロジェクトを作成して始めましょう。</p>
            <button className="btn btn--sm" style={{ marginTop: 12 }}>プロジェクトを作成</button>
          </div>
        )}
        {state === 'error' && (
          <div style={{ textAlign: 'center', padding: '30px 10px' }} role="alert">
            <div style={{ fontSize: 32, color: 'var(--danger)' }} aria-hidden="true"><IconAlert size={34} /></div>
            <p style={{ fontWeight: 700, fontSize: 14, marginTop: 8 }}>データを読み込めませんでした</p>
            <p style={{ fontSize: 12.5, color: 'var(--text-muted)', marginTop: 4 }}>ネットワーク接続を確認してください。問題が続く場合はサポートへご連絡ください。</p>
            <button className="btn btn--sm" style={{ marginTop: 12 }} onClick={retry}><IconRefresh size={15} /> 再試行</button>
          </div>
        )}
      </div>
      <Note>
        4つの状態を切り替えてみてください。<strong>「エラー」と「空」を混同しない</strong>のが最重要。
        エラーには必ず再試行手段を、空には次の一歩を置きます。
      </Note>
    </div>
  );
}

/* -------------------------------------------------------------- dark-mode-toggle */
export function DarkModeToggleDemo() {
  const [mode, setMode] = useState(() => {
    try { return localStorage.getItem('ui-catalog-theme') ?? 'system'; } catch { return 'system'; }
  });
  const apply = (m) => {
    setMode(m);
    const root = document.documentElement;
    if (m === 'system') { root.removeAttribute('data-theme'); try { localStorage.removeItem('ui-catalog-theme'); } catch {} }
    else { root.setAttribute('data-theme', m); try { localStorage.setItem('ui-catalog-theme', m); } catch {} }
  };
  const systemDark = typeof window !== 'undefined' && window.matchMedia?.('(prefers-color-scheme: dark)').matches;

  return (
    <div className="d-stack">
      <div role="radiogroup" aria-label="表示テーマ" style={{ display: 'inline-flex', background: 'var(--bg-sunken)', border: '1px solid var(--border)', borderRadius: 10, padding: 3, gap: 2, alignSelf: 'flex-start' }}>
        {[['light', '☀️ ライト'], ['dark', '🌙 ダーク'], ['system', '⚙️ システム']].map(([v, l]) => (
          <button
            key={v}
            role="radio"
            aria-checked={mode === v}
            onClick={() => apply(v)}
            style={{ border: 0, cursor: 'pointer', padding: '7px 13px', borderRadius: 8, fontSize: 13, fontWeight: mode === v ? 700 : 500, background: mode === v ? 'var(--bg-elev)' : 'transparent', color: mode === v ? 'var(--text)' : 'var(--text-muted)' }}
          >
            {l}
          </button>
        ))}
      </div>
      <Out label="現在">
        {mode === 'system' ? `システム連動（OSは現在 ${systemDark ? 'ダーク' : 'ライト'}）` : mode === 'dark' ? 'ダーク固定' : 'ライト固定'}
        ／ 選択は localStorage に保存され、リロードしても維持されます
      </Out>
      <div style={{ display: 'grid', gap: 8, gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))' }}>
        {[['本文テキスト', 'var(--text)', 'var(--bg-elev)'], ['補助テキスト', 'var(--text-muted)', 'var(--bg-elev)'], ['アクセント', 'var(--accent-text)', 'var(--accent)']].map(([l, fg, bg]) => (
          <div key={l} style={{ background: bg, color: fg, border: '1px solid var(--border)', borderRadius: 8, padding: 11, fontSize: 13 }}>{l}</div>
        ))}
      </div>
      <Note>
        3択（ライト／ダーク／システム連動）が現代の標準。色をすべてCSS変数（トークン）にしておけば、値の差し替えだけで切り替わります。
        このページ全体の色もこの操作で切り替わります。
      </Note>
    </div>
  );
}

/* ------------------------------------------------------------- permission-prompt */
export function PermissionPromptDemo() {
  const [step, setStep] = useState('idle'); // idle | priming | os | granted | denied
  return (
    <div className="d-stack">
      <Phone height={340}>
        <div style={{ flex: 1, padding: 14, position: 'relative' }}>
          <div style={{ fontWeight: 800, fontSize: 15, marginBottom: 8 }}>チャット</div>
          {['佐藤さん: 資料できました', '鈴木さん: 了解です！'].map((m) => (
            <div key={m} style={{ border: '1px solid var(--border)', borderRadius: 10, padding: 10, marginBottom: 7, fontSize: 12.5, background: 'var(--bg-elev)' }}>{m}</div>
          ))}
          {step === 'idle' && (
            <button className="btn btn--sm" style={{ marginTop: 10 }} onClick={() => setStep('priming')}>
              3通目のメッセージを受け取る（ここで初めて通知を求める）
            </button>
          )}
          {step === 'granted' && <div style={{ marginTop: 10, fontSize: 12.5, color: 'var(--success)', fontWeight: 700 }}>✅ 通知が有効になりました</div>}
          {step === 'denied' && (
            <div style={{ marginTop: 10, fontSize: 12.5, color: 'var(--text-muted)' }}>
              通知はオフのままです。アプリ内バッジでお知らせします。<br />
              <button className="btn btn--ghost btn--sm" style={{ paddingLeft: 0 }} onClick={() => setStep('idle')}>設定から後で有効にする</button>
            </div>
          )}

          {step === 'priming' && (
            <div style={{ position: 'absolute', inset: 0, background: 'rgba(8,11,22,.5)', display: 'grid', placeItems: 'center', padding: 16 }}>
              <div style={{ background: 'var(--bg-elev)', borderRadius: 14, padding: 16, textAlign: 'center', boxShadow: 'var(--shadow-lg)' }}>
                <div style={{ fontSize: 30 }} aria-hidden="true"><IconBell size={32} /></div>
                <h4 style={{ fontSize: 14.5, marginTop: 6 }}>返信をすぐ受け取りませんか？</h4>
                <p style={{ fontSize: 12, color: 'var(--text-muted)', marginTop: 6, lineHeight: 1.7 }}>
                  通知をオンにすると、新しいメッセージが届いたときにお知らせします。あとから設定で変更できます。
                </p>
                <div style={{ display: 'flex', gap: 7, marginTop: 12 }}>
                  <button className="btn btn--secondary btn--sm" style={{ flex: 1 }} onClick={() => setStep('denied')}>今はしない</button>
                  <button className="btn btn--sm" style={{ flex: 1 }} onClick={() => setStep('os')}>オンにする</button>
                </div>
                <p style={{ fontSize: 10.5, color: 'var(--text-faint)', marginTop: 8 }}>↑ これがアプリ独自の「プライミング」画面</p>
              </div>
            </div>
          )}

          {step === 'os' && (
            <div style={{ position: 'absolute', inset: 0, background: 'rgba(8,11,22,.5)', display: 'grid', placeItems: 'center', padding: 16 }}>
              <div style={{ background: 'var(--bg-elev)', borderRadius: 14, overflow: 'hidden', width: '100%', maxWidth: 250, boxShadow: 'var(--shadow-lg)', border: '1px solid var(--border-strong)' }}>
                <div style={{ padding: 14, textAlign: 'center' }}>
                  <div style={{ fontSize: 13, fontWeight: 700 }}>“ChatApp”は通知を送信します。よろしいですか？</div>
                  <div style={{ fontSize: 11.5, color: 'var(--text-muted)', marginTop: 5 }}>通知方法：テキスト、サウンド、アイコンバッジ</div>
                </div>
                <div style={{ display: 'flex', borderTop: '1px solid var(--border)' }}>
                  <button onClick={() => setStep('denied')} style={{ flex: 1, border: 0, background: 'transparent', padding: 11, cursor: 'pointer', fontSize: 13, borderRight: '1px solid var(--border)' }}>許可しない</button>
                  <button onClick={() => setStep('granted')} style={{ flex: 1, border: 0, background: 'transparent', padding: 11, cursor: 'pointer', fontSize: 13, fontWeight: 700, color: 'var(--accent)' }}>許可</button>
                </div>
                <div style={{ fontSize: 10.5, color: 'var(--text-faint)', textAlign: 'center', padding: '6px 8px 8px' }}>↑ これがOSの許可ダイアログ（1度しか出せない）</div>
              </div>
            </div>
          )}
        </div>
      </Phone>
      <div className="d-row">
        <button className="btn btn--secondary btn--sm" onClick={() => setStep('idle')}>デモをリセット</button>
        <Out label="状態">{step}</Out>
      </div>
      <Note>
        起動直後ではなく「価値を体験した後」に、まず自社のプライミング画面で理由を説明してから OS ダイアログを出します。
        「今はしない」を選んでも、OS の許可は消費されないので後から再度求められます。
      </Note>
    </div>
  );
}
