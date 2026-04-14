import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? studentsData = prefs.getString('students');
    
    if (studentsData != null) {
      final List<dynamic> decoded = jsonDecode(studentsData);
      setState(() {
        students = decoded.map((item) => Student.fromJson(item)).toList();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(students.map((e) => e.toJson()).toList());
    await prefs.setString('students', encoded);
  }

  void _addStudent(Student student) {
    setState(() {
      students.add(student);
    });
    _saveData();
  }

  void _updateStudents(List<Student> updatedList) {
    setState(() {
      students = updatedList;
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

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
