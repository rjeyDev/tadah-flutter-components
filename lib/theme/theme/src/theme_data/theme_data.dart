// @dart=2.9
library app_theme;

import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../types.dart';
import 'border_theme_data.dart';
import 'text_style_theme_data.dart';
import 'text_theme_data.dart';
import 'background_theme_data.dart';
import 'button_theme_data.dart';

class AppThemeData {
  static AppThemeData lerp(AppThemeData a, AppThemeData b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);

    return AppThemeData(
      type: t == 0
          ? a.type
          : t == 1
              ? b.type
              : AppThemeType.Transition,
      accentMain: Color.lerp(a.accentMain, b.accentMain, t),
      transparent: Color.lerp(a.transparent, b.transparent, t),
      transparentPure: Color.lerp(a.transparentPure, b.transparentPure, t),
      base: Color.lerp(a.base, b.base, t),
      contrast: Color.lerp(a.contrast, b.contrast, t),
      text: AppTextThemeData.lerp(a.text, b.text, t),
      textStyles: AppTextStylesThemeData.lerp(a.textStyles, b.textStyles, t),
      background: AppBackgroundThemeData.lerp(a.background, b.background, t),
      border: AppBorderThemeData.lerp(a.border, b.border, t),
      button: AppButtonThemeData.lerp(a.button, b.button, t),
      chatLoader: Color.lerp(a.chatLoader, b.chatLoader, t),
    );
  }

  const AppThemeData({
    @required this.type,
    @required this.accentMain,
    @required this.transparent,
    @required this.transparentPure,
    @required this.base,
    @required this.contrast,
    @required this.text,
    @required this.textStyles,
    @required this.background,
    @required this.border,
    @required this.button,
    @required this.chatLoader,
  });

  final AppThemeType type;
  final Color accentMain;
  final Color transparent;
  final Color transparentPure;
  final Color base;
  final Color contrast;
  final AppTextThemeData text;
  final AppTextStylesThemeData textStyles;
  final AppBackgroundThemeData background;
  final AppBorderThemeData border;
  final AppButtonThemeData button;
  final Color chatLoader;

  // border
  // final Color borderCommon;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is AppThemeData &&
        type == other.type &&
        accentMain == other.accentMain &&
        transparent == other.transparent &&
        transparentPure == other.transparentPure &&
        base == other.base &&
        contrast == other.contrast &&
        text == other.text &&
        background == other.background &&
        border == other.border &&
        button == other.button &&
        chatLoader == other.chatLoader;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      type,
      accentMain,
      transparent,
      transparentPure,
      base,
      contrast,
      text.hashCode,
      background.hashCode,
      border.hashCode,
      button.hashCode,
      chatLoader,
    ];

    return hashList(values);
  }
}

class AppThemeDataTween extends Tween<AppThemeData> {
  /// Creates a [AppThemeData] tween.
  AppThemeDataTween({AppThemeData begin, AppThemeData end})
      : super(begin: begin, end: end);

  @override
  AppThemeData lerp(double t) => AppThemeData.lerp(begin, end, t);
}
