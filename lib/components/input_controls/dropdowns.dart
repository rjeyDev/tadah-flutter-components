//@dart=2.9
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

class DropdownItem {
  final String title;
  final Widget prefix;
  final DropdownItemType type;
  final Function(String) onTap;
  final bool selected;
  DropdownItem({
    this.title,
    this.prefix,
    this.selected = false,
    this.type = DropdownItemType.classic,
    this.onTap,
  }) : assert(type != null);
}

class Dropdown extends StatefulWidget {
  final List<DropdownItem> children;
  final String value;
  final String label;
  final String hintText;
  final String helpText;
  final bool multiselect;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) validator;
  final Widget prefix;

  Dropdown({
    Key key,
    this.onChanged,
    this.focusNode,
    this.controller,
    this.value,
    this.children,
    this.prefix,
    this.label,
    this.hintText,
    this.helpText,
    this.multiselect = false,
    this.validator,
  }) : super(key: key);

  @override
  _DropdownState createState() => _DropdownState();

  static _DropdownState of(BuildContext context) =>
      context.findAncestorStateOfType<_DropdownState>();
}

class _DropdownState extends State<Dropdown>
    with SingleTickerProviderStateMixin {
  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  Animation<double> animation;
  AnimationController controller;
  bool hovered = false;
  String prev = '';
  FocusNode _focusNode;
  bool get disabled => widget.onChanged == null;
  bool multiselect;
  List<int> selectedItems = [];

  @override
  void initState() {
    super.initState();
    widget.children.forEach((element) {
      if (element.selected) selectedItems.add(widget.children.indexOf(element));
    });
    refreshController();
    multiselect = widget.multiselect;
    _focusNode = widget.focusNode ?? FocusNode();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0, end: 0.5).animate(controller);
    _overlayEntry = OverlayEntry(builder: (ctx) {
      return DropdownList(
        context,
        children: widget.children.map((item) {
          int index = widget.children.indexOf(item);
          return DropdownListChild(
            title: item.title,
            prefix: item.prefix,
            multiselect: widget.multiselect,
            selected: selectedItems.contains(index),
            onTap: (value) {
              if (widget.multiselect &&
                  widget.children[index].type == DropdownItemType.classic) {
                print('hey');
                if (selectedItems.contains(index))
                  selectedItems.removeWhere((element) => element == index);
                else
                  selectedItems.add(index);
                refreshController();
              }
              if (!widget.multiselect) item.onTap(value);
            },
            type: item.type,
          );
        }).toList(),
        layerLink: _layerLink,
      );
    });
    widget.controller.text = widget.value;
    _focusNode.addListener(() {
      if (!disabled) {
        if (_focusNode.hasFocus) {
          Overlay.of(context).insert(_overlayEntry);
          controller.forward();
        } else {
          _overlayEntry.remove();
          controller.reverse();
        }

        setState(() {});
      }
    });
    widget.controller.addListener(() {
      //
      if (!widget.multiselect &&
          _overlayEntry != null &&
          _overlayEntry.mounted &&
          widget.controller.text != prev &&
          !disabled) {
        if (_focusNode.hasFocus)
          _focusNode.unfocus();
        else
          _focusNode.requestFocus();
      }
      prev = widget.controller.text;
      widget.onChanged(widget.controller.text);
    });
  }

  refreshController() {
    widget.controller.text = '';
    selectedItems.forEach((element) {
      widget.controller.text += widget.children[element].title + ',';
    });
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
              height: 50,
              child: IgnorePointer(
                child: TextFormField(
                  focusNode: _focusNode ?? FocusNode(),
                  readOnly: true,
                  validator: widget.validator,
                  enabled: !disabled,
                  showCursor: false,
                  onTap: () {},
                  controller: widget.controller,
                  decoration: InputDecoration(
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
                    // prefixIcon: widget.prefix,
                    //  widget.multiselect
                    //     ? Wrap(
                    //         clipBehavior: Clip.antiAlias,
                    //         children: [
                    //           if (widget.prefix != null)
                    //             SizedBox(
                    //                 height: 40,
                    //                 width: 40,
                    //                 child: widget.prefix),
                    //         ],
                    //       )
                    //     : widget.prefix,
                    // prefixIconConstraints: BoxConstraints(
                    //   minWidth: 40,
                    //   maxWidth: 40,
                    //   maxHeight: 40,
                    // ),
                    labelText: widget.label,
                    hintText: widget.hintText,
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

enum DropdownItemType {
  label,
  classic,
  nested,
}

class DropdownListChild extends StatefulWidget {
  final String title;
  final Widget prefix;
  final bool multiselect;
  final bool selected;
  final DropdownItemType type;
  final Function(String) onTap;

  const DropdownListChild({
    Key key,
    this.onTap,
    this.title,
    this.selected = false,
    this.prefix,
    this.multiselect = false,
    this.type = DropdownItemType.classic,
  })  : assert(title != null),
        super(key: key);

  @override
  _DropdownListChildState createState() => _DropdownListChildState();
}

class _DropdownListChildState extends State<DropdownListChild> {
  bool selected;
  _DropdownState state;
  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    state = Dropdown.of(context);
    return widget.type != DropdownItemType.label
        ? Theme(
            data: ThemeData(
              highlightColor: AppColors.COOL_GRAY_500_24,
              splashColor: AppColors.COOL_GRAY_500_24,
            ),
            child: ListTile(
              hoverColor: AppColors.COOL_GRAY_500_8,
              focusColor: AppColors.COOL_GRAY_500_16,
              onTap: () {
                setState(() {
                  selected = !selected;
                });
                widget.onTap(widget.title);
              },
              contentPadding: EdgeInsets.only(
                  left: widget.type == DropdownItemType.classic &&
                          widget.multiselect
                      ? 8
                      : widget.prefix != null
                          ? 8
                          : 16),
              title: Row(
                children: [
                  if (widget.multiselect &&
                      widget.type == DropdownItemType.classic)
                    AppCheckBox(
                        value: selected,
                        onChanged: (value) {
                          widget.onTap(widget.title);
                          setState(() {
                            selected = value;
                          });
                        }),
                  if (widget.prefix != null)
                    Padding(
                      padding: widget.multiselect &&
                              widget.type == DropdownItemType.classic
                          ? EdgeInsets.only(right: 4)
                          : const EdgeInsets.symmetric(horizontal: 4.0),
                      child: widget.prefix,
                    ),
                  Text(widget.title, style: TextStyle()),
                ],
              ),
              trailing: widget.type == DropdownItemType.nested
                  ? Icon(AppIcons.caret_right_mini,
                      color: AppColors.BLACK_38_WO)
                  : null,
            ),
          )
        : Container(
            alignment: Alignment.centerLeft,
            height: 40,
            padding: EdgeInsets.only(left: 16),
            child: Text(
              widget.title,
              style: AppTextStyles.styleFrom(
                context: context,
                style: TextStyles.NOTE,
                color: AppColors.TEXT_SECONDARY_LIGHT,
              ),
            ),
          );
  }
}

class DropdownList extends StatefulWidget {
  final List<DropdownListChild> children;
  final LayerLink layerLink;
  final BuildContext context;
  final double width;
  DropdownList(
    this.context, {
    @required this.children,
    this.layerLink,
    this.width,
    Key key,
  }) : super(key: key);

  @override
  _DropdownListState createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  @override
  Widget build(BuildContext context) {
    RenderBox renderBox = widget.context.findRenderObject();
    var size = renderBox.size;

    return Positioned(
      width: widget.width ?? size.width,
      child: CompositedTransformFollower(
        link: widget.layerLink,
        showWhenUnlinked: false,
        offset: Offset(0.0, size.height + 8.0),
        child: Material(
          color: AppColors.WHITE,
          elevation: 3,
          shadowColor: AppColors.SHADOW_24_LIGHT,
          borderRadius: BorderRadius.circular(8),
          child: ListView(
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            children: List.generate(
              widget.children.length,
              (index) => widget.children[index],
            ),
          ),
        ),
      ),
    );
  }
}
