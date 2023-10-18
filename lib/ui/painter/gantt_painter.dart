import 'package:flutter/material.dart';
import 'package:gantt_view/settings/gantt_style.dart';
import 'package:gantt_view/settings/grid_scheme.dart';
import 'package:gantt_view/ui/painter/data/gantt_config.dart';

abstract class GanttPainter extends CustomPainter {
  final GanttConfig config;

  GridScheme get gridScheme => config.gridScheme;
  GanttStyle get ganttStyle => config.style;

  DateTime get startDate => config.startDate;

  double get rowHeight => config.rowHeight;

  GanttPainter({required this.config});

  @override
  bool shouldRepaint(covariant GanttPainter oldDelegate) {
    return oldDelegate.config != config;
  }
}
