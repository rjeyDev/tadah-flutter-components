//@dart=2.9
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

const List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];
const List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

class DatePicker extends StatefulWidget {
  final String label;
  final String helpText;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onChanged;
  final FocusNode focusNode;
  final Function(String) validator;
  final Widget prefix;

  DatePicker({
    Key key,
    this.onChanged,
    this.initialDate,
    @required this.firstDate,
    @required this.lastDate,
    this.focusNode,
    this.prefix,
    this.label,
    this.helpText,
    this.validator,
  }) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();

  static _DatePickerState of(BuildContext context) =>
      context.findAncestorStateOfType<_DatePickerState>();
}

class _DatePickerState extends State<DatePicker>
    with SingleTickerProviderStateMixin {
  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  TextEditingController textController = TextEditingController();
  Animation<double> animation;
  AnimationController controller;
  bool hovered = false;
  FocusNode _focusNode;
  bool get disabled => widget.onChanged == null;
  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate == null)
      selectedDate = widget.firstDate.isBefore(DateTime.now()) &&
              widget.lastDate.isAfter(DateTime.now())
          ? DateTime.now()
          : widget.lastDate;
    else
      selectedDate = widget.initialDate;
    _focusNode = FocusNode();
    textController.text =
        '${days[selectedDate.weekday % 7]}, ${months[selectedDate.month - 1].substring(0, 3)} ${selectedDate.day}, ${selectedDate.year}';
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0, end: 0.5).animate(controller);
    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        RenderBox renderBox = context.findRenderObject();
        var size = renderBox.size;
        return Calendar(
          layerLink: _layerLink,
          size: size,
          initialDate: selectedDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          select: selectDate,
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
        return Calendar(
          layerLink: _layerLink,
          size: size,
          initialDate: selectedDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          select: selectDate,
        );
      },
    );
  }

  void selectDate(DateTime date) {
    widget.onChanged(date);
    selectedDate = date;
    textController.text =
        '${days[date.weekday % 7]}, ${months[date.month - 1].substring(0, 3)} ${date.day}, ${date.year}';
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
      ),
    );
  }
}

class Calendar extends StatefulWidget {
  final LayerLink layerLink;
  final Size size;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) select;
  Calendar({
    this.size,
    this.layerLink,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.select,
    Key key,
  }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with TickerProviderStateMixin {
  int selectedNum;
  int number = 0;
  int maxNum;
  int prevMonthNum;
  bool yearSelect = false;
  bool monthSelect = false;
  int selectedYear;
  int selectedMonthIndex;
  DateTime monthFirstDate;
  AnimationController controllerM;
  Animation<double> animationM;
  AnimationController controllerY;
  Animation<double> animationY;

  @override
  void initState() {
    super.initState();

    selectedNum = widget.initialDate.day;
    selectedYear = widget.initialDate.year;
    selectedMonthIndex = widget.initialDate.month - 1;
    controllerM =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animationM = Tween<double>(begin: 0, end: 0.5).animate(controllerM);
    controllerY =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animationY = Tween<double>(begin: 0, end: 0.5).animate(controllerY);
  }

  @override
  Widget build(BuildContext context) {
    monthFirstDate = DateTime(selectedYear, selectedMonthIndex + 1);
    prevMonthNum = DateTime(selectedYear, selectedMonthIndex + 1, 0).day;
    maxNum = DateTime(selectedYear, selectedMonthIndex + 2, 0).day;
    number = -monthFirstDate.weekday;
    if (number == -7) number = 0;
    return Positioned(
      width: 290,
      height: 306,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (yearSelect) controllerY.reverse();
                          yearSelect = false;
                          monthSelect = !monthSelect;

                          if (monthSelect)
                            controllerM.forward();
                          else
                            controllerM.reverse();
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Text(
                              '${months[selectedMonthIndex]}',
                              style: TextStyle(
                                color: AppColors.ACCENT_MAIN,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 12),
                            RotationTransition(
                              turns: animationM,
                              child: Icon(
                                AppIcons.caret_down_mini,
                                size: 20,
                                color: AppColors.ACCENT_MAIN,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 25),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (monthSelect) controllerM.reverse();
                          monthSelect = false;
                          yearSelect = !yearSelect;
                          if (yearSelect)
                            controllerY.forward();
                          else
                            controllerY.reverse();
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Text(
                              '$selectedYear',
                              style: TextStyle(
                                color: AppColors.ACCENT_MAIN,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 12),
                            RotationTransition(
                              turns: animationY,
                              child: Icon(
                                AppIcons.caret_down_mini,
                                size: 20,
                                color: AppColors.ACCENT_MAIN,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
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
                SizedBox(height: 10),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: monthSelect
                        ? GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 4 / 2,
                            children: List.generate(
                              12,
                              (index) => month(index),
                            ),
                          )
                        : yearSelect
                            ? GridView.count(
                                crossAxisCount: 3,
                                childAspectRatio: 3 / 2,
                                children: List.generate(
                                  widget.lastDate.year -
                                      widget.firstDate.year +
                                      1,
                                  (index) => year(index),
                                ),
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  5,
                                  (ndx) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                      7,
                                      (index) {
                                        number++;
                                        return calendarNumber(number);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget year(int index) {
    return Container(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          setState(() {
            selectedYear = widget.firstDate.year + index;
            yearSelect = !yearSelect;
            widget.select(
                DateTime(selectedYear, selectedMonthIndex + 1, selectedNum));
            controllerY.reverse();
          });
        },
        style: TextButton.styleFrom(
          primary: selectedYear == widget.firstDate.year + index
              ? AppColors.WHITE
              : AppColors.BLACK,
          backgroundColor: selectedYear == widget.firstDate.year + index
              ? AppColors.ACCENT_MAIN
              : AppColors.TRANSPARENT,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(
          '${widget.firstDate.year + index}',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget month(int index) {
    return Container(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          setState(() {
            selectedMonthIndex = index;
            monthSelect = !monthSelect;
            widget.select(
                DateTime(selectedYear, selectedMonthIndex + 1, selectedNum));
            controllerM.reverse();
          });
        },
        style: TextButton.styleFrom(
          primary:
              selectedMonthIndex == index ? AppColors.WHITE : AppColors.BLACK,
          backgroundColor: selectedMonthIndex == index
              ? AppColors.ACCENT_MAIN
              : AppColors.TRANSPARENT,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text(
            '${months[index]}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget calendarNumber(int index) {
    return Container(
      width: 30,
      height: 30,
      child: TextButton(
        onPressed: number < 1 || number > maxNum
            ? null
            : () {
                setState(() {
                  selectedNum = index;
                  widget.select(DateTime(
                      selectedYear, selectedMonthIndex + 1, selectedNum));
                });
              },
        style: TextButton.styleFrom(
          primary: selectedNum == index
              ? AppColors.WHITE
              : number < 1 || number > maxNum
                  ? AppColors.TEXT_PLACEHOLDER_LIGHT
                  : AppColors.BLACK,
          padding: EdgeInsets.zero,
          minimumSize: Size(30, 30),
          fixedSize: Size(20, 20),
          textStyle: TextStyle(color: AppColors.BLACK, fontSize: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          backgroundColor: selectedNum == index
              ? AppColors.ACCENT_MAIN
              : AppColors.TRANSPARENT,
        ),
        child: Text(
          number < 1
              ? '${prevMonthNum + number}'
              : number > maxNum
                  ? '${number - maxNum}'
                  : '$number',
        ),
      ),
    );
  }
}
