import 'package:flutter/foundation.dart';
import '../services/ml_service.dart';

enum AnalysisStatus { idle, analyzing, done, error }

class RiskClause {
  final String article;
  final String description;
  final String advice;
  final int level; // 0=aman, 1=sedang, 2=tinggi

  const RiskClause({
    required this.article,
    required this.description,
    required this.advice,
    required this.level,
  });
}

class AnalysisProvider extends ChangeNotifier {
  AnalysisStatus _status = AnalysisStatus.idle;
  String? _errorMessage;

  List<dynamic> _rawResults = [];
  List<RiskClause> _riskClauses = [];
  String _cleanedText = '';

  int _riskScore = 0;
  int _highCount = 0;
  int _mediumCount = 0;
  int _lowCount = 0;

  // --- getter ---
  AnalysisStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<dynamic> get rawResults => _rawResults;
  List<RiskClause> get riskClauses => _riskClauses;
  String get cleanedText => _cleanedText;
  int get riskScore => _riskScore;
  int get highCount => _highCount;
  int get mediumCount => _mediumCount;
  int get lowCount => _lowCount;

  bool get isAnalyzing => _status == AnalysisStatus.analyzing;
  bool get isDone => _status == AnalysisStatus.done;
  bool get hasError => _status == AnalysisStatus.error;

  // --- label risiko keseluruhan (worst clause dominates) ---
  String get riskLabel {
    if (_highCount >= 3) return 'BAHAYA';
    if (_highCount >= 1) return 'PERLU PERHATIAN';
    if (_mediumCount >= 3) return 'PERLU PERHATIAN';
    return 'AMAN';
  }

  // --- analisis klausul via ml api ---
  Future<void> analyze({
    required String requestText,
    required String cleanedText,
  }) async {
    debugPrint('=== REQUEST TEXT ===');
    debugPrint(requestText);
    debugPrint('=== END REQUEST TEXT ===');

    _status = AnalysisStatus.analyzing;
    _errorMessage = null;
    _cleanedText = cleanedText;
    _rawResults = [];
    _riskClauses = [];
    _riskScore = 0;
    _highCount = 0;
    _mediumCount = 0;
    _lowCount = 0;
    notifyListeners();

    try {
      final results = await MlService.analyzeClauses(requestText);
      _rawResults = results;
      _processResults(results);
      _status = AnalysisStatus.done;
    } catch (e) {
      _status = AnalysisStatus.error;
      _errorMessage = 'Analisis gagal: ${e.toString()}';
    }
    notifyListeners();
  }

  // --- proses hasil ml mentah ke model typed ---
  void _processResults(List<dynamic> results) {
    int totalScore = 0;
    int count = 0;

    for (final result in results) {
      final text = result['text']?.toString() ?? '';
      final label = result['label']?.toString() ?? 'clearly_fair';

      int level;
      String advice;

      if (label == 'clearly_unfair') {
        level = 2;
        _highCount++;
        advice = 'Klausul ini berisiko tinggi. Harap negosiasikan atau hapus.';
      } else if (label == 'potentially_unfair') {
        level = 1;
        _mediumCount++;
        totalScore += 1;
        advice = 'Klausul ini berpotensi merugikan. Harap minta klarifikasi.';
      } else {
        level = 0;
        _lowCount++;
        totalScore += 2;
        advice = 'Klausul ini dinilai adil.';
      }

      _riskClauses.add(
        RiskClause(
          article: '${text.split(' ').take(5).join(' ')}...',
          description: text,
          advice: advice,
          level: level,
        ),
      );
      count++;
    }

    if (count > 0) {
      _riskScore = ((totalScore / (count * 2)) * 100).toInt();
    }
  }

  // --- bangun segmen highlight untuk tampilan dokumen lengkap ---
  List<Map<String, dynamic>> buildHighlightSegments() {
    final List<Map<String, dynamic>> segments = [];
    final String text = _cleanedText;
    final List<dynamic> results = List.from(_rawResults);
    int currentIndex = 0;

    while (currentIndex < text.length) {
      int nextMatchIndex = text.length;
      dynamic bestMatch;

      for (final res in results) {
        final sentence = res['text']?.toString() ?? '';
        if (sentence.isEmpty) continue;
        final idx = text.indexOf(sentence, currentIndex);
        if (idx != -1 && idx < nextMatchIndex) {
          nextMatchIndex = idx;
          bestMatch = res;
        }
      }

      if (bestMatch != null) {
        final sentence = bestMatch['text'].toString();
        final label = bestMatch['label']?.toString() ?? 'clearly_fair';

        if (nextMatchIndex > currentIndex) {
          segments.add({
            'text': text.substring(currentIndex, nextMatchIndex),
            'label': null,
          });
        }

        segments.add({'text': sentence, 'label': label});
        currentIndex = nextMatchIndex + sentence.length;
        results.remove(bestMatch);
      } else {
        segments.add({'text': text.substring(currentIndex), 'label': null});
        break;
      }
    }

    return segments;
  }

  // --- muat data dari riwayat firestore (tanpa panggil api) ---
  void loadFromHistory({
    required String cleanedText,
    required List<dynamic> results,
    required int riskScore,
    required int highCount,
    required int mediumCount,
    required int lowCount,
  }) {
    _cleanedText = cleanedText;
    _rawResults = results;
    _riskScore = riskScore;
    _highCount = highCount;
    _mediumCount = mediumCount;
    _lowCount = lowCount;

    _riskClauses = [];
    for (final result in results) {
      final text = result['text']?.toString() ?? '';
      final label = result['label']?.toString() ?? 'clearly_fair';

      int level;
      String advice;
      if (label == 'clearly_unfair') {
        level = 2;
        advice = 'Klausul ini berisiko tinggi. Harap negosiasikan atau hapus.';
      } else if (label == 'potentially_unfair') {
        level = 1;
        advice = 'Klausul ini berpotensi merugikan. Harap minta klarifikasi.';
      } else {
        level = 0;
        advice = 'Klausul ini dinilai adil.';
      }

      _riskClauses.add(
        RiskClause(
          article: '${text.split(' ').take(5).join(' ')}...',
          description: text,
          advice: advice,
          level: level,
        ),
      );
    }

    _status = AnalysisStatus.done;
    notifyListeners();
  }

  // --- reset semua state ---
  void reset() {
    _status = AnalysisStatus.idle;
    _errorMessage = null;
    _rawResults = [];
    _riskClauses = [];
    _cleanedText = '';
    _riskScore = 0;
    _highCount = 0;
    _mediumCount = 0;
    _lowCount = 0;
    notifyListeners();
  }
}
