import 'package:gantt_view/model/gantt_activity.dart';
import 'package:gantt_view/model/gantt_task.dart';

abstract class ActivityBuilder {
  static List<GanttActivity> buildActivities<T>(ActivityBuildData<T> data) {
    List<GanttActivity> activities = [];
    if (data.activityLabelBuilder != null) {
      List<GanttActivity> newActivities = [];
      final activityLabels =
          data.items.map<String>(data.activityLabelBuilder!).toSet();

      for (var label in activityLabels) {
        final tasks = data.items
            .where((item) => data.activityLabelBuilder!(item) == label)
            .map<GanttTask>(data.taskBuilder)
            .toList();
        if (data.taskSort != null) {
          tasks.sort(data.taskSort!);
        }

        newActivities.add(GanttActivity(label: label, tasks: tasks));
      }

      if (data.activitySort != null) {
        newActivities.sort(data.activitySort!);
      }

      activities = newActivities;
    } else {
      final tasks = data.items.map<GanttTask>(data.taskBuilder).toList();

      if (data.taskSort != null) {
        tasks.sort(data.taskSort!);
      }
      activities = [GanttActivity(tasks: tasks)];
    }
    return activities;
  }
}

class ActivityBuildData<T> {
  final List<T> items;
  final GanttTask Function(T data) taskBuilder;
  final int Function(GanttTask a, GanttTask b)? taskSort;

  final String Function(T data)? activityLabelBuilder;
  final int Function(GanttActivity a, GanttActivity b)? activitySort;

  final List<DateTime> highlightedDates;
  final bool showFullWeeks;

  ActivityBuildData({
    required this.items,
    required this.taskBuilder,
    required this.taskSort,
    required this.activityLabelBuilder,
    required this.activitySort,
    required this.highlightedDates,
    required this.showFullWeeks,
  });

  ActivityBuildData<T> copyWith({
    List<T>? items,
    GanttTask Function(T data)? taskBuilder,
    int Function(GanttTask a, GanttTask b)? taskSort,
    String Function(T data)? activityLabelBuilder,
    int Function(GanttActivity a, GanttActivity b)? activitySort,
    List<DateTime>? highlightedDates,
    bool? showFullWeeks,
  }) =>
      ActivityBuildData<T>(
        items: items ?? this.items,
        taskBuilder: taskBuilder ?? this.taskBuilder,
        taskSort: taskSort ?? this.taskSort,
        activityLabelBuilder: activityLabelBuilder ?? this.activityLabelBuilder,
        activitySort: activitySort ?? this.activitySort,
        highlightedDates: highlightedDates ?? this.highlightedDates,
        showFullWeeks: showFullWeeks ?? this.showFullWeeks,
      );
}
