import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/gantt_view.dart';
import 'package:gantt_view/src/painter/gantt_painter.dart';
import 'package:gantt_view/src/settings/gantt_visible_data.dart';
import 'package:gantt_view/src/util/datetime_extension.dart';

class GanttDataPainter<T> extends GanttPainter {
  final Offset tooltipOffset;

  String? _tooltip;

  GanttDataPainter({
    required super.config,
    required super.panOffset,
    required this.tooltipOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (config.style.gridColor != null) {
      _paintGridColumns(size, canvas, gridData.visibleColumns);
    }

    _paintCells(canvas, size, gridData);

    _paintDateLines(
      config.dateLines,
      size,
      canvas,
    );

    if (config.style.tooltipType != TooltipType.none && _tooltip != null) {
      _paintTooltip(canvas, gridData, _tooltip!);
    }
  }

  @override
  bool shouldRepaint(covariant GanttDataPainter oldDelegate) =>
      super.shouldRepaint(oldDelegate) ||
      oldDelegate.tooltipOffset != tooltipOffset;

  void _paintCells(Canvas canvas, Size size, GanttVisibleData gridData) {
    for (int y = gridData.firstVisibleRow; y < gridData.lastVisibleRow; y++) {
      final row = config.rows[y].$1;
      var rowHeight = config.rows[y].$2.height;
      var dy = gridData.rowOffsets[y];

      if (config.style.gridColor != null) {
        _paintGridRow(dy, size, canvas);
      }

      for (int x = gridData.firstVisibleColumn;
          x < gridData.lastVisibleColumn;
          x++) {
        var dx = x * config.cellWidth;

        final currentOffset = (config.weekendOffset + x) % 7;
        final isWeekend = currentOffset == 5 || currentOffset == 6;

        final isHighlighted = config.highlightedColumns.contains(x);
        final backgroundRect =
            Rect.fromLTWH(dx, dy, config.cellWidth + 1, rowHeight);

        if (row is TaskGridRow<T>) {
          final task = row;

          final start = task.startDate;
          final end = task.endDate;

          final int from = start.numberOfDaysBetween(config.startDate) - 1;
          final int to = end.numberOfDaysBetween(config.startDate) - 1;

          if (start.isAtSameMomentAs(end) && start.isAfter(end)) {
            throw Exception('Start date must be before or same as end date.');
          }
          final isFilled = x >= from && x <= to;
          final isFirst = x == from;
          final isLast = x == to;

          if (isFilled) {
            final taskDx = dx +
                (isFirst && !config.style.snapToDay
                    ? config.cellWidth * row.startDate.dayProgress
                    : 0);
            final taskWidth = (isLast && !config.style.snapToDay
                    ? (config.cellWidth -
                            (config.cellWidth * row.endDate.dayProgress)) -
                        (taskDx - dx)
                    : config.cellWidth) +
                1;

            final taskHeight = min(rowHeight, config.style.barHeight);
            _paintTask(
              Rect.fromLTWH(dx, dy, config.cellWidth + 1, rowHeight),
              Rect.fromLTWH(taskDx, dy + (rowHeight - taskHeight) / 2,
                  taskWidth, taskHeight),
              canvas,
              _TaskGridCell(
                task.tooltip,
                isFirst,
                isLast,
                isHighlighted: isHighlighted,
                isWeekend: isWeekend,
              ),
            );
          } else if (isHighlighted) {
            _paintFill(backgroundRect, canvas, config.style.holidayColor);
          } else if (isWeekend && config.style.weekendColor != null) {
            _paintFill(backgroundRect, canvas, config.style.weekendColor!);
          }
        } else if (isHighlighted) {
          _paintFill(backgroundRect, canvas, config.style.holidayColor);
        } else if (isWeekend && config.style.weekendColor != null) {
          _paintFill(backgroundRect, canvas, config.style.weekendColor!);
        } else if (row is ActivityGridRow) {
          _paintFill(backgroundRect, canvas, config.style.activityLabelColor);
        }
      }

      dy += rowHeight;
    }
  }

  void _paintFill(Rect rect, Canvas canvas, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      rect.shift(panOffset),
      paint,
    );
  }

  void _paintTask(
      Rect backgroundRect, Rect taskRect, Canvas canvas, _TaskGridCell fill) {
    var color = config.style.taskBarColor;
    if (fill.isHighlighted ||
        (fill.isWeekend && config.style.weekendColor != null)) {
      _paintFill(
          backgroundRect,
          canvas,
          fill.isHighlighted
              ? config.style.holidayColor
              : config.style.weekendColor!);
      color = color.withOpacity(0.5);
    }
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final radius = config.style.taskBarRadius;
    final rect = RRect.fromRectAndCorners(
      taskRect,
      topLeft: Radius.circular(fill.isFirst ? radius : 0),
      bottomLeft: Radius.circular(fill.isFirst ? radius : 0),
      topRight: Radius.circular(fill.isLast ? radius : 0),
      bottomRight: Radius.circular(fill.isLast ? radius : 0),
    );
    canvas.drawRRect(
      rect.shift(panOffset),
      paint,
    );

    if (config.style.tooltipType != TooltipType.none &&
        rect.contains(tooltipOffset)) {
      _tooltip = fill.tooltip!;
    }
  }

