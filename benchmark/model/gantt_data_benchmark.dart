import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:gantt_view/gantt_view.dart';
import 'package:gantt_view/src/model/gantt_data.dart';

import '../../test/util/data.dart';

class GanttDataBuildBenchmark extends BenchmarkBase {
  const GanttDataBuildBenchmark() : super('CellBuilderBenchmark');

  static void main() {
    const GanttDataBuildBenchmark().report();
  }

  @override
  void run() {
    GanttData.build(
        GanttDataInput(activities: activities, showFullWeeks: false));
  }
}

final activities = TestData.buildActivities(
  10000,
  startDate: DateTime(2021, 1, 1),
  endDate: DateTime(2021, 1, 100),
);
