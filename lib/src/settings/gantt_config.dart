import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/src/model/grid_row.dart';
import 'package:gantt_view/src/model/timeline_axis_type.dart';
import 'package:gantt_view/src/settings/gantt_grid.dart';
import 'package:gantt_view/src/settings/gantt_style.dart';
import 'package:gantt_view/src/util/measure_util.dart';

class GanttConfig<T> {
  final GanttGrid grid;
  final GanttStyle<T> style;

  final String? title;
  final String? subtitle;

  final List<(GridRow, Size)> rows;

  final List<DateTime> highlightedDates;

  late Size renderAreaSize;

  late double maxDx;
  late double maxDy;

  late double dataHeight;

  late double cellWidth;
  late double dataWidth;

  late int weekendOffset;

  int get widthDivisor => switch (grid.timelineAxisType) {
        TimelineAxisType.daily => 1,
        TimelineAxisType.weekly => 7,
      };

  late Offset uiOffset;

  double get labelColumnWidth => uiOffset.dx;
  double get timelineHeight => uiOffset.dy;

  Iterable<int> get highlightedColumns =>
      highlightedDates.map((d) => d.difference(startDate).inDays);

  DateTime get startDate => rows
      .map((e) => e.$1)
      .whereType<TaskGridRow>()
      .map((t) => t.startDate)
      .fold(
          rows.map((e) => e.$1).whereType<TaskGridRow>().first.startDate,
          (previousValue, newValue) =>
              previousValue.isBefore(newValue) ? previousValue : newValue);

  DateTime get endDate =>
      rows.map((e) => e.$1).whereType<TaskGridRow>().map((t) => t.endDate).fold(
          rows.map((e) => e.$1).whereType<TaskGridRow>().first.endDate,
          (previousValue, newValue) =>
              previousValue.isAfter(newValue) ? previousValue : newValue);

  int get columnCount => endDate.difference(startDate).inDays + 1;

  GanttConfig({
    GanttGrid? grid,
    GanttStyle<T>? style,
    this.title,
    this.subtitle,
    required Size containerSize,
    required this.rows,
    this.highlightedDates = const [],
  })  : grid = grid ?? const GanttGrid(),
        style = style ?? const GanttStyle() {
    cellWidth = this.grid.columnWidth / widthDivisor;

    dataHeight = rows.fold(
        0, (previousValue, element) => previousValue + element.$2.height);
    dataWidth = columnCount * cellWidth;

    uiOffset = Offset(
      _titleWidth(rows),
      _legendHeight(),
    );

    renderAreaSize = Size(
      min(containerSize.width - uiOffset.dx, dataWidth),
      min(containerSize.height, dataHeight),
    );

    maxDx = _horizontalScrollBoundary;
    maxDy = _verticalScrollBoundary;

    weekendOffset = startDate.weekday - DateTime.monday;
  }

  double get _horizontalScrollBoundary {
    var renderAreaWidth = renderAreaSize.width;
    return dataWidth < renderAreaWidth ? 0 : dataWidth - renderAreaSize.width;
  }

  double get _verticalScrollBoundary =>
      dataHeight < (renderAreaSize.height + uiOffset.dy)
          ? 0
          : dataHeight - renderAreaSize.height + uiOffset.dy;

  double _titleWidth(Iterable<(GridRow, Size)> rows) {
    double width = 0;

    if (style.chartTitleBuilder != null) {
      width = MeasureUtil.measureWidget(style.chartTitleBuilder!()).width;
    }

    width = max(
        width,
        rows
            .map((e) => e.$2.width)
            .reduce((value, element) => value > element ? value : element));

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
    return max(
        style.chartTitleBuilder != null
            ? MeasureUtil.measureWidget(
                    Material(child: style.chartTitleBuilder!()))
                .width
            : 0,
        dateHeight);
  }
}
