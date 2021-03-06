// @dart=2.9
import 'package:flutter/widgets.dart';
import 'package:tadah_flutter_components/components/buttons/touchable_opacity/index.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

class AppLink extends StatefulWidget {
  const AppLink(
    this.text, {
    this.icon,
    this.onPressed,
    this.fontWeight = FontWeight.w400,
    this.fontSize = 16,
  })  : assert(text != null && text != ""),
        assert(fontWeight != null);

  final String text;
  final IconData icon;
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.text,
          style: AppTextStyles.styleFrom(
            context: context,
            style: TextStyles.SECONDARY,
            color: color,
            fontWeight: widget.fontWeight,
            fontSize: widget.fontSize,
            decoration: (hovered && !pressed)
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        ),
        SizedBox(width: 4),
        Icon(
          widget.icon,
          size: 20,
          color: color,
        ),
      ],
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
