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

  final Offset panOffset;
  final Offset tooltipOffset;

  late Size renderAreaSize;

  late double labelColumnWidth;
  late double timelineHeight;
  late double maxDx;
  late double maxDy;

  late double rowHeight;
  late double dataHeight;

  late DateTime startDate;
  late DateTime endDate;

  late List<int> highlightedColumns;

  late int columns;
  late double cellWidth;

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
    required Size containerSize,
    required this.panOffset,
    required this.tooltipOffset,
    List<DateTime>? highlightedDates,
  })  : grid = grid ?? const GanttGrid(),
        style = style ?? GanttStyle() {
    rowHeight = this.grid.barHeight +
        this.grid.rowSpacing +
        this.style.labelPadding.vertical;

    var firstTaskStartDate = activities.allTasks
        .reduce((value, element) =>
            value.startDate.isBefore(element.startDate) ? value : element)
        .startDate;

    startDate = DateTime(
      firstTaskStartDate.year,
      firstTaskStartDate.month,
      firstTaskStartDate.day +
          (this.grid.showFullWeeks
              ? DateTime.monday - firstTaskStartDate.weekday
              : 0),
    );

    var lastTaskEndDate = activities.allTasks
        .reduce((value, element) =>
            value.endDate.isAfter(element.endDate) ? value : element)
        .endDate;

    endDate = DateTime(
      lastTaskEndDate.year,
      lastTaskEndDate.month,
      lastTaskEndDate.day,
    );

    highlightedColumns =
        highlightedDates?.map((e) => e.difference(startDate).inDays).toList() ??
            [];

    final diff = endDate.difference(startDate).inDays;
    columns =
        diff + 1 + (this.grid.showFullWeeks ? 7 - lastTaskEndDate.weekday : 0);
    cellWidth = this.grid.columnWidth / widthDivisor;

    dataHeight = (activities.length + activities.allTasks.length) * rowHeight;
    labelColumnWidth = _titleWidth;
    timelineHeight = _legendHeight;

    renderAreaSize = Size(
      min(containerSize.width, (columns * cellWidth) + labelColumnWidth),
      min(
          containerSize.height,
          (activities.length + activities.allTasks.length) * rowHeight +
              timelineHeight),
    );

    maxDx = _horizontalScrollBoundary;
    maxDy = _verticalScrollBoundary;

    uiOffset = Offset(
      labelColumnWidth,
      timelineHeight,
    );
  }

  double get _horizontalScrollBoundary {
    var dataWidth = columns * cellWidth;
    var renderAreaWidth = renderAreaSize.width - labelColumnWidth;
    return dataWidth < renderAreaWidth
        ? 0
        : dataWidth - renderAreaSize.width + labelColumnWidth;
  }

  double get _verticalScrollBoundary =>
      dataHeight < (renderAreaSize.height - timelineHeight)
          ? 0
          : dataHeight - renderAreaSize.height + timelineHeight;

  double get _titleWidth {
    double width = 0;
    for (var activity in activities) {
      width = max(
        width,
        textPainter(activity.label ?? '', style.activityLabelStyle, maxLines: 1)
                .width +
            style.labelPadding.horizontal,
      );

      for (var task in activity.tasks) {
        width = max(
          width,
          textPainter(task.label, style.taskLabelStyle, maxLines: 1).width +
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

  TextPainter titlePainter() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: title,
        style: style.titleStyle,
        children: [
          if (subtitle != null)
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

  TextPainter textPainter(
    String label,
    TextStyle style, {
    double maxWidth = double.infinity,
    int? maxLines,
  }) {
    final textPainter = TextPainter(
      maxLines: maxLines,
      text: TextSpan(
        text: label,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: maxWidth,
    );
    return textPainter;
  }

  GanttVisibleData get gridData => GanttVisibleData(
        renderAreaSize,
        activities.length + activities.allTasks.length,
        uiOffset,
        columns,
        cellWidth,
        panOffset,
        rowHeight,
      );
}
