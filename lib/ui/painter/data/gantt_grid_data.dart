import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/settings/gantt_settings.dart';

class GanttGridData {
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
  ) {
    final verticalSpacing = settings.gridScheme.rowSpacing;
    final rowHeight = settings.gridScheme.rowHeight;
    final columnWidth = settings.gridScheme.columnWidth;

    final visibleRows =
        (size.height / (rowHeight + (verticalSpacing / 2))).ceil();
    firstVisibleRow =
        max(0, (-panOffset.dy / (rowHeight + (verticalSpacing / 2))).floor());
    lastVisibleRow = min(rows, firstVisibleRow + visibleRows);

    final visibleColumns = (size.width / columnWidth).floor();
    firstVisibleColumn = max(0, (-panOffset.dx ~/ columnWidth));
    lastVisibleColumn = min(firstVisibleColumn + visibleColumns, columns);
  }
}
