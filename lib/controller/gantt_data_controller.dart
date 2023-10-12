import 'package:flutter/material.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/model/gantt_header.dart';
import 'package:gantt_view/model/gantt_row_data.dart';

class GanttDataController<T> extends ChangeNotifier {
  final List<T> _items = [];

  final GanttEvent Function(T data) _eventBuilder;
  final GanttHeader Function(T data)? _headerBuilder;

  final int Function(T a, T b)? _sorter;

  final List<GanttRowData> _data = [];
  List<GanttRowData> get data => List.unmodifiable(_data);

  GanttDataController({
    required List<T> items,
    required GanttEvent Function(T data) eventBuilder,
    GanttHeader Function(T data)? headerBuilder,
    int Function(T a, T b)? sorter,
  })  : _eventBuilder = eventBuilder,
        _headerBuilder = headerBuilder,
        _sorter = sorter {
    _items.addAll(items);
    sortItems();
  }

  void addItems(T item) {
    _items.add(item);
    sortItems();
  }

  void removeItem(T item) {
    _items.remove(item);
    sortItems();
  }

  void sortItems() {
    _data.clear();
    List<T> items = List.from(_items);
    if (_sorter != null) {
      items.sort(_sorter);
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
