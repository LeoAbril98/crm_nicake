// lib/modules/clientes/screens/clientes_page.dart
import 'package:flutter/material.dart';
import '../clientes_styles.dart';
import 'lista_clientes_page.dart';
import 'cadastro_cliente_page.dart'; // Importe a nova página

class ClientesPage extends StatefulWidget {
  @override
  _ClientesPageState createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  List<Map<String, String>> _clientes = [];

  void _adicionarCliente(Map<String, String> novoCliente) {
    setState(() {
      _clientes.add(novoCliente);
    });
  }

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
            SizedBox(height: 20),
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
                  child: Column(
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
                  child: Column(
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
    );
  }
}
