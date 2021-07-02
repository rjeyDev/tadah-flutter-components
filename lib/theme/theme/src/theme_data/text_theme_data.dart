// @dart=2.9
library app_theme;

import 'dart:ui';

import 'package:flutter/widgets.dart';

class AppTextThemeData {
  static AppTextThemeData lerp(
    AppTextThemeData a,
    AppTextThemeData b,
    double t,
  ) {
    assert(a != null);
    assert(b != null);
    assert(t != null);

    return AppTextThemeData(
      primary: Color.lerp(a.primary, b.primary, t),
      secondary: Color.lerp(a.secondary, b.secondary, t),
      placeholder: Color.lerp(a.placeholder, b.placeholder, t),
      disabled: Color.lerp(a.disabled, b.disabled, t),
      onAccent: Color.lerp(a.onAccent, b.onAccent, t),
    );
  }

  const AppTextThemeData({
    @required this.primary,
    @required this.secondary,
    @required this.placeholder,
    @required this.disabled,
    @required this.onAccent,
  });

  // text
  final Color primary;
  final Color secondary;
  final Color placeholder;
  final Color disabled;
  final Color onAccent;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is AppTextThemeData &&
        primary == other.primary &&
        secondary == other.secondary &&
        placeholder == other.placeholder &&
        disabled == other.placeholder &&
        onAccent == other.onAccent;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      primary,
      secondary,
      placeholder,
      disabled,
      onAccent,
    ];

    return hashList(values);
  }
}
