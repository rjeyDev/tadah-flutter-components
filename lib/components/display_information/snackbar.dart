//@dart=2.9
import 'package:flutter/material.dart';

class AppSnackBar {
  final String description;
  final IconData icon;
  final String buttonText;
  final Color backgroudColor;
  final double elevation;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double width;
  final ShapeBorder shape;
  final SnackBarBehavior behavior;
  final SnackBarAction action;
  final Duration duration;
  final Animation<double> animation;
  final void Function() onVisible;
  final void Function() onPressed;
  AppSnackBar({
    @required this.description,
    this.onPressed,
    this.icon,
    this.buttonText,
    this.elevation,
    this.margin,
    this.action,
    this.animation,
    this.backgroudColor,
    this.behavior,
    this.duration,
    this.onVisible,
    this.padding,
    this.shape,
    this.width,
  });
}
