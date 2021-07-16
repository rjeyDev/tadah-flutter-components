// @dart=2.9

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:tadah_flutter_components/theme/app_colors.dart';
import 'package:tadah_flutter_components/theme/theme/src/theme.dart';

class CommonLoader extends StatefulWidget {
  static const Curve curve = Curves.linear;
  static const double _pullToRefreshLoaderSize = 18.0;

  // static Tween<Offset> _refreshIndicatorOffsetTween = Tween<Offset>(
  //   begin: const Offset(0, -10),
  //   end: const Offset(0, 0),
  // );

  static Widget buildRefreshIndicator(
    BuildContext context,
    RefreshIndicatorMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
  ) {
    final double percentageComplete =
        (pulledExtent / refreshTriggerPullDistance).clamp(0.0, 1.0);
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            top: 16.0,
            left: 0.0,
            right: 0.0,
            child: _buildIndicatorForRefreshState(
                refreshState, percentageComplete),
          ),
        ],
      ),
    );
  }

  static Widget _buildIndicatorForRefreshState(
    RefreshIndicatorMode refreshState,
    double percentageComplete,
  ) {
    const Curve intervalCurve = Interval(0.025, 0.40, curve: Curves.easeInOut);
    switch (refreshState) {
      case RefreshIndicatorMode.drag:
        return Opacity(
          opacity: intervalCurve.transform(percentageComplete),
          child: CommonLoader.partialAppear(
            size: _pullToRefreshLoaderSize *
                (0.4 + percentageComplete).clamp(0, 1),
            arcLengthPercent: percentageComplete,
          ),
        );
      case RefreshIndicatorMode.armed:
      case RefreshIndicatorMode.refresh:
        // Once we're armed or performing the refresh, we just show the normal spinner.
        return CommonLoader(size: _pullToRefreshLoaderSize);
      case RefreshIndicatorMode.done:
        // When the user lets go, the standard transition is to shrink the spinner.
        return Opacity(
          opacity: intervalCurve.transform(percentageComplete),
          child:
              CommonLoader(size: _pullToRefreshLoaderSize * percentageComplete),
        );
      case RefreshIndicatorMode.inactive:
        // Anything else doesn't show anything.
        return SizedBox();
    }
    return SizedBox();
  }

  static Widget imageLoadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent loadingProgress,
  ) {
    if (loadingProgress == null) return child;
    return Center(
      child: CommonLoader(
        size: 36.0,
      ),
    );
  }

  const CommonLoader.partialAppear({
    Key key,
    this.inverse = false,
    this.inverseController,
    this.size = 35.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 800),
    this.controller,
    this.arcLengthPercent = 1,
  })  : assert(inverse != null),
        assert(size != null),
        active = false,
        super(key: key);

  const CommonLoader({
    Key key,
    this.inverse = false,
    this.inverseController,
    this.size = 35.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 800),
    this.controller,
  })  : assert(inverse != null),
        assert(size != null),
        active = true,
        arcLengthPercent = 1.0,
        super(key: key);

  final bool inverse;
  final Animation<double> inverseController;
  final double size;
  final IndexedWidgetBuilder itemBuilder;
  final Duration duration;
  final AnimationController controller;

  final bool active;
  final double arcLengthPercent;

  @override
  _CommonLoaderState createState() => _CommonLoaderState();
}

class _CommonLoaderState extends State<CommonLoader>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _curvedAnimation;
  Animation<double> _offsetAnimation;

  Animation<Color> _circleColorAnimation;
  Animation<Color> _arcColorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(_animationListener);

    if (widget.active) _animationController.repeat();

    _curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: CommonLoader.curve,
    );

    _offsetAnimation = Tween<double>(
      begin: 0,
      end: pi * 2,
    ).animate(_curvedAnimation);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (widget.inverseController != null) {
      _circleColorAnimation = ColorTween(
        begin: widget.inverse
            ? AppColors.WHITE.withOpacity(0.3)
            : AppTheme.of(context).accentMain.withOpacity(0.3),
        end: widget.inverse
            ? AppTheme.of(context).accentMain.withOpacity(0.3)
            : AppColors.WHITE.withOpacity(0.3),
      ).animate(widget.inverseController);

      _arcColorAnimation = ColorTween(
        begin:
            widget.inverse ? AppColors.WHITE : AppTheme.of(context).accentMain,
        end: widget.inverse ? AppTheme.of(context).accentMain : AppColors.WHITE,
      ).animate(widget.inverseController);
    }
    super.didChangeDependencies();
  }

  void _animationListener() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Center(
          child: CustomPaint(
            size: Size(
              widget.size,
              widget.size,
            ),
            painter: _IndicatorPainter(
              arcLengthPercent: widget.arcLengthPercent,
              offset: _offsetAnimation.value,
              circleColor: widget.inverseController != null
                  ? _circleColorAnimation.value
                  : widget.inverse
                      ? AppColors.WHITE.withOpacity(0.3)
                      : AppTheme.of(context).accentMain.withOpacity(0.3),
              arcColor: widget.inverseController != null
                  ? _arcColorAnimation.value
                  : widget.inverse
                      ? AppColors.WHITE
                      : AppTheme.of(context).accentMain,
            ),
          ),
        ),
      ),
    );
  }
}

class _IndicatorPainter extends CustomPainter {
  static const double arcLength = pi / 2;

  _IndicatorPainter({
    this.arcLengthPercent,
    this.offset,
    this.arcColor,
    this.circleColor,
  });

  final double arcLengthPercent;
  final double offset;
  final Color arcColor;
  final Color circleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width / 8;

    final Rect drawingRect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    final Paint paintAcr = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final Paint paintCircle = Paint()
      ..color = circleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paintCircle,
    );

    canvas.drawArc(
      drawingRect,
      pi + offset,
      arcLength * arcLengthPercent,
      null,
      paintAcr,
    );
  }

  @override
  bool shouldRepaint(_IndicatorPainter oldDelegate) {
    return oldDelegate.offset != offset ||
        oldDelegate.circleColor != circleColor ||
        oldDelegate.arcColor != arcColor;
  }
}
