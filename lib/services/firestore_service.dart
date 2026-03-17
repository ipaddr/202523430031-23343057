import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // menyimpan data riwayat scan baru
  Future<void> saveScanHistory({
    required String uid,
    required String name,
    required String result,
    required double accuracy,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).collection('history').add({
        'name': name,
        'result': result,
        'accuracy': accuracy,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Gagal menyimpan riwayat scan: ${e.toString()}');
    }
  }

  // mendapatkan stream riwayat scan untuk seorang pengguna
  Stream<QuerySnapshot> getUserHistoryStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('history')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
