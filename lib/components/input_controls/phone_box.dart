//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';
import 'package:tadah_flutter_components/theme/app_colors.dart';
import 'package:tadah_flutter_components/theme/app_text_styles.dart';
import 'package:tadah_flutter_components/theme/theme/src/theme.dart';

class PhoneBox extends StatefulWidget {
  static const double _cursorWidth = 1.2;
  static const double _cursorHeight = AppTextStyles.inputHeightBasicCalc;
  static const double _cursorRadius = _cursorWidth / 2;

  const PhoneBox({
    Key key,
    @required this.controller,
    this.hintText,
    this.labelText,
    this.helpText,
    this.fontSize = 14,
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
  _PhoneBoxState createState() => _PhoneBoxState();
}

class _PhoneBoxState extends State<PhoneBox> {
  FocusNode _focusNode;
  TextEditingController textController = TextEditingController();
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
          cursorRadius: Radius.circular(PhoneBox._cursorRadius),
          cursorWidth: PhoneBox._cursorWidth,
          cursorHeight: PhoneBox._cursorHeight,
          cursorColor: AppTheme.of(context).accentMain,
          obscureText: hide,
          style: AppTextStyles.styleFrom(
            context: context,
            fontSize: widget.fontSize,
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
            prefixIcon: SizedBox(
              width: 70,
              child: Dropdown(
                controller: textController,
                focusNode: _focusNode,
                label: 'Style',
                hintText: 'Select style',
                multiselect: true,
                onChanged:
                    // null,
                    (value) {},
                // value: 'Weight',
                // prefix: Icon(AppIcons.search),
                children: [
                  DropdownItem(title: 'Style', type: DropdownItemType.label),
                  DropdownItem(
                    onTap: (value) {
                      textController.text = value;
                    },
                    // selected: true,
                    title: 'Align right',
                  ),
                  DropdownItem(
                    onTap: (value) {
                      textController.text = value;
                    },
                    prefix: Icon(AppIcons.apple),
                    title: 'Align left',
                    // type: DropdownItemType.nested,
                  ),
                  DropdownItem(
                    onTap: (value) {},
                    title: 'Colors',
                    type: DropdownItemType.nested,
                  ),
                ],
              ),
            ),
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

typedef BeforeChangeCallback = bool Function(String previous, String next);
typedef AfterChangeCallback = void Function(String previous, String next);

/// A [TextEditingController] extended to provide custom masks to flutter
class MaskedTextController extends TextEditingController {
  MaskedTextController({
    @required this.mask,
    this.beforeChange,
    this.afterChange,
    String text,
    Map<String, RegExp> translator,
  }) : super(text: text) {
    this.translator = translator ?? MaskedTextController.getDefaultTranslator();

    // Initialize the beforeChange and afterChange callbacks if they are null
    beforeChange ??= (previous, next) => true;
    afterChange ??= (previous, next) {};

    addListener(() {
      final previous = _lastUpdatedText;

      if (beforeChange(previous, this.text)) {
        updateText(this.text);
        afterChange(previous, this.text);
      } else {
        updateText(_lastUpdatedText);
      }
    });

    updateText(this.text);
  }

  /// The current applied mask
  String mask;

  /// Translator from mask characters to [RegExp]
  Map<String, RegExp> translator;

  /// A function called before the text is updated.
  /// Returns a boolean informing whether the text should be updated.
  ///
  /// Defaults to a function returning true
  BeforeChangeCallback beforeChange;

  /// A function called after the text is updated
  ///
  /// Defaults to an empty function
  AfterChangeCallback afterChange;

  String _lastUpdatedText = '';

  /// Default [RegExp] for each character available for the mask
  ///
  /// 'A' represents a letter of the alphabet
  /// '0' represents a numeric character
  /// '@' represents a alphanumeric character
  /// '*' represents any character
  static Map<String, RegExp> getDefaultTranslator() => {
        'A': RegExp(r'[A-Za-z]'),
        '0': RegExp(r'[0-9]'),
        '@': RegExp(r'[A-Za-z0-9]'),
        '*': RegExp(r'.*')
      };

  /// Corresponding to [TextEditingController.text]
  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
    }
  }

  /// Replaces [mask] with a [newMask] and moves cursor to the end if
  /// [shouldMoveCursorToEnd] is true
  void updateMask(String newMask, {bool shouldMoveCursorToEnd = true}) {
    mask = newMask;
    updateText(text);

    if (shouldMoveCursorToEnd) {
      moveCursorToEnd();
    }
  }

  /// Updates the current [text] with a new one applying the [mask]
  void updateText(String newText) {
    text = _applyMask(mask, newText);
    _lastUpdatedText = text;
    moveCursorToEnd();
  }

  /// Moves cursor to the end of the text
  void moveCursorToEnd() {
    // only moves the cursor if text is not selected
    if (selection.baseOffset == selection.extentOffset) {
      selection = TextSelection.fromPosition(
        TextPosition(offset: _lastUpdatedText.length),
      );
    }
  }

  String _applyMask(String mask, String value) {
    final result = StringBuffer('');
    var maskCharIndex = 0;
    var valueCharIndex = 0;

    while (maskCharIndex != mask.length && valueCharIndex != value.length) {
      final maskChar = mask[maskCharIndex];
      final valueChar = value[valueCharIndex];

      // value equals mask, just write value to the buffer
      if (maskChar == valueChar) {
        result.write(maskChar);
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match with the current mask character
      if (translator.containsKey(maskChar)) {
        if (translator[maskChar].hasMatch(valueChar)) {
          result.write(valueChar);
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not a masked value, fixed char on mask
      result.write(maskChar);
      maskCharIndex += 1;
    }

    return result.toString();
  }
}
