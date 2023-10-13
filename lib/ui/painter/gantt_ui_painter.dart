import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/model/gantt_row_data.dart';
import 'package:gantt_view/ui/painter/gantt_painter.dart';

class GanttUiPainter extends GanttPainter {
  GanttUiPainter({
    required super.data,
    required super.panOffset,
    required super.settings,
    required super.uiOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final visibleRows = (size.height / rowHeight).ceil();
    final int firstVisibleRow = max(0, (-panOffset.dy / rowHeight).floor());
    final int lastVisibleRow = min(data.length, firstVisibleRow + visibleRows);

    final visibleColumns = (size.width / columnWidth).ceil();
    final int firstVisibleColumn = max(0, (-panOffset.dx ~/ columnWidth));
    final int lastVisibleColumn =
        min(firstVisibleColumn + visibleColumns + 2, maxColumns);

    _paintLegend(
      firstVisibleColumn,
      lastVisibleColumn,
      canvas,
    );

    for (int index = firstVisibleRow; index < lastVisibleRow; index++) {
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
      if (settings.legendTheme.showYear) {
        final date = startDate.add(Duration(days: x));

        final textPainter = TextPainter(
          maxLines: 3,
          textAlign: TextAlign.center,
          text: TextSpan(
            text: [
              if (settings.legendTheme.showYear)
                previousYear == date.year ? '' : '${date.year}',
              if (settings.legendTheme.showMonth)
                previousMonth == date.month ? '' : '${date.month}',
              if (settings.legendTheme.showDay)
                previousDay == date.day ? '' : '${date.day}',
            ].join('\n'),
            style: settings.headerRowTheme.textStyle,
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(
          minWidth: 0,
          maxWidth: columnWidth,
        );

        final paint = Paint()
          ..color = settings.legendTheme.backgroundColor
          ..style = PaintingStyle.fill;

        final rect = Rect.fromLTWH(
          (x * columnWidth) + uiOffset.dx,
          0 - panOffset.dy,
          columnWidth,
          textPainter.height,
        );
        canvas.drawRect(
          rect.shift(panOffset),
          paint,
        );

        textPainter.paint(
          canvas,
          Offset(
                rect.left + (columnWidth / 2) - (textPainter.width / 2),
                rect.top,
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
    final startOffset = Offset(
      0,
      index * rowHeight,
    );

    final endOffset = Offset(
      uiOffset.dx,
      (index + 1) * rowHeight,
    );

    var titleRect = Rect.fromPoints(
      startOffset,
      endOffset,
    );

    final titlePaint = Paint()
      ..color = rowData is GanttEvent
          ? settings.headerRowTheme.backgroundColor
          : settings.eventRowTheme.labelColor
      ..style = PaintingStyle.fill;

    final titleOffset = Offset(0, panOffset.dy + uiOffset.dy);
    canvas.drawRect(
      titleRect.shift(titleOffset),
      titlePaint,
    );

    final textPainter = TextPainter(
      maxLines: 1,
      text: TextSpan(
        text: rowData.label,
        style: settings.headerRowTheme.textStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: uiOffset.dx,
    );

    textPainter.paint(
      canvas,
      Offset(
            0,
            titleRect.top + rowHeight / 4,
          ) +
          titleOffset,
    );
  }

  void _paintTitle(Canvas canvas) {
    const startOffset = Offset.zero;

    final endOffset = Offset(
      uiOffset.dx,
      uiOffset.dy,
    );

    var titleRect = Rect.fromPoints(
      startOffset,
      endOffset,
    );

    final titlePaint = Paint()
      ..color = settings.legendTheme.backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      titleRect,
      titlePaint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: settings.title,
        style: settings.legendTheme.titleStyle,
        children: [
          TextSpan(
            text: '\n${settings.subtitle}',
            style: settings.legendTheme.subtitleStyle,
          )
        ],
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: uiOffset.dx,
    );

    textPainter.paint(
      canvas,
      Offset(
        0,
        titleRect.top + rowHeight / 4,
      ),
    );
  }
}
