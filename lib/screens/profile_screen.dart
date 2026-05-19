import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AuklusColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(auth)),

          // --- section akun ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Akun',
                    style: AuklusTextStyles.titleMedium.copyWith(
                      color: AuklusColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _EditableMenuItem(
                    icon: Icons.person_outline,
                    label: 'Nama',
                    value: auth.displayName,
                    onEdit: () => _showEditNameDialog(context, auth),
                  ),
                  const SizedBox(height: 8),
                  _EditableMenuItem(
                    icon: Icons.alternate_email,
                    label: 'Username',
                    value: '@${auth.username}',
                    onEdit: null,
                  ),
                  const SizedBox(height: 8),
                  _EditableMenuItem(
                    icon: Icons.lock_outline,
                    label: 'Password',
                    value: '••••••••',
                    onEdit: () => _showEditPasswordDialog(context, auth),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Lainnya',
                    style: AuklusTextStyles.titleMedium.copyWith(
                      color: AuklusColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: () => _showLogoutDialog(context, auth),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AuklusColors.riskHighBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AuklusColors.riskHigh.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: AuklusColors.riskHigh,
                            size: 20,
                          ),
                          SizedBox(width: 14),
                          Text(
                            'Keluar',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AuklusColors.riskHigh,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AuklusColors.riskHigh,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- header, style sama dengan riwayat ---
  Widget _buildHeader(AuthProvider auth) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2540), Color(0xFF1A3C5E), Color(0xFF1E4976)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profil',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Kelola informasi akun Anda',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- edit nama ---
  void _showEditNameDialog(BuildContext context, AuthProvider auth) {
    _showEditDialog(
      context,
      title: 'Ubah Nama',
      label: 'Nama Lengkap',
      initialValue: auth.displayName,
      onSave: (val) async {
        final err = await auth.updateDisplayName(val);
        if (err != null && context.mounted) _showError(context, err);
      },
    );
  }

  // --- edit password, butuh password lama ---
  void _showEditPasswordDialog(BuildContext context, AuthProvider auth) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    // --- state visibility di luar statefulbuilder ---
    var obscure = [true, true, true]; // --- [current, new, confirm] ---

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Ubah Password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentCtrl,
                    obscureText: obscure[0],
                    decoration: InputDecoration(
                      labelText: 'Password Saat Ini',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure[0]
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: AuklusColors.textHint,
                        ),
                        onPressed: () =>
                            setDialogState(() => obscure[0] = !obscure[0]),
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: newCtrl,
                    obscureText: obscure[1],
                    decoration: InputDecoration(
                      labelText: 'Password Baru',
                      hintText: 'Min. 6 karakter',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure[1]
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: AuklusColors.textHint,
                        ),
                        onPressed: () =>
                            setDialogState(() => obscure[1] = !obscure[1]),
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: confirmCtrl,
                    obscureText: obscure[2],
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password Baru',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure[2]
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: AuklusColors.textHint,
                        ),
                        onPressed: () =>
                            setDialogState(() => obscure[2] = !obscure[2]),
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                Row(
                  children: [
                    Expanded(child: _cancelButton(() => Navigator.pop(ctx))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _saveButton('Simpan', () async {
                        if (newCtrl.text != confirmCtrl.text) {
                          Navigator.pop(ctx);
                          _showError(context, 'Password baru tidak cocok.');
                          return;
                        }
                        Navigator.pop(ctx);
                        final err = await auth.updatePassword(
                          currentPassword: currentCtrl.text,
                          newPassword: newCtrl.text,
                        );
                        if (err != null && context.mounted) {
                          _showError(context, err);
                        }
                      }),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- dialog edit generik ---
  void _showEditDialog(
    BuildContext context, {
    required String title,
    required String label,
    required String initialValue,
    String? hint,
    required Future<void> Function(String) onSave,
  }) {
    final ctrl = TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(child: _cancelButton(() => Navigator.pop(ctx))),
              const SizedBox(width: 12),
              Expanded(
                child: _saveButton('Simpan', () async {
                  final val = ctrl.text.trim();
                  Navigator.pop(ctx);
                  await onSave(val);
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- dialog logout ---
  void _showLogoutDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Keluar',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar?',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(child: _cancelButton(() => Navigator.pop(ctx))),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await auth.logout();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (_) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AuklusColors.riskHigh,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Keluar',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Poppins')),
        backgroundColor: AuklusColors.riskHigh,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // --- widget tombol reusable ---
  Widget _cancelButton(VoidCallback onPressed) => SizedBox(
    height: 48,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AuklusColors.textSecondary,
        side: const BorderSide(color: Color(0xFFCFD8DC)),
        backgroundColor: const Color(0xFFF5F5F5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Batal',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),
  );

  Widget _saveButton(String label, VoidCallback onPressed) => SizedBox(
    height: 48,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AuklusColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),
  );
}

// --- widget bersama ---
class _EditableMenuItem extends StatelessWidget {
  const _EditableMenuItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.onEdit,
  });
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onEdit; // --- null berarti disabled ---

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AuklusColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AuklusColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AuklusColors.primary),
          const SizedBox(width: 14),
          Text(label, style: AuklusTextStyles.bodyMedium),
          const Spacer(),
          Text(value, style: AuklusTextStyles.titleMedium),
          if (onEdit != null) ...[
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onEdit,
              child: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: AuklusColors.textHint,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
