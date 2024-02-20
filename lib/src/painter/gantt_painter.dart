import 'package:flutter/material.dart';
import 'package:gantt_view/src/model/grid_row.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';
import 'package:gantt_view/src/settings/gantt_visible_data.dart';

abstract class GanttPainter extends CustomPainter {
  final GanttConfig config;
  final Offset panOffset;
  final List<GridRow> rows;

  final GanttVisibleData gridData;

  GanttPainter({
    required this.config,
    required this.panOffset,
    required this.rows,
  }) : gridData = GanttVisibleData(
          config.renderAreaSize,
          config.rows.length,
          config.columnCount,
          config.cellWidth,
          panOffset,
          config.rowHeight,
        );

  @override
  bool shouldRepaint(covariant GanttPainter oldDelegate) =>
      oldDelegate.config != config || oldDelegate.panOffset != panOffset;
}
