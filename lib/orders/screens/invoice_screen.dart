import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceGenerator {
  static Future<String> generateInvoice() async {
    final pdf = pw.Document();

    // Load logo image
    final image = pw.MemoryImage(
      (await rootBundle.load("assets/images/murrah_5.jpeg"))
          .buffer
          .asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // LOGO + APP NAME
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(image, height: 40),
                  pw.Text(
                    "ZapBuy",
                    style: pw.TextStyle(
                      fontSize: 20,
                      color: PdfColor.fromHex("#777777"),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              pw.Text(
                "MARKWAVE PRIVATE LIMITED",
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.Text(
                "#JH56A1",
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColor.fromHex("#555555"),
                ),
              ),

              pw.SizedBox(height: 30),

              // BILLING + SHIPPING
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // BILLING
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "BILLING ADDRESS",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text("Yesenia M. Lawrence"),
                      pw.Text("3647 Confederate Drive"),
                      pw.Text("Syracuse, NY 13221"),
                      pw.Text("email@youraddress.com"),
                      pw.Text("(555) 987 - 123"),
                    ],
                  ),

                  // SHIPPING
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "SHIPPING ADDRESS",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text("Yesenia M. Lawrence"),
                      pw.Text("3647 Confederate Drive"),
                      pw.Text("Syracuse, NY 13221"),
                      pw.Text("email@youraddress.com"),
                      pw.Text("(555) 987 - 123"),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              // TABLE (HEADER + ROWS)
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(1),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(1),
                  3: pw.FlexColumnWidth(1),
                  4: pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#FFE800'), // Yellow header
                    ),
                    children: [
                      _tableHeader("Order ID"),
                      _tableHeader("Quantity"),
                      _tableHeader("CPF"),
                      _tableHeader("CPF Qty"),
                      _tableHeader("Amount"),
                    ],
                  ),

                  // Rows
                  buildRow("1", "1", "50%", "2", "₹49"),
                  buildRow("2", "2", "10%", "5", "₹135"),
                ],
              ),

              pw.SizedBox(height: 30),

              // PRICE SUMMARY
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    _priceRow("Subtotal", "₹184.00"),
                    _priceRow("Discount", "₹15.00"),
                    pw.Divider(),
                    _priceRow("Total Amount Paid", "₹169.00", bold: true),
                    _priceRow("Total Due", "₹0", bold: true),
                  ],
                ),
              ),

              pw.SizedBox(height: 40),

              // TERMS
              pw.Text(
                "Please note that depending on the availability of your products,\n"
                "your order will be shipped within 5 to 7 business days.\n"
                "Please check return instructions and warranty upon receiving.\n"
                "For queries call 654-123-123 or email support@youremail.com.\n\n"
                "Thank you for shopping!",
                style: pw.TextStyle(
                  fontSize: 11,
                  color: PdfColor.fromHex("#666666"),
                ),
              ),
            ],
          );
        },
      ),
    );

    // SAVE PDF
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/invoice.pdf");
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  // ---------- TABLE HEADER CELL ----------
  static pw.Widget _tableHeader(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        title,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  // ---------- Table Row Function ----------
  static pw.TableRow buildRow(
    String orderId,
    String qty,
    String cpf,
    String cpfQty,
    String amount,
  ) {
    return pw.TableRow(
      children: [
        _tableData(orderId),
        _tableData(qty),
        _tableData(cpf),
        _tableData(cpfQty),
        _tableData(amount),
      ],
    );
  }

  static pw.Widget _tableData(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text),
    );
  }

  // ---------- PRICE ROW ----------
  static pw.Widget _priceRow(String label, String value, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Text(
            "$label: ",
            style: pw.TextStyle(
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}