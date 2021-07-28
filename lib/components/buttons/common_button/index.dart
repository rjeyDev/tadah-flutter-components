// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tadah_flutter_components/components/buttons/common_loader/index.dart';
import 'package:tadah_flutter_components/theme/app_colors.dart';
import 'package:tadah_flutter_components/theme/app_text_styles.dart';
import 'package:tadah_flutter_components/theme/app_widget_styles.dart';
import 'package:tadah_flutter_components/theme/theme/src/theme.dart';

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

enum CommonButtonSize {
  Small,
  Medium,
  Large,
}

enum IconPosition {
  Left,
  Right,
}

class CommonButton extends StatefulWidget {
  static const double _borderRadius = 80;

  factory CommonButton.withIcon(
    String text, {
    FocusNode focusNode,
    bool autoFocus = false,
    IconData icon,
    IconPosition iconPosition = IconPosition.Left,
    VoidCallback onPressed,
    bool loading = false,
    CommonButtonType type = CommonButtonType.Primary,
    CommonButtonSize size = CommonButtonSize.Medium,
    FontWeight fontWeight,
    double fontSize,
    bool wide = false,
  }) {
    return CommonButton(
      text,
      focusNode: focusNode,
      autoFocus: autoFocus,
      onPressed: onPressed,
      type: type,
      size: size,
      loading: loading,
      fontWeight: fontWeight,
      fontSize: fontSize,
      wide: wide,
      prefixBuilder: iconPosition == IconPosition.Left
          ? (context, type, animation, color) => Padding(
                padding: EdgeInsets.only(
                    right: size == CommonButtonSize.Small ? 4 : 8),
                child: Icon(
                  icon,
                  color: color,
                  size: size == CommonButtonSize.Small
                      ? 12
                      : AppWidgetStyles.commonIconSize,
                ),
              )
          : null,
      suffixBuilder: iconPosition == IconPosition.Right
          ? (context, type, animation, color) => Padding(
                padding: EdgeInsets.only(
                    left: size == CommonButtonSize.Small ? 4 : 8),
                child: Icon(
                  icon,
                  color: color,
                  size: size == CommonButtonSize.Small
                      ? 12
                      : AppWidgetStyles.commonIconSize,
                ),
              )
          : null,
    );
  }

  const CommonButton(
    this.text, {
    this.focusNode,
    this.autoFocus = false,
    this.onPressed,
    this.type = CommonButtonType.Primary,
    this.size = CommonButtonSize.Medium,
    this.fontWeight,
    this.fontSize,
    this.wide = false,
    this.padding,
    this.prefixBuilder,
    this.suffixBuilder,
    this.loading = false,
  })  : assert(text != null && text != ""),
        assert(wide != null),
        assert(loading != null);

  final String text;
  final FocusNode focusNode;
  final bool autoFocus;
  final VoidCallback onPressed;
  final CommonButtonType type;
  final CommonButtonSize size;
  final FontWeight fontWeight;
  final double fontSize;
  final bool wide;
  final EdgeInsets padding;
  final CommonButtonElementBuilder prefixBuilder;
  final CommonButtonElementBuilder suffixBuilder;
  final bool loading;

  @override
  _CommonButtonState createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  bool get disabled => widget.onPressed == null;
  bool pressed = false;
  bool focused = false;
  bool hovered = false;

  Color _backgroundColor(BuildContext context) {
    switch (widget.type) {
      case CommonButtonType.Outlined:
        return AppTheme.of(context).transparent;
      // case CommonButtonType.Additional:
      //   return AppTheme.of(context).button.backgroundCommon;
      // case CommonButtonType.CommonDanger:
      //   return AppColors.DANGER_MAIN;
      case CommonButtonType.Contrast:
        return AppTheme.of(context).transparent;
      case CommonButtonType.Primary:
      default:
        return disabled && !widget.loading
            ? AppTheme.of(context).button.backgroundDisabled
            : AppTheme.of(context).button.backgroundCommon;
    }
  }

