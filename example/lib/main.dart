import 'package:example/data.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/controller/gantt_data_controller.dart';
import 'package:gantt_view/extension/gantt_task_iterable_extension.dart';
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
  late GanttDataController<ExampleEventItem> _controller;

  @override
  void initState() {
    super.initState();
    _controller = GanttDataController<ExampleEventItem>(
      items: Data.dummyData,
      taskBuilder: (item) => GanttTask(
        label: item.title,
        startDate: item.start,
        endDate: item.end,
      ),
      taskSort: (a, b) => a.startDate.compareTo(b.startDate),
      activityLabelBuilder: (item) => item.group,
      activitySort: (a, b) => a.tasks.startDate.compareTo(b.tasks.startDate),
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
      body: GanttChart(
        controller: _controller,
        title: 'My Lovely Gantt',
        subtitle: 'This is a subtitle',
        grid: const GanttGrid(
          columnWidth: 30,
          rowSpacing: 0,
          timelineAxisType: TimelineAxisType.daily,
        ),
        style: GanttStyle(
          taskBarColor: Colors.blue.shade200,
          taskLabelColor: Colors.blue.shade900,
          activityLabelColor: Colors.blue.shade400,
          gridColor: Colors.grey.shade300,
          labelPadding: const EdgeInsets.all(4),
          taskBarRadius: 10,
          timelineColor: Colors.grey.shade300,
        ),
      ),
    );
  }
}
