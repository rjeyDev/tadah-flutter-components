// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//@dart = 2.9
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

/// A material design tooltip.
///
/// Tooltips provide text labels which help explain the function of a button or
/// other user interface action. Wrap the button in a [Tooltip] widget and provide
/// a message which will be shown when the widget is long pressed.
///
/// Many widgets, such as [IconButton], [FloatingActionButton], and
/// [PopupMenuButton] have a `tooltip` property that, when non-null, causes the
/// widget to include a [Tooltip] in its build.
///
/// Tooltips improve the accessibility of visual widgets by proving a textual
/// representation of the widget, which, for example, can be vocalized by a
/// screen reader.
///
/// {@youtube 560 315 https://www.youtube.com/watchv=EeEfD5fI-5Q}
///
/// {@tool dartpad --template=stateless_widget_scaffold_center}
///
/// This example show a basic [Tooltip] which has a [Text] as child.
/// [message] contains your label to be shown by the tooltip when
/// the child that Tooltip wraps is hovered over on web or desktop. On mobile,
/// the tooltip is shown when the widget is long pressed.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return const Tooltip(
///     message: 'I am a Tooltip',
///     child: Text('Hover over the text to show a tooltip.'),
///   );
/// }
/// ```
/// {@end-tool}
///
/// {@tool dartpad --template=stateless_widget_scaffold_center}
///
/// This example covers most of the attributes available in Tooltip.
/// `decoration` has been used to give a gradient and borderRadius to Tooltip.
/// `height` has been used to set a specific height of the Tooltip.
/// `preferBelow` is false, the tooltip will prefer showing above [Tooltip]'s child widget.
/// However, it may show the tooltip below if there's not enough space
/// above the widget.
/// `textStyle` has been used to set the font size of the 'message'.
/// `showDuration` accepts a Duration to continue showing the message after the long
/// press has been released.
/// `waitDuration` accepts a Duration for which a mouse pointer has to hover over the child
/// widget before the tooltip is shown.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Tooltip(
///     message: 'I am a Tooltip',
///     child: const Text('Tap this text and hold down to show a tooltip.'),
///     decoration: BoxDecoration(
///       borderRadius: BorderRadius.circular(25),
///       gradient: const LinearGradient(colors: <Color>[Colors.amber, Colors.red]),
///     ),
///     height: 50,
///     padding: const EdgeInsets.all(8.0),
///     preferBelow: false,
///     textStyle: const TextStyle(
///       fontSize: 24,
///     ),
///     showDuration: const Duration(seconds: 2),
///     waitDuration: const Duration(seconds: 1),
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * <https://material.io/design/components/tooltips.html>
///  * [TooltipTheme] or [ThemeData.tooltipTheme]
class AppTooltip extends StatefulWidget {
  /// Creates a tooltip.
  ///
  /// By default, tooltips should adhere to the
  /// [Material specification](https://material.io/design/components/tooltips.html#spec).
  /// If the optional constructor parameters are not defined, the values
  /// provided by [TooltipTheme.of] will be used if a [TooltipTheme] is present
  /// or specified in [ThemeData].
  ///
  /// All parameters that are defined in the constructor will
  /// override the default values _and_ the values in [TooltipTheme.of].
  const AppTooltip({
    Key key,
    this.title,
    this.subtitle,
    this.icon,
    this.content,
    this.height,
    this.maxWidth,
    this.padding,
    this.margin,
    this.verticalOffset,
    this.preferBelow,
    this.excludeFromSemantics,
    this.decoration,
    this.waitDuration,
    this.showDuration,
    this.child,
  }) : super(key: key);

  /// The text to display in the tooltip.
  final String title;
  final String subtitle;
  final Widget icon;
  final Widget content;

  /// The height of the tooltip's [child].
  ///
  /// If the [child] is null, then this is the tooltip's intrinsic height.
  final double height;
  final double maxWidth;

  /// The amount of space by which to inset the tooltip's [child].
  ///
  /// Defaults to 16.0 logical pixels in each direction.
  final EdgeInsetsGeometry padding;

