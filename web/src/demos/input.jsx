import { useEffect, useMemo, useRef, useState } from 'react';
import { Compare, Note, Out, PREFECTURES, useTimedFlag } from './common.jsx';
import { IconCalendar, IconClose, IconMinus, IconPlus, IconSearch, IconStar, IconUpload } from '../components/Icons.jsx';

/* ---------------------------------------------------------------- text-field */
export function TextFieldDemo() {
  const [value, setValue] = useState('');
  const [touched, setTouched] = useState(false);
  const invalid = touched && value.length > 0 && !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(value);
  return (
    <div className="d-stack">
      <div className="field">
        <label className="field__label" htmlFor="tf-mail">メールアドレス</label>
        <input
          id="tf-mail"
          className="input"
          type="email"
          inputMode="email"
          autoComplete="email"
          placeholder="you@example.com"
          value={value}
          onChange={(e) => setValue(e.target.value)}
          onBlur={() => setTouched(true)}
          aria-invalid={invalid}
          aria-describedby={invalid ? 'tf-err' : 'tf-hint'}
        />
        {invalid
          ? <span className="field__error" id="tf-err" role="alert">「@」を含む形式で入力してください（例: you@example.com）</span>
          : <span className="field__hint" id="tf-hint">ログインIDとして使用します</span>}
      </div>
      <Out label="入力値">{value || '（未入力）'}</Out>
      <Note>
        ラベル・ヘルプ・エラーの3点セット。エラーはフォーカスを外した（blur）タイミングで初めて出しています。
        入力中の1文字目から赤くしないのがポイント。
      </Note>
    </div>
  );
}

/* ------------------------------------------------------------------ textarea */
export function TextareaDemo() {
  const [text, setText] = useState('');
  const max = 140;
  const over = text.length > max;
  const ref = useRef(null);
  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    el.style.height = 'auto';
    el.style.height = Math.min(el.scrollHeight, 260) + 'px';
  }, [text]);
  return (
    <div className="d-stack">
      <div className="field">
        <label className="field__label" htmlFor="ta">投稿本文</label>
        <textarea
          id="ta"
          ref={ref}
          className="textarea"
          rows={3}
          value={text}
          onChange={(e) => setText(e.target.value)}
          placeholder="いま何してる？"
          aria-describedby="ta-count"
        />
        <div style={{ display: 'flex', justifyContent: 'space-between' }}>
          <span className="field__hint">入力に合わせて高さが伸びます</span>
          <span
            id="ta-count"
            aria-live="polite"
            style={{ fontSize: 11.5, fontVariantNumeric: 'tabular-nums', color: over ? 'var(--danger)' : 'var(--text-faint)', fontWeight: over ? 700 : 400 }}
          >
            {text.length} / {max}
          </span>
        </div>
      </div>
      <button className="btn" disabled={over || text.length === 0}>投稿する</button>
      <Note>超過分は切り捨てず、赤く見せてユーザーに削らせます（切り捨ては書いた内容を黙って失わせる最悪の挙動）。</Note>
    </div>
  );
}

/* ------------------------------------------------------------------ checkbox */
export function CheckboxDemo() {
  const options = ['送料無料', '当日配送', 'セール対象', '新品のみ'];
  const [checked, setChecked] = useState(['送料無料']);
  const allRef = useRef(null);
  const all = checked.length === options.length;
  const some = checked.length > 0 && !all;
  useEffect(() => { if (allRef.current) allRef.current.indeterminate = some; }, [some]);

  return (
    <div className="d-stack">
      <fieldset style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: '10px 14px 14px' }}>
        <legend style={{ fontSize: 12.5, fontWeight: 700, padding: '0 6px' }}>絞り込み条件（複数選択可）</legend>
        <label style={{ display: 'flex', gap: 9, alignItems: 'center', padding: '5px 0', borderBottom: '1px dashed var(--border)', marginBottom: 5 }}>
          <input
            ref={allRef}
            type="checkbox"
            checked={all}
            onChange={(e) => setChecked(e.target.checked ? [...options] : [])}
            style={{ width: 17, height: 17 }}
          />
          <span style={{ fontWeight: 700, fontSize: 13.5 }}>すべて選択{some && '（一部選択中）'}</span>
        </label>
        {options.map((o) => (
          <label key={o} style={{ display: 'flex', gap: 9, alignItems: 'center', padding: '5px 0', cursor: 'pointer' }}>
            <input
              type="checkbox"
              checked={checked.includes(o)}
              onChange={(e) => setChecked((prev) => (e.target.checked ? [...prev, o] : prev.filter((x) => x !== o)))}
              style={{ width: 17, height: 17 }}
            />
            <span style={{ fontSize: 14 }}>{o}</span>
          </label>
        ))}
      </fieldset>
      <Out label="選択中">{checked.length ? checked.join(' / ') : 'なし（0個でも成立するのがチェックボックス）'}</Out>
      <Note>親チェックの「一部選択中」が indeterminate（中間状態）。ラベル文字のクリックでも切り替わることを確かめてください。</Note>
    </div>
  );
}

