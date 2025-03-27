import 'package:flutter/material.dart';
import 'screens/home_content.dart'; // Importe a home_content separada

void main() {
  runApp(const EcommerceAppUI());
}

class EcommerceAppUI extends StatelessWidget {
  const EcommerceAppUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce UI Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeContent(),
      debugShowCheckedModeBanner: false,
    );
  }
}
