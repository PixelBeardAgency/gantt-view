import 'package:flutter/material.dart';
import 'package:gantt_view/ui/painter/gantt_painter.dart';

class GanttDataPainter extends GanttPainter {
  final Map<int, Map<int, _FillData>> _cells = {};

  late double _eventOffset;

  GanttDataPainter({
    required super.panOffset,
    required super.layoutData,
  }) {
    int currentRow = 0;
    for (var activity in layoutData.activities) {
      if (activity.label != null) {
        for (int i = 0; i < layoutData.days; i++) {
          final currentOffset = (i + layoutData.weekendOffset) % 7;
          (_cells[currentRow] ??= {})[i] = layoutData.filledDays.contains(i)
              ? _HolidayFillData()
              : layoutData.settings.style.weekendColor != null &&
                      (currentOffset == 0 || currentOffset == 1)
                  ? _WeekendFillData()
                  : _HeaderFillData();
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

        for (int i = 0; i < layoutData.days; i++) {
          final currentOffset = (i + layoutData.weekendOffset) % 7;
          if (layoutData.filledDays.contains(i)) {
            (_cells[currentRow] ??= {})[i] = (i >= from && i <= to)
                ? _EventFillData(i == from, i == to, isHoliday: true)
                : _HolidayFillData();
          } else if (layoutData.settings.style.weekendColor != null &&
              (currentOffset == 0 || currentOffset == 1)) {
            (_cells[currentRow] ??= {})[i] = (i >= from && i <= to)
                ? _EventFillData(i == from, i == to, isWeekend: true)
                : _WeekendFillData();
          } else if (i >= from && i <= to) {
            (_cells[currentRow] ??= {})[i] = _EventFillData(i == from, i == to);
          }
        }

        currentRow++;
      }
    }
    _eventOffset =
        (gridScheme.rowSpacing + ganttStyle.labelPadding.vertical) / 2;
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
      var dy = y * rowHeight + layoutData.uiOffset.dy;
      for (int x = gridData.firstVisibleColumn;
          x < gridData.lastVisibleColumn;
          x++) {
        final fill = _cells[y]?[x];
        var dx = x * layoutData.cellWidth + layoutData.uiOffset.dx;
        if (fill is _HeaderFillData) {
          _paintFill(
              dx, dy, canvas, layoutData.settings.style.activityLabelColor);
        } else if (fill is _EventFillData) {
          _paintEvent(dx, dy, canvas, fill);
        } else if (fill is _WeekendFillData) {
          _paintFill(dx, dy, canvas, layoutData.settings.style.weekendColor!);
        } else if (fill is _HolidayFillData) {
          _paintFill(dx, dy, canvas, layoutData.settings.style.holidayColor);
        }
      }
    }
  }

  void _paintFill(double x, double y, Canvas canvas, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(
      x,
      y,
      layoutData.cellWidth + 1,
      rowHeight,
    );

    canvas.drawRect(
      rect.shift(panOffset),
      paint,
    );
  }

  void _paintEvent(double x, double y, Canvas canvas, _EventFillData fill) {
    var color = layoutData.settings.style.taskBarColor;
    if (fill.isHoliday || fill.isWeekend) {
      _paintFill(
          x,
          y,
          canvas,
          fill.isHoliday
              ? layoutData.settings.style.holidayColor
              : layoutData.settings.style.weekendColor!);
      color = color.withOpacity(0.5);
    }
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final radius = layoutData.settings.style.taskBarRadius;
    Rect.fromLTWH(
      0,
      y * rowHeight + layoutData.timelineHeight,
      layoutData.labelColumnWidth,
      rowHeight + 1,
    );
    final rect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        x,
        y + _eventOffset,
        layoutData.cellWidth + 1,
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
  final bool isHoliday;
  final bool isWeekend;
  final bool isFirst;
  final bool isLast;

  _EventFillData(
    this.isFirst,
    this.isLast, {
    this.isHoliday = false,
    this.isWeekend = false,
  });
}

class _WeekendFillData extends _FillData {}

class _HolidayFillData extends _FillData {}
