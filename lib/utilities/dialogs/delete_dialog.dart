import 'package:mynotes/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Hapus",
    content: "Apakah Anda yakin ingin menghapus catatan ini?",
    optionsBuilder: () => {"Batal": false, "Ya": true},
  ).then((value) => value ?? false);
}
