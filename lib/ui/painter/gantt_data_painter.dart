import 'package:flutter/material.dart';
import 'package:gantt_view/ui/painter/gantt_painter.dart';

class GanttDataPainter extends GanttPainter {
  final Map<int, Map<int, _FillData>> _cells = {};

  late double _eventOffset;

  GanttDataPainter({
    required super.data,
    required super.panOffset,
    required super.layoutData,
  }) {
    int currentRow = 0;
    for (var activity in data) {
      if (activity.label != null) {
        for (int j = 0; j < layoutData.maxColumns; j++) {
          (_cells[currentRow] ??= {})[j] = _HeaderFillData();
        }
        currentRow++;
      }
      for (var task in activity.tasks) {
        final start = task.startDate;
        final end = task.endDate;

        final int from = start.difference(startDate).inDays;
        final int to = end.difference(startDate).inDays;

        if (start.isAfter(end)) {
          throw Exception('Start date must be before end date.');
        }

        for (int k = from; k <= to; k++) {
          (_cells[currentRow] ??= {})[k] = _EventFillData(
            k == from,
            k == to,
          );
        }
        currentRow++;
      }
    }
    _eventOffset = (gridScheme.rowSpacing +
            ganttStyle.eventLabelPadding.top +
            ganttStyle.eventLabelPadding.bottom) /
        2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (layoutData.settings.style.gridColor != null) {
      _paintGrid(canvas, size);
    }

    _paintCells(canvas, size);
  }

  void _paintCells(Canvas canvas, Size size) {
    final gridData = super.gridData(size);
    for (int y = gridData.firstVisibleRow; y < gridData.lastVisibleRow; y++) {
      for (int x = gridData.firstVisibleColumn;
          x / layoutData.widthDivisor < gridData.lastVisibleColumn;
          x++) {
        final fill = _cells[y]?[x];
        if (fill != null) {
          if (fill is _HeaderFillData) {
            _paintHeader(x, y, canvas, fill);
          } else if (fill is _EventFillData) {
            _paintEvent(x, y, canvas, fill);
          }
        }
      }
    }
  }

  void _paintHeader(int x, int y, Canvas canvas, _HeaderFillData fill) {
    final paint = Paint()
      ..color = layoutData.settings.style.eventHeaderColor
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(
      (x * gridScheme.columnWidth) + layoutData.uiOffset.dx,
      y * rowHeight + layoutData.uiOffset.dy,
      (gridScheme.columnWidth) + 1,
      rowHeight,
    );

    canvas.drawRect(
      rect.shift(panOffset),
      paint,
    );
  }

  void _paintEvent(int x, int y, Canvas canvas, _EventFillData fill) {
    final paint = Paint()
      ..color = layoutData.settings.style.eventColor
      ..style = PaintingStyle.fill;

    final radius = layoutData.settings.style.eventRadius;
    Rect.fromLTWH(
      0,
      y * rowHeight + layoutData.timelineHeight,
      layoutData.labelColumnWidth,
      rowHeight + 1,
    );
    final rect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        (x * gridScheme.columnWidth) / layoutData.widthDivisor +
            layoutData.uiOffset.dx,
        y * rowHeight + _eventOffset + layoutData.uiOffset.dy,
        (gridScheme.columnWidth / layoutData.widthDivisor) + 1,
        gridScheme.barHeight,
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

  void _paintGrid(Canvas canvas, Size size) {
    final double verticalOffset = layoutData.timelineHeight;
    final double horizontalOffset = layoutData.labelColumnWidth;

    _paintGridRows(size, verticalOffset, horizontalOffset, canvas);
    _paintGridColumns(size, horizontalOffset, verticalOffset, canvas);
  }

  void _paintGridRows(Size size, double verticalOffset, double horizontalOffset,
      Canvas canvas) {
    final gridData = super.gridData(size);

    final double rowVerticalOffset =
        verticalOffset + (panOffset.dy % rowHeight);
    final rows = gridData.lastVisibleRow - gridData.firstVisibleRow + 1;

    for (int y = 0; y < rows; y++) {
      final py = y * rowHeight + rowVerticalOffset;
      final p1 = Offset(layoutData.labelColumnWidth, py);
      final p2 = Offset(size.width, py);
      if (p1.dy > verticalOffset) {
        final paint = Paint()
          ..color = layoutData.settings.style.gridColor!
          ..strokeWidth = 1;
        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  void _paintGridColumns(Size size, double horizontalOffset,
      double verticalOffset, Canvas canvas) {
    final gridData = super.gridData(size);

    final double columnHorizontalOffset =
        horizontalOffset + (panOffset.dx % gridScheme.columnWidth);

    final columns =
        gridData.lastVisibleColumn - gridData.firstVisibleColumn + 1;

    for (int x = 0; x < columns; x++) {
      final px = x * gridScheme.columnWidth + columnHorizontalOffset;
      final p1 = Offset(px, verticalOffset);
      final p2 = Offset(px, size.height);
      final paint = Paint()
        ..color = layoutData.settings.style.gridColor!
        ..strokeWidth = 1;
      canvas.drawLine(p1, p2, paint);
    }
  }
}

abstract class _FillData {}

class _HeaderFillData extends _FillData {}

class _EventFillData extends _FillData {
  final bool isFirst;
  final bool isLast;

  _EventFillData(this.isFirst, this.isLast);
}
