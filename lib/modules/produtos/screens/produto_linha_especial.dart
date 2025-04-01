import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../../../providers/orcamento_provider.dart';

class AppColors {
  static const Color backgroundGray = Color(0xFFF5F5F5);
  static const Color primaryGreen = Color(0xFF113f3e);
}

class ProdutoLinhaEspecialPage extends StatefulWidget {
  final String productName;
  final List<String> flavors;
  final String productImage;
  final Function(Map<String, dynamic>) onAddToBudget;
  final String productCategory;

  const ProdutoLinhaEspecialPage({
    Key? key,
    required this.productName,
    required this.flavors,
    required this.productImage,
    required this.onAddToBudget,
    required this.productCategory,
  }) : super(key: key);

  @override
  _ProdutoLinhaEspecialPageState createState() =>
      _ProdutoLinhaEspecialPageState();
}

class _ProdutoLinhaEspecialPageState extends State<ProdutoLinhaEspecialPage> {
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
    widget.flavors.forEach((flavor) {
      selectedFlavorCounts[flavor] = 0;
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
                        _adicionarAoOrcamento(context);
                        _showConfirmationDialog(context);
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
      'selectedSize': selectedSize,
      'selectedFlavors': selectedFlavorCounts,
      'totalPrice': totalPrice,
      'productImage': widget.productImage,
      'category': widget.productCategory, // Usando widget.productCategory
    };
    widget.onAddToBudget(orderDetails);
    print('Produto adicionado ao orçamento: ${orderDetails['productName']}');
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          titlePadding: EdgeInsets.all(0),
          title: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: const Color.fromARGB(255, 236, 5, 5),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/check_animation.json', height: 100),
              SizedBox(height: 24),
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
      children: [...widget.flavors.map((flavor) => _flavorRow(flavor))],
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
            GestureDetector(
              onTap: () => _mostrarDialogoEditarQuantidade(flavor),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${selectedFlavorCounts[flavor]}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
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

  Future<void> _mostrarDialogoEditarQuantidade(String flavor) async {
    final TextEditingController _controladorQuantidade = TextEditingController(
      text: '${selectedFlavorCounts[flavor]}',
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Quantidade de $flavor'),
          content: TextField(
            controller: _controladorQuantidade,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Nova Quantidade'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                final novaQuantidade = int.tryParse(
                  _controladorQuantidade.text,
                );
                if (novaQuantidade != null &&
                    novaQuantidade >= 0 &&
                    novaQuantidade <= _getMaxFlavorCount()) {
                  setState(() {
                    selectedFlavorCounts[flavor] = novaQuantidade;
                    _updateTotalFlavorCount();
                  });
                } else {
                  // Mensagem de erro ou feedback para o usuário (opcional)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quantidade inválida!')),
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
