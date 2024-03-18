import 'package:flutter/material.dart';
import 'package:gantt_view/gantt_view.dart';
import 'package:gantt_view/src/content/gantt_content.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';
import 'package:gantt_view/src/util/measure_util.dart';

class GanttChart<T> extends StatelessWidget {
  final List<GridRow> rows;
  final List<DateTime> highlightedDates;
  final GanttStyle<T> style;

  GanttChart({
    super.key,
    required this.rows,
    this.highlightedDates = const [],
    this.style = const GanttStyle(),
  }) : assert(rows.isNotEmpty == true, 'rows cannot be empty');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GanttContent(
        config: GanttConfig(
          style: style,
          containerSize: constraints.biggest,
          highlightedDates: highlightedDates,
          rows: rows
              .map(
                (e) => (
                  e,
                  e is ActivityGridRow
                      ? MeasureUtil.measureWidget(
                          Material(child: style.activityLabelBuilder?.call(e)))
                      : e is TaskGridRow<T>
                          ? MeasureUtil.measureWidget(
                              Material(child: style.taskLabelBuilder(e)))
                          : const Size(0, 0)
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
