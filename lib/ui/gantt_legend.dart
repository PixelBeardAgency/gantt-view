import 'package:flutter/material.dart';
import 'package:gantt_view/controller/synced_scroll_controller.dart';
import 'package:gantt_view/extension/gantt_event_list_extension.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/settings/gantt_settings.dart';

class GanttLegend extends StatefulWidget {
  final SyncedScrollController controller;
  final Iterable<GanttEvent> events;
  final int columns;

  const GanttLegend({
    super.key,
    required this.controller,
    required this.events,
    required this.columns,
  });

  @override
  State<GanttLegend> createState() => _GanttLegendState();
}

class _GanttLegendState extends State<GanttLegend> {
  late ScrollController _headerScrollController;

  @override
  void initState() {
    super.initState();
    _headerScrollController = ScrollController();
    widget.controller.add(_headerScrollController);
  }

  @override
  void dispose() {
    widget.controller.remove(_headerScrollController);
    _headerScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GanttSettings.of(context).legendTheme.backgroundColor,
      height: GanttSettings.of(context).legendTheme.height,
      child: Row(
        children: [
          SizedBox(
            width: GanttSettings.of(context).legendTheme.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (GanttSettings.of(context).title != null)
                  Text(
                    GanttSettings.of(context).title!,
                    style: GanttSettings.of(context).legendTheme.titleStyle ??
                        Theme.of(context).textTheme.titleLarge,
                  ),
                if (GanttSettings.of(context).subtitle != null)
                  Text(
                    GanttSettings.of(context).subtitle!,
                    style:
                        GanttSettings.of(context).legendTheme.subtitleStyle ??
                            Theme.of(context).textTheme.titleMedium,
                  ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: GanttSettings.of(context).legendTheme.height,
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) =>
                    widget.controller.onScroll(scrollInfo),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (GanttSettings.of(context).legendTheme.showYear)
                      Expanded(
                        child: _DateHorizontalScroll(
                          type: _DateHorizontalScrollType.year,
                          headerScrollController: _headerScrollController,
                          startDate: widget.events.startDate,
                          columns: widget.columns,
                        ),
                      ),
                    if (GanttSettings.of(context).legendTheme.showMonth)
                      Expanded(
                        child: _DateHorizontalScroll(
                          type: _DateHorizontalScrollType.month,
                          headerScrollController: _headerScrollController,
                          startDate: widget.events.startDate,
                          columns: widget.columns,
                        ),
                      ),
                    if (GanttSettings.of(context).legendTheme.showDay)
                      Expanded(
                        child: _DateHorizontalScroll(
                          type: _DateHorizontalScrollType.day,
                          headerScrollController: _headerScrollController,
                          startDate: widget.events.startDate,
                          columns: widget.columns,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateHorizontalScroll extends StatelessWidget {
  final _DateHorizontalScrollType type;
  final ScrollController headerScrollController;
  final DateTime startDate;
  final int columns;

  const _DateHorizontalScroll({
    required this.type,
    required this.headerScrollController,
    required this.startDate,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: headerScrollController,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        var multiplier = switch (GanttSettings.of(context).timelineAxisType) {
          TimelineAxisType.daily => 1,
          TimelineAxisType.weekly => 7,
        };
        var additionalDays = index * multiplier;
        var previousDays = (index - 1) * multiplier;

        var label = switch (type) {
          _DateHorizontalScrollType.year =>
            startDate.add(Duration(days: additionalDays)).year,
          _DateHorizontalScrollType.month =>
            startDate.add(Duration(days: additionalDays)).month,
          _DateHorizontalScrollType.day =>
            startDate.add(Duration(days: additionalDays)).day,
        };

        var previousLabel = switch (type) {
          _DateHorizontalScrollType.year =>
            startDate.add(Duration(days: previousDays)).year,
          _DateHorizontalScrollType.month =>
            startDate.add(Duration(days: previousDays)).month,
          _DateHorizontalScrollType.day =>
            startDate.add(Duration(days: previousDays)).day,
        };

        return SizedBox(
          width: GanttSettings.of(context).legendTheme.dateWidth,
          child: index == 0 || label != previousLabel
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    '$label',
                    style: GanttSettings.of(context).legendTheme.dateStyle,
                  ),
                )
              : null,
        );
      },
      itemCount: columns,
    );
  }
}

enum _DateHorizontalScrollType {
  year,
  month,
  day,
}
