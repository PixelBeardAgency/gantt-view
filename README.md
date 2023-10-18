A customisable Gantt Chart view for Flutter.
> Currently under development

## Features

- Sticky Title Column to display event names
- Sticky Legend Row to display dates 
- Customisable event bar colours
- Customisable event bar height
- Customisable gaps between event bars
- Customisable event bar corner radius
- Ability to switch from day view to week view
- Display weekends in a different colour
- Customisable weekend colour
- Custom highlighted dates
- Customisable highlighted date colour

## Usage

![Gantt Example](/assets/example.png)

All that is required is a `GanttDataController` and a `GanttView` widget. The `GanttDataController` is responsible for providing the data to the `GanttView` and the `GanttView` is responsible for displaying the data.

There are basic theming options available for customising the look and feel of the `GanttView`, such as changing how rows look, and if headers should be displayed.

```dart
GanttView(
    controller: _controller,
    title: 'My Lovely Gantt',
    subtitle: 'This is a subtitle',
    gridScheme: const GridScheme(
        columnWidth: 30,
        rowSpacing: 0,
        highlightWeekends: true,
        timelineAxisType: TimelineAxisType.daily,
    ),
    style: GanttStyle(
        context,
        eventColor: Colors.blue.shade400,
        eventHeaderColor: Colors.blue.shade100,
        eventLabelColor: Colors.blue.shade900,
        gridColor: Colors.grey.shade300,
        eventRadius: 6,
        eventHeaderStyle: Theme.of(context).textTheme.labelLarge,
        titleStyle: Theme.of(context).textTheme.titleLarge,
        titlePadding: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 16,
        bottom: 8,
        ),
        subtitleStyle: Theme.of(context).textTheme.titleMedium,
        timelineColor: _backgroundColor,
        eventLabelPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        weekendColor: Colors.blue.shade200,
        highlightedDateColor: Colors.blue.shade300,
    ),
    highlightedDates: [DateTime(2023, 10, 4)],
)
```

To display events in the `GanttView`, a `GanttDataController` is required. The `GanttDataController` has 2 required fields, `items` and `eventBuilder`. The `items` field is a list of items that are used by the `GanttDataController` to build an internal data model for the `GanttView` to display. The `eventBuilder` is a function that takes an item from the `items` list and returns a `GanttEvent` data object. The `GanttEvent` data object provides the required data to display an event in the `GanttView`.

If an `activityLabelBuilder` is provided, the `GanttView` will display a header row above the events which for that activity. The `activityLabelBuilder` is a function that takes an item from the `items` list and returns a `String`. The header String is then used to group events together to be displayed as part of the same activity.

To sort tasks internal to a single activity, a `taskSort` function can be provided. This is a comparator function that takes 2 `GanttTask` objects and returns an `int` value. The `GanttTask` objects are then sorted based on the returned value.

To sort activities in the `GanttView`, a `activitySort` function can be provided. This is a comparator function that takes 2 `GanttActivity` objects and returns an `int` value. The `GanttActivity` objects are then sorted based on the returned value.

```dart
GanttDataController<ExampleEventItem>(
    items: Data.dummyData,
    taskBuilder: (item) => GanttTask(
    label: item.title,
    startDate: item.start,
    endDate: item.end,
    ),
    taskSort: (a, b) => a.startDate.compareTo(b.startDate),
    activityLabelBuilder: (item) => item.group,
    activitySort: (a, b) => a.tasks.startDate.compareTo(b.tasks.startDate),
)
```

## Additional information

This is a WIP project and is not yet ready for production use. The API is subject to change. Any feedback is welcome, as are pull requests.

The current version was made quickly, and as such, there are some performance issues. The current implementation uses a series of `ListView` widgets which have their `ScrollController` synced to display the events. This is not a very performant solution, and will be replaced in the future.

## TODO
- [ ] Add tooltip to display event details
- [ ] Add zooming functionality
- [ ] Add ability to customise individual event bar colours
- [ ] Add ability to define custom start and end times for the entire chart
- [ ] Tests