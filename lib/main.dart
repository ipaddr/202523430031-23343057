import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'theme.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'providers/auth_provider.dart' as app_auth;
import 'providers/document_provider.dart';
import 'providers/analysis_provider.dart';
import 'providers/history_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const AuklusApp());
}

class AuklusApp extends StatelessWidget {
  const AuklusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // --- state autentikasi ---
        ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()),
        // --- state dokumen & ocr ---
        ChangeNotifierProvider(create: (_) => DocumentProvider()),
        // --- state analisis ml ---
        ChangeNotifierProvider(create: (_) => AnalysisProvider()),
        // --- state riwayat scan ---
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: MaterialApp(
        title: 'Auklus',
        debugShowCheckedModeBanner: false,
        theme: AuklusTheme.lightTheme,
        home: const _AuthGate(),
      ),
    );
  }
}

// --- pengarah otomatis login/main berdasarkan status auth ---
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // --- menunggu firebase resolve auth ---
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashScreen();
        }

        // --- sudah login, langsung ke halaman utama ---
        if (snapshot.hasData && snapshot.data != null) {
          return const MainScreen();
        }

        // --- belum login ---
        return const LoginScreen();
      },
    );
  }
}

// --- splash singkat saat cek auth (~200ms) ---
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F2540),
      body: Center(
        child: CircularProgressIndicator(
          color: AuklusColors.accent,
          strokeWidth: 2.5,
        ),
      ),
    );
  }
}
