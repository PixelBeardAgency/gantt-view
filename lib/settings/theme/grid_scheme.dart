import 'package:gantt_view/settings/gantt_settings.dart';

class GridScheme {
  final double barHeight;
  final double rowSpacing;
  final double columnWidth;

  final bool showYear;
  final bool showMonth;
  final bool showDay;

  final bool highlightWeekends;
  final bool blockWeekends;

  final TimelineAxisType timelineAxisType;

  const GridScheme({
    this.barHeight = 12.0,
    this.rowSpacing = 0.0,
    this.columnWidth = 50.0,
    this.showYear = true,
    this.showMonth = true,
    this.showDay = true,
    this.timelineAxisType = TimelineAxisType.daily,
    this.highlightWeekends = false,
    this.blockWeekends = false,
  });
}
