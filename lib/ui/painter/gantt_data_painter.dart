import 'package:flutter/material.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/ui/painter/gantt_painter.dart';

class GanttDataPainter extends GanttPainter {
  final Map<int, Map<int, _FillData>> _cells = {};

  GanttDataPainter({
    required super.data,
    required super.panOffset,
    required super.layoutData,
  }) {
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
          (_cells[y] ??= {})[i] = _EventFillData(
            i == from,
            i == to,
          );
        }
      } else {
        for (int i = 0; i < layoutData.maxColumns; i++) {
          (_cells[y] ??= {})[i] = _HeaderFillData();
        }
      }
    }
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
      y * (gridScheme.rowHeight + layoutData.verticalPadding) +
          layoutData.uiOffset.dy +
          layoutData.verticalPadding,
      (gridScheme.columnWidth) + 1,
      gridScheme.rowHeight,
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

    final rect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        (x * gridScheme.columnWidth) / layoutData.widthDivisor +
            layoutData.uiOffset.dx,
        y * (gridScheme.rowHeight + layoutData.verticalPadding) +
            layoutData.uiOffset.dy +
            layoutData.verticalPadding,
        (gridScheme.columnWidth / layoutData.widthDivisor) + 1,
        gridScheme.rowHeight,
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
    final double vertinalLineSpacing =
        gridScheme.rowHeight + gridScheme.rowSpacing / 2;
    final double verticalOffset =
        layoutData.timelineHeight + gridScheme.rowSpacing / 4;
    final double horizontalOffset = layoutData.labelColumnWidth;

    _paintGridRows(
        size, verticalOffset, vertinalLineSpacing, horizontalOffset, canvas);
    _paintGridColumns(size, horizontalOffset, verticalOffset, canvas);
  }

  void _paintGridRows(Size size, double verticalOffset,
      double vertinalLineSpacing, double horizontalOffset, Canvas canvas) {
    final int rows = (size.height - verticalOffset + vertinalLineSpacing) ~/
        vertinalLineSpacing;
    final double rowVerticalOffset =
        verticalOffset + (panOffset.dy % vertinalLineSpacing);
    for (int y = 0; y < rows; y++) {
      final py = y * vertinalLineSpacing + rowVerticalOffset;
      final p1 = Offset(0 + horizontalOffset, py);
      final p2 = Offset(size.width + horizontalOffset, py);
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
    final double horizontalLineSpacing = gridScheme.columnWidth;
    final int columns =
        (size.width - horizontalOffset + gridScheme.columnWidth) ~/
            gridScheme.columnWidth;
    final double columnHorizontalOffset =
        horizontalOffset + (panOffset.dx % horizontalLineSpacing);
    for (int x = 0; x < columns; x++) {
      final px = x * horizontalLineSpacing + columnHorizontalOffset;
      final p1 = Offset(px, verticalOffset);
      final p2 = Offset(px, size.height + verticalOffset);
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
