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

  GanttStyle(
    BuildContext context, {
    Color? taskBarColor,
    this.taskBarRadius = 0.0,
    TextStyle? taskLabelStyle,
    Color? taskLabelColor,
    this.labelPadding = const EdgeInsets.all(0),
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
  })  : taskBarColor = taskBarColor ?? Theme.of(context).colorScheme.primary,
        taskLabelStyle = taskLabelStyle ??
            Theme.of(context)
                .textTheme
                .labelMedium
                ?.apply(color: Theme.of(context).colorScheme.onSecondary) ??
            const TextStyle(color: Colors.black),
        taskLabelColor =
            taskLabelColor ?? Theme.of(context).colorScheme.secondary,
        activityLabelStyle = activityLabelStyle ??
            Theme.of(context)
                .textTheme
                .labelMedium
                ?.apply(color: Theme.of(context).colorScheme.onTertiary) ??
            const TextStyle(color: Colors.black),
        activityLabelColor =
            activityLabelColor ?? Theme.of(context).colorScheme.tertiary,
        timelineColor = timelineColor ?? Theme.of(context).colorScheme.surface,
        timelineStyle = timelineStyle ??
            Theme.of(context)
                .textTheme
                .labelSmall
                ?.apply(color: Theme.of(context).colorScheme.onSurface) ??
            const TextStyle(color: Colors.black),
        titleStyle = titleStyle ??
            Theme.of(context)
                .textTheme
                .labelLarge
                ?.apply(color: Theme.of(context).colorScheme.onSurface) ??
            const TextStyle(color: Colors.black),
        subtitleStyle = subtitleStyle ??
            Theme.of(context)
                .textTheme
                .labelMedium
                ?.apply(color: Theme.of(context).colorScheme.onSurface) ??
            const TextStyle(color: Colors.black),
        holidayColor =
            highlightedDateColor ?? Theme.of(context).colorScheme.tertiary;
}
