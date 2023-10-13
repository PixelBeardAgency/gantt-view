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

    _paintLegend(
      gridData.firstVisibleColumn,
      gridData.lastVisibleColumn,
      canvas,
    );

    for (int index = gridData.firstVisibleRow;
        index < gridData.lastVisibleRow;
        index++) {
      final rowData = data[index];

      _paintHeader(index, canvas, rowData);
    }

    _paintTitle(canvas);
  }

  void _paintLegend(
      int firstVisibleColumn, int lastVisibleColumn, Canvas canvas) {
    int previousYear = 0;
    int previousMonth = 0;
    int previousDay = 0;

    double height = 0;
    for (int x = firstVisibleColumn; x < lastVisibleColumn; x++) {
      if (layoutData.settings.legendTheme.showYear ||
          layoutData.settings.legendTheme.showMonth ||
          layoutData.settings.legendTheme.showDay) {
        final paint = Paint()
          ..color = layoutData.settings.legendTheme.backgroundColor
          ..style = PaintingStyle.fill;

        final rect = Rect.fromLTWH(
          (x * columnWidth) + layoutData.uiOffset.dx,
          0 - panOffset.dy,
          columnWidth,
          layoutData.legendHeight,
        );
        canvas.drawRect(
          rect.shift(panOffset),
          paint,
        );

        final date = startDate.add(Duration(days: x));
        final textPainter = layoutData.datePainter([
          if (layoutData.settings.legendTheme.showYear)
            previousYear == date.year ? '' : '${date.year}',
          if (layoutData.settings.legendTheme.showMonth)
            previousMonth == date.month ? '' : '${date.month}',
          if (layoutData.settings.legendTheme.showDay)
            previousDay == date.day ? '' : '${date.day}',
        ]);

        textPainter.paint(
          canvas,
          Offset(
                rect.left + (columnWidth / 2) - (textPainter.width / 2),
                rect.bottom - textPainter.height, // Align to bottom
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

  void _paintHeader(int index, Canvas canvas, GanttRowData rowData) {
    final verticalPadding = layoutData.settings.rowSpacing / 2;

    final startOffset = Offset(
      0,
      index * rowHeight,
    );

    final endOffset = Offset(
      layoutData.uiOffset.dx,
      (index + 1) * rowHeight,
    );

    var titleRect = Rect.fromPoints(
      startOffset,
      endOffset,
    );

    final titlePaint = Paint()
      ..color = rowData is GanttEvent
          ? layoutData.settings.eventRowTheme.labelColor
          : layoutData.settings.headerRowTheme.backgroundColor
      ..style = PaintingStyle.fill;

    final titleOffset = Offset(
        0,
        panOffset.dy +
            layoutData.uiOffset.dy +
            (index * verticalPadding) +
            verticalPadding);
    canvas.drawRect(
      titleRect.shift(titleOffset),
      titlePaint,
    );

    final textPainter = layoutData.headerPainter(rowData.label);

    textPainter.paint(
      canvas,
      Offset(
            0,
            titleRect.top,
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
      ..color = layoutData.settings.legendTheme.backgroundColor
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
        titleRect.top + rowHeight / 4,
      ),
    );
  }
}
