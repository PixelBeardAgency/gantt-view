import 'package:gantt_view/settings/gantt_settings.dart';

class GridScheme {
  final double rowHeight;
  final double rowSpacing;
  final double columnWidth;

  final bool showYear;
  final bool showMonth;
  final bool showDay;

  final TimelineAxisType timelineAxisType;

  const GridScheme({
    this.rowHeight = 20.0,
    this.rowSpacing = 4.0,
    this.columnWidth = 50.0,
    this.showYear = true,
    this.showMonth = true,
    this.showDay = true,
    this.timelineAxisType = TimelineAxisType.daily,
  });
}
