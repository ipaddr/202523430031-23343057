import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_state.dart';
import '../services/firestore_service.dart';
import '../themes.dart';
import '../utilities/dialogs/logout_dialog.dart';
import 'login_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final FirestoreService firestoreService = FirestoreService();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: MotifaTheme.lightBlue,
        appBar: AppBar(
          title: const Text(
            'PROFIL PENGGUNA',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: MotifaTheme.backgroundWhite,
            ),
          ),
          backgroundColor: MotifaTheme.primaryBlue,
          scrolledUnderElevation: 0,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3.0),
            child: Container(color: MotifaTheme.black, height: 3.0),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // header profil
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: MotifaTheme.backgroundWhite,
                  border: MotifaTheme.brutalBorder,
                  boxShadow: MotifaTheme.brutalShadow,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: MotifaTheme.yellowAccent,
                        border: MotifaTheme.brutalBorder,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: MotifaTheme.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // nama dari Firebase Auth displayName
                    Text(
                      user?.displayName ?? 'Pengguna',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // email dari Firebase Auth
                    Text(
                      user?.email ?? '-',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // statistik — total scan dari Firestore
              if (user != null)
                StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getUserHistoryStream(user.uid),
                  builder: (context, snapshot) {
                    final count =
                        snapshot.hasData ? snapshot.data!.docs.length : 0;
                    return SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: MotifaTheme.backgroundWhite,
                          border: MotifaTheme.brutalBorder,
                          boxShadow: MotifaTheme.brutalShadowSmall,
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$count',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                color: MotifaTheme.primaryBlue,
                              ),
                            ),
                            const Text(
                              'Total motif discan',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 48),

              // tombol keluar
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: const BoxDecoration(
                    boxShadow: MotifaTheme.brutalShadowSmall,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final shouldLogout = await showLogoutDialog(context);
                      if (shouldLogout && context.mounted) {
                        // Panggil AuthBloc untuk logout → state jadi Unauthenticated
                        context
                            .read<AuthBloc>()
                            .add(AuthLogoutRequested());
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Keluar'),
                    style: MotifaTheme.brutalButtonStyle(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: MotifaTheme.backgroundWhite,
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
