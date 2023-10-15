import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/settings/gantt_settings.dart';

class GanttGridData {
  final double rowHeight;

  late int firstVisibleRow;
  late int lastVisibleRow;
  late int firstVisibleColumn;
  late int lastVisibleColumn;

  GanttGridData(
    GanttSettings settings,
    Size size,
    Offset panOffset,
    int rows,
    int columns,
    this.rowHeight,
  ) {
    final columnWidth = settings.gridScheme.columnWidth;

    final visibleRows = (size.height / rowHeight).ceil();
    firstVisibleRow = max(0, (-panOffset.dy ~/ rowHeight));
    lastVisibleRow = min(rows, firstVisibleRow + visibleRows);

    final visibleColumns = (size.width / columnWidth).ceil();
    firstVisibleColumn = max(0, (-panOffset.dx ~/ columnWidth));
    lastVisibleColumn = min(columns, firstVisibleColumn + visibleColumns);
  }
}
