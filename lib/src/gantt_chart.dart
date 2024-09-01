import 'package:flutter/material.dart';
import 'package:gantt_view/gantt_view.dart';
import 'package:gantt_view/src/content/gantt_content.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';
import 'package:gantt_view/src/util/measure_util.dart';

class GanttChart<T> extends StatelessWidget {
  final List<GridRow> rows;
  final List<DateTime> highlightedDates;
  final List<GanttDateLine> dateLines;
  final bool showCurrentDate;
  final GanttStyle<T> style;

  GanttChart({
    super.key,
    required this.rows,
    this.highlightedDates = const [],
    this.dateLines = const [],
    this.style = const GanttStyle(),
    this.showCurrentDate = false,
  }) : assert(rows.isNotEmpty == true, 'rows cannot be empty');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GanttContent(
        config: GanttConfig<T>(
          style: style,
          containerSize: constraints.biggest,
          highlightedDates: highlightedDates,
          dateLines: dateLines,
          rows: rows
              .map(
                (e) => (
                  e,
                  switch (e) {
                    ActivityGridRow() => MeasureUtil.measureWidget(
                        Material(child: style.activityLabelBuilder?.call(e))),
                    TaskGridRow() => MeasureUtil.measureWidget(
                        Material(child: style.taskLabelBuilder(e))),
                  }
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
