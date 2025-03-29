import 'package:flutter/material.dart';

class ProdutoLinhaTradicionalStyles {
  static const Color backgroundGray = Color(0xFFF5F5F5);
  static const Color primaryGreen = Color(0xFF113f3e);

  static TextStyle productNameTextStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle descriptionTextStyle = const TextStyle(
    color: Colors.black54,
  );

  static TextStyle totalTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
  );

  static TextStyle flavorHeaderTextStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static TextStyle clearButtonStyle = const TextStyle(color: Colors.red);

  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryGreen,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  );

  static ButtonStyle disabledButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.grey,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  );

  static ButtonStyle selectedLineButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryGreen,
  );

  static ButtonStyle unselectedLineButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.grey,
  );

  static ButtonStyle outlinedSizeButtonStyle(bool isSelected) {
    return OutlinedButton.styleFrom(
      side: BorderSide(color: isSelected ? primaryGreen : Colors.grey.shade400),
      backgroundColor:
          isSelected ? primaryGreen.withOpacity(0.1) : Colors.transparent,
    );
  }

  static TextStyle outlinedSizeButtonTextStyle(bool isSelected) {
    return TextStyle(color: isSelected ? primaryGreen : Colors.grey.shade700);
  }
}
