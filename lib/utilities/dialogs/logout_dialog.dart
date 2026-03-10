import 'package:mynotes/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showlogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Keluar",
    content: "Apakah Anda yakin ingin keluar?",
    optionsBuilder: () => {"Batal": false, "Keluar": true},
  ).then((value) => value ?? false);
}