/* --------------------------------------------------------------------- radio */
export function RadioDemo() {
  const plans = [
    { id: 'std', name: '通常配送', desc: '3〜5日で到着', price: '無料' },
    { id: 'exp', name: 'お急ぎ便', desc: '翌日までに到着', price: '+500円' },
    { id: 'day', name: '日時指定便', desc: '希望日時を指定', price: '+800円' },
  ];
  const [sel, setSel] = useState('std');
  return (
    <div className="d-stack">
      <fieldset style={{ border: 0, padding: 0, margin: 0 }}>
        <legend className="d-label" style={{ marginBottom: 8 }}>配送方法を選択</legend>
        <div className="d-stack" style={{ gap: 8 }}>
          {plans.map((p) => (
            <label
              key={p.id}
              style={{
                display: 'flex', gap: 10, alignItems: 'flex-start', cursor: 'pointer',
                border: `1px solid ${sel === p.id ? 'var(--accent)' : 'var(--border)'}`,
                background: sel === p.id ? 'var(--accent-soft)' : 'var(--bg-elev)',
                borderRadius: 'var(--radius)', padding: '11px 13px',
              }}
            >
              <input
                type="radio"
                name="shipping"
                value={p.id}
                checked={sel === p.id}
                onChange={() => setSel(p.id)}
                style={{ width: 17, height: 17, marginTop: 2 }}
              />
              <span style={{ flex: 1 }}>
                <span style={{ fontWeight: 700, fontSize: 14 }}>{p.name}</span>
                <span style={{ float: 'right', fontSize: 13, fontWeight: 700 }}>{p.price}</span>
                <div style={{ fontSize: 12.5, color: 'var(--text-muted)' }}>{p.desc}</div>
              </span>
            </label>
          ))}
        </div>
      </fieldset>
      <Note>
        選択肢が全部見えているので比較できます。行全体がタップ領域。矢印キーでもグループ内を移動できます（ネイティブ radio の利点）。
      </Note>
    </div>
  );
}

/* ------------------------------------------------------------- toggle-switch */
function Switch({ checked, onChange, label, id, disabled }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12, padding: '9px 2px' }}>
      <label htmlFor={id} style={{ fontSize: 14, cursor: disabled ? 'not-allowed' : 'pointer', opacity: disabled ? .5 : 1 }}>{label}</label>
      <button
        id={id}
        role="switch"
        aria-checked={checked}
        disabled={disabled}
        onClick={() => onChange(!checked)}
        style={{
          width: 50, height: 30, borderRadius: 999, border: '1px solid var(--border-strong)',
          background: checked ? 'var(--accent)' : 'var(--bg-sunken)', position: 'relative',
          cursor: disabled ? 'not-allowed' : 'pointer', transition: 'background .18s ease', flex: 'none', opacity: disabled ? .5 : 1,
        }}
      >
        <span
          aria-hidden="true"
          style={{
            position: 'absolute', top: 2, left: checked ? 22 : 2, width: 24, height: 24, borderRadius: '50%',
            background: '#fff', boxShadow: '0 1px 3px rgba(0,0,0,.3)', transition: 'left .18s ease',
            display: 'grid', placeItems: 'center', fontSize: 11, color: 'var(--accent)', fontWeight: 900,
          }}
        >
          {checked ? '✓' : ''}
        </span>
      </button>
    </div>
  );
}

