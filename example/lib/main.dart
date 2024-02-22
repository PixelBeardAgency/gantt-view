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
        grid: const GanttGrid(
          columnWidth: 100,
          barHeight: 100,
          timelineAxisType: TimelineAxisType.daily,
          tooltipType: TooltipType.hover,
        ),
        style: GanttStyle(
          taskBarColor: Colors.blue.shade400,
          activityLabelColor: Colors.blue.shade100,
          taskLabelColor: Colors.blue.shade900,
          taskLabelBuilder: (task) => Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              task.data.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          gridColor: Colors.grey.shade300,
          taskBarRadius: 6,
          activityLabelBuilder: (activity) => Container(
            padding: const EdgeInsets.all(8),
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
        ),
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