  /// The empty space that surrounds the tooltip.
  ///
  /// Defines the tooltip's outer [Container.margin]. By default, a
  /// long tooltip will span the width of its window. If long enough,
  /// a tooltip might also span the window's height. This property allows
  /// one to define how much space the tooltip must be inset from the edges
  /// of their display window.
  ///
  /// If this property is null, then [TooltipThemeData.margin] is used.
  /// If [TooltipThemeData.margin] is also null, the default margin is
  /// 0.0 logical pixels on all sides.
  final EdgeInsetsGeometry margin;

  /// The vertical gap between the widget and the displayed tooltip.
  ///
  /// When [preferBelow] is set to true and tooltips have sufficient space to
  /// display themselves, this property defines how much vertical space
  /// tooltips will position themselves under their corresponding widgets.
  /// Otherwise, tooltips will position themselves above their corresponding
  /// widgets with the given offset.
  final double verticalOffset;

  /// Whether the tooltip defaults to being displayed below the widget.
  ///
  /// Defaults to true. If there is insufficient space to display the tooltip in
  /// the preferred direction, the tooltip will be displayed in the opposite
  /// direction.
  final bool preferBelow;

  /// Whether the tooltip's [message] should be excluded from the semantics
  /// tree.
  ///
  /// Defaults to false. A tooltip will add a [Semantics] label that is set to
  /// [Tooltip.message]. Set this property to true if the app is going to
  /// provide its own custom semantics label.
  final bool excludeFromSemantics;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// Specifies the tooltip's shape and background color.
  ///
  /// The tooltip shape defaults to a rounded rectangle with a border radius of
  /// 4.0. Tooltips will also default to an opacity of 90% and with the color
  /// [Colors.grey[700]] if [ThemeData.brightness] is [Brightness.dark], and
  /// [Colors.white] if it is [Brightness.light].
  final Decoration decoration;

  /// The style to use for the message of the tooltip.
  ///
  /// If null, the message's [TextStyle] will be determined based on
  /// [ThemeData]. If [ThemeData.brightness] is set to [Brightness.dark],
  /// [TextTheme.bodyText2] of [ThemeData.textTheme] will be used with
  /// [Colors.white]. Otherwise, if [ThemeData.brightness] is set to
  /// [Brightness.light], [TextTheme.bodyText2] of [ThemeData.textTheme] will be
  /// used with [Colors.black].

  /// The length of time that a pointer must hover over a tooltip's widget
  /// before the tooltip will be shown.
  ///
  /// Once the pointer leaves the widget, the tooltip will immediately
  /// disappear.
  ///
  /// Defaults to 0 milliseconds (tooltips are shown immediately upon hover).
  final Duration waitDuration;

  /// The length of time that the tooltip will be shown after a long press
  /// is released.
  ///
  /// Defaults to 1.5 seconds.
  final Duration showDuration;

  @override
  _TooltipState createState() => _TooltipState();
}

