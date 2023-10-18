import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/ui/painter/gantt_painter.dart';

class GanttUiPainter extends GanttPainter {
  final List<_HeaderData> _headers = [];

  GanttUiPainter({
    required super.panOffset,
    required super.layoutData,
  }) {
    for (var activity in layoutData.activities) {
      if (activity.label != null) {
        _headers.add(_ActivityHeaderData(activity.label));
      }
      _headers.addAll(activity.tasks.map((e) => _TaskHeaderData(e.label)));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    var gridData = super.gridData(size);

    for (int index = gridData.firstVisibleRow;
        index < gridData.lastVisibleRow;
        index++) {
      _paintHeaders(index, canvas);
    }

    _paintLegend(
      gridData.firstVisibleColumn,
      gridData.lastVisibleColumn,
      canvas,
    );

    _paintTitle(canvas);
  }

  void _paintLegend(
      int firstVisibleColumn, int lastVisibleColumn, Canvas canvas) {
    int previousYear = 0;
    int previousMonth = 0;
    int previousDay = 0;

    double height = 0;
    for (int x = firstVisibleColumn; x < lastVisibleColumn; x++) {
      final paint = Paint()
        ..color = layoutData.settings.style.timelineColor
        ..style = PaintingStyle.fill;

      final rect = Rect.fromLTWH(
        (x * gridScheme.columnWidth) + layoutData.uiOffset.dx,
        0 - panOffset.dy,
        gridScheme.columnWidth + 1,
        layoutData.timelineHeight,
      );
      canvas.drawRect(
        rect.shift(panOffset),
        paint,
      );
      
      final date = DateTime(startDate.year, startDate.month,
          startDate.day + (x * layoutData.widthDivisor));
      final textPainter = layoutData.datePainter([
        if (layoutData.settings.gridScheme.showYear)
          previousYear == date.year ? '' : '${date.year}',
        if (layoutData.settings.gridScheme.showMonth)
          previousMonth == date.month ? '' : '${date.month}',
        if (layoutData.settings.gridScheme.showDay)
          previousDay == date.day ? '' : '${date.day}',
      ]);

      textPainter.paint(
        canvas,
        Offset(
              rect.left +
                  (gridScheme.columnWidth / 2) -
                  (textPainter.width / 2),
              rect.bottom -
                  textPainter.height -
                  layoutData.settings.style.titlePadding.bottom,
            ) +
            panOffset,
      );

      previousYear = date.year;
      previousMonth = date.month;
      previousDay = date.day;

      height = max(height, textPainter.height);
    }
  }

  void _paintHeaders(int index, Canvas canvas) {
    final header = _headers[index];

    var backgroundRect = Rect.fromLTWH(
      0,
      index * rowHeight + layoutData.timelineHeight,
      layoutData.labelColumnWidth,
      rowHeight + 1,
    );

    final titlePaint = Paint()
      ..color = header is _TaskHeaderData
          ? layoutData.settings.style.taskLabelColor
          : layoutData.settings.style.activityLabelColor
      ..style = PaintingStyle.fill;

    final backgroundOffset = Offset(0, panOffset.dy);

    canvas.drawRect(
      backgroundRect.shift(backgroundOffset),
      titlePaint,
    );

    final textPainter = layoutData.headerPainter(
        header.label ?? '',
        header is _TaskHeaderData
            ? layoutData.settings.style.taskLabelStyle
            : layoutData.settings.style.activityLabelStyle);

    textPainter.paint(
      canvas,
      Offset(
            0 + ganttStyle.labelPadding.left,
            backgroundRect.top +
                (gridScheme.barHeight / 2) -
                (textPainter.height / 2) +
                ganttStyle.labelPadding.top,
          ) +
          backgroundOffset,
    );
  }

  void _paintTitle(Canvas canvas) {
    const startOffset = Offset.zero;

    final endOffset = Offset(
      layoutData.uiOffset.dx,
      layoutData.uiOffset.dy,
    );

    var titleRect = Rect.fromPoints(
      startOffset,
      endOffset,
    );

    final titlePaint = Paint()
      ..color = layoutData.settings.style.timelineColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      titleRect,
      titlePaint,
    );

    final textPainter = layoutData.titlePainter();

    textPainter.paint(
      canvas,
      Offset(
        0 + ganttStyle.titlePadding.left,
        titleRect.bottom - textPainter.height - ganttStyle.titlePadding.bottom,
      ),
    );
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
