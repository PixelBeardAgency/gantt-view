import 'dart:math';

import 'package:flutter/material.dart';

class GanttVisibleData {
  late int visibleRows;
  late int firstVisibleRow;
  late int lastVisibleRow;

  late int visibleColumns;
  late int firstVisibleColumn;
  late int lastVisibleColumn;

  GanttVisibleData(
    Size size,
    int rowCount,
    Offset uiOffset,
    int columnCount,
    double columnWidth,
    Offset panOffset,
    double rowHeight,
  ) {
    visibleRows = ((size.height - uiOffset.dy) / rowHeight).ceil() + 1;
    firstVisibleRow = max(0, (-panOffset.dy ~/ rowHeight));
    lastVisibleRow = min(rowCount, firstVisibleRow + visibleRows);

    visibleColumns = ((size.width - uiOffset.dx) / columnWidth).ceil() + 1;
    firstVisibleColumn = max(0, (-panOffset.dx ~/ columnWidth));
    lastVisibleColumn = min(columnCount, firstVisibleColumn + visibleColumns);
  }
}
