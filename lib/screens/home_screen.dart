import 'package:flutter/material.dart';
import '../models/student.dart';
import 'paste_attendance_screen.dart';
import 'student_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Student> students = [];

  void _addStudent(Student student) {
    setState(() {
      students.add(student);
    });
  }

  void _updateStudents(List<Student> updatedList) {
    setState(() {
      students = updatedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      StudentListScreen(
        students: students,
        onAddStudent: _addStudent,
      ),
      PasteAttendanceScreen(
        students: students,
        onAttendanceUpdated: _updateStudents,
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Mahasiswa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.paste_outlined),
            activeIcon: Icon(Icons.paste),
            label: 'Rekap',
          ),
        ],
      ),
    );
  }
}
