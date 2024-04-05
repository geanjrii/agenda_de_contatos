import 'package:flutter/material.dart';

class DiscardChangesDialog {
  static Future<bool> showDiscardChangesDialog(
      BuildContext context, bool userEdited) async {
    if (userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Descartar Alterações?'),
            content: const Text('Se sair, as alterações serão perdidas'),
            actions: [
              TextButton(
                child: const Text(
                  'Sair',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
