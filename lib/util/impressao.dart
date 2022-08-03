import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:drift/drift.dart' as dr;
import 'package:ssoft_ticket/model/Item.dart';
import 'package:intl/intl.dart';

class impressao{

  impressao();

  void imprimir(String impressora, Item item){
    Printer printer = Printer(url: impressora);
    PdfPageFormat format;
    format = PdfPageFormat.roll80;
    // This is where we print the document
    Printing.directPrintPdf(printer: printer,
      //usePrinterSettings: true,
      // [onLayout] will be called multiple times
      // when the user changes the printer or printer settings
      onLayout: (format) {
        // Any valid Pdf document can be returned here as a list of int
        return buildPdf(format, item);
      },
    );
  }
  /// This method takes a page format and generates the Pdf file data
  Future<Uint8List> buildPdf(PdfPageFormat format, Item item) async {
    // Create the Pdf document
    DateTime now = DateTime.now();
    String data = DateFormat('dd-MM-yyyy kk:mm:ss').format(now);
    final image = pw.MemoryImage(
      File('images/logosf.png').readAsBytesSync(),
    );
    final pw.Document doc = pw.Document();
    // Add one page with centered text "Hello World"
    doc.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Align(
            alignment: pw.Alignment.topCenter,
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.FittedBox(
                      alignment: pw.Alignment.topCenter,
                      child: pw.Image(
                        image,
                        height: 60,
                        width: 60,
                      )
                  ),
                  pw.FittedBox(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Text("-----------------------------------------------------", style: pw.TextStyle(fontSize: 8)),
                  ),
                  pw.FittedBox(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Text(item.descricao, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.FittedBox(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Text(data, /*style: pw.TextStyle(fontSize: 16)*/),
                  ),
                  pw.FittedBox(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Text("-----------------------------------------------------", style: pw.TextStyle(fontSize: 8)),
                  ),
                ]
            )
          );
        },
      ),
    );
    return await doc.save();
  }
  List<Item> lista_relatorio = [];
  double total_relatorio = 0;
  void imprimir_relatorio(String impressora, List<Item> lista, double total){
    lista_relatorio = lista;
    total_relatorio = total;
    Printer printer = Printer(url: impressora);
    PdfPageFormat format;
    format = PdfPageFormat.roll80;
    // This is where we print the document
    Printing.directPrintPdf(printer: printer,
      //usePrinterSettings: true,
      // [onLayout] will be called multiple times
      // when the user changes the printer or printer settings
      onLayout: (format) {
        // Any valid Pdf document can be returned here as a list of int
        return buildPdf_relatorio(format);
      },
    );
  }
  /// This method takes a page format and generates the Pdf file data
  Future<Uint8List> buildPdf_relatorio(PdfPageFormat format) async {
    // Create the Pdf document
    DateTime now = DateTime.now();
    String data = DateFormat('dd-MM-yyyy kk:mm:ss').format(now);
    final image = pw.MemoryImage(
      File('images/logosf.png').readAsBytesSync(),
    );
    final pw.Document doc = pw.Document();
    // Add one page with centered text "Hello World"
    doc.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Align(
              alignment: pw.Alignment.topCenter,
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.FittedBox(
                        alignment: pw.Alignment.topCenter,
                        child: pw.Image(
                          image,
                          height: 60,
                          width: 60,
                        )
                    ),
                    pw.FittedBox(
                      alignment: pw.Alignment.topCenter,
                      child: pw.Text("Relatorio de Fechamento", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.FittedBox(
                      alignment: pw.Alignment.topCenter,
                      child: pw.Text("-----------------------------------------------------", style: pw.TextStyle(fontSize: 8)),
                    ),
                    pw.FittedBox(
                      alignment: pw.Alignment.topCenter,
                      child: pw.Text(data, /*style: pw.TextStyle(fontSize: 16)*/),
                    ),
                    pw.FittedBox(
                      alignment: pw.Alignment.topCenter,
                      child: pw.Text("-----------------------------------------------------", style: pw.TextStyle(fontSize: 8)),
                    ),
                    pw.FittedBox(
                      alignment: pw.Alignment.topCenter,
                      child: pw.Text("Total: " + NumberFormat.simpleCurrency(locale: 'pt_BR').format(total_relatorio), style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.FittedBox(
                      alignment: pw.Alignment.topCenter,
                      child: pw.Text("-----------------------------------------------------", style: pw.TextStyle(fontSize: 8)),
                    ),
                    for(int i = 0; i < lista_relatorio.length; i++)
                        pw.FittedBox(
                          alignment: pw.Alignment.topCenter,
                          child: pw.Text(lista_relatorio[i].descricao + "\n" + lista_relatorio[i].qtd.toString() + "x = " + NumberFormat.simpleCurrency(locale: 'pt_BR').format(lista_relatorio[i].valor) + "\n\n", style: pw.TextStyle(fontSize: 12), textAlign: pw.TextAlign.center),
                        ),
                    pw.FittedBox(
                      alignment: pw.Alignment.topCenter,
                      child: pw.Text("-----------------------------------------------------", style: pw.TextStyle(fontSize: 8)),
                    ),
                  ]
              )
          );
        },
      ),
    );
    return await doc.save();
  }
}