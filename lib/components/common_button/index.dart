// @dart=2.9
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/components/common_loader/index.dart';
import 'package:tadah_flutter_components/components/touchable_opacity/index.dart';
import 'package:tadah_flutter_components/theme/app_widget_styles.dart';
import 'package:tadah_flutter_components/theme/theme/index.dart';

typedef CommonButtonElementBuilder = Widget Function(
  BuildContext,
  CommonButtonType type,
  Animation animation,
  Color color,
);

enum CommonButtonType {
  Primary,
  // Additional,
  // CommonDanger,
  Outlined,
  Contrast,
}

class CommonButton extends StatelessWidget {
  static const double _borderRadius = 8.0;

  factory CommonButton.withIcon(
    String text, {
    IconData icon,
    VoidCallback onPressed,
    CommonButtonType type = CommonButtonType.Primary,
    FontWeight fontWeight,
    double fontSize,
    bool wide = false,
  }) {
    return CommonButton(
      text,
      onPressed: onPressed,
      type: type,
      fontWeight: fontWeight,
      fontSize: fontSize,
      wide: wide,
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: 12,
        right: 32,
      ),
      prefixBuilder: (context, type, animation, color) => Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Icon(
          icon,
          color: color,
          size: AppWidgetStyles.commonIconSize,
        ),
      ),
    );
  }

  const CommonButton(
    this.text, {
    this.onPressed,
    this.type = CommonButtonType.Primary,
    this.fontWeight = FontWeight.w500,
    this.fontSize,
    this.wide = false,
    this.padding,
    this.prefixBuilder,
    this.suffixBuilder,
    this.loading = false,
  })  : assert(text != null && text != ""),
        assert(wide != null),
        assert(fontWeight != null),
        assert(loading != null);

  final String text;
  final VoidCallback onPressed;
  final CommonButtonType type;
  final FontWeight fontWeight;
  final double fontSize;
  final bool wide;
  final EdgeInsets padding;
  final CommonButtonElementBuilder prefixBuilder;
  final CommonButtonElementBuilder suffixBuilder;
  final bool loading;

  bool get disabled => onPressed == null;

  Color _backgroundColor(BuildContext context) {
    switch (type) {
      case CommonButtonType.Outlined:
        return AppTheme.of(context).transparent;
      // case CommonButtonType.Additional:
      //   return AppTheme.of(context).button.backgroundCommon;
      // case CommonButtonType.CommonDanger:
      //   return AppColors.DANGER_MAIN;
      case CommonButtonType.Contrast:
        return AppTheme.of(context).base;
      case CommonButtonType.Primary:
      default:
        return disabled && !loading
            ? AppTheme.of(context).button.backgroundDisabled
            : AppTheme.of(context).button.backgroundCommon;
    }
  }

  BorderSide _border(BuildContext context) {
    Color borderColor;

    switch (type) {
      case CommonButtonType.Outlined:
        borderColor = disabled && !loading
            ? AppTheme.of(context).button.borderDisabled
            : AppTheme.of(context).accentMain;
        break;
      case CommonButtonType.Primary:
      // case CommonButtonType.CommonDanger:
      default:
        borderColor = null;
    }

    return borderColor != null
        ? BorderSide(color: borderColor)
        : BorderSide.none;
  }

  Color _color(BuildContext context) {
    switch (type) {
      case CommonButtonType.Contrast:
      case CommonButtonType.Outlined:
        return disabled && !loading
            ? AppTheme.of(context).button.textDisabled
            : AppTheme.of(context).accentMain;
      // case CommonButtonType.Additional:
      // return AppTheme.of(context).accentMain;
      case CommonButtonType.Primary:
      // case  CommonButtonType.CommonDanger:
      default:
        return AppTheme.of(context).button.textOnFilled;
    }
  }

  bool _isLoaderInversed(BuildContext context) {
    switch (type) {
      case CommonButtonType.Contrast:
      case CommonButtonType.Outlined:
        return false;
      // case CommonButtonType.Additional:
      //   return AppTheme.of(context).accentMain;
      case CommonButtonType.Primary:
      // case  CommonButtonType.CommonDanger:
      default:
        return !disabled || loading;
    }
  }

  Widget _content(BuildContext context) {
    return Text(text, style: AppTheme.of(context).textStyles.body);
  }

  Widget _button(BuildContext context) {
    switch (type) {
      case CommonButtonType.Outlined:
      case CommonButtonType.Primary:
      // case CommonButtonType.CommonDanger:
      default:
        return TouchableOpacity(
          ghostTouch: true,
          behavior: HitTestBehavior.opaque,
          onTap: loading ? null : onPressed,
          child: Container(
            padding: padding != null
                ? padding
                : const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
            decoration: BoxDecoration(
              color: _backgroundColor(context),
              borderRadius: new BorderRadius.circular(_borderRadius),
              border: Border.fromBorderSide(_border(context)),
            ),
            child: Center(
              child: loading
                  ? CommonLoader(
                      size: AppTextStyles.bodyHeightBasicCalc,
                      inverse: _isLoaderInversed(context),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (prefixBuilder != null)
                          prefixBuilder(
                            context,
                            type,
                            null,
                            _color(context),
                          ),
                        Flexible(
                          flex: 1,
                          child: _content(context),
                        ),
                        if (suffixBuilder != null)
                          suffixBuilder(
                            context,
                            type,
                            null,
                            _color(context),
                          ),
                      ],
                    ),
            ),
          ),
        );
    }
  }

  Widget build(BuildContext context) {
    return wide ? _button(context) : FittedBox(child: _button(context));
  }
}
