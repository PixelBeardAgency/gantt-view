import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/controller/gantt_data_controller.dart';
import 'package:gantt_view/extension/gantt_activity_iterable_extension.dart';
import 'package:gantt_view/model/gantt_activity.dart';
import 'package:gantt_view/painter/gantt_data_painter.dart';
import 'package:gantt_view/painter/gantt_ui_painter.dart';
import 'package:gantt_view/settings/gantt_config.dart';
import 'package:gantt_view/settings/gantt_grid.dart';
import 'package:gantt_view/settings/gantt_style.dart';

class GanttChart<T> extends StatelessWidget {
  final GanttChartController<T> controller;
  final GanttGrid? grid;
  final GanttStyle? style;
  final String? title;
  final String? subtitle;

  GanttChart({
    super.key,
    required this.controller,
    this.grid,
    this.style,
    this.title,
    this.subtitle,
  }) : assert(
            controller.activities.allTasks
                .every((task) => task.endDate.compareTo(task.startDate) >= 0),
            'All tasks must have a start date before or equal to the end date.');

  @override
  Widget build(BuildContext context) {
    return controller.activities.isNotEmpty
        ? LayoutBuilder(
            builder: (context, constraints) => ListenableBuilder(
              listenable: controller,
              builder: (context, child) => _GanttChartContent(
                activities: controller.activities,
                config: GanttConfig(
                  activities: controller.activities,
                  grid: grid,
                  style: style,
                  title: title,
                  subtitle: subtitle,
                  containerSize: constraints.biggest,
                  panOffset: controller.panOffset,
                  tooltipOffset: controller.tooltipOffset,
                ),
                controller: controller,
              ),
            ),
          )
        : const Center(child: Text('No data'));
  }
}

class _GanttChartContent<T> extends StatefulWidget {
  final List<GanttActivity> activities;
  final GanttChartController<T> controller;
  final GanttConfig config;

  const _GanttChartContent({
    required this.activities,
    required this.config,
    required this.controller,
  });

  @override
  State<_GanttChartContent<T>> createState() => _GanttChartContentState<T>();
}

class _GanttChartContentState<T> extends State<_GanttChartContent<T>> {
  double mouseX = 0;
  double mouseY = 0;

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
            child: MouseRegion(
              onExit: (event) {
                if (widget.config.grid.tooltipType == TooltipType.hover) {
                  widget.controller.setTooltipOffset(Offset.zero);
                }
              },
              onHover: (event) {
                mouseX = event.localPosition.dx;
                mouseY = event.localPosition.dy;
                if (widget.config.grid.tooltipType == TooltipType.hover) {
                  setState(() => widget.controller
                      .setTooltipOffset(Offset(mouseX, mouseY)));
                }
              },
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
                  onTap: () {
                    if (widget.config.grid.tooltipType == TooltipType.tap) {
                      setState(() => widget.controller
                          .setTooltipOffset(Offset(mouseX, mouseY)));
                    }
                  },
                  onPanUpdate: (details) => _updateOffset(
                      details.delta, widget.config.maxDx, widget.config.maxDy),
                  child: CustomPaint(
                    size: Size.infinite,
                    willChange: true,
                    foregroundPainter: GanttUiPainter(config: widget.config),
                    painter: GanttDataPainter(config: widget.config),
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
    var panOffset = widget.controller.panOffset;
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

    widget.controller.setPanOffset(panOffset);
  }
}
