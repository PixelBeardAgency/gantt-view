import 'package:flutter/material.dart';
import 'package:gantt_view/settings/theme/event_row_theme.dart';
import 'package:gantt_view/settings/theme/header_row_theme.dart';
import 'package:gantt_view/settings/theme/legend_theme.dart';

class GanttSettings<T> extends InheritedWidget {
  final EventRowTheme _eventRowTheme;
  EventRowTheme get eventRowTheme => _eventRowTheme;

  final HeaderRowTheme _headerRowTheme;
  HeaderRowTheme get headerRowTheme => _headerRowTheme;

  final LegendTheme _legendTheme;
  LegendTheme get legendTheme => _legendTheme;

  final double _rowSpacing;
  double get rowSpacing => _rowSpacing;

  final String? _title;
  String? get title => _title;

  final String? _subtitle;
  String? get subtitle => _subtitle;

  final TimelineAxisType _timelineAxisType;
  TimelineAxisType get timelineAxisType => _timelineAxisType;

  final Color? _columnBoundaryColor;
  Color? get columnBoundaryColor => _columnBoundaryColor;

  GanttSettings({
    super.key,
    double? titleColumnWidth,
    EventRowTheme? eventRowTheme,
    HeaderRowTheme? headerRowTheme,
    LegendTheme? legendTheme,
    double? rowSpacing,
    String? title,
    String? subtitle,
    TimelineAxisType? timelineAxisType,
    bool? showColumnBoundary,
    Color? columnBoundaryColor,
    required super.child,
  })  : _eventRowTheme = eventRowTheme ?? EventRowTheme(),
        _headerRowTheme = headerRowTheme ?? HeaderRowTheme(),
        _legendTheme = legendTheme ?? LegendTheme(),
        _rowSpacing = rowSpacing ?? 0.0,
        _title = title,
        _subtitle = subtitle,
        _timelineAxisType = timelineAxisType ?? TimelineAxisType.daily,
        _columnBoundaryColor = columnBoundaryColor;

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
      _eventRowTheme != oldWidget._eventRowTheme ||
      _headerRowTheme != oldWidget._headerRowTheme ||
      _legendTheme != oldWidget._legendTheme ||
      _rowSpacing != oldWidget._rowSpacing ||
      _title != oldWidget._title ||
      _subtitle != oldWidget._subtitle;
}

enum TimelineAxisType { weekly, daily }
