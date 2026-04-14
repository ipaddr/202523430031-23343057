class Student {
  final String id;
  final String name;
  final String nim;
  int attendanceCount;

  Student({
    required this.id,
    required this.name,
    required this.nim,
    this.attendanceCount = 0,
  });
}
