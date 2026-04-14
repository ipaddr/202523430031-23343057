import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentListScreen extends StatelessWidget {
  final List<Student> students;
  final Function(Student) onAddStudent;

  const StudentListScreen({
    super.key,
    required this.students,
    required this.onAddStudent,
  });

  void _showAddStudentDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController nimController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Tambah Mahasiswa', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nimController,
                decoration: InputDecoration(
                  labelText: 'NIM',
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty && nimController.text.trim().isNotEmpty) {
                  onAddStudent(Student(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    nim: nimController.text.trim(),
                  ));
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mahasiswa', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
      ),
      body: students.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_off_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada data mahasiswa.\nSilakan tekan tombol + untuk menambah.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: students.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[200], indent: 16, endIndent: 16),
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  subtitle: Text(student.nim, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Hadir x${student.attendanceCount}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStudentDialog(context),
        backgroundColor: Colors.black87,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
