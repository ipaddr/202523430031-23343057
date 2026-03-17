import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<User?> get user => _firebaseAuth.authStateChanges();

  // masuk dengan email dan password
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Pengguna tidak ditemukan untuk email tersebut.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Password yang dimasukkan salah.');
      }
      throw Exception(e.message ?? 'Terjadi kesalahan saat masuk.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // daftar dengan email dan password
  Future<User?> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // perbarui nama tampilan
      await userCredential.user?.updateDisplayName(name);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Password yang diberikan terlalu lemah.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Akun sudah ada untuk email tersebut.');
      }
      throw Exception(e.message ?? 'Terjadi kesalahan saat pendaftaran.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // keluar
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
