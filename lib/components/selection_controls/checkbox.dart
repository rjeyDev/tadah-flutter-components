//@dart=2.9
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/theme/theme/index.dart';

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
