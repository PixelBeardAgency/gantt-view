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
      settings.gridScheme.columnWidth,
      screenSize.width,
      titleWidth,
    );
    maxDy = _getVerticalScrollBoundary(
      data,
      settings.gridScheme.rowHeight,
      legendHeight,
      settings.gridScheme.rowSpacing,
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
      final textPainter = headerPainter(
          rowData.label,
          rowData is GanttEvent
              ? settings.style.eventLabelStyle
              : settings.style.eventHeaderStyle);
      width = max(width, textPainter.width);
    }
    return max(width, titlePainter().width);
  }

  double _getLegendHeight() => max(
        datePainter(
          [
            if (settings.gridScheme.showYear) '2021',
            if (settings.gridScheme.showMonth) '12',
            if (settings.gridScheme.showDay) '31',
          ],
        ).height,
        titlePainter().height,
      );

  TextPainter titlePainter() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: settings.title,
        style: settings.style.titleStyle,
        children: [
          TextSpan(
            text: '\n${settings.subtitle}',
            style: settings.style.subtitleStyle,
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
        style: settings.style.timelineStyle,
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: settings.gridScheme.columnWidth,
    );

    return textPainter;
  }

  TextPainter headerPainter(String label, TextStyle style) {
    final textPainter = TextPainter(
      maxLines: 1,
      text: TextSpan(
        text: label,
        style: style,
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
