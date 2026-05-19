import 'package:flutter/material.dart';

// --- palet warna ---
class AuklusColors {
  AuklusColors._();

  // --- warna utama ---
  static const Color primary = Color(0xFF1A3C5E);
  static const Color primaryLight = Color(0xFF2563A8);
  static const Color primaryDark = Color(0xFF0F2540);
  static const Color accent = Color(0xFF00C2A8);
  static const Color accentLight = Color(0xFF4DD9C9);
  static const Color accentDark = Color(0xFF009688);

  // --- latar belakang ---
  static const Color background = Color(0xFFF4F6FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEEF2F9);

  // --- warna risiko ---
  static const Color riskHigh = Color(0xFFE53935);
  static const Color riskHighBg = Color(0xFFFFEBEE);
  static const Color riskMedium = Color(0xFFFB8C00);
  static const Color riskMediumBg = Color(0xFFFFF3E0);
  static const Color riskLow = Color(0xFF43A047);
  static const Color riskLowBg = Color(0xFFE8F5E9);

  // --- teks ---
  static const Color textPrimary = Color(0xFF0F1F33);
  static const Color textSecondary = Color(0xFF5A708A);
  static const Color textHint = Color(0xFF9EB3C7);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // --- garis & border ---
  static const Color divider = Color(0xFFDDE4EF);
  static const Color border = Color(0xFFCDD8E8);

  // --- gradient ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1A3C5E), Color(0xFF2563A8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00C2A8), Color(0xFF2563A8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E4976), Color(0xFF163558)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// --- tipografi ---
class AuklusTextStyles {
  AuklusTextStyles._();

  static const String fontFamily = 'Poppins';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AuklusColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AuklusColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AuklusColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AuklusColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AuklusColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AuklusColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AuklusColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AuklusColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AuklusColors.textHint,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AuklusColors.primary,
    letterSpacing: 0.5,
  );
}

// --- tema aplikasi ---
class AuklusTheme {
  AuklusTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AuklusTextStyles.fontFamily,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AuklusColors.primary,
        onPrimary: AuklusColors.textOnPrimary,
        primaryContainer: AuklusColors.surfaceVariant,
        onPrimaryContainer: AuklusColors.primary,
        secondary: AuklusColors.accent,
        onSecondary: AuklusColors.textOnPrimary,
        secondaryContainer: AuklusColors.accentLight.withValues(alpha: 0.2),
        onSecondaryContainer: AuklusColors.accentDark,
        tertiary: AuklusColors.primaryLight,
        onTertiary: AuklusColors.textOnPrimary,
        tertiaryContainer: AuklusColors.primaryLight.withValues(alpha: 0.15),
        onTertiaryContainer: AuklusColors.primaryDark,
        error: AuklusColors.riskHigh,
        onError: AuklusColors.textOnPrimary,
        errorContainer: AuklusColors.riskHighBg,
        onErrorContainer: AuklusColors.riskHigh,
        surface: AuklusColors.surface,
        onSurface: AuklusColors.textPrimary,
        onSurfaceVariant: AuklusColors.textSecondary,
        outline: AuklusColors.border,
        outlineVariant: AuklusColors.divider,
        shadow: Colors.black12,
        scrim: Colors.black54,
        inverseSurface: AuklusColors.primaryDark,
        onInverseSurface: AuklusColors.textOnPrimary,
        inversePrimary: AuklusColors.accentLight,
      ),
      scaffoldBackgroundColor: AuklusColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: AuklusTextStyles.fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AuklusColors.textPrimary,
        ),
        iconTheme: IconThemeData(color: AuklusColors.textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AuklusColors.surface,
        selectedItemColor: AuklusColors.primary,
        unselectedItemColor: AuklusColors.textHint,
        selectedLabelStyle: TextStyle(
          fontFamily: AuklusTextStyles.fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AuklusTextStyles.fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AuklusColors.primary,
          foregroundColor: AuklusColors.textOnPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: AuklusTextStyles.fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AuklusColors.primary,
          side: const BorderSide(color: AuklusColors.primary, width: 1.5),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: AuklusTextStyles.fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AuklusColors.primary,
          textStyle: const TextStyle(
            fontFamily: AuklusTextStyles.fontFamily,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AuklusColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AuklusColors.divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AuklusColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AuklusColors.riskHigh, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(
          fontFamily: AuklusTextStyles.fontFamily,
          fontSize: 14,
          color: AuklusColors.textHint,
        ),
        labelStyle: const TextStyle(
          fontFamily: AuklusTextStyles.fontFamily,
          fontSize: 14,
          color: AuklusColors.textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AuklusColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AuklusColors.divider, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: AuklusColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
