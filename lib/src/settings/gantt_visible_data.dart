import 'dart:math';

import 'package:flutter/material.dart';

class GanttVisibleData {
  late int visibleColumns;
  late int firstVisibleColumn;
  late int lastVisibleColumn;

  GanttVisibleData(
    Size size,
    int columnCount,
    double columnWidth,
    Offset panOffset,
  ) {
    visibleColumns = (size.width / columnWidth).ceil() + 1;
    firstVisibleColumn = max(0, (-panOffset.dx ~/ columnWidth));
    lastVisibleColumn = min(columnCount, firstVisibleColumn + visibleColumns);
  }
}
