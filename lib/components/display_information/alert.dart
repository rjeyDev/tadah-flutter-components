//@dart=2.9
import 'package:flutter/widgets.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

/// Displays a widget that will be passed to [child] parameter above the current
/// contents of the app, with transition animation
///
/// The [child] argument is used to pass widget that you want to show
///
/// The [showOutAnimationDuration] argument is used to specify duration of
/// enter transition
///
/// The [hideOutAnimationDuration] argument is used to specify duration of
/// exit transition
///
/// The [displayDuration] argument is used to specify duration displaying
///
/// The [additionalTopPadding] argument is used to specify amount of top
/// padding that will be added for SafeArea values
///
/// The [onTap] callback of [Alert]
///
/// The [overlayState] argument is used to add specific overlay state.
/// If you will not pass it, it will try to get the current overlay state from
/// passed [BuildContext]

enum AlertAlignment {
  left,
  right,
}

void showAlert(
  BuildContext context,
  Widget child, {
  AlertAlignment alignment,
  Duration showOutAnimationDuration = const Duration(milliseconds: 500),
  Duration hideOutAnimationDuration = const Duration(milliseconds: 400),
  Duration displayDuration = const Duration(milliseconds: 3000),
  double additionalTopPadding = 16.0,
  VoidCallback onTap,
  OverlayState overlayState,
  double width,
}) async {
  overlayState ??= Overlay.of(context);
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) {
      return Alert(
        child: child,
        alignment: alignment,
        onDismissed: () => overlayEntry.remove(),
        showOutAnimationDuration: showOutAnimationDuration,
        hideOutAnimationDuration: hideOutAnimationDuration,
        displayDuration: displayDuration,
        additionalTopPadding: additionalTopPadding,
        onTap: onTap,
        width: width,
      );
    },
  );

  overlayState?.insert(overlayEntry);
}

/// Widget that controls all animations
class Alert extends StatefulWidget {
  final Widget child;
  final AlertAlignment alignment;
  final VoidCallback onDismissed;
  final showOutAnimationDuration;
  final hideOutAnimationDuration;
  final displayDuration;
  final additionalTopPadding;
  final VoidCallback onTap;
  final double width;

  Alert({
    Key key,
    @required this.child,
    @required this.alignment,
    @required this.onDismissed,
    @required this.showOutAnimationDuration,
    @required this.hideOutAnimationDuration,
    @required this.displayDuration,
    @required this.additionalTopPadding,
    @required this.width,
    this.onTap,
  }) : super(key: key);

  @override
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<Alert> with SingleTickerProviderStateMixin {
  Animation offsetAnimation;
  AnimationController animationController;
  double topPosition;

  @override
  void initState() {
    topPosition = widget.additionalTopPadding;
    _setupAndStartAnimation();
    super.initState();
  }

  void _setupAndStartAnimation() async {
    animationController = AnimationController(
      vsync: this,
      duration: widget.showOutAnimationDuration,
      reverseDuration: widget.hideOutAnimationDuration,
    );

    Tween<Offset> offsetTween = Tween<Offset>(
      begin: Offset(0.0, -1.0),
      end: Offset(0.0, 0.0),
    );

    offsetAnimation = offsetTween.animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.linearToEaseOut,
      ),
    )..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await Future.delayed(widget.displayDuration);
          animationController.reverse();
          if (mounted) {
            setState(() {
              topPosition = 0;
            });
          }
        }

        if (status == AnimationStatus.dismissed) {
          widget.onDismissed.call();
        }
      });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: widget.hideOutAnimationDuration * 1.5,
      curve: Curves.linearToEaseOut,
      top: topPosition,
      left: (widget.alignment == AlertAlignment.left || widget.width == null)
          ? 0
          : null,
      right: (widget.alignment == AlertAlignment.right || widget.width == null)
          ? 0
          : null,
      child: SlideTransition(
        position: offsetAnimation as Animation<Offset>,
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              widget.onTap?.call();
              animationController.reverse();
            },
            child: SizedBox(
              width: widget.width,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Popup widget that you can use by default to show some information
class CustomAlert extends StatefulWidget {
  final String message;
  final Widget icon;
  final TextStyle textStyle;

  const CustomAlert({
    Key key,
    @required this.message,
    this.icon,
    this.textStyle = AppTextStyles.SECONDARY,
  });

  @override
  _CustomAlertState createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 40),
      color: AppColors.RED_PIGMENT_500,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  if (widget.icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: widget.icon,
                    ),
                  Flexible(
                    flex: 1,
                    child: Text(
                      widget.message,
                      style: widget.textStyle ?? AppTextStyles.SECONDARY,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              AppIcons.x_mini,
              color: AppColors.TEXT_SECONDARY_DARK,
            ),
          ],
        ),
      ),
    );
  }
}
