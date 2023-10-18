import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_activity_iterable_extension.dart';
import 'package:gantt_view/ui/painter/data/gantt_layout_data.dart';

class GanttGridData {
  final double rowHeight;

  late int firstVisibleRow;
  late int lastVisibleRow;
  late int firstVisibleColumn;
  late int lastVisibleColumn;

  GanttGridData(
    GanttChartLayoutData layoutData,
    Size size,
    Offset panOffset,
    this.rowHeight,
  ) {
    final columnWidth = layoutData.cellWidth ;

    final visibleRows =
        ((size.height - layoutData.timelineHeight) / rowHeight).ceil() + 1;
    firstVisibleRow = max(0, (-panOffset.dy ~/ rowHeight));
    lastVisibleRow = min(
        layoutData.activities.length + layoutData.activities.allTasks.length,
        firstVisibleRow + visibleRows);

    final visibleColumns = (size.width / columnWidth).ceil();
    firstVisibleColumn = max(0, (-panOffset.dx ~/ columnWidth));
    lastVisibleColumn =
        min(layoutData.columns, firstVisibleColumn + visibleColumns);
  }
}
