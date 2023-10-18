import 'package:flutter/material.dart';
import 'package:gantt_view/settings/gantt_config.dart';
import 'package:gantt_view/settings/gantt_grid.dart';
import 'package:gantt_view/settings/gantt_style.dart';

abstract class GanttPainter extends CustomPainter {
  final GanttConfig config;

  GanttGrid get grid => config.grid;
  GanttStyle get ganttStyle => config.style;

  DateTime get startDate => config.startDate;

  double get rowHeight => config.rowHeight;

  GanttPainter({required this.config});

  @override
  bool shouldRepaint(covariant GanttPainter oldDelegate) {
    return oldDelegate.config != config;
  }
}
