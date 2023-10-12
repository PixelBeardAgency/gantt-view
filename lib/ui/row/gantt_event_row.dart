import 'package:flutter/material.dart';
import 'package:gantt_view/controller/synced_scroll_controller.dart';
import 'package:gantt_view/settings/gantt_settings.dart';

class GanttEventRow extends StatefulWidget {
  final String title;
  final SyncedScrollController controller;
  final int start;
  final int end;
  final int columns;

  const GanttEventRow({
    super.key,
    required this.controller,
    required this.columns,
    required this.start,
    required this.end,
    required this.title,
  });

  @override
  State<GanttEventRow> createState() => _GanttEventRowState();
}

class _GanttEventRowState extends State<GanttEventRow> {
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
    int divisor = switch (GanttSettings.of(context).timelineAxisType) {
      TimelineAxisType.daily => 1,
      TimelineAxisType.weekly => 7,
    };

    return SizedBox(
      height: GanttSettings.of(context).eventRowTheme.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: GanttSettings.of(context).legendTheme.width,
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
            child: Text(
              widget.title,
              style: GanttSettings.of(context).eventRowTheme.labelStyle ??
                  Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Expanded(
            child: SizedBox(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) =>
                    widget.controller.onScroll(scrollInfo),
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Container(
                    width: GanttSettings.of(context).legendTheme.dateWidth /
                        divisor,
                    decoration:
                        GanttSettings.of(context).columnBoundaryColor != null &&
                                index % divisor == divisor - 1
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
                    child: index >= widget.start && index <= widget.end
                        ? _GanttItemFill(
                            index == widget.start,
                            index == widget.end,
                          )
                        : const SizedBox.shrink(),
                  ),
                  itemCount: widget.columns * divisor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GanttItemFill extends StatelessWidget {
  final bool isStart;
  final bool isEnd;

  const _GanttItemFill(this.isStart, this.isEnd);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'asjkdsa',
      child: Container(
        decoration: BoxDecoration(
          color: GanttSettings.of(context).eventRowTheme.fillColor,
          border: Border.all(
              color: GanttSettings.of(context).eventRowTheme.fillColor),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isStart
                ? GanttSettings.of(context).eventRowTheme.startRadius
                : 0),
            bottomLeft: Radius.circular(isStart
                ? GanttSettings.of(context).eventRowTheme.startRadius
                : 0),
            topRight: Radius.circular(
                isEnd ? GanttSettings.of(context).eventRowTheme.endRadius : 0),
            bottomRight: Radius.circular(
                isEnd ? GanttSettings.of(context).eventRowTheme.endRadius : 0),
          ),
        ),
      ),
    );
  }
}
