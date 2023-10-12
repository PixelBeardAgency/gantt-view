import 'package:flutter/material.dart';
import 'package:gantt_view/controller/synced_scroll_controller.dart';
import 'package:gantt_view/extension/gantt_event_list_extension.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/model/gantt_header.dart';
import 'package:gantt_view/model/gantt_row_data.dart';
import 'package:gantt_view/ui/row/gantt_event_row.dart';
import 'package:gantt_view/ui/row/gantt_header_row.dart';
import 'package:gantt_view/ui/row/gantt_separator_row.dart';

class GanttEvents extends StatelessWidget {
  final List<GanttRowData> events;
  final SyncedScrollController _syncedScrollController;
  final int columns;

  DateTime get eventsStartDate => events.whereType<GanttEvent>().startDate;
  DateTime get eventsEndDate => events.whereType<GanttEvent>().endDate;

  const GanttEvents({
    super.key,
    required SyncedScrollController syncedScrollController,
    required this.columns,
    required this.events,
  }) : _syncedScrollController = syncedScrollController;

  @override
  Widget build(BuildContext context) {
    return events.isEmpty
        ? const SizedBox.shrink()
        : ListView.separated(
            itemBuilder: (context, index) {
              final event = events[index];
              return event is GanttEvent
                  ? GanttEventRow(
                      title: event.label,
                      start: event.startDate.difference(eventsStartDate).inDays,
                      end: event.endDate.difference(eventsStartDate).inDays,
                      controller: _syncedScrollController,
                      columns: columns,
                    )
                  : event is GanttHeader
                      ? GanttHeaderRow(
                          controller: _syncedScrollController,
                          columns: columns,
                          title: event,
                        )
                      : const SizedBox.shrink();
            },
            itemCount: events.length,
            separatorBuilder: (context, index) => GanttSeparatorRow(
              controller: _syncedScrollController,
              columns: columns,
            ),
          );
  }
}
