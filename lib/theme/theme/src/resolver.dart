// @dart=2.9
library app_theme;

import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'theme_data/theme_data.dart';
import 'theme.dart';
import 'types.dart';

part 'resolver_controller.dart';

class AppThemeResolver extends StatefulWidget {
  static ThemeResolverController of(BuildContext context) {
    final _InheritedThemeResolver inheritedThemeResolver =
        context.dependOnInheritedWidgetOfExactType<_InheritedThemeResolver>();
    return inheritedThemeResolver._data._controller;
  }

  const AppThemeResolver({
    @required this.child,
    @required this.themes,
    this.initialMode = AppThemeMode.System,
  })  : assert(child != null),
        assert(themes != null),
        assert(initialMode != null);

  final Widget child;
  final AppThemeMode initialMode;
  final Map<AppThemeVariety, AppThemeData> themes;

  @override
  _AppThemeResolverState createState() => _AppThemeResolverState();
}

class _AppThemeResolverState extends State<AppThemeResolver> {
  ThemeResolverController _controller;

  @override
  void initState() {
    SingletonFlutterWindow window = WidgetsBinding.instance.window;

    _controller = ThemeResolverController._(
      mode: widget.initialMode,
      themes: widget.themes,
    );

    _controller._setPlatformBrightness(window.platformBrightness);
    window.onPlatformBrightnessChanged = () {
      final brightness = window.platformBrightness;
      if (_controller._platformBrightness != brightness) {
        _controller._setPlatformBrightness(brightness);
      }
    };

    super.initState();
  }

  @override
  void dispose() {
    SingletonFlutterWindow window = WidgetsBinding.instance.window;

    _controller?.dispose();
    window.onPlatformBrightnessChanged = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.window;

    return _InheritedThemeResolver(
      data: this,
      child: StreamBuilder<AppThemeData>(
          initialData: _controller.currentTheme,
          stream: _controller._themesStream,
          builder: (context, snapshot) {
            return AnimatedAppTheme(
              data: snapshot.data,
              child: widget.child,
            );
          }),
    );
  }
}

class _InheritedThemeResolver extends InheritedWidget {
  final _AppThemeResolverState _data;

  const _InheritedThemeResolver({
    Key key,
    Widget child,
    _AppThemeResolverState data,
  })  : _data = data,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedThemeResolver oldWidget) =>
      _data != oldWidget._data;
}
