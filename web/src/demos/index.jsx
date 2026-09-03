/**
 * コンポーネントID → デモコンポーネント のレジストリ。
 * data/components.json の id と 1:1 で対応する。
 */
import * as I from './input.jsx';
import * as N from './navigation.jsx';
import * as D from './display.jsx';
import * as O from './overlay.jsx';
import * as A from './action.jsx';
import * as M from './mobile.jsx';
import * as P from './pattern.jsx';

export const demos = {
  // 入力系
  'text-field': I.TextFieldDemo,
  'textarea': I.TextareaDemo,
  'checkbox': I.CheckboxDemo,
  'radio': I.RadioDemo,
  'toggle-switch': I.ToggleSwitchDemo,
  'slider': I.SliderDemo,
  'stepper-input': I.StepperInputDemo,
  'select': I.SelectDemo,
  'autocomplete': I.AutocompleteDemo,
  'date-time-picker': I.DateTimePickerDemo,
  'file-uploader': I.FileUploaderDemo,
  'search-bar': I.SearchBarDemo,
  'tag-input': I.TagInputDemo,
  'rating': I.RatingDemo,
  'pin-input': I.PinInputDemo,

  // ナビゲーション系
  'app-bar': N.AppBarDemo,
  'bottom-navigation': N.BottomNavigationDemo,
  'tab-bar': N.TabBarDemo,
  'drawer-sidebar': N.DrawerSidebarDemo,
  'hamburger-menu': N.HamburgerMenuDemo,
  'breadcrumbs': N.BreadcrumbsDemo,
  'pagination': N.PaginationDemo,
  'wizard-stepper': N.WizardStepperDemo,
  'fab': N.FabDemo,
  'segmented-control': N.SegmentedControlDemo,
  'command-palette': N.CommandPaletteDemo,

  // 情報表示系
  'card': D.CardDemo,
  'list': D.ListDemo,
  'table': D.TableDemo,
  'avatar': D.AvatarDemo,
  'badge': D.BadgeDemo,
  'chip': D.ChipDemo,
  'timeline': D.TimelineDemo,
  'accordion': D.AccordionDemo,
  'tooltip': D.TooltipDemo,
  'popover': D.PopoverDemo,
  'carousel': D.CarouselDemo,
  'empty-state': D.EmptyStateDemo,
  'skeleton': D.SkeletonDemo,
  'progress-indicator': D.ProgressIndicatorDemo,

  // オーバーレイ系
  'modal-dialog': O.ModalDialogDemo,
  'bottom-sheet': O.BottomSheetDemo,
  'action-sheet': O.ActionSheetDemo,
  'drawer-overlay': O.DrawerOverlayDemo,
  'toast-snackbar': O.ToastSnackbarDemo,
  'alert-banner': O.AlertBannerDemo,
  'context-menu': O.ContextMenuDemo,

  // アクション系
  'primary-button': A.PrimaryButtonDemo,
  'secondary-button': A.SecondaryButtonDemo,
  'ghost-button': A.GhostButtonDemo,
  'destructive-button': A.DestructiveButtonDemo,
  'link': A.LinkDemo,
  'icon-button': A.IconButtonDemo,
  'split-button': A.SplitButtonDemo,
  'copy-button': A.CopyButtonDemo,
  'share-button': A.ShareButtonDemo,

  // モバイル特有
  'pull-to-refresh': M.PullToRefreshDemo,
  'swipe-actions': M.SwipeActionsDemo,
  'infinite-scroll': M.InfiniteScrollDemo,
  'long-press': M.LongPressDemo,
  'safe-area': M.SafeAreaDemo,
  'haptics': M.HapticsDemo,

  // パターン系
  'onboarding': P.OnboardingDemo,
  'auth-form': P.AuthFormDemo,
  'search-and-filter': P.SearchAndFilterDemo,
  'sort': P.SortDemo,
  'undo': P.UndoDemo,
  'confirm-dialog': P.ConfirmDialogDemo,
  'validation-error': P.ValidationErrorDemo,
  'three-states': P.ThreeStatesDemo,
  'dark-mode-toggle': P.DarkModeToggleDemo,
  'permission-prompt': P.PermissionPromptDemo,
};
