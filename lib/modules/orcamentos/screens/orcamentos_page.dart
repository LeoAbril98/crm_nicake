import 'package:flutter/material.dart';
import '../../../widgets/bottom_nav_bar.dart'; // Bottom Navigation Bar
import '../../../screens/home_content.dart'; // Tela Home
import '../../clientes/screens/clientes_page.dart'; // Tela Clientes
import '../../produtos/screens/produtos_page.dart'; // Tela Produtos

class OrcamentosPage extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const OrcamentosPage({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _OrcamentosPageState createState() => _OrcamentosPageState();
}

class _OrcamentosPageState extends State<OrcamentosPage> {
  final List<String> orcamentos = ['Orçamento 1', 'Orçamento 2', 'Orçamento 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orçamentos')),
      body: ListView.builder(
        itemCount: orcamentos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(orcamentos[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  orcamentos.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _criarNovoOrcamento();
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: widget.selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _criarNovoOrcamento() {
    setState(() {
      orcamentos.add('Orçamento ${orcamentos.length + 1}');
    });
  }

  void _onItemTapped(int index) {
    widget.onItemTapped(index);

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
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => ProductScreen(
                selectedIndex: index,
                onItemTapped: _onItemTapped,
              ),
        ),
      );
    }
  }
}
