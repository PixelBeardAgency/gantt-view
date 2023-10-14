import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_event_list_extension.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/ui/painter/gantt_painter.dart';

class GanttDataPainter extends GanttPainter {
  final Map<int, Map<int, _FillData>> _cells = {};

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
          (_cells[y] ??= {})[i] = _FillData(
            layoutData.settings.style.eventColor,
            i == from,
            i == to,
          );
        }
      } else {
        for (int i = 0; i <= columns; i++) {
          (_cells[y] ??= {})[i] = _FillData(
              layoutData.settings.style.eventHeaderColor, false, false);
        }
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final verticalSpacing = layoutData.settings.gridScheme.rowSpacing;
    var gridData = super.gridData(size);

    for (int y = 0; y < gridData.lastVisibleRow; y++) {
      for (int x = 0; x < gridData.lastVisibleColumn; x++) {
        final fill = _cells[y]?[x];
        if (fill != null) {
          _fillCell(
            x,
            y,
            layoutData.uiOffset.dy,
            canvas,
            fill,
            verticalSpacing / 2,
          );
        }
      }
    }
  }

  void _fillCell(
    int x,
    int y,
    double legendHeight,
    Canvas canvas,
    _FillData fill,
    double verticalPadding,
  ) {
    final paint = Paint()
      ..color = fill.color
      ..style = PaintingStyle.fill;

    final radius = layoutData.settings.style.eventRadius;

    final rect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        x * columnWidth + layoutData.uiOffset.dx,
        y * (rowHeight + verticalPadding) + legendHeight + verticalPadding,
        columnWidth,
        rowHeight,
      ),
      topLeft: Radius.circular(fill.isFirst ? radius : 0),
      bottomLeft: Radius.circular(fill.isFirst ? radius : 0),
      topRight: Radius.circular(fill.isLast ? radius : 0),
      bottomRight: Radius.circular(fill.isLast ? radius : 0),
    );
    canvas.drawRRect(
      rect.shift(panOffset),
      paint,
    );
  }
}

class _FillData {
  final Color color;
  final bool isFirst;
  final bool isLast;

  _FillData(this.color, this.isFirst, this.isLast);
}
