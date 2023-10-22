import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/controller/gantt_data_controller.dart';
import 'package:gantt_view/gantt_chart_content.dart';
import 'package:gantt_view/model/cell/grid/grid_cell.dart';
import 'package:gantt_view/model/cell/header/header_cell.dart';
import 'package:gantt_view/model/gantt_activity.dart';
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
        valueListenable: controller.activities,
        builder: (context, activities, child) {
          final config = GanttConfig(
            activities: activities,
            grid: grid,
            style: style,
            title: title,
            subtitle: subtitle,
            containerSize: constraints.biggest,
          );

          return activities.isNotEmpty
              ? FutureBuilder(
                  future: _buildCells(activities, config),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GanttChartContent(
                        config: config,
                        controller: controller,
                        gridCells: snapshot.data!.first
                            as Map<int, Map<int, GridCell>>,
                        headerCells: snapshot.data!.last as List<HeaderCell>,
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  })
              : const Center(child: Text('No data'));
        },
      ),
    );
  }
}

Future<List<dynamic>> _buildCells(
  List<GanttActivity> activities,
  GanttConfig config,
) =>
    Future.wait([
      compute(_buildGridCells,
          _GridCellBuilderData(activities: activities, config: config)),
      compute(_buildHeaderCells, activities)
    ]);

Map<int, Map<int, GridCell>> _buildGridCells(_GridCellBuilderData data) {
  Map<int, Map<int, GridCell>> cells = {};
  int currentRow = 0;
  for (var activity in data.activities) {
    if (activity.label != null) {
      for (int i = 0; i < data.config.columns; i++) {
        final currentOffset = i % 7;
        (cells[currentRow] ??= {})[i] =
            data.config.highlightedColumns.contains(i)
                ? HolidayGridCell()
                : data.config.style.weekendColor != null &&
                        (currentOffset == 5 || currentOffset == 6)
                    ? WeekendGridCell()
                    : HeaderGridCell();
      }
      currentRow++;
    }
    for (var task in activity.tasks) {
      final start = task.startDate;
      final end = task.endDate;

      final int from = start.difference(data.config.startDate).inDays;
      final int to = end.difference(data.config.startDate).inDays;

      if (start.isAfter(end)) {
        throw Exception('Start date must be before end date.');
      }

      for (int i = 0; i < data.config.columns; i++) {
        final currentOffset = i % 7;
        if (data.config.highlightedColumns.contains(i)) {
          (cells[currentRow] ??= {})[i] = (i >= from && i <= to)
              ? TaskGridCell(task.tooltip, i == from, i == to, isHoliday: true)
              : HolidayGridCell();
        } else if (data.config.style.weekendColor != null &&
            (currentOffset == 5 || currentOffset == 6)) {
          (cells[currentRow] ??= {})[i] = (i >= from && i <= to)
              ? TaskGridCell(task.tooltip, i == from, i == to, isWeekend: true)
              : WeekendGridCell();
        } else if (i >= from && i <= to) {
          (cells[currentRow] ??= {})[i] =
              TaskGridCell(task.tooltip, i == from, i == to);
        }
      }

      currentRow++;
    }
  }
  return cells;
}

List<HeaderCell> _buildHeaderCells(List<GanttActivity> activities) {
  List<HeaderCell> headers = [];

  for (var activity in activities) {
    if (activity.label != null) {
      headers.add(ActivityHeaderCell(activity.label));
    }
    headers.addAll(activity.tasks.map((e) => TaskHeaderCell(e.label)));
  }
  return headers;
}

class _GridCellBuilderData {
  final List<GanttActivity> activities;
  final GanttConfig config;

  const _GridCellBuilderData({
    required this.activities,
    required this.config,
  });
}
