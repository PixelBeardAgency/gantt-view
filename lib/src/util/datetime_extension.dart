extension DateTimeExtension on DateTime {
  int numberOfDaysBetween(DateTime other) {
    if (isAfter(other)) {
      return other.numberOfDaysBetween(this);
    }

    int days = 0;
    DateTime start = DateTime(year, month, day);
    DateTime end = DateTime(other.year, other.month, other.day);
    while (!start.isAfter(end)) {
      days++;
      start = DateTime(start.year, start.month, start.day + 1);
    }

    return days;
  }

  List<DateTime> monthsBetween(DateTime other) {
    if (isAfter(other)) {
      return other.monthsBetween(this);
    }

    List<DateTime> months = [];
    DateTime start = DateTime(year, month, day);
    DateTime end = DateTime(other.year, other.month, other.day);
    while (!start.isAfter(end)) {
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
    DateTime start = DateTime(year, month, day);
    DateTime end = DateTime(other.year, other.month, other.day);
    while (!start.isAfter(end)) {
      years.add(start);
      start = DateTime(start.year + 1, 1, 1);
    }

    return years;
  }

  int get daysRemainingInMonth =>
      numberOfDaysBetween(DateTime(year, month + 1, 0)) + 1;

  int get daysRemainingInYear =>
      numberOfDaysBetween(DateTime(year + 1, 1, 0)) + 1;
}
