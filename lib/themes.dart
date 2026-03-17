import 'package:flutter/material.dart';

class MotifaTheme {
  // Warna
  static const Color primaryBlue = Color(0xFF2563EB); // Vibrant blue
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  static const Color lightBlue = Color(0xFFDBEAFE);
  static const Color yellowAccent = Color(0xFFFDE047);

  // Border
  static final Border brutalBorder = Border.all(
    color: black,
    width: 3.0,
  );

  // Bayangan
  static const List<BoxShadow> brutalShadow = [
    BoxShadow(
      color: black,
      offset: Offset(4, 4),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];
  
  static const List<BoxShadow> brutalShadowSmall = [
    BoxShadow(
      color: black,
      offset: Offset(2, 2),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];

  // Gaya Tombol
  static ButtonStyle brutalButtonStyle({
    Color backgroundColor = primaryBlue,
    Color foregroundColor = backgroundWhite,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      side: const BorderSide(color: black, width: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 16,
        letterSpacing: 1,
      ),
    ).copyWith(
      overlayColor: MaterialStateProperty.all(black.withOpacity(0.1)),
    );
  }

  // Gaya Input
  static InputDecoration brutalInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: black, width: 3),
        borderRadius: BorderRadius.zero,
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryBlue, width: 3),
        borderRadius: BorderRadius.zero,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