export function ToggleSwitchDemo() {
  const [notify, setNotify] = useState(true);
  const [sound, setSound] = useState(false);
  const [saving, setSaving] = useState(false);
  const [log, setLog] = useState('（切り替えると即座に反映されます）');

  const changeNotify = async (v) => {
    setSaving(true);
    setNotify(v);
    setLog('サーバーへ保存中…');
    await new Promise((r) => setTimeout(r, 700));
    setSaving(false);
    setLog(`通知を「${v ? 'ON' : 'OFF'}」で保存しました（保存ボタンは不要）`);
  };

  return (
    <div className="d-stack">
      <div style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: '4px 14px' }}>
        <Switch id="sw-1" label="プッシュ通知" checked={notify} onChange={changeNotify} disabled={saving} />
        <div style={{ borderTop: '1px solid var(--border)' }} />
        <Switch id="sw-2" label="サウンド" checked={sound} onChange={setSound} />
      </div>
      <Out label="状態">{log}</Out>
      <Note>
        トグルは「押した瞬間に効く」もの。通信中は disabled にして二度押しを防いでいます。
        保存ボタンを押して初めて反映されるなら、チェックボックスを使うべきです。
      </Note>
    </div>
  );
}

/* -------------------------------------------------------------------- slider */
export function SliderDemo() {
  const [vol, setVol] = useState(60);
  const [range, setRange] = useState([2000, 8000]);
  const setMin = (v) => setRange(([, max]) => [Math.min(v, max - 500), max]);
  const setMax = (v) => setRange(([min]) => [min, Math.max(v, min + 500)]);
  return (
    <div className="d-stack">
      <div className="field">
        <label className="field__label" htmlFor="sl-vol">音量：{vol}%</label>
        <input id="sl-vol" type="range" min="0" max="100" value={vol} onChange={(e) => setVol(+e.target.value)} style={{ width: '100%' }} />
      </div>
      <div className="field">
        <span className="field__label">価格帯（レンジスライダー）</span>
        <label className="sr-only" htmlFor="sl-min">下限価格</label>
        <input id="sl-min" type="range" min="0" max="10000" step="500" value={range[0]} onChange={(e) => setMin(+e.target.value)} style={{ width: '100%' }} />
        <label className="sr-only" htmlFor="sl-max">上限価格</label>
        <input id="sl-max" type="range" min="0" max="10000" step="500" value={range[1]} onChange={(e) => setMax(+e.target.value)} style={{ width: '100%' }} />
      </div>
      <Out label="絞り込み">¥{range[0].toLocaleString()} 〜 ¥{range[1].toLocaleString()}</Out>
      <Note>
        現在値を必ず数値でも表示すること。矢印キー・Home・End でも操作できます（ネイティブ input[type=range] の利点）。
      </Note>
    </div>
  );
}

/* ------------------------------------------------------------- stepper-input */
export function StepperInputDemo() {
  const [qty, setQty] = useState(1);
  const MAX = 5;
  const clamp = (n) => Math.max(0, Math.min(MAX, n));
  return (
    <div className="d-stack">
      <div style={{ display: 'flex', alignItems: 'center', gap: 12, border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: 12 }}>
        <div style={{ width: 42, height: 42, borderRadius: 8, background: 'var(--bg-sunken)', display: 'grid', placeItems: 'center', fontSize: 20 }} aria-hidden="true">🍱</div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ fontWeight: 700, fontSize: 14 }}>日替わり弁当</div>
          <div style={{ fontSize: 12.5, color: 'var(--text-muted)' }}>¥880 / 個（お一人様 {MAX} 個まで）</div>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
          <button className="btn btn--secondary btn--sm" style={{ width: 36, padding: 0 }} onClick={() => setQty(clamp(qty - 1))} disabled={qty <= 0} aria-label="数量を1つ減らす">
            <IconMinus size={16} />
          </button>
          <input
            className="input"
            type="number"
            value={qty}
            min={0}
            max={MAX}
            onChange={(e) => setQty(clamp(+e.target.value || 0))}
            aria-label="数量"
            style={{ width: 56, textAlign: 'center', padding: '7px 4px' }}
          />
          <button className="btn btn--secondary btn--sm" style={{ width: 36, padding: 0 }} onClick={() => setQty(clamp(qty + 1))} disabled={qty >= MAX} aria-label="数量を1つ増やす">
            <IconPlus size={16} />
          </button>
        </div>
      </div>
      <Out label="小計">¥{(qty * 880).toLocaleString()}{qty >= MAX && '（上限に達しました）'}</Out>
      <Note>上限・下限に達したらボタンを disabled に。中央は直接入力もできるようにしておくのが親切です。</Note>
    </div>
  );
}

