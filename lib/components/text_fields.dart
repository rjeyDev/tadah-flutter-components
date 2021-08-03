//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';
import 'package:tadah_flutter_components/theme/app_colors.dart';
import 'package:tadah_flutter_components/theme/app_text_styles.dart';
import 'package:tadah_flutter_components/theme/theme/src/theme.dart';

class BasicTextInput extends StatefulWidget {
  static const double _cursorWidth = 1.2;
  static const double _cursorHeight = AppTextStyles.inputHeightBasicCalc;
  static const double _cursorRadius = _cursorWidth / 2;

  const BasicTextInput({
    Key key,
    @required this.controller,
    this.hintText,
    this.labelText,
    this.helpText,
    this.fontSize,
    this.color,
    this.textInputType,
    this.focusNode,
    this.obscureText = false,
    this.disabled = false,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.prefix,
    this.maxlines = 1,
    this.minlines = 1,
    this.maxLength,
  })  : assert(obscureText != null),
        assert(minlines <= maxlines),
        super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final String helpText;
  final double fontSize;
  final Color color;
  final TextInputType textInputType;
  final FocusNode focusNode;
  final bool obscureText;
  final bool disabled;
  final int maxlines;
  final int minlines;
  final int maxLength;
  final Widget prefix;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSaved;
  final String Function(String) validator;

  @override
  _BasicTextInputState createState() => _BasicTextInputState();
}

class _BasicTextInputState extends State<BasicTextInput> {
  FocusNode _focusNode;

  bool hide;
  bool hovered = false;
  bool get _isFocused => _focusNode.hasFocus;

  @override
  void initState() {
    // widget.controller.addListener(() {
    //   if (widget.controller.text.length < 2) {
    //     setState(() {});
    //   }
    // });
    hide = widget.obscureText;
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

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
          onChanged: widget.onChanged,
          onSaved: widget.onSaved,
          validator: widget.validator,
          enabled: !widget.disabled,
          controller: widget.controller,
          keyboardType: widget.textInputType,
          focusNode: _focusNode,
          maxLength: widget.maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          cursorRadius: Radius.circular(BasicTextInput._cursorRadius),
          cursorWidth: BasicTextInput._cursorWidth,
          cursorHeight: BasicTextInput._cursorHeight,
          cursorColor: AppTheme.of(context).accentMain,
          obscureText: hide,
          style: AppTextStyles.styleFrom(
            context: context,
            style: TextStyles.SECONDARY,
            color: AppColors.TEXT_PRIMARY_LIGHT,
            // height: 1.4,
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(widget.maxLength),
          ],
          decoration: InputDecoration(
            enabled: !widget.disabled,
            filled: false,
            contentPadding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
            // isDense: true,
            helperText: widget.helpText,
            suffixIconConstraints: BoxConstraints(
              maxWidth: 20,
              minWidth: 20,
            ),
            prefixIconConstraints: BoxConstraints(
              maxWidth: 40,
              minWidth: 40,
            ),
            prefixIcon: widget.prefix != null
                ? IconTheme(
                    data: IconThemeData(
                      color: _isFocused || widget.controller.text.length > 0
                          ? AppColors.BLACK
                          : AppColors.BLACK_38_WO,
                      size: 20,
                    ),
                    child:
                        SizedBox(width: 20, height: 20, child: widget.prefix))
                : null,
            suffix: widget.obscureText
                ? IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                    splashRadius: 10,
                    constraints: BoxConstraints(maxWidth: 20, maxHeight: 20),
                    onPressed: () {
                      setState(() {
                        hide = !hide;
                      });
                    },
                    icon: hide ? Icon(AppIcons.eye_slash) : Icon(AppIcons.eye),
                  )
                : ElevatedButton(
                    onPressed: () {
                      widget.controller.clear();
                    },
                    child: Icon(
                      AppIcons.x_mini,
                      color: AppColors.ACCENT_MAIN,
                    ),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(20, 20)),
                      padding:
                          MaterialStateProperty.all(EdgeInsets.only(left: 0)),
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(
                          AppColors.BLUE_VIOLET_500_16_WO),
                      shape: MaterialStateProperty.all(CircleBorder()),
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
                  color: hovered ? AppColors.BLACK_38_WO : AppColors.BLACK_8_WO,
                  width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: hovered ? AppColors.BLACK_38_WO : AppColors.BLACK_8_WO,
                  width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.RED_PIGMENT_500, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.ACCENT_MAIN, width: 1.5),
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
            hintText: widget.hintText,
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
              color: _isFocused ? AppColors.ACCENT_MAIN : AppColors.BLACK_38_WO,
            ),
          ),
        ),
      ),
    );
  }
}
