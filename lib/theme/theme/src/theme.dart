// @dart=2.9
library app_theme;

import 'package:flutter/widgets.dart';
import 'theme_data/theme_data.dart';

class AppTheme extends StatelessWidget {
  final AppThemeData data;
  final Widget child;

  const AppTheme._({
    Key key,
    @required this.data,
    @required this.child,
  })  : assert(child != null),
        assert(data != null),
        super(key: key);

  static AppThemeData of(BuildContext context) {
    final _InheritedTheme inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedTheme>();
    return inheritedTheme.theme.data;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedTheme(
      theme: this,
      child: child,
    );
  }
}

class _InheritedTheme extends InheritedWidget {
  final AppTheme theme;

  const _InheritedTheme({
    Key key,
    Widget child,
    this.theme,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedTheme oldWidget) =>
      oldWidget.theme.data != theme.data;
}

class AnimatedAppTheme extends ImplicitlyAnimatedWidget {
  final AppThemeData data;
  final Widget child;

  const AnimatedAppTheme({
    Key key,
    @required this.data,
    Curve curve = Curves.linear,
    Duration duration = const Duration(milliseconds: 500),
    VoidCallback onEnd,
    @required this.child,
  })  : assert(child != null),
        assert(data != null),
        super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  @override
  _AnimatedAppThemeState createState() => _AnimatedAppThemeState();
}

class _AnimatedAppThemeState extends AnimatedWidgetBaseState<AnimatedAppTheme> {
  AppThemeDataTween _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(
      _data,
      widget.data,
      (dynamic value) => AppThemeDataTween(begin: value as AppThemeData),
    );

    assert(_data != null);
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme._(
      child: widget.child,
      data: _data.evaluate(animation),
    );
  }
}
