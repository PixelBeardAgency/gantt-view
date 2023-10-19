import 'package:flutter/material.dart';
import 'package:gantt_view/model/gantt_activity.dart';
import 'package:gantt_view/model/gantt_task.dart';

class GanttChartController<T> extends ChangeNotifier {
  final List<T> _items = [];

  final List<GanttActivity> _activities = [];
  List<GanttActivity> get activities => List.unmodifiable(_activities);

  final GanttTask Function(T data) _taskBuilder;
  final int Function(GanttTask a, GanttTask b)? _taskSort;

  final String Function(T data)? _activityLabelBuilder;
  final int Function(GanttActivity a, GanttActivity b)? _activitySort;

  final List<DateTime> _highlightedDates;
  List<DateTime> get highlightedDates => List.unmodifiable(_highlightedDates);

  Offset _panOffset = Offset.zero;
  Offset get panOffset => _panOffset;

  GanttChartController({
    required List<T> items,
    required GanttTask Function(T data) taskBuilder,
    int Function(GanttTask a, GanttTask b)? taskSort,
    String Function(T item)? activityLabelBuilder,
    int Function(GanttActivity a, GanttActivity b)? activitySort,
    List<DateTime> highlightedDates = const [],
  })  : _taskBuilder = taskBuilder,
        _taskSort = taskSort,
        _activityLabelBuilder = activityLabelBuilder,
        _activitySort = activitySort,
        _highlightedDates = highlightedDates {
    _items.addAll(items);
    _sortItems();
  }

  void setItems(List<T> items) {
    _items.clear();
    _items.addAll(items);
    _sortItems();
  }

  void addItems(List<T> items) {
    _items.addAll(items);
    _sortItems();
  }

  void removeItem(T item) {
    _items.remove(item);
    _sortItems();
  }

  void _sortItems() {
    _activities.clear();
    List<T> items = List.from(_items);

    if (_activityLabelBuilder != null) {
      List<GanttActivity> activities = [];
      final activityLabels = items.map<String>(_activityLabelBuilder!).toSet();
      for (var label in activityLabels) {
        final tasks = items
            .where((item) => _activityLabelBuilder!(item) == label)
            .map<GanttTask>(_taskBuilder)
            .toList();
        if (_taskSort != null) {
          tasks.sort(_taskSort!);
        }

        activities.add(GanttActivity(label: label, tasks: tasks));
      }

      if (_activitySort != null) {
        activities.sort(_activitySort!);
      }

      _activities.addAll(activities);
    } else {
      final tasks = items.map<GanttTask>(_taskBuilder).toList();

      if (_taskSort != null) {
        tasks.sort(_taskSort!);
      }
      _activities.add(GanttActivity(tasks: tasks));
    }

    notifyListeners();
  }

  void setHighlightedDates(List<DateTime> dates) {
    _highlightedDates.clear();
    _highlightedDates.addAll(dates);
    notifyListeners();
  }

  void addHighlightedDates(List<DateTime> dates) {
    _highlightedDates.addAll(dates);
    notifyListeners();
  }

  void removeHighlightedDate(DateTime date) {
    _highlightedDates.remove(date);
    notifyListeners();
  }

  void setPanOffset(Offset offset) {
    _panOffset = offset;
    notifyListeners();
  }
}
