//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';
import 'package:tadah_flutter_components/theme/app_colors.dart';
import 'package:tadah_flutter_components/theme/app_text_styles.dart';
import 'package:tadah_flutter_components/theme/theme/src/theme.dart';

class CountryCode {
  final Widget flagIcon;
  final String countryCode;
  final String mask;
  CountryCode(
      {@required this.flagIcon,
      @required this.countryCode,
      @required this.mask});
}

class PhoneBox extends StatefulWidget {
  static const double _cursorWidth = 1.2;
  static const double _cursorHeight = AppTextStyles.inputHeightBasicCalc;
  static const double _cursorRadius = _cursorWidth / 2;

  const PhoneBox({
    Key key,
    @required this.countries,
    this.labelText,
    this.helpText,
    this.fontSize = 16,
    this.focusNode,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.enableSuffix = true,
  }) : super(key: key);

  final List<CountryCode> countries;
  final String labelText;
  final String helpText;
  final double fontSize;
  final FocusNode focusNode;
  final Function(CountryCode, String) onChanged;
  final ValueChanged<String> onSaved;
  final String Function(String) validator;
  final bool enableSuffix;

  @override
  _PhoneBoxState createState() => _PhoneBoxState();
}

class _PhoneBoxState extends State<PhoneBox>
    with SingleTickerProviderStateMixin {
  FocusNode _focusNode;
  Animation<double> animation;
  AnimationController controller;
  MaskedTextController textController;
  bool hovered = false;
  bool get disabled => widget.onChanged == null;
  bool get _isFocused => _focusNode.hasFocus;
  CountryCode selectedCountry;
  OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    selectedCountry = widget.countries.first;
    textController = MaskedTextController(mask: selectedCountry.mask);
    _overlayEntry = OverlayEntry(builder: (ctx) {
      return DropdownList(
        context,
        width: 95,
        children: widget.countries.map((item) {
          return DropdownListChild(
            title: item.countryCode,
            prefix: Container(
              width: 20,
              height: 20,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: item.flagIcon),
            ),
            onTap: (value) {
              _overlayEntry.remove();
              controller.reverse();
              setState(() {
                selectedCountry = widget.countries
                    .firstWhere((element) => element.countryCode == value);
                textController =
                    MaskedTextController(mask: selectedCountry.mask);
                widget.onChanged(selectedCountry, textController.text);
              });
            },
          );
        }).toList(),
        layerLink: _layerLink,
      );
    });
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_focusListener);
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0, end: 0.5).animate(controller);
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

  toggleOverlay() {
    if (_overlayEntry.mounted) {
      _overlayEntry.remove();
      controller.reverse();
    } else {
      Overlay.of(context).insert(_overlayEntry);
      controller.forward();
    }
  }

  _focusListener() => setState(() {
        if (!_focusNode.hasFocus && _overlayEntry.mounted) {
          _overlayEntry.remove();
          controller.reverse();
        }
      });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.TRANSPARENT,
      child: CompositedTransformTarget(
        link: _layerLink,
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
              onChanged: (value) => widget.onChanged(selectedCountry, value),
              onSaved: widget.onSaved,
              validator: widget.validator,
              enabled: !disabled,
              controller: textController,
              keyboardType: TextInputType.phone,
              focusNode: _focusNode,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              cursorRadius: Radius.circular(PhoneBox._cursorRadius),
              cursorWidth: PhoneBox._cursorWidth,
              cursorHeight: PhoneBox._cursorHeight,
              cursorColor: AppTheme.of(context).accentMain,
              style: AppTextStyles.styleFrom(
                context: context,
                fontSize: widget.fontSize,
                style: TextStyles.SECONDARY,
                color: AppColors.TEXT_PRIMARY_LIGHT,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              decoration: InputDecoration(
                enabled: !disabled,
                filled: false,
                contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                // isDense: true,
                suffixIconConstraints: BoxConstraints(
                  maxWidth: 20,
                  minWidth: 20,
                ),
                prefixIconConstraints: BoxConstraints(
                  maxWidth: 75,
                  minWidth: 40,
                ),
                prefixStyle: TextStyle(fontSize: 16),
                prefixIcon: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      toggleOverlay();
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 12),
                        Container(
                            width: 20,
                            height: 20,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: selectedCountry.flagIcon)),
                        SizedBox(width: 4),
                        RotationTransition(
                          turns: animation,
                          child: Icon(
                            AppIcons.caret_down_mini,
                            color: _focusNode.hasFocus
                                ? AppColors.ACCENT_MAIN
                                : AppColors.BLACK_38_WO,
                          ),
                        ),
                        SizedBox(width: 4),
                        Container(
                          width: 1,
                          height: 24,
                          color: AppColors.BLACK_8_WO,
                        ),
                      ],
                    ),
                  ),
                ),
                suffix: widget.enableSuffix
                    ? ElevatedButton(
                        onPressed: () {
                          textController.clear();
                        },
                        child: Icon(
                          AppIcons.x_mini,
                          size: 20,
                          color: AppColors.ACCENT_MAIN,
                        ),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(20, 20)),
                          fixedSize: MaterialStateProperty.all(Size(20, 20)),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: MaterialStateProperty.all(
                              EdgeInsets.only(left: 0)),
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(
                              AppColors.BLUE_VIOLET_500_16_WO),
                          shape: MaterialStateProperty.all(CircleBorder()),
                        ),
                      )
                    : null,
                counterStyle: AppTextStyles.styleFrom(
                  context: context,
                  style: TextStyles.NOTE,
                  color: AppColors.BLACK_38_WO,
                ),
                // counterText: '${widget.controller.text.length}/${widget.maxLength}',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: hovered
                          ? AppColors.BLACK_38_WO
                          : AppColors.BLACK_8_WO,
                      width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: hovered
                          ? AppColors.BLACK_38_WO
                          : AppColors.BLACK_8_WO,
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
                  borderSide:
                      BorderSide(color: AppColors.BLACK_8_WO, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.RED_PIGMENT_500, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                helperText: widget.helpText,
                prefixText: selectedCountry.countryCode + ' ',
                hintText: selectedCountry.mask,
                labelText: widget.labelText,
                alignLabelWithHint: true,
                helperMaxLines: 10,
                helperStyle: AppTextStyles.styleFrom(
                  context: context,
                  style: TextStyles.NOTE,
                  color: AppColors.BLACK_38_WO,
                ),
                hintStyle: AppTextStyles.styleFrom(
                  context: context,
                  style: TextStyles.SECONDARY,
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
                  color: _isFocused
                      ? AppColors.ACCENT_MAIN
                      : AppColors.BLACK_38_WO,
                ),
              ),
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
