import 'package:flutter/material.dart';
import 'package:gantt_view/extension/gantt_event_list_extension.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/model/gantt_header.dart';
import 'package:gantt_view/model/gantt_row_data.dart';

class GanttDataController<T> extends ChangeNotifier {
  final List<T> _items = [];

  final GanttEvent Function(T data) _eventBuilder;
  final String Function(T data)? _headerLabelBuilder;

  final List<GanttRowData> _data = [];
  List<GanttRowData> get data => List.unmodifiable(_data);

  GanttDataController({
    required List<T> items,
    required GanttEvent Function(T data) eventBuilder,
    String Function(T data)? headerLabelBuilder,
    List<int Function(T a, T b)>? sorters,
  })  : _eventBuilder = eventBuilder,
        _headerLabelBuilder = headerLabelBuilder {
    _items.addAll(items);
    sortItems();
  }

  void setItems(List<T> items) {
    _items.clear();
    _items.addAll(items);
    sortItems();
  }

  void addItems(List<T> items) {
    _items.addAll(items);
    sortItems();
  }

  void removeItem(T item) {
    _items.remove(item);
    sortItems();
  }

  void sortItems() {
    _data.clear();
    List<T> items = List.from(_items);

    if (_headerLabelBuilder != null) {
      Map<String, List<GanttEvent>> groups = {};
      final headers = items.map<String>(_headerLabelBuilder!).toSet();
      for (var header in headers) {
        (groups[header] ??= []).addAll(items
            .where((item) => _headerLabelBuilder!(item) == header)
            .map<GanttEvent>(_eventBuilder)
            .toList()
          ..sort((a, b) => a.startDate.compareTo(b.startDate)));
      }

      var sortedGroups = groups.entries.toList()
        ..sort((a, b) => a.value.startDate.compareTo(b.value.startDate));

      for (var group in sortedGroups) {
        _data.add(GanttHeader(label: group.key));
        _data.addAll(group.value);
      }
    } else {
      _data.addAll(items.map<GanttEvent>(_eventBuilder).toList()
        ..sort((a, b) => a.startDate.compareTo(b.startDate)));
    }

    notifyListeners();
  }
}
