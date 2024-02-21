import 'package:flutter/material.dart';
import 'package:gantt_view/src/model/gantt_activity.dart';
import 'package:gantt_view/src/model/gantt_task.dart';
import 'package:gantt_view/src/model/grid_row.dart';

class GanttChartController<T> extends ChangeNotifier {
  Offset _panOffset = Offset.zero;
  Offset get panOffset => _panOffset;

  Offset _tooltipOffset = Offset.zero;
  Offset get tooltipOffset => _tooltipOffset;

  final List<T> _items = [];
  final List<GanttActivity> _activities = [];
  List<GanttActivity> get activities => _activities;

  final List<DateTime> _highlightedDates = [];
  List<int> get highlightedDates =>
      _highlightedDates.map((d) => d.difference(startDate).inDays).toList();

  List<GanttActivity> Function(List<T> item) itemBuilder;
  List<GridRow> get rows => activities
      .map((a) {
        if (a.tasks.isNotEmpty) {
          List<GridRow> rows = [];
          rows.add(ActivityGridRow(a.label ?? ''));
          rows.addAll(a.tasks.map(
            (t) => TaskGridRow(
              GanttTask(
                label: t.label,
                startDate: t.startDate,
                endDate: t.endDate,
                tooltip: t.tooltip,
              ),
            ),
          ));
          return rows;
        }
        return null;
      })
      .where((element) => element != null)
      .expand((element) => element!)
      .toList();

  GanttChartController({
    required List<T> items,
    required this.itemBuilder,
    List<DateTime> highlightedDates = const [],
    bool showFullWeeks = false,
  }) {
    setItems(items);
  }

  List<GanttTask> get tasks =>
      activities.map((a) => a.tasks).expand((t) => t).toList();

  DateTime get startDate => tasks.map((t) => t.startDate).fold(
      tasks.first.startDate,
      (previousValue, newValue) =>
          previousValue.isBefore(newValue) ? previousValue : newValue);

  DateTime get endDate => tasks.map((t) => t.endDate).fold(
      tasks.first.endDate,
      (previousValue, newValue) =>
          previousValue.isAfter(newValue) ? previousValue : newValue);

  int get columnCount => endDate.difference(startDate).inDays + 1;

  void setItems(List<T> items) {
    _items.clear();
    _activities.clear();

    _items.addAll(items);
    _activities.addAll(itemBuilder(items));

    notifyListeners();
  }

  void addItems(List<T> items) => setItems([..._items, ...items]);

  void removeItem(T item) => setItems(_items..remove(item));

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

  void setTooltipOffset(Offset offset) {
    _tooltipOffset = offset;
    notifyListeners();
  }

  void setPanOffset(Offset offset) {
    final diff = (panOffset - offset);
    _panOffset = offset;
    _tooltipOffset -= diff;
    notifyListeners();
  }

  void setPanY(double offset) {
    _panOffset = Offset(panOffset.dx, -offset);
    notifyListeners();
  }

  void setPanX(double offset) {
    _panOffset = Offset(-offset, panOffset.dy);
    notifyListeners();
  }

  void setShowFullWeeks(bool showFullWeeks) {}
}
