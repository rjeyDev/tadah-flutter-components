// @dart=2.9

import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/theme/theme/index.dart';

enum RadioButtonType {
  classic,
  labeled,
}

class RadioButton<T> extends StatefulWidget {
  const RadioButton({
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
    this.label = '',
    this.type = RadioButtonType.classic,
    this.mouseCursor,
    this.toggleable = false,
    this.activeColor = AppColors.ACCENT_MAIN,
    this.focusColor = AppColors.BLUE_VIOLET_500_16,
    this.pressColor = AppColors.BLUE_VIOLET_500_24,
    this.splashRadius = 9,
    this.materialTapTargetSize = MaterialTapTargetSize.shrinkWrap,
    this.focusNode,
    this.autofocus = false,
  })  : assert(autofocus != null),
        assert(toggleable != null);

  final String label;
  final RadioButtonType type;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final MouseCursor mouseCursor;
  final bool toggleable;
  final Color activeColor;
  final Color focusColor;
  final Color pressColor;
  final double splashRadius;
  final MaterialTapTargetSize materialTapTargetSize;
  final FocusNode focusNode;
  final bool autofocus;

  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  bool pressed = false;
  bool hovered = false;
  bool get disabled => widget.onChanged == null;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.TRANSPARENT,
      child: widget.type == RadioButtonType.classic
          ? Radio(
              value: widget.value,
              groupValue: widget.groupValue,
              onChanged: widget.onChanged,
              mouseCursor: widget.mouseCursor,
              toggleable: widget.toggleable,
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled)) {
                  return AppColors.BLACK_8;
                }
                if (states.contains(MaterialState.selected) ||
                    states.contains(MaterialState.hovered) ||
                    states.contains(MaterialState.focused)) {
                  return widget.activeColor;
                }
                return AppColors.BLACK_16;
              }),
              overlayColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled))
                  return AppColors.TRANSPARENT;
                if (states.contains(MaterialState.focused))
                  return widget.focusColor;
                if (states.contains(MaterialState.pressed)) {
                  return widget.pressColor;
                }
                return AppColors.TRANSPARENT;
              }),
              splashRadius: widget.splashRadius,
              materialTapTargetSize: widget.materialTapTargetSize,
              focusNode: widget.focusNode ?? FocusNode(),
              autofocus: widget.autofocus,
            )
          : MouseRegion(
              cursor: disabled
                  ? SystemMouseCursors.basic
                  : SystemMouseCursors.click,
              onEnter: (event) {
                if (!disabled)
                  setState(() {
                    hovered = true;
                  });
              },
              onExit: (event) {
                if (!disabled)
                  setState(() {
                    hovered = false;
                  });
              },
              child: GestureDetector(
                onTap: () {
                  if (!disabled) widget.onChanged(widget.value);
                },
                onTapDown: (details) {
                  if (!disabled)
                    setState(() {
                      pressed = true;
                    });
                },
                onTapUp: (details) {
                  if (!disabled)
                    setState(() {
                      pressed = false;
                    });
                },
                onTapCancel: () {
                  if (!disabled)
                    setState(() {
                      pressed = false;
                    });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: !disabled && pressed
                        ? AppColors.BLUE_VIOLET_500_24
                        : AppColors.TRANSPARENT,
                    border: Border.all(
                      width: 1.5,
                      color: disabled
                          ? AppColors.BLACK_8
                          : pressed || hovered
                              ? AppColors.ACCENT_MAIN
                              : AppColors.BLACK_8,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Radio(
                        value: widget.value,
                        fillColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.disabled)) {
                            return AppColors.BLACK_8;
                          }
                          if (states.contains(MaterialState.selected) ||
                              states.contains(MaterialState.hovered) ||
                              states.contains(MaterialState.focused)) {
                            return widget.activeColor;
                          }
                          return AppColors.BLACK_16;
                        }),
                        overlayColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.disabled))
                            return AppColors.TRANSPARENT;
                          if (states.contains(MaterialState.focused))
                            return widget.focusColor;
                          if (states.contains(MaterialState.pressed)) {
                            return widget.pressColor;
                          }
                          return AppColors.TRANSPARENT;
                        }),
                        groupValue: widget.groupValue,
                        autofocus: widget.autofocus,
                        splashRadius: widget.splashRadius,
                        materialTapTargetSize: widget.materialTapTargetSize,
                        onChanged: widget.onChanged,
                      ),
                      Text(
                        widget.label,
                        style: AppTextStyles.styleFrom(
                          context: context,
                          style: TextStyles.SECONDARY,
                          color: disabled
                              ? AppColors.BLUE_VIOLET_500_38
                              : AppColors.ACCENT_MAIN,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
