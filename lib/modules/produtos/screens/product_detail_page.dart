import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart'; // Importando para animação de Lottie

import '../../../providers/orcamento_provider.dart';

class AppColors {
  static const Color backgroundGray = Color(0xFFF5F5F5);
  static const Color primaryGreen = Color(0xFF113f3e);
}

class ProductDetailPage extends StatefulWidget {
  final String productName;
  final Map<String, List<String>> flavors;
  final String productImage;
  final Function(Map<String, dynamic>) onAddToBudget;

  const ProductDetailPage({
    Key? key,
    required this.productName,
    required this.flavors,
    required this.productImage,
    required this.onAddToBudget,
  }) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedLine = 'Linha Tradicional';
  String selectedSize = '25un';
  int totalFlavorsSelected = 0;
  Map<String, int> selectedFlavorCounts = {};
  double totalPrice = 0.0;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeFlavorCounts();
    _calculateTotalPrice();
  }

  void _initializeFlavorCounts() {
    widget.flavors.forEach((line, flavors) {
      flavors.forEach((flavor) {
        selectedFlavorCounts[flavor] = 0;
      });
    });
    _updateTotalFlavorCount();
  }

  void _updateTotalFlavorCount() {
    setState(() {
      totalFlavorsSelected = selectedFlavorCounts.values.fold(
        0,
        (sum, count) => sum + count,
      );
      _calculateTotalPrice();
      isButtonEnabled = totalFlavorsSelected == _getMaxFlavorCount();
    });
  }

  void _calculateTotalPrice() {
    setState(() {
      double price = 0.0;
      if (selectedLine == 'Linha Tradicional') {
        switch (selectedSize) {
          case '25un':
            price = 85.0;
            break;
          case '50un':
            price = 160.0;
            break;
          case '100un':
            price = 280.0;
            break;
        }
      } else if (selectedLine == 'Linha Especial') {
        switch (selectedSize) {
          case '25un':
            price = 150.0;
            break;
          case '50un':
            price = 280.0;
            break;
          case '100un':
            price = 490.0;
            break;
        }
      }
      totalPrice = price;
      isButtonEnabled = totalFlavorsSelected == _getMaxFlavorCount();
    });
  }

  int _getMaxFlavorCount() {
    switch (selectedSize) {
      case '25un':
        return 25;
      case '50un':
        return 50;
      case '100un':
        return 100;
      default:
        return 25;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: AppColors.backgroundGray,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipOval(
                child: Image.asset(widget.productImage, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.productName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent in posuere dui.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(height: 24),
            _buildLineSelection(),
            SizedBox(height: 16),
            _buildSizeSelection(),
            SizedBox(height: 24),
            _buildFlavorHeader(),
            SizedBox(height: 8),
            _buildFlavorMenu(),
            SizedBox(height: 48),
            Text(
              'Sabores selecionados: $totalFlavorsSelected/${_getMaxFlavorCount()}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildTotalRow(),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed:
                  isButtonEnabled
                      ? () {
                        _adicionarAoOrcamento(
                          context,
                        ); // Adiciona o item ao orçamento
                        _showConfirmationDialog(
                          context,
                        ); // Exibe o popup de animação
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isButtonEnabled ? AppColors.primaryGreen : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Adicionar ao Orçamento'),
            ),
          ],
        ),
      ),
    );
  }

  void _adicionarAoOrcamento(BuildContext context) {
    final orcamentoProvider = Provider.of<OrcamentoProvider>(
      context,
      listen: false,
    );
    Map<String, dynamic> orderDetails = {
      'productName': widget.productName,
      'selectedLine': selectedLine,
      'selectedSize': selectedSize,
      'selectedFlavors': selectedFlavorCounts,
      'totalPrice': totalPrice,
      'productImage': widget.productImage,
    };
    widget.onAddToBudget(orderDetails);
    print('Produto adicionado ao orçamento: ${orderDetails['productName']}');
  }

  // Método para exibir o popup de confirmação com animação de check
  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Impede o fechamento ao tocar fora
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(
            255,
            255,
            255,
            255,
          ), // Cor personalizada para o fundo do popup
          contentPadding:
              EdgeInsets.zero, // Remove o padding interno para melhor ajuste
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ), // Arredondando os cantos do popup
          ),
          titlePadding: EdgeInsets.all(
            0,
          ), // Remove o padding do título para poder adicionar o "X" no topo
          title: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: const Color.fromARGB(255, 236, 5, 5),
              ), // O "X" no canto superior direito
              onPressed: () {
                Navigator.of(
                  context,
                ).pop(); // Fecha o popup ao pressionar o "X"
              },
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Usando Lottie para exibir a animação de check
              Lottie.asset(
                'assets/check_animation.json', // Certifique-se de que o arquivo esteja na pasta assets
                height: 100,
              ),
              SizedBox(
                height: 24,
              ), // Adiciona um espaço extra entre a animação e o texto
              const Text(
                'Item adicionado ao orçamento!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFlavorHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Sabores:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            _showClearConfirmationDialog(context);
          },
          child: const Text('Limpar', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  Future<void> _showClearConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limpar Sabores?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tem certeza de que deseja limpar a seleção de sabores?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop();
                _clearFlavorCounts();
              },
            ),
          ],
        );
      },
    );
  }

  void _clearFlavorCounts() {
    setState(() {
      selectedFlavorCounts.forEach((flavor, count) {
        selectedFlavorCounts[flavor] = 0;
      });
      _updateTotalFlavorCount();
    });
  }

  Widget _buildLineSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedLine = 'Linha Tradicional';
              _initializeFlavorCounts();
              _calculateTotalPrice();
            });
          },
          child: Text(
            'Linha Tradicional',
            style: TextStyle(
              color:
                  selectedLine == 'Linha Tradicional'
                      ? Colors.white
                      : Colors.black87,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selectedLine == 'Linha Tradicional'
                    ? AppColors.primaryGreen
                    : Colors.grey,
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedLine = 'Linha Especial';
              _initializeFlavorCounts();
              _calculateTotalPrice();
            });
          },
          child: Text(
            'Linha Especial',
            style: TextStyle(
              color:
                  selectedLine == 'Linha Especial'
                      ? Colors.white
                      : Colors.black87,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selectedLine == 'Linha Especial'
                    ? AppColors.primaryGreen
                    : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSizeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _sizeButton('25un'),
        SizedBox(width: 8),
        _sizeButton('50un'),
        SizedBox(width: 8),
        _sizeButton('100un'),
      ],
    );
  }

  Widget _sizeButton(String size) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedSize = size;
          _calculateTotalPrice();
          _updateTotalFlavorCount();
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color:
              selectedSize == size
                  ? AppColors.primaryGreen
                  : Colors.grey.shade400,
        ),
        backgroundColor:
            selectedSize == size
                ? AppColors.primaryGreen.withOpacity(0.1)
                : Colors.transparent,
      ),
      child: Text(
        size,
        style: TextStyle(
          color:
              selectedSize == size
                  ? AppColors.primaryGreen
                  : Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildFlavorMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widget.flavors[selectedLine]!.map((flavor) => _flavorRow(flavor)),
      ],
    );
  }

  Widget _flavorRow(String flavor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(flavor),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (selectedFlavorCounts[flavor]! > 0) {
                    selectedFlavorCounts[flavor] =
                        selectedFlavorCounts[flavor]! - 1;
                    _updateTotalFlavorCount();
                  }
                });
              },
              icon: const Icon(Icons.remove, color: Colors.red),
            ),
            Text('${selectedFlavorCounts[flavor]}'),
            IconButton(
              onPressed: () {
                setState(() {
                  if (selectedFlavorCounts[flavor]! < _getMaxFlavorCount()) {
                    selectedFlavorCounts[flavor] =
                        selectedFlavorCounts[flavor]! + 1;
                    _updateTotalFlavorCount();
                  }
                });
              },
              icon: const Icon(Icons.add, color: Colors.green),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Total'),
        Text(
          'R\$ $totalPrice',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
