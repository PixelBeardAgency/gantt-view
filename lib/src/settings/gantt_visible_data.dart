import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/src/model/grid_row.dart';

class GanttVisibleData {
  late int firstVisibleRow;
  late int lastVisibleRow;
  List<double> rowOffsets = [];

  late int visibleColumns;
  late int firstVisibleColumn;
  late int lastVisibleColumn;

  GanttVisibleData(
    List<(GridRow, Size)> rows,
    Size size,
    int columnCount,
    double columnWidth,
    Offset panOffset,
    bool gridShown,
  ) {
    final rowIterator = rows.iterator;
    firstVisibleRow = 0;
    lastVisibleRow = 0;
    double currentY = 0;

    rowOffsets.add(0);
    while (rowIterator.moveNext()) {
      final row = rowIterator.current;
      if (currentY + row.$2.height - (gridShown ? 1 : 0) < -panOffset.dy) {
        firstVisibleRow++;
      }
      if (currentY < -panOffset.dy + size.height) {
        lastVisibleRow++;
      } else {
        break;
      }
      currentY += row.$2.height+ (gridShown ? 1 : 0);
      rowOffsets.add(currentY);
    }

    visibleColumns = (size.width / columnWidth).ceil() + 1;
    firstVisibleColumn = max(0, (-panOffset.dx ~/ columnWidth));
    lastVisibleColumn = min(columnCount, firstVisibleColumn + visibleColumns);
  }
}