  bool _isLoaderInversed(BuildContext context) {
    switch (widget.type) {
      case CommonButtonType.Contrast:
      case CommonButtonType.Outlined:
        return false;
      // case CommonButtonType.Additional:
      //   return AppTheme.of(context).accentMain;
      case CommonButtonType.Primary:
      // case  CommonButtonType.CommonDanger:
      default:
        return !disabled || widget.loading;
    }
  }

  BorderSide _border(BuildContext context) {
    Color borderColor;

    switch (widget.type) {
      case CommonButtonType.Outlined:
        borderColor = disabled && !widget.loading
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
    if (disabled && !widget.loading)
      return AppTheme.of(context).button.textDisabled;
    switch (widget.type) {
      case CommonButtonType.Contrast:
      case CommonButtonType.Outlined:
        return disabled && !widget.loading
            ? AppTheme.of(context).button.textDisabled
            : AppTheme.of(context).accentMain;
      // case CommonButtonType.Additional:
      //   return AppTheme.of(context).accentMain;
      case CommonButtonType.Primary:
      // case  CommonButtonType.CommonDanger:
      default:
        return AppTheme.of(context).button.textOnFilled;
    }
  }

  double _fontSize(context) {
    if (widget.fontSize != null) return widget.fontSize;
    switch (widget.size) {
      case CommonButtonSize.Small:
        return AppTextStyles.noteFontSize;
      case CommonButtonSize.Medium:
        return AppTextStyles.secondaryFontSize;
        break;
      case CommonButtonSize.Large:
      default:
        return AppTextStyles.bodyFontSize;
    }
  }

  FontWeight _fontWeight(context) {
    return widget.fontWeight ?? widget.size == CommonButtonSize.Small
        ? FontWeight.w600
        : FontWeight.w400;
  }

  EdgeInsets _contentPadding(context) {
    if (widget.padding != null) return widget.padding;
    switch (widget.size) {
      case CommonButtonSize.Small:
        return EdgeInsets.only(top: 8, bottom: 8, right: 12, left: 12);
        break;
      case CommonButtonSize.Medium:
        return EdgeInsets.only(top: 8, bottom: 10, right: 16, left: 16);
        break;
      case CommonButtonSize.Large:
      default:
        return EdgeInsets.only(top: 10, bottom: 12, right: 20, left: 20);
        break;
    }
  }

  Widget _content(BuildContext context) {
    return Text(
      widget.text,
      style: AppTextStyles.styleFrom(
        context: context,
        style: TextStyles.SECONDARY,
        fontWeight: _fontWeight(context),
        fontSize: _fontSize(context),
        color: _color(context),
      ),
    );
    // Text(widget.text, style: AppTheme.of(context).textStyles.secondary);
    // AppTypography.body(
    //   text,
    //   context: context,
    //   color: _color(context),
    //   fontWeight: fontWeight,
    //   overflow: TextOverflow.ellipsis,
    // );
  }

  Color _overlayColor(context) {
    if (widget.loading || disabled) return AppColors.TRANSPARENT;
    switch (widget.type) {
      case CommonButtonType.Outlined:
      case CommonButtonType.Contrast:
        return hovered
            ? AppColors.BLUE_VIOLET_500_8
            : focused
                ? AppColors.BLUE_VIOLET_500_16
                : (pressed)
                    ? AppColors.BLUE_VIOLET_500_24
                    : AppColors.TRANSPARENT;
        break;
      case CommonButtonType.Primary:
      default:
        return hovered
            ? AppColors.BLACK_8
            : focused
                ? AppColors.BLACK_16
                : pressed
                    ? AppColors.BLACK_24
                    : AppColors.TRANSPARENT;
    }
  }

  double _loaderSize() {
    switch (widget.size) {
      case CommonButtonSize.Small:
        return AppTextStyles.noteHeightBasicCalc;
        break;
      case CommonButtonSize.Medium:
        return AppTextStyles.secondaryHeightBasicCalc;
        break;
      case CommonButtonSize.Large:
      default:
        return AppTextStyles.bodyHeightBasicCalc;
    }
  }

  List<BoxShadow> _shadow() {
    if (widget.loading || disabled) return [];
    return widget.type == CommonButtonType.Primary && (focused || hovered)
        ? AppWidgetStyles.commonButtonShadow(context: context)
        : [];
  }

  Widget _button(BuildContext context) {
    switch (widget.type) {
      case CommonButtonType.Outlined:
      case CommonButtonType.Primary:
      // case CommonButtonType.CommonDanger:
      default:
        return Stack(
          children: [
            // button
            Positioned.fill(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                decoration: BoxDecoration(
                  color: _backgroundColor(context),
                  borderRadius:
                      BorderRadius.circular(CommonButton._borderRadius),
                  boxShadow: _shadow(),
                ),
              ),
            ),
            // overlay
            Positioned.fill(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                decoration: BoxDecoration(
                  color: _overlayColor(context),
                  borderRadius:
                      BorderRadius.circular(CommonButton._borderRadius),
                ),
              ),
            ),
            Focus(
              focusNode: widget.focusNode,
              autofocus: widget.autoFocus,
              onFocusChange: (value) {
                setState(() {
                  focused = value;
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (event) {
                  setState(() {
                    hovered = true;
                  });
                },
                // onHover: (event) {
                //   setState(() {
                //     hovered = true;
                //   });
                // },
                onExit: (event) {
                  setState(() {
                    hovered = false;
                  });
                },
                child: GestureDetector(
                  onTap: widget.loading ? null : widget.onPressed,
                  onTapDown: (details) {
                    if (!disabled & !widget.loading) {
                      setState(() {
                        hovered = false;
                        pressed = true;
                        FocusScope.of(context).requestFocus(FocusNode());
                        // pressed = true;
                      });
                    }
                  },
                  onTapUp: (details) {
                    if (!disabled & !widget.loading) {
                      setState(() {
                        pressed = false;
                      });
                    }
                  },
                  onTapCancel: () {
                    if (!disabled && !widget.loading) {
                      setState(() {
                        pressed = false;
                      });
                    }
                  },
                  child: Container(
                    padding: widget.padding != null
                        ? widget.padding
                        : _contentPadding(context),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius:
                          new BorderRadius.circular(CommonButton._borderRadius),
                      border: Border.fromBorderSide(_border(context)),
                    ),
                    child: Center(
                      child: widget.loading
                          ? CommonLoader(
                              size: _loaderSize(),
                              inverse: _isLoaderInversed(context),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.prefixBuilder != null)
                                  widget.prefixBuilder(
                                    context,
                                    widget.type,
                                    null,
                                    _color(context),
                                  ),
                                Flexible(
                                  flex: 1,
                                  child: _content(context),
                                ),
                                if (widget.suffixBuilder != null)
                                  widget.suffixBuilder(
                                    context,
                                    widget.type,
                                    null,
                                    _color(context),
                                  ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget build(BuildContext context) {
    return widget.wide ? _button(context) : FittedBox(child: _button(context));
    // ElevatedButton(
    //   onPressed: () {},
    //   child: Text('Press me'),
    //   style: ButtonStyle(
    //     backgroundColor: MaterialStateProperty.all(AppColors.ACCENT_MAIN),
    //     elevation: MaterialStateProperty.resolveWith((states) {
    //       if (states.contains(MaterialState.hovered)) return 8;
    //       return 0;
    //     }),
    //     shape: MaterialStateProperty.all(
    //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    //     shadowColor: MaterialStateProperty.resolveWith(
    //       (states) {
    //         if (states.contains(MaterialState.pressed))
    //           return AppColors.TRANSPARENT;
    //         return AppColors.BLUE_VIOLET_500;
    //       },
    //     ),
    //     overlayColor: MaterialStateProperty.resolveWith(
    //       (states) {
    //         if (states.contains(MaterialState.pressed))
    //           return AppColors.BLACK_24;
    //         return AppColors.TRANSPARENT;
    //       },
    //     ),
    //   ),
    // );
  }
}
