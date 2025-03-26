// lib/main.dart
import 'package:flutter/material.dart';
import 'modules/produtos/screens/produtos_page.dart';
import 'modules/clientes/screens/clientes_page.dart';
import 'modules/orcamentos/screens/orcamentos_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicativo de Vendas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Página Inicial')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdutosPage()),
                );
              },
              child: Text('Produtos'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientesPage()),
                );
              },
              child: Text('Clientes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrcamentosPage()),
                );
              },
              child: Text('Orçamentos'),
            ),
          ],
        ),
      ),
    );
  }
}
