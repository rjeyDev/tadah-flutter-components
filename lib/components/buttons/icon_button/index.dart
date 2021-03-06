// @dart=2.9
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/components/buttons/common_button/index.dart';
import 'package:tadah_flutter_components/components/buttons/common_loader/index.dart';

import 'package:tadah_flutter_components/theme/app_colors.dart';
import 'package:tadah_flutter_components/theme/app_text_styles.dart';
import 'package:tadah_flutter_components/theme/theme/src/theme.dart';

class CommonIconButton extends StatefulWidget {
  static const double _borderRadius = 80;

  const CommonIconButton(
    this.icon, {
    this.focusNode,
    this.autoFocus = false,
    this.onPressed,
    this.type = CommonButtonType.Primary,
    this.size = CommonButtonSize.Medium,
    this.fontWeight,
    this.fontSize,
    this.backgroundColor,
    this.wide = false,
    this.padding,
    this.prefixBuilder,
    this.suffixBuilder,
    this.loading = false,
  })  : assert(icon != null),
        assert(wide != null),
        assert(loading != null);

  final IconData icon;
  final FocusNode focusNode;
  final bool autoFocus;
  final VoidCallback onPressed;
  final CommonButtonType type;
  final CommonButtonSize size;
  final FontWeight fontWeight;
  final double fontSize;
  final Color backgroundColor;
  final bool wide;
  final EdgeInsets padding;
  final CommonButtonElementBuilder prefixBuilder;
  final CommonButtonElementBuilder suffixBuilder;
  final bool loading;

  @override
  _CommonIconButtonState createState() => _CommonIconButtonState();
}

class _CommonIconButtonState extends State<CommonIconButton> {
  bool get disabled => widget.onPressed == null;
  bool pressed = false;
  bool focused = false;
  bool hovered = false;

  Color _backgroundColor(BuildContext context) {
    switch (widget.type) {
      case CommonButtonType.Outlined:
      case CommonButtonType.Contrast:
      case CommonButtonType.ContrastDark:
        return AppTheme.of(context).transparent;
      case CommonButtonType.Primary:
      default:
        return disabled && !widget.loading
            ? AppTheme.of(context).button.backgroundDisabled
            : widget.backgroundColor ??
                AppTheme.of(context).button.backgroundCommon;
    }
  }

  bool _isLoaderInversed(BuildContext context) {
    switch (widget.type) {
      case CommonButtonType.Contrast:
      case CommonButtonType.ContrastDark:
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
      case CommonButtonType.ContrastDark:
      default:
        return AppTheme.of(context).button.textOnFilled;
    }
  }

  EdgeInsets _contentPadding(context) {
    if (widget.padding != null) return widget.padding;
    switch (widget.size) {
      case CommonButtonSize.Small:
        return EdgeInsets.all(8);
        break;
      case CommonButtonSize.Medium:
        return EdgeInsets.all(10);
        break;
      case CommonButtonSize.Large:
      default:
        return EdgeInsets.all(12);
        break;
    }
  }

  double _iconSize() {
    switch (widget.size) {
      case CommonButtonSize.Small:
        return 16;
        break;
      case CommonButtonSize.Medium:
        return 20;
        break;
      case CommonButtonSize.Large:
      default:
        return 24;
    }
  }

  Widget _content(BuildContext context) {
    return Icon(
      widget.icon,
      size: _iconSize(),
      color: _color(context),
    );
  }

  Color _overlayColor(context) {
    if (widget.loading || disabled) return AppColors.TRANSPARENT;
    switch (widget.type) {
      case CommonButtonType.Outlined:
      case CommonButtonType.Contrast:
        return pressed
            ? AppColors.BLUE_VIOLET_500_24
            : focused
                ? AppColors.BLUE_VIOLET_500_16
                : hovered
                    ? AppColors.BLUE_VIOLET_500_8
                    : AppColors.TRANSPARENT;
        break;
      case CommonButtonType.ContrastDark:
        return pressed
            ? AppColors.WHITE_24
            : focused || hovered
                ? AppColors.WHITE_16
                : AppColors.TRANSPARENT;
        break;
      case CommonButtonType.Primary:
      default:
        return pressed
            ? AppColors.BLACK_24
            : focused
                ? AppColors.BLACK_16
                : hovered
                    ? AppColors.BLACK_8
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

  Widget _button(BuildContext context) {
    switch (widget.type) {
      case CommonButtonType.Outlined:
      case CommonButtonType.Primary:
      // case CommonButtonType.CommonDanger:
      default:
        return Stack(
          children: [
            Positioned.fill(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                decoration: BoxDecoration(
                  color: _backgroundColor(context),
                  borderRadius:
                      BorderRadius.circular(CommonIconButton._borderRadius),
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
                      BorderRadius.circular(CommonIconButton._borderRadius),
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
                //   if (!pressed)
                //     setState(() {
                //       hovered = true;
                //     });
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
                        pressed = true;
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
                      borderRadius: new BorderRadius.circular(
                          CommonIconButton._borderRadius),
                      border: Border.fromBorderSide(_border(context)),
                    ),
                    child: Center(
                      child: widget.loading
                          ? CommonLoader(
                              size: _loaderSize(),
                              inverse: _isLoaderInversed(context),
                            )
                          : _content(context),
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
  }
}
