import 'package:flutter/material.dart';
import 'package:gantt_view/src/controller/gantt_data_controller.dart';
import 'package:gantt_view/src/model/grid_row.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';
import 'package:gantt_view/src/util/measure_util.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

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

  final _controllerGroup = LinkedScrollControllerGroup();
  late ScrollController _dateScrollController;

  @override
  void initState() {
    super.initState();
    _dateScrollController = _controllerGroup.addAndGet();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
              sliver: SliverList.builder(
                itemCount: widget.controller.rows.length,
                itemBuilder: (context, j) {
                  final row = widget.controller.rows[j];
                  if (row is ActivityGridRow) {
                    return Container(
                      color: Colors.blue,
                      height: MeasureUtil.measureWidget(
                                  widget.config.style.activityLabelBuilder(row))
                              .height +
                          1,
                    );
                  } else if (row is TaskGridRow) {
                    final height = MeasureUtil.measureWidget(
                                widget.config.style.taskLabelBuilder(row))
                            .height +
                        1;
                    return SizedBox(
                      height: height,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _controllerGroup.addAndGet(),
                        itemCount: widget.controller.columnCount,
                        itemBuilder: (context, column) {
                          final columnDate = DateTime(
                            widget.controller.startDate.year,
                            widget.controller.startDate.month,
                            widget.controller.startDate.day + column,
                          );

                          final startDate = DateTime(
                            row.task.startDate.year,
                            row.task.startDate.month,
                            row.task.startDate.day,
                          );

                          final endDate = DateTime(
                            row.task.endDate.year,
                            row.task.endDate.month,
                            row.task.endDate.day,
                          );

                          return Row(
                            children: [
                              if (startDate == columnDate)
                                Container(
                                  width: widget.config.cellWidth,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: widget.config.style.taskBarColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          widget.config.style.taskBarRadius),
                                      bottomLeft: Radius.circular(
                                          widget.config.style.taskBarRadius),
                                    ),
                                  ),
                                ),
                              if (endDate == columnDate)
                                Container(
                                    width: widget.config.cellWidth,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: widget.config.style.taskBarColor,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                            widget.config.style.taskBarRadius),
                                        bottomRight: Radius.circular(
                                            widget.config.style.taskBarRadius),
                                      ),
                                    )),
                              if (columnDate.isAfter(startDate) &&
                                  columnDate.isBefore(endDate))
                                Container(
                                  width: widget.config.cellWidth,
                                  height: 10,
                                  color: widget.config.style.taskBarColor,
                                ),
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
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
