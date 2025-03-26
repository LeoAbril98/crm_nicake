// lib/modules/produtos/widgets/brigadeiro_card.dart
import 'package:flutter/material.dart';
import '../../../core/data/models.dart';

class BrigadeiroCard extends StatefulWidget {
  final BrigadeiroCategoria brigadeiroCategoria;

  BrigadeiroCard({required this.brigadeiroCategoria});

  @override
  _BrigadeiroCardState createState() => _BrigadeiroCardState();
}

class _BrigadeiroCardState extends State<BrigadeiroCard> {
  Linha? linhaSelecionada;
  int quantidadeSelecionada = 25;
  Map<Sabor, int> saboresSelecionados = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.brigadeiroCategoria.nome,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          DropdownButton<Linha>(
            value: linhaSelecionada,
            hint: Text("Selecione a linha"),
            onChanged: (Linha? linha) {
              setState(() {
                linhaSelecionada = linha;
                saboresSelecionados.clear();
              });
            },
            items:
                widget.brigadeiroCategoria.linhas.map<DropdownMenuItem<Linha>>((
                  Linha value,
                ) {
                  return DropdownMenuItem<Linha>(
                    value: value,
                    child: Text(value.nome),
                  );
                }).toList(),
          ),
          if (linhaSelecionada != null) ...[
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Radio(
                      value: 25,
                      groupValue: quantidadeSelecionada,
                      onChanged: (int? value) {
                        setState(() {
                          quantidadeSelecionada = value!;
                        });
                      },
                    ),
                    Text("25 unidades"),
                  ],
                ),
                Column(
                  children: [
                    Radio(
                      value: 50,
                      groupValue: quantidadeSelecionada,
                      onChanged: (int? value) {
                        setState(() {
                          quantidadeSelecionada = value!;
                        });
                      },
                    ),
                    Text("50 unidades"),
                  ],
                ),
                Column(
                  children: [
                    Radio(
                      value: 100,
                      groupValue: quantidadeSelecionada,
                      onChanged: (int? value) {
                        setState(() {
                          quantidadeSelecionada = value!;
                        });
                      },
                    ),
                    Text("100 unidades"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              children:
                  widget.brigadeiroCategoria.sabores.map((sabor) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(sabor.nome),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed:
                                  saboresSelecionados[sabor] != null &&
                                          saboresSelecionados[sabor]! > 0
                                      ? () {
                                        setState(() {
                                          saboresSelecionados[sabor] =
                                              (saboresSelecionados[sabor] ??
                                                  0) -
                                              1;
                                        });
                                      }
                                      : null,
                            ),
                            Text('${saboresSelecionados[sabor] ?? 0}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  saboresSelecionados[sabor] =
                                      (saboresSelecionados[sabor] ?? 0) + 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
