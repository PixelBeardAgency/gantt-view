import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_event_list_extension.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/ui/painter/gantt_painter.dart';

class GanttDataPainter extends GanttPainter {
  final Map<int, Map<int, Color>> _cells = {};

  GanttDataPainter({
    required super.data,
    required super.panOffset,
    required super.layoutData,
  }) {
    final startDate = data.whereType<GanttEvent>().startDate;
    final endDate = data.whereType<GanttEvent>().endDate;
    final columns = endDate.difference(startDate).inDays + 1;

    for (int y = 0; y < data.length; y++) {
      final rowData = data[y];
      if (rowData is GanttEvent) {
        final start = rowData.startDate;
        final end = rowData.endDate;

        final int from = start.difference(startDate).inDays;
        final int to = end.difference(startDate).inDays;

        if (start.isAfter(end)) {
          throw Exception('Start date must be before end date.');
        }

        for (int i = from; i <= to; i++) {
          (_cells[y] ??= {})[i] = layoutData.settings.eventRowTheme.fillColor;
        }
      } else {
        for (int i = 0; i <= columns; i++) {
          (_cells[y] ??= {})[i] =
              layoutData.settings.headerRowTheme.backgroundColor;
        }
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final verticalSpacing = layoutData.settings.rowSpacing;

    final visibleRows = (size.height / (rowHeight + verticalSpacing)).ceil();
    final int firstVisibleRow =
        max(0, (-panOffset.dy / (rowHeight + verticalSpacing)).floor());
    final int lastVisibleRow = min(
        data.length, (firstVisibleRow + visibleRows + verticalSpacing).ceil());

    final visibleColumns = (size.width / columnWidth).ceil();
    final int firstVisibleColumn = max(0, (-panOffset.dx ~/ columnWidth));
    final int lastVisibleColumn =
        min(firstVisibleColumn + visibleColumns, maxColumns);

    for (int y = 0; y < lastVisibleRow; y++) {
      for (int x = 0; x < lastVisibleColumn; x++) {
        final fill = _cells[y]?[x];
        if (fill != null) {
          _fillCell(
              x, y, layoutData.uiOffset.dy, canvas, fill, verticalSpacing / 2);
        }
      }
    }
  }

  void _fillCell(int x, int y, double legendHeight, Canvas canvas, Color color,
      double verticalPadding) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final rect = Rect.fromLTWH(
      x * columnWidth + layoutData.uiOffset.dx,
      y * (rowHeight + verticalPadding) + legendHeight + verticalPadding,
      columnWidth,
      rowHeight,
    );
    canvas.drawRect(
      rect.shift(panOffset),
      paint,
    );
  }
}
