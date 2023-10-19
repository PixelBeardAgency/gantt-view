import 'package:flutter/material.dart';

class GanttStyle {
  final Color taskBarColor;
  final double taskBarRadius;

  final TextStyle taskLabelStyle;
  final Color taskLabelColor;
  final EdgeInsets labelPadding;

  final TextStyle activityLabelStyle;
  final Color activityLabelColor;

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

  GanttStyle({
    Color? taskBarColor,
    this.taskBarRadius = 8.0,
    TextStyle? taskLabelStyle,
    Color? taskLabelColor,
    this.labelPadding = const EdgeInsets.all(4),
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
    this.tooltipRadius = 4,
  })  : taskBarColor = taskBarColor ?? Colors.blue.shade200,
        taskLabelStyle = taskLabelStyle ??
            const TextStyle(color: Colors.white, fontSize: 12),
        taskLabelColor = taskLabelColor ?? Colors.blue.shade900,
        activityLabelStyle = activityLabelStyle ??
            const TextStyle(color: Colors.white, fontSize: 12),
        activityLabelColor = activityLabelColor ?? Colors.blue.shade400,
        timelineColor = timelineColor ?? Colors.grey.shade300,
        timelineStyle =
            timelineStyle ?? const TextStyle(color: Colors.black, fontSize: 10),
        titleStyle =
            titleStyle ?? const TextStyle(color: Colors.black, fontSize: 16),
        subtitleStyle =
            subtitleStyle ?? const TextStyle(color: Colors.black, fontSize: 14),
        holidayColor = highlightedDateColor ?? Colors.grey.shade300,
        tooltipColor = tooltipColor ?? Colors.grey.shade500,
        tooltipStyle =
            tooltipStyle ?? const TextStyle(color: Colors.white, fontSize: 16);
}
