import 'package:flutter/material.dart';

class HeaderRowTheme {
  final double height;
  final Color backgroundColor;
  final TextStyle? textStyle;

  HeaderRowTheme({
    this.backgroundColor = Colors.transparent,
    this.textStyle,
    this.height = 50,
  });
}
