// lib/core/styles.dart
import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle productTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle productPriceStyle = TextStyle(fontSize: 16);

  static const EdgeInsets productCardMargin = EdgeInsets.all(8.0);
  static const EdgeInsets productCardPadding = EdgeInsets.all(16.0);
  static const double productCardElevation = 4.0;

  static const double productGridChildAspectRatio = 0.75;
}
