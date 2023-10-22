import 'package:gantt_view/model/timeline_axis_type.dart';

class GanttGrid {
  final double barHeight;
  final double rowSpacing;
  final double columnWidth;
  final double tooltipWidth;

  final bool showYear;
  final bool showMonth;
  final bool showDay;

  final TimelineAxisType timelineAxisType;
  final TooltipType tooltipType;

  final bool showFullWeeks;

  const GanttGrid({
    this.barHeight = 12.0,
    this.rowSpacing = 0.0,
    this.columnWidth = 30.0,
    this.tooltipWidth = 200,
    this.showYear = true,
    this.showMonth = true,
    this.showDay = true,
    this.timelineAxisType = TimelineAxisType.daily,
    this.tooltipType = TooltipType.none,
    bool? showFullWeeks,
  }) : showFullWeeks =
            showFullWeeks ?? timelineAxisType == TimelineAxisType.weekly;
}

enum TooltipType {
  none,
  hover,
  tap,
}
