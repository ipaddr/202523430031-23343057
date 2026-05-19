import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/auth_provider.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  void _navigateToMain() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, b) => const MainScreen(),
        transitionsBuilder: (_, a, b, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // --- header biru ---
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2540),
                  Color(0xFF1A3C5E),
                  Color(0xFF2563A8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 40, 28, 36),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AuklusColors.accent, AuklusColors.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AuklusColors.accent.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icon/appicon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Auklus',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Analisis Risiko Kontrak Berbasis AI',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Color(0xAAFFFFFF),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- card putih ---
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: AuklusColors.surface),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  children: [
                    // --- tab switcher ---
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AuklusColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TabBar(
                        controller: _tabCtrl,
                        indicator: BoxDecoration(
                          color: AuklusColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: Colors.white,
                        unselectedLabelColor: AuklusColors.textSecondary,
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: const [
                          Tab(text: 'Masuk'),
                          Tab(text: 'Daftar'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // --- form login/daftar ---
                    _UnifiedForm(
                      isRegister: _tabCtrl.index == 1,
                      onSuccess: _navigateToMain,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- form unified, field muncul/hilang dengan slide ---
class _UnifiedForm extends StatefulWidget {
  const _UnifiedForm({required this.isRegister, required this.onSuccess});
  final bool isRegister;
  final VoidCallback onSuccess;

  @override
  State<_UnifiedForm> createState() => _UnifiedFormState();
}

class _UnifiedFormState extends State<_UnifiedForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  static const _duration = Duration(milliseconds: 300);
  static const _curve = Curves.easeInOut;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    auth.clearError();

    final bool success;
    if (widget.isRegister) {
      success = await auth.register(
        username: _usernameCtrl.text.trim(),
        displayName: _nameCtrl.text.trim(),
        password: _passCtrl.text,
      );
    } else {
      success = await auth.login(
        username: _usernameCtrl.text.trim(),
        password: _passCtrl.text,
      );
    }
    if (success && mounted) widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isRegister = widget.isRegister;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- nama lengkap, slide dari atas ---
          _SlideField(
            visible: isRegister,
            slideFrom: _SlideDirection.top,
            duration: _duration,
            curve: _curve,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => auth.clearError(),
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    hintText: 'Masukkan nama lengkap',
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      color: AuklusColors.textHint,
                      size: 20,
                    ),
                  ),
                  validator: isRegister
                      ? (v) => (v == null || v.trim().isEmpty)
                            ? 'Nama diperlukan'
                            : null
                      : null,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // --- username, selalu tampil ---
          TextFormField(
            controller: _usernameCtrl,
            textInputAction: TextInputAction.next,
            onChanged: (_) => auth.clearError(),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
            ],
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: isRegister ? 'contoh: ghazian_01' : 'Masukkan username',
              prefixIcon: const Icon(
                Icons.alternate_email,
                color: AuklusColors.textHint,
                size: 20,
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Username diperlukan';
              if (isRegister && v.trim().length < 3)
                return 'Minimal 3 karakter';
              if (isRegister && v.trim().length > 20)
                return 'Maksimal 20 karakter';
              return null;
            },
          ),
          const SizedBox(height: 14),

          // --- kata sandi, selalu tampil ---
          TextFormField(
            controller: _passCtrl,
            obscureText: _obscurePass,
            textInputAction: isRegister
                ? TextInputAction.next
                : TextInputAction.done,
            onFieldSubmitted: isRegister ? null : (_) => _submit(),
            onChanged: (_) => auth.clearError(),
            decoration: InputDecoration(
              labelText: 'Kata Sandi',
              hintText: isRegister ? 'Min. 6 karakter' : '••••••••',
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AuklusColors.textHint,
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePass
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AuklusColors.textHint,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscurePass = !_obscurePass),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Kata sandi diperlukan';
              if (isRegister && v.length < 6) return 'Minimal 6 karakter';
              return null;
            },
          ),

          // --- konfirmasi kata sandi, slide dari bawah ---
          _SlideField(
            visible: isRegister,
            slideFrom: _SlideDirection.bottom,
            duration: _duration,
            curve: _curve,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Kata Sandi',
                    hintText: 'Ulangi kata sandi',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AuklusColors.textHint,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AuklusColors.textHint,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: isRegister
                      ? (v) {
                          if (v == null || v.isEmpty) {
                            return 'Konfirmasi diperlukan';
                          }
                          if (v != _passCtrl.text) {
                            return 'Kata sandi tidak cocok';
                          }
                          return null;
                        }
                      : null,
                ),
              ],
            ),
          ),

          // --- banner error ---
          if (auth.errorMessage != null) ...[
            const SizedBox(height: 12),
            _ErrorBanner(message: auth.errorMessage!),
          ],

          const SizedBox(height: 24),

          // --- tombol submit ---
          _GradientButton(
            label: isRegister ? 'Daftar Akun' : 'Masuk',
            isLoading: auth.isLoading,
            onTap: auth.isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }
}

// --- widget slide field ---
enum _SlideDirection { top, bottom }

class _SlideField extends StatefulWidget {
  const _SlideField({
    required this.visible,
    required this.slideFrom,
    required this.child,
    required this.duration,
    required this.curve,
  });
  final bool visible;
  final _SlideDirection slideFrom;
  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  State<_SlideField> createState() => _SlideFieldState();
}

class _SlideFieldState extends State<_SlideField>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.visible ? 1.0 : 0.0,
    );
    _slideAnim = CurvedAnimation(parent: _ctrl, curve: widget.curve);
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: widget.curve);
  }

  @override
  void didUpdateWidget(_SlideField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _ctrl.forward();
      } else {
        _ctrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTop = widget.slideFrom == _SlideDirection.top;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        // --- hidden: slide ke asal, visible: posisi normal ---
        final slideOffset = (1.0 - _slideAnim.value);
        final dy = isTop ? -slideOffset : slideOffset;

        return ClipRect(
          child: Align(
            heightFactor: _slideAnim.value,
            child: FractionalTranslation(
              translation: Offset(0, dy),
              child: Opacity(opacity: _fadeAnim.value, child: child),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

// --- widget bersama ---
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AuklusColors.riskHighBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AuklusColors.riskHigh,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AuklusColors.riskHigh,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: onTap != null
              ? AuklusColors.accentGradient
              : const LinearGradient(
                  colors: [Color(0xFFB0BEC5), Color(0xFF90A4AE)],
                ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: onTap != null
              ? [
                  BoxShadow(
                    color: AuklusColors.primary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}
