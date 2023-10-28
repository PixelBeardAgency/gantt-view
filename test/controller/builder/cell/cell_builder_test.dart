import 'package:flutter_test/flutter_test.dart';
import 'package:gantt_view/src/controller/builder/cell/cell_builder.dart';
import 'package:gantt_view/src/model/gantt_activity.dart';

import '../../../util/data.dart';

void main() {
  test(
      'Correct number of rows and columns calculated with showFullWeeks set to false',
      () async {
    // Arrange
    final DateTime startDate = DateTime(2021, 1, 1);
    final DateTime endDate = DateTime(2021, 1, 4);

    const int activitiesAmount = 2;
    const int tasksPerActivity = 2;

    const int expectedColumns = 4; // 3 days diff + 1 index offset
    const int expectedRows =
        activitiesAmount + (activitiesAmount * tasksPerActivity);

    List<GanttActivity> activities = TestData.buildActivities(
      activitiesAmount,
      tasksPerActivity: tasksPerActivity,
      startDate: startDate,
      endDate: endDate,
    );

    // Act
    final data = DataBuilder.buildGridCells(
      BuildCellsData(
        activities: activities,
        showFullWeeks: false,
      ),
    );

    // Assert
    expect(data.rows.length, equals(expectedRows));
    expect(data.columnCount, equals(expectedColumns));
  });

  test('Correct number of columns calculated with showFullWeeks set to true',
      () async {
    // Arrange
    final DateTime startDate = DateTime(2023, 10, 18);
    const int activitiesAmount = 2;

    const int expectedColumns = 7;

    List<GanttActivity> activities = TestData.buildActivities(
      activitiesAmount,
      startDate: startDate,
    );

    // Act
    final data = DataBuilder.buildGridCells(
      BuildCellsData(
        activities: activities,
        showFullWeeks: true,
      ),
    );

    // Assert
    expect(data.columnCount, equals(expectedColumns));
  });

  test('start date is correctly calculated with showFullWeeks set to false',
      () {
    // Arrange
    final startDate = DateTime(2021, 1, 1);

    final activities = TestData.buildActivities(
      2,
      startDate: DateTime(2021, 1, 1),
    );

    // Act
    final data = DataBuilder.buildGridCells(BuildCellsData(
      activities: activities,
      showFullWeeks: false,
    ));

    // Assert
    expect(data.startDate, equals(startDate));
  });

  test('start date is correctly calculated with showFullWeeks set to true', () {
    // Arrange
    final startDate = DateTime(2023, 10, 18);
    final expectedStartDate = DateTime(2023, 10, 16);

    final activities = TestData.buildActivities(
      2,
      startDate: startDate,
    );

    // Act
    final data = DataBuilder.buildGridCells(BuildCellsData(
      activities: activities,
      showFullWeeks: true,
    ));

    // Assert
    expect(data.startDate, equals(expectedStartDate));
  });
}
