import 'package:flutter/material.dart';

class OrcamentoProvider extends ChangeNotifier {
  List<Map<String, dynamic>> orcamentoItens = [];

  void adicionarItem(Map<String, dynamic> item) {
    orcamentoItens.add(item);
    notifyListeners();
  }

  void removerItem(Map<String, dynamic> item) {
    orcamentoItens.remove(item);
    notifyListeners();
  }

  void limparOrcamento() {
    orcamentoItens.clear();
    notifyListeners();
  }

  double calcularTotal() {
    double total = 0;
    for (var item in orcamentoItens) {
      total += (item['totalPrice'] ?? 0.0);
    }
    return total;
  }
}
