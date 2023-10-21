import 'package:flutter/material.dart';
import 'package:gantt_view/settings/gantt_config.dart';
import 'package:gantt_view/settings/gantt_visible_data.dart';

abstract class GanttPainter extends CustomPainter {
  final GanttConfig config;
  final Offset panOffset;

  GanttPainter({
    required this.config,
    required this.panOffset,
  });

  @override
  bool shouldRepaint(covariant GanttPainter oldDelegate) =>
      oldDelegate.config != config || oldDelegate.panOffset != panOffset;

  GanttVisibleData get gridData => GanttVisibleData(
        config.renderAreaSize,
        config.rows,
        config.uiOffset,
        config.columns,
        config.cellWidth,
        panOffset,
        config.rowHeight,
      );
}
