import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/src/controller/gantt_data_controller.dart';
import 'package:gantt_view/src/model/cell/grid/grid_cell.dart';
import 'package:gantt_view/src/model/cell/header/header_cell.dart';
import 'package:gantt_view/src/model/tooltip_type.dart';
import 'package:gantt_view/src/painter/gantt_data_painter.dart';
import 'package:gantt_view/src/painter/gantt_ui_painter.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';

class GanttChartContent<T> extends StatefulWidget {
  final GanttChartController<T> controller;
  final GanttConfig config;

  final Map<int, Map<int, GridCell>> gridCells;
  final List<HeaderCell> headerCells;

  final bool isBuilding;

  const GanttChartContent({
    super.key,
    required this.config,
    required this.controller,
    required this.gridCells,
    required this.headerCells,
    required this.isBuilding,
  });

  @override
  State<GanttChartContent<T>> createState() => GanttChartContentState<T>();
}

class GanttChartContentState<T> extends State<GanttChartContent<T>> {
  double mouseX = 0;
  double mouseY = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller.panOffset,
      builder: (context, panOffset, child) => ValueListenableBuilder(
        valueListenable: widget.controller.tooltipOffset,
        builder: (context, tooltipOffset, child) => SizedBox(
          height: widget.config.renderAreaSize.height,
          width: widget.config.renderAreaSize.width,
          child: Stack(
            children: [
              Positioned.fill(
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
                        widget.controller
                            .setTooltipOffset(Offset(mouseX, mouseY));
                      }
                    },
                    child: Listener(
                      onPointerSignal: (event) {
                        if (event is PointerScrollEvent) {
                          _updateOffset(
                            panOffset + -event.scrollDelta,
                            widget.config.maxDx,
                            widget.config.maxDy,
                          );
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          if (widget.config.grid.tooltipType ==
                              TooltipType.tap) {
                            widget.controller
                                .setTooltipOffset(Offset(mouseX, mouseY));
                          }
                        },
                        onPanUpdate: (details) => _updateOffset(
                          panOffset + details.delta,
                          widget.config.maxDx,
                          widget.config.maxDy,
                        ),
                        child: CustomPaint(
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
              if (widget.isBuilding)
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: widget.config.style.taskBarColor
                                  .withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              color: widget.config.style.taskBarColor,
                              strokeWidth: 1.5,
                            ),
                          ),
                        )),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void _updateOffset(Offset panOffset, double maxDx, double maxDy) {
    panOffset;
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
