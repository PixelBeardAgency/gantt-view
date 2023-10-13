import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_event_list_extension.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/model/gantt_layout_data.dart';
import 'package:gantt_view/model/gantt_row_data.dart';
import 'package:gantt_view/settings/gantt_settings.dart';

abstract class GanttPainter extends CustomPainter {
  final List<GanttRowData> data;
  final Offset panOffset;
  final GanttSettings settings;
  final GanttChartLayoutData layoutData;

  double get rowHeight => settings.eventRowTheme.height;
  double get columnWidth => settings.legendTheme.dateWidth;

  DateTime get startDate => data.whereType<GanttEvent>().startDate;
  int get maxColumns => data.whereType<GanttEvent>().days;

  GanttPainter({
    required this.data,
    required this.panOffset,
    required this.settings,
    required this.layoutData
  });

  @override
  bool shouldRepaint(covariant GanttPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.settings != settings;
  }
}
