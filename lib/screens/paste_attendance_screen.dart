import 'package:flutter/material.dart';
import '../models/student.dart';
import '../utils/string_matching.dart';

class PasteAttendanceScreen extends StatefulWidget {
  final List<Student> students;
  final Function(List<Student>) onAttendanceUpdated;

  const PasteAttendanceScreen({
    super.key,
    required this.students,
    required this.onAttendanceUpdated,
  });

  @override
  State<PasteAttendanceScreen> createState() => _PasteAttendanceScreenState();
}

class _PasteAttendanceScreenState extends State<PasteAttendanceScreen> {
  final TextEditingController _textController = TextEditingController();

  void _processAttendance() {
    String text = _textController.text;
    if (text.trim().isEmpty) {
      _showSnackbar('Teks absensi tidak boleh kosong', Colors.red);
      return;
    }

    if (widget.students.isEmpty) {
      _showSnackbar(
        'Daftar mahasiswa masih kosong. Tambahkan dulu di tab sebelah.',
        Colors.orange,
      );
      return;
    }

    List<String> lines = text.split('\n');
    int matchedCount = 0;

    // Create a copy of the list
    List<Student> updatedStudents = List.from(widget.students);

    // To keep track of students already marked in this batch to prevent double counting
    Set<String> processedStudentIds = {};

    for (String line in lines) {
      if (line.trim().isEmpty) continue;

      // Clean up the line: e.g., "1. Budi" -> "Budi", "  2) Siti " -> "Siti"
      String cleanedName = line
          .replaceFirst(RegExp(r'^\d+[\.\)\-]?\s*'), '')
          .trim();

      if (cleanedName.isEmpty) continue;

      // Find the student with typo tolerance
      for (int i = 0; i < updatedStudents.length; i++) {
        Student currentStudent = updatedStudents[i];

        // Cek toleransi typo
        if (StringMatching.isMatch(cleanedName, currentStudent.name)) {
          // Hanya hitung sekali jika namanya muncul berkali-kali dalam 1 pesan
          if (!processedStudentIds.contains(currentStudent.id)) {
            currentStudent.attendanceCount += 1;
            processedStudentIds.add(currentStudent.id);
            matchedCount++;
          }
          break; // Stop finding once matched for this line
        }
      }
    }

    widget.onAttendanceUpdated(updatedStudents);
    _textController.clear();
    FocusScope.of(context).unfocus(); // Close keyboard

    _showSnackbar(
      'Berhasil merekap $matchedCount nama mahasiswa.',
      Colors.green,
    );
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rekap Absensi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Tempel list daftar nama mahasiswa di sini.',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: 'Contoh:\n1. Ghazian\n2. Ridho\n3. Carli',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _processAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'PROSES ABSENSI',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
