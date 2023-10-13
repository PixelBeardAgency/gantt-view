import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_event_list_extension.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/model/gantt_row_data.dart';
import 'package:gantt_view/settings/gantt_settings.dart';

class GanttChartLayoutData {
  final GanttSettings settings;

  late double titleWidth;
  late double legendHeight;
  late double maxDx;
  late double maxDy;

  GanttChartLayoutData({
    required Iterable<GanttEvent> data,
    required this.settings,
    required Size screenSize,
  }) {
    titleWidth = _getTitleWidth(data);
    legendHeight = _getLegendHeight();
    maxDx = _getHorizontalScrollBoundary(
      data,
      settings.legendTheme.dateWidth,
      screenSize.width,
      titleWidth,
    );
    maxDy = _getVerticalScrollBoundary(
      data,
      settings.eventRowTheme.height,
      legendHeight,
      settings.rowSpacing,
    );
  }

  Offset get uiOffset => Offset(titleWidth, legendHeight);

  double _getHorizontalScrollBoundary(Iterable<GanttEvent> data,
          double columnWidth, double screenWidth, double offset) =>
      (data.days * columnWidth) - screenWidth + offset;

  double _getVerticalScrollBoundary(Iterable<GanttEvent> data, double rowHeight,
          double offset, double rowSpacing) =>
      (data.length * (rowHeight + rowSpacing)) -
      offset +
      rowHeight +
      rowSpacing;

  double _getTitleWidth(Iterable<GanttRowData> data) {
    double width = 0;
    for (var rowData in data) {
      final textPainter = headerPainter(rowData.label);
      width = max(width, textPainter.width);
    }
    return max(width, titlePainter().width);
  }

  double _getLegendHeight() => max(
        datePainter(
          [
            if (settings.legendTheme.showYear) '2021',
            if (settings.legendTheme.showMonth) '12',
            if (settings.legendTheme.showDay) '31',
          ],
        ).height,
        titlePainter().height,
      );

  TextPainter titlePainter() {
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
      maxWidth: double.infinity,
    );
    return textPainter;
  }

  TextPainter datePainter(Iterable<String> dates) {
    final textPainter = TextPainter(
      maxLines: 3,
      textAlign: TextAlign.center,
      text: TextSpan(
        text: dates.join('\n'),
        style: settings.legendTheme.dateStyle,
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: settings.legendTheme.dateWidth,
    );

    return textPainter;
  }

  TextPainter headerPainter(String label) {
    final textPainter = TextPainter(
      maxLines: 1,
      text: TextSpan(
        text: label,
        style: settings.headerRowTheme.textStyle ??
            const TextStyle(color: Colors.black),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: double.infinity,
    );
    return textPainter;
  }
}