/* -------------------------------------------------------------------- select */
export function SelectDemo() {
  const [pref, setPref] = useState('');
  return (
    <div className="d-stack">
      <div className="field">
        <label className="field__label" htmlFor="sel-pref">都道府県</label>
        <select id="sel-pref" className="select" value={pref} onChange={(e) => setPref(e.target.value)}>
          <option value="" disabled>選択してください</option>
          <optgroup label="北海道・東北">
            {PREFECTURES.slice(0, 7).map((p) => <option key={p} value={p}>{p}</option>)}
          </optgroup>
          <optgroup label="関東">
            {PREFECTURES.slice(7, 14).map((p) => <option key={p} value={p}>{p}</option>)}
          </optgroup>
          <optgroup label="中部">
            {PREFECTURES.slice(14, 23).map((p) => <option key={p} value={p}>{p}</option>)}
          </optgroup>
          <optgroup label="近畿">
            {PREFECTURES.slice(23, 30).map((p) => <option key={p} value={p}>{p}</option>)}
          </optgroup>
        </select>
        <span className="field__hint">頭文字をキーボードで打つと候補にジャンプできます（ネイティブ select の利点）</span>
      </div>
      <Out label="選択値">{pref || '未選択'}</Out>
      <Note>
        「選択してください」は <code>disabled</code> にして選べなくしています。optgroup でグループ化すると探しやすくなります。
      </Note>
    </div>
  );
}

/* -------------------------------------------------------------- autocomplete */
const FRUITS = ['りんご', 'いちご', 'みかん', 'ぶどう', 'もも', 'なし', 'メロン', 'すいか', 'バナナ', 'キウイ', 'マンゴー', 'パイナップル', 'さくらんぼ', 'ブルーベリー'];

export function AutocompleteDemo() {
  const [q, setQ] = useState('');
  const [open, setOpen] = useState(false);
  const [active, setActive] = useState(0);
  const [selected, setSelected] = useState('');
  const [loading, setLoading] = useState(false);
  const timer = useRef(null);

  const results = useMemo(() => (q ? FRUITS.filter((f) => f.includes(q)) : FRUITS), [q]);

  // デバウンス：1文字ごとに検索せず、入力が止まってから絞り込む
  const onChange = (v) => {
    setQ(v); setOpen(true); setActive(0); setLoading(true);
    clearTimeout(timer.current);
    timer.current = setTimeout(() => setLoading(false), 250);
  };
  useEffect(() => () => clearTimeout(timer.current), []);

  const choose = (v) => { setSelected(v); setQ(v); setOpen(false); };

  return (
    <div className="d-stack">
      <div className="field" style={{ position: 'relative' }}>
        <label className="field__label" htmlFor="ac">好きな果物</label>
        <input
          id="ac"
          className="input"
          role="combobox"
          aria-expanded={open}
          aria-controls="ac-list"
          aria-autocomplete="list"
          aria-activedescendant={open && results[active] ? `ac-opt-${active}` : undefined}
          value={q}
          placeholder="2文字入力すると候補が出ます"
          onChange={(e) => onChange(e.target.value)}
          onFocus={() => setOpen(true)}
          onKeyDown={(e) => {
            if (e.key === 'ArrowDown') { e.preventDefault(); setOpen(true); setActive((i) => Math.min(i + 1, results.length - 1)); }
            else if (e.key === 'ArrowUp') { e.preventDefault(); setActive((i) => Math.max(i - 1, 0)); }
            else if (e.key === 'Enter' && open && results[active]) { e.preventDefault(); choose(results[active]); }
            else if (e.key === 'Escape') { setOpen(false); }
          }}
        />
        {open && (
          <ul
            id="ac-list"
            role="listbox"
            aria-label="候補"
            style={{
              position: 'absolute', top: '100%', left: 0, right: 0, zIndex: 5, margin: '4px 0 0', padding: 4, listStyle: 'none',
              background: 'var(--bg-elev)', border: '1px solid var(--border-strong)', borderRadius: 'var(--radius)',
              boxShadow: 'var(--shadow-md)', maxHeight: 190, overflowY: 'auto',
            }}
          >
            {loading && <li style={{ padding: 8, fontSize: 12.5, color: 'var(--text-faint)' }}>検索中…</li>}
            {!loading && results.length === 0 && (
              <li style={{ padding: '10px 8px', fontSize: 13, color: 'var(--text-muted)' }}>
                候補がありません。<button className="btn btn--ghost btn--sm" onClick={() => choose(q)}>「{q}」を新規追加</button>
              </li>
            )}
            {!loading && results.map((f, i) => (
              <li key={f} id={`ac-opt-${i}`} role="option" aria-selected={i === active}>
                <button
                  className="cmdk__item"
                  data-active={i === active}
                  onMouseEnter={() => setActive(i)}
                  onClick={() => choose(f)}
                  style={{ width: '100%' }}
                >
                  {f}
                </button>
              </li>
            ))}
          </ul>
        )}
      </div>
      <Out label="確定値">{selected || '未確定'}</Out>
      <Note>候補0件でも行き止まりにせず、「新規追加」の逃げ道を用意しています。上下キー＋Enterでも選べます。</Note>
    </div>
  );
}

