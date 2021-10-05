//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';
import 'package:tadah_flutter_components/theme/app_colors.dart';
import 'package:tadah_flutter_components/theme/app_text_styles.dart';
import 'package:tadah_flutter_components/theme/theme/src/theme.dart';

class BasicTextInput extends StatefulWidget {
  static const double _cursorWidth = 1.2;
  // static const double _cursorHeight = AppTextStyles.inputHeightBasicCalc;
  static const double _cursorRadius = _cursorWidth / 2;

  const BasicTextInput({
    Key key,
    @required this.controller,
    this.hintText,
    this.labelText,
    this.helpText,
    this.fontSize = 16,
    this.textInputType,
    this.focusNode,
    this.obscureText = false,
    this.disabled = false,
    this.onChanged,
    this.onSaved,
    this.onTap,
    this.validator,
    this.prefix,
    this.floatingLabelBehavior,
    this.maxlines = 1,
    this.minlines = 1,
    this.maxLength,
    this.enableSuffix = true,
  })  : assert(obscureText != null),
        assert(minlines <= maxlines),
        super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final String helpText;
  final double fontSize;
  final FloatingLabelBehavior floatingLabelBehavior;
  final TextInputType textInputType;
  final FocusNode focusNode;
  final bool obscureText;
  final bool disabled;
  final int maxlines;
  final int minlines;
  final int maxLength;
  final bool enableSuffix;
  final Widget prefix;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSaved;
  final Function onTap;
  final String Function(String) validator;

  @override
  _BasicTextInputState createState() => _BasicTextInputState();
}

class _BasicTextInputState extends State<BasicTextInput> {
  FocusNode _focusNode;

  bool hide;
  bool enableClearButton = false;
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
            onTap: widget.onTap,
            onChanged: (value) {
              if (value.length > 0 && !enableClearButton)
                setState(() {
                  enableClearButton = true;
                });
              else if (enableClearButton && value.length == 0)
                setState(() {
                  enableClearButton = false;
                });
              if (widget.onChanged != null) widget.onChanged(value);
            },
            onSaved: widget.onSaved,
            validator: widget.validator,
            enabled: !widget.disabled,
            controller: widget.controller ?? TextEditingController(),
            keyboardType: widget.textInputType,
            focusNode: _focusNode,
            maxLength: widget.maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            cursorRadius: Radius.circular(BasicTextInput._cursorRadius),
            cursorWidth: BasicTextInput._cursorWidth,
            cursorHeight: 16,
            cursorColor: AppTheme.of(context).accentMain,
            obscureText: hide,
            textAlignVertical: TextAlignVertical.center,
            style: AppTextStyles.styleFrom(
              context: context,
              fontSize: widget.fontSize,
              style: TextStyles.SECONDARY,
              color: AppColors.TEXT_PRIMARY_LIGHT,
              letterSpacing: hide ? 2 : 0,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.maxLength),
            ],
            decoration: InputDecoration(
              enabled: !widget.disabled,
              floatingLabelBehavior: widget.floatingLabelBehavior != null
                  ? widget.floatingLabelBehavior
                  : FloatingLabelBehavior.auto,
              filled: false,
              contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              // isDense: true,
              helperText: widget.helpText,
              helperMaxLines: 10,
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
              suffix: widget.enableSuffix
                  ? widget.obscureText
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              hide = !hide;
                            });
                          },
                          child: Icon(
                            hide ? AppIcons.eye_slash : AppIcons.eye,
                            size: 20,
                            color: AppColors.BLACKOUT_700_80,
                          ),
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all(Size(20, 20)),
                            fixedSize: MaterialStateProperty.all(Size(20, 20)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: MaterialStateProperty.all(
                                EdgeInsets.only(left: 0)),
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor: MaterialStateProperty.all(
                                AppColors.TRANSPARENT),
                            shape: MaterialStateProperty.all(CircleBorder()),
                          ),
                        )
                      : enableClearButton
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  enableClearButton = false;
                                });
                                widget.controller.clear();
                              },
                              child: Icon(
                                AppIcons.x_mini,
                                size: 20,
                                color: AppColors.ACCENT_MAIN,
                              ),
                              style: ButtonStyle(
                                minimumSize:
                                    MaterialStateProperty.all(Size(20, 20)),
                                fixedSize:
                                    MaterialStateProperty.all(Size(20, 20)),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.only(left: 0)),
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors.BLUE_VIOLET_500_16_WO),
                                shape:
                                    MaterialStateProperty.all(CircleBorder()),
                              ),
                            )
                          : null
                  : null,
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
