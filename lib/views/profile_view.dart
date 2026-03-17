import 'package:flutter/material.dart';
import '../themes.dart';
import '../utilities/dialogs/logout_dialog.dart';
import 'login_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'johndoe@email.com',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // statistik info
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: MotifaTheme.backgroundWhite,
                  border: MotifaTheme.brutalBorder,
                  boxShadow: MotifaTheme.brutalShadowSmall,
                ),
                child: const Column(
                  children: [
                    Text(
                      '12',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: MotifaTheme.primaryBlue,
                      ),
                    ),
                    Text(
                      'Total motif discan',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                        (route) => false,
                      );
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
    );
  }
}
