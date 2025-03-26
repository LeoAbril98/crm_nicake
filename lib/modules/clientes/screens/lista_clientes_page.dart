// lib/modules/clientes/screens/lista_clientes_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ListaClientesPage extends StatefulWidget {
  final List<Map<String, String>> clientes;

  ListaClientesPage({required this.clientes});

  @override
  _ListaClientesPageState createState() => _ListaClientesPageState();
}

class _ListaClientesPageState extends State<ListaClientesPage> {
  List<Map<String, String>> _clientesExibidos = [];
  String _filtro = ''; // Campo único de filtro geral
  int? _filtroMesAniversario;
  String? _filtroComoConheceu;

  List<String> _opcoesComoConheceu = [
    'Indicação',
    'Redes Sociais',
    'Google',
    'Anúncio',
    'Outros',
  ];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null).then((_) {
      _atualizarListaExibida();
    });
  }

  void _atualizarListaExibida() {
    List<Map<String, String>> clientesFiltrados =
        widget.clientes.where((cliente) {
          bool filtroGeralValido = cliente.values.any(
            (value) => value.toLowerCase().contains(_filtro.toLowerCase()),
          );

          bool filtroAniversarioValido =
              _filtroMesAniversario == null ||
              (cliente['aniversario'] != null &&
                  DateTime.parse(
                        DateFormat('yyyy-MM-dd').format(
                          DateFormat(
                            'dd/MM/yyyy',
                          ).parse(cliente['aniversario']!),
                        ),
                      ).month ==
                      _filtroMesAniversario);
          bool filtroComoConheceuValido =
              _filtroComoConheceu == null ||
              cliente['comoConheceu'] == _filtroComoConheceu;

          return filtroGeralValido &&
              filtroAniversarioValido &&
              filtroComoConheceuValido;
        }).toList();

    clientesFiltrados.sort(
      (a, b) => (a['nome'] ?? '').compareTo(b['nome'] ?? ''),
    );

    setState(() {
      _clientesExibidos = clientesFiltrados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Clientes'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _mostrarFiltros(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _filtro = value;
                  _atualizarListaExibida();
                });
              },
              decoration: InputDecoration(
                labelText: 'Buscar',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _clientesExibidos.length,
              itemBuilder: (context, index) {
                final cliente = _clientesExibidos[index];
                return ListTile(
                  title: Text(cliente['nome'] ?? 'Nome não disponível'),
                  subtitle: Text(
                    'Telefone: ${cliente['telefone'] ?? 'Telefone não disponível'}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarFiltros(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filtrar Clientes'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: _filtroMesAniversario,
                  items:
                      List.generate(12, (index) => index + 1)
                          .map(
                            (mes) => DropdownMenuItem(
                              value: mes,
                              child: Text(
                                DateFormat(
                                  'MMMM',
                                  'pt_BR',
                                ).format(DateTime(0, mes)),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (mes) => setState(() => _filtroMesAniversario = mes),
                  decoration: InputDecoration(labelText: 'Mês de Aniversário'),
                ),
                DropdownButtonFormField<String>(
                  value: _filtroComoConheceu,
                  items:
                      _opcoesComoConheceu
                          .map(
                            (opcao) => DropdownMenuItem(
                              value: opcao,
                              child: Text(opcao),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (opcao) => setState(() => _filtroComoConheceu = opcao),
                  decoration: InputDecoration(labelText: 'Como Conheceu'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _filtroMesAniversario = null;
                  _filtroComoConheceu = null;
                  _atualizarListaExibida();
                });
                Navigator.of(context).pop();
              },
              child: Text('Limpar Filtros'),
            ),
            TextButton(
              onPressed: () {
                setState(() => _atualizarListaExibida());
                Navigator.of(context).pop();
              },
              child: Text('Aplicar Filtros'),
            ),
          ],
        );
      },
    );
  }
}
