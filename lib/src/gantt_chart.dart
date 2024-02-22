import 'package:flutter/material.dart';
import 'package:gantt_view/gantt_view.dart';
import 'package:gantt_view/src/controller/gantt_data_controller.dart';
import 'package:gantt_view/src/gantt_chart_content.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';
import 'package:gantt_view/src/util/measure_util.dart';

class GanttChart<T> extends StatefulWidget {
  final List<GridRow> rows;
  final List<DateTime> highlightedDates;
  final GanttGrid grid;
  final GanttStyle style;

  const GanttChart({
    super.key,
    required this.rows,
    this.highlightedDates = const [],
    this.grid = const GanttGrid(),
    this.style = const GanttStyle(),
  });

  @override
  State<GanttChart<T>> createState() => _GanttChartState<T>();
}

class _GanttChartState<T> extends State<GanttChart<T>> {
  final GanttChartController<T> controller = GanttChartController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ListenableBuilder(
        listenable: controller,
        builder: (context, child) => (widget.rows.isNotEmpty == true)
            ? GanttChartContent(
                config: GanttConfig(
                  grid: widget.grid,
                  style: widget.style,
                  containerSize: constraints.biggest,
                  highlightedDates: widget.highlightedDates,
                  rows: widget.rows
                      .map((e) => (
                            e,
                            e is ActivityGridRow
                                ? MeasureUtil.measureWidget(Material(
                                    child: widget.style.activityLabelBuilder
                                        ?.call(e)))
                                : e is TaskGridRow<T>
                                    ? MeasureUtil.measureWidget(Material(
                                        child:
                                            widget.style.taskLabelBuilder(e)))
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
