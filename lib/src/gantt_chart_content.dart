import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/src/controller/gantt_data_controller.dart';
import 'package:gantt_view/src/model/grid_row.dart';
import 'package:gantt_view/src/model/tooltip_type.dart';
import 'package:gantt_view/src/painter/gantt_data_painter.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';

class GanttChartContent<T> extends StatefulWidget {
  final GanttChartController<T> controller;
  final GanttConfig config;

  const GanttChartContent({
    super.key,
    required this.config,
    required this.controller,
  });

  @override
  State<GanttChartContent<T>> createState() => GanttChartContentState<T>();
}

class GanttChartContentState<T> extends State<GanttChartContent<T>> {
  double mouseX = 0;
  double mouseY = 0;

  final ScrollController _dateScrollController = ScrollController();
  final ScrollController _labelScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _labelScrollController,
      slivers: [
        SliverPersistentHeader(
          delegate: MyHeaderDelegate(
            labelColumnWidth: widget.config.labelColumnWidth,
            title: widget.config.style.chartTitleBuilder?.call(),
            timelineHeight: widget.config.timelineHeight,
            itemBuilder: (context, index) => SizedBox(
              width: widget.config.cellWidth,
              child: widget.config.style.dateLabelBuilder(
                  widget.controller.startDate.add(Duration(days: index))),
            ),
            dateScrollController: _dateScrollController,
            columnCount: widget.controller.columnCount,
          ),
        ),
        SliverCrossAxisGroup(
          slivers: [
            SliverConstrainedCrossAxis(
              maxExtent: widget.config.labelColumnWidth,
              sliver: SliverList.builder(
                itemCount: widget.controller.rows.length,
                itemBuilder: (context, index) {
                  final row = widget.controller.rows[index];
                  if (row is ActivityGridRow) {
                    return widget.config.style.activityLabelBuilder(row);
                  } else if (row is TaskGridRow) {
                    return widget.config.style.taskLabelBuilder(row);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            SliverCrossAxisExpanded(
              flex: 1,
              sliver: SliverToBoxAdapter(
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
                            widget.controller.panOffset + -event.scrollDelta,
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
                          widget.controller.panOffset + details.delta,
                          widget.config.maxDx,
                          widget.config.maxDy,
                        ),
                        child: CustomPaint(
                          size: Size.infinite,
                          willChange: true,
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
              ),
            ),
          ],
        )
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

    widget.controller.setPanOffset(panOffset);
    _dateScrollController.jumpTo(-panOffset.dx);
    _labelScrollController.jumpTo(-panOffset.dy);
  }
}

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double labelColumnWidth;
  final double timelineHeight;
  final Widget? title;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final ScrollController dateScrollController;
  final int columnCount;

  MyHeaderDelegate({
    required this.labelColumnWidth,
    required this.timelineHeight,
    required this.title,
    required this.itemBuilder,
    required this.dateScrollController,
    required this.columnCount,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Row(
      children: [
        SizedBox(
          width: labelColumnWidth,
          child: title,
        ),
        Expanded(
          child: SizedBox(
            height: timelineHeight,
            child: ListView.builder(
              itemBuilder: itemBuilder,
              itemCount: columnCount,
              scrollDirection: Axis.horizontal,
              controller: dateScrollController,
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => timelineHeight;

  @override
  double get minExtent => timelineHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
