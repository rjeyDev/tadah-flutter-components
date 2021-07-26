// @dart=2.9
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

class AppTabBar extends StatefulWidget {
  AppTabBar(
      {Key key,
      @required this.tabController,
      this.focusNode,
      this.autofocus = false,
      this.onTap,
      this.disabled = false,
      this.isScrollable,
      this.tabs})
      : super(key: key);

  final FocusNode focusNode;
  final bool autofocus;
  final TabController tabController;
  final bool isScrollable;
  final bool disabled;
  final Function(int) onTap;
  final List<Widget> tabs;

  @override
  _AppTabBarState createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar> {
  bool focused = false;

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
            labelPadding: EdgeInsets.all(8),
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
            tabs: widget.tabs,
          ),
        ),
      ),
    );
  }
}
