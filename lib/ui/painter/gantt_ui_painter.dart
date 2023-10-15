import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/model/gantt_row_data.dart';
import 'package:gantt_view/ui/painter/gantt_painter.dart';

class GanttUiPainter extends GanttPainter {
  GanttUiPainter({
    required super.data,
    required super.panOffset,
    required super.layoutData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var gridData = super.gridData(size);

    for (int index = gridData.firstVisibleRow;
        index < gridData.lastVisibleRow;
        index++) {
      final rowData = data[index];

      _paintHeader(index, canvas, rowData, size.width);
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
      if (layoutData.settings.gridScheme.showYear ||
          layoutData.settings.gridScheme.showMonth ||
          layoutData.settings.gridScheme.showDay) {
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

        final date = startDate.add(Duration(days: x * layoutData.widthDivisor));
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
                rect.bottom - textPainter.height,
              ) +
              panOffset,
        );

        previousYear = date.year;
        previousMonth = date.month;
        previousDay = date.day;

        height = max(height, textPainter.height);
      }
    }
  }

  void _paintHeader(
      int index, Canvas canvas, GanttRowData rowData, double width) {
    final verticalMargin = gridScheme.rowSpacing / 2;

    final startOffset = Offset(
      0,
      index * gridScheme.rowHeight,
    );

    final endOffset = Offset(
      rowData is GanttEvent ? layoutData.uiOffset.dx : width,
      (index + 1) * gridScheme.rowHeight,
    );

    var titleRect = Rect.fromPoints(
      startOffset,
      endOffset,
    );

    final titlePaint = Paint()
      ..color = rowData is GanttEvent
          ? layoutData.settings.style.eventLabelColor
          : layoutData.settings.style.eventHeaderColor
      ..style = PaintingStyle.fill;

    final titleOffset = Offset(
        0,
        panOffset.dy +
            layoutData.uiOffset.dy +
            (index * verticalMargin) +
            verticalMargin);

    canvas.drawRect(
      titleRect.shift(titleOffset),
      titlePaint,
    );

    final textPainter = layoutData.headerPainter(
        rowData.label,
        rowData is GanttEvent
            ? layoutData.settings.style.eventLabelStyle
            : layoutData.settings.style.eventHeaderStyle);

    textPainter.paint(
      canvas,
      Offset(
            0,
            titleRect.top +
                ((gridScheme.rowHeight / 2)) -
                (textPainter.height / 2),
          ) +
          titleOffset,
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
        0,
        titleRect.bottom - textPainter.height,
      ),
    );
  }
}
