//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';
import 'package:tadah_flutter_components/theme/app_colors.dart';
import 'package:tadah_flutter_components/theme/app_text_styles.dart';
import 'package:tadah_flutter_components/theme/theme/src/theme.dart';

class AppStepper extends StatefulWidget {
  static const double _cursorWidth = 1.2;
  static const double _cursorHeight = AppTextStyles.inputHeightBasicCalc;
  static const double _cursorRadius = _cursorWidth / 2;

  const AppStepper({
    Key key,
    @required this.children,
    this.initialValue,
    this.labelText,
    this.helpText,
    this.fontSize = 16,
    this.focusNode,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  final List<String> children;
  final String initialValue;
  final String labelText;
  final String helpText;
  final double fontSize;
  final FocusNode focusNode;

  final ValueChanged<String> onChanged;
  final String Function(String) validator;

  @override
  _AppStepperState createState() => _AppStepperState();
}

class _AppStepperState extends State<AppStepper> {
  FocusNode _focusNode;
  bool hovered = false;
  bool get _isFocused => _focusNode.hasFocus;
  TextEditingController controller = TextEditingController();
  int index = 0;
  bool get disabled => widget.onChanged == null;

  @override
  void initState() {
    if (widget.initialValue != null) {
      controller.text = widget.initialValue;
      index = widget.children.indexOf(widget.initialValue);
    } else {
      controller.text = widget.children.first;
    }
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_focusListener);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode?.dispose();
    } else {
      _focusNode.removeListener(_focusListener);
    }
    super.dispose();
  }

  _focusListener() => setState(() {});

  next() {
    setState(() {
      index++;
      controller.text = widget.children[index];
      widget.onChanged(controller.text);
    });
  }

  prev() {
    setState(() {
      index--;
      controller.text = widget.children[index];
      widget.onChanged(controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.TRANSPARENT,
      child: MouseRegion(
        cursor: SystemMouseCursors.text,
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
        child: Theme(
          data: ThemeData(
              colorScheme: ColorScheme.light(
            primary: AppColors.BLACK,
          )),
          child: TextFormField(
            textAlign: TextAlign.center,
            readOnly: true,
            controller: controller,
            validator: widget.validator,
            enabled: !disabled,
            focusNode: _focusNode,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            cursorRadius: Radius.circular(AppStepper._cursorRadius),
            cursorWidth: AppStepper._cursorWidth,
            cursorHeight: AppStepper._cursorHeight,
            cursorColor: AppTheme.of(context).accentMain,
            style: AppTextStyles.styleFrom(
                context: context,
                fontSize: widget.fontSize,
                style: TextStyles.SECONDARY,
                color: disabled
                    ? AppColors.TEXT_DISABLED_LIGHT
                    : AppColors.TEXT_PRIMARY_LIGHT,
                height: 0),
            decoration: InputDecoration(
              enabled: !disabled,
              isCollapsed: true,
              filled: false,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 18,
              ),
              // isDense: true,
              helperText: widget.helpText,
              prefixStyle: TextStyle(height: 1),
              prefix: Container(
                // color: Colors.red,
                // width: 40,
                // margin: EdgeInsets.only(top: 8),
                child: ElevatedButton(
                  onPressed: index == 0
                      ? null
                      : () {
                          prev();
                        },
                  child: Icon(
                    AppIcons.caret_left_mini,
                    size: 20,
                    color: index == 0 || disabled
                        ? AppColors.BLACK_24_WO
                        : AppColors.ACCENT_MAIN,
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(20, 20)),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (index == 0) return AppColors.TRANSPARENT;
                      if (states.contains(MaterialState.hovered))
                        return AppColors.BLUE_VIOLET_500_16_WO;
                      return AppColors.TRANSPARENT;
                    }),
                    shape: MaterialStateProperty.all(CircleBorder()),
                  ),
                ),
              ),
              suffix: SizedBox(
                child: ElevatedButton(
                  onPressed: index == widget.children.length - 1
                      ? null
                      : () {
                          next();
                        },
                  child: Icon(
                    AppIcons.caret_right_mini,
                    size: 20,
                    color: index == widget.children.length - 1 || disabled
                        ? AppColors.BLACK_24_WO
                        : AppColors.ACCENT_MAIN,
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(20, 20)),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (index == widget.children.length - 1)
                        return AppColors.TRANSPARENT;
                      if (states.contains(MaterialState.hovered))
                        return AppColors.BLUE_VIOLET_500_16_WO;
                      return AppColors.TRANSPARENT;
                    }),
                    shape: MaterialStateProperty.all(CircleBorder()),
                  ),
                ),
              ),
              counterStyle: AppTextStyles.styleFrom(
                context: context,
                style: TextStyles.NOTE,
                color: AppColors.BLACK_38_WO,
              ),
              // counterText: '${widget.controller.text.length}/${widget.maxLength}',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        hovered ? AppColors.BLACK_38_WO : AppColors.BLACK_8_WO,
                    width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        hovered ? AppColors.BLACK_38_WO : AppColors.BLACK_8_WO,
                    width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.RED_PIGMENT_500, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.ACCENT_MAIN, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.BLACK_8_WO, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.RED_PIGMENT_500, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              labelText: widget.labelText,
              alignLabelWithHint: true,
              hintStyle: AppTextStyles.styleFrom(
                context: context,
                style: TextStyles.SECONDARY,
                color: AppColors.BLACK_38_WO,
              ),
              helperStyle: AppTextStyles.styleFrom(
                context: context,
                style: TextStyles.NOTE,
                color: AppColors.BLACK_38_WO,
              ),
              errorStyle: AppTextStyles.styleFrom(
                context: context,
                style: TextStyles.NOTE,
                color: AppColors.RED_PIGMENT_500,
              ),
              labelStyle: AppTextStyles.styleFrom(
                context: context,
                style: TextStyles.SECONDARY,
                color:
                    _isFocused ? AppColors.ACCENT_MAIN : AppColors.BLACK_38_WO,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
