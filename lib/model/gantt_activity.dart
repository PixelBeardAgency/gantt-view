import 'package:gantt_view/model/gantt_task.dart';

class GanttActivity {
  final String? label;
  final List<GanttTask> tasks;

  GanttActivity({this.label, required this.tasks});
}
