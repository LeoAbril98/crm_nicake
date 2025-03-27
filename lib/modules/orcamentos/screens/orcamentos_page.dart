// lib/modules/orcamentos/screens/orcamentos_page.dart
import 'package:flutter/material.dart';
import '../../../widgets/bottom_nav_bar.dart'; // Importe o BottomNavigationBar
import '../../../screens/home_content.dart'; // Importe a tela Home
import '../../clientes/screens/clientes_page.dart'; // Importe a tela Clientes
import '../../produtos/screens/produtos_page.dart'; // Importe a tela Produtos

class OrcamentosPage extends StatefulWidget {
  // Altere para StatefulWidget
  @override
  _OrcamentosPageState createState() => _OrcamentosPageState();
}

class _OrcamentosPageState extends State<OrcamentosPage> {
  final List<String> orcamentos = ['Orçamento 1', 'Orçamento 2', 'Orçamento 3'];
  int _selectedIndex = 3; // Selecionar "Orçamentos" por padrão

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
      bottomNavigationBar: CustomBottomNavigationBar(
        // Adicione o BottomNavigationBar
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegar para a página apropriada
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeContent()),
      ); // Navegar para Home
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ClientesPage()),
      ); // Navegar para Clientes
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProdutosPage()),
      ); // Navegar para Produtos
    }
    // Adicione aqui as navegações para outros índices, se necessário
  }
}
