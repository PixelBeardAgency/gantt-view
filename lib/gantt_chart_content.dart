import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/controller/gantt_data_controller.dart';
import 'package:gantt_view/model/cell/grid/grid_cell.dart';
import 'package:gantt_view/model/cell/header/header_cell.dart';
import 'package:gantt_view/painter/gantt_data_painter.dart';
import 'package:gantt_view/painter/gantt_ui_painter.dart';
import 'package:gantt_view/settings/gantt_config.dart';
import 'package:gantt_view/settings/gantt_grid.dart';

class GanttChartContent<T> extends StatefulWidget {
  final GanttChartController<T> controller;
  final GanttConfig config;

  final Map<int, Map<int, GridCell>> gridCells;
  final List<HeaderCell> headerCells;

  const GanttChartContent({
    super.key,
    required this.config,
    required this.controller,
    required this.gridCells,
    required this.headerCells,
  });

  @override
  State<GanttChartContent<T>> createState() => GanttChartContentState<T>();
}

class GanttChartContentState<T> extends State<GanttChartContent<T>> {
  double mouseX = 0;
  double mouseY = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.config.renderAreaSize.height,
      width: widget.config.renderAreaSize.width,
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
              widget.controller.setTooltipOffset(Offset(mouseX, mouseY));
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
                  widget.controller.setTooltipOffset(Offset(mouseX, mouseY));
                }
              },
              onPanUpdate: (details) => _updateOffset(
                  details.delta, widget.config.maxDx, widget.config.maxDy),
              child: ValueListenableBuilder(
                valueListenable: widget.controller.panOffset,
                builder: (context, panOffset, child) => ValueListenableBuilder(
                  valueListenable: widget.controller.tooltipOffset,
                  builder: (context, tooltipOffset, child) => CustomPaint(
                    size: Size.infinite,
                    willChange: true,
                    foregroundPainter: GanttUiPainter(
                      config: widget.config,
                      panOffset: panOffset,
                      headers: widget.headerCells,
                    ),
                    painter: GanttDataPainter(
                      cells: widget.gridCells,
                      config: widget.config,
                      panOffset: panOffset,
                      tooltipOffset: tooltipOffset,
                    ),
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
    var panOffset = widget.controller.panOffset.value;
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
