import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_event_list_extension.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/model/gantt_row_data.dart';
import 'package:gantt_view/settings/gantt_settings.dart';

class GanttChartLayoutData {
  final GanttSettings settings;
  final Iterable<GanttRowData> data;

  late double labelColumnWidth;
  late double timelineHeight;
  late double maxDx;
  late double maxDy;

  int get widthDivisor => switch (settings.gridScheme.timelineAxisType) {
        TimelineAxisType.daily => 1,
        TimelineAxisType.weekly => 7,
      };

  Offset get uiOffset => Offset(labelColumnWidth, timelineHeight);
  int get maxRows => data.length;
  int get maxColumns => switch (settings.gridScheme.timelineAxisType) {
        TimelineAxisType.daily => data.whereType<GanttEvent>().days + 1,
        TimelineAxisType.weekly => data.whereType<GanttEvent>().weeks,
      };
  double get verticalPadding => settings.gridScheme.rowSpacing / 2;

  GanttChartLayoutData(
      {required this.data, required this.settings, required Size size}) {
    labelColumnWidth = _getTitleWidth();
    timelineHeight = _getLegendHeight();
    maxDx = _getHorizontalScrollBoundary(size.width);
    maxDy = _getVerticalScrollBoundary(size.height);
  }

  double _getHorizontalScrollBoundary(double screenWidth) {
    var dataWidth = maxColumns * settings.gridScheme.columnWidth;
    var renderAreaWidth = screenWidth - labelColumnWidth;
    return dataWidth < renderAreaWidth
        ? 0
        : dataWidth - screenWidth + labelColumnWidth;
  }

  double _getVerticalScrollBoundary(double screenHeight) {
    var fullRowHeight =
        settings.gridScheme.rowHeight + (settings.gridScheme.rowSpacing / 2);
    var dataHeight = data.length * fullRowHeight;
    var renderAreaHeight = screenHeight - timelineHeight;
    return dataHeight < renderAreaHeight
        ? 0
        : dataHeight - screenHeight + timelineHeight;
  }

  double _getTitleWidth() {
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
