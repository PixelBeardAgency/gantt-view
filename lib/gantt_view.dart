import 'package:flutter/material.dart';
import 'package:gantt_view/controller/gantt_data_controller.dart';
import 'package:gantt_view/controller/synced_scroll_controller.dart';
import 'package:gantt_view/extension/gantt_event_list_extension.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/settings/gantt_settings.dart';
import 'package:gantt_view/settings/theme/event_row_theme.dart';
import 'package:gantt_view/settings/theme/header_row_theme.dart';
import 'package:gantt_view/settings/theme/legend_theme.dart';
import 'package:gantt_view/ui/gantt_events.dart';
import 'package:gantt_view/ui/gantt_legend.dart';

class GanttView<T> extends StatelessWidget {
  final GanttDataController<T> controller;
  final double? titleColumnWidth;
  final EventRowTheme? eventRowTheme;
  final HeaderRowTheme? headerRowTheme;
  final LegendTheme? legendTheme;
  final double? rowSpacing;
  final String? title;
  final String? subtitle;
  final TimelineAxisType? timelineAxisType;
  final Color? columnBoundaryColor;

  const GanttView({
    super.key,
    required this.controller,
    this.titleColumnWidth,
    this.eventRowTheme,
    this.headerRowTheme,
    this.legendTheme,
    this.rowSpacing,
    this.title,
    this.subtitle,
    this.timelineAxisType,
    this.columnBoundaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return GanttSettings(
      titleColumnWidth: titleColumnWidth,
      eventRowTheme: eventRowTheme,
      headerRowTheme: headerRowTheme,
      legendTheme: legendTheme,
      rowSpacing: rowSpacing,
      title: title,
      subtitle: subtitle,
      timelineAxisType: timelineAxisType,
      columnBoundaryColor: columnBoundaryColor,
      child: _GanttViewContent<T>(eventController: controller),
    );
  }
}

class _GanttViewContent<T> extends StatefulWidget {
  final GanttDataController<T> eventController;

  const _GanttViewContent({required this.eventController});

  @override
  State<_GanttViewContent> createState() => _GanttViewContentState();
}

class _GanttViewContentState extends State<_GanttViewContent> {
  final SyncedScrollController _syncedScrollController =
      SyncedScrollController();

  DateTime get startDate =>
      widget.eventController.data.whereType<GanttEvent>().startDate;

  @override
  void dispose() {
    _syncedScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var columns = widget.eventController.data.isEmpty
        ? 0
        : switch (GanttSettings.of(context).timelineAxisType) {
            TimelineAxisType.daily =>
              widget.eventController.data.whereType<GanttEvent>().days,
            TimelineAxisType.weekly =>
              widget.eventController.data.whereType<GanttEvent>().weeks,
          };
    return Column(
      children: [
        GanttLegend(
            controller: _syncedScrollController,
            events: widget.eventController.data.whereType<GanttEvent>(),
            columns: columns),
        Expanded(
          child: GanttEvents(
            syncedScrollController: _syncedScrollController,
            columns: columns,
            events: widget.eventController.data,
          ),
        ),
      ],
    );
  }
}
