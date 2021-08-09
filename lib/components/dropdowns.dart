//@dart=2.9
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

class Dropdown extends StatefulWidget {
  final List<DropdownItem> children;
  final String value;
  final String label;
  final String hint;
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
    this.hint,
    this.multiselect = false,
    this.validator,
  }) : super(key: key);

  @override
  _DropdownState createState() => _DropdownState();
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

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0, end: 0.5).animate(controller);
    _overlayEntry = OverlayEntry(builder: (ctx) {
      return DropdownList(
        context,
        children: widget.children,
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
                    prefixIcon: widget.prefix,
                    // prefixIconConstraints: BoxConstraints(
                    //   maxWidth: 40,
                    // ),
                    labelText: widget.label,
                    hintText: widget.hint,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    //   Focus(
    //     focusNode: widget.focusNode,
    //     child: GestureDetector(
    //       onTap: () {
    //         if (_focusNode.hasFocus)
    //           _focusNode.unfocus();
    //         else
    //           _focusNode.requestFocus();
    //       },
    //       child: Container(
    //         width: double.infinity,
    //         padding: EdgeInsets.symmetric(horizontal: 12),
    //         height: 50,
    //         decoration: BoxDecoration(
    //           color: AppColors.WHITE,
    //           border: Border.all(color: AppColors.ACCENT_MAIN, width: 1.5),
    //           borderRadius: BorderRadius.circular(8),
    //         ),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Container(),
    //             RotationTransition(
    //               turns: animation,
    //               child: Icon(
    //                 AppIcons.caret_down_mini,
    //                 color: AppColors.ACCENT_MAIN,
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

enum DropdownItemType {
  label,
  classic,
  nested,
}

class DropdownItem extends StatefulWidget {
  final String title;
  final Widget prefix;
  final DropdownItemType type;
  final Function(String) onTap;
  final bool multiSelect;

  const DropdownItem({
    Key key,
    this.onTap,
    this.title,
    this.prefix,
    this.multiSelect = false,
    this.type = DropdownItemType.classic,
  })  : assert(title != null),
        super(key: key);

  @override
  _DropdownItemState createState() => _DropdownItemState();
}

class _DropdownItemState extends State<DropdownItem> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return widget.type != DropdownItemType.label
        ? ListTile(
            onTap: () {
              widget.onTap(widget.title);
            },
            leading: widget.prefix != null || widget.multiSelect
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.multiSelect)
                        AppCheckBox(
                            value: selected,
                            onChanged: (value) {
                              setState(() {
                                selected = value;
                              });
                            }),
                      if (widget.prefix != null) widget.prefix,
                    ],
                  )
                : null,
            title: Text(widget.title, style: TextStyle()),
            trailing: widget.type == DropdownItemType.nested
                ? Icon(AppIcons.caret_right_mini, color: AppColors.BLACK_38_WO)
                : null,
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
  final List<DropdownItem> children;
  final LayerLink layerLink;
  final BuildContext context;
  DropdownList(
    this.context, {
    @required this.children,
    this.layerLink,
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
      width: size.width,
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
            children: widget.children,
          ),
        ),
      ),
    );
  }
}
