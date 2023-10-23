
abstract class HeaderCell {
  final String? label;

  HeaderCell(this.label);
}

class ActivityHeaderCell extends HeaderCell {
  ActivityHeaderCell(String? label) : super(label);
}

class TaskHeaderCell extends HeaderCell {
  TaskHeaderCell(String label) : super(label);
}
