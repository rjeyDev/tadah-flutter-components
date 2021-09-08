//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

extension DateConverter on DateTime {
  String toDateString() {
    // print(thi);
    if (this == null) return '';
    return (this.day < 10 ? "0" : "") +
        this.day.toString() +
        '/' +
        (this.month < 10 ? '0' : '') +
        this.month.toString() +
        '/' +
        this.year.toString();
  }
}

class DateRangePicker extends StatefulWidget {
  final String label;
  final String helpText;
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime, DateTime) onChanged;
  final FocusNode focusNode;
  final Function(String) validator;
  final Widget prefix;

  DateRangePicker({
    Key key,
    @required this.firstDate,
    @required this.lastDate,
    this.onChanged,
    this.initialStartDate,
    this.initialEndDate,
    this.focusNode,
    this.prefix,
    this.label,
    this.helpText,
    this.validator,
  })  : assert((initialEndDate != null && initialStartDate != null) ||
            (initialEndDate == null && initialStartDate == null)),
        super(key: key);

  @override
  _DateRangePickerState createState() => _DateRangePickerState();

  static _DateRangePickerState of(BuildContext context) =>
      context.findAncestorStateOfType<_DateRangePickerState>();
}

class _DateRangePickerState extends State<DateRangePicker>
    with SingleTickerProviderStateMixin {
  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  TextEditingController textController = TextEditingController();
  Animation<double> animation;
  AnimationController controller;
  bool hovered = false;
  FocusNode _focusNode;
  bool focusListen = true;
  bool get disabled => widget.onChanged == null;
  DateTime selectedStartDate;
  DateTime selectedEndDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialStartDate == null) {
      selectedStartDate = widget.firstDate;
      selectedEndDate = DateTime(
          widget.firstDate.year + (widget.firstDate.month == 12 ? 1 : 0),
          (widget.firstDate.month == 12 ? 1 : widget.firstDate.month + 1),
          widget.firstDate.day);
    } else {
      selectedStartDate = widget.initialStartDate;
      selectedEndDate = widget.initialEndDate;
    }
    _focusNode = FocusNode();
    textController.text =
        '${selectedStartDate.toDateString()} - ${selectedEndDate.toDateString()}';
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0, end: 0.5).animate(controller);
    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        RenderBox renderBox = context.findRenderObject();
        var size = renderBox.size;
        return RangeCalendar(
          layerLink: _layerLink,
          size: size,
          focusListener: focusListener,
          initialStartDate: selectedStartDate,
          initialEndDate: selectedEndDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          overlayEntry: _overlayEntry,
          selectStart: selectStartDate,
          selectEnd: selectEndDate,
        );
      },
    );

    _focusNode.addListener(() {
      if (!disabled && focusListen) {
        if (_focusNode.hasFocus && !_overlayEntry.mounted) {
          Overlay.of(context).insert(_overlayEntry);
          controller.forward();
        } else {
          if (_focusNode.hasFocus) {
            focusListen = false;
            _focusNode.unfocus();
            Future.delayed(Duration(milliseconds: 100), () {
              focusListen = true;
            });
          }
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
        return RangeCalendar(
          layerLink: _layerLink,
          size: size,
          focusListener: focusListener,
          initialStartDate: selectedStartDate,
          initialEndDate: selectedEndDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          overlayEntry: _overlayEntry,
          selectStart: selectStartDate,
          selectEnd: selectEndDate,
        );
      },
    );
  }

  focusListener(bool value) {
    focusListen = value;
  }

  void selectStartDate(DateTime date) {
    selectedStartDate = date;
    widget.onChanged(selectedStartDate, selectedEndDate);
    textController.text = selectedStartDate.toDateString() +
        ' - ' +
        selectedEndDate.toDateString();
  }

  void selectEndDate(DateTime date) {
    selectedEndDate = date;
    widget.onChanged(selectedStartDate, selectedEndDate);
    textController.text = selectedStartDate.toDateString() +
        ' - ' +
        selectedEndDate.toDateString();
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

class RangeCalendar extends StatefulWidget {
  final LayerLink layerLink;
  final Size size;
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final OverlayEntry overlayEntry;
  final Function(bool) focusListener;
  final Function(DateTime) selectStart;
  final Function(DateTime) selectEnd;
  RangeCalendar({
    this.size,
    this.layerLink,
    this.focusListener,
    this.initialStartDate,
    this.initialEndDate,
    this.firstDate,
    this.lastDate,
    this.overlayEntry,
    this.selectStart,
    this.selectEnd,
    Key key,
  }) : super(key: key);

  @override
  _RangeCalendarState createState() => _RangeCalendarState();
}

class _RangeCalendarState extends State<RangeCalendar>
    with TickerProviderStateMixin {
  int maxDay;
  int prevMonthNum;
  bool yearSelect = false;
  bool monthSelect = false;
  DateTime selectedMonth;
  DateTime monthFirstDate;
  bool selectFrom = true;
  DateTime selectedStartDate;
  DateTime selectedEndDate;
  MaskedTextController controller1 = MaskedTextController(mask: '00/00/0000');
  MaskedTextController controller2 = MaskedTextController(mask: '00/00/0000');
  // Animation<double> animation;
  // AnimationController animationController;

  FocusScopeNode focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    selectedStartDate = widget.initialStartDate;
    selectedEndDate = widget.initialEndDate;
    controller1.updateText(selectedStartDate.toDateString());
    controller2.updateText(selectedEndDate.toDateString());
    selectedMonth = widget.initialStartDate;
    // animationController = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 100),
    //   reverseDuration: Duration(milliseconds: 100),
    // );
    // animation = Tween<double>(begin: 1, end: 0).animate(animationController);
  }

  @override
  void dispose() {
    focusScopeNode.dispose();
    super.dispose();
  }

  moveBack() {
    setState(() {
      // animationController.forward();
      // Future.delayed(Duration(milliseconds: 100), () {
      //   animationController.reverse();
      // });
      if (selectedMonth.isAfter(widget.firstDate))
        selectedMonth = DateTime(
          selectedMonth.month == 1
              ? selectedMonth.year - 1
              : selectedMonth.year,
          selectedMonth.month - 1 == 0 ? 12 : selectedMonth.month - 1,
        );
    });
  }

  moveForward() {
    setState(() {
      // animationController.forward();
      // Future.delayed(Duration(milliseconds: 100), () {
      //   animationController.reverse();
      // });
      if (selectedMonth.isBefore(widget.lastDate))
        selectedMonth = DateTime(
          selectedMonth.month == 12
              ? selectedMonth.year + 1
              : selectedMonth.year,
          selectedMonth.month + 1 == 13 ? 1 : selectedMonth.month + 1,
        );
    });
  }

  selectStartDate(DateTime date) {
    selectedStartDate = date;
    widget.selectStart(date);
    controller1.updateText(date.toDateString());
  }

  selectEndDate(DateTime date) {
    selectedEndDate = date;
    widget.selectEnd(date);
    controller2.updateText(date.toDateString());
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: 596,
      height: 412,
      child: CompositedTransformFollower(
        link: widget.layerLink,
        showWhenUnlinked: false,
        offset: Offset(0.0, widget.size.height + 8.0),
        child: FocusScope(
          node: focusScopeNode,
          child: Builder(
            builder: (context) {
              return Material(
                color: AppColors.WHITE,
                elevation: 3,
                shadowColor: AppColors.SHADOW_24_LIGHT,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonButton.withIcon(
                            months[selectedMonth.month - 1] +
                                ' ${selectedMonth.year}',
                            onPressed: () {
                              moveBack();
                            },
                            type: CommonButtonType.Contrast,
                            fontWeight: FontWeight.w600,
                            iconPosition: IconPosition.left,
                            icon: AppIcons.caret_left_mini,
                          ),
                          CommonButton.withIcon(
                            months[selectedMonth.month == 12
                                    ? 0
                                    : selectedMonth.month] +
                                ' ${selectedMonth.month == 12 ? selectedMonth.year + 1 : selectedMonth.year}',
                            onPressed: () {
                              moveForward();
                            },
                            fontWeight: FontWeight.w600,
                            type: CommonButtonType.Contrast,
                            iconPosition: IconPosition.right,
                            icon: AppIcons.caret_right_mini,
                          ),
                        ],
                      ),
                      Spacer(flex: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 260,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                7,
                                (index) => Container(
                                  width: 30,
                                  alignment: Alignment.center,
                                  child: Text(
                                    days[index],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.TEXT_PLACEHOLDER_LIGHT,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 260,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                7,
                                (index) => Container(
                                  width: 30,
                                  alignment: Alignment.center,
                                  child: Text(
                                    days[index],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.TEXT_PLACEHOLDER_LIGHT,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          calendar(date: selectedMonth),
                          calendar(
                              date: DateTime(
                                  selectedMonth.year +
                                      (selectedMonth.month == 12 ? 1 : 0),
                                  selectedMonth.month == 12
                                      ? 1
                                      : selectedMonth.month + 1)),
                        ],
                      ),
                      Spacer(flex: 2),
                      Row(
                        children: [
                          SizedBox(
                            height: 45,
                            width: 140,
                            child: BasicTextInput(
                              textInputType: TextInputType.number,
                              labelText: 'From',
                              hintText: 'dd/mm/yyyy',
                              onChanged: (value) {
                                if (value.length == 10) {
                                  selectStartDate(
                                    DateTime(
                                      int.parse(value.substring(6, 10)),
                                      int.parse(value.substring(3, 5)),
                                      int.parse(value.substring(0, 2)),
                                    ),
                                  );
                                }
                                controller1.updateText(value);
                                controller1.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(offset: controller1.text.length),
                                );
                              },
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              controller: controller1,
                              onTap: () {
                                selectFrom = true;
                                widget.focusListener(false);
                                Future.microtask(
                                  () => widget.focusListener(true),
                                );
                              },
                              // controller: TextEditingController(text: 'scdsdc'),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: Center(
                              child: Container(
                                width: 20,
                                height: 1.5,
                                color: AppColors.ACCENT_MAIN,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 45,
                            width: 140,
                            child: BasicTextInput(
                              textInputType: TextInputType.number,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'To',
                              hintText: 'dd/mm/yyyy',
                              onChanged: (value) {
                                if (value.length == 10) {
                                  selectEndDate(
                                    DateTime(
                                      int.parse(value.substring(6, 10)),
                                      int.parse(value.substring(3, 5)),
                                      int.parse(value.substring(0, 2)),
                                    ),
                                  );
                                }
                                controller2.updateText(value);
                                controller2.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: controller2.text.length));
                              },
                              controller: controller2,
                              onTap: () {
                                selectFrom = false;
                                widget.focusListener(false);
                                Future.microtask(
                                  () => widget.focusListener(true),
                                );
                              },
                              // controller: TextEditingController(text: 'scdsdc'),
                            ),
                          ),
                          Spacer(),
                          CommonButton.withIcon(
                            'Clear',
                            onPressed: () {
                              selectStartDate(widget.firstDate);
                              selectEndDate(widget.firstDate);
                              controller1.clear();
                              controller2.clear();
                            },
                            type: CommonButtonType.Outlined,
                            fontWeight: FontWeight.w600,
                            icon: AppIcons.x,
                          ),
                          SizedBox(width: 16),
                          CommonButton.withIcon(
                            'Apply',
                            onPressed: () {
                              widget.overlayEntry.remove();
                            },
                            fontWeight: FontWeight.w600,
                            icon: AppIcons.check,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget calendar({DateTime date}) {
    monthFirstDate = DateTime(date.year, date.month);
    maxDay = DateTime(date.year, date.month + 1, 0).day;
    int number = -monthFirstDate.weekday;
    if (number == -7) number = 0;
    return SizedBox(
      width: 259,
      height: 220,
      child: Column(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  5,
                  (ndx) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      7,
                      (index) {
                        number++;
                        return rangeCalendarNumber(date, number, index);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rangeCalendarNumber(DateTime date, int day, int index) {
    return Container(
      width: 37,
      height: 30,
      child: day < 1 || day > maxDay
          ? SizedBox()
          : TextButton(
              onPressed: () {
                setState(() {
                  focusScopeNode.unfocus();
                  if (selectFrom) {
                    selectStartDate(DateTime(date.year, date.month, day));
                    selectFrom = false;
                  } else
                    selectEndDate(DateTime(date.year, date.month, day));
                });
              },
              style: TextButton.styleFrom(
                primary: DateTime(date.year, date.month, day + 1)
                            .isAfter(selectedStartDate) &&
                        DateTime(date.year, date.month, day - 1)
                            .isBefore(selectedEndDate)
                    ? AppColors.WHITE
                    : AppColors.BLACK,
                padding: EdgeInsets.zero,
                minimumSize: Size(30, 30),
                fixedSize: Size(20, 20),
                textStyle: TextStyle(color: AppColors.BLACK, fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: DateTime(date.year, date.month, day)
                                .isAfter(selectedStartDate) &&
                            DateTime(date.year, date.month, day - 1)
                                .isBefore(selectedEndDate) &&
                            index != 0 &&
                            day != 1
                        ? Radius.circular(0)
                        : Radius.circular(100),
                    bottomLeft: DateTime(date.year, date.month, day)
                                .isAfter(selectedStartDate) &&
                            DateTime(date.year, date.month, day - 1)
                                .isBefore(selectedEndDate) &&
                            index != 0 &&
                            day != 1
                        ? Radius.circular(0)
                        : Radius.circular(100),
                    topRight: DateTime(date.year, date.month, day + 1)
                                .isAfter(selectedStartDate) &&
                            DateTime(date.year, date.month, day)
                                .isBefore(selectedEndDate) &&
                            index != 6 &&
                            day != maxDay
                        ? Radius.circular(0)
                        : Radius.circular(100),
                    bottomRight: DateTime(date.year, date.month, day + 1)
                                .isAfter(selectedStartDate) &&
                            DateTime(date.year, date.month, day)
                                .isBefore(selectedEndDate) &&
                            index != 6 &&
                            day != maxDay
                        ? Radius.circular(0)
                        : Radius.circular(100),
                  ),
                ),
                backgroundColor: DateTime(date.year, date.month, day + 1)
                            .isAfter(selectedStartDate) &&
                        DateTime(date.year, date.month, day - 1)
                            .isBefore(selectedEndDate)
                    ? AppColors.ACCENT_MAIN
                    : AppColors.TRANSPARENT,
              ),
              child: Text(
                '$day',
              ),
            ),
    );
  }
}
