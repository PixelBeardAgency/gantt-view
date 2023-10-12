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

## Usage

![Gantt Example](/assets/example.png)

All that is required is a `GanttDataController` and a `GanttView` widget. The `GanttDataController` is responsible for providing the data to the `GanttView` and the `GanttView` is responsible for displaying the data.

There are basic theming options available for customising the look and feel of the `GanttView`, such as changing how rows look, and if headers should be displayed.

```dart
GanttView(
    controller: _controller, // required
    rowSpacing: 8.0,
    title: 'My Lovely Gantt',
    subtitle: 'This is a subtitle',
    headerRowTheme: HeaderRowTheme(
        height: 48.0,
        textStyle: Theme.of(context).textTheme.labelLarge,
        backgroundColor: Colors.grey[300],
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
)
```

To display events in the `GanttView`, a `GanttDataController` is required. The `GanttDataController` has
2 required fields, `items` and `eventBuilder`. The `items` field is a list of items that are used by the `GanttDataController` to build an internal data model for the `GanttView` to display. The `eventBuilder` is a function that takes an item from the `items` list and returns a `GanttEvent` data object. The `GanttEvent` data object provides the required data to display an event in the `GanttView`.

If a `headerBuilder` is provided, the `GanttView` will display a header row above the events. The `headerBuilder` is a function that takes an item from the `items` list and returns a `GanttHeader` data object. The `GanttHeader` data object provides the required data to display a header in the `GanttView`.

If a `sorter` is provided, the `GanttDataController` will sort the `items` list before building the internal data model. The `sorter` is a function that takes 2 items from the `items` list and returns an integer. The `sorter` should return a negative integer if the first item should be placed before the second item, a positive integer if the first item should be placed after the second item, or 0 if the items are equal.

```dart
GanttDataController<ExampleEventItem>(
    items: Data.dummyData,
    eventBuilder: (item) => GanttEvent(
    label: item.title,
    startDate: item.start,
    endDate: item.end,
    ),
    headerBuilder: (item) => GanttHeader(label: item.group),
    sorter: (a, b) => <Comparator<ExampleEventItem>>[
    (a, b) => a.group.compareTo(b.group),
    (a, b) => a.start.compareTo(b.start),
    ].map((e) => e(a, b)).firstWhere(
        (comparator) => comparator != 0,
        orElse: () => 0,
        ),
);
```

## Additional information

This is a WIP project and is not yet ready for production use. The API is subject to change. Any feedback is welcome, as are pull requests.

The current version was made quickly, and as such, there are some performance issues. The current implementation uses a series of `ListView` widgets which have their `ScrollController` synced to display the events. This is not a very performant solution, and will be replaced in the future.

## TODO
- [ ] Add ability to switch from day view to week view
- [ ] Display weekends in a different colour
- [ ] Add ability to customise weekend colour
- [ ] Add ability to add custom holiday dates
- [ ] Add ability to customise holiday colour
- [ ] Switch from a series of ListViews to a more performant solution
- [ ] Add tooltip to display event details
- [ ] Add zooming functionality
- [ ] Add ability to customise individual event bar colours
- [ ] Add ability to define custom start and end times for the entire chart
- [ ] Tests