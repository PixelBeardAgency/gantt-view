import 'package:flutter_test/flutter_test.dart';
import 'package:gantt_view/gantt_view.dart';

void main() {
  test('Empty item list still sets loading state to false correctly', () async {
    // Act
    final GanttChartController controller = GanttChartController(
      items: [],
      taskBuilder: (item) => GanttTask(
        label: 'label',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      ),
    );

    // Assert
    assert(controller.isBuilding.value, isFalse);
  });
}
