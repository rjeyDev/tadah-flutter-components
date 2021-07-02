// @dart=2.9
library app_theme;

import 'dart:ui';

import 'package:flutter/widgets.dart';

class AppBorderThemeData {
  static AppBorderThemeData lerp(
    AppBorderThemeData a,
    AppBorderThemeData b,
    double t,
  ) {
    assert(a != null);
    assert(b != null);
    assert(t != null);

    return AppBorderThemeData(
      inputUnderlined: Color.lerp(a.inputUnderlined, b.inputUnderlined, t),
      inputDisabledUnderlined:
          Color.lerp(a.inputDisabledUnderlined, b.inputDisabledUnderlined, t),
      commonUnderline: Color.lerp(a.commonUnderline, b.commonUnderline, t),
    );
  }

  const AppBorderThemeData({
    @required this.inputUnderlined,
    @required this.inputDisabledUnderlined,
    @required this.commonUnderline,
  });

  // text
  final Color inputUnderlined;
  final Color inputDisabledUnderlined;
  final Color commonUnderline;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is AppBorderThemeData &&
        inputUnderlined == other.inputUnderlined &&
        inputDisabledUnderlined == other.inputDisabledUnderlined &&
        commonUnderline == other.commonUnderline;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      inputUnderlined,
      inputDisabledUnderlined,
      commonUnderline,
    ];

    return hashList(values);
  }
}
