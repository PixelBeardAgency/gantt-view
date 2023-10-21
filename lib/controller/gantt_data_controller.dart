import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/model/gantt_activity.dart';
import 'package:gantt_view/model/gantt_task.dart';

class GanttChartController<T> {
  final List<T> _items = [];

  final ValueNotifier<List<GanttActivity>> _activities =
      ValueNotifier<List<GanttActivity>>([]);
  ValueListenable<List<GanttActivity>> get activities => _activities;

  final GanttTask Function(T data) _taskBuilder;
  final int Function(GanttTask a, GanttTask b)? _taskSort;

  final String Function(T data)? _activityLabelBuilder;
  final int Function(GanttActivity a, GanttActivity b)? _activitySort;

  final List<DateTime> _highlightedDates;
  List<DateTime> get highlightedDates => List.unmodifiable(_highlightedDates);

  final ValueNotifier<Offset> _panOffset = ValueNotifier<Offset>(Offset.zero);
  ValueListenable<Offset> get panOffset => _panOffset;

  final ValueNotifier<Offset> _tooltipOffset =
      ValueNotifier<Offset>(Offset.zero);
  ValueListenable<Offset> get tooltipOffset => _tooltipOffset;

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
    List<T> items = List.from(_items);

    if (_activityLabelBuilder != null) {
      List<GanttActivity> newActivities = [];
      final activityLabels = items.map<String>(_activityLabelBuilder!).toSet();
      for (var label in activityLabels) {
        final tasks = items
            .where((item) => _activityLabelBuilder!(item) == label)
            .map<GanttTask>(_taskBuilder)
            .toList();
        if (_taskSort != null) {
          tasks.sort(_taskSort!);
        }

        newActivities.add(GanttActivity(label: label, tasks: tasks));
      }

      if (_activitySort != null) {
        newActivities.sort(_activitySort!);
      }

      _activities.value = newActivities;
    } else {
      final tasks = items.map<GanttTask>(_taskBuilder).toList();

      if (_taskSort != null) {
        tasks.sort(_taskSort!);
      }
      _activities.value = [GanttActivity(tasks: tasks)];
    }
  }

  void setHighlightedDates(List<DateTime> dates) {
    _highlightedDates.clear();
    _highlightedDates.addAll(dates);
  }

  void addHighlightedDates(List<DateTime> dates) =>
      _highlightedDates.addAll(dates);

  void removeHighlightedDate(DateTime date) => _highlightedDates.remove(date);

  void setTooltipOffset(Offset offset) => _tooltipOffset.value = offset;

  void setPanOffset(Offset offset) {
    final diff = (panOffset.value - offset);
    final ttOffset = tooltipOffset.value;
    if (diff.dx != 0) {
      _tooltipOffset.value = Offset(ttOffset.dx - diff.dx, ttOffset.dy);
    }
    if (diff.dy != 0) {
      _tooltipOffset.value = Offset(ttOffset.dx, ttOffset.dy - diff.dy);
    }
    _panOffset.value = offset;
  }
}
