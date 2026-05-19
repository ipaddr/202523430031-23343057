import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/document_provider.dart';
import 'analyzing_screen.dart';

class ExtractedTextScreen extends StatelessWidget {
  const ExtractedTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doc = context.watch<DocumentProvider>();

    return Scaffold(
      backgroundColor: AuklusColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AuklusColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Hasil Ekstraksi',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AuklusColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // --- preview teks ---
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AuklusColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AuklusColors.divider),
              ),
              child: _buildContent(doc),
            ),
          ),

          // --- tombol aksi ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                // --- aktif hanya saat dokumen siap ---
                onPressed: doc.isReady
                    ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AnalyzingScreen(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AuklusColors.accent,
                  disabledBackgroundColor: AuklusColors.divider,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Scan Contract',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(DocumentProvider doc) {
    // --- state error ---
    if (doc.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AuklusColors.riskHigh,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              doc.errorMessage ?? 'Terjadi kesalahan.',
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: AuklusColors.riskHigh,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // --- state loading/proses ---
    if (doc.isExtracting || doc.isCleaning) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AuklusColors.accent),
            const SizedBox(height: 16),
            Text(
              doc.statusMessage,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: AuklusColors.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    // --- state siap, tampilkan teks bersih ---
    if (doc.isReady) {
      return SingleChildScrollView(
        child: Text(
          doc.cleanedText.isEmpty
              ? 'Tidak ada teks yang dapat diekstrak.'
              : doc.cleanedText,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: AuklusColors.textPrimary,
            height: 1.6,
          ),
        ),
      );
    }

    // --- state idle, baru dibuka ---
    return const Center(
      child: Text(
        'Memproses dokumen...',
        style: TextStyle(fontFamily: 'Poppins', color: AuklusColors.textHint),
      ),
    );
  }
}
