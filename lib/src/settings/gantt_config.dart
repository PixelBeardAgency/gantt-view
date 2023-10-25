import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/src/model/cell/header/header_cell.dart';
import 'package:gantt_view/src/model/timeline_axis_type.dart';
import 'package:gantt_view/src/settings/gantt_grid.dart';
import 'package:gantt_view/src/settings/gantt_style.dart';

class GanttConfig {
  final GanttGrid grid;
  final GanttStyle style;

  final String? title;
  final String? subtitle;

  final DateTime startDate;
  final int columns;
  final int rows;

  late Size renderAreaSize;

  late double maxDx;
  late double maxDy;

  late double rowHeight;
  late double dataHeight;

  late double cellWidth;
  late double dataWidth;

  int get widthDivisor => switch (grid.timelineAxisType) {
        TimelineAxisType.daily => 1,
        TimelineAxisType.weekly => 7,
      };

  late Offset uiOffset;

  double get labelColumnWidth => uiOffset.dx;
  double get timelineHeight => uiOffset.dy;

  GanttConfig({
    required Iterable<HeaderCell> headers,
    GanttGrid? grid,
    GanttStyle? style,
    this.title,
    this.subtitle,
    required Size containerSize,
    required this.startDate,
    required this.columns,
    required this.rows,
  })  : grid = grid ?? const GanttGrid(),
        style = style ?? GanttStyle() {
    rowHeight = this.grid.barHeight +
        this.grid.rowSpacing +
        this.style.labelPadding.vertical;
    cellWidth = this.grid.columnWidth / widthDivisor;

    dataHeight = rows * rowHeight;
    dataWidth = columns * cellWidth;

    uiOffset = Offset(
      _titleWidth(headers),
      _legendHeight(),
    );

    renderAreaSize = Size(
      min(containerSize.width, dataWidth + labelColumnWidth),
      min(containerSize.height, dataHeight + timelineHeight),
    );

    maxDx = _horizontalScrollBoundary;
    maxDy = _verticalScrollBoundary;
  }

  double get _horizontalScrollBoundary {
    var renderAreaWidth = renderAreaSize.width - labelColumnWidth;
    return dataWidth < renderAreaWidth
        ? 0
        : dataWidth - renderAreaSize.width + labelColumnWidth;
  }

  double get _verticalScrollBoundary =>
      dataHeight < (renderAreaSize.height - timelineHeight)
          ? 0
          : dataHeight - renderAreaSize.height + timelineHeight;

  double _titleWidth(Iterable<HeaderCell> headers) {
    double width = 0;
    final headersCount = headers.length;
    for (int i = 0; i < headersCount; i++) {
      final header = headers.elementAt(i);
      if (header is ActivityHeaderCell) {
        width = max(
          width,
          textPainter(header.label ?? '', style.activityLabelStyle, maxLines: 1)
                  .width +
              style.labelPadding.horizontal,
        );
      } else if (header is TaskHeaderCell) {
        width = max(
          width,
          textPainter(header.label!, style.taskLabelStyle, maxLines: 1).width +
              style.labelPadding.horizontal,
        );
      }
    }
    return max(width, titlePainter().width + style.titlePadding.horizontal);
  }

  double _legendHeight() => max(
        datePainter(
              [
                if (grid.showYear) '2022',
                if (grid.showMonth) '12',
                if (grid.showDay) '31',
              ],
            ).height +
            style.titlePadding.bottom,
        titlePainter().height + style.titlePadding.vertical,
      );

  TextPainter titlePainter() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: title,
        style: style.titleStyle,
        children: [
          if (subtitle != null)
            TextSpan(
              text: '\n$subtitle',
              style: style.subtitleStyle,
            )
        ],
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: double.infinity,
    );
    return textPainter;
  }

  TextPainter datePainter(Iterable<String> dates) {
    final textPainter = TextPainter(
      maxLines: 3,
      textAlign: TextAlign.center,
      text: TextSpan(
        text: dates.join('\n'),
        style: style.timelineStyle,
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: grid.columnWidth,
    );

    return textPainter;
  }

  TextPainter textPainter(
    String label,
    TextStyle style, {
    double maxWidth = double.infinity,
    int? maxLines,
  }) {
    final textPainter = TextPainter(
      maxLines: maxLines,
      text: TextSpan(
        text: label,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: maxWidth,
    );
    return textPainter;
  }
}
