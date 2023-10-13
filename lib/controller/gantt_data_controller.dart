import 'package:flutter/material.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/model/gantt_header.dart';
import 'package:gantt_view/model/gantt_row_data.dart';

class GanttDataController<T> extends ChangeNotifier {
  final List<T> _items = [];

  final GanttEvent Function(T data) _eventBuilder;
  final GanttHeader Function(T data)? _headerBuilder;

  final List<int Function(T a, T b)> _sorters;

  final List<GanttRowData> _data = [];
  List<GanttRowData> get data => List.unmodifiable(_data);

  GanttDataController({
    required List<T> items,
    required GanttEvent Function(T data) eventBuilder,
    GanttHeader Function(T data)? headerBuilder,
    List<int Function(T a, T b)>? sorters,
  })  : _eventBuilder = eventBuilder,
        _headerBuilder = headerBuilder,
        _sorters = sorters ?? [] {
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
    if (_sorters.isNotEmpty) {
      items.sort(
          (a, b) => <Comparator<T>>[..._sorters].map((e) => e(a, b)).firstWhere(
                (comparator) => comparator != 0,
                orElse: () => 0,
              ));
    }

    if (_headerBuilder == null) {
      _data.addAll(items.map<GanttEvent>(_eventBuilder).toList());
    } else {
      String? currentHeader;
      for (final event in items) {
        var header = _headerBuilder!(event);
        if (header.label != currentHeader) {
          currentHeader = header.label;
          _data.add(header);
        }
        _data.add(_eventBuilder(event));
      }
    }
    notifyListeners();
  }
}
