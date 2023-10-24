import 'package:flutter_test/flutter_test.dart';
import 'package:gantt_view/src/controller/builder/activity/activity_builder.dart';
import 'package:gantt_view/src/model/gantt_task.dart';

void main() {
  test('TaskBuilder correctly creates list of GanttTasks', () {
    // Arrange
    final items = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    final expected = [
      GanttTask(
        label: '1',
        startDate: DateTime(2021, 1, 1),
        endDate: DateTime(2021, 1, 2),
      ),
      GanttTask(
        label: '2',
        startDate: DateTime(2021, 1, 2),
        endDate: DateTime(2021, 1, 3),
      ),
      GanttTask(
        label: '3',
        startDate: DateTime(2021, 1, 3),
        endDate: DateTime(2021, 1, 4),
      ),
      GanttTask(
        label: '4',
        startDate: DateTime(2021, 1, 4),
        endDate: DateTime(2021, 1, 5),
      ),
      GanttTask(
        label: '5',
        startDate: DateTime(2021, 1, 5),
        endDate: DateTime(2021, 1, 6),
      ),
      GanttTask(
        label: '6',
        startDate: DateTime(2021, 1, 6),
        endDate: DateTime(2021, 1, 7),
      ),
      GanttTask(
        label: '7',
        startDate: DateTime(2021, 1, 7),
        endDate: DateTime(2021, 1, 8),
      ),
      GanttTask(
        label: '8',
        startDate: DateTime(2021, 1, 8),
        endDate: DateTime(2021, 1, 9),
      ),
      GanttTask(
        label: '9',
        startDate: DateTime(2021, 1, 9),
        endDate: DateTime(2021, 1, 10),
      ),
    ];

    // Act
    final activities = ActivityBuilder.buildActivities(
      ActivityBuildData(
        items: items,
        taskBuilder: (item) => GanttTask(
          label: '$item',
          startDate: DateTime(2021, 1, item),
          endDate: DateTime(2021, 1, item + 1),
        ),
      ),
    );

    // Assert
    expect(activities.length, equals(1));
    expect(activities.first.tasks.length, equals(expected.length));
    for (int i = 0; i < expected.length; i++) {
      final actualTask = activities.first.tasks[i];
      expect(actualTask.label, equals(expected[i].label));
      expect(actualTask.startDate, equals(expected[i].startDate));
      expect(actualTask.endDate, equals(expected[i].endDate));
    }
  });

  test('TaskSort correctly sorts list of GanttTasks', () {
    // Arrange
    final items = [1, 2, 3, 4];
    final expected = [
      GanttTask(
        label: '1',
        startDate: DateTime(2021, 1, 1),
        endDate: DateTime(2021, 1, 2),
      ),
      GanttTask(
        label: '2',
        startDate: DateTime(2021, 1, 2),
        endDate: DateTime(2021, 1, 3),
      ),
      GanttTask(
        label: '3',
        startDate: DateTime(2021, 1, 3),
        endDate: DateTime(2021, 1, 4),
      ),
      GanttTask(
        label: '4',
        startDate: DateTime(2021, 1, 4),
        endDate: DateTime(2021, 1, 5),
      ),
    ];

    // Act
    final activities = ActivityBuilder.buildActivities(
      ActivityBuildData(
        items: items,
        taskBuilder: (item) => GanttTask(
          label: '$item',
          startDate: DateTime(2021, 1, item),
          endDate: DateTime(2021, 1, item + 1),
        ),
        taskSort: (a, b) => b.startDate.compareTo(a.startDate),
      ),
    );

    // Assert
    expect(activities.length, equals(1));
    expect(activities.first.tasks.length, equals(expected.length));
    for (int i = 0; i < expected.length; i++) {
      final actualTask = activities.first.tasks[expected.length - i - 1];
      expect(actualTask.label, equals(expected[i].label));
      expect(actualTask.startDate, equals(expected[i].startDate));
      expect(actualTask.endDate, equals(expected[i].endDate));
    }
  });

  test('activityLabelBuilder correctly groups tasks', () {
    // Arrange
    final items = [1, 2, 3, 4];
    final expectedOdd = [
      GanttTask(
        label: '1',
        startDate: DateTime(2021, 1, 1),
        endDate: DateTime(2021, 1, 2),
      ),
      GanttTask(
        label: '3',
        startDate: DateTime(2021, 1, 3),
        endDate: DateTime(2021, 1, 4),
      ),
    ];
    final expectedEven = [
      GanttTask(
        label: '2',
        startDate: DateTime(2021, 1, 2),
        endDate: DateTime(2021, 1, 3),
      ),
      GanttTask(
        label: '4',
        startDate: DateTime(2021, 1, 4),
        endDate: DateTime(2021, 1, 5),
      ),
    ];

    // Act
    final activities = ActivityBuilder.buildActivities(
      ActivityBuildData(
        items: items,
        taskBuilder: (item) => GanttTask(
          label: '$item',
          startDate: DateTime(2021, 1, item),
          endDate: DateTime(2021, 1, item + 1),
        ),
        activityLabelBuilder: (item) => item.isEven ? 'even' : 'odd',
      ),
    );

    // Assert
    expect(activities.length, equals(2));

    final actualActivityOdd = activities[0];
    expect(actualActivityOdd.label, equals('odd'));
    expect(actualActivityOdd.tasks.length, equals(expectedOdd.length));
    for (int i = 0; i < expectedOdd.length; i++) {
      final expectedTask = expectedOdd[i];
      final actualTask = activities.first.tasks[i];
      expect(actualTask.label, equals(expectedTask.label));
      expect(actualTask.startDate, equals(expectedTask.startDate));
      expect(actualTask.endDate, equals(expectedTask.endDate));
    }

    final actualActivityEven = activities[1];
    expect(actualActivityEven.label, equals('even'));
    expect(actualActivityEven.tasks.length, equals(expectedEven.length));
    for (int i = 0; i < expectedEven.length; i++) {
      final expectedTask = expectedEven[i];
      final actualTask = actualActivityEven.tasks[i];
      expect(actualTask.label, equals(expectedTask.label));
      expect(actualTask.startDate, equals(expectedTask.startDate));
      expect(actualTask.endDate, equals(expectedTask.endDate));
    }
  });

  test('taskSort correctly sorts grouped tasks', () {
    // Arrange
    final items = [1, 2, 3, 4];
    final expectedOdd = [
      GanttTask(
        label: '1',
        startDate: DateTime(2021, 1, 1),
        endDate: DateTime(2021, 1, 2),
      ),
      GanttTask(
        label: '3',
        startDate: DateTime(2021, 1, 3),
        endDate: DateTime(2021, 1, 4),
      ),
    ];
    final expectedEven = [
      GanttTask(
        label: '2',
        startDate: DateTime(2021, 1, 2),
        endDate: DateTime(2021, 1, 3),
      ),
      GanttTask(
        label: '4',
        startDate: DateTime(2021, 1, 4),
        endDate: DateTime(2021, 1, 5),
      ),
    ];

    // Act
    final activities = ActivityBuilder.buildActivities(
      ActivityBuildData(
        items: items,
        taskBuilder: (item) => GanttTask(
          label: '$item',
          startDate: DateTime(2021, 1, item),
          endDate: DateTime(2021, 1, item + 1),
        ),
        taskSort: (a, b) => b.startDate.compareTo(a.startDate),
        activityLabelBuilder: (item) => item.isEven ? 'even' : 'odd',
      ),
    );

    // Assert
    expect(activities.length, equals(2));

    final actualActivityOdd = activities[0];
    expect(actualActivityOdd.label, equals('odd'));
    expect(actualActivityOdd.tasks.length, equals(expectedOdd.length));
    for (int i = 0; i < expectedOdd.length; i++) {
      final expectedTask = expectedOdd[expectedOdd.length - i - 1];
      final actualTask = activities.first.tasks[i];
      expect(actualTask.label, equals(expectedTask.label));
      expect(actualTask.startDate, equals(expectedTask.startDate));
      expect(actualTask.endDate, equals(expectedTask.endDate));
    }

    final actualActivityEven = activities[1];
    expect(actualActivityEven.label, equals('even'));
    expect(actualActivityEven.tasks.length, equals(expectedEven.length));
    for (int i = 0; i < expectedEven.length; i++) {
      final expectedTask = expectedEven[expectedEven.length - i - 1];
      final actualTask = actualActivityEven.tasks[i];
      expect(actualTask.label, equals(expectedTask.label));
      expect(actualTask.startDate, equals(expectedTask.startDate));
      expect(actualTask.endDate, equals(expectedTask.endDate));
    }
  });

  test('activitySort correctly sorts grouped tasks', () {
    // Arrange
    final items = [1, 2, 3, 4];

    // Act
    final activities = ActivityBuilder.buildActivities(
      ActivityBuildData(
        items: items,
        taskBuilder: (item) => GanttTask(
          label: '$item',
          startDate: DateTime(2021, 1, item),
          endDate: DateTime(2021, 1, item + 1),
        ),
        taskSort: (a, b) => b.startDate.compareTo(a.startDate),
        activityLabelBuilder: (item) => item.isEven ? 'even' : 'odd',
        activitySort: (a, b) => a.label!.compareTo(b.label!),
      ),
    );

    // Assert
    expect(activities.length, equals(2));
    expect(activities[0].label, equals('even'));
    expect(activities[1].label, equals('odd'));
  });
}
