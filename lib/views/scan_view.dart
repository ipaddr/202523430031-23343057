import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firestore_service.dart';
import '../themes.dart';
import '../tensorflow.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  List<Map<String, dynamic>>? _outputs;
  File? _image;
  bool _loading = false;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _loading = true;
    Tensorflow.loadModel().then((value) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  void _runClassification(File imageFile) async {
    setState(() {
      _loading = true;
    });

    var result = await Tensorflow.classifyImage(imageFile);

    if (mounted) {
      setState(() {
        _loading = false;
        _outputs = result;
      });
    }

    // simpan hasil ke Firestore jika ada hasil dan user sudah login
    if (result != null && result.isNotEmpty) {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final String label = result[0]['label'] as String;
        final double confidence = (result[0]['confidence'] as num).toDouble();

        try {
          await _firestoreService.saveScanHistory(
            uid: user.uid,
            name: label,
            result: label,
            accuracy: confidence,
          );
        } catch (e) {
          // jika gagal simpan, tampilkan pesan
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal menyimpan riwayat: $e')),
            );
          }
        }
      }
    }
  }

  pickImage(ImageSource source) async {
    var image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    setState(() {
      _image = File(image.path);
      _outputs = null;
    });
  }

  @override
  void dispose() {
    Tensorflow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MotifaTheme.backgroundWhite,
      appBar: AppBar(
        title: const Text(
          'SCAN MOTIF',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: MotifaTheme.backgroundWhite,
          ),
        ),
        backgroundColor: MotifaTheme.primaryBlue,
        scrolledUnderElevation: 0,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: Container(color: MotifaTheme.black, height: 3.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Kenali Batikmu!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Unggah atau foto motif batik untuk mencari tahu asal dan maknanya.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // placeholder / gambar preview
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: MotifaTheme.lightBlue,
                border: MotifaTheme.brutalBorder,
                boxShadow: MotifaTheme.brutalShadow,
                image: _image != null
                    ? DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _image == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_search_outlined,
                          size: 80,
                          color: MotifaTheme.black,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada gambar',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),

            // hasil prediksi
            if (_outputs != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MotifaTheme.yellowAccent,
                  border: MotifaTheme.brutalBorder,
                  boxShadow: MotifaTheme.brutalShadowSmall,
                ),
                child: Column(
                  children: [
                    const Text(
                      'Hasil Deteksi:',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _outputs![0]["label"],
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // deretan tombol
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: MotifaTheme.brutalShadow,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Kamera'),
                      style: MotifaTheme.brutalButtonStyle(
                        backgroundColor: MotifaTheme.yellowAccent,
                        foregroundColor: MotifaTheme.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: MotifaTheme.brutalShadow,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Galeri'),
                      style: MotifaTheme.brutalButtonStyle(
                        backgroundColor: MotifaTheme.yellowAccent,
                        foregroundColor: MotifaTheme.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // tombol scan
            Container(
              decoration: const BoxDecoration(
                boxShadow: MotifaTheme.brutalShadow,
              ),
              child: ElevatedButton(
                onPressed: _image != null && !_loading
                    ? () => _runClassification(_image!)
                    : null,
                style:
                    MotifaTheme.brutalButtonStyle(
                      backgroundColor: MotifaTheme.primaryBlue,
                      foregroundColor: MotifaTheme.backgroundWhite,
                    ).copyWith(
                      backgroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.disabled)) {
                          return MotifaTheme.lightBlue;
                        }
                        return MotifaTheme.primaryBlue;
                      }),
                      foregroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.disabled)) {
                          return MotifaTheme.black.withOpacity(0.4);
                        }
                        return MotifaTheme.backgroundWhite;
                      }),
                    ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Analisa motif', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
