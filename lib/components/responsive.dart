import 'package:flutter/widgets.dart';

class ResponsiveValue<T> {
  static double extraSmallBreakpoint = 480;
  static double smallBreakpoint = 560;
  static double largeBreakpoint = 1200;

  const ResponsiveValue({
    this.extraSmall,
    required this.small,
    this.medium,
    this.large,
  });

  final T? extraSmall;
  final T small;
  final T? medium;
  final T? large;

  T get(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    if (screenWidth < extraSmallBreakpoint) return extraSmall ?? small;
    if (screenWidth < smallBreakpoint) return small;
    if (screenWidth > largeBreakpoint) return large ?? medium ?? small;
    return medium ?? small;
  }
}

class Responsive extends StatelessWidget {
  Responsive({
    Key? key,
    Widget? extraSmall,
    required Widget small,
    Widget? medium,
    Widget? large,
  })  : _responsiveValue = ResponsiveValue<Widget>(
          extraSmall: extraSmall,
          small: small,
          medium: medium,
          large: large,
        ),
        super(key: key);

  final ResponsiveValue<Widget> _responsiveValue;

  @override
  Widget build(BuildContext context) => _responsiveValue.get(context);
}
