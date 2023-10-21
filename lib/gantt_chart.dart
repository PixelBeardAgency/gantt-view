import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/controller/gantt_data_controller.dart';
import 'package:gantt_view/model/cell/grid/grid_cell.dart';
import 'package:gantt_view/model/cell/header/header_cell.dart';
import 'package:gantt_view/model/gantt_activity.dart';
import 'package:gantt_view/painter/gantt_data_painter.dart';
import 'package:gantt_view/painter/gantt_ui_painter.dart';
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
              ? _GanttChartContent(
                  config: config,
                  controller: controller,
                  gridCells: _buildGridCells(activities, config),
                  headerCells: _buildHeaderCells(activities),
                )
              : const Center(child: Text('No data'));
        },
      ),
    );
  }

  Map<int, Map<int, GridCell>> _buildGridCells(
    List<GanttActivity> activities,
    GanttConfig config,
  ) {
    debugPrint('asdasd');
    Map<int, Map<int, GridCell>> cells = {};
    int currentRow = 0;
    for (var activity in activities) {
      if (activity.label != null) {
        for (int i = 0; i < config.columns; i++) {
          final currentOffset = i % 7;
          (cells[currentRow] ??= {})[i] = config.highlightedColumns.contains(i)
              ? HolidayGridCell()
              : config.style.weekendColor != null &&
                      (currentOffset == 5 || currentOffset == 6)
                  ? WeekendGridCell()
                  : HeaderGridCell();
        }
        currentRow++;
      }
      for (var task in activity.tasks) {
        final start = task.startDate;
        final end = task.endDate;

        final int from = start.difference(config.startDate).inDays;
        final int to = end.difference(config.startDate).inDays;

        if (start.isAfter(end)) {
          throw Exception('Start date must be before end date.');
        }

        for (int i = 0; i < config.columns; i++) {
          final currentOffset = i % 7;
          if (config.highlightedColumns.contains(i)) {
            (cells[currentRow] ??= {})[i] = (i >= from && i <= to)
                ? TaskGridCell(task.tooltip, i == from, i == to,
                    isHoliday: true)
                : HolidayGridCell();
          } else if (config.style.weekendColor != null &&
              (currentOffset == 5 || currentOffset == 6)) {
            (cells[currentRow] ??= {})[i] = (i >= from && i <= to)
                ? TaskGridCell(task.tooltip, i == from, i == to,
                    isWeekend: true)
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
}

class _GanttChartContent<T> extends StatefulWidget {
  final GanttChartController<T> controller;
  final GanttConfig config;

  final Map<int, Map<int, GridCell>> gridCells;
  final List<HeaderCell> headerCells;

  const _GanttChartContent({
    required this.config,
    required this.controller,
    required this.gridCells,
    required this.headerCells,
  });

  @override
  State<_GanttChartContent<T>> createState() => _GanttChartContentState<T>();
}

class _GanttChartContentState<T> extends State<_GanttChartContent<T>> {
  double mouseX = 0;
  double mouseY = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.config.renderAreaSize.height,
      width: widget.config.renderAreaSize.width,
      child: ClipRect(
        child: MouseRegion(
          onExit: (event) {
            if (widget.config.grid.tooltipType == TooltipType.hover) {
              widget.controller.setTooltipOffset(Offset.zero);
            }
          },
          onHover: (event) {
            mouseX = event.localPosition.dx;
            mouseY = event.localPosition.dy;
            if (widget.config.grid.tooltipType == TooltipType.hover) {
              setState(() =>
                  widget.controller.setTooltipOffset(Offset(mouseX, mouseY)));
            }
          },
          child: Listener(
            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                _updateOffset(
                  -event.scrollDelta,
                  widget.config.maxDx,
                  widget.config.maxDy,
                );
              }
            },
            child: GestureDetector(
              onTap: () {
                if (widget.config.grid.tooltipType == TooltipType.tap) {
                  setState(() => widget.controller
                      .setTooltipOffset(Offset(mouseX, mouseY)));
                }
              },
              onPanUpdate: (details) => _updateOffset(
                  details.delta, widget.config.maxDx, widget.config.maxDy),
              child: ValueListenableBuilder(
                valueListenable: widget.controller.panOffset,
                builder: (context, panOffset, child) => ValueListenableBuilder(
                  valueListenable: widget.controller.tooltipOffset,
                  builder: (context, tooltipOffset, child) => CustomPaint(
                    size: Size.infinite,
                    willChange: true,
                    foregroundPainter: GanttUiPainter(
                      config: widget.config,
                      panOffset: panOffset,
                      headers: widget.headerCells,
                    ),
                    painter: GanttDataPainter(
                      cells: widget.gridCells,
                      config: widget.config,
                      panOffset: panOffset,
                      tooltipOffset: tooltipOffset,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateOffset(Offset delta, double maxDx, double maxDy) {
    var panOffset = widget.controller.panOffset.value;
    panOffset += delta;
    if (panOffset.dx > 0) {
      panOffset = Offset(0, panOffset.dy);
    }
    if (panOffset.dx < -maxDx) {
      panOffset = Offset(-maxDx, panOffset.dy);
    }
    if (panOffset.dy > 0) {
      panOffset = Offset(panOffset.dx, 0);
    }
    if (panOffset.dy < -maxDy) {
      panOffset = Offset(panOffset.dx, -maxDy);
    }

    widget.controller.setPanOffset(panOffset);
  }
}
