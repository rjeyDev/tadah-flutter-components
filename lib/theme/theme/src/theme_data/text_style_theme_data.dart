// @dart=2.9
library app_theme;

import 'dart:ui';

import 'package:flutter/widgets.dart';

class AppTextStylesThemeData {
  static AppTextStylesThemeData lerp(
    AppTextStylesThemeData a,
    AppTextStylesThemeData b,
    double t,
  ) {
    assert(a != null);
    assert(b != null);
    assert(t != null);

    return AppTextStylesThemeData(
      h1: TextStyle.lerp(a.h1, b.h1, t),
      h2: TextStyle.lerp(a.h2, b.h2, t),
      h3: TextStyle.lerp(a.h3, b.h3, t),
      h4: TextStyle.lerp(a.h4, b.h4, t),
      h5: TextStyle.lerp(a.h5, b.h5, t),
      h6: TextStyle.lerp(a.h6, b.h6, t),
      body: TextStyle.lerp(a.body, b.body, t),
      bodyMoreText: TextStyle.lerp(a.bodyMoreText, b.bodyMoreText, t),
      secondary: TextStyle.lerp(a.secondary, b.secondary, t),
      secondaryMoreText:
          TextStyle.lerp(a.secondaryMoreText, b.secondaryMoreText, t),
      note: TextStyle.lerp(a.note, b.note, t),
      noteAccent: TextStyle.lerp(a.noteAccent, b.noteAccent, t),
    );
  }

  const AppTextStylesThemeData({
    @required this.h1,
    @required this.h2,
    @required this.h3,
    @required this.h4,
    @required this.h5,
    @required this.h6,
    @required this.body,
    @required this.bodyMoreText,
    @required this.secondary,
    @required this.secondaryMoreText,
    @required this.note,
    @required this.noteAccent,
  });

  // text
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle h4;
  final TextStyle h5;
  final TextStyle h6;
  final TextStyle body;
  final TextStyle bodyMoreText;
  final TextStyle secondary;
  final TextStyle secondaryMoreText;
  final TextStyle note;
  final TextStyle noteAccent;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is AppTextStylesThemeData &&
        h1 == other.h1 &&
        h2 == other.h2 &&
        h3 == other.h3 &&
        h4 == other.h4 &&
        h5 == other.h5 &&
        h6 == other.h6 &&
        body == other.body &&
        bodyMoreText == other.bodyMoreText &&
        secondary == other.secondary &&
        secondaryMoreText == other.secondaryMoreText &&
        note == other.note &&
        noteAccent == other.noteAccent;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      h1,
      h2,
      h3,
      h4,
      h5,
      h6,
      body,
      bodyMoreText,
      secondary,
      secondaryMoreText,
      note,
      noteAccent,
    ];

    return hashList(values);
  }
}
