import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

Future<File> gerarPdfOrcamento(List<Map<String, dynamic>> itens) async {
  final pdf = pw.Document();

  final PdfColor corPersonalizada = PdfColor.fromHex("#07390e");
  final PdfColor corDeFundo = PdfColor.fromHex("#fff8eb");

  final ByteData fontDataBloomings = await rootBundle.load(
    'assets/fonts/Bloomings.ttf',
  );
  final ttfFontBloomings = pw.Font.ttf(fontDataBloomings.buffer.asByteData());

  final ByteData fontDataQuicksand = await rootBundle.load(
    'assets/fonts/Quicksand-Medium.ttf',
  );
  final ttfFontQuicksand = pw.Font.ttf(fontDataQuicksand.buffer.asByteData());

  final ByteData imageData = await rootBundle.load(
    'assets/images/bolomorango.jpeg',
  );
  final pw.MemoryImage refImage = pw.MemoryImage(
    imageData.buffer.asUint8List(),
  );

  double valorTotal = 0.0; // Inicializa o valor total

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Container(color: corDeFundo),
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'nicake',
                      style: pw.TextStyle(
                        font: ttfFontBloomings,
                        fontSize: 40,
                        color: corPersonalizada,
                      ),
                    ),
                    pw.Text(
                      'ATELIÊ DE BOLOS E DOCES',
                      style: pw.TextStyle(
                        font: ttfFontQuicksand,
                        fontSize: 6.5,
                        color: corPersonalizada,
                      ),
                    ),
                  ],
                ),
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey600),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Cliente: Cliente Exemplo',
                        style: pw.TextStyle(
                          font: ttfFontQuicksand,
                          fontSize: 12,
                          color: corPersonalizada,
                        ),
                      ),
                      pw.Text(
                        'Telefone: (XX) XXXX-XXXX',
                        style: pw.TextStyle(
                          font: ttfFontQuicksand,
                          fontSize: 12,
                          color: corPersonalizada,
                        ),
                      ),
                      pw.Text(
                        'Endereço: Rua Cliente, 123',
                        style: pw.TextStyle(
                          font: ttfFontQuicksand,
                          fontSize: 12,
                          color: corPersonalizada,
                        ),
                      ),
                      pw.Text(
                        'Cidade: Cidade Exemplo',
                        style: pw.TextStyle(
                          font: ttfFontQuicksand,
                          fontSize: 12,
                          color: corPersonalizada,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Center(
            child: pw.Text(
              'Orçamento Detalhado',
              style: pw.TextStyle(
                font: ttfFontBloomings,
                fontSize: 20,
                color: corPersonalizada,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Detalhes do pedido:',
            style: pw.TextStyle(
              font: ttfFontBloomings,
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: corPersonalizada,
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Produtos:',
                style: pw.TextStyle(
                  font: ttfFontBloomings,
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: corPersonalizada,
                ),
              ),
              ...itens.map((item) {
                if (item is Map<String, dynamic>) {
                  final selectedFlavors =
                      item['selectedFlavors'] as Map<String, int>? ?? {};
                  final filteredFlavors =
                      selectedFlavors.entries
                          .where((entry) => entry.value > 0)
                          .toList();
                  String saboresFormatados = filteredFlavors
                      .map((entry) => '${entry.key}: ${entry.value}')
                      .join(', ');

                  // Atualiza o valor total com o preço do item
                  valorTotal += (item['totalPrice'] ?? 0.0);

                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        // Usar Row para exibir na mesma linha
                        children: [
                          pw.Expanded(
                            // Expandir para ocupar o espaço disponível
                            flex: 2, // Ajuste flex para controlar a largura
                            child: pw.Text(
                              '${item['category'] ?? 'Categoria Desconhecida'}: ${item['productName'] ?? 'Nome Desconhecido'}',
                              style: pw.TextStyle(
                                font: ttfFontQuicksand,
                                fontSize: 14,
                                color: corPersonalizada,
                              ),
                            ),
                          ),
                          if (saboresFormatados.isNotEmpty)
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                'Sabores: $saboresFormatados',
                                style: pw.TextStyle(
                                  font: ttfFontQuicksand,
                                  fontSize: 12,
                                  color: corPersonalizada,
                                ),
                              ),
                            ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              'Qtd: ${selectedFlavors.values.fold(0, (sum, count) => sum + count)}',
                              style: pw.TextStyle(
                                font: ttfFontQuicksand,
                                fontSize: 12,
                                color: corPersonalizada,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              'R\$ ${(item['totalPrice'] ?? 0.0).toStringAsFixed(2)}',
                              style: pw.TextStyle(
                                font: ttfFontQuicksand,
                                fontSize: 12,
                                color: corPersonalizada,
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 10), // Adiciona espaçamento vertical
                    ],
                  );
                } else {
                  return pw.Text('Item inválido');
                }
              }).toList(),
            ],
          ),
          pw.SizedBox(height: 15),
          pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(
                  text: 'Decoração: ',
                  style: pw.TextStyle(
                    font: ttfFontBloomings,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: corPersonalizada,
                  ),
                ),
                pw.TextSpan(
                  text: 'Decoração Exemplo',
                  style: pw.TextStyle(
                    font: ttfFontQuicksand,
                    fontSize: 16,
                    color: corPersonalizada,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Text(
            'Foto de Referência:',
            style: pw.TextStyle(
              font: ttfFontBloomings,
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: corPersonalizada,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Image(refImage, width: 200, height: 200),
          pw.SizedBox(height: 15),
          pw.Text(
            'Endereço de entrega:',
            style: pw.TextStyle(
              font: ttfFontBloomings,
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: corPersonalizada,
            ),
          ),
          pw.Text(
            'Rua da Entrega, 456 - Bairro da Entrega - Cidade da Entrega - UF',
            style: pw.TextStyle(
              font: ttfFontQuicksand,
              fontSize: 12,
              color: corPersonalizada,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Divider(color: PdfColors.black),
          pw.SizedBox(height: 5),
          pw.Center(
            child: pw.RichText(
              // Usar RichText para estilos diferentes
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'Valor Total: ',
                    style: pw.TextStyle(
                      font:
                          ttfFontBloomings, // Fonte estilizada para "Valor Total:"
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: corPersonalizada,
                    ),
                  ),
                  pw.TextSpan(
                    text: 'R\$ ${valorTotal.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      font:
                          ttfFontQuicksand, // Fonte padrão para o valor numérico
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: corPersonalizada,
                    ),
                  ),
                ],
              ),
            ),
          ),
          pw.SizedBox(height: 5),
        ];
      },
    ),
  );

  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/orcamento.pdf');
  await file.writeAsBytes(await pdf.save());

  return file;
}
