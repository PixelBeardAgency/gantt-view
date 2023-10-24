import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:gantt_view/src/controller/builder/cell/cell_builder.dart';

import '../../../../test/util/data.dart';

class CellBuilderBenchmark extends BenchmarkBase {
  const CellBuilderBenchmark() : super('CellBuilderBenchmark');

  static void main() {
    const CellBuilderBenchmark().report();
  }

  @override
  void run() {
    CellBuilder.buildGridCells(
        BuildCellsData(activities: activities, showFullWeeks: false));
  }
}

final activities = TestData.buildActivities(
  100000,
  startDate: DateTime(2021, 1, 1),
);