class _TooltipState extends State<AppTooltip>
    with SingleTickerProviderStateMixin {
  static const double _defaultVerticalOffset = 24.0;
  static const bool _defaultPreferBelow = true;
  static const EdgeInsetsGeometry _defaultMargin = EdgeInsets.zero;
  static const Duration _fadeInDuration = Duration(milliseconds: 150);
  static const Duration _fadeOutDuration = Duration(milliseconds: 75);
  static const Duration _defaultShowDuration = Duration(milliseconds: 1500);
  static const Duration _defaultWaitDuration = Duration.zero;
  static const bool _defaultExcludeFromSemantics = false;

  double height;
  EdgeInsetsGeometry padding;
  EdgeInsetsGeometry margin;
  Decoration decoration;
  TextStyle textStyle;
  double verticalOffset;
  bool preferBelow;
  bool excludeFromSemantics;
  AnimationController _controller;
  OverlayEntry _entry;
  Timer _hideTimer;
  Timer _showTimer;
  Duration showDuration;
  Duration waitDuration;
  bool _mouseIsConnected;
  bool _longPressActivated = false;

  @override
  void initState() {
    super.initState();
    _mouseIsConnected = RendererBinding.instance.mouseTracker.mouseIsConnected;
    _controller = AnimationController(
      duration: _fadeInDuration,
      reverseDuration: _fadeOutDuration,
      vsync: this,
    )..addStatusListener(_handleStatusChanged);
    // Listen to see when a mouse is added.
    RendererBinding.instance.mouseTracker
        .addListener(_handleMouseTrackerChange);
    // Listen to global pointer events so that we can hide a tooltip immediately
    // if some other control is clicked on.
    GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
  }

  // https://material.io/components/tooltips#specs
  double _getDefaultTooltipHeight() {
    return 32.0;
  }

  EdgeInsets _getDefaultPadding() {
    return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
  }

  // Forces a rebuild if a mouse has been added or removed.
  void _handleMouseTrackerChange() {
    if (!mounted) {
      return;
    }
    final bool mouseIsConnected =
        RendererBinding.instance.mouseTracker.mouseIsConnected;
    if (mouseIsConnected != _mouseIsConnected) {
      setState(() {
        _mouseIsConnected = mouseIsConnected;
      });
    }
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      _hideTooltip(immediately: true);
    }
  }

  void _hideTooltip({bool immediately = false}) {
    _showTimer?.cancel();
    _showTimer = null;
    if (immediately) {
      _removeEntry();
      return;
    }
    if (_longPressActivated) {
      // Tool tips activated by long press should stay around for the showDuration.
      _hideTimer ??= Timer(showDuration, _controller.reverse);
    } else {
      // Tool tips activated by hover should disappear as soon as the mouse
      // leaves the control.
      _controller.reverse();
    }
    _longPressActivated = false;
  }

  void _showTooltip({bool immediately = false}) {
    _hideTimer?.cancel();
    _hideTimer = null;
    if (immediately) {
      ensureTooltipVisible();
      return;
    }
    _showTimer ??= Timer(waitDuration, ensureTooltipVisible);
  }

  /// Shows the tooltip if it is not already visible.
  ///
  /// Returns `false` when the tooltip was already visible or if the context has
  /// become null.
  bool ensureTooltipVisible() {
    _showTimer?.cancel();
    _showTimer = null;
    if (_entry != null) {
      // Stop trying to hide, if we were.
      _hideTimer?.cancel();
      _hideTimer = null;
      _controller.forward();
      return false; // Already visible.
    }
    _createNewEntry();
    _controller.forward();
    return true;
  }

  void _createNewEntry() {
    final OverlayState overlayState = Overlay.of(
      context,
      debugRequiredFor: widget,
    );

    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset target = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState.context.findRenderObject(),
    );

    // We create this widget outside of the overlay entry's builder to prevent
    // updated values from happening to leak into the overlay when the overlay
    // rebuilds.
    final Widget overlay = Directionality(
      textDirection: Directionality.of(context),
      child: _TooltipOverlay(
        title: widget.title,
        subtitle: widget.subtitle,
        icon: widget.icon,
        child: widget.content,
        height: height,
        maxWidth: widget.maxWidth,
        padding: padding,
        margin: margin,
        decoration: decoration,
        animation: CurvedAnimation(
          parent: _controller,
          curve: Curves.fastOutSlowIn,
        ),
        target: target,
        verticalOffset: verticalOffset,
        preferBelow: preferBelow,
      ),
    );
    _entry = OverlayEntry(builder: (BuildContext context) => overlay);
    overlayState.insert(_entry);
    // SemanticsService.tooltip(widget.title);
  }

  void _removeEntry() {
    _hideTimer?.cancel();
    _hideTimer = null;
    _showTimer?.cancel();
    _showTimer = null;
    _entry?.remove();
    _entry = null;
  }

  void _handlePointerEvent(PointerEvent event) {
    if (_entry == null) {
      return;
    }
    if (event is PointerUpEvent || event is PointerCancelEvent) {
      _hideTooltip();
    } else if (event is PointerDownEvent) {
      _hideTooltip(immediately: true);
    }
  }

  @override
  void deactivate() {
    if (_entry != null) {
      _hideTooltip(immediately: true);
    }
    _showTimer?.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter
        .removeGlobalRoute(_handlePointerEvent);
    RendererBinding.instance.mouseTracker
        .removeListener(_handleMouseTrackerChange);
    if (_entry != null) _removeEntry();
    _controller.dispose();
    super.dispose();
  }

  void _handleLongPress() {
    _longPressActivated = true;
    final bool tooltipCreated = ensureTooltipVisible();
    if (tooltipCreated) Feedback.forLongPress(context);
  }

  @override
  Widget build(BuildContext context) {
    assert(Overlay.of(context, debugRequiredFor: widget) != null);

    BoxDecoration defaultDecoration;
    defaultDecoration = BoxDecoration(
      color: AppColors.BLACK,
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
    );

    height = widget.height ?? _getDefaultTooltipHeight();
    padding = widget.padding ?? _getDefaultPadding();
    margin = widget.margin ?? _defaultMargin;
    verticalOffset = widget.verticalOffset ?? _defaultVerticalOffset;
    preferBelow = widget.preferBelow ?? _defaultPreferBelow;
    excludeFromSemantics =
        widget.excludeFromSemantics ?? _defaultExcludeFromSemantics;
    decoration = widget.decoration ?? defaultDecoration;
    waitDuration = widget.waitDuration ?? _defaultWaitDuration;
    showDuration = widget.showDuration ?? _defaultShowDuration;

    Widget result = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: _handleLongPress,
      excludeFromSemantics: true,
      child: Semantics(
        label: excludeFromSemantics ? null : widget.title,
        child: widget.child,
      ),
    );

    // Only check for hovering if there is a mouse connected.
    if (_mouseIsConnected) {
      result = MouseRegion(
        onEnter: (PointerEnterEvent event) {
          _showTooltip();
        },
        onExit: (PointerExitEvent event) => _hideTooltip(),
        child: result,
      );
    }

    return result;
  }
}

