import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/src/model/grid_row.dart';
import 'package:gantt_view/src/model/month.dart';
import 'package:gantt_view/src/model/timeline_axis_type.dart';
import 'package:gantt_view/src/settings/gantt_style.dart';
import 'package:gantt_view/src/util/datetime_extension.dart';
import 'package:gantt_view/src/util/measure_util.dart';

class GanttConfig<T> {
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

  int get widthDivisor => switch (style.timelineAxisType) {
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

  late List<DateTime> monthsBetween;
  late List<DateTime> yearsBetween;
  late int columnCount;

  GanttConfig({
    GanttStyle<T>? style,
    this.title,
    this.subtitle,
    required Size containerSize,
    required this.rows,
    this.highlightedDates = const [],
  }) : style = style ?? const GanttStyle() {
    columnCount = startDate.numberOfDaysBetween(endDate);
    monthsBetween = startDate.monthsBetween(endDate);
    yearsBetween = startDate.yearsBetween(endDate);

    cellWidth = this.style.columnWidth / widthDivisor;

    dataHeight = rows.fold(0.0,
            (previousValue, element) => previousValue + element.$2.height) +
        (style?.axisDividerColor != null ? rows.length : 0);
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
    if (style.labelColumnWidth != null) {
      return style.labelColumnWidth!;
    }

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
          child: Column(
            children: [
              if (style.showYear) style.yearLabelBuilder(2222),
              if (style.showMonth) style.monthLabelBuilder(Month.jan),
              if (style.showDay) style.dayLabelBuilder(31),
            ],
          ),
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
