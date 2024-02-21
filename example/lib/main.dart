import 'package:example/data.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/gantt_view.dart';

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

  final List<ExampleEventItem> _items = Data.dummyData;

  @override
  void initState() {
    super.initState();
    _controller = GanttChartController<ExampleEventItem>(
      items: _items,
      itemBuilder: (items) {
        List<GanttActivity> activities = [];
        Map<String, List<GanttTask>> labelTasks = {};

        for (var item in items) {
          final label = item.group;
          (labelTasks[label] ??= []).add(GanttTask(
            label: item.title,
            startDate: item.start,
            endDate: item.end,
            tooltip:
                '${item.title}\n${item.start.formattedDate} - ${item.end.formattedDate}',
          ));
        }

        activities = labelTasks.entries.map((e) {
          final tasks = e.value;
          tasks.sort((a, b) => a.startDate.compareTo(b.startDate));
          return GanttActivity(label: e.key, tasks: tasks);
        }).toList();
        activities.sort((a, b) =>
            a.tasks.first.startDate.compareTo(b.tasks.first.startDate));
        return activities;
      },
      highlightedDates: [DateTime.now().add(const Duration(days: 5))],
      showFullWeeks: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GanttChart(
        controller: _controller,
        grid: const GanttGrid(
          columnWidth: 100,
          timelineAxisType: TimelineAxisType.daily,
          tooltipType: TooltipType.tap,
        ),
        style: GanttStyle(
          taskBarColor: Colors.blue.shade400,
          activityLabelColor: Colors.blue.shade100,
          taskLabelColor: Colors.blue.shade900,
          taskLabelBuilder: (task) => Container(
            padding: const EdgeInsets.all(8),
            child: Text(task.label),
          ),
          gridColor: Colors.grey.shade300,
          taskBarRadius: 6,
          activityLabelStyle: Theme.of(context).textTheme.labelLarge,
          activityLabelBuilder: (activity) => Container(
            padding: const EdgeInsets.all(8),
            color: Colors.blue,
            child: Text(
              activity.label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          titleStyle: Theme.of(context).textTheme.titleLarge,
          titlePadding: const EdgeInsets.only(
            left: 8,
            right: 8,
            top: 16,
            bottom: 8,
          ),
          subtitleStyle: Theme.of(context).textTheme.titleMedium,
          timelineColor: Colors.grey.shade100,
          axisDividerColor: Colors.grey.shade500,
          tooltipColor: Colors.redAccent,
          tooltipPadding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          weekendColor: Colors.grey.shade200,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () => setState(() => _controller.addItems(Data.dummyData)),
        child: const Icon(Icons.restore, color: Colors.white),
      ),
    );
  }
}

extension on DateTime {
  String get formattedDate => '$day/$month/$year';
}
