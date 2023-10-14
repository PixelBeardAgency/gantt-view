import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_event_list_extension.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/model/gantt_row_data.dart';
import 'package:gantt_view/ui/painter/data/gantt_grid_data.dart';
import 'package:gantt_view/ui/painter/data/gantt_layout_data.dart';

abstract class GanttPainter extends CustomPainter {
  final List<GanttRowData> data;
  final Offset panOffset;
  final GanttChartLayoutData layoutData;

  double get rowHeight => layoutData.settings.gridScheme.rowHeight;
  double get columnWidth => layoutData.settings.gridScheme.columnWidth;

  DateTime get startDate => data.whereType<GanttEvent>().startDate;
  int get maxColumns => data.whereType<GanttEvent>().days;

  GanttPainter(
      {required this.data, required this.panOffset, required this.layoutData});

  @override
  bool shouldRepaint(covariant GanttPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.layoutData != layoutData;
  }

  GanttGridData gridData(Size size) => GanttGridData(
        layoutData.settings,
        size,
        panOffset,
        data.length,
        maxColumns,
      );
}
