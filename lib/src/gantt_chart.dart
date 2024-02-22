import 'package:flutter/material.dart';
import 'package:gantt_view/gantt_view.dart';
import 'package:gantt_view/src/content/gantt_content.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';
import 'package:gantt_view/src/util/measure_util.dart';

class GanttChart<T> extends StatelessWidget {
  final List<GridRow> rows;
  final List<DateTime> highlightedDates;
  final GanttGrid grid;
  final GanttStyle<T> style;

  const GanttChart({
    super.key,
    required this.rows,
    this.highlightedDates = const [],
    this.grid = const GanttGrid(),
    this.style = const GanttStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (rows.isNotEmpty == true)
          ? GanttContent(
              config: GanttConfig(
                grid: grid,
                style: style,
                containerSize: constraints.biggest,
                highlightedDates: highlightedDates,
                rows: rows
                    .map((e) => (
                          e,
                          e is ActivityGridRow
                              ? MeasureUtil.measureWidget(Material(
                                  child: style.activityLabelBuilder?.call(e)))
                              : e is TaskGridRow<T>
                                  ? MeasureUtil.measureWidget(Material(
                                      child: style.taskLabelBuilder(e)))
                                  : const Size(0, 0)
                        ))
                    .toList(),
              ),
            )
          : const Center(child: Text('No data')),
    );
  }
}