/* ---------------------------------------------------------- date-time-picker */
export function DateTimePickerDemo() {
  const [start, setStart] = useState('');
  const [end, setEnd] = useState('');
  const [time, setTime] = useState('19:00');
  const today = new Date().toISOString().slice(0, 10);
  const nights = start && end ? Math.max(0, (new Date(end) - new Date(start)) / 86400000) : 0;
  return (
    <div className="d-stack">
      <div style={{ display: 'grid', gap: 10, gridTemplateColumns: '1fr 1fr' }}>
        <div className="field">
          <label className="field__label" htmlFor="dt-in"><IconCalendar size={13} /> チェックイン</label>
          <input id="dt-in" className="input" type="date" min={today} value={start} onChange={(e) => { setStart(e.target.value); if (end && e.target.value > end) setEnd(''); }} />
        </div>
        <div className="field">
          <label className="field__label" htmlFor="dt-out">チェックアウト</label>
          <input id="dt-out" className="input" type="date" min={start || today} value={end} onChange={(e) => setEnd(e.target.value)} disabled={!start} />
        </div>
      </div>
      <div className="field">
        <label className="field__label" htmlFor="dt-time">到着予定時刻</label>
        <input id="dt-time" className="input" type="time" value={time} onChange={(e) => setTime(e.target.value)} style={{ maxWidth: 160 }} />
      </div>
      <Out label="予約内容">
        {start && end ? `${start} 〜 ${end}（${nights}泊） / 到着 ${time}` : '日付を選択してください'}
      </Out>
      <Note>
        チェックアウトの <code>min</code> にチェックインの日付を渡し、逆転した期間を選べないようにしています。
        開始日を変更すると、矛盾する終了日はリセットされます。
      </Note>
    </div>
  );
}

