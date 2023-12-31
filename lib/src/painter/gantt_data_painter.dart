import 'package:flutter/material.dart';
import 'package:gantt_view/src/model/grid_row.dart';
import 'package:gantt_view/src/model/tooltip_type.dart';
import 'package:gantt_view/src/painter/gantt_painter.dart';
import 'package:gantt_view/src/settings/gantt_visible_data.dart';

class GanttDataPainter extends GanttPainter {
  final Offset tooltipOffset;

  final double _taskOffset;

  GanttDataPainter({
    required super.rows,
    required super.config,
    required super.panOffset,
    required this.tooltipOffset,
  }) : _taskOffset =
            (config.grid.rowSpacing + config.style.labelPadding.vertical) / 2;

  @override
  void paint(Canvas canvas, Size size) {
    if (config.style.gridColor != null) {
      _paintGrid(canvas, size, gridData);
    }

    _paintCells(canvas, size, gridData);

    if (config.grid.tooltipType != TooltipType.none) {
      _paintTooltip(canvas, gridData);
    }
  }

  @override
  bool shouldRepaint(covariant GanttDataPainter oldDelegate) =>
      super.shouldRepaint(oldDelegate) ||
      oldDelegate.tooltipOffset != tooltipOffset;

  void _paintCells(Canvas canvas, Size size, GanttVisibleData gridData) {
    for (int y = gridData.firstVisibleRow; y < gridData.lastVisibleRow; y++) {
      var dy = y * config.rowHeight + config.uiOffset.dy;
      final row = rows[y];

      for (int x = gridData.firstVisibleColumn;
          x < gridData.lastVisibleColumn;
          x++) {
        var dx = x * config.cellWidth + config.uiOffset.dx;

        final currentOffset = (config.weekendOffset + x) % 7;
        final isWeekend = currentOffset == 5 || currentOffset == 6;

        final isHighlighted = config.highlightedColumns.contains(x);

        if (row is TaskGridRow) {
          final task = row.task;

          final start = task.startDate;
          final end = task.endDate;

          final int from = start.difference(config.startDate).inDays;
          final int to = end.difference(config.startDate).inDays;

          if (start.isAtSameMomentAs(end) && start.isAfter(end)) {
            throw Exception('Start date must be before or same as end date.');
          }
          final isFilled = x >= from && x <= to;

          if (isFilled) {
            _paintTask(
              dx,
              dy,
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
            _paintFill(dx, dy, canvas, config.style.holidayColor);
          } else if (isWeekend && config.style.weekendColor != null) {
            _paintFill(dx, dy, canvas, config.style.weekendColor!);
          }
        } else if (isHighlighted) {
          _paintFill(dx, dy, canvas, config.style.holidayColor);
        } else if (isWeekend && config.style.weekendColor != null) {
          _paintFill(dx, dy, canvas, config.style.weekendColor!);
        } else if (row is ActivityGridRow) {
          _paintFill(dx, dy, canvas, config.style.activityLabelColor);
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
      config.rowHeight,
    );

    canvas.drawRect(
      rect.shift(panOffset),
      paint,
    );
  }

  void _paintTask(double x, double y, Canvas canvas, _TaskGridCell fill) {
    var color = config.style.taskBarColor;
    if (fill.isHighlighted ||
        (fill.isWeekend && config.style.weekendColor != null)) {
      _paintFill(
          x,
          y,
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
        y + _taskOffset,
        config.cellWidth + 1,
        config.grid.barHeight,
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

  void _paintGrid(Canvas canvas, Size size, GanttVisibleData gridData) {
    _paintGridRows(size, canvas, gridData.visibleRows);
    _paintGridColumns(size, canvas, gridData.visibleColumns);
  }

  void _paintGridRows(Size size, Canvas canvas, int rows) {
    final double rowVerticalOffset =
        config.timelineHeight + (panOffset.dy % config.rowHeight);

    for (int y = 0; y < rows; y++) {
      final py = y * config.rowHeight + rowVerticalOffset;
      final p1 = Offset(config.labelColumnWidth, py);
      final p2 = Offset(size.width, py);
      final paint = Paint()
        ..color = config.style.gridColor!
        ..strokeWidth = 1;
      canvas.drawLine(p1, p2, paint);
    }
  }

  void _paintGridColumns(Size size, Canvas canvas, int columns) {
    final double columnHorizontalOffset =
        config.labelColumnWidth + (panOffset.dx % config.grid.columnWidth);
    for (int x = 0; x < columns; x++) {
      final px = x * config.grid.columnWidth + columnHorizontalOffset;
      final p1 = Offset(px, config.timelineHeight);
      final p2 = Offset(px, size.height);
      final paint = Paint()
        ..color = config.style.gridColor!
        ..strokeWidth = 1;
      canvas.drawLine(p1, p2, paint);
    }
  }

  void _paintTooltip(Canvas canvas, GanttVisibleData gridData) {
    final firstColumnOffset = ((-panOffset.dx) % config.cellWidth);
    final currentPosX = tooltipOffset.dx - config.labelColumnWidth;

    var x = (currentPosX + firstColumnOffset) ~/
            (config.grid.columnWidth / config.widthDivisor) +
        gridData.firstVisibleColumn;

    final firstRowOffset = ((-panOffset.dy) % config.rowHeight);
    final currentPosY = tooltipOffset.dy - config.timelineHeight;

    final y = ((currentPosY + firstRowOffset) ~/ config.rowHeight) +
        gridData.firstVisibleRow;

    if (x < 0 || y < 0) {
      return;
    }

    final row = rows[y];
    if (row is! TaskGridRow) return;

    final int from = row.task.startDate.difference(config.startDate).inDays;
    final int to = row.task.endDate.difference(config.startDate).inDays;

    final isTask = x >= from && x <= to;

    if (!isTask || (row.task.tooltip?.isEmpty ?? true)) {
      return;
    }

    final textPainter = config.textPainter(
      row.task.tooltip!,
      config.style.tooltipStyle,
      maxWidth: config.grid.tooltipWidth,
    );

    var startOffset = Offset(
      tooltipOffset.dx - textPainter.width / 2,
      tooltipOffset.dy -
          config.style.tooltipPadding.vertical -
          textPainter.height,
    );

    final backgroundWidth =
        textPainter.width + config.style.tooltipPadding.horizontal;
    final backgroundHeight =
        textPainter.height + config.style.tooltipPadding.vertical;

    // Tooltip is rendered off the start edge of the available space
    if (startOffset.dx - panOffset.dx < config.labelColumnWidth) {
      startOffset = Offset(
        config.labelColumnWidth + panOffset.dx,
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
    if (startOffset.dy - panOffset.dy < config.timelineHeight) {
      startOffset = Offset(
        startOffset.dx,
        config.timelineHeight + panOffset.dy,
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

    textPainter.paint(
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
