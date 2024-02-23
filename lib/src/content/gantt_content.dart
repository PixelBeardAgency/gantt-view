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
  final ScrollController _yearScrollController = ScrollController();
  final ScrollController _monthScrollController = ScrollController();
  final ScrollController _dayScrollController = ScrollController();
  final ScrollController _labelScrollController = ScrollController();
  final GanttChartController controller = GanttChartController();

  @override
  void dispose() {
    _yearScrollController.dispose();
    _monthScrollController.dispose();
    _dayScrollController.dispose();
    _labelScrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            children: [
              GanttHeaderRow(
                config: widget.config,
                yearScrollController: _yearScrollController,
                monthScrollController: _monthScrollController,
                dayScrollController: _dayScrollController,
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
                          if (widget.config.style.showYear) {
                            _yearScrollController.jumpTo(-position.dx);
                          }

                          if (widget.config.style.showMonth) {
                            _monthScrollController.jumpTo(-position.dx);
                          }

                          if (widget.config.style.showDay) {
                            _dayScrollController.jumpTo(-position.dx);
                          }

                          _labelScrollController.jumpTo(-position.dy);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 10,
            child: Scrollbar(
              controller: _labelScrollController,
              child: SizedBox(height: widget.config.dataHeight, width: 10),
            ),
          ),
        ),
      ],
    );
  }
}
