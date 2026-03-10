import 'package:mynotes/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Berbagi',
    content:
        'Anda tidak dapat membagikan catatan kosong. Silakan tulis sesuatu untuk dibagikan.',
    optionsBuilder: () => {'OK': null},
  );
}
