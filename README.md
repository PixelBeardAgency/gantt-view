A customisable Gantt Chart view for Flutter.
> Currently under development

## Features

- Sticky Title Column to display event names
- Sticky Legend Row to display dates 
- Customisable event bar colors
- Customisable event bar height
- Customisable gaps between event bars
- Customisable event bar corner radius
- Ability to switch from day view to week view
- Display weekends in a different color
- Customisable weekend color
- Custom highlighted dates
- Customisable highlighted date color

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
## Grid Scheme

| Property         | Type               | Description                                              | Default |
| ---------------- | ------------------ | -------------------------------------------------------- | ------- |
| barHeight        | `double`           | Height of the task bar internal to the row               | `12.0`  |
| rowSpacing       | `double`           | Vertical spacing between rows                            | `0.0`   |
| columnWidth      | `double`           | Horizontal width of each column                          | `50.0`  |
| showYear         | `bool`             | Toggle for displaying the year on the top timeline axis  | `true`  |
| showMonth        | `bool`             | Toggle for displaying the month on the top timeline axis | `true`  |
| showDay          | `bool`             | Toggle for displaying the day on the top timeline axis   | `true`  |
| timelineAxisType | `TimelineAxisType` | Enum to toggle chart between daily and weekly view       | `daily` |

## Styling

| Property             | Type         | Description                                                | Default                                     |
| -------------------- | ------------ | ---------------------------------------------------------- | ------------------------------------------- |
| taskBarColor         | `Color`      | Color of the task bar on the chart                         | `primaryColor`                              |
| taskBarRadius        | `double`     | Corner radius of the task bar                              | `0.0`                                       |
| taskLabelStyle       | `TextStyle`  | TextStyle for the task title for the row                   | `labelMedium` with `onSecondary` text color |
| taskLabelColor       | `Color`      | Color for the task title for the row                       | `secondaryColor`                            |
| labelPadding         | `EdgeInsets` | Padding for task and activity row titles                   | `EdgeInsets.all(0)`                         |
| activityLabelStyle   | `TextStyle`  | TextStyle for the activity title                           | `labelMedium` with `onTertiary` text color  |
| activityLabelColor   | `Color`      | Color for the activity title                               | `tertiaryColor`                             |
| timelineColor        | `Color`      | Background color for the top timeline axis                 | `surfaceColor`                              |
| timelineStyle        | `TextStyle`  | TextStyle for the dates in the top timeline axis           | `labelSmall` with `onSurface` text color    |
| titleStyle           | `TextStyle`  | TextStyle for the title on the top left of the chart       | `labelLarge` with `onSurface` text color    |
| subtitleStyle        | `TextStyle`  | TextStyle for the subtitle on the top left of the chart    | `labelMedium` with `onSurface` text color   |
| titlePadding         | `EdgeInsets` | Overall padding around the Title and Subtitle              | `EdgeInsets.all(0)`                         |
| gridColor            | `Color`      | Color of the grid lines on the chart                       | `null`                                      |
| weekendColor         | `Color`      | Color of the weekend columns                               | `null`                                      |
| highlightedDateColor | `Color`      | Color of the highlighted date columns                      | `tertiaryColor`                             |
| axisDividerColor     | `Color`      | Color of the dividing lines between the axis and the chart | `null`                                      |

## Additional information

This is a WIP project and is not yet ready for production use. The API is subject to change. Any feedback is welcome, as are pull requests.

## TODO
- [ ] Add tooltip to display event details
- [ ] Add zooming functionality
- [ ] Add ability to customise individual event bar colors
- [ ] Add ability to define custom start and end times for the entire chart
- [ ] Tests