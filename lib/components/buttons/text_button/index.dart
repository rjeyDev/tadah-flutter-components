// @dart=2.9
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/components/buttons/common_loader/index.dart';
import 'package:tadah_flutter_components/components/buttons/touchable_opacity/index.dart';
import 'package:tadah_flutter_components/theme/app_text_styles.dart';
import 'package:tadah_flutter_components/theme/theme/src/theme.dart';

enum TextButtonType {
  Primary,
  Additional,
}

class TextButton extends StatelessWidget {
  const TextButton(
    this.text, {
    this.onPressed,
    this.type = TextButtonType.Primary,
    this.fontWeight = FontWeight.w500,
    this.fontSize,
    this.wide = false,
    this.padding,
    this.loading = false,
  })  : assert(text != null && text != ""),
        assert(wide != null),
        assert(fontWeight != null),
        assert(loading != null);

  final String text;
  final VoidCallback onPressed;
  final TextButtonType type;
  final FontWeight fontWeight;
  final double fontSize;
  final bool wide;
  final EdgeInsets padding;
  final bool loading;

  bool get disabled => onPressed == null;

  Color color(BuildContext context) {
    switch (type) {
      case TextButtonType.Additional:
        return disabled
            ? AppTheme.of(context).button.textDisabled
            : AppTheme.of(context).text.secondary;
      case TextButtonType.Primary:
      default:
        return disabled
            ? AppTheme.of(context).button.textDisabled
            : AppTheme.of(context).accentMain;
    }
  }

  Widget _content(BuildContext context) {
    return Text(
      text,
      style: AppTheme.of(context).textStyles.body,
    );
  }

  Widget _button(BuildContext context) {
    return TouchableOpacity(
      ghostTouch: true,
      behavior: HitTestBehavior.opaque,
      onTap: loading ? null : onPressed,
      child: Padding(
        padding: padding != null ? padding : const EdgeInsets.all(8),
        child: Center(
          child: loading
              ? CommonLoader(
                  size: AppTextStyles.bodyHeightBasicCalc,
                  inverse: true,
                )
              : _content(context),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return wide ? _button(context) : FittedBox(child: _button(context));
  }
}
