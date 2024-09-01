import 'package:flutter/material.dart';
import 'package:gantt_view/gantt_view.dart';

class GanttStyle<T> {
  final Color taskBarColor;
  final double taskBarRadius;

  final Color taskLabelColor;
  final Color activityLabelColor;

  final Widget Function()? chartTitleBuilder;
  final Widget Function(TaskGridRow task) taskLabelBuilder;
  final Widget Function(ActivityGridRow activity)? activityLabelBuilder;

  final Widget Function(int year) yearLabelBuilder;
  final Widget Function(Month month) monthLabelBuilder;
  final Widget Function(int day) dayLabelBuilder;

  final Color? gridColor;

  final Color? weekendColor;
  final Color holidayColor;

  final Color? axisDividerColor;

  final Color tooltipColor;
  final TextStyle tooltipStyle;
  final EdgeInsets tooltipPadding;
  final double tooltipRadius;

  final double barHeight;
  final double columnWidth;
  final double tooltipWidth;
  final double? labelColumnWidth;

  final bool showYear;
  final bool showMonth;
  final bool showDay;

  final TimelineAxisType timelineAxisType;
  final TooltipType tooltipType;

  const GanttStyle({
    Color? taskBarColor,
    this.taskBarRadius = 8.0,
    Color? taskLabelColor,
    Color? activityLabelColor,
    this.gridColor,
    this.weekendColor,
    Color? highlightedDateColor,
    Color? dateLineColor,
    this.axisDividerColor,
    Color? tooltipColor,
    TextStyle? tooltipStyle,
    this.tooltipPadding = const EdgeInsets.all(4),
    this.tooltipRadius = 4.0,
    this.activityLabelBuilder,
    this.taskLabelBuilder = _defaultTaskLabelBuilder,
    this.yearLabelBuilder = _defaultYearLabelBuilder,
    this.monthLabelBuilder = _defaultMonthLabelBuilder,
    this.dayLabelBuilder = _defaultDayLabelBuilder,
    this.chartTitleBuilder,
    this.barHeight = 12.0,
    this.columnWidth = 30.0,
    this.tooltipWidth = 200,
    this.labelColumnWidth,
    this.showYear = true,
    this.showMonth = true,
    this.showDay = true,
    this.timelineAxisType = TimelineAxisType.daily,
    this.tooltipType = TooltipType.none,
  })  : taskBarColor = taskBarColor ?? const Color.fromRGBO(144, 202, 249, 1),
        taskLabelColor = taskLabelColor ?? const Color.fromRGBO(13, 71, 161, 1),
        activityLabelColor =
            activityLabelColor ?? const Color.fromRGBO(66, 165, 245, 1),
        holidayColor =
            highlightedDateColor ?? const Color.fromRGBO(224, 224, 224, 1),
        tooltipColor = tooltipColor ?? const Color.fromRGBO(158, 158, 158, 1),
        tooltipStyle =
            tooltipStyle ?? const TextStyle(color: Colors.white, fontSize: 16);

  static Widget _defaultTaskLabelBuilder(TaskGridRow task) => Container();

  static Widget _defaultYearLabelBuilder(int year) => Text(
        '$year',
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
  static Widget _defaultMonthLabelBuilder(Month month) => Text('${month.id}');
  static Widget _defaultDayLabelBuilder(int day) => Text('$day');
}
