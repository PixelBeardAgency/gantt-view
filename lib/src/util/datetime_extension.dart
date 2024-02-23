extension DateTimeExtension on DateTime {
  List<DateTime> monthsBetween(DateTime other) {
    if (isAfter(other)) {
      return other.monthsBetween(this);
    }

    List<DateTime> months = [];
    DateTime start = this;
    while (!start.isAfter(other)) {
      months.add(start);
      start = DateTime(start.year, start.month + 1, 1);
    }

    return months;
  }

  List<DateTime> yearsBetween(DateTime other) {
    if (isAfter(other)) {
      return other.yearsBetween(this);
    }

    List<DateTime> years = [];
    DateTime start = this;
    while (!start.isAfter(other)) {
      years.add(start);
      start = DateTime(start.year + 1, 1, 1);
    }

    return years;
  }

  int get daysRemainingInMonth =>
      DateTime(year, month + 1, 0).difference(this).inDays + 1;

  int get daysRemainingInYear =>
      DateTime(year + 1, 1, 0).difference(this).inDays + 1;
}
