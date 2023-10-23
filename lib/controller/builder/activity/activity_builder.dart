import 'package:gantt_view/model/gantt_activity.dart';
import 'package:gantt_view/model/gantt_task.dart';

abstract class ActivityBuilder {
  static List<GanttActivity> buildActivities<T>(ActivityBuildData<T> data) {
    List<GanttActivity> activities = [];
    if (data.activityLabelBuilder != null) {
      Map<String, List<GanttTask>> labelTasks = {};

      for (var item in data.items) {
        final label = data.activityLabelBuilder!(item);
        (labelTasks[label] ??= []).add(data.taskBuilder(item));
      }

      activities = labelTasks.entries.map((e) {
        final tasks = e.value;
        if (data.taskSort != null) {
          tasks.sort(data.taskSort);
        }
        return GanttActivity(label: e.key, tasks: tasks);
      }).toList();
      if (data.activitySort != null) {
        activities.sort(data.activitySort);
      }
    } else {
      final tasks = data.items.map<GanttTask>(data.taskBuilder).toList();

      if (data.taskSort != null) {
        tasks.sort(data.taskSort);
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
    this.taskSort,
    this.activityLabelBuilder,
    this.activitySort,
    this.highlightedDates = const [],
    this.showFullWeeks = false,
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
