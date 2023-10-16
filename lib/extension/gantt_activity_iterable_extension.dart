import 'package:gantt_view/model/gantt_activity.dart';
import 'package:gantt_view/model/gantt_task.dart';

extension GanttActivityIterableExtension on Iterable<GanttActivity> {
  Iterable<GanttTask> get allTasks => expand((a) => a.tasks);
}
