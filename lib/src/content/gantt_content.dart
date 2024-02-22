import 'package:flutter/material.dart';
import 'package:gantt_view/src/content/gantt_header_row.dart';
import 'package:gantt_view/src/content/gantt_labels.dart';
import 'package:gantt_view/src/content/gantt_tasks.dart';
import 'package:gantt_view/src/controller/gantt_data_controller.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';

class GanttContent<T> extends StatefulWidget {
  final GanttConfig<T> config;

  const GanttContent({
    super.key,
    required this.config,
  });

  @override
  State<GanttContent<T>> createState() => GanttContentState<T>();
}

class GanttContentState<T> extends State<GanttContent<T>> {
  final ScrollController _dateScrollController = ScrollController();
  final ScrollController _labelScrollController = ScrollController();
  final GanttChartController controller = GanttChartController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GanttHeaderRow(
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
              GanttLabels<T>(
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
                child: GanttTasks(
                  controller: controller,
                  config: widget.config,
                  onPanned: (position) {
                    controller.setPanOffset(position);
                    _dateScrollController.jumpTo(-position.dx);
                    _labelScrollController.jumpTo(-position.dy);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
