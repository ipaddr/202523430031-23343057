import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Atur Ulang Kata Sandi',
    content:
        'Kami telah mengirimkan tautan pengaturan ulang kata sandi ke email Anda. Silakan periksa email Anda untuk informasi lebih lanjut.',
    optionsBuilder: () => {'OK': null},
  );
}
