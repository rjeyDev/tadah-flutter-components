// @dart=2.9
import 'package:tadah_flutter_components/theme/theme/index.dart';
import 'package:tadah_flutter_components/theme/theme/src/theme_data/border_theme_data.dart';
import 'package:tadah_flutter_components/theme/theme/src/theme_data/text_style_theme_data.dart';

import '../app_colors.dart';

const AppThemeData themeDarkCommon = const AppThemeData(
  type: AppThemeType.Dark,
  accentMain: AppColors.BLUE_VIOLET_500,
  transparent: AppColors.TRANSPARENT_LIGHT,
  transparentPure: AppColors.TRANSPARENT,
  base: AppColors.WHITE,
  contrast: AppColors.TEXT_PRIMARY_DARK,
  text: AppTextThemeData(
    primary: AppColors.TEXT_PRIMARY_LIGHT,
    secondary: AppColors.TEXT_SECONDARY_LIGHT,
    placeholder: AppColors.TEXT_SECONDARY_LIGHT,
    disabled: AppColors.TEXT_DISABLED_LIGHT,
    onAccent: AppColors.WHITE,
  ),
  textStyles: AppTextStylesThemeData(
    h1: AppTextStyles.H1,
    h2: AppTextStyles.H2,
    h3: AppTextStyles.H3,
    h4: AppTextStyles.H4,
    h5: AppTextStyles.H5,
    h6: AppTextStyles.H6,
    body: AppTextStyles.BODY,
    bodyMoreText: AppTextStyles.BODY_MORE_TEXT,
    secondary: AppTextStyles.SECONDARY,
    secondaryMoreText: AppTextStyles.SECONDARY_MORE_TEXT,
    note: AppTextStyles.NOTE,
    noteAccent: AppTextStyles.NOTE_ACCENT,
  ),
  background: AppBackgroundThemeData(
    main: AppColors.BACKGROUND_MAIN_LIGHT,
    cardCommon: AppColors.BACKGROUND_CARD_COMMON_LIGHT,
    toast: AppColors.BACKGROUND_TOAST_LIGHT,
  ),
  button: AppButtonThemeData(
    backgroundCommon: AppColors.BUTTON_BACKGROUND_COMMON_LIGHT,
    backgroundDisabled: AppColors.BACKGROUND_BUTTON_DISABLED_LIGHT,
    borderDisabled: AppColors.TEXT_DISABLED_LIGHT,
    textOnFilled: AppColors.WHITE,
    textDisabled: AppColors.TEXT_DISABLED_LIGHT,
  ),
  border: AppBorderThemeData(
    inputUnderlined: AppColors.BORDER_INPUT_UNDERLINED_LIGHT,
    inputDisabledUnderlined: AppColors.BORDER_INPUT_DISABLED_UNDERLINED_LIGHT,
    commonUnderline: AppColors.BORDER_COMMON_UNDERLINED_LIGHT,
  ),
  // TODO-change separate color
  chatLoader: AppColors.BACKGROUND_TOAST_LIGHT,
);


// const AppThemeData themeDarkCommon = const AppThemeData(
//   type: AppThemeType.Dark,
//   accentMain: AppColors.BLUE_VIOLET_500,
//   transparent: AppColors.TRANSPARENT_DARK,
//   transparentPure: AppColors.TRANSPARENT,
//   base: AppColors.TEXT_PRIMARY_DARK,
//   contrast: AppColors.WHITE,
//   text: AppTextThemeData(
//     primary: AppColors.TEXT_PRIMARY_DARK,
//     secondary: AppColors.TEXT_SECONDARY_DARK,
//     placeholder: AppColors.TEXT_SECONDARY_DARK,
//     disabled: AppColors.TEXT_DISABLED_DARK,
//     onAccent: AppColors.WHITE,
//   ),
//   textStyles: AppTextStylesThemeData(
//     h1: AppTextStyles.H1,
//     h2: AppTextStyles.H2,
//     h3: AppTextStyles.H3,
//     h4: AppTextStyles.H4,
//     h5: AppTextStyles.H5,
//     h6: AppTextStyles.H6,
//     body: AppTextStyles.BODY,
//     bodyMoreText: AppTextStyles.BODY_MORE_TEXT,
//     secondary: AppTextStyles.SECONDARY,
//     secondaryMoreText: AppTextStyles.SECONDARY_MORE_TEXT,
//     note: AppTextStyles.NOTE,
//     noteAccent: AppTextStyles.NOTE_ACCENT,
//   ),
//   background: AppBackgroundThemeData(
//     main: AppColors.BACKGROUND_MAIN_DARK,
//     cardCommon: AppColors.BACKGROUND_CARD_COMMON_DARK,
//     toast: AppColors.BACKGROUND_TOAST_DARK,
//   ),
//   button: AppButtonThemeData(
//     backgroundCommon: AppColors.BUTTON_BACKGROUND_COMMON_DARK,
//     backgroundDisabled: AppColors.BACKGROUND_BUTTON_DISABLED_LIGHT,
//     borderDisabled: AppColors.TEXT_DISABLED_DARK,
//     textOnFilled: AppColors.WHITE,
//     textDisabled: AppColors.TEXT_DISABLED_DARK,
//   ),
//   border: AppBorderThemeData(
//     inputUnderlined: AppColors.BORDER_INPUT_UNDERLINED_DARK,
//     inputDisabledUnderlined: AppColors.BORDER_INPUT_DISABLED_UNDERLINED_DARK,
//     commonUnderline: AppColors.BORDER_COMMON_UNDERLINED_DARK,
//   ),
//   chatLoader: AppColors.BACKGROUND_TOAST_DARK,
// );
