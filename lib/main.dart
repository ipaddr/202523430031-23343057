import 'package:flutter/material.dart';
import 'themes.dart';
import 'views/login_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motifa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: MotifaTheme.backgroundWhite,
        colorScheme: ColorScheme.fromSeed(seedColor: MotifaTheme.primaryBlue),
        useMaterial3: true,
      ),
      home: const LoginView(),
    );
  }
}
