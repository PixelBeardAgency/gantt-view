abstract class GridCell {}

class ActivityGridCell extends GridCell {}

class TaskGridCell extends GridCell {
  final String? tooltip;
  final bool isHoliday;
  final bool isWeekend;
  final bool isFirst;
  final bool isLast;

  TaskGridCell(
    this.tooltip,
    this.isFirst,
    this.isLast, {
    this.isHoliday = false,
    this.isWeekend = false,
  });
}

class WeekendGridCell extends GridCell {}

class HolidayGridCell extends GridCell {}
