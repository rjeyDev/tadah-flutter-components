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
    selectTime(widget.initialTime ?? TimeOfDay.now());
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
          initialTime: selectedTime,
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
          initialTime: selectedTime,
          select: selectTime,
        );
      },
    );
  }

  void selectTime(TimeOfDay time) {
    widget.onChanged(time);
    selectedTime = time;
    textController.text = (time.hour < 10 ? '0' : '') +
        time.hour.toString() +
        ' : ' +
        (time.minute < 10 ? '0' : '') +
        time.minute.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.TRANSPARENT,
      child: CompositedTransformTarget(
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
                        borderSide: BorderSide(
                            color: AppColors.ACCENT_MAIN, width: 1.5),
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
                        child: widget.prefix ?? Icon(AppIcons.clock),
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
      ),
    );
  }
}

class TimeSelect extends StatefulWidget {
  final LayerLink layerLink;
  final Size size;
  final TimeOfDay initialTime;
  final Function(TimeOfDay) select;

  TimeSelect({
    this.size,
    this.initialTime,
    this.layerLink,
    this.select,
    Key key,
  }) : super(key: key);

  @override
  _TimeSelectState createState() => _TimeSelectState();
}

class _TimeSelectState extends State<TimeSelect> with TickerProviderStateMixin {
  AnimationController controllerM;
  Animation<double> animationM;
  AnimationController controllerY;
  Animation<double> animationY;
  TextEditingController hourController;
  TextEditingController minuteController;
  int hour;
  int minute;

  @override
  void initState() {
    super.initState();
    hour = widget.initialTime.hour;
    minute = widget.initialTime.minute;
    hourController =
        TextEditingController(text: (hour < 10 ? '0' : '') + hour.toString());
    minuteController = TextEditingController(
        text: (minute < 10 ? '0' : '') + minute.toString());

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
                      hourController.text,
                      style: TextStyle(
                        color: AppColors.TEXT_PRIMARY_LIGHT,
                        fontSize: 16,
                      ),
                    ),
                    // SizedBox(
                    //   width: 50,
                    //   height: 25,
                    //   child: TextFormField(
                    //     controller: hourController,
                    //     style: TextStyle(
                    //       color: AppColors.TEXT_PRIMARY_LIGHT,
                    //       fontSize: 16,
                    //     ),
                    //     decoration: InputDecoration(
                    //       contentPadding: EdgeInsets.zero,
                    //       border: InputBorder.none,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    iconButton(() {
                      setState(() {
                        if (hour < 23)
                          hour++;
                        else
                          hour = 0;
                        hourController.text =
                            (hour < 10 ? '0' : '') + hour.toString();
                        widget.select(TimeOfDay(hour: hour, minute: minute));
                      });
                    }, AppIcons.caret_up_mini),
                    iconButton(() {
                      setState(() {
                        if (hour > 0)
                          hour--;
                        else
                          hour = 23;
                        hourController.text =
                            (hour < 10 ? '0' : '') + hour.toString();
                        widget.select(TimeOfDay(hour: hour, minute: minute));
                      });
                    }, AppIcons.caret_down_mini),
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
                      minuteController.text,
                      style: TextStyle(
                        color: AppColors.TEXT_PRIMARY_LIGHT,
                        fontSize: 16,
                      ),
                    ),
                    // SizedBox(
                    //   width: 50,
                    //   height: 25,
                    //   child: TextFormField(
                    //     controller: minuteController,
                    //     autofocus: true,
                    //     style: TextStyle(
                    //       color: AppColors.TEXT_PRIMARY_LIGHT,
                    //       fontSize: 16,
                    //     ),
                    //     decoration: InputDecoration(
                    //       border: InputBorder.none,
                    //       contentPadding: EdgeInsets.zero,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    iconButton(() {
                      setState(() {
                        if (minute < 59)
                          minute++;
                        else
                          minute = 0;
                        minuteController.text =
                            (minute < 10 ? '0' : '') + minute.toString();
                        widget.select(TimeOfDay(hour: hour, minute: minute));
                      });
                    }, AppIcons.caret_up_mini),
                    iconButton(() {
                      setState(() {
                        if (minute > 0)
                          minute--;
                        else
                          minute = 59;
                        minuteController.text =
                            (minute < 10 ? '0' : '') + minute.toString();
                        widget.select(TimeOfDay(hour: hour, minute: minute));
                      });
                    }, AppIcons.caret_down_mini),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget iconButton(Function onPressed, IconData icon) {
    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: 20,
        maxHeight: 20,
        minHeight: 20,
        maxWidth: 20,
      ),
      iconSize: 20,
      splashRadius: 10,
      splashColor: AppColors.BLUE_VIOLET_500_16_WO,
      hoverColor: AppColors.BLUE_VIOLET_500_8_WO,
      highlightColor: AppColors.BLUE_VIOLET_500_24_WO,
      icon: Icon(icon, size: 16, color: AppColors.ACCENT_MAIN),
    );
  }
}
