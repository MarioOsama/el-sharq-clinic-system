import 'package:easy_localization/easy_localization.dart';
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

    final arabicFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Cairo-Regular.ttf'),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (context) {
          // Responsive Text Styles
          final pw.TextStyle headerTextStyle = pw.TextStyle(
            font: arabicFont,
            fontSize: 12 * scaleFactor,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          );

          final pw.TextStyle titleTextStyle = pw.TextStyle(
            font: arabicFont,
            fontSize: 24 * scaleFactor,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          );

          final pw.TextStyle tableHeaderTextStyle = pw.TextStyle(
              font: arabicFont,
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 12 * scaleFactor);

          final pw.TextStyle summaryTextStyle =
              pw.TextStyle(font: arabicFont, fontSize: 10 * scaleFactor);

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
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                          textDirection: pw.TextDirection.rtl,
                          " ${invoice.id}",
                          style: headerTextStyle),
                      pw.Text(
                          textDirection: pw.TextDirection.rtl,
                          invoice.date.substring(0, 10),
                          style: headerTextStyle),
                      pw.Text(
                          textDirection: pw.TextDirection.rtl,
                          invoice.date.substring(11, 19),
                          style: headerTextStyle),
                    ],
                  ),
                  pw.SizedBox(width: 20 * scaleFactor),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                          textDirection: pw.TextDirection.rtl,
                          "رقم الفاتورة",
                          style: headerTextStyle),
                      pw.Text(
                          textDirection: pw.TextDirection.rtl,
                          "التاريخ",
                          style: headerTextStyle),
                      pw.Text(
                          textDirection: pw.TextDirection.rtl,
                          "الوقت",
                          style: headerTextStyle),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20 * scaleFactor),

              // Title
              pw.Text(
                textDirection: pw.TextDirection.rtl,
                "فاتورة",
                style: titleTextStyle,
              ),
              pw.SizedBox(height: 20 * scaleFactor),

              // Table Header
              pw.Container(
                color: PdfColors.grey600,
                padding: pw.EdgeInsets.all(8 * scaleFactor),
                child: buildHeaderRow(scaleFactor, tableHeaderTextStyle),
              ),

              // Table Rows
              ...buildTableDataRows(invoice.items, scaleFactor, arabicFont),
              pw.Divider(),

              // Footer for summary
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    width: 200 * scaleFactor,
                    child: buildSummaryColumn(
                        invoice, scaleFactor, summaryTextStyle),
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

  static pw.Row buildHeaderRow(
      double scaleFactor, pw.TextStyle tableHeaderTextStyle) {
    return pw.Row(
      children: [
        pw.Expanded(
            child: pw.Text(
                textDirection: pw.TextDirection.rtl,
                "المجموع",
                style: tableHeaderTextStyle)),
        pw.Expanded(
            child: pw.Text(
                textDirection: pw.TextDirection.rtl,
                "سعر الوحدة",
                style: tableHeaderTextStyle)),
        pw.Expanded(
            child: pw.Text(
                textDirection: pw.TextDirection.rtl,
                "الكميه",
                style: tableHeaderTextStyle)),
        pw.Expanded(
            child: pw.Text(
                textDirection: pw.TextDirection.rtl,
                "النوع",
                style: tableHeaderTextStyle)),
        pw.Expanded(
            child: pw.Text(
                textDirection: pw.TextDirection.rtl,
                "الاسم",
                style: tableHeaderTextStyle)),
      ],
    );
  }

  static List<pw.Widget> buildTableDataRows(
      List<InvoiceItemModel> items, double scaleFactor, pw.Font font) {
    return List.generate(items.length, (index) {
      final item = items[index];
      return buildTableRow(
          (item.price * item.quantity).toStringAsFixed(2),
          item.price.toStringAsFixed(2),
          item.quantity.toString(),
          item.type.tr(),
          item.name,
          scaleFactor,
          font);
    });
  }

  static pw.Column buildSummaryColumn(
      InvoiceModel invoice, double scaleFactor, pw.TextStyle textStyle) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        buildSummaryRow("الاجمالي", invoice.total.toStringAsFixed(2),
            scaleFactor, textStyle),
        buildSummaryRow("الخصم", invoice.discount.toStringAsFixed(2),
            scaleFactor, textStyle),
        buildSummaryRow(
            "نسبة الخصم",
            (invoice.discount / invoice.total * 100).toStringAsFixed(2),
            scaleFactor,
            textStyle),
        pw.Divider(),
        buildSummaryRow(
            "الاجمالي بعد الخصم",
            (invoice.total - invoice.discount).toStringAsFixed(2),
            scaleFactor,
            textStyle,
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
              child: pw.Text(
                  textDirection: pw.TextDirection.rtl,
                  name,
                  style: pw.TextStyle(font: font, fontSize: 10 * scaleFactor))),
          pw.Expanded(
              child: pw.Text(
                  textDirection: pw.TextDirection.rtl,
                  type,
                  style: pw.TextStyle(font: font, fontSize: 10 * scaleFactor))),
          pw.Expanded(
              child: pw.Text(
                  textDirection: pw.TextDirection.rtl,
                  quantity,
                  style: pw.TextStyle(font: font, fontSize: 10 * scaleFactor))),
          pw.Expanded(
              child: pw.Text(
                  textDirection: pw.TextDirection.rtl,
                  unitPrice,
                  style: pw.TextStyle(font: font, fontSize: 10 * scaleFactor))),
          pw.Expanded(
              child: pw.Text(
                  textDirection: pw.TextDirection.rtl,
                  total,
                  style: pw.TextStyle(font: font, fontSize: 10 * scaleFactor))),
        ],
      ),
    );
  }

  // Helper method to create summary rows
  static pw.Widget buildSummaryRow(
      String label, String value, double scaleFactor, pw.TextStyle textStyle,
      {bool isBold = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          textDirection: pw.TextDirection.rtl,
          value,
          style: textStyle.copyWith(
              fontWeight: isBold ? pw.FontWeight.bold : null),
        ),
        pw.Text(
          textDirection: pw.TextDirection.rtl,
          label,
          style: textStyle.copyWith(
              fontWeight: isBold ? pw.FontWeight.bold : null),
        ),
      ],
    );
  }
}
