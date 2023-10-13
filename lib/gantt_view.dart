import 'package:flutter/material.dart';
import 'package:gantt_view/controller/gantt_data_controller.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/settings/gantt_settings.dart';
import 'package:gantt_view/settings/theme/event_row_theme.dart';
import 'package:gantt_view/settings/theme/header_row_theme.dart';
import 'package:gantt_view/settings/theme/legend_theme.dart';
import 'package:gantt_view/ui/gantt_chart.dart';

class GanttView<T> extends StatelessWidget {
  final GanttDataController<T> controller;
  final double? titleColumnWidth;
  final EventRowTheme? eventRowTheme;
  final HeaderRowTheme? headerRowTheme;
  final LegendTheme? legendTheme;
  final double? rowSpacing;
  final String? title;
  final String? subtitle;
  final TimelineAxisType? timelineAxisType;
  final Color? columnBoundaryColor;

  GanttView({
    super.key,
    required this.controller,
    this.titleColumnWidth,
    this.eventRowTheme,
    this.headerRowTheme,
    this.legendTheme,
    this.rowSpacing,
    this.title,
    this.subtitle,
    this.timelineAxisType,
    this.columnBoundaryColor,
  }) : assert(
            controller.data.whereType<GanttEvent>().every(
                (event) => event.endDate.compareTo(event.startDate) >= 0),
            'All events must have a start date before or equal to the end date.');

  @override
  Widget build(BuildContext context) {
    return GanttSettings(
      titleColumnWidth: titleColumnWidth,
      eventRowTheme: eventRowTheme,
      headerRowTheme: headerRowTheme,
      legendTheme: legendTheme,
      rowSpacing: rowSpacing,
      title: title,
      subtitle: subtitle,
      timelineAxisType: timelineAxisType,
      columnBoundaryColor: columnBoundaryColor,
      child: GanttChart(data: controller.data),
    );
  }
}
