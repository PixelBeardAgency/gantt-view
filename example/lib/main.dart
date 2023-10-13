import 'package:example/data.dart';
import 'package:flutter/material.dart';
import 'package:gantt_view/controller/gantt_data_controller.dart';
import 'package:gantt_view/gantt_view.dart';
import 'package:gantt_view/model/gantt_event.dart';
import 'package:gantt_view/model/gantt_header.dart';
import 'package:gantt_view/settings/gantt_settings.dart';
import 'package:gantt_view/settings/theme/event_row_theme.dart';
import 'package:gantt_view/settings/theme/header_row_theme.dart';
import 'package:gantt_view/settings/theme/legend_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
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
      eventBuilder: (item) => GanttEvent(
        label: item.title,
        startDate: item.start,
        endDate: item.end,
      ),
      headerBuilder: (item) => GanttHeader(label: item.group),
      sorters: 
[        (a, b) => a.group.compareTo(b.group),
        (a, b) => a.start.compareTo(b.start),],
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
      body: GanttView(
        controller: _controller,
        rowSpacing: 8.0,
        title: 'My Lovely Gantt',
        subtitle: 'This is a subtitle',
        headerRowTheme: HeaderRowTheme(
          height: 48.0,
          textStyle: Theme.of(context).textTheme.labelLarge,
          backgroundColor: Colors.grey[300]!,
        ),
        eventRowTheme: EventRowTheme(
          fillColor: Colors.blue[200],
          labelStyle: Theme.of(context).textTheme.labelMedium,
          height: 20,
          startRadius: 4.0,
          endRadius: 4.0,
        ),
        legendTheme: LegendTheme(
          width: 200,
          dateStyle: Theme.of(context).textTheme.labelMedium,
          backgroundColor: Colors.blue[100],
        ),
        timelineAxisType: TimelineAxisType.daily,
      ),
    );
  }
}
