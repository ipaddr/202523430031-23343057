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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nim': nim,
        'attendanceCount': attendanceCount,
      };

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['id'],
        name: json['name'],
        nim: json['nim'],
        attendanceCount: json['attendanceCount'] ?? 0,
      );
}
