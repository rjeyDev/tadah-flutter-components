// @dart=2.9

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

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
            if (!disabled)
              setState(() {
                widget.onChanged(!widget.value);
                !widget.value
                    ? _animationController.forward()
                    : _animationController.reverse();
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

class LabelSwitch extends StatefulWidget {
  LabelSwitch({
    Key key,
    this.focusNode,
    this.autoFocus = false,
    this.initialIndex = 0,
    this.first = '',
    this.second = '',
    @required this.onChanged,
  }) : super(key: key);

  final FocusNode focusNode;
  final bool autoFocus;
  final int initialIndex;
  final String first;
  final String second;
  final ValueChanged<int> onChanged;

  @override
  _LabelSwitchState createState() => _LabelSwitchState();
}

class _LabelSwitchState extends State<LabelSwitch>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool hovered = false;
  bool focused = false;
  bool pressed = false;
  bool get disabled => widget.onChanged == null;

  @override
  void initState() {
    super.initState();
    // _currentIndex = widget.initialIndex;
    _tabController = TabController(
        vsync: this, length: 2, initialIndex: widget.initialIndex);

    _tabController.addListener(() {
      setState(() {
        widget.onChanged(_tabController.index);
      });
    });
  }

  Color get indicatorColor {
    return disabled
        ? AppColors.BACKGROUND_BUTTON_DISABLED_LIGHT
        : pressed
            ? AppColors.BLUE_VIOLET_500_16_WO
            : focused
                ? AppColors.BLUE_VIOLET_500_24_WO
                : AppColors.BLUE_VIOLET_500_16_WO;
  }

  Color get borderColor {
    return disabled
        ? AppColors.BLACK_8_WO
        : pressed || focused || hovered
            ? AppColors.ACCENT_MAIN
            : AppColors.BLACK_8_WO;
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
            if (!disabled) {
              _tabController.animateTo((_tabController.index + 1) % 2);
              focused = false;
            }
          },
          onTapDown: (details) {
            if (!disabled) {
              setState(() {
                pressed = true;
                focused = false;
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
              setState(() {
                pressed = false;
              });
            }
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IgnorePointer(
              child: TabBar(
                isScrollable: true,
                onTap: null,
                controller: _tabController,
                labelColor: disabled
                    ? AppColors.TEXT_DISABLED_LIGHT
                    : AppColors.ACCENT_MAIN,
                unselectedLabelColor: disabled
                    ? AppColors.TEXT_DISABLED_LIGHT
                    : AppColors.TEXT_PRIMARY_LIGHT,
                labelPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 4,
                ),
                // overlayColor: MaterialStateProperty.resolveWith((states) {
                //   if (states.contains(MaterialState.disabled))
                //     return AppColors.BLACK_16_WO;
                //   if (states.contains(MaterialState.pressed)) {
                //     return AppColors.BLUE_VIOLET_500_38_WO;
                //   }
                //   return AppColors.BLUE_VIOLET_500_16_WO;
                // }),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: indicatorColor,
                ),
                indicatorWeight: 2.0,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      widget.first,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      widget.second,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