/* -------------------------------------------------------------- file-uploader */
export function FileUploaderDemo() {
  const [files, setFiles] = useState([]);
  const [dragOver, setDragOver] = useState(false);
  const inputRef = useRef(null);

  const addFiles = (list) => {
    const arr = [...list].slice(0, 3).map((f) => ({
      id: Math.random().toString(36).slice(2),
      name: f.name,
      size: f.size,
      progress: 0,
      error: f.size > 2 * 1024 * 1024 ? 'サイズが2MBを超えています' : null,
    }));
    setFiles((prev) => [...prev, ...arr]);
    arr.forEach((f) => {
      if (f.error) return;
      const iv = setInterval(() => {
        setFiles((prev) => prev.map((x) => (x.id === f.id ? { ...x, progress: Math.min(100, x.progress + 12) } : x)));
      }, 160);
      setTimeout(() => clearInterval(iv), 1600);
    });
  };

  return (
    <div className="d-stack">
      <div
        onDragOver={(e) => { e.preventDefault(); setDragOver(true); }}
        onDragLeave={() => setDragOver(false)}
        onDrop={(e) => { e.preventDefault(); setDragOver(false); addFiles(e.dataTransfer.files); }}
        style={{
          border: `2px dashed ${dragOver ? 'var(--accent)' : 'var(--border-strong)'}`,
          background: dragOver ? 'var(--accent-soft)' : 'var(--bg-sunken)',
          borderRadius: 'var(--radius-lg)', padding: '22px 16px', textAlign: 'center',
        }}
      >
        <div style={{ color: 'var(--text-faint)' }}><IconUpload size={26} /></div>
        <p style={{ fontSize: 13.5, fontWeight: 700, marginTop: 6 }}>ここにファイルをドロップ</p>
        <p style={{ fontSize: 12, color: 'var(--text-muted)', marginTop: 2 }}>または</p>
        <button className="btn btn--secondary btn--sm" style={{ marginTop: 8 }} onClick={() => inputRef.current?.click()}>
          ファイルを選択
        </button>
        <input ref={inputRef} type="file" multiple hidden onChange={(e) => addFiles(e.target.files)} />
        <p style={{ fontSize: 11.5, color: 'var(--text-faint)', marginTop: 8 }}>対応形式: 任意 / 1ファイル 2MB まで / 最大3件</p>
      </div>

      <div aria-live="polite" className="d-stack" style={{ gap: 8 }}>
        {files.map((f) => (
          <div key={f.id} style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: '9px 11px' }}>
            <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
              <span style={{ fontSize: 13, fontWeight: 600, flex: 1, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{f.name}</span>
              <span style={{ fontSize: 11.5, color: 'var(--text-faint)' }}>{(f.size / 1024).toFixed(0)} KB</span>
              <button className="iconbtn" style={{ width: 28, height: 28 }} onClick={() => setFiles((p) => p.filter((x) => x.id !== f.id))} aria-label={`${f.name} を削除`}>
                <IconClose size={15} />
              </button>
            </div>
            {f.error ? (
              <div style={{ fontSize: 12, color: 'var(--danger)', fontWeight: 600 }} role="alert">✕ {f.error}</div>
            ) : (
              <div style={{ height: 5, background: 'var(--bg-sunken)', borderRadius: 999, overflow: 'hidden', marginTop: 5 }} role="progressbar" aria-valuenow={f.progress} aria-valuemin={0} aria-valuemax={100} aria-label={`${f.name} のアップロード進捗`}>
                <div style={{ height: '100%', width: `${f.progress}%`, background: f.progress === 100 ? 'var(--success)' : 'var(--accent)', transition: 'width .16s linear' }} />
              </div>
            )}
          </div>
        ))}
        {files.length === 0 && <Out>まだファイルがありません</Out>}
      </div>
      <Note>ドロップ領域とボタンの両方を用意し、対応形式・上限を事前に明示。失敗したファイルは理由付きで残します。</Note>
    </div>
  );
}

/* ---------------------------------------------------------------- search-bar */
const ARTICLES = ['UIデザインの基本', 'アクセシビリティ入門', 'Flutter で作るモバイルUI', '色のコントラスト比', 'フォーム設計の原則', 'ダークモード実装ガイド'];

export function SearchBarDemo() {
  const [q, setQ] = useState('');
  const [submitted, setSubmitted] = useState('');
  const results = submitted ? ARTICLES.filter((a) => a.includes(submitted)) : null;
  return (
    <div className="d-stack">
      <form
        role="search"
        onSubmit={(e) => { e.preventDefault(); setSubmitted(q.trim()); }}
        style={{ display: 'flex', gap: 8 }}
      >
        <div style={{ position: 'relative', flex: 1 }}>
          <span style={{ position: 'absolute', left: 11, top: 10, color: 'var(--text-faint)' }}><IconSearch size={17} /></span>
          <input
            className="input"
            type="search"
            value={q}
            onChange={(e) => setQ(e.target.value)}
            placeholder="記事を検索"
            aria-label="記事を検索"
            enterKeyHint="search"
            style={{ paddingLeft: 36, paddingRight: q ? 36 : 12 }}
          />
          {q && (
            <button
              type="button"
              className="iconbtn"
              style={{ position: 'absolute', right: 2, top: 2, width: 32, height: 32 }}
              onClick={() => { setQ(''); setSubmitted(''); }}
              aria-label="検索キーワードをクリア"
            >
              <IconClose size={15} />
            </button>
          )}
        </div>
        <button className="btn" type="submit">検索</button>
      </form>

      <div aria-live="polite">
        {results === null ? (
          <Out>キーワードを入力して検索してください（例: UI）</Out>
        ) : results.length === 0 ? (
          <div style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: 16, textAlign: 'center' }}>
            <p style={{ fontWeight: 700, fontSize: 13.5 }}>「{submitted}」に一致する記事はありません</p>
            <p style={{ fontSize: 12.5, color: 'var(--text-muted)', marginTop: 4 }}>人気のキーワード:</p>
            <div className="tagrow" style={{ justifyContent: 'center', marginTop: 6 }}>
              {['UI', '色', 'Flutter'].map((k) => (
                <button key={k} className="mini-chip" style={{ cursor: 'pointer' }} onClick={() => { setQ(k); setSubmitted(k); }}>{k}</button>
              ))}
            </div>
          </div>
        ) : (
          <div className="d-list">
            {results.map((r) => <div className="d-list__item" key={r}><span style={{ fontSize: 13.5 }}>{r}</span></div>)}
          </div>
        )}
      </div>
      <Note>0件で行き止まりにせず、次の一歩（人気キーワード）を提示しています。×でのクリアも必須。</Note>
    </div>
  );
}

