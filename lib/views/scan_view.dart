import 'package:flutter/material.dart';
import '../themes.dart';

class ScanView extends StatelessWidget {
  const ScanView({super.key});

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
            const SizedBox(height: 48),

            // placeholder gambar
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: MotifaTheme.lightBlue,
                border: MotifaTheme.brutalBorder,
                boxShadow: MotifaTheme.brutalShadow,
              ),
              child: const Column(
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
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // deretan tombol
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: MotifaTheme.brutalShadow,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {},
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
                      onPressed: () {},
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

            const SizedBox(height: 48),

            // tombol scan
            Container(
              decoration: const BoxDecoration(
                boxShadow: MotifaTheme.brutalShadow,
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: MotifaTheme.brutalButtonStyle(
                  backgroundColor: MotifaTheme.primaryBlue,
                  foregroundColor: MotifaTheme.backgroundWhite,
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
