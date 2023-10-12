import 'package:gantt_view/model/gantt_row_data.dart';

class GanttEvent extends GanttRowData {
  final String group;
  final DateTime startDate;
  final DateTime endDate;

  GanttEvent({
    required super.label,
    this.group = '',
    required this.startDate,
    required this.endDate,
  });
}
