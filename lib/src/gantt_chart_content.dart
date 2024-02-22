import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/src/controller/gantt_data_controller.dart';
import 'package:gantt_view/src/model/grid_row.dart';
import 'package:gantt_view/src/model/tooltip_type.dart';
import 'package:gantt_view/src/painter/gantt_data_painter.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';

class GanttChartContent<T> extends StatefulWidget {
  final GanttConfig<T> config;

  const GanttChartContent({
    super.key,
    required this.config,
  });

  @override
  State<GanttChartContent<T>> createState() => GanttChartContentState<T>();
}

class GanttChartContentState<T> extends State<GanttChartContent<T>> {
  double mouseX = 0;
  double mouseY = 0;

  final ScrollController _dateScrollController = ScrollController();
  final ScrollController _labelScrollController = ScrollController();
  final GanttChartController controller = GanttChartController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GanttChartHeaderRow(
          config: widget.config,
          dateScrollController: _dateScrollController,
          onScroll: (double position) => controller.setPanX(position),
        ),
        if (widget.config.style.axisDividerColor != null)
          Divider(
            color: widget.config.style.axisDividerColor,
            height: 1,
            thickness: 1,
          ),
        Expanded(
          child: Row(
            children: [
              _ChartLabels<T>(
                config: widget.config,
                scrollController: _labelScrollController,
                onScroll: (position) => controller.setPanY(position),
              ),
              if (widget.config.style.axisDividerColor != null)
                VerticalDivider(
                  color: widget.config.style.axisDividerColor,
                  width: 1,
                  thickness: 1,
                ),
              Expanded(
                child: ClipRect(
                  child: MouseRegion(
                    onExit: (event) {
                      if (widget.config.grid.tooltipType == TooltipType.hover) {
                        controller.setTooltipOffset(Offset.zero);
                      }
                    },
                    onHover: (event) {
                      mouseX = event.localPosition.dx;
                      mouseY = event.localPosition.dy;
                      if (widget.config.grid.tooltipType == TooltipType.hover) {
                        controller.setTooltipOffset(Offset(mouseX, mouseY));
                      }
                    },
                    child: Listener(
                      onPointerSignal: (event) {
                        if (event is PointerScrollEvent) {
                          _updateOffset(
                            controller.panOffset + -event.scrollDelta,
                            widget.config.maxDx,
                            widget.config.maxDy,
                          );
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          if (widget.config.grid.tooltipType ==
                              TooltipType.tap) {
                            controller.setTooltipOffset(Offset(mouseX, mouseY));
                          }
                        },
                        onPanUpdate: (details) => _updateOffset(
                          controller.panOffset + details.delta,
                          widget.config.maxDx,
                          widget.config.maxDy,
                        ),
                        child: ListenableBuilder(
                          listenable: controller,
                          builder: (context, child) => CustomPaint(
                            size: Size.infinite,
                            willChange: true,
                            painter: GanttDataPainter<T>(
                              config: widget.config,
                              panOffset: controller.panOffset,
                              tooltipOffset: controller.tooltipOffset,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
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

    controller.setPanOffset(panOffset);
    _dateScrollController.jumpTo(-panOffset.dx);
    _labelScrollController.jumpTo(-panOffset.dy);
  }
}

class _ChartLabels<T> extends StatelessWidget {
  final GanttConfig<T> config;
  final ScrollController scrollController;
  final Function(double position) onScroll;

  const _ChartLabels({
    required this.config,
    required this.scrollController,
    required this.onScroll,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        onScroll(scrollNotification.metrics.pixels);
        return true;
      },
      child: SizedBox(
        width: config.labelColumnWidth,
        child: ListView.separated(
            controller: scrollController,
            itemCount: config.rows.length,
            itemBuilder: (context, index) {
              final row = config.rows[index].$1;
              if (row is ActivityGridRow &&
                  config.style.activityLabelBuilder != null) {
                return Container(
                  color: config.style.activityLabelColor,
                  child: config.style.activityLabelBuilder!.call(row),
                );
              } else if (row is TaskGridRow<T>) {
                return Container(
                  color: config.style.taskLabelColor,
                  child: config.style.taskLabelBuilder.call(row),
                );
              }
              return const SizedBox.shrink();
            },
            separatorBuilder: (context, index) => config.style.gridColor != null
                ? Divider(
                    color: config.style.gridColor,
                    height: 1,
                    thickness: 1,
                  )
                : const SizedBox.shrink()),
      ),
    );
  }
}

class _GanttChartHeaderRow extends StatelessWidget {
  final GanttConfig config;
  final ScrollController dateScrollController;
  final Function(double position) onScroll;

  const _GanttChartHeaderRow({
    required this.config,
    required this.dateScrollController,
    required this.onScroll,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: config.timelineHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: config.labelColumnWidth,
            child: config.style.chartTitleBuilder?.call(),
          ),
          if (config.style.axisDividerColor != null)
            VerticalDivider(
              color: config.style.axisDividerColor,
              width: 1,
              thickness: 1,
            ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                onScroll(scrollNotification.metrics.pixels);
                return true;
              },
              child: ListView.builder(
                itemBuilder: (context, index) => SizedBox(
                  width: config.cellWidth,
                  child: config.style.dateLabelBuilder(
                      config.startDate.add(Duration(days: index))),
                ),
                itemCount: config.columnCount,
                scrollDirection: Axis.horizontal,
                controller: dateScrollController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
