import 'package:flutter/material.dart';
import 'package:gantt_view/src/model/grid_row.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';

class GanttLabels<T> extends StatelessWidget {
  final GanttConfig<T> config;
  final ScrollController scrollController;
  final Function(double position) onScroll;

  const GanttLabels({
    super.key,
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
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
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
              separatorBuilder: (context, index) =>
                  config.style.gridColor != null
                      ? Divider(
                          color: config.style.gridColor,
                          height: 1,
                          thickness: 1,
                        )
                      : const SizedBox.shrink()),
        ),
      ),
    );
  }
}
