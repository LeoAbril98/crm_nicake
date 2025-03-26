// lib/core/data/models.dart
class Sabor {
  final String nome;

  Sabor(this.nome);
}

class Linha {
  final String nome;
  final double preco25;
  final double preco50;
  final double preco100;
  final int maxSabores25;
  final int maxSabores50;
  final int maxSabores100;

  Linha({
    required this.nome,
    required this.preco25,
    required this.preco50,
    required this.preco100,
    required this.maxSabores25,
    required this.maxSabores50,
    required this.maxSabores100,
  });
}

class BrigadeiroCategoria {
  final String nome;
  final List<Linha> linhas;
  final List<Sabor> sabores;

  BrigadeiroCategoria({
    required this.nome,
    required this.linhas,
    required this.sabores,
  });
}