/* ----------------------------------------------------------------- tag-input */
export function TagInputDemo() {
  const [tags, setTags] = useState(['UI', 'アクセシビリティ']);
  const [draft, setDraft] = useState('');
  const composing = useRef(false);

  const add = (v) => {
    const t = v.trim().replace(/,$/, '');
    if (!t || tags.includes(t) || tags.length >= 5) return;
    setTags((p) => [...p, t]);
  };

  return (
    <div className="d-stack">
      <div className="field">
        <span className="field__label">タグ（最大5個）</span>
        <div
          style={{
            display: 'flex', flexWrap: 'wrap', gap: 6, alignItems: 'center',
            border: '1px solid var(--border-strong)', borderRadius: 'var(--radius)', padding: 7, background: 'var(--bg-elev)',
          }}
          onClick={(e) => e.currentTarget.querySelector('input')?.focus()}
        >
          {tags.map((t) => (
            <span key={t} style={{ display: 'inline-flex', alignItems: 'center', gap: 4, background: 'var(--accent-soft)', color: 'var(--accent)', borderRadius: 999, padding: '3px 4px 3px 10px', fontSize: 12.5, fontWeight: 600 }}>
              {t}
              <button
                onClick={() => setTags((p) => p.filter((x) => x !== t))}
                aria-label={`${t} を削除`}
                style={{ border: 0, background: 'transparent', cursor: 'pointer', color: 'inherit', display: 'grid', placeItems: 'center', width: 20, height: 20, borderRadius: '50%' }}
              >
                <IconClose size={13} />
              </button>
            </span>
          ))}
          <input
            value={draft}
            onChange={(e) => setDraft(e.target.value)}
            onCompositionStart={() => { composing.current = true; }}
            onCompositionEnd={() => { composing.current = false; }}
            onKeyDown={(e) => {
              if (composing.current) return; // IME変換中のEnterを確定と誤認しない
              if (e.key === 'Enter' || e.key === ',') { e.preventDefault(); add(draft); setDraft(''); }
              else if (e.key === 'Backspace' && draft === '' && tags.length) { setTags((p) => p.slice(0, -1)); }
            }}
            placeholder={tags.length >= 5 ? '上限に達しました' : 'Enter または , で追加'}
            aria-label="タグを追加"
            disabled={tags.length >= 5}
            style={{ flex: 1, minWidth: 130, border: 0, outline: 'none', background: 'transparent', color: 'var(--text)', fontSize: 14, padding: '4px 2px' }}
          />
        </div>
        <span className="field__hint">空の状態で Backspace を押すと、直前のタグを削除します</span>
      </div>
      <Out label="送信される値">{JSON.stringify(tags)}</Out>
      <Note>日本語入力（IME）変換中の Enter でタグが確定してしまうバグは、compositionstart/end の判定で防げます。</Note>
    </div>
  );
}

/* -------------------------------------------------------------------- rating */
export function RatingDemo() {
  const [rating, setRating] = useState(0);
  const [hover, setHover] = useState(0);
  const labels = ['', '不満', 'いまいち', 'ふつう', '満足', '非常に満足'];
  const shown = hover || rating;
  return (
    <div className="d-stack">
      <fieldset style={{ border: 0, padding: 0, margin: 0 }}>
        <legend className="d-label" style={{ marginBottom: 6 }}>この商品の評価</legend>
        <div style={{ display: 'flex', gap: 2, alignItems: 'center' }} onMouseLeave={() => setHover(0)}>
          {[1, 2, 3, 4, 5].map((n) => (
            <label key={n} style={{ cursor: 'pointer', lineHeight: 0 }} onMouseEnter={() => setHover(n)}>
              <input
                type="radio"
                name="rating"
                value={n}
                checked={rating === n}
                onChange={() => setRating(n)}
                className="sr-only"
                aria-label={`${n}点：${labels[n]}`}
              />
              <span style={{ color: n <= shown ? '#f5a623' : 'var(--border-strong)', display: 'inline-block', padding: 2 }}>
                <IconStar size={30} filled={n <= shown} />
              </span>
            </label>
          ))}
          <span style={{ marginLeft: 8, fontSize: 13.5, fontWeight: 700 }} aria-live="polite">
            {shown ? `${shown}.0 ${labels[shown]}` : '未評価'}
          </span>
        </div>
      </fieldset>

      <div style={{ border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: 12 }}>
        <div className="d-label" style={{ marginBottom: 6 }}>表示用（集計結果）</div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <span style={{ fontSize: 24, fontWeight: 800 }}>4.3</span>
          <span aria-hidden="true" style={{ color: '#f5a623', display: 'flex' }}>
            {[1, 2, 3, 4, 5].map((n) => <IconStar key={n} size={17} filled={n <= 4} />)}
          </span>
          <span style={{ fontSize: 12.5, color: 'var(--text-muted)' }}>1,284件の評価</span>
        </div>
      </div>
      <Note>件数の併記は必須。1件の5.0と1000件の4.3では意味が全く違います。入力側はラジオグループなのでキーボードでも選べます。</Note>
    </div>
  );
}

