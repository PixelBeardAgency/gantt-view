import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_event_list_extension.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/model/gantt_row_data.dart';
import 'package:gantt_view/settings/gantt_settings.dart';

class GanttEvents extends StatefulWidget {
  final List<GanttRowData> data;

  const GanttEvents({
    super.key,
    required this.data,
  });

  @override
  State<GanttEvents> createState() => _GanttEventsState();
}

class _GanttEventsState extends State<GanttEvents> {
  Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: GestureDetector(
        onPanUpdate: (details) => setState(
          () {
            offset += details.delta;
          },
        ),
        child: CustomPaint(
          size: Size.infinite,
          willChange: true,
          painter: GanttChartPainter(
            data: widget.data,
            offset: offset,
            settings: GanttSettings.of(context),
          ),
        ),
      ),
    );
  }
}

class GanttChartPainter extends CustomPainter {
  final List<GanttRowData> data;
  final Offset offset;
  final GanttSettings settings;

  double get height => settings.eventRowTheme.height;
  double get width => settings.legendTheme.dateWidth;

  GanttChartPainter({
    required this.data,
    required this.offset,
    required this.settings,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final visibleRows = (size.height / height).ceil();
    final int firstVisibleRow = max(0, (-offset.dy / height).floor());
    final int lastVisibleRow =
        min(data.length, firstVisibleRow + visibleRows) + 1;

    for (int index = firstVisibleRow; index < lastVisibleRow; index++) {
      final rowData = data[index];

      if (rowData is GanttEvent) {
        final start = rowData.startDate;
        final end = rowData.endDate;

        final paint = Paint()
          ..color = settings.eventRowTheme.fillColor
          ..style = PaintingStyle.fill;

        final rect = _taskrect(index, start, end);

        if (!(rect.right + offset.dx < 0 ||
            rect.left + offset.dx > size.width)) {
          canvas.drawRect(
            rect.shift(offset),
            paint,
          );
        }
      }

      final titleRect = _titleRect(index);

      final titlePaint = Paint()
        ..color = rowData is GanttEvent
            ? settings.headerRowTheme.backgroundColor
            : settings.eventRowTheme.labelColor
        ..style = PaintingStyle.fill;

      final titleOffset = Offset(0, offset.dy);
      canvas.drawRect(
        titleRect.shift(titleOffset),
        titlePaint,
      );

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
        maxWidth: titleRect.width,
      );

      textPainter.paint(
        canvas,
        Offset(
              0,
              titleRect.top + height / 4,
            ) +
            titleOffset,
      );
    }
  }

  Rect _taskrect(int index, DateTime start, DateTime end) {
    final startOffset = Offset(
      (start
                  .difference(data.whereType<GanttEvent>().startDate)
                  .inDays
                  .toDouble() *
              width) +
          settings.legendTheme.width,
      index * height,
    );
    final endOffset = Offset(
      (end
                  .difference(data.whereType<GanttEvent>().startDate)
                  .inDays
                  .toDouble() *
              width) +
          settings.legendTheme.width,
      (index + 1) * height,
    );

    return Rect.fromPoints(
      startOffset,
      endOffset,
    );
  }

  Rect _titleRect(int index) {
    final startOffset = Offset(
      0,
      index * height,
    );
    final endOffset = Offset(
      settings.legendTheme.width,
      (index + 1) * height,
    );

    return Rect.fromPoints(
      startOffset,
      endOffset,
    );
  }

  @override
  bool shouldRepaint(covariant GanttChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.offset != offset;
  }
}
