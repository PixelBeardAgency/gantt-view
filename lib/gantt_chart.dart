import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/controller/gantt_data_controller.dart';
import 'package:gantt_view/extension/gantt_activity_iterable_extension.dart';
import 'package:gantt_view/model/gantt_activity.dart';
import 'package:gantt_view/settings/gantt_style.dart';
import 'package:gantt_view/settings/grid_scheme.dart';
import 'package:gantt_view/ui/painter/data/gantt_config.dart';
import 'package:gantt_view/ui/painter/gantt_data_painter.dart';
import 'package:gantt_view/ui/painter/gantt_ui_painter.dart';

class GanttChart<T> extends StatelessWidget {
  final GanttDataController<T> controller;
  final GridScheme? gridScheme;
  final GanttStyle? style;
  final String? title;
  final String? subtitle;

  GanttChart({
    super.key,
    required this.controller,
    this.gridScheme,
    this.style,
    this.title,
    this.subtitle,
  }) : assert(
            controller.activities.allTasks.every(
                (event) => event.endDate.compareTo(event.startDate) >= 0),
            'All tasks must have a start date before or equal to the end date.');

  @override
  Widget build(BuildContext context) {
    return controller.activities.isNotEmpty
        ? LayoutBuilder(
            builder: (context, constraints) => _GanttChartContent(
              activities: controller.activities,
              config: GanttConfig(
                context,
                activities: controller.activities,
                gridScheme: gridScheme,
                style: style,
                title: title,
                subtitle: subtitle,
                containerSize: constraints.biggest,
              ),
            ),
          )
        : const Center(child: Text('No data'));
  }
}

class _GanttChartContent extends StatefulWidget {
  final List<GanttActivity> activities;
  final GanttConfig config;

  const _GanttChartContent({required this.activities, required this.config});

  @override
  State<_GanttChartContent> createState() => _GanttChartContentState();
}

class _GanttChartContentState extends State<_GanttChartContent> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: min(
              constraints.maxHeight,
              (widget.activities.length + widget.activities.allTasks.length) *
                      widget.config.rowHeight +
                  widget.config.timelineHeight),
          width: min(
              constraints.maxWidth,
              widget.config.columns * widget.config.cellWidth +
                  widget.config.labelColumnWidth),
          child: ClipRect(
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  _updateOffset(
                    -event.scrollDelta,
                    widget.config.maxDx,
                    widget.config.maxDy,
                  );
                }
              },
              child: GestureDetector(
                onPanUpdate: (details) => _updateOffset(
                    details.delta, widget.config.maxDx, widget.config.maxDy),
                child: CustomPaint(
                  size: Size.infinite,
                  willChange: true,
                  foregroundPainter: GanttUiPainter(
                    config: widget.config,
                  ),
                  painter: GanttDataPainter(
                    config: widget.config,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateOffset(Offset delta, double maxDx, double maxDy) {
    var panOffset = widget.config.panOffset;
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
    setState(() {
      widget.config.setPanOffset(panOffset);
    });
  }
}
