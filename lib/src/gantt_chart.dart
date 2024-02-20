import 'package:flutter/material.dart';
import 'package:gantt_view/gantt_view.dart';
import 'package:gantt_view/src/gantt_chart_content.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';

class GanttChart<T> extends StatelessWidget {
  final GanttChartController<T> controller;
  final GanttGrid? grid;
  final GanttStyle? style;

  const GanttChart({
    super.key,
    required this.controller,
    this.grid,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ListenableBuilder(
        listenable: controller,
        builder: (context, child) => (controller.activities.isNotEmpty == true)
            ? GanttChartContent(
                config: GanttConfig(
                  grid: grid,
                  style: style,
                  containerSize: constraints.biggest,
                  startDate: controller.startDate,
                  columnCount: controller.columnCount,
                  highlightedColumns: controller.highlightedDates,
                  rows: controller.rows,
                ),
                controller: controller,
              )
            : const Center(child: Text('No data')),
      ),
    );
  }
}
