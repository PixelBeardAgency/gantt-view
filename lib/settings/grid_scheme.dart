import 'package:gantt_view/model/timeline_axis_type.dart';

class GridScheme {
  final double barHeight;
  final double rowSpacing;
  final double columnWidth;

  final bool showYear;
  final bool showMonth;
  final bool showDay;

  final TimelineAxisType timelineAxisType;

  const GridScheme({
    this.barHeight = 12.0,
    this.rowSpacing = 0.0,
    this.columnWidth = 30.0,
    this.showYear = true,
    this.showMonth = true,
    this.showDay = true,
    this.timelineAxisType = TimelineAxisType.daily,
  });
}
