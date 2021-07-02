// @dart=2.9
library app_theme;

import 'dart:ui';

import 'package:flutter/widgets.dart';

class AppButtonThemeData {
  static AppButtonThemeData lerp(
    AppButtonThemeData a,
    AppButtonThemeData b,
    double t,
  ) {
    assert(a != null);
    assert(b != null);
    assert(t != null);

    return AppButtonThemeData(
      backgroundCommon: Color.lerp(a.backgroundCommon, b.backgroundCommon, t),
      backgroundDisabled:
          Color.lerp(a.backgroundDisabled, b.backgroundDisabled, t),
      borderDisabled: Color.lerp(a.borderDisabled, b.borderDisabled, t),
      textOnFilled: Color.lerp(a.textOnFilled, b.textOnFilled, t),
      textDisabled: Color.lerp(a.textDisabled, b.textDisabled, t),
    );
  }

  const AppButtonThemeData({
    @required this.backgroundCommon,
    @required this.backgroundDisabled,
    @required this.borderDisabled,
    @required this.textOnFilled,
    @required this.textDisabled,
  });

  // text
  final Color backgroundCommon;
  final Color backgroundDisabled;
  final Color borderDisabled;
  final Color textOnFilled;
  final Color textDisabled;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is AppButtonThemeData &&
        backgroundCommon == other.backgroundCommon &&
        backgroundDisabled == other.backgroundDisabled &&
        borderDisabled == other.borderDisabled &&
        textOnFilled == other.textOnFilled &&
        textDisabled == other.textDisabled;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      backgroundCommon,
      backgroundDisabled,
      borderDisabled,
      textOnFilled,
      textDisabled,
    ];

    return hashList(values);
  }
}