/// A delegate for computing the layout of a tooltip to be displayed above or
/// bellow a target specified in the global coordinate system.
class _TooltipPositionDelegate extends SingleChildLayoutDelegate {
  /// Creates a delegate for computing the layout of a tooltip.
  ///
  /// The arguments must not be null.
  _TooltipPositionDelegate({
    @required this.target,
    @required this.verticalOffset,
    @required this.preferBelow,
  })  : assert(target != null),
        assert(verticalOffset != null),
        assert(preferBelow != null);

  /// The offset of the target the tooltip is positioned near in the global
  /// coordinate system.
  final Offset target;

  /// The amount of vertical distance between the target and the displayed
  /// tooltip.
  final double verticalOffset;

  /// Whether the tooltip is displayed below its widget by default.
  ///
  /// If there is insufficient space to display the tooltip in the preferred
  /// direction, the tooltip will be displayed in the opposite direction.
  final bool preferBelow;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return positionDependentBox(
      size: size,
      childSize: childSize,
      target: target,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
    );
  }

  @override
  bool shouldRelayout(_TooltipPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        verticalOffset != oldDelegate.verticalOffset ||
        preferBelow != oldDelegate.preferBelow;
  }
}

class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    Key key,
    @required this.height,
    this.maxWidth,
    this.title,
    this.subtitle,
    this.icon,
    this.child,
    this.padding,
    this.margin,
    this.decoration,
    @required this.animation,
    @required this.target,
    @required this.verticalOffset,
    @required this.preferBelow,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Widget icon;
  final Widget child;
  final double height;
  final double maxWidth;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Decoration decoration;
  final Animation<double> animation;
  final Offset target;
  final double verticalOffset;
  final bool preferBelow;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.TRANSPARENT,
      child: Positioned.fill(
        child: IgnorePointer(
          child: CustomSingleChildLayout(
            delegate: _TooltipPositionDelegate(
              target: target,
              verticalOffset: verticalOffset,
              preferBelow: preferBelow,
            ),
            child: FadeTransition(
              opacity: animation,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: Container(
                  decoration: decoration,
                  constraints: BoxConstraints(
                    maxWidth: maxWidth ?? double.infinity,
                  ),
                  padding: padding != null
                      ? padding
                      : EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: margin,
                  child: Center(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 3.0),
                                child: icon,
                              ),
                            if (title != null)
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.TEXT_PRIMARY_DARK,
                                ),
                              ),
                          ],
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.TEXT_SECONDARY_DARK,
                            ),
                          ),
                        if (child != null) child,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
