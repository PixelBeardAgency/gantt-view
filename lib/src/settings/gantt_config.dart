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
  final List<(GridRow, Size)> rows;
  final Iterable<int> highlightedColumns;

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
      min(containerSize.width, dataWidth),
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

  double get _verticalScrollBoundary => dataHeight < (renderAreaSize.height)
      ? 0
      : dataHeight - renderAreaSize.height;

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
