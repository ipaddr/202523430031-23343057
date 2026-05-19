import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../services/gemini_service.dart';

enum DocumentStatus { idle, extracting, cleaning, ready, error }

class DocumentProvider extends ChangeNotifier {
  DocumentStatus _status = DocumentStatus.idle;
  String? _errorMessage;
  String _extractedText = '';
  String _cleanedText = '';
  String _requestText = '';
  String _fileName = 'Dokumen';

  // --- getter ---
  DocumentStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get extractedText => _extractedText;
  String get cleanedText => _cleanedText;
  String get requestText => _requestText;
  String get fileName => _fileName;

  bool get isExtracting => _status == DocumentStatus.extracting;
  bool get isCleaning => _status == DocumentStatus.cleaning;
  bool get isReady => _status == DocumentStatus.ready;
  bool get hasError => _status == DocumentStatus.error;

  String get statusMessage {
    switch (_status) {
      case DocumentStatus.extracting:
        return 'Mengekstrak teks...';
      case DocumentStatus.cleaning:
        return 'Membersihkan teks dengan AI...';
      default:
        return '';
    }
  }

  // --- proses gambar (kamera / galeri) ---
  Future<void> processImage(ImageSource source) async {
    _setStatus(DocumentStatus.extracting);

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile == null) {
        _setStatus(DocumentStatus.idle);
        return;
      }

      _fileName = pickedFile.name.isNotEmpty
          ? pickedFile.name
          : 'Foto_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );
      final recognized = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      _extractedText = recognized.text;
      await _cleanWithGemini();
    } catch (e) {
      _setError('Gagal mengekstrak gambar: ${e.toString()}');
    }
  }

  // --- proses pdf ---
  Future<void> processPdf() async {
    _setStatus(DocumentStatus.extracting);

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.single.path == null) {
        _setStatus(DocumentStatus.idle);
        return;
      }

      _fileName = result.files.single.name;

      final file = File(result.files.single.path!);
      final document = PdfDocument(inputBytes: await file.readAsBytes());
      _extractedText = PdfTextExtractor(document).extractText();
      document.dispose();

      await _cleanWithGemini();
    } catch (e) {
      _setError('Gagal membaca PDF: ${e.toString()}');
    }
  }

  // --- bersihkan teks dengan gemini ---
  Future<void> _cleanWithGemini() async {
    _setStatus(DocumentStatus.cleaning);
    try {
      final result = await GeminiService.cleanText(_extractedText);
      _cleanedText = result['cleaned_text'] ?? _extractedText;
      _requestText = result['request_text'] ?? _extractedText;
      _setStatus(DocumentStatus.ready);
    } catch (e) {
      _setError('Gagal membersihkan teks: ${e.toString()}');
    }
  }

  // --- reset state untuk scan baru ---
  void reset() {
    _status = DocumentStatus.idle;
    _errorMessage = null;
    _extractedText = '';
    _cleanedText = '';
    _requestText = '';
    _fileName = 'Dokumen';
    notifyListeners();
  }

  // --- helper privat ---
  void _setStatus(DocumentStatus status) {
    _status = status;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = DocumentStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}
