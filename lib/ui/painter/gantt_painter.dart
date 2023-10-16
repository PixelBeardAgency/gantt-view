import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_activity_iterable_extension.dart';
import 'package:gantt_view/extension/gantt_task_iterable_extension.dart';
import 'package:gantt_view/model/gantt_activity.dart';
import 'package:gantt_view/settings/theme/gantt_style.dart';
import 'package:gantt_view/settings/theme/grid_scheme.dart';
import 'package:gantt_view/ui/painter/data/gantt_grid_data.dart';
import 'package:gantt_view/ui/painter/data/gantt_layout_data.dart';

abstract class GanttPainter extends CustomPainter {
  final List<GanttActivity> data;
  final Offset panOffset;
  final GanttChartLayoutData layoutData;

  GridScheme get gridScheme => layoutData.settings.gridScheme;
  GanttStyle get ganttStyle => layoutData.settings.style;

  DateTime get startDate => data.allTasks.startDate;

  double get rowHeight => layoutData.rowHeight;

  GanttPainter(
      {required this.data, required this.panOffset, required this.layoutData});

  @override
  bool shouldRepaint(covariant GanttPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.layoutData != layoutData;
  }

  GanttGridData gridData(Size size) => GanttGridData(
        layoutData,
        size,
        panOffset,
        data.length + data.allTasks.length,
        rowHeight,
      );
}
