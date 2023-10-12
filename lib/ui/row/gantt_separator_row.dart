import 'package:flutter/material.dart';
import 'package:gantt_view/controller/synced_scroll_controller.dart';
import 'package:gantt_view/settings/gantt_settings.dart';

class GanttSeparatorRow extends StatefulWidget {
  final SyncedScrollController controller;
  final int columns;

  const GanttSeparatorRow({
    super.key,
    required this.controller,
    required this.columns,
  });

  @override
  State<GanttSeparatorRow> createState() => _GanttSeparatorRowState();
}

class _GanttSeparatorRowState extends State<GanttSeparatorRow> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController =
        ScrollController(initialScrollOffset: widget.controller.offset);
    widget.controller.add(_scrollController);
  }

  @override
  void dispose() {
    widget.controller.remove(_scrollController);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: GanttSettings.of(context).rowSpacing,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: GanttSettings.of(context).columnBoundaryColor != null
                ? BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: GanttSettings.of(context).columnBoundaryColor!,
                        width: 1,
                      ),
                    ),
                  )
                : null,
            width: GanttSettings.of(context).legendTheme.width,
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) =>
                  widget.controller.onScroll(scrollInfo),
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Container(
                  decoration:
                      GanttSettings.of(context).columnBoundaryColor != null
                          ? BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: GanttSettings.of(context)
                                      .columnBoundaryColor!,
                                  width: 1,
                                ),
                              ),
                            )
                          : null,
                  width: GanttSettings.of(context).legendTheme.dateWidth,
                ),
                itemCount: widget.columns,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
