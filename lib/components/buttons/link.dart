// @dart=2.9
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/components/buttons/touchable_opacity/index.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

class AppLink extends StatefulWidget {
  const AppLink(
    this.text, {
    this.onPressed,
    this.fontWeight = FontWeight.w400,
    this.fontSize,
  })  : assert(text != null && text != ""),
        assert(fontWeight != null);

  final String text;
  final VoidCallback onPressed;
  final FontWeight fontWeight;
  final double fontSize;

  @override
  _AppLinkState createState() => _AppLinkState();
}

class _AppLinkState extends State<AppLink> {
  bool pressed = false;
  bool hovered = false;
  bool viewed = false;

  Color get color {
    return pressed
        ? AppColors.BLUE_VIOLET_500_PRESSED
        : hovered
            ? AppColors.BLUE_VIOLET_500_HOVERED
            : viewed
                ? AppColors.BLUE_VIOLET_500_54
                : AppColors.BLUE_VIOLET_500;
  }

  Widget _content(BuildContext context) {
    return Text(
      widget.text,
      style: AppTextStyles.styleFrom(
        context: context,
        style: TextStyles.SECONDARY,
        color: color,
        decoration: (hovered && !pressed)
            ? TextDecoration.underline
            : TextDecoration.none,
      ),
    );
  }

  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (value) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (value) {
        setState(() {
          hovered = false;
        });
      },
      child: FittedBox(
        child: TouchableOpacity(
          activeOpacity: 1,
          // ghostTouch: true,

          // behavior: HitTestBehavior.opaque,
          onTap: () {
            if (widget.onPressed != null) {
              widget.onPressed();
            }
            setState(() {
              pressed = true;
              viewed = true;
            });
            Future.delayed(Duration(milliseconds: 100), () {
              setState(() {
                pressed = false;
              });
            });
          },
          onTapDown: (details) {
            setState(() {
              pressed = true;
            });
          },
          onTapUp: (details) {
            setState(() {
              pressed = false;
            });
          },
          onTapCancel: () {
            setState(() {
              pressed = false;
            });
          },
          child: Center(
            child: _content(context),
          ),
        ),
      ),
    );
  }
}
