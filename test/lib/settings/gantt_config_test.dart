import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gantt_view/model/gantt_activity.dart';
import 'package:gantt_view/model/gantt_task.dart';
import 'package:gantt_view/model/timeline_axis_type.dart';
import 'package:gantt_view/settings/gantt_config.dart';
import 'package:gantt_view/settings/gantt_grid.dart';
import 'package:gantt_view/settings/gantt_style.dart';

void main() {
  test('start and end dates are correctly calculated', () {
    // Arrange
    final startDate = DateTime(2021, 1, 1);
    final endDate = DateTime(2021, 12, 31);

    final List<GanttTask> activity1tasks = [
      GanttTask(
        label: '1',
        startDate: DateTime(2021, 3, 1),
        endDate: DateTime(2021, 4, 31),
      ),
      GanttTask(
          label: '2', startDate: startDate, endDate: DateTime(2021, 3, 31))
    ];
    final List<GanttTask> activity2tasks = [
      GanttTask(
        label: '1',
        startDate: DateTime(2021, 4, 1),
        endDate: endDate,
      ),
      GanttTask(
          label: '2',
          startDate: DateTime(2021, 4, 1),
          endDate: DateTime(2021, 5, 31))
    ];

    final activities = [
      GanttActivity(label: '1', tasks: activity1tasks),
      GanttActivity(label: '2', tasks: activity2tasks),
    ];

    // Act
    final config = GanttConfig(
      activities: activities,
      containerSize: const Size(100, 100),
      panOffset: Offset.zero,
    );

    // Assert
    expect(config.startDate, equals(startDate));
    expect(config.endDate, equals(endDate));
  });

  test('rowHeight is correctly calculated', () {
    // Arrange
    final activities = [
      GanttActivity(label: '1', tasks: [
        GanttTask(
          label: '1',
          startDate: DateTime(2021, 3, 1),
          endDate: DateTime(2021, 4, 31),
        ),
      ]),
    ];

    const GanttGrid grid = GanttGrid(
      barHeight: 20,
      rowSpacing: 5,
    );
    final style = GanttStyle(labelPadding: const EdgeInsets.all(5));
    const expectedRowHeight = 35.0;

    // Act
    final config = GanttConfig(
      activities: activities,
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      panOffset: Offset.zero,
    );

    // Assert
    expect(config.rowHeight, equals(expectedRowHeight));
  });

  test('dataHeight is correctly calculated', () {
    // Arrange
    final activities = [
      GanttActivity(label: '1', tasks: [
        GanttTask(
          label: '1',
          startDate: DateTime(2021, 3, 1),
          endDate: DateTime(2021, 4, 31),
        ),
      ]),
    ];

    const GanttGrid grid = GanttGrid(
      barHeight: 20,
      rowSpacing: 5,
    );
    final style = GanttStyle(labelPadding: const EdgeInsets.all(5));
    const expectedDataHeight = 70.0;

    // Act
    final config = GanttConfig(
      activities: activities,
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      panOffset: Offset.zero,
    );

    // Assert
    expect(config.dataHeight, equals(expectedDataHeight));
  });

  test('columns is calculated correctly when set to daily', () {
    // Arrange
    final activities = [
      GanttActivity(label: '1', tasks: [
        GanttTask(
          label: '1',
          startDate: DateTime(2021, 3, 1),
          endDate: DateTime(2021, 3, 12),
        ),
      ]),
    ];

    const GanttGrid grid = GanttGrid(timelineAxisType: TimelineAxisType.daily);
    const expectedColumns = 12;

    // Act
    final config = GanttConfig(
      activities: activities,
      containerSize: const Size(100, 100),
      grid: grid,
      panOffset: Offset.zero,
    );

    // Assert
    expect(config.columns, equals(expectedColumns));
  });

  test('columns is calculated correctly when set to weekly', () {
    // Arrange
    final activities = [
      GanttActivity(label: '1', tasks: [
        GanttTask(
          label: '1',
          startDate: DateTime(2021, 3, 1),
          endDate: DateTime(2021, 3, 12),
        ),
      ]),
    ];

    const GanttGrid grid = GanttGrid(timelineAxisType: TimelineAxisType.weekly);
    const expectedColumns = 14;

    // Act
    final config = GanttConfig(
      activities: activities,
      containerSize: const Size(100, 100),
      grid: grid,
      panOffset: Offset.zero,
    );

    // Assert
    expect(config.columns, equals(expectedColumns));
  });

  test('maxDx is calculated correctly when set to daily', () {
    // Arrange
    final startDate = DateTime(2021, 1, 1);
    final activities = [
      GanttActivity(
        label: '1',
        tasks: [
          GanttTask(
            label: '1',
            startDate: startDate,
            endDate: DateTime(
              startDate.year,
              startDate.month,
              startDate.day + 11,
            ),
          ),
        ],
      ),
    ];

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

    const expectedDx = 162;

    // Act
    final config = GanttConfig(
      activities: activities,
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      title: '1',
      subtitle: '1',
      panOffset: Offset.zero,
    );

    // Assert
    expect(config.maxDx, equals(expectedDx));
  });

  test(
      'maxDx is calculated correctly when set to daily and is narrower than container',
      () {
    // Arrange
    final startDate = DateTime(2021, 1, 1);
    final activities = [
      GanttActivity(
        label: '1',
        tasks: [
          GanttTask(
            label: '1',
            startDate: startDate,
            endDate: DateTime(
              startDate.year,
              startDate.month,
              startDate.day + 2,
            ),
          ),
        ],
      ),
    ];

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
      activities: activities,
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      title: '1',
      subtitle: '1',
      panOffset: Offset.zero,
    );

    // Assert
    expect(config.maxDx, equals(expectedDx));
  });

  test('maxDx is calculated correctly when set to weekly', () {
    // Arrange
    final startDate = DateTime(2021, 1, 1);
    final activities = [
      GanttActivity(
        label: '1',
        tasks: [
          GanttTask(
            label: '1',
            startDate: startDate,
            endDate: DateTime(
              startDate.year,
              startDate.month,
              startDate.day + (11 * 7),
            ),
          ),
        ],
      ),
    ];

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

    const expectedDx = 162;

    // Act
    final config = GanttConfig(
      activities: activities,
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      title: '1',
      subtitle: '1',
      panOffset: Offset.zero,
    );

    // Assert
    expect(config.maxDx, equals(expectedDx));
  });

  test(
      'maxDx is calculated correctly when set to weekly and is narrower than container',
      () {
    // Arrange
    final startDate = DateTime(2021, 1, 1);
    final activities = [
      GanttActivity(
        label: '1',
        tasks: [
          GanttTask(
            label: '1',
            startDate: startDate,
            endDate: DateTime(
              startDate.year,
              startDate.month,
              startDate.day + (2 * 7),
            ),
          ),
        ],
      ),
    ];

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
      activities: activities,
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      title: '1',
      subtitle: '1',
      panOffset: Offset.zero,
    );

    // Assert
    expect(config.maxDx, equals(expectedDx));
  });

  test('maxDy is calculated correctly when data is taller than container', () {
    // Arrange
    final startDate = DateTime(2021, 1, 1);
    final activities = [
      GanttActivity(
        label: '1',
        tasks: List.generate(
          12,
          (index) => GanttTask(
            label: '1',
            startDate: startDate,
            endDate: DateTime(
              startDate.year,
              startDate.month,
              startDate.day + 11,
            ),
          ),
        ),
      ),
    ];

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
      activities: activities,
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      title: '1',
      subtitle: '1',
      panOffset: Offset.zero,
    );

    // Assert
    expect(config.maxDy, equals(expectedDy));
  });

  test('maxDy is calculated correctly when data is shorter than container', () {
    // Arrange
    final startDate = DateTime(2021, 1, 1);
    final activities = [
      GanttActivity(
        label: '1',
        tasks: [
          GanttTask(
            label: '1',
            startDate: startDate,
            endDate: DateTime(
              startDate.year,
              startDate.month,
              startDate.day + 11,
            ),
          )
        ],
      ),
    ];

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
      activities: activities,
      containerSize: const Size(100, 200),
      grid: grid,
      style: style,
      title: '1',
      subtitle: '1',
      panOffset: Offset.zero,
    );

    // Assert
    expect(config.maxDy, equals(expectedDy));
  });

  test('uiOffset is calculated correctly', () {
    // Arrange
    final startDate = DateTime(2021, 1, 1);
    final activities = [
      GanttActivity(
        label: '1',
        tasks: [
          GanttTask(
            label: '1',
            startDate: startDate,
            endDate: DateTime(
              startDate.year,
              startDate.month,
              startDate.day + 11,
            ),
          )
        ],
      ),
    ];

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
      activities: activities,
      containerSize: const Size(100, 100),
      grid: grid,
      style: style,
      title: '1',
      subtitle: '1',
      panOffset: Offset.zero,
    );

    // Assert
    expect(config.uiOffset.dx, equals(expectedDx));
    expect(config.uiOffset.dy, equals(expectedDy));
  });
}
