// @dart=2.9
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

class AppCheckBox extends StatefulWidget {
  const AppCheckBox({
    Key key,
    @required this.value,
    this.tristate = false,
    @required this.onChanged,
    this.mouseCursor,
    this.activeColor = AppColors.ACCENT_MAIN,
    this.focusColor = AppColors.BLUE_VIOLET_500_16,
    this.pressColor = AppColors.BLUE_VIOLET_500_24,
    this.splashRadius,
    this.materialTapTargetSize,
    this.focusNode,
    this.autofocus = false,
    this.side,
  })  : assert(tristate != null),
        assert(tristate || value != null),
        assert(autofocus != null),
        super(key: key);

  final bool value;

  final ValueChanged<bool> onChanged;

  final MouseCursor mouseCursor;

  final Color activeColor;
  final Color focusColor;
  final Color pressColor;

  final bool tristate;

  final MaterialTapTargetSize materialTapTargetSize;

  final double splashRadius;

  final FocusNode focusNode;

  final bool autofocus;

  final BorderSide side;

  static const double width = 18.0;

  @override
  _AppCheckBoxState createState() => _AppCheckBoxState();
}

class _AppCheckBoxState extends State<AppCheckBox> {
  bool state = false;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: widget.value,
      onChanged: widget.onChanged,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      tristate: widget.tristate,
      mouseCursor: widget.mouseCursor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(width: 1),
      ),
      materialTapTargetSize:
          widget.materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.BLUE_VIOLET_500_16;
        }
        if (states.contains(MaterialState.selected) ||
            states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return widget.activeColor;
        }
        return AppColors.BLACK_16;
      }),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.focused)) return widget.focusColor;
        if (states.contains(MaterialState.pressed)) {
          return widget.pressColor;
        }
        return AppColors.TRANSPARENT;
      }),
      splashRadius: 10,
      // hoverColor: AppColors.ACCENT_MAIN,
    );
  }
}

enum RadioButtonType {
  CLASSIC,
  LABELED,
}

class RadioButton<T> extends StatefulWidget {
  const RadioButton({
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
    this.label = '',
    this.type = RadioButtonType.CLASSIC,
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
    return widget.type == RadioButtonType.CLASSIC
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
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
          )
        : MouseRegion(
            cursor:
                disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
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
                      groupValue: widget.groupValue,
                      autofocus: widget.autofocus,
                      splashRadius: widget.splashRadius,
                      materialTapTargetSize: widget.materialTapTargetSize,
                      onChanged: widget.onChanged,
                    ),
                    Text(
                      widget.label,
                      style: AppTextStyles.styleFrom(
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
          );
  }
}
