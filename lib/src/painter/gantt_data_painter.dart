import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/gantt_view.dart';
import 'package:gantt_view/src/painter/gantt_painter.dart';
import 'package:gantt_view/src/settings/gantt_visible_data.dart';
import 'package:gantt_view/src/util/datetime_extension.dart';

class GanttDataPainter<T> extends GanttPainter {
  final Offset tooltipOffset;

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

    if (config.style.tooltipType != TooltipType.none) {
      _paintTooltip(canvas, gridData);
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

          if (isFilled) {
            _paintTask(
              dx,
              dy,
              rowHeight,
              canvas,
              _TaskGridCell(
                task.tooltip,
                x == from,
                x == to,
                isHighlighted: isHighlighted,
                isWeekend: isWeekend,
              ),
            );
          } else if (isHighlighted) {
            _paintFill(dx, dy, rowHeight, canvas, config.style.holidayColor);
          } else if (isWeekend && config.style.weekendColor != null) {
            _paintFill(dx, dy, rowHeight, canvas, config.style.weekendColor!);
          }
        } else if (isHighlighted) {
          _paintFill(dx, dy, rowHeight, canvas, config.style.holidayColor);
        } else if (isWeekend && config.style.weekendColor != null) {
          _paintFill(dx, dy, rowHeight, canvas, config.style.weekendColor!);
        } else if (row is ActivityGridRow) {
          _paintFill(
              dx, dy, rowHeight, canvas, config.style.activityLabelColor);
        }
      }

      dy += rowHeight;
    }
  }

  void _paintFill(
      double x, double y, double height, Canvas canvas, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(
      x,
      y,
      config.cellWidth + 1,
      height,
    );

    canvas.drawRect(
      rect.shift(panOffset),
      paint,
    );
  }

  void _paintTask(
      double x, double y, double height, Canvas canvas, _TaskGridCell fill) {
    var color = config.style.taskBarColor;
    if (fill.isHighlighted ||
        (fill.isWeekend && config.style.weekendColor != null)) {
      _paintFill(
          x,
          y,
          height,
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
      Rect.fromLTWH(
        x,
        y + (height - min(height, config.style.barHeight)) / 2,
        config.cellWidth + 1,
        min(height, config.style.barHeight),
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

  void _paintTooltip(Canvas canvas, GanttVisibleData gridData) {
    final firstColumnOffset = ((-panOffset.dx) % config.cellWidth);
    final currentPosX = tooltipOffset.dx;

    var x = (currentPosX + firstColumnOffset) ~/
            (config.style.columnWidth / config.widthDivisor) +
        gridData.firstVisibleColumn;

    final firstRowOffset = (gridData.rowOffsets[gridData.firstVisibleRow]);
    final currentPosY = tooltipOffset.dy - panOffset.dy + firstRowOffset;

    final y = gridData.rowOffsets
            .indexWhere((offset) => currentPosY < offset + firstRowOffset) -
        1;

    if (x < 0 || y < 0) {
      return;
    }

    final row = config.rows[y].$1;
    if (row is! TaskGridRow) return;

    final int from = row.startDate.difference(config.startDate).inDays;
    final int to = row.endDate.difference(config.startDate).inDays;

    final isTask = x >= from && x <= to;

    if (!isTask || (row.tooltip?.isEmpty ?? true)) {
      return;
    }

    final painter = TextPainter(
      text: TextSpan(
        text: row.tooltip!,
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

      final px = timelineOffset;
      final p1 = Offset(px, 0);
      final p2 = Offset(px, size.height);
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = line.width;

      canvas.drawLine(p1, p2, paint);
    }
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

extension on TimeOfDay {
  double get dayProgress => (hour / 24) + (minute / 60 / 100);
}
