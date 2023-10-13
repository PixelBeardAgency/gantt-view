import 'package:flutter/material.dart';

class LegendTheme {
  final double width;
  final double height;
  final Color backgroundColor;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  final bool showYear;
  final bool showMonth;
  final bool showDay;
  final double dateWidth;
  final TextStyle dateStyle;

  LegendTheme({
    this.width = 200,
    this.height = 60,
    this.backgroundColor = Colors.white,
    this.titleStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    this.subtitleStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
    ),
    this.showYear = true,
    this.showMonth = true,
    this.showDay = true,
    this.dateWidth = 50,
    this.dateStyle = const TextStyle(color: Colors.black),
  });
}
