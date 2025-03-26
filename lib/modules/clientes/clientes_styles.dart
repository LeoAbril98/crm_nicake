// lib/modules/clientes/clientes_styles.dart
import 'package:flutter/material.dart';

class ClientesStyles {
  static TextStyle titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.pink[400],
  );

  static ElevatedButtonThemeData novoClienteButtonStyle =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[300],
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
}
