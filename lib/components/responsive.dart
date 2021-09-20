import 'package:flutter/widgets.dart';

class ResponsiveValue<T> {
  static double smallBreakpoint = 480;
  static double largeBreakpoint = 1200;

  const ResponsiveValue({
    required this.small,
    this.medium,
    this.large,
  });

  final T small;
  final T? medium;
  final T? large;

  T get(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    if (screenWidth < smallBreakpoint) return small;
    if (screenWidth > largeBreakpoint) return medium ?? small;
    return large ?? medium ?? small;
  }
}

class Responsive extends StatelessWidget {
  Responsive({
    Key? key,
    required Widget small,
    Widget? medium,
    Widget? large,
  })  : _responsiveValue = ResponsiveValue<Widget>(
          small: small,
          medium: medium,
          large: large,
        ),
        super(key: key);

  final ResponsiveValue<Widget> _responsiveValue;

  @override
  Widget build(BuildContext context) {
    return _responsiveValue.get(context);
  }
}
