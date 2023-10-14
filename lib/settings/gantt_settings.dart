import 'package:flutter/material.dart';
import 'package:gantt_view/settings/theme/gantt_style.dart';
import 'package:gantt_view/settings/theme/grid_scheme.dart';

class GanttSettings<T> extends InheritedWidget {
  final GridScheme gridScheme;
  final GanttStyle style;

  final String? title;
  final String? subtitle;

  GanttSettings(
    BuildContext context, {
    super.key,
    GridScheme? gridScheme,
    GanttStyle? style,
    this.title,
    this.subtitle,
    required super.child,
  })  : gridScheme = gridScheme ?? const GridScheme(),
        style = style ?? GanttStyle(context);

  static GanttSettings? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GanttSettings>();
  }

  static GanttSettings of(BuildContext context) {
    final settings =
        context.dependOnInheritedWidgetOfExactType<GanttSettings>();
    assert(settings != null, 'No GanttSettings found in context');
    return settings!;
  }

  @override
  bool updateShouldNotify(GanttSettings oldWidget) =>
      oldWidget.gridScheme != gridScheme ||
      oldWidget.style != style ||
      oldWidget.title != title ||
      oldWidget.subtitle != subtitle;
}

enum TimelineAxisType { weekly, daily }
