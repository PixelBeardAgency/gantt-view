import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gantt_view/src/model/grid_row.dart';
import 'package:gantt_view/src/model/timeline_axis_type.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';
import 'package:gantt_view/src/settings/gantt_grid.dart';
import 'package:gantt_view/src/settings/gantt_style.dart';

class _TestGridRow extends GridRow {
  _TestGridRow() : super('');
}

void main() {
  test('rowHeight is correctly calculated', () {
    // Arrange
    const GanttGrid grid = GanttGrid(
      barHeight: 20,
      rowSpacing: 5,
    );
    final style = GanttStyle(labelPadding: const EdgeInsets.all(5));
    const expectedRowHeight = 35.0;

    // Act
    final config = GanttConfig(
      rows: List.generate(12, (index) => _TestGridRow()),
      columnCount: 12,
      startDate: DateTime.now(),
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      highlightedColumns: [],
    );

    // Assert
    expect(config.rowHeight, equals(expectedRowHeight));
  });

  test('dataHeight is correctly calculated', () {
    // Arrange
    const GanttGrid grid = GanttGrid(
      barHeight: 20,
      rowSpacing: 5,
    );
    final style = GanttStyle(labelPadding: const EdgeInsets.all(5));
    const expectedDataHeight = 70.0;

    // Act
    final config = GanttConfig(
      rows: List.generate(2, (index) => _TestGridRow()),
      columnCount: 1,
      startDate: DateTime.now(),
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      highlightedColumns: [],
    );

    // Assert
    expect(config.dataHeight, equals(expectedDataHeight));
  });

  test('columns is calculated correctly when set to daily', () {
    // Arrange
    const GanttGrid grid = GanttGrid(timelineAxisType: TimelineAxisType.daily);
    const expectedColumns = 12;

    // Act
    final config = GanttConfig(
      rows: List.generate(12, (index) => _TestGridRow()),
      columnCount: 12,
      startDate: DateTime.now(),
      containerSize: const Size(100, 100),
      grid: grid,
      highlightedColumns: [],
    );

    // Assert
    expect(config.columnCount, equals(expectedColumns));
  });

  test('maxDx is calculated correctly when set to daily', () {
    // Arrange
    const textStyle = TextStyle(fontSize: 12);
    const labelPadding = 5.0;

    const grid = GanttGrid(
      columnWidth: 20,
      timelineAxisType: TimelineAxisType.daily,
    );
    final style = GanttStyle(
      taskLabelStyle: textStyle,
      activityLabelStyle: textStyle,
      titleStyle: textStyle,
      subtitleStyle: textStyle,
      labelPadding: const EdgeInsets.all(labelPadding),
    );

    // 12 * 20  total width of all columns
    // + 20     label width
    // - 100    container width
    const expectedDx = 160;

    // Act
    final config = GanttConfig(
      rows: List.generate(12, (index) => _TestGridRow()),
      columnCount: 12,
      startDate: DateTime.now(),
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      title: '1',
      subtitle: '1',
      highlightedColumns: [],
    );

    // Assert
    expect(config.maxDx, equals(expectedDx));
  });

  test(
      'maxDx is calculated correctly when set to daily and is narrower than container',
      () {
    // Arrange
    final startDate = DateTime(2021, 1, 1);
    const columns = 2;

    const textStyle = TextStyle(fontSize: 12);
    const labelPadding = 5.0;

    const grid = GanttGrid(
      columnWidth: 20,
      timelineAxisType: TimelineAxisType.daily,
    );
    final style = GanttStyle(
      taskLabelStyle: textStyle,
      activityLabelStyle: textStyle,
      titleStyle: textStyle,
      subtitleStyle: textStyle,
      labelPadding: const EdgeInsets.all(labelPadding),
    );

    const expectedDx = 0;

    // Act
    final config = GanttConfig(
      rows: List.generate(12, (index) => _TestGridRow()),
      columnCount: columns,
      startDate: startDate,
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      title: '1',
      subtitle: '1',
      highlightedColumns: [],
    );

    // Assert
    expect(config.maxDx, equals(expectedDx));
  });

  test('maxDx is calculated correctly when set to weekly', () {
    // Arrange
    final startDate = DateTime(2021, 1, 1);
    const columns = 84;

    const textStyle = TextStyle(fontSize: 12);
    const labelPadding = 5.0;

    const grid = GanttGrid(
      columnWidth: 20,
      timelineAxisType: TimelineAxisType.weekly,
    );
    final style = GanttStyle(
      taskLabelStyle: textStyle,
      activityLabelStyle: textStyle,
      titleStyle: textStyle,
      subtitleStyle: textStyle,
      labelPadding: const EdgeInsets.all(labelPadding),
    );

    // 84 * 20  full size width of all columns
    // / 7      divided by the number of days in a week
    // + 20     label width
    // - 100    container width
    const expectedDx = 160;

    // Act
    final config = GanttConfig(
      rows: List.generate(2, (index) => _TestGridRow()),
      columnCount: columns,
      startDate: startDate,
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      title: '1',
      subtitle: '1',
      highlightedColumns: [],
    );

    // Assert
    expect(config.maxDx, equals(expectedDx));
  });

  test(
      'maxDx is calculated correctly when set to weekly and is narrower than container',
      () {
    // Arrange
    const textStyle = TextStyle(fontSize: 12);
    const labelPadding = 5.0;

    const grid = GanttGrid(
      columnWidth: 20,
      timelineAxisType: TimelineAxisType.weekly,
    );
    final style = GanttStyle(
      taskLabelStyle: textStyle,
      activityLabelStyle: textStyle,
      titleStyle: textStyle,
      subtitleStyle: textStyle,
      labelPadding: const EdgeInsets.all(labelPadding),
    );

    const expectedDx = 0;

    // Act
    final config = GanttConfig(
      rows: List.generate(12, (index) => _TestGridRow()),
      columnCount: 12,
      startDate: DateTime.now(),
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      title: '1',
      subtitle: '1',
      highlightedColumns: [],
    );

    // Assert
    expect(config.maxDx, equals(expectedDx));
  });

  test('maxDy is calculated correctly when data is taller than container', () {
    // Arrange

    const textStyle = TextStyle(fontSize: 12);
    const titlePadding = 5.0;

    const grid = GanttGrid(
      timelineAxisType: TimelineAxisType.weekly,
      barHeight: 20,
      rowSpacing: 5,
    );
    final style = GanttStyle(
      taskLabelStyle: textStyle,
      activityLabelStyle: textStyle,
      titleStyle: textStyle,
      subtitleStyle: textStyle,
      timelineStyle: textStyle,
      labelPadding: const EdgeInsets.all(titlePadding),
      titlePadding: const EdgeInsets.all(titlePadding),
    );

    const expectedDy = 396; // (13 * (20 + 5 + 10)) - 100 + 41;

    // Act
    final config = GanttConfig(
      rows: List.generate(13, (index) => _TestGridRow()),
      columnCount: 2,
      startDate: DateTime.now(),
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      title: '1',
      subtitle: '1',
      highlightedColumns: [],
    );

    // Assert
    expect(config.maxDy, equals(expectedDy));
  });

  test('maxDy is calculated correctly when data is shorter than container', () {
    // Arrange
    const textStyle = TextStyle(fontSize: 12);
    const titlePadding = 5.0;

    const grid = GanttGrid(
      timelineAxisType: TimelineAxisType.weekly,
      barHeight: 20,
      rowSpacing: 5,
    );
    final style = GanttStyle(
      taskLabelStyle: textStyle,
      activityLabelStyle: textStyle,
      titleStyle: textStyle,
      subtitleStyle: textStyle,
      timelineStyle: textStyle,
      labelPadding: const EdgeInsets.all(titlePadding),
      titlePadding: const EdgeInsets.all(titlePadding),
    );

    const expectedDy = 0;

    // Act
    final config = GanttConfig(
      rows: List.generate(2, (index) => _TestGridRow()),
      columnCount: 2,
      startDate: DateTime.now(),
      containerSize: const Size(100, 200),
      grid: grid,
      style: style,
      title: '1',
      subtitle: '1',
      highlightedColumns: [],
    );

    // Assert
    expect(config.maxDy, equals(expectedDy));
  });

  test('uiOffset is calculated correctly', () {
    // Arrange
    const textStyle = TextStyle(fontSize: 12);
    const titlePadding = 5.0;

    const grid = GanttGrid(
      timelineAxisType: TimelineAxisType.weekly,
      barHeight: 20,
      rowSpacing: 5,
    );
    final style = GanttStyle(
      taskLabelStyle: textStyle,
      activityLabelStyle: textStyle,
      titleStyle: textStyle,
      subtitleStyle: textStyle,
      timelineStyle: textStyle,
      labelPadding: const EdgeInsets.all(titlePadding),
      titlePadding: const EdgeInsets.all(titlePadding),
    );

    const expectedDx = 22;
    const expectedDy = 41;

    // Act
    final config = GanttConfig(
      rows: List.generate(12, (index) => _TestGridRow()),
      columnCount: 12,
      startDate: DateTime.now(),
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      title: '1',
      subtitle: '1',
      highlightedColumns: [],
    );

    // Assert
    expect(config.uiOffset.dx, equals(expectedDx));
    expect(config.uiOffset.dy, equals(expectedDy));
  });
}
