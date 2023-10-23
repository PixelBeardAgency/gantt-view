import 'package:flutter/material.dart';
import 'package:gantt_view/controller/gantt_data_controller.dart';
import 'package:gantt_view/gantt_chart_content.dart';
import 'package:gantt_view/settings/gantt_config.dart';
import 'package:gantt_view/settings/gantt_grid.dart';
import 'package:gantt_view/settings/gantt_style.dart';

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
                  headers: data!.headerCells,
                  grid: grid,
                  style: style,
                  title: title,
                  subtitle: subtitle,
                  containerSize: constraints.biggest,
                  startDate: data.startDate,
                  columns: data.columns,
                  rows: data.rows,
                ),
                controller: controller,
                gridCells: data.gridCells,
                headerCells: data.headerCells,
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
