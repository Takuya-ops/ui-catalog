/** 依存を増やさないための最小アイコンセット（すべて aria-hidden の装飾） */
const S = ({ children, size = 20, ...rest }) => (
  <svg
    width={size}
    height={size}
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="1.8"
    strokeLinecap="round"
    strokeLinejoin="round"
    aria-hidden="true"
    {...rest}
  >
    {children}
  </svg>
);

export const IconSearch = (p) => (<S {...p}><circle cx="11" cy="11" r="7" /><path d="m20 20-3.2-3.2" /></S>);
export const IconMenu = (p) => (<S {...p}><path d="M3 6h18M3 12h18M3 18h18" /></S>);
export const IconClose = (p) => (<S {...p}><path d="M18 6 6 18M6 6l12 12" /></S>);
export const IconChevronRight = (p) => (<S {...p}><path d="m9 18 6-6-6-6" /></S>);
export const IconChevronLeft = (p) => (<S {...p}><path d="m15 18-6-6 6-6" /></S>);
export const IconChevronDown = (p) => (<S {...p}><path d="m6 9 6 6 6-6" /></S>);
export const IconHome = (p) => (<S {...p}><path d="M3 10.5 12 3l9 7.5" /><path d="M5.5 9.5V20h13V9.5" /></S>);
export const IconGrid = (p) => (<S {...p}><rect x="3" y="3" width="7" height="7" rx="1.5" /><rect x="14" y="3" width="7" height="7" rx="1.5" /><rect x="3" y="14" width="7" height="7" rx="1.5" /><rect x="14" y="14" width="7" height="7" rx="1.5" /></S>);
export const IconSun = (p) => (<S {...p}><circle cx="12" cy="12" r="4" /><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4" /></S>);
export const IconMoon = (p) => (<S {...p}><path d="M21 13.2A8.5 8.5 0 1 1 10.8 3a6.8 6.8 0 0 0 10.2 10.2Z" /></S>);
export const IconAuto = (p) => (<S {...p}><circle cx="12" cy="12" r="9" /><path d="M12 3v18" /><path d="M12 3a9 9 0 0 1 0 18" fill="currentColor" stroke="none" /></S>);
export const IconCheck = (p) => (<S {...p}><path d="m4 12.5 5 5L20 6.5" /></S>);
export const IconInfo = (p) => (<S {...p}><circle cx="12" cy="12" r="9" /><path d="M12 11v5M12 7.6v.01" /></S>);
export const IconAlert = (p) => (<S {...p}><path d="M12 4.5 2.8 20h18.4L12 4.5Z" /><path d="M12 10v4M12 17.2v.01" /></S>);
export const IconBook = (p) => (<S {...p}><path d="M4 4.5h9a3 3 0 0 1 3 3V20a2.5 2.5 0 0 0-2.5-2.5H4Z" /><path d="M20 4.5h-1.5a3 3 0 0 0-3 3V20a2.5 2.5 0 0 1 2.5-2.5H20Z" /></S>);
export const IconSparkle = (p) => (<S {...p}><path d="M12 3.5 13.8 9l5.7 1.8-5.7 1.8L12 18.2 10.2 12.6 4.5 10.8 10.2 9 12 3.5Z" /></S>);
export const IconCopy = (p) => (<S {...p}><rect x="9" y="9" width="11" height="11" rx="2" /><path d="M5 15H4.5A1.5 1.5 0 0 1 3 13.5V5a2 2 0 0 1 2-2h8.5A1.5 1.5 0 0 1 15 4.5V5" /></S>);
export const IconShare = (p) => (<S {...p}><path d="M12 15V3.5M12 3.5 8.2 7.3M12 3.5l3.8 3.8" /><path d="M5 13v6.5A1.5 1.5 0 0 0 6.5 21h11a1.5 1.5 0 0 0 1.5-1.5V13" /></S>);
export const IconTrash = (p) => (<S {...p}><path d="M4 7h16M9 7V5h6v2M6.5 7l.8 13h9.4l.8-13" /></S>);
export const IconStar = ({ filled, ...p }) => (
  <S {...p}><path d="m12 4 2.4 5 5.5.8-4 3.9.9 5.5-4.8-2.6-4.8 2.6.9-5.5-4-3.9 5.5-.8L12 4Z" fill={filled ? 'currentColor' : 'none'} /></S>
);
export const IconHeart = ({ filled, ...p }) => (
  <S {...p}><path d="M12 20s-7.5-4.6-7.5-9.4A4.1 4.1 0 0 1 12 7.6a4.1 4.1 0 0 1 7.5 3C19.5 15.4 12 20 12 20Z" fill={filled ? 'currentColor' : 'none'} /></S>
);
export const IconRefresh = (p) => (<S {...p}><path d="M20 12a8 8 0 1 1-2.4-5.7" /><path d="M20 4v4.5h-4.5" /></S>);
export const IconPlus = (p) => (<S {...p}><path d="M12 5v14M5 12h14" /></S>);
export const IconMinus = (p) => (<S {...p}><path d="M5 12h14" /></S>);
export const IconMore = (p) => (<S {...p}><circle cx="12" cy="5" r="1.4" fill="currentColor" /><circle cx="12" cy="12" r="1.4" fill="currentColor" /><circle cx="12" cy="19" r="1.4" fill="currentColor" /></S>);
export const IconBell = (p) => (<S {...p}><path d="M6.5 10a5.5 5.5 0 0 1 11 0c0 4 1.5 5.5 1.5 5.5H5S6.5 14 6.5 10Z" /><path d="M10 19a2 2 0 0 0 4 0" /></S>);
export const IconUser = (p) => (<S {...p}><circle cx="12" cy="8.5" r="3.5" /><path d="M4.5 20a7.5 7.5 0 0 1 15 0" /></S>);
export const IconFilter = (p) => (<S {...p}><path d="M4 5h16l-6.2 7.4V20l-3.6-2v-5.6L4 5Z" /></S>);
export const IconCalendar = (p) => (<S {...p}><rect x="3.5" y="5" width="17" height="15.5" rx="2" /><path d="M3.5 9.5h17M8 3.5V6M16 3.5V6" /></S>);
export const IconUpload = (p) => (<S {...p}><path d="M12 16V4.5M12 4.5 8 8.6M12 4.5l4 4.1" /><path d="M4.5 15v3.5A1.5 1.5 0 0 0 6 20h12a1.5 1.5 0 0 0 1.5-1.5V15" /></S>);
export const IconExternal = (p) => (<S {...p}><path d="M14 4h6v6M20 4l-8.5 8.5" /><path d="M18 14v5a1.5 1.5 0 0 1-1.5 1.5H5.5A1.5 1.5 0 0 1 4 19V7.5A1.5 1.5 0 0 1 5.5 6H10" /></S>);
export const IconCode = (p) => (<S {...p}><path d="m9 8-5 4 5 4M15 8l5 4-5 4" /></S>);
export const IconAccessibility = (p) => (<S {...p}><circle cx="12" cy="4.6" r="1.6" /><path d="M4.5 8.5h15M12 8.5v6M12 14.5 9 20.5M12 14.5l3 6" /></S>);
