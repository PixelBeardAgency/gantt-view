import 'package:flutter/material.dart';
import 'package:gantt_view/gantt_view.dart';
import 'package:gantt_view/src/gantt_chart_content.dart';
import 'package:gantt_view/src/model/grid_row.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';
import 'package:gantt_view/src/util/measure_util.dart';

class GanttChart<T> extends StatelessWidget {
  final GanttChartController<T> controller;
  final GanttGrid grid;
  final GanttStyle style;

  const GanttChart({
    super.key,
    required this.controller,
    this.grid = const GanttGrid(),
    this.style = const GanttStyle(),
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
                  rows: controller.rows
                      .map((e) => (
                            e,
                            e is ActivityGridRow
                                ? MeasureUtil.measureWidget(Material(
                                    child: style.activityLabelBuilder(e)))
                                : e is TaskGridRow
                                    ? MeasureUtil.measureWidget(Material(
                                        child: style.taskLabelBuilder(e)))
                                    : const Size(0, 0)
                          ))
                      .toList(),
                ),
                controller: controller,
              )
            : const Center(child: Text('No data')),
      ),
    );
  }
}
