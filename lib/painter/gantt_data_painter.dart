import 'package:flutter/material.dart';
import 'package:gantt_view/settings/gantt_visible_data.dart';
import 'package:gantt_view/painter/gantt_painter.dart';

class GanttDataPainter extends GanttPainter {
  final Map<int, Map<int, _FillData>> _cells = {};

  late double _eventOffset;

  GanttDataPainter({required super.config}) {
    int currentRow = 0;
    for (var activity in config.activities) {
      if (activity.label != null) {
        for (int i = 0; i < config.columns; i++) {
          final currentOffset = (i + config.weekendOffset) % 7;
          (_cells[currentRow] ??= {})[i] = config.highlightedColumns.contains(i)
              ? _HolidayFillData()
              : config.style.weekendColor != null &&
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

        for (int i = 0; i < config.columns; i++) {
          final currentOffset = (i + config.weekendOffset) % 7;
          if (config.highlightedColumns.contains(i)) {
            (_cells[currentRow] ??= {})[i] = (i >= from && i <= to)
                ? _EventFillData(i == from, i == to, isHoliday: true)
                : _HolidayFillData();
          } else if (config.style.weekendColor != null &&
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
        (grid.rowSpacing + ganttStyle.labelPadding.vertical) / 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final gridData = config.gridData;

    if (config.style.gridColor != null) {
      _paintGrid(canvas, size, gridData);
    }

    _paintCells(canvas, size, gridData);
  }

  void _paintCells(Canvas canvas, Size size, GanttVisibleData gridData) {
    for (int y = gridData.firstVisibleRow; y < gridData.lastVisibleRow; y++) {
      var dy = y * rowHeight + config.uiOffset.dy;
      for (int x = gridData.firstVisibleColumn;
          x < gridData.lastVisibleColumn;
          x++) {
        final fill = _cells[y]?[x];
        var dx = x * config.cellWidth + config.uiOffset.dx;
        if (fill is _HeaderFillData) {
          _paintFill(dx, dy, canvas, config.style.activityLabelColor);
        } else if (fill is _EventFillData) {
          _paintEvent(dx, dy, canvas, fill);
        } else if (fill is _WeekendFillData) {
          _paintFill(dx, dy, canvas, config.style.weekendColor!);
        } else if (fill is _HolidayFillData) {
          _paintFill(dx, dy, canvas, config.style.holidayColor);
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
      config.cellWidth + 1,
      rowHeight,
    );

    canvas.drawRect(
      rect.shift(config.panOffset),
      paint,
    );
  }

  void _paintEvent(double x, double y, Canvas canvas, _EventFillData fill) {
    var color = config.style.taskBarColor;
    if (fill.isHoliday || fill.isWeekend) {
      _paintFill(
          x,
          y,
          canvas,
          fill.isHoliday
              ? config.style.holidayColor
              : config.style.weekendColor!);
      color = color.withOpacity(0.5);
    }
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final radius = config.style.taskBarRadius;
    final rect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        x,
        y + _eventOffset,
        config.cellWidth + 1,
        grid.barHeight,
      ),
      topLeft: Radius.circular(fill.isFirst ? radius : 0),
      bottomLeft: Radius.circular(fill.isFirst ? radius : 0),
      topRight: Radius.circular(fill.isLast ? radius : 0),
      bottomRight: Radius.circular(fill.isLast ? radius : 0),
    );
    canvas.drawRRect(
      rect.shift(config.panOffset),
      paint,
    );
  }

  void _paintGrid(Canvas canvas, Size size, GanttVisibleData gridData) {
    _paintGridRows(size, canvas, gridData.visibleRows);
    _paintGridColumns(size, canvas, gridData.visibleColumns);
  }

  void _paintGridRows(Size size, Canvas canvas, int rows) {
    final double rowVerticalOffset =
        config.timelineHeight + (config.panOffset.dy % rowHeight);

    for (int y = 0; y < rows; y++) {
      final py = y * rowHeight + rowVerticalOffset;
      final p1 = Offset(config.labelColumnWidth, py);
      final p2 = Offset(size.width, py);
      final paint = Paint()
        ..color = config.style.gridColor!
        ..strokeWidth = 1;
      canvas.drawLine(p1, p2, paint);
    }
  }

  void _paintGridColumns(Size size, Canvas canvas, int columns) {
    final double columnHorizontalOffset = config.labelColumnWidth +
        (config.panOffset.dx % grid.columnWidth);
    for (int x = 0; x < columns; x++) {
      final px = x * grid.columnWidth + columnHorizontalOffset;
      final p1 = Offset(px, config.timelineHeight);
      final p2 = Offset(px, size.height);
      final paint = Paint()
        ..color = config.style.gridColor!
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
