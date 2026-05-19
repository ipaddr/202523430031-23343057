import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- stream status autentikasi ---
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // --- login dengan username ---
  static Future<UserCredential> loginWithUsername({
    required String username,
    required String password,
  }) async {
    final trimmed = username.trim().toLowerCase();

    // --- cari email dari index username ---
    final doc = await _db.collection('usernames').doc(trimmed).get();
    if (!doc.exists) {
      throw Exception('Username tidak ditemukan');
    }

    final email = doc.data()?['email'] as String?;
    if (email == null) {
      throw Exception('Username tidak ditemukan');
    }

    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // --- registrasi akun baru ---
  static Future<UserCredential> register({
    required String username,
    required String displayName,
    required String password,
  }) async {
    final trimmed = username.trim().toLowerCase();

    // --- validasi format username ---
    final usernameRegex = RegExp(r'^[a-z0-9_]{3,20}$');
    if (!usernameRegex.hasMatch(trimmed)) {
      throw Exception(
        'Username hanya boleh mengandung huruf kecil, angka, dan underscore (3–20 karakter).',
      );
    }

    // --- cek ketersediaan username ---
    final existing = await _db.collection('usernames').doc(trimmed).get();
    if (existing.exists) {
      throw Exception(
        'Username "$trimmed" sudah digunakan. Pilih username lain.',
      );
    }

    // --- buat akun firebase auth ---
    final email = '$trimmed@auklus.app';
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    // --- simpan profil ke firestore ---
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'username': trimmed,
      'displayName': displayName.trim(),
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'totalDocs': 0,
    });

    // --- simpan index username ---
    await _db.collection('usernames').doc(trimmed).set({
      'uid': uid,
      'email': email,
    });

    return credential;
  }

  // --- logout ---
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // --- ambil data user dari firestore ---
  static Future<Map<String, dynamic>?> getCurrentUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  // --- stream data user realtime ---
  static Stream<Map<String, dynamic>?> userDataStream() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(null);

    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) => snap.exists ? snap.data() : null);
  }

  // --- update nama tampilan ---
  static Future<void> updateDisplayName(String newName) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Tidak ada sesi aktif.');
    if (newName.trim().isEmpty) throw Exception('Nama tidak boleh kosong.');

    await _db.collection('users').doc(uid).update({
      'displayName': newName.trim(),
    });
  }

  // --- update username ---
  static Future<void> updateUsername(String newUsername) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Tidak ada sesi aktif.');

    final trimmed = newUsername.trim().toLowerCase();

    final usernameRegex = RegExp(r'^[a-z0-9_]{3,20}$');
    if (!usernameRegex.hasMatch(trimmed)) {
      throw Exception(
        'Username hanya boleh mengandung huruf kecil, angka, dan underscore (3–20 karakter).',
      );
    }

    // --- cek ketersediaan username baru ---
    final existing = await _db.collection('usernames').doc(trimmed).get();
    if (existing.exists) {
      throw Exception('Username "$trimmed" sudah digunakan.');
    }

    // --- ambil username lama ---
    final userDoc = await _db.collection('users').doc(uid).get();
    final oldUsername = userDoc.data()?['username'] as String?;
    final newEmail = '$trimmed@auklus.app';

    // --- update email di firebase auth ---
    await _auth.currentUser!.verifyBeforeUpdateEmail(newEmail);

    // --- update data user di firestore ---
    await _db.collection('users').doc(uid).update({
      'username': trimmed,
      'email': newEmail,
    });

    // --- hapus index lama, buat index baru ---
    if (oldUsername != null) {
      await _db.collection('usernames').doc(oldUsername).delete();
    }
    await _db.collection('usernames').doc(trimmed).set({
      'uid': uid,
      'email': newEmail,
    });
  }

  // --- update password ---
  static Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Tidak ada sesi aktif.');
    if (newPassword.length < 6) {
      throw Exception('Password baru minimal 6 karakter.');
    }

    // --- re-authenticate sebelum ganti password ---
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }
}
