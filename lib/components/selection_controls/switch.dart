// @dart=2.9

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

enum SwitchType { classic, labeled }

class AppSwitch extends StatefulWidget {
  AppSwitch({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.focusNode,
    this.autoFocus = false,
  }) : super(key: key);

  final ValueChanged<bool> onChanged;
  final bool value;
  final FocusNode focusNode;
  final bool autoFocus;

  @override
  _AppSwitchState createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _animation;
  static const double trackWidth = 28;
  static const double togglerWidth = 16;
  bool hovered = false;
  bool pressed = false;
  bool focused = false;
  bool get disabled => widget.onChanged == null;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    print(hovered);
    _animation = Tween<Offset>(
            begin: Offset(0, 0),
            end: Offset((trackWidth - togglerWidth) / togglerWidth, 0))
        .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
    focused = widget.autoFocus;
    super.initState();
  }

  Color get togglerColor {
    return disabled
        ? AppColors.BLACK_16_WO
        : widget.value
            ? pressed
                ? AppColors.BLUE_VIOLET_500_PRESSED
                : focused
                    ? AppColors.BLUE_VIOLET_500_FOCUSED
                    : hovered
                        ? AppColors.BLUE_VIOLET_500_HOVERED
                        : AppColors.BLUE_VIOLET_500
            : pressed
                ? AppColors.BLACK_54_WO
                : hovered
                    ? AppColors.BLACK_38_WO
                    : AppColors.BLACK_24_WO;
  }

  Color get borderColor {
    return disabled
        ? AppColors.BLACK_8_WO
        : widget.value
            ? pressed || hovered || focused
                ? AppColors.BLUE_VIOLET_500_38_WO
                : AppColors.BLACK_8_WO
            : pressed
                ? AppColors.BLACK_24_WO
                : hovered || focused
                    ? AppColors.BLACK_16_WO
                    : AppColors.BLACK_8_WO;
  }

  Color get trackColor {
    return disabled
        ? AppColors.TRANSPARENT
        : widget.value
            ? pressed
                ? AppColors.BLUE_VIOLET_500_24_WO
                : focused
                    ? AppColors.BLUE_VIOLET_500_FOCUSED
                    : AppColors.TRANSPARENT
            : pressed || focused
                ? AppColors.BLACK_8_WO
                : AppColors.TRANSPARENT;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
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
        onExit: (event) {
          setState(() {
            hovered = false;
          });
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              !widget.value
                  ? _animationController.forward()
                  : _animationController.reverse();
              widget.onChanged(!widget.value);
            });
          },
          onTapDown: (details) {
            if (!disabled) {
              setState(() {
                pressed = true;
                FocusScope.of(context).requestFocus(FocusNode());
                // pressed = true;
              });
            }
          },
          onTapUp: (details) {
            if (!disabled) {
              setState(() {
                pressed = false;
              });
            }
          },
          onTapCancel: () {
            if (!disabled) {
              print('cancel');
              setState(() {
                pressed = false;
              });
            }
          },
          child: Container(
            width: 28,
            height: 16,
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  alignment: Alignment.centerLeft,
                  width: 28,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(width: 1.5, color: borderColor),
                    color: trackColor,
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: SlideTransition(
                    position: _animation,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: togglerColor,
                      ),
                    ),
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
