import 'package:flutter/material.dart';
import '../widgets/featured_item_card.dart';
import '../widgets/popular_item_card.dart';
import '../widgets/bottom_nav_bar.dart';

import '../modules/clientes/screens/clientes_page.dart';
import '../modules/produtos/screens/produtos_page.dart';
import '../modules/orcamentos/screens/orcamentos_page.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }

    switch (index) {
      case 0:
        // Início (Já estamos aqui)
        break;
      case 1:
        // Clientes
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClientesPage()),
        ).then((retorno) {
          if (retorno != null) {
            setState(() {
              _selectedIndex = retorno;
            });
          }
        });
        break;
      case 2:
        // Produtos
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProdutosPage()),
        );
        break;

      case 3:
        // Orçamentos
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrcamentosPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            width: 72, // Duas vezes o raio do CircleAvatar
            height: 72, // Duas vezes o raio do CircleAvatar
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Image.asset(
              'assets/images/logo.png', // Sua imagem do logo
              fit: BoxFit.cover,
            ),
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // Conteúdo da tela inicial (banners, listas de produtos, etc.)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: const DecorationImage(
                  image: AssetImage('assets/images/banner.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Atalhos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16.0),
              children: const [
                FeaturedItemCard(
                  imageUrl: 'assets/images/order.png', // Imagem de orçamento
                  name: 'Novo Orçamento',
                ),
                FeaturedItemCard(
                  imageUrl: 'assets/images/cliente.png', // Imagem de cliente
                  name: 'Novo Cliente',
                ),
                FeaturedItemCard(
                  imageUrl: 'assets/images/bolo.jpg', // Imagem de bolo
                  name: 'Novo Produto',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mais populares',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text('Ver mais')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
              children: const [
                PopularItemCard(
                  imageUrl: 'assets/images/bolomorango.jpeg', // Imagem de TV
                  name: 'Bolo Morango',
                  price: '\$330',
                ),
                PopularItemCard(
                  imageUrl: 'assets/images/doce.jpeg', // Imagem de Macbook
                  name: 'Doces',
                  price: '\$999',
                ),
                PopularItemCard(
                  imageUrl: 'assets/images/brigadeiros.jpeg', // Imagem padrão
                  name: 'Brigadeiros',
                  price: '\$50',
                ),
                PopularItemCard(
                  imageUrl: 'assets/images/uva.jpeg', // Imagem padrão
                  name: 'surpresinha de uva',
                  price: '\$75',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
