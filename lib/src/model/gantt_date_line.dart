import 'package:flutter/material.dart';

typedef GanttDateLineTooltipBuilder = String Function(DateTime date);

final class GanttDateLine {
  final DateTime date;
  final Color color;
  final double width;
  final GanttDateLineTooltipBuilder? tooltipBuilder;

  TimeOfDay get time => TimeOfDay(hour: date.hour, minute: date.minute);

  GanttDateLine({
    required this.date,
    this.width = 1.0,
    Color? color,
    this.tooltipBuilder,
  }) : color = color ?? const Color.fromRGBO(238, 76, 83, 1);
}
