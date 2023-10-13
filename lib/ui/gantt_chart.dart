import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_event_list_extension.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/model/gantt_row_data.dart';
import 'package:gantt_view/settings/gantt_settings.dart';
import 'package:gantt_view/ui/painter/gantt_data_painter.dart';
import 'package:gantt_view/ui/painter/gantt_ui_painter.dart';

class GanttChart extends StatelessWidget {
  final List<GanttRowData> data;

  const GanttChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return _GanttChartContent(
      data: data,
      layoutData: GanttChartLayoutData(
        data: data.whereType<GanttEvent>(),
        settings: GanttSettings.of(context),
        screenSize: MediaQuery.of(context).size,
      ),
    );
  }
}

class _GanttChartContent extends StatefulWidget {
  final List<GanttRowData> data;
  final GanttChartLayoutData layoutData;

  const _GanttChartContent({required this.data, required this.layoutData});

  @override
  State<_GanttChartContent> createState() => _GanttChartContentState();
}

class _GanttChartContentState extends State<_GanttChartContent> {
  Offset panOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: GestureDetector(
        onPanUpdate: (details) => setState(
          () => _updateOffset(
              details, widget.layoutData.maxDx, widget.layoutData.maxDy),
        ),
        child: CustomPaint(
          size: Size.infinite,
          willChange: true,
          foregroundPainter: GanttUiPainter(
            data: widget.data,
            panOffset: panOffset,
            settings: GanttSettings.of(context),
            uiOffset: widget.layoutData.uiOffset,
          ),
          painter: GanttDataPainter(
            data: widget.data,
            panOffset: panOffset,
            settings: GanttSettings.of(context),
            uiOffset: widget.layoutData.uiOffset,
          ),
        ),
      ),
    );
  }

  void _updateOffset(DragUpdateDetails details, double maxDx, double maxDy) {
    panOffset += details.delta;
    if (panOffset.dx > 0) {
      panOffset = Offset(0, panOffset.dy);
    }
    if (panOffset.dx < -maxDx) {
      panOffset = Offset(-maxDx, panOffset.dy);
    }
    if (panOffset.dy > 0) {
      panOffset = Offset(panOffset.dx, 0);
    }
    if (panOffset.dy < maxDy) {
      panOffset = Offset(panOffset.dx, maxDy);
    }
  }
}

class GanttChartLayoutData {
  late double titleWidth;
  late double legendHeight;
  late double maxDx;
  late double maxDy;

  GanttChartLayoutData(
      {required Iterable<GanttEvent> data,
      required GanttSettings settings,
      required Size screenSize}) {
    titleWidth = _getTitleWidth(data, settings);
    legendHeight = _getLegendHeight(settings);
    maxDx = _getHorizontalScrollBoundary(
      data,
      settings.legendTheme.dateWidth,
      screenSize.width,
      titleWidth,
    );
    maxDy = _getVerticalScrollBoundary(
      data,
      settings.eventRowTheme.height,
      screenSize.height,
      legendHeight,
    );
  }

  Offset get uiOffset => Offset(titleWidth, legendHeight);

  double _getHorizontalScrollBoundary(Iterable<GanttEvent> data,
          double columnWidth, double screenWidth, double offset) =>
      ((data.whereType<GanttEvent>().days) * columnWidth) -
      screenWidth +
      offset;

  double _getVerticalScrollBoundary(Iterable<GanttEvent> data, double rowHeight,
          double screenHeight, double offset) =>
      ((data.length + 1) * rowHeight) - screenHeight + offset;

  static double _getTitleWidth(
      Iterable<GanttRowData> data, GanttSettings settings) {
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
}
