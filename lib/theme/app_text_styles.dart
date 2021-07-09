// @dart=2.9
import 'package:flutter/widgets.dart';

import 'app_colors.dart';
import 'theme/src/theme.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String mainFontFamily = "Source Sans Pro";

  static const double basicLetterSpacing = 0.0;
  static const double basicLineHeight = 1.2;
  static const double readingLineHeight = 1.8;
  static const FontWeight basicFontWeight = FontWeight.w400;
  static const FontWeight headerFontWeight = FontWeight.w700;
  static const FontWeight headerFontWeightSmall = FontWeight.w600;

  static const double header1FontSize = 60.0;
  static const double header2FontSize = 48.0;
  static const double header3FontSize = 34.0;
  static const double header4FontSize = 24.0;
  static const double header5FontSize = 20.0;
  static const double header6FontSize = 16.0;

  static const double subtitleFontSize = 30.0;
  static const double bodyFontSize = 20.0;
  static const double secondaryFontSize = 16.0;
  static const double noteFontSize = 12.0;

  static const double inputFontSize = 12.0;

  // CALC
  static const double header1HeightBasicCalc =
      header1FontSize * basicLineHeight;
  static const double header2HeightBasicCalc =
      header2FontSize * basicLineHeight;
  static const double header3HeightBasicCalc =
      header4FontSize * basicLineHeight;
  static const double header4HeightBasicCalc =
      header4FontSize * basicLineHeight;

  static const double subtitleHeightBasicCalc =
      subtitleFontSize * basicLineHeight;
  static const double bodyHeightBasicCalc = bodyFontSize * basicLineHeight;
  static const double secondaryHeightBasicCalc =
      secondaryFontSize * basicLineHeight;
  static const double noteHeightBasicCalc = noteFontSize * basicLineHeight;

  static const double inputHeightBasicCalc = inputFontSize * basicLineHeight;

  static const TextStyle H1 = TextStyle(
    color: AppColors.TEXT_PRIMARY_DARK,
    fontFamily: mainFontFamily,
    fontSize: header1FontSize,
    fontWeight: headerFontWeight,
    letterSpacing: basicLetterSpacing,
    decoration: TextDecoration.none,
    height: basicLineHeight,
  );

  static const TextStyle H2 = TextStyle(
    color: AppColors.TEXT_PRIMARY_DARK,
    fontFamily: mainFontFamily,
    fontSize: header2FontSize,
    fontWeight: headerFontWeight,
    letterSpacing: basicLetterSpacing,
    decoration: TextDecoration.none,
    height: basicLineHeight,
  );

  static const TextStyle H3 = TextStyle(
    color: AppColors.TEXT_PRIMARY_DARK,
    fontFamily: mainFontFamily,
    fontSize: header3FontSize,
    fontWeight: headerFontWeight,
    letterSpacing: basicLetterSpacing,
    decoration: TextDecoration.none,
    height: basicLineHeight,
  );

  static const TextStyle H4 = TextStyle(
    color: AppColors.TEXT_PRIMARY_DARK,
    fontFamily: mainFontFamily,
    fontSize: header4FontSize,
    fontWeight: headerFontWeight,
    letterSpacing: basicLetterSpacing,
    decoration: TextDecoration.none,
    height: basicLineHeight,
  );

  static const TextStyle H5 = TextStyle(
    color: AppColors.TEXT_PRIMARY_DARK,
    fontFamily: mainFontFamily,
    fontSize: header5FontSize,
    fontWeight: headerFontWeight,
    letterSpacing: basicLetterSpacing,
    decoration: TextDecoration.none,
    height: basicLineHeight,
  );

  static const TextStyle H6 = TextStyle(
    color: AppColors.TEXT_PRIMARY_DARK,
    fontFamily: mainFontFamily,
    fontSize: header6FontSize,
    fontWeight: headerFontWeightSmall,
    letterSpacing: basicLetterSpacing,
    decoration: TextDecoration.none,
    height: basicLineHeight,
  );

  static const TextStyle SUBTITLE = TextStyle(
    color: AppColors.TEXT_PRIMARY_DARK,
    fontFamily: mainFontFamily,
    fontSize: subtitleFontSize,
    fontWeight: headerFontWeightSmall,
    letterSpacing: basicLetterSpacing,
    decoration: TextDecoration.none,
    height: basicLineHeight,
  );
  static const TextStyle BODY = TextStyle(
    color: AppColors.TEXT_PRIMARY_DARK,
    fontFamily: mainFontFamily,
    fontSize: bodyFontSize,
    fontWeight: basicFontWeight,
    letterSpacing: basicLetterSpacing,
    decoration: TextDecoration.none,
    height: basicLineHeight,
  );
  static const TextStyle BODY_MORE_TEXT = TextStyle(
    color: AppColors.TEXT_PRIMARY_DARK,
    fontFamily: mainFontFamily,
    fontSize: bodyFontSize,
    fontWeight: basicFontWeight,
    letterSpacing: basicLetterSpacing,
    decoration: TextDecoration.none,
    height: readingLineHeight,
  );

  static const TextStyle SECONDARY = TextStyle(
    color: AppColors.TEXT_PRIMARY_DARK,
    fontFamily: mainFontFamily,
    fontSize: secondaryFontSize,
    fontWeight: basicFontWeight,
    letterSpacing: basicLetterSpacing,
    decoration: TextDecoration.none,
    height: basicLineHeight,
  );

  static const TextStyle SECONDARY_MORE_TEXT = TextStyle(
    color: AppColors.TEXT_PRIMARY_DARK,
    fontFamily: mainFontFamily,
    fontSize: secondaryFontSize,
    fontWeight: basicFontWeight,
    letterSpacing: basicLetterSpacing,
    decoration: TextDecoration.none,
    height: readingLineHeight,
  );

  static const TextStyle NOTE = TextStyle(
    color: AppColors.TEXT_PRIMARY_DARK,
    fontFamily: mainFontFamily,
    fontSize: noteFontSize,
    fontWeight: basicFontWeight,
    letterSpacing: basicLetterSpacing,
    decoration: TextDecoration.none,
    height: basicLineHeight,
  );

  static const TextStyle NOTE_ACCENT = TextStyle(
    color: AppColors.TEXT_PRIMARY_DARK,
    fontFamily: mainFontFamily,
    fontSize: noteFontSize,
    fontWeight: headerFontWeightSmall,
    letterSpacing: basicLetterSpacing,
    decoration: TextDecoration.none,
    height: basicLineHeight,
  );

  static TextStyle styleFrom({
    TextStyles style,
    Color color,
    BuildContext context,
    String fontFamily,
    FontWeight fontWeight,
    double fontSize,
    double letterSpacing,
    double height,
    TextDecoration decoration,
  }) {
    assert(color != null || context != null);
    TextStyles _style = style ?? TextStyles.BODY;
    Color _color = color ?? AppTheme.of(context).text.primary;
    double _fontSize = fontSize ?? _style.fontSize;
    FontWeight _fontWeight = fontWeight ?? _style.fontWeight;
    double _letterSpacing = letterSpacing ?? basicLetterSpacing;
    double _height = height ?? _style.lineHeight;
    TextDecoration _decoration = decoration ?? TextDecoration.none;

    return TextStyle(
      color: _color,
      fontFamily: mainFontFamily,
      fontSize: _fontSize,
      fontWeight: _fontWeight,
      letterSpacing: _letterSpacing,
      decoration: _decoration,
      height: _height,
    );
  }
}

