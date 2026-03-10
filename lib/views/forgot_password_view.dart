import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/dialogs/password_reset_email_sent_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
              context,
              'Kami tidak dapat memproses permintaan Anda. Pastikan Anda adalah pengguna terdaftar, atau jika tidak, daftar sekarang dengan kembali ke langkah sebelumnya.',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Lupa Kata Sandi')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Jika Anda lupa kata sandi, cukup masukkan email Anda dan kami akan mengirimkan tautan atur ulang kata sandi.',
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Alamat email Anda...',
                ),
              ),
              TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context.read<AuthBloc>().add(
                    AuthEventForgotPassword(email: email),
                  );
                },
                child: const Text('Kirimkan tautan atur ulang kata sandi'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthEventLogout());
                },
                child: const Text('Kembali ke halaman masuk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
