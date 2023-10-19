import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_activity_iterable_extension.dart';
import 'package:gantt_view/model/gantt_activity.dart';
import 'package:gantt_view/model/timeline_axis_type.dart';
import 'package:gantt_view/settings/gantt_grid.dart';
import 'package:gantt_view/settings/gantt_style.dart';
import 'package:gantt_view/settings/gantt_visible_data.dart';

class GanttConfig {
  final Iterable<GanttActivity> activities;

  final GanttGrid grid;
  final GanttStyle style;

  final String? title;
  final String? subtitle;

  final Size containerSize;

  final Offset panOffset;

  late double labelColumnWidth;
  late double timelineHeight;
  late double maxDx;
  late double maxDy;

  late double rowHeight;
  late double dataHeight;

  late DateTime startDate;
  late DateTime endDate;

  late int weekendOffset;
  late List<int> highlightedColumns;

  late int columns;
  late double cellWidth;

  Offset tooltipOffset = Offset.zero;

  int get widthDivisor => switch (grid.timelineAxisType) {
        TimelineAxisType.daily => 1,
        TimelineAxisType.weekly => 7,
      };

  late Offset uiOffset;

  GanttConfig({
    required this.activities,
    GanttGrid? grid,
    GanttStyle? style,
    this.title,
    this.subtitle,
    required this.containerSize,
    required this.panOffset,
    List<DateTime>? highlightedDates,
  })  : grid = grid ?? const GanttGrid(),
        style = style ?? GanttStyle() {
    rowHeight = this.grid.barHeight +
        this.grid.rowSpacing +
        this.style.labelPadding.vertical;

    startDate = activities.allTasks
        .reduce((value, element) =>
            value.startDate.isBefore(element.startDate) ? value : element)
        .startDate;
    endDate = activities.allTasks
        .reduce((value, element) =>
            value.endDate.isAfter(element.endDate) ? value : element)
        .endDate;

    weekendOffset = startDate.weekday - DateTime.sunday + 1;

    highlightedColumns =
        highlightedDates?.map((e) => e.difference(startDate).inDays).toList() ??
            [];

    final diff = endDate.difference(startDate).inDays;
    columns = diff + (widthDivisor - (diff % widthDivisor));

    cellWidth = this.grid.columnWidth / widthDivisor;

    dataHeight = (activities.length + activities.allTasks.length) * rowHeight;
    labelColumnWidth = _titleWidth;
    timelineHeight = _legendHeight;
    maxDx = _horizontalScrollBoundary;
    maxDy = _verticalScrollBoundary;

    uiOffset = Offset(
      labelColumnWidth,
      timelineHeight,
    );
  }

  double get _horizontalScrollBoundary {
    var dataWidth = columns * cellWidth;
    var renderAreaWidth = containerSize.width - labelColumnWidth;
    return dataWidth < renderAreaWidth
        ? 0
        : dataWidth - containerSize.width + labelColumnWidth;
  }

  double get _verticalScrollBoundary =>
      dataHeight < (containerSize.height - timelineHeight)
          ? 0
          : dataHeight - containerSize.height + timelineHeight;

  double get _titleWidth {
    double width = 0;
    for (var activity in activities) {
      width = max(
        width,
        headerPainter(activity.label ?? '', style.activityLabelStyle).width +
            style.labelPadding.horizontal,
      );

      for (var task in activity.tasks) {
        width = max(
          width,
          headerPainter(task.label, style.taskLabelStyle).width +
              style.labelPadding.horizontal,
        );
      }
    }
    return max(width, titlePainter().width + style.titlePadding.horizontal);
  }

  double get _legendHeight => max(
        datePainter(
              [
                if (grid.showYear) '2022',
                if (grid.showMonth) '12',
                if (grid.showDay) '31',
              ],
            ).height +
            style.titlePadding.bottom,
        titlePainter().height + style.titlePadding.vertical,
      );

  void setTooltipOffset(Offset offset) => tooltipOffset = offset;

  TextPainter titlePainter() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: title,
        style: style.titleStyle,
        children: [
          TextSpan(
            text: '\n$subtitle',
            style: style.subtitleStyle,
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
        style: style.timelineStyle,
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: grid.columnWidth,
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

  GanttVisibleData get gridData => GanttVisibleData(
        containerSize,
        activities.length + activities.allTasks.length,
        uiOffset,
        columns,
        cellWidth,
        panOffset,
        rowHeight,
      );
}
