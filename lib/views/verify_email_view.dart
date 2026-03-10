import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verifikasi Email')),
      body: Column(
        children: [
          const Text(
            'Kami telah mengirimkan email verifikasi, silakan buka untuk memverifikasi akun Anda',
          ),
          const Text(
            'Jika Anda belum menerima email verifikasi, tekan tombol di bawah ini',
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(
                const AuthEventSendEmailVerification(),
              );
            },
            child: const Text('Kirim verifikasi email'),
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(const AuthEventLogout());
            },
            child: const Text('Mulai ulang'),
          ),
        ],
      ),
    );
  }
}