  void _paintGridRow(double dy, Size size, Canvas canvas) {
    final p1 = Offset(0, dy + panOffset.dy);
    final p2 = Offset(size.width, dy + panOffset.dy);
    final paint = Paint()
      ..color = config.style.gridColor!
      ..strokeWidth = 1;
    canvas.drawLine(p1, p2, paint);
  }

  void _paintGridColumns(Size size, Canvas canvas, int columns) {
    final double columnHorizontalOffset =
        panOffset.dx % config.style.columnWidth;
    for (int x = 0; x < columns; x++) {
      final px = x * config.style.columnWidth + columnHorizontalOffset;
      final p1 = Offset(px, 0);
      final p2 = Offset(px, size.height);
      final paint = Paint()
        ..color = config.style.gridColor!
        ..strokeWidth = 1;
      canvas.drawLine(p1, p2, paint);
    }
  }

  void _paintDateLines(List<GanttDateLine> lines, Size size, Canvas canvas) {
    // Get date offset
    for (var line in lines) {
      final double horizontalColumnOffset =
          (line.date.difference(config.startDate).inDays *
                  config.style.columnWidth) +
              panOffset.dx;

      // Get offset based on current time
      final double columnTimeOffset =
          config.style.columnWidth * line.time.dayProgress;

      final double timelineOffset = horizontalColumnOffset + columnTimeOffset;

      final lowerLimit = timelineOffset - line.width;
      final upperLimit = timelineOffset + line.width;
      final showTooltip =
          tooltipOffset.dx > lowerLimit && tooltipOffset.dx < upperLimit;

      final px = timelineOffset;
      final p1 = Offset(px, 0);
      final p2 = Offset(px, size.height);
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = showTooltip ? line.width + 2 : line.width;

      canvas.drawLine(p1, p2, paint);

      if (config.style.tooltipType != TooltipType.none &&
          tooltipOffset.dx > lowerLimit &&
          tooltipOffset.dx < upperLimit) {
        _tooltip = line.date.toString();
      }
    }
  }

  void _paintTooltip(Canvas canvas, GanttVisibleData gridData, String label) {
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: config.style.tooltipStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    painter.layout(
      minWidth: 0,
      maxWidth: config.style.tooltipWidth,
    );

    var startOffset = Offset(
      tooltipOffset.dx - painter.width / 2,
      tooltipOffset.dy - config.style.tooltipPadding.vertical - painter.height,
    );

    final backgroundWidth =
        painter.width + config.style.tooltipPadding.horizontal;
    final backgroundHeight =
        painter.height + config.style.tooltipPadding.vertical;

    // Tooltip is rendered off the start edge of the available space
    if (startOffset.dx - panOffset.dx < 0) {
      startOffset = Offset(
        panOffset.dx,
        startOffset.dy,
      );
    }

    // Tooltip is rendered off the end edge of the available space
    var limit = config.maxDx + config.renderAreaSize.width;
    var currentStartOffset = startOffset.dx + backgroundWidth + -panOffset.dx;

    if (currentStartOffset > limit) {
      startOffset = Offset(
        limit - backgroundWidth + panOffset.dx,
        startOffset.dy,
      );
    }

    // Tooltip is rendered off the top edge of the available space
    if (startOffset.dy - panOffset.dy < 0) {
      startOffset = Offset(
        startOffset.dx,
        panOffset.dy,
      );
    }

    final endOffset = startOffset + Offset(backgroundWidth, 0);

    var backgroundRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        startOffset.dx,
        endOffset.dy,
        backgroundWidth,
        backgroundHeight,
      ),
      topLeft: Radius.circular(config.style.tooltipRadius),
      bottomLeft: Radius.circular(config.style.tooltipRadius),
      topRight: Radius.circular(config.style.tooltipRadius),
      bottomRight: Radius.circular(config.style.tooltipRadius),
    );

    final backgroundPaint = Paint()
      ..color = config.style.tooltipColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      backgroundRect,
      backgroundPaint,
    );

    painter.paint(
      canvas,
      startOffset +
          Offset(
            config.style.tooltipPadding.left,
            config.style.tooltipPadding.top,
          ),
    );
  }
}

class _TaskGridCell {
  final String? tooltip;
  final bool isHighlighted;
  final bool isWeekend;
  final bool isFirst;
  final bool isLast;

  _TaskGridCell(
    this.tooltip,
    this.isFirst,
    this.isLast, {
    this.isHighlighted = false,
    this.isWeekend = false,
  });
}

extension on DateTime {
  double get dayProgress => (hour / 24) + (minute / 60 / 100);
}

extension on TimeOfDay {
  double get dayProgress => (hour / 24) + (minute / 60 / 100);
}
