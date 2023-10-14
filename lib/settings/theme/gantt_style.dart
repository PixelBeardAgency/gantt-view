import 'package:flutter/material.dart';

class GanttStyle {
  final Color eventColor;
  final double eventRadius;

  final TextStyle eventLabelStyle;
  final Color eventLabelColor;

  final TextStyle eventHeaderStyle;
  final Color eventHeaderColor;

  final Color timelineColor;
  final TextStyle timelineStyle;

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  GanttStyle(
    BuildContext context, {
    Color? eventColor,
    this.eventRadius = 8.0,
    TextStyle? eventLabelStyle,
    Color? eventLabelColor,
    TextStyle? eventHeaderStyle,
    Color? eventHeaderColor,
    Color? timelineColor,
    TextStyle? timelineStyle,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
  })  : eventColor = eventColor ?? Theme.of(context).colorScheme.primary,
        eventLabelStyle = Theme.of(context)
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
            const TextStyle(color: Colors.black);
}
