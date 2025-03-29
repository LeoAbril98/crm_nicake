import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart'; // Importe o pacote flutter/material para usar Color

Future<File> gerarPdfOrcamento(List<Map<String, dynamic>> itens) async {
  final pdf = pw.Document();
  final backgroundImage =
      (await rootBundle.load('assets/images/pdf.jpg')).buffer.asUint8List();
  final dateFormat = DateFormat('dd/MM/yyyy');
  final dataAtual = dateFormat.format(DateTime.now());
  double total = itens.fold(
    0.0,
    (sum, item) => sum + (item['totalPrice'] ?? 0.0),
  );

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Stack(
          children: [
            // Imagem de fundo ajustada para ocupar toda a página
            pw.Positioned.fill(
              child: pw.Image(
                pw.MemoryImage(backgroundImage),
                fit: pw.BoxFit.cover, // Imagem preenchendo a página sem margem
              ),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                // Remover a margem superior inicial
                pw.SizedBox(height: 150), // Ajuste para deixar espaço adequado
                // Título "Orçamento"
                pw.Center(
                  child: pw.Text(
                    'Orçamento',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex(
                        '113f3e',
                      ), // Use PdfColor.fromHex para converter a cor
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Data do Orçamento: $dataAtual',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Itens do Orçamento:',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex(
                      '113f3e',
                    ), // Use PdfColor.fromHex para converter a cor
                  ),
                ),
                pw.SizedBox(height: 10),
                ...itens.map(
                  (item) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '${item['productName']} - Quantidade: ${item['selectedFlavors'].values.fold(0, (sum, count) => sum + (count as int))}',
                        style: pw.TextStyle(fontSize: 14),
                      ),
                      if (item['selectedFlavors'].isNotEmpty)
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Sabores:',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            ...item['selectedFlavors'].entries
                                .where((entry) => (entry.value as int) > 0)
                                .map((entry) {
                                  final sabor = entry.key;
                                  final quant = entry.value as int;
                                  return pw.Padding(
                                    padding: pw.EdgeInsets.only(left: 10),
                                    child: pw.Text('- $sabor : $quant'),
                                  );
                                })
                                .toList(),
                          ],
                        ),
                      pw.Text(
                        'Preço: R\$ ${(item['totalPrice'] ?? 0.0).toStringAsFixed(2)}',
                        style: pw.TextStyle(fontSize: 14),
                      ),
                      pw.SizedBox(height: 5),
                    ],
                  ),
                ),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Total: R\$ ${total.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex(
                      '113f3e',
                    ), // Use PdfColor.fromHex para converter a cor
                  ),
                ),
                pw.SizedBox(height: 20),
              ],
            ),
          ],
        );
      },
    ),
  );

  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/orcamento.pdf');
  await file.writeAsBytes(await pdf.save());
  return file;
}
