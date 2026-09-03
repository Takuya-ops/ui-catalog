import 'package:flutter/material.dart';

import 'action_demos.dart';
import 'display_demos.dart';
import 'input_demos.dart';
import 'mobile_demos.dart';
import 'navigation_demos.dart';
import 'overlay_demos.dart';
import 'pattern_demos.dart';

/// コンポーネントID → デモウィジェット のレジストリ。
/// data/components.json の id と 1:1 で対応する（Web版 web/src/demos/index.jsx と同じ構成）。
class DemoRegistry {
  static final Map<String, WidgetBuilder> _builders = <String, WidgetBuilder>{
    // 入力系
    'text-field': (_) => const TextFieldDemo(),
    'textarea': (_) => const TextareaDemo(),
    'checkbox': (_) => const CheckboxDemo(),
    'radio': (_) => const RadioDemo(),
    'toggle-switch': (_) => const ToggleSwitchDemo(),
    'slider': (_) => const SliderDemo(),
    'stepper-input': (_) => const StepperInputDemo(),
    'select': (_) => const SelectDemo(),
    'autocomplete': (_) => const AutocompleteDemo(),
    'date-time-picker': (_) => const DateTimePickerDemo(),
    'file-uploader': (_) => const FileUploaderDemo(),
    'search-bar': (_) => const SearchBarDemo(),
    'tag-input': (_) => const TagInputDemo(),
    'rating': (_) => const RatingDemo(),
    'pin-input': (_) => const PinInputDemo(),

    // ナビゲーション系
    'app-bar': (_) => const AppBarDemo(),
    'bottom-navigation': (_) => const BottomNavigationDemo(),
    'tab-bar': (_) => const TabBarDemo(),
    'drawer-sidebar': (_) => const DrawerSidebarDemo(),
    'hamburger-menu': (_) => const HamburgerMenuDemo(),
    'breadcrumbs': (_) => const BreadcrumbsDemo(),
    'pagination': (_) => const PaginationDemo(),
    'wizard-stepper': (_) => const WizardStepperDemo(),
    'fab': (_) => const FabDemo(),
    'segmented-control': (_) => const SegmentedControlDemo(),
    'command-palette': (_) => const CommandPaletteDemo(),

    // 情報表示系
    'card': (_) => const CardDemo(),
    'list': (_) => const ListDemo(),
    'table': (_) => const TableDemo(),
    'avatar': (_) => const AvatarDemo(),
    'badge': (_) => const BadgeDemo(),
    'chip': (_) => const ChipDemo(),
    'timeline': (_) => const TimelineDemo(),
    'accordion': (_) => const AccordionDemo(),
    'tooltip': (_) => const TooltipDemo(),
    'popover': (_) => const PopoverDemo(),
    'carousel': (_) => const CarouselDemo(),
    'empty-state': (_) => const EmptyStateDemo(),
    'skeleton': (_) => const SkeletonDemo(),
    'progress-indicator': (_) => const ProgressIndicatorDemo(),

    // オーバーレイ系
    'modal-dialog': (_) => const ModalDialogDemo(),
    'bottom-sheet': (_) => const BottomSheetDemo(),
    'action-sheet': (_) => const ActionSheetDemo(),
    'drawer-overlay': (_) => const DrawerOverlayDemo(),
    'toast-snackbar': (_) => const ToastSnackbarDemo(),
    'alert-banner': (_) => const AlertBannerDemo(),
    'context-menu': (_) => const ContextMenuDemo(),

    // アクション系
    'primary-button': (_) => const PrimaryButtonDemo(),
    'secondary-button': (_) => const SecondaryButtonDemo(),
    'ghost-button': (_) => const GhostButtonDemo(),
    'destructive-button': (_) => const DestructiveButtonDemo(),
    'link': (_) => const LinkDemo(),
    'icon-button': (_) => const IconButtonDemo(),
    'split-button': (_) => const SplitButtonDemo(),
    'copy-button': (_) => const CopyButtonDemo(),
    'share-button': (_) => const ShareButtonDemo(),

    // ジェスチャー・モバイル特有
    'pull-to-refresh': (_) => const PullToRefreshDemo(),
    'swipe-actions': (_) => const SwipeActionsDemo(),
    'infinite-scroll': (_) => const InfiniteScrollDemo(),
    'long-press': (_) => const LongPressDemo(),
    'safe-area': (_) => const SafeAreaDemo(),
    'haptics': (_) => const HapticsDemo(),

    // パターン系
    'onboarding': (_) => const OnboardingDemo(),
    'auth-form': (_) => const AuthFormDemo(),
    'search-and-filter': (_) => const SearchAndFilterDemo(),
    'sort': (_) => const SortDemo(),
    'undo': (_) => const UndoDemo(),
    'confirm-dialog': (_) => const ConfirmDialogDemo(),
    'validation-error': (_) => const ValidationErrorDemo(),
    'three-states': (_) => const ThreeStatesDemo(),
    'dark-mode-toggle': (_) => const DarkModeToggleDemo(),
    'permission-prompt': (_) => const PermissionPromptDemo(),
  };

  /// デモがなければ null を返す（詳細画面側で「準備中」を表示する）
  static Widget? build(String componentId) {
    final WidgetBuilder? builder = _builders[componentId];
    if (builder == null) return null;
    return Builder(builder: builder);
  }

  static int get count => _builders.length;
  static Iterable<String> get ids => _builders.keys;
}
