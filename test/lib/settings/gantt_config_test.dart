import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gantt_view/src/model/grid_row.dart';
import 'package:gantt_view/src/model/timeline_axis_type.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';
import 'package:gantt_view/src/settings/gantt_grid.dart';

class _TestGridRow extends GridRow {
  _TestGridRow() : super('');
}

void main() {
  test('columns is calculated correctly when set to daily', () {
    // Arrange
    const GanttGrid grid = GanttGrid(timelineAxisType: TimelineAxisType.daily);
    const expectedColumns = 12;

    // Act
    final config = GanttConfig(
      rows: List.generate(12, (index) => (_TestGridRow(), const Size(0, 0))),
      columnCount: 12,
      startDate: DateTime.now(),
      containerSize: const Size(100, 100),
      grid: grid,
      highlightedColumns: [],
    );

    // Assert
    expect(config.columnCount, equals(expectedColumns));
  });
}
