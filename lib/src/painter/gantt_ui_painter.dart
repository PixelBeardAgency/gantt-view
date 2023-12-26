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

    _paintScrollbars(canvas, size);
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

  void _paintScrollbars(Canvas canvas, Size size) {
    const padding = 4.0;
    const thickness = 10.0;
    const radius = Radius.circular(thickness / 2);
    const thumbSize = 30.0;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    final thumbPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 1;

    _paintVerticalScrollbar(size, padding, thickness, radius, canvas,
        backgroundPaint, thumbSize, thumbPaint);
    _paintHorizontalScrollbar(size, padding, thickness, radius, canvas,
        backgroundPaint, thumbSize, thumbPaint);
  }

  void _paintVerticalScrollbar(
    Size size,
    double padding,
    double thickness,
    Radius radius,
    Canvas canvas,
    Paint backgroundPaint,
    double thumbSize,
    Paint thumbPaint,
  ) {
    final scrollBarHeight =
        size.height - config.timelineHeight - padding * 2 - thickness;
    final scrollBarX = size.width - thickness;
    final scrollBarY = -config.timelineHeight;
    final scrollBarRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          scrollBarX - padding,
          -scrollBarY + padding,
          thickness,
          scrollBarHeight,
        ),
        radius);
    canvas.drawRRect(scrollBarRect, backgroundPaint);

    final scrollBarThumbY = scrollBarY +
        (scrollBarHeight * (panOffset.dy / config.maxDy)) -
        (panOffset.dy / config.maxDy * thumbSize);

    final scrollBarThumbRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          scrollBarX - padding,
          -scrollBarThumbY + padding,
          thickness,
          thumbSize,
        ),
        radius);
    canvas.drawRRect(scrollBarThumbRect, thumbPaint);
  }

  void _paintHorizontalScrollbar(
    Size size,
    double padding,
    double thickness,
    Radius radius,
    Canvas canvas,
    Paint backgroundPaint,
    double thumbSize,
    Paint thumbPaint,
  ) {
    final scrollBarWidth =
        size.width - config.labelColumnWidth - padding * 2 - thickness;
    final scrollBarX = config.labelColumnWidth;
    final scrollBarY = size.height - thickness;
    final scrollBarRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          scrollBarX + padding,
          scrollBarY - padding,
          scrollBarWidth,
          thickness,
        ),
        radius);
    canvas.drawRRect(scrollBarRect, backgroundPaint);

    final scrollBarThumbX = scrollBarX +
        (scrollBarWidth * (-panOffset.dx / config.maxDx)) -
        (-panOffset.dx / config.maxDx * thumbSize);

    final scrollBarThumbRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          scrollBarThumbX + padding,
          scrollBarY - padding,
          thumbSize,
          thickness,
        ),
        radius);
    canvas.drawRRect(scrollBarThumbRect, thumbPaint);
  }
}
