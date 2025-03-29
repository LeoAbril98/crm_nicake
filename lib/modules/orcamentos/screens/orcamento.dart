import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/orcamento_provider.dart';

class OrcamentoPage extends StatelessWidget {
  const OrcamentoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orcamentoProvider = Provider.of<OrcamentoProvider>(context);
    final orcamentoItens = orcamentoProvider.orcamentoItens;

    return Scaffold(
      appBar: AppBar(title: const Text('Orçamento')),
      body:
          orcamentoItens.isEmpty
              ? const Center(child: Text('Seu orçamento está vazio.'))
              : ListView.builder(
                itemCount: orcamentoItens.length,
                itemBuilder: (context, index) {
                  final item = orcamentoItens[index];
                  return _buildOrcamentoItem(context, item);
                },
              ),
      bottomNavigationBar: _buildTotalBar(orcamentoItens),
    );
  }

  Widget _buildOrcamentoItem(BuildContext context, Map<String, dynamic> item) {
    final selectedFlavors = item['selectedFlavors'] as Map<String, int>? ?? {};
    int totalQuantidade = selectedFlavors.values.fold(
      0,
      (sum, count) => sum + count,
    );

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      item['productImage'] ?? 'assets/placeholder.png',
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, object, stackTrace) => Image.asset(
                            'assets/placeholder.png',
                            fit: BoxFit.cover,
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['productName'] ?? 'Nome Desconhecido',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Quantidade: $totalQuantidade',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (selectedFlavors.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sabores:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...selectedFlavors.entries.map((entry) {
                    final flavor = entry.key;
                    final quantidade = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text('- $flavor: $quantidade'),
                    );
                  }).toList(),
                ],
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: R\$ ${(item['totalPrice'] ?? 0.0).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<OrcamentoProvider>(
                      context,
                      listen: false,
                    ).removerItem(item);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBar(List<Map<String, dynamic>> itens) {
    double total = itens.fold(
      0.0,
      (sum, item) => sum + (item['totalPrice'] ?? 0.0),
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Text(
        'Total: R\$ ${total.toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
