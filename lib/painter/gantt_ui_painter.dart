import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/painter/gantt_painter.dart';

class GanttUiPainter extends GanttPainter {
  final List<_HeaderData> _headers = [];

  GanttUiPainter({
    required super.config,
  }) {
    for (var activity in config.activities) {
      if (activity.label != null) {
        _headers.add(_ActivityHeaderData(activity.label));
      }
      _headers.addAll(activity.tasks.map((e) => _TaskHeaderData(e.label)));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    var gridData = config.gridData;

    _paintHeaders(
      gridData.firstVisibleRow,
      gridData.lastVisibleRow,
      canvas,
    );

    _paintLegend(
      gridData.firstVisibleColumn,
      gridData.lastVisibleColumn,
      canvas,
    );

    _paintTitle(canvas);

    if (config.style.axisDividerColor != null) {
      _paintDividers(canvas, size);
    }
  }

  void _paintLegend(
      int firstVisibleColumn, int lastVisibleColumn, Canvas canvas) {
    int previousYear = 0;
    int previousMonth = 0;
    int previousDay = 0;

    double height = 0;
    for (int x = firstVisibleColumn; x < lastVisibleColumn; x++) {
      final paint = Paint()
        ..color = config.style.timelineColor
        ..style = PaintingStyle.fill;

      final rect = Rect.fromLTWH(
        (x * grid.columnWidth) + config.uiOffset.dx,
        0 - config.panOffset.dy,
        grid.columnWidth + 1,
        config.timelineHeight,
      );
      canvas.drawRect(
        rect.shift(config.panOffset),
        paint,
      );

      final date = DateTime(startDate.year, startDate.month,
          startDate.day + (x * config.widthDivisor));
      final textPainter = config.datePainter([
        if (config.grid.showYear)
          previousYear == date.year ? '' : '${date.year}',
        if (config.grid.showMonth)
          previousMonth == date.month ? '' : '${date.month}',
        if (config.grid.showDay)
          previousDay == date.day ? '' : '${date.day}',
      ]);

      textPainter.paint(
        canvas,
        Offset(
              rect.left +
                  (grid.columnWidth / 2) -
                  (textPainter.width / 2),
              rect.bottom -
                  textPainter.height -
                  config.style.titlePadding.bottom,
            ) +
            config.panOffset,
      );

      previousYear = date.year;
      previousMonth = date.month;
      previousDay = date.day;

      height = max(height, textPainter.height);
    }
  }

  void _paintHeaders(int firstVisibleRow, int lastVisibleRow, Canvas canvas) {
    for (int index = firstVisibleRow; index < lastVisibleRow; index++) {
      final header = _headers[index];

      var backgroundRect = Rect.fromLTWH(
        0,
        index * rowHeight + config.timelineHeight,
        config.labelColumnWidth,
        rowHeight + 1,
      );

      final titlePaint = Paint()
        ..color = header is _TaskHeaderData
            ? config.style.taskLabelColor
            : config.style.activityLabelColor
        ..style = PaintingStyle.fill;

      final backgroundOffset = Offset(0, config.panOffset.dy);

      canvas.drawRect(
        backgroundRect.shift(backgroundOffset),
        titlePaint,
      );

      final textPainter = config.headerPainter(
          header.label ?? '',
          header is _TaskHeaderData
              ? config.style.taskLabelStyle
              : config.style.activityLabelStyle);

      textPainter.paint(
        canvas,
        Offset(
              0 + ganttStyle.labelPadding.left,
              backgroundRect.top +
                  (grid.barHeight / 2) -
                  (textPainter.height / 2) +
                  ganttStyle.labelPadding.top,
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
        0 + ganttStyle.titlePadding.left,
        titleRect.bottom - textPainter.height - ganttStyle.titlePadding.bottom,
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

abstract class _HeaderData {
  final String? label;

  _HeaderData(this.label);
}

class _ActivityHeaderData extends _HeaderData {
  _ActivityHeaderData(String? label) : super(label);
}

class _TaskHeaderData extends _HeaderData {
  _TaskHeaderData(String label) : super(label);
}
