import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:gantt_view/src/controller/builder/activity/activity_builder.dart';
import 'package:gantt_view/src/model/gantt_task.dart';

class ActivityBuilderBenchmark extends BenchmarkBase {
  const ActivityBuilderBenchmark() : super('ActivityBuilderBenchmark');

  static void main() {
    const ActivityBuilderBenchmark().report();
  }

  @override
  void run() {
    ActivityBuilder.buildActivities(
      ActivityBuildData(
        items: _items,
        taskBuilder: (item) => GanttTask(
          label: item.label,
          startDate: item.startDate,
          endDate: item.endDate,
          tooltip: 'Tooltip',
        ),
        taskSort: (a, b) => a.label.compareTo(b.label),
        activityLabelBuilder: (e) => e.activity,
        activitySort: (a, b) =>
            a.tasks.first.startDate.compareTo(b.tasks.first.startDate),
      ),
    );
  }
}

final _items = List<_Item>.generate(
  100000,
  (index) => _Item('$index', DateTime(2023, 1, 1), DateTime(2023, 1, 1 + index),
      '${index % 10}'),
);

class _Item {
  const _Item(this.label, this.startDate, this.endDate, this.activity);

  final String label;
  final DateTime startDate;
  final DateTime endDate;
  final String activity;
}
