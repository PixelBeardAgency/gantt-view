import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/src/model/grid_row.dart';
import 'package:gantt_view/src/model/timeline_axis_type.dart';
import 'package:gantt_view/src/settings/gantt_grid.dart';
import 'package:gantt_view/src/settings/gantt_style.dart';
import 'package:gantt_view/src/util/measure_util.dart';

class GanttConfig {
  final GanttGrid grid;
  final GanttStyle style;

  final String? title;
  final String? subtitle;

  final DateTime startDate;
  final int columnCount;
  final List<GridRow> rows;
  final Iterable<int> highlightedColumns;

  late double cellWidth;

  late int weekendOffset;

  int get widthDivisor => switch (grid.timelineAxisType) {
        TimelineAxisType.daily => 1,
        TimelineAxisType.weekly => 7,
      };

  late Offset uiOffset;

  double get labelColumnWidth => uiOffset.dx;
  double get timelineHeight => uiOffset.dy;

  GanttConfig({
    GanttGrid? grid,
    GanttStyle? style,
    this.title,
    this.subtitle,
    required Size containerSize,
    required this.startDate,
    required this.columnCount,
    required this.rows,
    required this.highlightedColumns,
  })  : grid = grid ?? const GanttGrid(),
        style = style ?? GanttStyle() {
    cellWidth = this.grid.columnWidth / widthDivisor;

    uiOffset = Offset(
      _titleWidth(rows),
      _legendHeight(),
    );

    weekendOffset = startDate.weekday - DateTime.monday;
  }

  double _titleWidth(Iterable<GridRow> labels) {
    double width = 0;
    var labelIterator = labels.iterator;

    if (style.chartTitleBuilder != null) {
      width = MeasureUtil.measureWidget(style.chartTitleBuilder!()).width;
    }

    //iterate over the list
    while (labelIterator.moveNext()) {
      final label = labelIterator.current;
      if (label is ActivityGridRow) {
        width = max(
          width,
          MeasureUtil.measureWidget(
                  Material(child: style.activityLabelBuilder(label)))
              .width,
        );
      } else if (label is TaskGridRow) {
        width = max(
          width,
          MeasureUtil.measureWidget(
                  Material(child: style.taskLabelBuilder(label)))
              .width,
        );
      }
    }
    return width;
  }

  double _legendHeight() {
    var dateHeight = MeasureUtil.measureWidget(
      Material(
        child: SizedBox(
          width: cellWidth,
          child: style.dateLabelBuilder(DateTime(2222, 12, 22)),
        ),
      ),
    ).height;
    debugPrint('dateHeight: $dateHeight');
    return max(
        style.chartTitleBuilder != null
            ? MeasureUtil.measureWidget(
                    Material(child: style.chartTitleBuilder!()))
                .width
            : 0,
        dateHeight);
  }
}
