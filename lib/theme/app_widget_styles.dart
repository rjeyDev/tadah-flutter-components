// @dart=2.9
import 'package:flutter/widgets.dart';

import 'app_colors.dart';
import 'theme/index.dart';

class AppWidgetStyles {
  AppWidgetStyles._();

  static const double commonHorizontalPaddingValue = 16.0;
  static const EdgeInsets commonHorizontalPadding =
      const EdgeInsets.symmetric(horizontal: commonHorizontalPaddingValue);

  static const double commonIconSize = 20.0;

  static const double commonDialogBorderRadiusValue = 4.0;
  static const Radius commonDialogBorderRadius =
      const Radius.circular(commonDialogBorderRadiusValue);

  static double _paddingTop;
  static double _paddingBottom;
  static double _paddingLeft;
  static double _paddingRight;

  static double _screenHeight;
  static double _screenWidth;

  static double _fontScaleFactor;

  static bool get isSmallScreen => _screenHeight < 800.0;

  static double get screenHeight => _screenHeight;

  static double get screenWidth => _screenWidth;

  static double get paddingTop => _paddingTop;

  static double get paddingLeft => _paddingLeft;

  static double get paddingRight => _paddingRight;

  static double get paddingBottom => _paddingBottom;

  static double get fontScaleFactor => _fontScaleFactor;

  static void defineData(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    _paddingTop = data.padding.top;
    _paddingBottom = data.padding.bottom;
    _paddingLeft = data.padding.left;
    _paddingRight = data.padding.right;
    _screenHeight = data.size.height;
    _screenWidth = data.size.width;
    _fontScaleFactor = data.textScaleFactor;
  }

  static double getResponsiveSize(double size) => size * _fontScaleFactor;

  static double getResponsiveHeight(double height) => getResponsiveSize(height);

  static double getResponsiveWidth(double width) => getResponsiveSize(width);

  static BoxShadow basicBoxShadow({
    Color color,
    Offset offset,
    double blurRadius,
    double spreadRadius,
  }) {
    Color _color = color ?? AppColors.BLACK_8;
    Offset _offset = offset ?? const Offset(0.0, 4.0);
    double _blurRadius = blurRadius ?? 24.0;
    double _spreadRadius = spreadRadius ?? 0.0;

    return BoxShadow(
      color: _color,
      offset: _offset,
      blurRadius: _blurRadius,
      spreadRadius: _spreadRadius,
    );
  }

  static List<BoxShadow> commonButtonShadow = [
    BoxShadow(
      color: AppColors.COMMON_BUTTON_SHADOW_54_LIGHT,
      offset: Offset(0, 8),
      blurRadius: 32,
    ),
  ];

  static List<BoxShadow> imageCardBoxShadow = [
    BoxShadow(
      color: AppColors.SHADOW_54_LIGHT,
      offset: Offset(0, 4),
      blurRadius: 24,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.SHADOW_16_LIGHT,
      offset: Offset(0, 2),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> cardBoxShadow = [
    BoxShadow(
      color: AppColors.SHADOW_16_LIGHT,
      offset: Offset(0, 8),
      blurRadius: 32,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.SHADOW_16_LIGHT,
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> dropdownBoxShadow = [
    BoxShadow(
      color: AppColors.SHADOW_24_LIGHT,
      offset: Offset(0, 4),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];
}