enum TextStyles {
  H1,
  H2,
  H3,
  H4,
  H5,
  H6,
  SUBTITLE,
  BODY,
  BODY_MORE_TEXT,
  SECONDARY,
  SECONDARY_MORE_TEXT,
  NOTE,
  NOTE_ACCENT,
}

extension TextStylesExtension on TextStyles {
  double get fontSize {
    switch (this) {
      case TextStyles.H1:
        return AppTextStyles.header1FontSize;
      case TextStyles.H2:
        return AppTextStyles.header2FontSize;
      case TextStyles.H3:
        return AppTextStyles.header3FontSize;
      case TextStyles.H4:
        return AppTextStyles.header4FontSize;
      case TextStyles.H5:
        return AppTextStyles.header5FontSize;
      case TextStyles.H6:
        return AppTextStyles.header6FontSize;
      case TextStyles.SUBTITLE:
        return AppTextStyles.subtitleFontSize;
      case TextStyles.BODY:
        return AppTextStyles.bodyFontSize;
      case TextStyles.BODY_MORE_TEXT:
        return AppTextStyles.bodyFontSize;
      case TextStyles.SECONDARY:
        return AppTextStyles.secondaryFontSize;
      case TextStyles.SECONDARY_MORE_TEXT:
        return AppTextStyles.secondaryFontSize;
      case TextStyles.NOTE:
        return AppTextStyles.noteFontSize;
      case TextStyles.NOTE_ACCENT:
        return AppTextStyles.noteFontSize;
      default:
        return AppTextStyles.bodyFontSize;
    }
  }

  FontWeight get fontWeight {
    switch (this) {
      case TextStyles.H1:
        return AppTextStyles.headerFontWeight;
      case TextStyles.H2:
        return AppTextStyles.headerFontWeight;
      case TextStyles.H3:
        return AppTextStyles.headerFontWeight;
      case TextStyles.H4:
        return AppTextStyles.headerFontWeight;
      case TextStyles.H5:
        return AppTextStyles.headerFontWeight;
      case TextStyles.H6:
        return AppTextStyles.headerFontWeightSmall;
      case TextStyles.SUBTITLE:
        return AppTextStyles.headerFontWeightSmall;
      case TextStyles.BODY:
        return AppTextStyles.basicFontWeight;
      case TextStyles.BODY_MORE_TEXT:
        return AppTextStyles.basicFontWeight;
      case TextStyles.SECONDARY:
        return AppTextStyles.basicFontWeight;
      case TextStyles.SECONDARY_MORE_TEXT:
        return AppTextStyles.basicFontWeight;
      case TextStyles.NOTE:
        return AppTextStyles.basicFontWeight;
      case TextStyles.NOTE_ACCENT:
        return AppTextStyles.headerFontWeightSmall;
      default:
        return AppTextStyles.basicFontWeight;
    }
  }

  double get lineHeight {
    switch (this) {
      case TextStyles.H1:
      case TextStyles.H2:
      case TextStyles.H3:
      case TextStyles.H4:
      case TextStyles.H5:
      case TextStyles.H6:
      case TextStyles.SUBTITLE:
      case TextStyles.BODY:
      case TextStyles.SECONDARY:
      case TextStyles.NOTE:
      case TextStyles.NOTE_ACCENT:
        return AppTextStyles.basicLineHeight;
      case TextStyles.BODY_MORE_TEXT:
      case TextStyles.SECONDARY_MORE_TEXT:
        return AppTextStyles.readingLineHeight;
      default:
        return AppTextStyles.basicLineHeight;
    }
  }
}
