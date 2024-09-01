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
  final List<ExampleEventItem> _items = Data.dummyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GanttChart<ExampleEventItem>(
        rows: _items.toRows(),
        showCurrentDate: true,
        style: GanttStyle(
          columnWidth: 50,
          barHeight: 16,
          timelineAxisType: TimelineAxisType.daily,
          tooltipType: TooltipType.hover,
          taskBarColor: Colors.blue.shade400,
          activityLabelColor: Colors.blue.shade500,
          taskLabelColor: Colors.blue.shade900,
          taskLabelBuilder: (task) => Container(
            padding: const EdgeInsets.all(4),
            child: Text(
              task.data.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          gridColor: Colors.grey.shade300,
          taskBarRadius: 8,
          activityLabelBuilder: (activity) => Container(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.label!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'A subtitle',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          axisDividerColor: Colors.grey.shade500,
          tooltipColor: Colors.redAccent,
          tooltipPadding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          weekendColor: Colors.grey.shade200,
          dateLineColor: Colors.red,
          snapToDay: false,
        ),
        dateLines: [
          GanttDateLine(
              date: DateTime.timestamp(), width: 2, color: Colors.orangeAccent),
          GanttDateLine(
            date: DateTime.timestamp().add(const Duration(days: 2)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () => setState(() => _items.addAll(Data.dummyData)),
        child: const Icon(Icons.restore, color: Colors.white),
      ),
    );
  }
}

extension on DateTime {
  String get formattedDate => '$day/$month/$year';
}

extension on List<ExampleEventItem> {
  List<GridRow> toRows() {
    List<GridRow> rows = [];
    Map<String, List<TaskGridRow<ExampleEventItem>>> labelTasks = {};

    sort((a, b) => a.start.compareTo(b.start));

    for (var item in this) {
      final label = item.group;
      (labelTasks[label] ??= []).add(TaskGridRow<ExampleEventItem>(
        data: item,
        startDate: item.start,
        endDate: item.end,
        tooltip:
            '${item.title}\n${item.start.formattedDate} - ${item.end.formattedDate}',
      ));
    }

    for (var label in labelTasks.keys) {
      rows.add(ActivityGridRow(label));
      rows.addAll(labelTasks[label]!);
    }

    return rows;
  }
}
