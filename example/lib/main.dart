import 'package:example/data.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/controller/gantt_data_controller.dart';
import 'package:gantt_view/gantt_chart.dart';
import 'package:gantt_view/model/gantt_task.dart';
import 'package:gantt_view/model/timeline_axis_type.dart';
import 'package:gantt_view/settings/gantt_grid.dart';
import 'package:gantt_view/settings/gantt_style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GanttChartController<ExampleEventItem> _controller;

  @override
  void initState() {
    super.initState();
    _controller = GanttChartController<ExampleEventItem>(
      items: Data.dummyData,
      taskBuilder: (item) => GanttTask(
        label: item.title,
        startDate: item.start,
        endDate: item.end,
        tooltip: item.title,
      ),
      taskSort: (a, b) => a.startDate.compareTo(b.startDate),
      activityLabelBuilder: (item) => item.group,
      activitySort: (a, b) => a.tasks
          .map((e) => e.startDate)
          .reduce((a, b) => a.isBefore(b) ? a : b)
          .compareTo(b.tasks
              .map((e) => e.startDate)
              .reduce((a, b) => a.isBefore(b) ? a : b)),
      highlightedDates: [DateTime(2023, 9, 29)],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GanttChart(
        controller: _controller,
        title: 'My Lovely Gantt',
        subtitle: 'This is a subtitle',
        grid: const GanttGrid(
          columnWidth: 40,
          rowSpacing: 0,
          timelineAxisType: TimelineAxisType.daily,
          tooltipType: TooltipType.hover,
        ),
        style: GanttStyle(
          taskBarColor: Colors.blue.shade400,
          activityLabelColor: Colors.blue.shade100,
          taskLabelColor: Colors.blue.shade900,
          gridColor: Colors.grey.shade300,
          taskBarRadius: 6,
          activityLabelStyle: Theme.of(context).textTheme.labelLarge,
          titleStyle: Theme.of(context).textTheme.titleLarge,
          titlePadding: const EdgeInsets.only(
            left: 8,
            right: 8,
            top: 16,
            bottom: 8,
          ),
          subtitleStyle: Theme.of(context).textTheme.titleMedium,
          timelineColor: Colors.grey.shade100,
          labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          axisDividerColor: Colors.grey.shade500,
          tooltipColor: Colors.redAccent,
          tooltipPadding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              weekendColor: Colors.grey.shade200,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () => _controller.setPanOffset(Offset.zero),
        child: const Icon(Icons.restore, color: Colors.white),
      ),
    );
  }
}
