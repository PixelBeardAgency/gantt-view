import 'package:flutter/material.dart';
import 'package:gantt_view/src/model/grid_row.dart';

class GanttStyle<T> {
  final Color taskBarColor;
  final double taskBarRadius;

  final TextStyle taskLabelStyle;
  final Color taskLabelColor;

  final TextStyle activityLabelStyle;
  final Color activityLabelColor;

  final Widget Function()? chartTitleBuilder;
  final Widget Function(TaskGridRow task) taskLabelBuilder;
  final Widget Function(ActivityGridRow activity)? activityLabelBuilder;
  final Widget Function(DateTime dateTime) dateLabelBuilder;

  final Color timelineColor;
  final TextStyle timelineStyle;

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final EdgeInsets titlePadding;

  final Color? gridColor;

  final Color? weekendColor;
  final Color holidayColor;

  final Color? axisDividerColor;

  final Color tooltipColor;
  final TextStyle tooltipStyle;
  final EdgeInsets tooltipPadding;
  final double tooltipRadius;

  const GanttStyle({
    Color? taskBarColor,
    this.taskBarRadius = 8.0,
    TextStyle? taskLabelStyle,
    Color? taskLabelColor,
    TextStyle? activityLabelStyle,
    Color? activityLabelColor,
    Color? timelineColor,
    TextStyle? timelineStyle,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    this.titlePadding = const EdgeInsets.all(4),
    this.gridColor,
    this.weekendColor,
    Color? highlightedDateColor,
    this.axisDividerColor,
    Color? tooltipColor,
    TextStyle? tooltipStyle,
    this.tooltipPadding = const EdgeInsets.all(4),
    this.tooltipRadius = 4.0,
    this.activityLabelBuilder,
    this.taskLabelBuilder = _defaultTaskLabelBuilder,
    this.dateLabelBuilder = _defaultDateLabelBuilder,
    this.chartTitleBuilder,
  })  : taskBarColor = taskBarColor ?? const Color.fromRGBO(144, 202, 249, 1),
        taskLabelStyle = taskLabelStyle ??
            const TextStyle(color: Colors.white, fontSize: 12),
        taskLabelColor = taskLabelColor ?? const Color.fromRGBO(13, 71, 161, 1),
        activityLabelStyle = activityLabelStyle ??
            const TextStyle(color: Colors.white, fontSize: 12),
        activityLabelColor =
            activityLabelColor ?? const Color.fromRGBO(66, 165, 245, 1),
        timelineColor = timelineColor ?? const Color.fromRGBO(224, 224, 224, 1),
        timelineStyle =
            timelineStyle ?? const TextStyle(color: Colors.black, fontSize: 10),
        titleStyle =
            titleStyle ?? const TextStyle(color: Colors.black, fontSize: 16),
        subtitleStyle =
            subtitleStyle ?? const TextStyle(color: Colors.black, fontSize: 14),
        holidayColor =
            highlightedDateColor ?? const Color.fromRGBO(224, 224, 224, 1),
        tooltipColor = tooltipColor ?? const Color.fromRGBO(158, 158, 158, 1),
        tooltipStyle =
            tooltipStyle ?? const TextStyle(color: Colors.white, fontSize: 16);

  static Widget _defaultTaskLabelBuilder(TaskGridRow task) => Container();

  static Widget _defaultDateLabelBuilder(DateTime dateTime) => Column(
        children: [
          Text(
            '${dateTime.year}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('${dateTime.month}'),
          Text('${dateTime.day}'),
        ],
      );
}
