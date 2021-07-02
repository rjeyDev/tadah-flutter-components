// @dart=2.9
library app_theme;

import 'dart:ui';

import 'package:flutter/widgets.dart';

class AppBackgroundThemeData {
  static AppBackgroundThemeData lerp(
    AppBackgroundThemeData a,
    AppBackgroundThemeData b,
    double t,
  ) {
    assert(a != null);
    assert(b != null);
    assert(t != null);

    return AppBackgroundThemeData(
      main: Color.lerp(a.main, b.main, t),
      cardCommon: Color.lerp(a.cardCommon, b.cardCommon, t),
      toast: Color.lerp(a.toast, b.toast, t),
    );
  }

  const AppBackgroundThemeData({
    @required this.main,
    @required this.cardCommon,
    @required this.toast,
  });

  // text
  final Color main;
  final Color cardCommon;
  final Color toast;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is AppBackgroundThemeData &&
        main == other.main &&
        cardCommon == other.cardCommon &&
        toast == other.toast;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      main,
      cardCommon,
      toast,
    ];

    return hashList(values);
  }
}
