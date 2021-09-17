//@dart=2.9
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

class AppDialog {
  final BuildContext context;
  final bool useRootNavigator;
  final bool useSafeArea;
  final String title;
  final String description;
  final Widget content;
  final List<Widget> actions;
  final TextStyle titleStyle;
  final TextStyle descriptionStyle;
  final BorderRadiusGeometry borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final double width;
  final double maxWidth;

  AppDialog({
    @required this.context,
    this.useRootNavigator = false,
    this.useSafeArea = false,
    this.title,
    this.description,
    this.content,
    this.actions = const [],
    this.backgroundColor = AppColors.WHITE,
    this.titleStyle,
    this.descriptionStyle,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.width = 0.0,
    this.maxWidth = double.infinity,
  }) : assert(width <= maxWidth);

  void show() {
    showDialog(
      context: context,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor ?? AppColors.WHITE,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
        ),
        elevation: elevation ?? 4,
        contentPadding:
            padding ?? EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? double.infinity,
            minWidth: width ?? 0.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text(
                    title,
                    style: titleStyle ??
                        AppTextStyles.styleFrom(
                          context: context,
                          style: TextStyles.H4,
                        ),
                  ),
                ),
              if (description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text(
                    description,
                    style: descriptionStyle ??
                        AppTextStyles.styleFrom(
                          context: context,
                          style: TextStyles.BODY,
                        ),
                  ),
                ),
              if (content != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: content,
                ),
              if (actions.length > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(
                      actions.length,
                      (index) => actions[index],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
