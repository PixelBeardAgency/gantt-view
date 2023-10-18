import 'package:flutter/material.dart';
import 'package:gantt_view/settings/theme/gantt_style.dart';
import 'package:gantt_view/settings/theme/grid_scheme.dart';
import 'package:gantt_view/ui/painter/data/gantt_grid_data.dart';
import 'package:gantt_view/ui/painter/data/gantt_layout_data.dart';

abstract class GanttPainter extends CustomPainter {
  final Offset panOffset;
  final GanttChartLayoutData layoutData;

  GridScheme get gridScheme => layoutData.settings.gridScheme;
  GanttStyle get ganttStyle => layoutData.settings.style;

  DateTime get startDate => layoutData.startDate;

  double get rowHeight => layoutData.rowHeight;

  GanttPainter({required this.panOffset, required this.layoutData});

  @override
  bool shouldRepaint(covariant GanttPainter oldDelegate) {
    return oldDelegate.panOffset != panOffset ||
        oldDelegate.layoutData != layoutData;
  }

  GanttGridData gridData(Size size) => GanttGridData(
        layoutData,
        size,
        panOffset,
        rowHeight,
      );
}
