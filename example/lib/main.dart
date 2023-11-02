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

  @override
  void initState() {
    super.initState();
    _controller = GanttChartController<ExampleEventItem>(
      items: Data.dummyData,
      taskBuilder: (item) => GanttTask(
        label: item.title,
        startDate: item.start,
        endDate: item.end,
        tooltip:
            '${item.title}\n${item.start.formattedDate} - ${item.end.formattedDate}',
      ),
      taskSort: (a, b) => a.startDate.compareTo(b.startDate),
      activityLabelBuilder: (item) => item.group,
      activitySort: (a, b) =>
          a.tasks.first.startDate.compareTo(b.tasks.first.startDate),
      highlightedDates: [DateTime.now().add(const Duration(days: 5))],
      showFullWeeks: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GanttChart(
        controller: _controller,
        title: 'My Lovely Gantt',
        subtitle: 'This is a subtitle',
        grid: const GanttGrid(
          columnWidth: 40,
          rowSpacing: 0,
          timelineAxisType: TimelineAxisType.daily,
          tooltipType: TooltipType.tap,
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
        onPressed: () => _controller.addItems(Data.dummyData),
        child: const Icon(Icons.restore, color: Colors.white),
      ),
    );
  }
}

extension on DateTime {
  String get formattedDate => '$day/$month/$year';
}
