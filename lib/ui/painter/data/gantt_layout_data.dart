import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_activity_iterable_extension.dart';
import 'package:gantt_view/extension/gantt_task_iterable_extension.dart';
import 'package:gantt_view/model/gantt_activity.dart';
import 'package:gantt_view/settings/gantt_settings.dart';

class GanttChartLayoutData {
  final GanttSettings settings;
  final Iterable<GanttActivity> data;

  late double labelColumnWidth;
  late double timelineHeight;
  late double maxDx;
  late double maxDy;

  final double rowHeight;
  late double dataHeight;

  int get widthDivisor => switch (settings.gridScheme.timelineAxisType) {
        TimelineAxisType.daily => 1,
        TimelineAxisType.weekly => 7,
      };

  Offset get uiOffset => Offset(labelColumnWidth, timelineHeight);
  final int maxColumns;

  GanttChartLayoutData(
      {required this.data, required this.settings, required Size size})
      : rowHeight = settings.gridScheme.barHeight +
            settings.gridScheme.rowSpacing +
            settings.style.eventLabelPadding.vertical,
        maxColumns = switch (settings.gridScheme.timelineAxisType) {
          TimelineAxisType.daily =>
            data.expand((element) => element.tasks).days,
          TimelineAxisType.weekly =>
            data.expand((element) => element.tasks).weeks,
        } {
    dataHeight = (data.length + data.allTasks.length) * rowHeight;
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
    return dataHeight < (screenHeight - timelineHeight)
        ? 0
        : dataHeight - screenHeight + timelineHeight;
  }

  double _getTitleWidth() {
    double width = 0;
    for (var activity in data) {
      width = max(
        width,
        headerPainter(activity.label ?? '', settings.style.eventHeaderStyle)
                .width +
            settings.style.eventLabelPadding.horizontal,
      );

      for (var task in activity.tasks) {
        width = max(
          width,
          headerPainter(task.label, settings.style.eventLabelStyle).width +
              settings.style.eventLabelPadding.horizontal,
        );
      }
    }
    return max(
        width, titlePainter().width + settings.style.titlePadding.horizontal);
  }

  double _getLegendHeight() => max(
        datePainter(
          [
            if (settings.gridScheme.showYear) '2022',
            if (settings.gridScheme.showMonth) '12',
            if (settings.gridScheme.showDay) '31',
          ],
        ).height,
        titlePainter().height + settings.style.titlePadding.vertical,
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
