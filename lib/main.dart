import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/orcamento_provider.dart';
import 'modules/produtos/screens/produtos_page.dart';
import 'modules/orcamentos/screens/orcamento.dart';
import 'screens/home_content.dart';
import 'modules/clientes/screens/clientes_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => OrcamentoProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nicake Shop',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeContent(),
        '/produtos':
            (context) => ProductScreen(
              onItemTapped: (index) {
                print('Item Tapped: $index');
                // Defina como navegar para diferentes telas aqui
                if (index == 0) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeContent()),
                  );
                } else if (index == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ClientesPage()),
                  );
                }
              },
              selectedIndex: 0,
            ),
        '/orcamento': (context) => OrcamentoPage(),
        '/clientes': (context) => ClientesPage(),
      },
    );
  }
}
