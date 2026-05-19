import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static const String _url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent';

  // --- bersihkan teks ocr dengan gemini ai ---
  static Future<Map<String, String>> cleanText(String extractedText) async {
    debugPrint(
      'gemini api key loaded: ${_apiKey.isNotEmpty ? "yes (${_apiKey.substring(0, 10)}...)" : "EMPTY!"}',
    );

    // --- lewati jika teks kosong ---
    if (extractedText.trim().isEmpty) {
      return {'cleaned_text': extractedText, 'request_text': extractedText};
    }

    final String prompt =
        '''
Anda adalah AI pembersih teks dokumen kontrak profesional.

Tugas Anda:
1. Membersihkan hasil OCR dari dokumen kontrak bisnis berbahasa Indonesia tanpa mengubah makna kalimat, meringkas isi dokumen, atau menambahkan informasi baru.
2. Mengekstrak HANYA kalimat-kalimat klausul yang mengandung hak, kewajiban, larangan, atau ketentuan hukum.

Perbaiki masalah berikut pada teks:
- Typo hasil OCR, spasi berantakan, new line berlebihan, karakter aneh, kata terpotong, format paragraf yang rusak, nomor pasal yang tidak rapi, dan struktur kalimat yang kacau.

Aturan penting:
- Output HARUS berupa JSON murni (raw JSON) yang valid, tanpa ada block code (seperti ```json).
- SANGAT PENTING: Setiap kalimat di dalam "request_text" TIDAK BOLEH diringkas atau diubah kata-katanya. Harus 100% identik (copy-paste) dengan kalimat yang ada di "cleaned_text". Ini wajib karena teks akan dipakai untuk pencarian string dan visual highlight.

Aturan khusus untuk "request_text" — BUANG SEMUA yang berikut:
- Judul dokumen, kop surat, nama instansi, alamat
- Nomor surat, tanggal surat, perihal
- Judul pasal (contoh: "PASAL 1", "BAB II", "KETENTUAN UMUM")
- Kalimat pengantar (contoh: "Yang bertanda tangan di bawah ini...", "Para pihak sepakat bahwa...")
- Identitas pihak (nama, NIK, alamat, jabatan)
- Kalimat penutup (contoh: "Demikian surat ini dibuat...", "ditandatangani oleh kedua belah pihak")
- Tanda tangan, saksi, meterai
- Nomor butir/ayat (hapus angka "1.", "a.", "i)" di awal kalimat, sisakan isi kalimatnya saja)

HANYA SISAKAN kalimat yang berisi:
- Hak dan kewajiban pihak
- Larangan atau pembatasan
- Sanksi atau konsekuensi
- Ketentuan pembayaran, jangka waktu, denda
- Syarat dan kondisi yang mengikat secara hukum

Setiap klausul dipisahkan oleh newline (\\n). Satu kalimat = satu baris.

Gunakan format output JSON persis seperti berikut:
{
  "cleaned_text": "Seluruh dokumen utuh dari awal hingga akhir yang sudah diperbaiki typo dan formatnya.",
  "request_text": "Hanya kalimat-kalimat klausul hukum, satu per baris, tanpa judul/kop/identitas/penutup. Kata-kata 100% identik dengan cleaned_text."
}

Berikut teks hasil OCR yang harus diproses:

$extractedText
''';

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': _apiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.1,
            'responseMimeType': 'application/json',
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final content = data['candidates'][0]['content'];
          if (content != null &&
              content['parts'] != null &&
              content['parts'].isNotEmpty) {
            String jsonText = content['parts'][0]['text'];
            try {
              final parsedJson = jsonDecode(jsonText);
              return {
                'cleaned_text':
                    parsedJson['cleaned_text']?.toString().trim() ??
                    extractedText,
                'request_text':
                    parsedJson['request_text']?.toString().trim() ??
                    extractedText,
              };
            } catch (e) {
              debugPrint('gemini json parse error: $e');
              return {
                'cleaned_text': jsonText.trim(),
                'request_text': jsonText.trim(),
              };
            }
          }
        }
        return {'cleaned_text': extractedText, 'request_text': extractedText};
      } else {
        debugPrint(
          'gemini api error: ${response.statusCode} - ${response.body}',
        );
        return {'cleaned_text': extractedText, 'request_text': extractedText};
      }
    } catch (e) {
      debugPrint('gemini api exception: $e');
      return {'cleaned_text': extractedText, 'request_text': extractedText};
    }
  }
}
