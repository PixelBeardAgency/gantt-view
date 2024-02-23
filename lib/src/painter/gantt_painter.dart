import 'package:flutter/material.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';
import 'package:gantt_view/src/settings/gantt_visible_data.dart';

abstract class GanttPainter extends CustomPainter {
  final GanttConfig config;
  final Offset panOffset;

  final GanttVisibleData gridData;

  GanttPainter({
    required this.config,
    required this.panOffset,
  }) : gridData = GanttVisibleData(
          config.rows,
          config.renderAreaSize,
          config.columnCount,
          config.cellWidth,
          panOffset,
          config.style.gridColor != null,
        );

  @override
  bool shouldRepaint(covariant GanttPainter oldDelegate) =>
      oldDelegate.config != config || oldDelegate.panOffset != panOffset;
}
