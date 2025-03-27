// lib/modules/produtos/screens/produtos_page.dart
import 'package:flutter/material.dart';
import '../widgets/brigadeiro_card.dart';
import '../../../core/data/models.dart';
import '../../../core/styles.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../../clientes/screens/clientes_page.dart'; // Importe a tela ClientesPage
import '../../orcamentos/screens/orcamentos_page.dart'; // Importe a tela OrcamentosPage

class ProdutosPage extends StatefulWidget {
  @override
  _ProdutosPageState createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  final List<String> categorias = [
    'Todos',
    'Categoria 1',
    'Categoria 2',
    'Categoria 3',
    'Categoria 4',
  ];

  final List<Map<String, dynamic>> produtos = [
    {
      'nome': 'Brigadeiros',
      'preco': 0.00,
      'imagem': 'https://dummyimage.com/150/000/fff',
    },
    {
      'nome': 'Produto 2',
      'preco': 39.99,
      'imagem': 'https://dummyimage.com/150/000/fff',
    },
  ];

  final BrigadeiroCategoria brigadeirosVazio = BrigadeiroCategoria(
    nome: 'Brigadeiros',
    linhas: [],
    sabores: [],
  );

  int _selectedIndex = 2; // Selecionar "Produtos" por padrão

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Catálogo de Produtos')),
      body: Column(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                children:
                    categorias.map((categoria) {
                      return Chip(label: Text(categoria));
                    }).toList(),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: AppStyles.productGridChildAspectRatio,
              ),
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return GestureDetector(
                  onTap: () {
                    if (produto['nome'] == 'Brigadeiros') {
                      showModalBottomSheet(
                        context: context,
                        builder:
                            (context) => BrigadeiroCard(
                              brigadeiroCategoria: brigadeirosVazio,
                            ),
                      );
                    }
                  },
                  child: Card(
                    elevation: AppStyles.productCardElevation,
                    margin: AppStyles.productCardMargin,
                    child: Padding(
                      padding: AppStyles.productCardPadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.network(produto['imagem'], height: 100),
                          SizedBox(height: 8.0),
                          Text(
                            produto['nome'],
                            style: AppStyles.productTitleStyle,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'R\$ ${produto['preco'].toStringAsFixed(2)}',
                            style: AppStyles.productPriceStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegar para a página apropriada com pushReplacement
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/'); // Vai para a Home
    } else if (index == 1) {
      Navigator.pushReplacement(
        // Usar pushReplacement para criar nova instancia
        context,
        MaterialPageRoute(builder: (context) => ClientesPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/produtos'); // Vai para Produtos
    } else if (index == 3) {
      Navigator.pushReplacement(
        // Usar pushReplacement para criar nova instancia
        context,
        MaterialPageRoute(builder: (context) => OrcamentosPage()),
      );
    }
  }
}
