import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_view/src/model/month.dart';
import 'package:gantt_view/src/settings/gantt_config.dart';
import 'package:gantt_view/src/util/datetime_extension.dart';

class GanttHeaderRow extends StatelessWidget {
  final GanttConfig config;
  final ScrollController yearScrollController;
  final ScrollController monthScrollController;
  final ScrollController dayScrollController;
  final Function(double position) onScroll;

  const GanttHeaderRow({
    super.key,
    required this.config,
    required this.yearScrollController,
    required this.monthScrollController,
    required this.dayScrollController,
    required this.onScroll,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: config.timelineHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: config.labelColumnWidth,
            child: config.style.chartTitleBuilder?.call(),
          ),
          if (config.style.axisDividerColor != null)
            VerticalDivider(
              color: config.style.axisDividerColor,
              width: 1,
              thickness: 1,
            ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                onScroll(scrollNotification.metrics.pixels);
                return true;
              },
              child: Column(
                children: [
                  if (config.grid.showYear)
                    Expanded(
                      child: CustomScrollView(
                        controller: yearScrollController,
                        scrollDirection: Axis.horizontal,
                        slivers: [
                          ...List.generate(config.yearsBetween.length,
                              (index) => config.yearsBetween[index]).map(
                            (e) => SliverPersistentHeader(
                                floating: true,
                                delegate: _YearHeaderDelegate(e, config)),
                          ),
                        ],
                      ),
                    ),
                  if (config.grid.showMonth)
                    Expanded(
                      child: CustomScrollView(
                        controller: monthScrollController,
                        scrollDirection: Axis.horizontal,
                        slivers: [
                          ...List.generate(config.monthsBetween.length,
                              (index) => config.monthsBetween[index]).map(
                            (e) => SliverPersistentHeader(
                                floating: true,
                                delegate: _MonthHeaderDelegate(e, config)),
                          ),
                        ],
                      ),
                    ),
                  if (config.grid.showDay)
                    Expanded(
                      child: ListView.builder(
                        controller: dayScrollController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final date =
                              config.startDate.add(Duration(days: index));
                          return SizedBox(
                            width: config.cellWidth,
                            child: config.style.dayLabelBuilder(date.day),
                          );
                        },
                        itemCount: config.columnCount,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthHeaderDelegate extends SliverPersistentHeaderDelegate {
  final DateTime date;
  final GanttConfig config;

  _MonthHeaderDelegate(this.date, this.config);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Align(
      alignment: Alignment.centerLeft,
      child: config.style.monthLabelBuilder(Month.fromId(date.month)),
    );
  }

  @override
  double get maxExtent =>
      config.cellWidth *
      (min(date.daysRemainingInMonth, config.endDate.difference(date).inDays +
          1));

  @override
  double get minExtent => config.cellWidth;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class _YearHeaderDelegate extends SliverPersistentHeaderDelegate {
  final DateTime date;
  final GanttConfig config;

  _YearHeaderDelegate(this.date, this.config);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Align(
      alignment: Alignment.centerLeft,
      child: config.style.yearLabelBuilder(date.year),
    );
  }

  @override
  double get maxExtent =>
      config.cellWidth *
      (min(date.daysRemainingInYear, config.endDate.difference(date).inDays +
          1));

  @override
  double get minExtent => config.cellWidth;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
