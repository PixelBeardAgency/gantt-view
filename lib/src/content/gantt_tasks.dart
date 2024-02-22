import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/src/controller/gantt_data_controller.dart';
import 'package:gantt_view/src/model/tooltip_type.dart';
import 'package:gantt_view/src/painter/gantt_data_painter.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';

class GanttTasks extends StatefulWidget {
  final GanttChartController controller;
  final GanttConfig config;
  final Function(Offset position) onPanned;

  const GanttTasks({
    super.key,
    required this.controller,
    required this.config,
    required this.onPanned,
  });

  @override
  State<GanttTasks> createState() => _GanttTasksState();
}

class _GanttTasksState extends State<GanttTasks> {
  double mouseX = 0;
  double mouseY = 0;
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: MouseRegion(
        onExit: (event) {
          if (widget.config.style.tooltipType == TooltipType.hover) {
            widget.controller.setTooltipOffset(Offset.zero);
          }
        },
        onHover: (event) {
          mouseX = event.localPosition.dx;
          mouseY = event.localPosition.dy;
          if (widget.config.style.tooltipType == TooltipType.hover) {
            widget.controller.setTooltipOffset(Offset(mouseX, mouseY));
          }
        },
        child: Listener(
          onPointerSignal: (event) {
            if (event is PointerScrollEvent) {
              _updateOffset(widget.controller.panOffset + -event.scrollDelta);
            }
          },
          child: GestureDetector(
            onTap: () {
              if (widget.config.style.tooltipType == TooltipType.tap) {
                widget.controller.setTooltipOffset(Offset(mouseX, mouseY));
              }
            },
            onPanUpdate: (details) =>
                _updateOffset(widget.controller.panOffset + details.delta),
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, child) => CustomPaint(
                size: widget.config.renderAreaSize,
                painter: GanttDataPainter(
                  config: widget.config,
                  panOffset: widget.controller.panOffset,
                  tooltipOffset: widget.controller.tooltipOffset,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateOffset(Offset panOffset) {
    if (panOffset.dx > 0) {
      panOffset = Offset(0, panOffset.dy);
    }
    if (panOffset.dx < -widget.config.maxDx) {
      panOffset = Offset(-widget.config.maxDx, panOffset.dy);
    }
    if (panOffset.dy > 0) {
      panOffset = Offset(panOffset.dx, 0);
    }
    if (panOffset.dy < -widget.config.maxDy) {
      panOffset = Offset(panOffset.dx, -widget.config.maxDy);
    }
    widget.onPanned(panOffset);
  }
}
