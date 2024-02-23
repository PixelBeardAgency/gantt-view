enum Month {
  jan(1),
  feb(2),
  mar(3),
  apr(4),
  may(5),
  jun(6),
  jul(7),
  aug(8),
  sep(9),
  oct(10),
  nov(11),
  dec(12);

  final int id;

  const Month(this.id);

  factory Month.fromId(int id) => switch (id) {
        1 => Month.jan,
        2 => Month.feb,
        3 => Month.mar,
        4 => Month.apr,
        5 => Month.may,
        6 => Month.jun,
        7 => Month.jul,
        8 => Month.aug,
        9 => Month.sep,
        10 => Month.oct,
        11 => Month.nov,
        12 => Month.dec,
        _ => throw Exception('Invalid month number')
      };
}
