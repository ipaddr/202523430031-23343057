import 'package:flutter/material.dart';
import '../themes.dart';
import 'main_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MotifaTheme.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              
              // logo aplikasi
              Container(
                decoration: BoxDecoration(
                  color: MotifaTheme.primaryBlue,
                  border: MotifaTheme.brutalBorder,
                  boxShadow: MotifaTheme.brutalShadow,
                ),
                padding: const EdgeInsets.all(24),
                child: const Column(
                  children: [
                    Icon(
                      Icons.qr_code_scanner, 
                      size: 80, 
                      color: MotifaTheme.backgroundWhite,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Motifa',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: MotifaTheme.backgroundWhite,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 64),
              
              // teks sapaan
              const Text(
                'Selamat datang kembali!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: MotifaTheme.black,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Masuk untuk scan dan temukan motif batik yang indah.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // kolom email
              Container(
                decoration: BoxDecoration(
                  boxShadow: MotifaTheme.brutalShadowSmall,
                ),
                child: TextField(
                  decoration: MotifaTheme.brutalInputDecoration('Email'),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // kolom password
              Container(
                decoration: BoxDecoration(
                  boxShadow: MotifaTheme.brutalShadowSmall,
                ),
                child: TextField(
                  obscureText: true,
                  decoration: MotifaTheme.brutalInputDecoration('Password'),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              
              const SizedBox(height: 48),
              
              // tombol masuk
              Container(
                decoration: const BoxDecoration(
                  boxShadow: MotifaTheme.brutalShadow,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainView()),
                    );
                  },
                  style: MotifaTheme.brutalButtonStyle(),
                  child: const Text('Masuk'),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // link daftar
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Belum punya akun? Daftar",
                    style: TextStyle(
                      color: MotifaTheme.black,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
