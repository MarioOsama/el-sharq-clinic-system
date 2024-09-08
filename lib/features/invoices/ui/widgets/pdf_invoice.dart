import 'package:el_sharq_clinic/features/invoices/data/models/invoice_item_model.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';

class PdfInvoice {
  static Future<void> generateInvoice(
      PdfPageFormat pageFormat, InvoiceModel invoice) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    // Load an image for the logo if you have one
    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/png/icon_logo.png'))
          .buffer
          .asUint8List(),
    );

    // Get the scaling factor based on page width (for font responsiveness)
    final scaleFactor = pageFormat.width / PdfPageFormat.a4.width;

    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (context) {
          // Responsive Text Styles
          final pw.TextStyle headerTextStyle = pw.TextStyle(
            font: font,
            fontSize: 12 * scaleFactor,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          );

          final pw.TextStyle titleTextStyle = pw.TextStyle(
            font: font,
            fontSize: 24 * scaleFactor,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          );

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header section
              pw.Row(
                children: [
                  pw.Image(logo,
                      width: 80 * scaleFactor), // Company logo on the left
                  pw.Spacer(),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Invoice Number:", style: headerTextStyle),
                      pw.Text("Invoice Date:", style: headerTextStyle),
                      pw.Text("Invoice Time:", style: headerTextStyle),
                    ],
                  ),
                  pw.SizedBox(width: 20 * scaleFactor),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(" ${invoice.id}", style: headerTextStyle),
                      pw.Text(invoice.date.substring(0, 10),
                          style: headerTextStyle),
                      pw.Text(invoice.date.substring(11, 19),
                          style: headerTextStyle),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20 * scaleFactor),

              // Title
              pw.Text(
                "Invoice",
                style: titleTextStyle,
              ),
              pw.SizedBox(height: 20 * scaleFactor),

              // Table Header
              pw.Container(
                color: PdfColors.grey600,
                padding: pw.EdgeInsets.all(8 * scaleFactor),
                child: buildHeaderRow(scaleFactor, font),
              ),

              // Table Rows
              ...buildTableDataRows(invoice.items, scaleFactor, font),
              pw.Divider(),

              // Footer for summary
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    width: 200 * scaleFactor,
                    child: buildSummaryColumn(invoice, scaleFactor, font),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // // Save PDF file to the device or share it
    // final file = File("${invoice.id}.pdf");
    // await file.writeAsBytes(await pdf.save());

    // Convert the document to bytes and call the Printing package to print
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static pw.Row buildHeaderRow(double scaleFactor, pw.Font font) {
    return pw.Row(
      children: [
        pw.Expanded(
            child: pw.Text("Name",
                style: pw.TextStyle(
                    font: font,
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12 * scaleFactor))),
        pw.Expanded(
            child: pw.Text("Type",
                style: pw.TextStyle(
                    font: font,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                    fontSize: 12 * scaleFactor))),
        pw.Expanded(
            child: pw.Text("Quantity",
                style: pw.TextStyle(
                    font: font,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                    fontSize: 12 * scaleFactor))),
        pw.Expanded(
            child: pw.Text("Unit Price",
                style: pw.TextStyle(
                    font: font,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                    fontSize: 12 * scaleFactor))),
        pw.Expanded(
            child: pw.Text("Total",
                style: pw.TextStyle(
                    font: font,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                    fontSize: 12 * scaleFactor))),
      ],
    );
  }

  static List<pw.Widget> buildTableDataRows(
      List<InvoiceItemModel> items, double scaleFactor, pw.Font font) {
    return List.generate(items.length, (index) {
      final item = items[index];
      return buildTableRow(
          item.name,
          item.type,
          item.quantity.toString(),
          item.price.toStringAsFixed(2),
          (item.price * item.quantity).toStringAsFixed(2),
          scaleFactor,
          font);
    });
  }

  static pw.Column buildSummaryColumn(
      InvoiceModel invoice, double scaleFactor, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        buildSummaryRow(
            "Net total", invoice.total.toStringAsFixed(2), scaleFactor, font),
        buildSummaryRow("Discount amount", invoice.discount.toStringAsFixed(2),
            scaleFactor, font),
        buildSummaryRow(
            "Discount percentage",
            (invoice.discount / invoice.total * 100).toStringAsFixed(2),
            scaleFactor,
            font),
        pw.Divider(),
        buildSummaryRow(
            "Total amount due",
            (invoice.total - invoice.discount).toStringAsFixed(2),
            scaleFactor,
            font,
            isBold: true),
      ],
    );
  }

  // Helper method to create a row in the table
  static pw.Widget buildTableRow(String name, String type, String quantity,
      String unitPrice, String total, double scaleFactor, pw.Font font) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4 * scaleFactor),
      child: pw.Row(
        children: [
          pw.Expanded(
              child: pw.Text(name,
                  style: pw.TextStyle(font: font, fontSize: 10 * scaleFactor))),
          pw.Expanded(
              child: pw.Text(type,
                  style: pw.TextStyle(font: font, fontSize: 10 * scaleFactor))),
          pw.Expanded(
              child: pw.Text(quantity,
                  style: pw.TextStyle(font: font, fontSize: 10 * scaleFactor))),
          pw.Expanded(
              child: pw.Text(unitPrice,
                  style: pw.TextStyle(font: font, fontSize: 10 * scaleFactor))),
          pw.Expanded(
              child: pw.Text(total,
                  style: pw.TextStyle(font: font, fontSize: 10 * scaleFactor))),
        ],
      ),
    );
  }

  // Helper method to create summary rows
  static pw.Widget buildSummaryRow(
      String label, String value, double scaleFactor, pw.Font font,
      {bool isBold = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
              font: font,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: 10 * scaleFactor),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
              font: font,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: 10 * scaleFactor),
        ),
      ],
    );
  }
}