/* ----------------------------------------------------------------- pin-input */
export function PinInputDemo() {
  const LEN = 6;
  const [digits, setDigits] = useState(Array(LEN).fill(''));
  const refs = useRef([]);
  const [status, setStatus] = useState('');
  const code = digits.join('');

  useEffect(() => {
    if (code.length === LEN) {
      setStatus(code === '123456' ? 'ok' : 'ng');
    } else setStatus('');
  }, [code]);

  const setAt = (i, v) => {
    const next = [...digits];
    next[i] = v;
    setDigits(next);
  };

  return (
    <div className="d-stack">
      <div className="field">
        <span className="field__label">SMSで届いた6桁のコード（デモの正解: 123456）</span>
        <div style={{ display: 'flex', gap: 7 }} role="group" aria-label="6桁の認証コード">
          {digits.map((d, i) => (
            <input
              key={i}
              ref={(el) => (refs.current[i] = el)}
              className="input"
              type="text"
              inputMode="numeric"
              autoComplete={i === 0 ? 'one-time-code' : 'off'}
              maxLength={1}
              value={d}
              aria-label={`${LEN}桁のうち${i + 1}桁目`}
              onChange={(e) => {
                const v = e.target.value.replace(/\D/g, '');
                if (!v) { setAt(i, ''); return; }
                if (v.length > 1) { // ペースト対応
                  const chars = v.slice(0, LEN - i).split('');
                  const next = [...digits];
                  chars.forEach((ch, k) => { next[i + k] = ch; });
                  setDigits(next);
                  refs.current[Math.min(i + chars.length, LEN - 1)]?.focus();
                  return;
                }
                setAt(i, v);
                if (i < LEN - 1) refs.current[i + 1]?.focus();
              }}
              onKeyDown={(e) => {
                if (e.key === 'Backspace' && !digits[i] && i > 0) refs.current[i - 1]?.focus();
              }}
              onPaste={(e) => {
                const text = e.clipboardData.getData('text').replace(/\D/g, '').slice(0, LEN);
                if (!text) return;
                e.preventDefault();
                const next = Array(LEN).fill('');
                text.split('').forEach((ch, k) => { next[k] = ch; });
                setDigits(next);
                refs.current[Math.min(text.length, LEN - 1)]?.focus();
              }}
              style={{ width: 44, textAlign: 'center', fontSize: 19, fontWeight: 700, padding: '10px 0', borderColor: status === 'ng' ? 'var(--danger)' : undefined }}
            />
          ))}
        </div>
      </div>
      <div aria-live="polite">
        {status === 'ok' && <Out label="結果">✅ 認証に成功しました</Out>}
        {status === 'ng' && <div className="field__error" role="alert">コードが正しくありません。入力内容は消さずに残しています。</div>}
        {!status && <Out>6桁すべて入力すると自動で検証します（コードを丸ごとペーストしても動きます）</Out>}
      </div>
      <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
        <button className="btn btn--ghost btn--sm" onClick={() => { setDigits(Array(LEN).fill('')); refs.current[0]?.focus(); }}>入力し直す</button>
        <span style={{ fontSize: 12, color: 'var(--text-faint)' }}>コードは10分間有効です</span>
      </div>
      <Note>ペースト・自動入力（autocomplete="one-time-code"）・Backspaceでの前戻りの3点が実装できていれば合格です。</Note>
    </div>
  );
}
