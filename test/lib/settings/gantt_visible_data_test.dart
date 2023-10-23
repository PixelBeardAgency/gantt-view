import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:gantt_view/settings/gantt_visible_data.dart';

void main() {
  test(
      'Number of rows calculated correctly when size is smaller than total row height area calculation',
      () {
    // Arrange
    const rowHeight = 20.0;
    const verticalOffset = 5.0;
    const panOffset = -40.0;
    const size = Size(100, 100);

    const expectedVisibleRows = 6;

    // Act
    final visibleData = GanttVisibleData(
      size,
      10,
      const Offset(verticalOffset, verticalOffset),
      10,
      10,
      const Offset(panOffset, panOffset),
      rowHeight,
    );

    // Assert
    expect(visibleData.visibleRows, equals(expectedVisibleRows));
  });

  test(
      'First visible row calculated correctly when size is smaller than total row height area calculation',
      () {
    // Arrange
    const rowHeight = 20.0;
    const verticalOffset = 5.0;
    const panOffset = -40.0;
    const size = Size(100, 100);

    const expectedFirstVisibleRow = 2;

    // Act
    final visibleData = GanttVisibleData(
      size,
      10,
      const Offset(verticalOffset, verticalOffset),
      10,
      10,
      const Offset(panOffset, panOffset),
      rowHeight,
    );

    // Assert
    expect(visibleData.firstVisibleRow, equals(expectedFirstVisibleRow));
  });
  test(
      'Last visible row calculated correctly when size is smaller than total row height area calculation',
      () {
    // Arrange
    const rowHeight = 20.0;
    const verticalOffset = 5.0;
    const panOffset = -40.0;
    const size = Size(100, 100);

    const expectedLastVisibleRow = 8;

    // Act
    final visibleData = GanttVisibleData(
      size,
      10,
      const Offset(verticalOffset, verticalOffset),
      10,
      10,
      const Offset(panOffset, panOffset),
      rowHeight,
    );

    // Assert
    expect(visibleData.lastVisibleRow, equals(expectedLastVisibleRow));
  });

  test(
      'Number of columns calculated correctly when size is smaller than total row height area calculation',
      () {
    // Arrange
    const columnWidth = 20.0;
    const horizontalOffset = 5.0;
    const panOffset = -40.0;
    const size = Size(100, 100);

    const expectedVisibleColumns = 6;

    // Act
    final visibleData = GanttVisibleData(
      size,
      10,
      const Offset(horizontalOffset, horizontalOffset),
      10,
      columnWidth,
      const Offset(panOffset, panOffset),
      10,
    );

    // Assert
    expect(visibleData.visibleColumns, equals(expectedVisibleColumns));
  });

  test(
      'First visible column calculated correctly when size is smaller than total row height area calculation',
      () {
    // Arrange
    const columnWidth = 20.0;
    const horizontalOffset = 5.0;
    const panOffset = -40.0;
    const size = Size(100, 100);

    const expectedFirstVisibleColumn = 2;

    // Act
    final visibleData = GanttVisibleData(
      size,
      10,
      const Offset(horizontalOffset, horizontalOffset),
      10,
      columnWidth,
      const Offset(panOffset, panOffset),
      10,
    );

    // Assert
    expect(visibleData.firstVisibleColumn, equals(expectedFirstVisibleColumn));
  });
  test(
      'Last visible row calculated correctly when size is smaller than total row height area calculation',
      () {
    // Arrange
    const columnWidth = 20.0;
    const horizontalOffset = 5.0;
    const panOffset = -40.0;
    const size = Size(100, 100);

    const expectedLastVisibleColumn = 8;

    // Act
    final visibleData = GanttVisibleData(
      size,
      10,
      const Offset(horizontalOffset, horizontalOffset),
      10,
      columnWidth,
      const Offset(panOffset, panOffset),
      10,
    );

    // Assert
    expect(visibleData.lastVisibleColumn, equals(expectedLastVisibleColumn));
  });
}
