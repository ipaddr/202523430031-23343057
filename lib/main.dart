import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AbsenKuApp());
}

class AbsenKuApp extends StatelessWidget {
  const AbsenKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AbsenKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
          secondary: Colors.grey[800]!,
          background: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.transparent,
        ),
        fontFamily: 'Inter', // Default fallback font
      ),
      home: const HomeScreen(),
    );
  }
}
