// lib/modules/orcamentos/screens/orcamentos_page.dart
import 'package:flutter/material.dart';

class OrcamentosPage extends StatelessWidget {
  final List<String> orcamentos = ['Orçamento 1', 'Orçamento 2', 'Orçamento 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orçamentos')),
      body: ListView.builder(
        itemCount: orcamentos.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(orcamentos[index]));
        },
      ),
    );
  }
}
