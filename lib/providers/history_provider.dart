import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum HistoryStatus { idle, loading, loaded, error }

class ScanHistoryItem {
  final String id;
  final String fileName;
  final int riskLevel; // 0=rendah, 1=sedang, 2=tinggi
  final int riskScore;
  final int highCount;
  final int mediumCount;
  final int lowCount;
  final DateTime createdAt;

  const ScanHistoryItem({
    required this.id,
    required this.fileName,
    required this.riskLevel,
    required this.riskScore,
    required this.highCount,
    required this.mediumCount,
    required this.lowCount,
    required this.createdAt,
  });

  String get riskLabel {
    switch (riskLevel) {
      case 2:
        return 'Tinggi';
      case 1:
        return 'Sedang';
      default:
        return 'Rendah';
    }
  }

  factory ScanHistoryItem.fromFirestore(String id, Map<String, dynamic> data) {
    final ts = data['createdAt'];
    return ScanHistoryItem(
      id: id,
      fileName: data['fileName'] as String? ?? 'Dokumen',
      riskLevel: data['riskLevel'] as int? ?? 0,
      riskScore: data['riskScore'] as int? ?? 0,
      highCount: data['highCount'] as int? ?? 0,
      mediumCount: data['mediumCount'] as int? ?? 0,
      lowCount: data['lowCount'] as int? ?? 0,
      createdAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
    );
  }
}

class HistoryProvider extends ChangeNotifier {
  HistoryStatus _status = HistoryStatus.idle;
  String? _errorMessage;
  List<ScanHistoryItem> _history = [];
  String _filterSelected = 'Semua';

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // --- getter ---
  HistoryStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get filterSelected => _filterSelected;
  bool get isLoading => _status == HistoryStatus.loading;

  List<ScanHistoryItem> get history {
    if (_filterSelected == 'Semua') return _history;
    return _history.where((h) => h.riskLabel == _filterSelected).toList();
  }

  int get highCount => _history.where((h) => h.riskLevel == 2).length;
  int get mediumCount => _history.where((h) => h.riskLevel == 1).length;
  int get lowCount => _history.where((h) => h.riskLevel == 0).length;
  int get totalCount => _history.length;

  // --- muat riwayat dari firestore (query by prefix id) ---
  Future<void> loadHistory() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _status = HistoryStatus.loading;
    notifyListeners();

    try {
      final snapshot = await _db
          .collection('scans')
          .orderBy(FieldPath.documentId)
          .startAt(['${uid}_'])
          .endAt(['${uid}_\uf8ff'])
          .get();

      final items = snapshot.docs
          .map((doc) => ScanHistoryItem.fromFirestore(doc.id, doc.data()))
          .toList();

      // urutkan terbaru dulu di sisi client
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _history = items;
      _status = HistoryStatus.loaded;
    } catch (e) {
      _status = HistoryStatus.error;
      _errorMessage = 'Gagal memuat riwayat: ${e.toString()}';
      debugPrint('loadHistory error: $e');
    }
    notifyListeners();
  }

  // --- simpan hasil scan baru ke firestore (id: uid_xxx) ---
  Future<void> saveScan({
    required String fileName,
    required int riskLevel,
    required int riskScore,
    required int highCount,
    required int mediumCount,
    required int lowCount,
    required String cleanedText,
    required List<dynamic> results,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      // ambil totalDocs untuk generate nomor urut
      final userDoc = await _db.collection('users').doc(uid).get();
      final currentTotal = (userDoc.data()?['totalDocs'] as int?) ?? 0;
      final nextNumber = currentTotal + 1;
      final numberStr = nextNumber.toString().padLeft(3, '0');
      final scanId = '${uid}_$numberStr';

      await _db.collection('scans').doc(scanId).set({
        'userId': uid,
        'fileName': fileName,
        'riskLevel': riskLevel,
        'riskScore': riskScore,
        'highCount': highCount,
        'mediumCount': mediumCount,
        'lowCount': lowCount,
        'cleanedText': cleanedText,
        'results': results,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // update counter di profil user
      await _db.collection('users').doc(uid).update({
        'totalDocs': FieldValue.increment(1),
      });

      await loadHistory();
    } catch (e) {
      debugPrint('saveScan error: $e');
    }
  }

  // --- set filter aktif ---
  void setFilter(String filter) {
    if (_filterSelected != filter) {
      _filterSelected = filter;
      notifyListeners();
    }
  }

  // --- hapus scan dari firestore ---
  Future<void> deleteScan(String scanId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await _db.collection('scans').doc(scanId).delete();

      await _db.collection('users').doc(uid).update({
        'totalDocs': FieldValue.increment(-1),
      });

      _history.removeWhere((item) => item.id == scanId);
      notifyListeners();
    } catch (e) {
      debugPrint('deleteScan error: $e');
    }
  }
}
