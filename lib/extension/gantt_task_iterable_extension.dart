import 'package:gantt_view/model/gantt_task.dart';

extension GanttEventIterableExtension on Iterable<GanttTask> {
  // No difference == 1 day
  int get days => endDate.difference(startDate).inDays + 1;

  int get weeks => (days / 7).ceil();

  DateTime get startDate => reduce((value, element) =>
      value.startDate.isBefore(element.startDate) ? value : element).startDate;

  DateTime get endDate => reduce((value, element) =>
      value.endDate.isAfter(element.endDate) ? value : element).endDate;
}
