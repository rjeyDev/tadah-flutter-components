//@dart=2.9
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

class TimePicker extends StatefulWidget {
  final String label;
  final String helpText;
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onChanged;
  final FocusNode focusNode;
  final Function(String) validator;
  final Widget prefix;

  TimePicker({
    Key key,
    this.onChanged,
    this.initialTime,
    this.focusNode,
    this.prefix,
    this.label,
    this.helpText,
    this.validator,
  }) : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();

  static _TimePickerState of(BuildContext context) =>
      context.findAncestorStateOfType<_TimePickerState>();
}

class _TimePickerState extends State<TimePicker>
    with SingleTickerProviderStateMixin {
  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  TextEditingController textController = TextEditingController();
  Animation<double> animation;
  AnimationController controller;
  bool hovered = false;
  FocusNode _focusNode;
  bool get disabled => widget.onChanged == null;
  TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    textController.text = '';
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0, end: 0.5).animate(controller);
    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        RenderBox renderBox = context.findRenderObject();
        var size = renderBox.size;
        return TimeSelect(
          layerLink: _layerLink,
          size: size,
          select: selectTime,
        );
      },
    );

    _focusNode.addListener(() {
      if (!disabled) {
        if (_focusNode.hasFocus) {
          Overlay.of(context).insert(_overlayEntry);
          controller.forward();
        } else {
          _overlayEntry.remove();
          refreshOverlayEntry();
          controller.reverse();
        }

        setState(() {});
      }
    });
  }

  void refreshOverlayEntry() {
    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        RenderBox renderBox = context.findRenderObject();
        var size = renderBox.size;
        return TimeSelect(
          layerLink: _layerLink,
          size: size,
          select: selectTime,
        );
      },
    );
  }

  void selectTime(TimeOfDay time) {
    widget.onChanged(time);
    selectedTime = time;
    textController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    // DropdownButton(items: []);
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          if (!disabled)
            setState(() {
              hovered = true;
            });
        },
        onExit: (event) {
          if (!disabled)
            setState(() {
              hovered = false;
            });
        },
        child: Theme(
          data: ThemeData(
              colorScheme: ColorScheme.light(
            primary: AppColors.BLACK,
          )),
          child: GestureDetector(
            onTap: () {
              if (!disabled) {
                if (_focusNode.hasFocus)
                  _focusNode.unfocus();
                else
                  _focusNode.requestFocus();
              }
            },
            child: Container(
              color: Colors.transparent,
              child: IgnorePointer(
                child: TextFormField(
                  focusNode: _focusNode,
                  readOnly: true,
                  validator: widget.validator,
                  enabled: !disabled,
                  showCursor: false,
                  onTap: () {},
                  controller: textController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 12),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: hovered
                              ? AppColors.BLACK_38_WO
                              : AppColors.BLACK_8_WO,
                          width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: hovered
                              ? AppColors.BLACK_38_WO
                              : AppColors.BLACK_8_WO,
                          width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.RED_PIGMENT_500, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.ACCENT_MAIN, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.BLACK_8_WO, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.RED_PIGMENT_500, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: RotationTransition(
                      turns: animation,
                      child: Icon(
                        AppIcons.caret_down_mini,
                        color: _focusNode.hasFocus
                            ? AppColors.ACCENT_MAIN
                            : AppColors.BLACK_38_WO,
                      ),
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: widget.prefix ?? Icon(AppIcons.calendar),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 16,
                      maxHeight: 50,
                    ),
                    labelText: widget.label,
                    helperText: widget.helpText,
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

class TimeSelect extends StatefulWidget {
  final LayerLink layerLink;
  final Size size;

  final Function(TimeOfDay) select;
  TimeSelect({
    this.size,
    this.layerLink,
    this.select,
    Key key,
  }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<TimeSelect> with TickerProviderStateMixin {
  AnimationController controllerM;
  Animation<double> animationM;
  AnimationController controllerY;
  Animation<double> animationY;

  @override
  void initState() {
    super.initState();

    controllerM =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animationM = Tween<double>(begin: 0, end: 0.5).animate(controllerM);
    controllerY =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animationY = Tween<double>(begin: 0, end: 0.5).animate(controllerY);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: 180,
      height: 60,
      child: CompositedTransformFollower(
        link: widget.layerLink,
        showWhenUnlinked: false,
        offset: Offset(0.0, widget.size.height + 8.0),
        child: Material(
          color: AppColors.WHITE,
          elevation: 3,
          shadowColor: AppColors.SHADOW_24_LIGHT,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hours',
                      style: TextStyle(
                        color: AppColors.TEXT_SECONDARY_LIGHT,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '16',
                      style: TextStyle(
                        color: AppColors.TEXT_PRIMARY_LIGHT,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(AppIcons.caret_up_mini,
                        size: 16, color: AppColors.ACCENT_MAIN),
                    Icon(AppIcons.caret_down_mini,
                        size: 16, color: AppColors.ACCENT_MAIN),
                  ],
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: AppColors.BLACK_8_WO,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Minutes',
                      style: TextStyle(
                        color: AppColors.TEXT_SECONDARY_LIGHT,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '30',
                      style: TextStyle(
                        color: AppColors.TEXT_PRIMARY_LIGHT,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(AppIcons.caret_up_mini,
                        size: 16, color: AppColors.ACCENT_MAIN),
                    Icon(AppIcons.caret_down_mini,
                        size: 16, color: AppColors.ACCENT_MAIN),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
