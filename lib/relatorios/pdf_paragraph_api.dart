import 'dart:io';

import 'package:estoque/product.dart';
import 'package:estoque/services/product_service.dart';
import 'package:estoque/relatorios/pdf_api.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfParagraphApi {
  ProductService productService = ProductService();
  late List<Product> _products;
  PdfParagraphApi(this._products);

  void updateProducts() async {
    final updatedProducts = await productService.getAllProducts();
    _products = updatedProducts;
  }

  List<Product> get products => _products;

  static Future<File> generate(PdfParagraphApi api) async {
    final products = api.products;
    final pdf = Document();

    final customFont =
        Font.ttf(await rootBundle.load('assets/OpenSans-Regular.ttf'));

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: <pw.Widget>[
              pw.Text('Relatório de Estoque Atual',
                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      )),
              pw.SizedBox(height: 20),
              pw.Table(
                children: [
                  pw.TableRow(children: [
                    pw.Text('Nome'),
                    pw.Text('Descrição'),
                    pw.Text('Quantidade'),
                  ]),
                  ...products.map((products) {
                    return pw.TableRow(children: [
                      pw.Text(products.name),
                      pw.Text(products.description),
                      pw.Text("${products.quantity}"),
                    ]);
                  }).toList(),
                ],
              ),
            ],
          );
        },
      ),
    );
    return PdfApi.saveDocument(name: 'relatorio_estoque.pdf', pdf: pdf);
  }
}
