import 'package:flutter/material.dart';

void showProviderNameToast(BuildContext context, String name) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: (name != '') ? Text(name) : const Text('Proveedor desconocido'),
      duration: const Duration(seconds: 2),
    ),
  );
}
