import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_state.dart';
import '../themes.dart';
import 'main_view.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password tidak boleh kosong.')),
      );
      return;
    }

    context.read<AuthBloc>().add(
      AuthLoginRequested(email: email, password: password),
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
                    'Selamat Datang Kembali!',
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

                  // tombol masuk
                  Container(
                    decoration: const BoxDecoration(
                      boxShadow: MotifaTheme.brutalShadow,
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _onLogin,
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
                          : const Text('Masuk'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // link daftar
                  Center(
                    child: TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterView(),
                                ),
                              );
                            },
                      child: const Text(
                        'Belum punya akun? Daftar',
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
