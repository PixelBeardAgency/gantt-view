import 'package:flutter/material.dart';
import 'package:gantt_view/src/controller/gantt_data_controller.dart';
import 'package:gantt_view/src/gantt_chart_content.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';
import 'package:gantt_view/src/settings/gantt_grid.dart';
import 'package:gantt_view/src/settings/gantt_style.dart';

class GanttChart<T> extends StatelessWidget {
  final GanttChartController<T> controller;
  final GanttGrid? grid;
  final GanttStyle? style;
  final String? title;
  final String? subtitle;

  const GanttChart({
    super.key,
    required this.controller,
    this.grid,
    this.style,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ValueListenableBuilder(
        valueListenable: controller.data,
        builder: (context, data, child) => ValueListenableBuilder(
          valueListenable: controller.isBuilding,
          builder: (context, isBuilding, child) {
            if (data?.activities.isNotEmpty == true) {
              return GanttChartContent(
                config: GanttConfig(
                  grid: grid,
                  style: style,
                  title: title,
                  subtitle: subtitle,
                  containerSize: constraints.biggest,
                  startDate: data!.startDate,
                  columnCount: data.columnCount,
                  rows: data.rows,
                  highlightedColumns: data.highlightedColumns,
                ),
                controller: controller,
                rows: data.rows,
                isBuilding: isBuilding,
              );
            }

            return isBuilding
                ? const Center(child: CircularProgressIndicator())
                : const Center(child: Text('No data'));
          },
        ),
      ),
    );
  }
}
