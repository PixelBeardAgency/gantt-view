A customisable Gantt Chart view for Flutter.
> Currently under development

## Features

- Sticky Title Column to display task names
- Sticky Legend Row to display dates 
- Customisable task bar colors
- Customisable task bar height
- Customisable gaps between task bars
- Customisable task bar corner radius
- Ability to switch from day view to week view
- Display weekends in a different color
- Customisable weekend color
- Custom highlighted dates
- Customisable highlighted date color
- Tooltip on hover, or tap, of task bar
- Customisable tooltip style

## Usage

![Gantt Example](/assets/example.png)

All that is required is a `GanttChart<T>` widget with a `List<GridRow>` passed in. The `List<GridRow>` is a list of `<ActivityGridRow>` and `TaskGridRow`, an example of how to construct is in `example\lib\main.dart`.

There are basic theming options available for customising the look and feel of the `GanttChart`, such as changing how rows look, and if headers should be displayed.

ActivityGridRow and TaskGridRow are the two types of rows that can be displayed in the GanttChart. ActivityGridRow is a row that displays a header for a group of tasks, and TaskGridRow is a row that displays a task. To customise the look of the rows, a `GanttRowStyle` can be provided to the `GanttChart` widget. The `GanttRowStyle` has 2 fields, `activityLabelBuilder` and `taskLabelBuilder`, which are used to customise the look of the `ActivityGridRow` and `TaskGridRow` respectively.

Other customisation options include the ability to change the color of the grid lines, the color of the weekend columns, and the color of the highlighted dates. The `GanttChart` also has the ability to display a tooltip when a task is hovered over, or tapped on.

```dart
GanttChart<ExampleEventItem>(
    rows: _items.toRows(),
    style: GanttStyle(
        columnWidth: 100,
        barHeight: 16,
        timelineAxisType: TimelineAxisType.daily,
        tooltipType: TooltipType.hover,
        taskBarColor: Colors.blue.shade400,
        activityLabelColor: Colors.blue.shade500,
        taskLabelColor: Colors.blue.shade900,
        taskLabelBuilder: (task) => TaskLabel(task),
        gridColor: Colors.grey.shade300,
        taskBarRadius: 8,
        activityLabelBuilder: (activity) => ActivityLabel(activity),
        axisDividerColor: Colors.grey.shade500,
        tooltipColor: Colors.redAccent,
        tooltipPadding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        weekendColor: Colors.grey.shade200,
    ),
    dateLines: [
        GanttDateLine(
            date: DateTime.timestamp(), width: 2, color: Colors.orangeAccent),
        GanttDateLine(
        date: DateTime.timestamp().add(const Duration(days: 2)),
        ),
    ],
)
```

## Styling

| Property             | Type                                       |
| -------------------- | ------------------------------------------ |
| taskBarColor         | Color                                      |
| taskBarRadius        | double                                     |
| taskLabelColor       | Color                                      |
| activityLabelColor   | Color                                      |
| chartTitleBuilder    | Widget Function()?                         |
| taskLabelBuilder     | Widget Function(TaskGridRow<T> task)       |
| activityLabelBuilder | Widget Function(ActivityGridRow activity)? |
| yearLabelBuilder     | Widget Function(int year)                  |
| monthLabelBuilder    | Widget Function(Month month)               |
| dayLabelBuilder      | Widget Function(int day)                   |
| gridColor            | Color?                                     |
| weekendColor         | Color?                                     |
| holidayColor         | Color                                      |
| axisDividerColor     | Color?                                     |
| tooltipColor         | Color                                      |
| tooltipStyle         | TextStyle                                  |
| tooltipPadding       | EdgeInsets                                 |
| tooltipRadius        | double                                     |
| barHeight            | double                                     |
| columnWidth          | double                                     |
| tooltipWidth         | double                                     |
| labelColumnWidth     | double                                     |
| showYear             | bool                                       |
| showMonth            | bool                                       |
| showDay              | bool                                       |
| timelineAxisType     | TimelineAxisType                           |
| tooltipType          | TooltipType                                |

## Additional information

This is a WIP project and is not yet ready for production use. The API is subject to change. Any feedback is welcome, as are pull requests.

## TODO
- [ ] Add zooming functionality
- [x] Add ability to customise individual task bar colors
- [ ] Add ability to define custom start and end times for the entire chart
- [ ] Tests
- [ ] Add ability to define legend height, label column width, which overrides the autocalculated values
- [ ] Add ability to hide the legend
- [ ] Add ability to hide the title/labels
- [ ] Add ability to set the first day of the week
- [ ] Add ability to make highlighted days and weekend days a solid colour, so that the task bar is not visible
- [ ] Add scrollbars
- [ ] Add date lines for the user to be able to display important dates

## Current Known Issues
- [ ] Sometimes when instantiated, the pan offset of the chart is not correctly updated when panning, resulting in a slower pan speed than expected.
- [ ] Large lists of items can cause the chart to be slow to render, due to:
  - Sorting a large amount of data into Activities and Tasks;
  - Calculating the width of the label column based on the longest label;
    - This is done currently via a utility function being run for each label and getting the width, then taking the max width of all the labels, which is not efficient.
- [x] When resizing, the chart can try to render further than it's bounds, instead of updating the pan offset to the new bounds.
- [ ] Dates not in UTC time can cause issues when crossing into daylight savings time (DST), as the chart does not take into account DST.
- [ ] Sometimes on web, scrolling horizontally with a horizontal mouse wheel doesn't work