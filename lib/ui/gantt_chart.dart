import 'package:flutter/material.dart';
import 'package:gantt_view/model/gantt_row_data.dart';
import 'package:gantt_view/settings/gantt_settings.dart';
import 'package:gantt_view/ui/painter/gantt_data_painter.dart';
import 'package:gantt_view/ui/painter/gantt_ui_painter.dart';

class GanttChart extends StatefulWidget {
  final List<GanttRowData> data;

  const GanttChart({
    super.key,
    required this.data,
  });

  @override
  State<GanttChart> createState() => _GanttChartState();
}

class _GanttChartState extends State<GanttChart> {
  Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    // debugPrint('offset: $offset');
    // final maxDy = ((widget.data.length + 1) *
    //         GanttSettings.of(context).eventRowTheme.height) -
    //     MediaQuery.of(context).size.height;
    // debugPrint('maxDy: $maxDy');
    return ClipRect(
      child: GestureDetector(
        onPanUpdate: (details) => setState(
          () {
            // debugPrint('onPanUpdate: $details');
            // debugPrint('offset: $offset');
            offset += details.delta;
            // if (offset.dx > 0) {
            //   offset = Offset(0, offset.dy);
            // }
            // if (-offset.dy < 0) {
            //   offset = Offset(offset.dx, 0);
            // }
            // if (-offset.dy > maxDy) {
            //   offset = Offset(offset.dx, -maxDy);
            // }
          },
        ),
        child: CustomPaint(
          size: Size.infinite,
          willChange: true,
          foregroundPainter: GanttUiPainter(
            data: widget.data,
            offset: offset,
            settings: GanttSettings.of(context),
          ),
          painter: GanttDataPainter(
            data: widget.data,
            offset: offset,
            settings: GanttSettings.of(context),
          ),
        ),
      ),
    );
  }
}
