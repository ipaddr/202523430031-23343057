import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_state.dart';
import '../themes.dart';
import 'main_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom wajib diisi.')),
      );
      return;
    }

    context.read<AuthBloc>().add(
      AuthRegisterRequested(name: name, email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainView()),
            (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
        // Kalau berhasil daftar (state Authenticated), MainApp akan otomatis
        // mengarahkan ke MainView lewat BlocBuilder di main.dart
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: MotifaTheme.backgroundWhite,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // logo aplikasi
                  Container(
                    decoration: BoxDecoration(
                      color: MotifaTheme.primaryBlue,
                      border: MotifaTheme.brutalBorder,
                      boxShadow: MotifaTheme.brutalShadow,
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Image.asset('assets/images/logo.png', height: 80),
                        const SizedBox(height: 16),
                        const Text(
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
                    'Buat Akun Baru',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: MotifaTheme.black,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Bergabunglah untuk mulai memindai dan menyimpan riwayat motif batikmu.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // kolom nama
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: MotifaTheme.brutalShadowSmall,
                    ),
                    child: TextField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: MotifaTheme.brutalInputDecoration(
                        'Nama Lengkap',
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // kolom email
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: MotifaTheme.brutalShadowSmall,
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
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
                      controller: _passwordController,
                      obscureText: true,
                      decoration: MotifaTheme.brutalInputDecoration('Password'),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // tombol daftar
                  Container(
                    decoration: const BoxDecoration(
                      boxShadow: MotifaTheme.brutalShadow,
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _onRegister,
                      style: MotifaTheme.brutalButtonStyle(),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: MotifaTheme.backgroundWhite,
                              ),
                            )
                          : const Text('Daftar'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // link masuk
                  Center(
                    child: TextButton(
                      onPressed: isLoading
                          ? null
                          : () => Navigator.pop(context),
                      child: const Text(
                        'Sudah punya akun? Masuk',
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
      },
    );
  }
}
