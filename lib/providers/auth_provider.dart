import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  Map<String, dynamic>? _userData;

  // --- getter ---
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;

  String get displayName => _userData?['displayName'] as String? ?? 'Pengguna';
  String get username => _userData?['username'] as String? ?? '-';
  int get totalDocs => _userData?['totalDocs'] as int? ?? 0;

  bool get isLoading => _status == AuthStatus.loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // --- inisial avatar dari displayName (maks 2 huruf) ---
  String get initials => displayName
      .trim()
      .split(' ')
      .where((w) => w.isNotEmpty)
      .take(2)
      .map((w) => w[0].toUpperCase())
      .join();

  // --- listener auth stream firebase ---
  AuthProvider() {
    AuthService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user == null) {
      _status = AuthStatus.unauthenticated;
      _userData = null;
    } else {
      _userData = await AuthService.getCurrentUserData();
      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }

  // --- login ---
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _setLoading();
    try {
      await AuthService.loginWithUsername(
        username: username,
        password: password,
      );
      return true;
    } catch (e) {
      _setError(_parseAuthError(e.toString()));
      return false;
    }
  }

  // --- register ---
  Future<bool> register({
    required String username,
    required String displayName,
    required String password,
  }) async {
    _setLoading();
    try {
      await AuthService.register(
        username: username,
        displayName: displayName,
        password: password,
      );
      return true;
    } catch (e) {
      _setError(_parseAuthError(e.toString()));
      return false;
    }
  }

  // --- logout ---
  Future<void> logout() async {
    await AuthService.logout();
  }

  // --- update nama tampilan ---
  Future<String?> updateDisplayName(String newName) async {
    try {
      await AuthService.updateDisplayName(newName);
      _userData = {...?_userData, 'displayName': newName.trim()};
      notifyListeners();
      return null;
    } catch (e) {
      return _parseAuthError(e.toString());
    }
  }

  // --- update username ---
  Future<String?> updateUsername(String newUsername) async {
    try {
      await AuthService.updateUsername(newUsername);
      final trimmed = newUsername.trim().toLowerCase();
      _userData = {
        ...?_userData,
        'username': trimmed,
        'email': '$trimmed@auklus.app',
      };
      notifyListeners();
      return null;
    } catch (e) {
      return _parseAuthError(e.toString());
    }
  }

  // --- update password ---
  Future<String?> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await AuthService.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return null;
    } catch (e) {
      return _parseAuthError(e.toString());
    }
  }

  // --- hapus error saat user mulai mengetik ---
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // --- helper privat ---
  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  // --- parsing pesan error firebase ---
  String _parseAuthError(String raw) {
    if (raw.contains('Username tidak ditemukan')) {
      return 'Username tidak ditemukan.';
    }
    if (raw.contains('sudah digunakan')) return raw.split('Exception: ').last;
    if (raw.contains('hanya boleh')) return raw.split('Exception: ').last;
    if (raw.contains('wrong-password') || raw.contains('invalid-credential')) {
      return 'Username atau kata sandi salah.';
    }
    if (raw.contains('weak-password')) {
      return 'Kata sandi terlalu lemah (min. 6 karakter).';
    }
    if (raw.contains('too-many-requests')) {
      return 'Terlalu banyak percobaan. Coba lagi nanti.';
    }
    if (raw.contains('network-request-failed')) {
      return 'Tidak ada koneksi internet.';
    }
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}
