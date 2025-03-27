import 'package:flutter/material.dart';
import 'package:repos/modules/clientes/screens/lista_clientes_page.dart';
import 'package:repos/modules/clientes/screens/cadastro_cliente_page.dart';
import 'package:repos/modules/clientes/clientes_styles.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../../../modules/produtos/screens/produtos_page.dart';
import '../../../modules/orcamentos/screens/orcamentos_page.dart'; // Importe a página de Orçamentos

class ClientesPage extends StatefulWidget {
  const ClientesPage({Key? key}) : super(key: key);

  @override
  _ClientesPageState createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  List<Map<String, String>> _clientes = [];
  int _selectedIndex = 1; // Selecionar "Clientes" por padrão

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Gerenciar Clientes', style: ClientesStyles.titleStyle),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => CadastroClientePage(
                            onClienteCadastrado: _adicionarCliente,
                          ),
                    );
                  },
                  style: ClientesStyles.novoClienteButtonStyle.style,
                  child: const Column(
                    children: <Widget>[
                      Icon(Icons.person_add_alt, size: 40),
                      SizedBox(height: 10),
                      Text('Novo Cliente', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ListaClientesPage(clientes: _clientes),
                      ),
                    );
                  },
                  style: ClientesStyles.novoClienteButtonStyle.style,
                  child: const Column(
                    children: <Widget>[
                      Icon(Icons.list, size: 40),
                      SizedBox(height: 10),
                      Text('Clientes', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _adicionarCliente(Map<String, String> novoCliente) {
    setState(() {
      _clientes.add(novoCliente);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegar para a página apropriada
    if (index == 0) {
      Navigator.pop(
        context,
        0,
      ); // Voltar para a tela anterior (Home) e passando o Index 0(home).
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProdutosPage()),
      ); // Navegar para Produtos
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrcamentosPage()),
      ); // Navegar para Orçamentos
    }
    // Adicione aqui as navegações para outros índices, se necessário
  }
}
