abstract class GridCell {}

class ActivityGridCell extends GridCell {}

class TaskGridCell extends GridCell {
  final String? tooltip;
  final bool isHighlighted;
  final bool isWeekend;
  final bool isFirst;
  final bool isLast;

  TaskGridCell(
    this.tooltip,
    this.isFirst,
    this.isLast, {
    this.isHighlighted = false,
    this.isWeekend = false,
  });
}

class WeekendGridCell extends GridCell {}

class HolidayGridCell extends GridCell {}
