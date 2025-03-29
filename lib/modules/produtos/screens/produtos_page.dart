import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../widgets/plant_item_card.dart';
import '../../../screens/home_content.dart';
import '../../clientes/screens/clientes_page.dart';
import '../screens/product_detail_page.dart';
import '../screens/produto_linha_tradicional.dart';
import './produto_linha_especial.dart'; // Importe a nova página
import '../../orcamentos/screens/orcamento.dart';
import '../../../providers/orcamento_provider.dart';

class AppColors {
  static const Color backgroundGray = Color(0xFFF5F5F5);
  static const Color primaryGreen = Color(0xFF113f3e);
  static const Color textDark = Color(0xFF333333);
  static const Color textGray = Color(0xFF777777);
}

class Plant {
  final String name;
  final String imageUrl;
  final double price;
  final String category;
  final String linhaTipo; // Adicione a propriedade linhaTipo

  Plant({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.linhaTipo, // Inclua linhaTipo no construtor
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(),
      category: json['category'],
      linhaTipo:
          json['linhaTipo'] ??
          '', // Se linhaTipo não existir, use uma string vazia
    );
  }
}

class ProductScreen extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const ProductScreen({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Plant> plants = [];
  List<Plant> filteredPlants = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String _selectedCategory = 'TODOS';

  final List<String> _categories = [
    'TODOS',
    'BOLOS',
    'DOCINHOS',
    'TORTAS',
    'OVOS DE PASCOA',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/products.json',
      );
      final List<dynamic> data = json.decode(response);
      setState(() {
        plants = data.map((json) => Plant.fromJson(json)).toList();
        _filterPlants('');
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterPlants(String query) {
    setState(() {
      if (query.isEmpty && _selectedCategory == 'TODOS') {
        filteredPlants = List.from(plants);
      } else if (query.isNotEmpty && _selectedCategory == 'TODOS') {
        filteredPlants =
            plants
                .where(
                  (plant) =>
                      plant.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      } else if (query.isEmpty) {
        filteredPlants =
            plants
                .where((plant) => plant.category == _selectedCategory)
                .toList();
      } else {
        filteredPlants =
            plants
                .where(
                  (plant) =>
                      plant.name.toLowerCase().contains(query.toLowerCase()) &&
                      plant.category == _selectedCategory,
                )
                .toList();
      }
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filterPlants(_searchController.text);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bem-vindo ao',
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.textGray,
                        ),
                      ),
                      const Text(
                        'Nicake Shop',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CupertinoTextField(
                        controller: _searchController,
                        placeholder: 'Buscar',
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            CupertinoIcons.search,
                            color: AppColors.textGray,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundGray,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onChanged: _filterPlants,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            final isSelected = _selectedCategory == category;
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: CupertinoButton(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                color:
                                    isSelected ? AppColors.primaryGreen : null,
                                borderRadius: BorderRadius.circular(8),
                                onPressed: () => _selectCategory(category),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? CupertinoColors.white
                                            : AppColors.textGray,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                        itemCount:
                            filteredPlants.isNotEmpty
                                ? filteredPlants.length
                                : plants.length,
                        itemBuilder: (context, index) {
                          final plant =
                              filteredPlants.isNotEmpty
                                  ? filteredPlants[index]
                                  : plants[index];
                          return PlantItemCard(
                            plant: plant,
                            onAddToBudget: (item) {
                              Provider.of<OrcamentoProvider>(
                                context,
                                listen: false,
                              ).adicionarItem(item);
                              print(
                                'Item adicionado ao orçamento: ${item['productName']}',
                              );
                            },
                            onProductTap:
                                () => _openProductDetails(context, plant),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: widget.selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _abrirOrcamento(context);
        },
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        tooltip: 'Ver Orçamento',
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

  void _openProductDetails(BuildContext context, Plant plant) {
    if (plant.linhaTipo == "Tradicional") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ProdutoLinhaTradicionalPage(
                productName: plant.name,
                flavors: [
                  'Ao Leite',
                  'Ninho',
                  'Uva',
                ], // Passa os sabores diretamente
                productImage: plant.imageUrl,
                onAddToBudget: (orderDetails) {
                  Provider.of<OrcamentoProvider>(
                    context,
                    listen: false,
                  ).adicionarItem(orderDetails);
                  print('Adicionado: ${orderDetails['productName']}');
                  Navigator.pop(context);
                },
              ),
        ),
      );
    } else if (plant.linhaTipo == "Especial") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ProdutoLinhaEspecialPage(
                productName: plant.name,
                flavors: [
                  'Pistache',
                  'Maracujá',
                  'Romeu e Julieta',
                ], // Passa os sabores diretamente
                productImage: plant.imageUrl,
                onAddToBudget: (orderDetails) {
                  Provider.of<OrcamentoProvider>(
                    context,
                    listen: false,
                  ).adicionarItem(orderDetails);
                  print('Adicionado: ${orderDetails['productName']}');
                  Navigator.pop(context);
                },
              ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ProductDetailPage(
                productName: plant.name,
                flavors: {
                  'Linha Tradicional': ['Ao Leite', 'Ninho', 'Uva'],
                  'Linha Especial': ['Pistache', 'Maracujá', 'Romeu e Julieta'],
                },
                productImage: plant.imageUrl,
                onAddToBudget: (orderDetails) {
                  Provider.of<OrcamentoProvider>(
                    context,
                    listen: false,
                  ).adicionarItem(orderDetails);
                  print('Adicionado: ${orderDetails['productName']}');
                  Navigator.pop(context);
                },
              ),
        ),
      );
    }
  }

  void _abrirOrcamento(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/orcamento',
      arguments: {
        // Passa os sabores como argumentos
        'flavors': {
          'Linha Tradicional': ['Ao Leite', 'Ninho', 'Uva'],
          'Linha Especial': ['Pistache', 'Maracujá', 'Romeu e Julieta'],
        },
      },
    );
  }
}
