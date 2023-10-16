import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_activity_iterable_extension.dart';
import 'package:gantt_view/model/gantt_activity.dart';
import 'package:gantt_view/settings/gantt_settings.dart';
import 'package:gantt_view/ui/painter/data/gantt_layout_data.dart';
import 'package:gantt_view/ui/painter/gantt_data_painter.dart';
import 'package:gantt_view/ui/painter/gantt_ui_painter.dart';

class GanttChart extends StatelessWidget {
  final List<GanttActivity> data;

  const GanttChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => _GanttChartContent(
        data: data,
        layoutData: GanttChartLayoutData(
          data: data,
          settings: GanttSettings.of(context),
          size: constraints.biggest,
        ),
      ),
    );
  }
}

class _GanttChartContent extends StatefulWidget {
  final List<GanttActivity> data;
  final GanttChartLayoutData layoutData;

  const _GanttChartContent({required this.data, required this.layoutData});

  @override
  State<_GanttChartContent> createState() => _GanttChartContentState();
}

class _GanttChartContentState extends State<_GanttChartContent> {
  Offset panOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: min(
                    constraints.maxHeight,
                    (widget.data.length + widget.data.allTasks.length) *
                            widget.layoutData.rowHeight +
                        widget.layoutData.timelineHeight),
                width: min(
                    constraints.maxWidth,
                    widget.layoutData.maxColumns *
                            widget.layoutData.settings.gridScheme.columnWidth +
                        widget.layoutData.labelColumnWidth),
                child: ClipRect(
                  child: Listener(
                    onPointerSignal: (event) {
                      if (event is PointerScrollEvent) {
                        _updateOffset(
                          -event.scrollDelta,
                          widget.layoutData.maxDx,
                          widget.layoutData.maxDy,
                        );
                      }
                    },
                    child: GestureDetector(
                      onPanUpdate: (details) => _updateOffset(details.delta,
                          widget.layoutData.maxDx, widget.layoutData.maxDy),
                      child: CustomPaint(
                        size: Size.infinite,
                        willChange: true,
                        foregroundPainter: GanttUiPainter(
                          data: widget.data,
                          panOffset: panOffset,
                          layoutData: widget.layoutData,
                        ),
                        painter: GanttDataPainter(
                          data: widget.data,
                          panOffset: panOffset,
                          layoutData: widget.layoutData,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  void _updateOffset(Offset delta, double maxDx, double maxDy) {
    setState(() {
      panOffset += delta;
      if (panOffset.dx > 0) {
        panOffset = Offset(0, panOffset.dy);
      }
      if (panOffset.dx < -maxDx) {
        panOffset = Offset(-maxDx, panOffset.dy);
      }
      if (panOffset.dy > 0) {
        panOffset = Offset(panOffset.dx, 0);
      }
      if (panOffset.dy < -maxDy) {
        panOffset = Offset(panOffset.dx, -maxDy);
      }
    });
  }
}
