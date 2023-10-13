import 'package:flutter/material.dart';

class EventRowTheme {
  final double height;
  final Color fillColor;
  final TextStyle? labelStyle;
  final Color labelColor;
  final double radius;

  EventRowTheme({
    this.height = 50.0,
    Color? fillColor,
    this.labelStyle,
    this.labelColor = Colors.white,
    this.radius = 8.0,
  }) : fillColor = fillColor ?? Colors.greenAccent.shade700;
}
