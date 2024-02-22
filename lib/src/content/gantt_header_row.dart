import 'package:flutter/material.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';

class GanttHeaderRow extends StatelessWidget {
  final GanttConfig config;
  final ScrollController dateScrollController;
  final Function(double position) onScroll;

  const GanttHeaderRow({
    super.key,
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
