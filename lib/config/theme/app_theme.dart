import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xff2862F5),
      textTheme: TextTheme().copyWith(titleLarge: TextStyle(fontWeight: FontWeight.w500), titleMedium: TextStyle(fontWeight: FontWeight.w500))
      // brightness: Brightness.dark

      //TODO PONER TEMA OSCURO
      );
}
