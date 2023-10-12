import 'dart:convert';

abstract class Data {
  static List<ExampleEventItem> get dummyData => json
      .decode(_dummyData)
      .map<ExampleEventItem>((e) => ExampleEventItem.fromJson(e))
      .toList();
}

class ExampleEventItem {
  final String title;
  final String group;
  final DateTime start;
  final DateTime end;

  ExampleEventItem(
      {required this.title,
      required this.group,
      required this.start,
      required this.end});

  factory ExampleEventItem.fromJson(Map<String, dynamic> json) {
    return ExampleEventItem(
      title: json['title'],
      group: json['group'],
      start: DateTime.parse(json['start_date']),
      end: DateTime.parse(json['end_date']),
    );
  }
}

const String _dummyData = '''
  [
    {
        "title": "tristique in",
        "group": "sed",
        "start_date": "2022-09-27",
        "end_date": "2022-10-07"
    },
    {
        "title": "id luctus nec",
        "group": "morbi",
        "start_date": "2022-09-21",
        "end_date": "2022-10-07"
    },
    {
        "title": "turpis a",
        "group": "sed",
        "start_date": "2022-09-14",
        "end_date": "2022-09-25"
    },
    {
        "title": "nulla ac enim",
        "group": "sed",
        "start_date": "2022-10-08",
        "end_date": "2022-10-21"
    },
    {
        "title": "faucibus orci",
        "group": "morbi",
        "start_date": "2022-10-06",
        "end_date": "2022-10-08"
    },
    {
        "title": "purus aliquet",
        "group": "morbi",
        "start_date": "2022-10-10",
        "end_date": "2022-10-11"
    },
    {
        "title": "etiam",
        "group": "in",
        "start_date": "2022-09-15",
        "end_date": "2022-10-02"
    },
    {
        "title": "vestibulum",
        "group": "sed",
        "start_date": "2022-09-25",
        "end_date": "2022-09-30"
    },
    {
        "title": "massa quis augue",
        "group": "morbi",
        "start_date": "2022-09-26",
        "end_date": "2022-10-04"
    },
    {
        "title": "id",
        "group": "in",
        "start_date": "2022-09-14",
        "end_date": "2022-09-18"
    },
    {
        "title": "leo maecenas pulvinar",
        "group": "sed",
        "start_date": "2022-09-16",
        "end_date": "2022-10-03"
    },
    {
        "title": "ultrices",
        "group": "in",
        "start_date": "2022-09-14",
        "end_date": "2022-09-28"
    },
    {
        "title": "libero nullam",
        "group": "sed",
        "start_date": "2022-09-19",
        "end_date": "2022-09-28"
    },
    {
        "title": "metus aenean fermentum",
        "group": "in",
        "start_date": "2022-09-28",
        "end_date": "2022-10-06"
    },
    {
        "title": "cubilia",
        "group": "sed",
        "start_date": "2022-09-14",
        "end_date": "2022-09-29"
    },
    {
        "title": "nullam porttitor lacus",
        "group": "diam",
        "start_date": "2022-09-26",
        "end_date": "2022-10-06"
    },
    {
        "title": "sit amet nulla",
        "group": "in",
        "start_date": "2022-09-25",
        "end_date": "2022-10-13"
    },
    {
        "title": "cras",
        "group": "in",
        "start_date": "2022-09-17",
        "end_date": "2022-09-27"
    },
    {
        "title": "quisque id justo",
        "group": "sed",
        "start_date": "2022-09-18",
        "end_date": "2022-09-22"
    },
    {
        "title": "vulputate",
        "group": "diam",
        "start_date": "2022-09-19",
        "end_date": "2022-09-24"
    },
    {
        "title": "tincidunt nulla mollis",
        "group": "diam",
        "start_date": "2022-09-20",
        "end_date": "2022-10-02"
    },
    {
        "title": "quam pharetra magna",
        "group": "morbi",
        "start_date": "2022-10-06",
        "end_date": "2022-10-19"
    },
    {
        "title": "eleifend luctus ultricies",
        "group": "diam",
        "start_date": "2022-09-14",
        "end_date": "2022-09-18"
    },
    {
        "title": "pede venenatis",
        "group": "sem",
        "start_date": "2022-10-08",
        "end_date": "2022-10-21"
    },
    {
        "title": "in tempus",
        "group": "morbi",
        "start_date": "2022-09-21",
        "end_date": "2022-09-24"
    },
    {
        "title": "vel",
        "group": "diam",
        "start_date": "2022-10-09",
        "end_date": "2022-10-26"
    },
    {
        "title": "ut suscipit",
        "group": "sem",
        "start_date": "2022-10-03",
        "end_date": "2022-10-20"
    },
    {
        "title": "ut nulla sed",
        "group": "in",
        "start_date": "2022-09-18",
        "end_date": "2022-09-22"
    },
    {
        "title": "non mattis",
        "group": "sem",
        "start_date": "2022-09-26",
        "end_date": "2022-09-28"
    },
    {
        "title": "at",
        "group": "morbi",
        "start_date": "2022-09-30",
        "end_date": "2022-10-18"
    }
]
''';
