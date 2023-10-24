import 'package:gantt_view/src/model/gantt_activity.dart';
import 'package:gantt_view/src/model/gantt_task.dart';

abstract class TestData {
  static List<GanttActivity> buildActivities(int amount,
          {DateTime? startDate, DateTime? endDate, int tasksPerActivity = 1}) =>
      List.generate(
        amount,
        (index) => GanttActivity(
          label: index.toString(),
          tasks: buildTasks(
            tasksPerActivity,
            startDate: startDate,
            endDate: endDate,
          ),
        ),
      );

  static List<GanttTask> buildTasks(
    int amount, {
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      List.generate(
        amount,
        (index) => GanttTask(
          label: index.toString(),
          startDate: startDate ?? DateTime(2021, 1, 1),
          endDate: endDate ??
              (startDate ?? DateTime(2021, 1, 1)).add(const Duration(days: 1)),
        ),
      );
}
