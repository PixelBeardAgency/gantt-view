import 'package:flutter/material.dart';
import 'package:gantt_view/controller/gantt_data_controller.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/settings/gantt_settings.dart';
import 'package:gantt_view/settings/theme/gantt_style.dart';
import 'package:gantt_view/settings/theme/grid_scheme.dart';
import 'package:gantt_view/ui/gantt_chart.dart';

class GanttView<T> extends StatelessWidget {
  final GanttDataController<T> controller;
  final GridScheme? gridScheme;
  final GanttStyle? style;
  final String? title;
  final String? subtitle;

  GanttView({
    super.key,
    required this.controller,
    this.gridScheme,
    this.style,
    this.title,
    this.subtitle,
  }) : assert(
            controller.data.whereType<GanttEvent>().every(
                (event) => event.endDate.compareTo(event.startDate) >= 0),
            'All events must have a start date before or equal to the end date.');

  @override
  Widget build(BuildContext context) {
    return GanttSettings(
      context,
      gridScheme: gridScheme,
      style: style,
      title: title,
      subtitle: subtitle,
      child: GanttChart(data: controller.data),
    );
  }
}
