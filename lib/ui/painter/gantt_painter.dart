import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_event_list_extension.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/model/gantt_row_data.dart';
import 'package:gantt_view/settings/gantt_settings.dart';

abstract class GanttPainter extends CustomPainter {
  final List<GanttRowData> data;
  final Offset offset;
  final GanttSettings settings;

  final double titleWidth;
  final double legendHeight;

  double get rowHeight => settings.eventRowTheme.height;
  double get columnWidth => settings.legendTheme.dateWidth;

  DateTime get startDate => data.whereType<GanttEvent>().startDate;
  int get maxColumns => data.whereType<GanttEvent>().days;

  GanttPainter({
    required this.data,
    required this.offset,
    required this.settings,
  })  : titleWidth = _getTitleWidth(data, settings),
        legendHeight = _getLegendHeight(settings);

  static double _getTitleWidth(
      List<GanttRowData> data, GanttSettings settings) {
    double width = 0;
    for (var rowData in data) {
      final textPainter = TextPainter(
        maxLines: 1,
        text: TextSpan(
          text: rowData.label,
          style: settings.headerRowTheme.textStyle,
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(
        minWidth: 0,
        maxWidth: double.infinity,
      );
      width = max(width, textPainter.width);
    }
    return width;
  }

  static double _getLegendHeight(GanttSettings settings) {
    if (settings.legendTheme.showYear) {
      final textPainter = TextPainter(
        maxLines: 3,
        textAlign: TextAlign.center,
        text: TextSpan(
          text: [
            if (settings.legendTheme.showYear) '',
            if (settings.legendTheme.showMonth) '',
            if (settings.legendTheme.showDay) '',
          ].join('\n'),
          style: settings.headerRowTheme.textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: settings.legendTheme.dateWidth,
      );
      return textPainter.height;
    }
    return 0;
  }

  @override
  bool shouldRepaint(covariant GanttPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.offset != offset ||
        oldDelegate.settings != settings;
  }
}
