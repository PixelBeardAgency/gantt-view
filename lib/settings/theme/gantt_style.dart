import 'package:flutter/material.dart';

class GanttStyle {
  final Color eventColor;
  final double eventRadius;

  final TextStyle eventLabelStyle;
  final Color eventLabelColor;
  final EdgeInsets eventLabelPadding;

  final TextStyle eventHeaderStyle;
  final Color eventHeaderColor;

  final Color timelineColor;
  final TextStyle timelineStyle;

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final EdgeInsets titlePadding;

  final Color? gridColor;

  final Color weekendColor;
  final Color holidayColor;

  GanttStyle(
    BuildContext context, {
    Color? eventColor,
    this.eventRadius = 0.0,
    TextStyle? eventLabelStyle,
    Color? eventLabelColor,
    this.eventLabelPadding = const EdgeInsets.all(0),
    TextStyle? eventHeaderStyle,
    Color? eventHeaderColor,
    Color? timelineColor,
    TextStyle? timelineStyle,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    this.titlePadding = const EdgeInsets.all(4),
    this.gridColor,
    Color? weekendColor,
    Color? highlightedDateColor,
  })  : eventColor = eventColor ?? Theme.of(context).colorScheme.primary,
        eventLabelStyle = eventLabelStyle ??
            Theme.of(context)
                .textTheme
                .labelMedium
                ?.apply(color: Theme.of(context).colorScheme.onSecondary) ??
            const TextStyle(color: Colors.black),
        eventLabelColor =
            eventLabelColor ?? Theme.of(context).colorScheme.secondary,
        eventHeaderStyle = eventHeaderStyle ??
            Theme.of(context)
                .textTheme
                .labelMedium
                ?.apply(color: Theme.of(context).colorScheme.onTertiary) ??
            const TextStyle(color: Colors.black),
        eventHeaderColor =
            eventHeaderColor ?? Theme.of(context).colorScheme.tertiary,
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
        weekendColor = weekendColor ??
            eventHeaderColor ??
            Theme.of(context).colorScheme.tertiary,
        holidayColor = highlightedDateColor ??
            highlightedDateColor ??
            eventHeaderColor ??
            Theme.of(context).colorScheme.tertiary;
}
