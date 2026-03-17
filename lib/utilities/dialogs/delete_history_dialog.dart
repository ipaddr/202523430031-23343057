import 'package:flutter/material.dart';
import '../../themes.dart';

Future<bool> showDeleteHistoryDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: MotifaTheme.backgroundWhite,
        shape: MotifaTheme.brutalBorder,
        title: const Text(
          'Hapus Riwayat?',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: MotifaTheme.black,
            letterSpacing: 1,
          ),
        ),
        content: const Text(
          'Tindakan ini tidak dapat dibatalkan. Apakah Anda yakin?',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        actions: [
          Container(
            decoration: const BoxDecoration(
              boxShadow: MotifaTheme.brutalShadowSmall,
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              style: MotifaTheme.brutalButtonStyle(
                backgroundColor: MotifaTheme.backgroundWhite,
                foregroundColor: MotifaTheme.black,
              ),
              child: const Text('Batal'),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              boxShadow: MotifaTheme.brutalShadowSmall,
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: MotifaTheme.brutalButtonStyle(
                backgroundColor: Colors.redAccent,
                foregroundColor: MotifaTheme.backgroundWhite,
              ),
              child: const Text('Hapus'),
            ),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
