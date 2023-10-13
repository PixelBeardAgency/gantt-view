import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_event_list_extension.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/ui/painter/gantt_painter.dart';

class GanttDataPainter extends GanttPainter {
  final Map<int, Map<int, bool>> _cells = {};

  GanttDataPainter({
    required super.data,
    required super.offset,
    required super.settings,
  }) {
    for (int y = 0; y < data.length; y++) {
      final rowData = data[y];
      if (rowData is GanttEvent) {
        final start = rowData.startDate;
        final end = rowData.endDate;

        final int from =
            start.difference(data.whereType<GanttEvent>().startDate).inDays;
        final int to =
            end.difference(data.whereType<GanttEvent>().startDate).inDays;

        if (start.isAfter(end)) {
          throw Exception('Start date must be before end date.');
        }

        for (int i = from; i <= to; i++) {
          (_cells[y] ??= {})[i] = true;
        }
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final visibleRows = (size.height / rowHeight).ceil();
    final int firstVisibleRow = max(0, (-offset.dy / rowHeight).floor());
    final int lastVisibleRow = min(data.length, firstVisibleRow + visibleRows);

    final visibleColumns = (size.width / columnWidth).ceil();
    final int firstVisibleColumn = max(0, (-offset.dx ~/ columnWidth)) - 1;
    final int lastVisibleColumn =
        min(firstVisibleColumn + visibleColumns + 2, maxColumns);

    for (int y = 0; y < lastVisibleRow; y++) {
      for (int x = 0; x < lastVisibleColumn; x++) {
        final fill = _cells[y]?[x] ?? false;
        if (fill) {
          _fillCell(x, y, legendHeight, canvas);
        }
      }
    }
  }

  void _fillCell(int x, int y, double legendHeight, Canvas canvas) {
    final paint = Paint()
      ..color = settings.eventRowTheme.fillColor
      ..style = PaintingStyle.fill;
    final rect = Rect.fromLTWH(
      x * columnWidth + titleWidth,
      y * rowHeight + legendHeight,
      columnWidth,
      rowHeight,
    );
    canvas.drawRect(
      rect.shift(offset),
      paint,
    );
  }
}
