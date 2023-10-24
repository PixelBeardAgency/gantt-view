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
          config.renderAreaSize,
          config.rows,
          config.uiOffset,
          config.columns,
          config.cellWidth,
          panOffset,
          config.rowHeight,
        );

  @override
  bool shouldRepaint(covariant GanttPainter oldDelegate) =>
      oldDelegate.config != config || oldDelegate.panOffset != panOffset;
}
