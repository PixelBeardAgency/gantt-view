import 'package:flutter_test/flutter_test.dart';
import 'package:gantt_view/controller/gantt_data_controller.dart';
import 'package:gantt_view/model/gantt_task.dart';

void main() {
  test('tooltipOffset updates correctly', () async {
    // Arrange
    const Offset panOffset = Offset(10, 10);
    const Offset tooltipOffset = Offset(20, 20);

    const Offset updatedPanOffset = Offset(30, 30);
    const Offset expectedTooltipOffset = Offset(40, 40);

    final controller = GanttChartController<int>(
      items: [1],
      taskBuilder: (item) => GanttTask(
        label: '$item',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 1)),
      ),
    );

    // Act
    controller.setPanOffset(panOffset);
    controller.setTooltipOffset(tooltipOffset);
    controller.setPanOffset(updatedPanOffset);

    // Assert
    expect(controller.tooltipOffset.value, equals(expectedTooltipOffset));
  });
}
