import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/controller/builder/activity/activity_builder.dart';
import 'package:gantt_view/controller/builder/cell/cell_builder.dart';
import 'package:gantt_view/model/gantt_activity.dart';
import 'package:gantt_view/model/gantt_data.dart';
import 'package:gantt_view/model/gantt_task.dart';

class GanttChartController<T> {
  late ActivityBuildData<T> _activityBuildData;

  final ValueNotifier<Offset> _panOffset = ValueNotifier<Offset>(Offset.zero);
  ValueListenable<Offset> get panOffset => _panOffset;

  final ValueNotifier<Offset> _tooltipOffset =
      ValueNotifier<Offset>(Offset.zero);
  ValueListenable<Offset> get tooltipOffset => _tooltipOffset;

  final ValueNotifier<GanttData?> _data = ValueNotifier<GanttData?>(null);
  ValueListenable<GanttData?> get data => _data;

  final ValueNotifier<bool> _isBuilding = ValueNotifier<bool>(false);
  ValueListenable<bool> get isBuilding => _isBuilding;

  GanttChartController({
    required List<T> items,
    required GanttTask Function(T item) taskBuilder,
    int Function(GanttTask a, GanttTask b)? taskSort,
    String Function(T item)? activityLabelBuilder,
    int Function(GanttActivity a, GanttActivity b)? activitySort,
    List<DateTime> highlightedDates = const [],
    bool showFullWeeks = false,
  }) : _activityBuildData = ActivityBuildData<T>(
            items: items,
            taskBuilder: taskBuilder,
            taskSort: taskSort,
            activityLabelBuilder: activityLabelBuilder,
            activitySort: activitySort,
            highlightedDates: highlightedDates,
            showFullWeeks: showFullWeeks) {
    _sortActivitiesAndBuildCells();
  }

  void setItems(List<T> items) {
    _activityBuildData = _activityBuildData.copyWith(items: items);
    _sortActivitiesAndBuildCells();
  }

  void addItems(List<T> items) {
    _activityBuildData = _activityBuildData
        .copyWith(items: [..._activityBuildData.items, ...items]);
    _sortActivitiesAndBuildCells();
  }

  void removeItem(T item) {
    _activityBuildData = _activityBuildData.copyWith(
        items: _activityBuildData.items..remove(item));
    _sortActivitiesAndBuildCells();
  }

  void setHighlightedDates(List<DateTime> dates) {
    _activityBuildData = _activityBuildData.copyWith(highlightedDates: dates);
    _buildGanttData(BuildCellsData(
      activities: data.value!.activities,
      highlightedDates: _activityBuildData.highlightedDates,
      showFullWeeks: _activityBuildData.showFullWeeks,
    ));
  }

  void addHighlightedDates(List<DateTime> dates) {
    _activityBuildData = _activityBuildData.copyWith(
        highlightedDates: [..._activityBuildData.highlightedDates, ...dates]);
    _buildGanttData(BuildCellsData(
      activities: data.value!.activities,
      highlightedDates: _activityBuildData.highlightedDates,
      showFullWeeks: _activityBuildData.showFullWeeks,
    ));
  }

  void removeHighlightedDate(DateTime date) {
    _activityBuildData = _activityBuildData.copyWith(
        highlightedDates: _activityBuildData.highlightedDates..remove(date));
    _buildGanttData(BuildCellsData(
      activities: data.value!.activities,
      highlightedDates: _activityBuildData.highlightedDates,
      showFullWeeks: _activityBuildData.showFullWeeks,
    ));
  }

  void setTooltipOffset(Offset offset) => _tooltipOffset.value = offset;

  void setPanOffset(Offset offset) {
    final diff = (panOffset.value - offset);
    _panOffset.value = offset;
    _tooltipOffset.value -= diff;
  }

  void setShowFullWeeks(bool showFullWeeks) {
    _activityBuildData =
        _activityBuildData.copyWith(showFullWeeks: showFullWeeks);
    _buildGanttData(BuildCellsData(
      activities: data.value!.activities,
      highlightedDates: _activityBuildData.highlightedDates,
      showFullWeeks: _activityBuildData.showFullWeeks,
    ));
  }

  void _setGanttData(GanttData data) => _data.value = data;

  Future<void> _sortActivitiesAndBuildCells() async {
    _isBuilding.value = true;
    final activities =
        await compute(ActivityBuilder.buildActivities<T>, _activityBuildData);

    await _buildGanttData(
      BuildCellsData(
        activities: activities,
        highlightedDates: _activityBuildData.highlightedDates,
        showFullWeeks: _activityBuildData.showFullWeeks,
      ),
    );
  }

  Future<void> _buildGanttData(BuildCellsData data) async {
    _isBuilding.value = true;
    return compute(CellBuilder.buildGridCells, data).then((data) {
      _setGanttData(data);
      _isBuilding.value = false;
    });
  }
}
