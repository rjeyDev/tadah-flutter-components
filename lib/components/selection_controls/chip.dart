// @dart=2.9

import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

class AppChip extends StatefulWidget {
  AppChip({
    @required this.selected,
    @required this.onSelected,
    @required this.label,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.avatar,
    this.onDeleted,
  })  : assert(selected != null),
        assert(onSelected != null),
        assert(enabled != null),
        assert(label != null),
        assert(autofocus != null);
  // assert(selected != null);
  final bool enabled;
  final FocusNode focusNode;
  final bool autofocus;
  final Widget avatar;
  final Widget label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final VoidCallback onDeleted;

  @override
  _AppChipState createState() => _AppChipState();
}

class _AppChipState extends State<AppChip> {
  bool get disabled => widget.enabled == false;
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: AppColors.TRANSPARENT,
        hoverColor: AppColors.BLUE_VIOLET_500_8,
        focusColor: AppColors.BLUE_VIOLET_500_16,
        highlightColor: AppColors.BLUE_VIOLET_500_24,
      ),
      child: RawChip(
        isEnabled: widget.enabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        selected: widget.selected,
        avatar: widget.avatar,
        showCheckmark: widget.avatar != null,
        checkmarkColor: AppColors.WHITE,
        onSelected: widget.onSelected,
        onDeleted: widget.onDeleted,
        pressElevation: 0,
        label: widget.label,
        disabledColor: AppColors.TRANSPARENT,
        labelStyle: AppTextStyles.styleFrom(
          context: context,
          style: TextStyles.SECONDARY,
          color: disabled ? AppColors.BLACK_54 : AppColors.BLACK,
        ),
        labelPadding: widget.onDeleted == null
            ? EdgeInsets.symmetric(horizontal: 8, vertical: 2)
            : EdgeInsets.fromLTRB(4, 2, 4, 2),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: disabled
                ? AppColors.BLACK_24_WO
                : widget.selected
                    ? AppColors.BLUE_VIOLET_500
                    : AppColors.COOL_GRAY_500_54,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        selectedColor: AppColors.TRANSPARENT,
        backgroundColor: widget.selected
            ? AppColors.BLUE_VIOLET_500_8
            : AppColors.TRANSPARENT,
        deleteIcon: AnimatedContainer(
          duration: Duration(milliseconds: 50),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: disabled
                ? AppColors.BLACK_16
                : widget.selected
                    ? AppColors.BLUE_VIOLET_500_16
                    : AppColors.BLACK_8,
          ),
          child: Icon(
            Icons.close_rounded,
            color:
                widget.selected ? AppColors.ACCENT_MAIN : AppColors.BLACK_54_WO,
            size: 16,
          ),
        ),
      ),
    );
  }
}
