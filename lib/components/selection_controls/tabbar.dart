// @dart=2.9
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

class UnderlinedTabBar extends StatefulWidget {
  UnderlinedTabBar(
      {Key key,
      @required this.tabController,
      this.prefix,
      this.focusNode,
      this.autofocus = false,
      this.onTap,
      this.disabled = false,
      this.isScrollable,
      this.tabs})
      : super(key: key);

  final FocusNode focusNode;
  final Widget prefix;
  final bool autofocus;
  final TabController tabController;
  final bool isScrollable;
  final bool disabled;
  final Function(int) onTap;
  final List<Widget> tabs;

  @override
  _UnderlinedTabBarState createState() => _UnderlinedTabBarState();
}

class _UnderlinedTabBarState extends State<UnderlinedTabBar> {
  bool focused = false;
  bool get hasPrefix => widget.prefix != null;

  @override
  void initState() {
    super.initState();
    focused = widget.autofocus;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: AppColors.TRANSPARENT,
        highlightColor: AppColors.TRANSPARENT,
        hoverColor: AppColors.TRANSPARENT,
      ),
      child: Focus(
        focusNode: widget.focusNode ?? FocusNode(),
        autofocus: widget.autofocus,
        onFocusChange: (focus) {
          setState(() {
            focused = focus;
          });
        },
        child: IgnorePointer(
          ignoring: widget.disabled,
          child: TabBar(
            controller: widget.tabController,
            isScrollable: widget.isScrollable ?? true,
            labelPadding: hasPrefix
                ? EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                : EdgeInsets.all(8),
            labelColor: widget.disabled
                ? AppColors.TEXT_DISABLED_LIGHT
                : AppColors.ACCENT_MAIN,
            labelStyle: AppTextStyles.NOTE_ACCENT,
            unselectedLabelStyle: AppTextStyles.NOTE_ACCENT,
            unselectedLabelColor: widget.disabled
                ? AppColors.TEXT_DISABLED_LIGHT
                : AppColors.COOL_GRAY_500,
            overlayColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.hovered)) {
                return AppColors.BLUE_VIOLET_500_8_WO;
              }
              if (states.contains(MaterialState.focused)) {
                return AppColors.BLUE_VIOLET_500_16_WO;
              }
              if (states.contains(MaterialState.pressed)) {
                return AppColors.BLUE_VIOLET_500_24_WO;
              }
              return AppColors.TRANSPARENT;
            }),
            indicator: widget.disabled
                ? BoxDecoration()
                : BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.ACCENT_MAIN,
                        width: 1.5,
                      ),
                    ),
                  ),
            onTap: widget.onTap,
            tabs: hasPrefix
                ? widget.tabs
                    .map((e) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widget.prefix,
                            SizedBox(width: 10),
                            e,
                          ],
                        ))
                    .toList()
                : widget.tabs,
          ),
        ),
      ),
    );
  }
}

class RoundedTabBar extends StatefulWidget {
  RoundedTabBar(
      {Key key,
      @required this.tabController,
      this.prefix,
      this.focusNode,
      this.autofocus = false,
      this.onTap,
      this.disabled = false,
      this.isScrollable,
      this.tabs})
      : super(key: key);

  final FocusNode focusNode;
  final Widget prefix;
  final bool autofocus;
  final TabController tabController;
  final bool isScrollable;
  final bool disabled;
  final Function(int) onTap;
  final List<Widget> tabs;

  @override
  _RoundedTabBarState createState() => _RoundedTabBarState();
}

class _RoundedTabBarState extends State<RoundedTabBar> {
  bool focused = false;
  bool pressed = false;
  bool get hasPrefix => widget.prefix != null;

  @override
  void initState() {
    super.initState();
    focused = widget.autofocus;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: AppColors.TRANSPARENT,
        highlightColor: AppColors.TRANSPARENT,
        hoverColor: AppColors.TRANSPARENT,
      ),
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onFocusChange: (focus) {
          setState(() {
            focused = focus;
          });
        },
        child: IgnorePointer(
          ignoring: widget.disabled,
          child: TabBar(
            controller: widget.tabController,
            isScrollable: widget.isScrollable ?? true,
            labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            labelColor: widget.disabled
                ? AppColors.TEXT_DISABLED_LIGHT
                : AppColors.ACCENT_MAIN,
            labelStyle: AppTextStyles.SECONDARY,
            unselectedLabelStyle: AppTextStyles.SECONDARY,
            unselectedLabelColor: widget.disabled
                ? AppColors.TEXT_DISABLED_LIGHT
                : AppColors.COOL_GRAY_500,
            indicator: widget.disabled
                ? BoxDecoration()
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: pressed
                        ? AppColors.BLUE_VIOLET_500_24_WO
                        : AppColors.BLUE_VIOLET_500_8_WO,
                    border: Border.all(
                      color: focused
                          ? AppColors.ACCENT_MAIN
                          : AppColors.TRANSPARENT,
                      width: 1.5,
                    ),
                  ),
            onTap: (index) {
              if (focused)
                setState(() {
                  focused = false;
                });
              if (widget.onTap != null) widget.onTap(index);
            },
            tabs: hasPrefix
                ? widget.tabs
                    .map((e) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widget.prefix,
                            SizedBox(width: 10),
                            e,
                          ],
                        ))
                    .toList()
                : widget.tabs,
          ),
        ),
      ),
    );
  }
}
