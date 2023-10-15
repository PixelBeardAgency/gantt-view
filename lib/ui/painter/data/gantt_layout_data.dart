import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_event_list_extension.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/settings/gantt_settings.dart';

class GanttChartLayoutData {
  final GanttSettings settings;
  final Iterable<GanttEvent> data;

  late double labelColumnWidth;
  late double timelineHeight;
  late double maxDx;
  late double maxDy;

  int get widthDivisor => switch (settings.gridScheme.timelineAxisType) {
        TimelineAxisType.daily => 1,
        TimelineAxisType.weekly => 7,
      };

  Offset get uiOffset => Offset(labelColumnWidth, timelineHeight);
  int get maxColumns => switch (settings.gridScheme.timelineAxisType) {
        TimelineAxisType.daily => data.days,
        TimelineAxisType.weekly => data.weeks,
      };

  GanttChartLayoutData(BuildContext context,
      {required this.data, required this.settings}) {
    labelColumnWidth = _getTitleWidth();
    timelineHeight = _getLegendHeight();
    maxDx = _getHorizontalScrollBoundary(
      settings.gridScheme.columnWidth,
      MediaQuery.of(context).size.width,
      labelColumnWidth,
    );
    maxDy = _getVerticalScrollBoundary(
      data,
      settings.gridScheme.rowHeight,
      timelineHeight,
      settings.gridScheme.rowSpacing,
    );
  }

  double _getHorizontalScrollBoundary(
          double columnWidth, double screenWidth, double offset) =>
      (maxColumns * columnWidth) - screenWidth + offset;

  double _getVerticalScrollBoundary(Iterable<GanttEvent> data, double rowHeight,
          double offset, double rowSpacing) =>
      (data.length * (rowHeight + rowSpacing)) -
      offset +
      rowHeight +
      rowSpacing;

  double _getTitleWidth() {
    double width = 0;
    for (var rowData in data) {
      final textPainter =
          headerPainter(rowData.label, settings.style.eventLabelStyle);
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
