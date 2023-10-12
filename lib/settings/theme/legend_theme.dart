import 'package:flutter/material.dart';

class LegendTheme {
  final double width;
  final double height;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  final bool showYear;
  final bool showMonth;
  final bool showDay;
  final double dateWidth;
  final TextStyle? dateStyle;

  LegendTheme({
    this.width = 200,
    this.height = 60,
    this.backgroundColor,
    this.titleStyle,
    this.subtitleStyle,
    this.showYear = true,
    this.showMonth = true,
    this.showDay = true,
    this.dateWidth = 50,
    this.dateStyle,
  });
}
