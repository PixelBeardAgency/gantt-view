import 'package:flutter/material.dart';
import 'package:gantt_view/controller/synced_scroll_controller.dart';
import 'package:gantt_view/model/gantt_header.dart';
import 'package:gantt_view/settings/gantt_settings.dart';

class GanttHeaderRow extends StatefulWidget {
  final GanttHeader title;
  final SyncedScrollController controller;
  final int columns;

  const GanttHeaderRow({
    super.key,
    required this.controller,
    required this.columns,
    required this.title,
  });

  @override
  State<GanttHeaderRow> createState() => _GanttHeaderRowState();
}

class _GanttHeaderRowState extends State<GanttHeaderRow> {
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
    return Container(
      color: GanttSettings.of(context).headerRowTheme.backgroundColor,
      height: GanttSettings.of(context).headerRowTheme.height,
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
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title.label,
                style: GanttSettings.of(context).headerRowTheme.textStyle ??
                    Theme.of(context).textTheme.labelLarge,
              ),
            ),
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
