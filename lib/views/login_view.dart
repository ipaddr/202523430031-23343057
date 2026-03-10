import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            showErrorDialog(
              context,
              'Pengguna tidak ditemukan dengan kredensial yang dimasukkan!',
            );
          } else if (state.exception is WrongPasswordAuthException) {
            showErrorDialog(context, 'Kredensial salah');
          } else if (state.exception is GenericAuthException) {
            showErrorDialog(context, 'Kesalahan autentikasi');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Masuk')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Silakan masuk ke akun Anda agar dapat berinteraksi dan membuat catatan.',
              ),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Masukkan email Anda di sini',
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'Masukkan kata sandi Anda di sini',
                ),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text.trim();
                  final password = _password.text.trim();
                  context.read<AuthBloc>().add(
                    AuthEventLogin(email: email, password: password),
                  );
                },
                child: const Text('Masuk'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventForgotPassword());
                },
                child: const Text('Lupa kata sandi?'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
                },
                child: const Text('Belum terdaftar? Daftar di sini!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
