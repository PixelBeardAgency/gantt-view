import 'package:flutter/material.dart';
import 'package:gantt_view/src/model/grid_row.dart';
import 'package:gantt_view/src/painter/gantt_painter.dart';

class GanttUiPainter extends GanttPainter {
  GanttUiPainter({
    required super.config,
    required super.panOffset,
    required super.rows,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _paintHeaders(
      gridData.firstVisibleRow,
      gridData.lastVisibleRow,
      canvas,
    );

    _paintLegend(canvas);

    _paintTitle(canvas);

    if (config.style.axisDividerColor != null) {
      _paintDividers(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant GanttUiPainter oldDelegate) =>
      super.shouldRepaint(oldDelegate);

  void _paintLegend(Canvas canvas) {
    int firstVisibleColumn = gridData.firstVisibleColumn ~/ config.widthDivisor;
    int lastVisibleColumn =
        (gridData.lastVisibleColumn / config.widthDivisor).ceil();

    int previousYear = 0;
    int previousMonth = 0;
    int previousDay = 0;

    for (int x = firstVisibleColumn; x < lastVisibleColumn; x++) {
      final paint = Paint()
        ..color = config.style.timelineColor
        ..style = PaintingStyle.fill;

      final rect = Rect.fromLTWH(
        (x * config.grid.columnWidth) + config.uiOffset.dx,
        0 - panOffset.dy,
        config.grid.columnWidth + 1,
        config.timelineHeight,
      );
      canvas.drawRect(
        rect.shift(panOffset),
        paint,
      );

      final date = DateTime(config.startDate.year, config.startDate.month,
          config.startDate.day + (x * config.widthDivisor));
      final textPainter = config.datePainter([
        if (config.grid.showYear)
          previousYear == date.year ? '' : '${date.year}',
        if (config.grid.showMonth)
          previousMonth == date.month ? '' : '${date.month}',
        if (config.grid.showDay) previousDay == date.day ? '' : '${date.day}',
      ]);

      textPainter.paint(
        canvas,
        Offset(
              rect.left +
                  (config.grid.columnWidth / 2) -
                  (textPainter.width / 2),
              rect.bottom -
                  textPainter.height -
                  config.style.titlePadding.bottom,
            ) +
            panOffset,
      );

      previousYear = date.year;
      previousMonth = date.month;
      previousDay = date.day;
    }
  }

  void _paintHeaders(int firstVisibleRow, int lastVisibleRow, Canvas canvas) {
    final backgroundOffset = Offset(0, panOffset.dy);
    final textYOffset =
        (config.grid.barHeight / 2) + config.style.labelPadding.top;

    for (int index = firstVisibleRow; index < lastVisibleRow; index++) {
      final header = rows[index];

      var backgroundRect = Rect.fromLTWH(
        0,
        index * config.rowHeight + config.timelineHeight,
        config.labelColumnWidth,
        config.rowHeight + 1,
      );

      final titlePaint = Paint()
        ..color = header is TaskGridRow
            ? config.style.taskLabelColor
            : config.style.activityLabelColor
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        backgroundRect.shift(backgroundOffset),
        titlePaint,
      );

      final textPainter = config.textPainter(
        header.label ?? '',
        header is TaskGridRow
            ? config.style.taskLabelStyle
            : config.style.activityLabelStyle,
        maxLines: 1,
      );

      textPainter.paint(
        canvas,
        Offset(
              0 + config.style.labelPadding.left,
              backgroundRect.top - (textPainter.height / 2) + textYOffset,
            ) +
            backgroundOffset,
      );
    }
  }

  void _paintTitle(Canvas canvas) {
    const startOffset = Offset.zero;

    final endOffset = Offset(
      config.uiOffset.dx,
      config.uiOffset.dy,
    );

    var titleRect = Rect.fromPoints(
      startOffset,
      endOffset,
    );

    final titlePaint = Paint()
      ..color = config.style.timelineColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      titleRect,
      titlePaint,
    );

    final textPainter = config.titlePainter();

    textPainter.paint(
      canvas,
      Offset(
        0 + config.style.titlePadding.left,
        titleRect.bottom -
            textPainter.height -
            config.style.titlePadding.bottom,
      ),
    );
  }

  void _paintDividers(Canvas canvas, Size size) {
    final py = config.timelineHeight;
    final px = config.labelColumnWidth;
    final paint = Paint()
      ..color = config.style.axisDividerColor!
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, py), Offset(size.width, py), paint);
    canvas.drawLine(Offset(px, 0), Offset(px, size.height), paint);
  }
}
