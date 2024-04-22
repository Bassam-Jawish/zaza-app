import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:zaza_app/core/utils/gen/assets.gen.dart';
import 'package:zaza_app/core/utils/pdf_api.dart';
import 'package:zaza_app/core/utils/pdf_invoice_api.dart';
import 'package:zaza_app/features/orders/domain/entities/order_details.dart';
import 'package:zaza_app/injection_container.dart';
export 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PdfInvoiceApi {
  static Future<File> generate(OrderDetailsEntity invoice, buildContext) async {
    final pdf = Document();
    final Uint8List img = await loadImage();

    var fallbackAr = [Font.ttf(await rootBundle.load("fonts/Cairo/Cairo-Medium.ttf"))];
    var fallback = [Font.ttf(await rootBundle.load("fonts/OpenSans/OpenSans-Medium.ttf"))];

    var myTheme = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("fonts/OpenSans/OpenSans-Medium.ttf")),
      bold: Font.ttf(await rootBundle.load("fonts/OpenSans/OpenSans-Bold.ttf")),
      italic: Font.ttf(await rootBundle.load("fonts/OpenSans/OpenSans-Italic.ttf")),
      fontFallback: fallbackAr,
    );

    var myThemeAr = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("fonts/Cairo/Cairo-Medium.ttf")),
      bold: Font.ttf(await rootBundle.load("fonts/Cairo/Cairo-Bold.ttf")),
      fontFallback: fallback,
    );

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      textDirection: languageCode == 'ar' ?  pw.TextDirection.rtl :  pw.TextDirection.ltr,
      theme: languageCode == 'ar' ? myThemeAr : myTheme,
      build: (context) => [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildInvoiceInfo(invoice,buildContext),
                pw.Image(
                    pw.MemoryImage(
                      img,
                    ),
                    width: 180,
                    height: 180,
                    fit: pw.BoxFit.cover),
              ],
            ),
          ],
        ),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        buildTitle(invoice, buildContext),
        buildInvoice(invoice, buildContext),
        Divider(),
        buildTotal(invoice, buildContext),
      ],
    ));

    String fileName = 'invoice_${invoice.orderId}.pdf';
    print('saving PDF file...');
    return PdfApi.saveDocument(name: fileName, pdf: pdf);
  }

  static Future<Uint8List> loadImage() async {
    final ByteData data =
        await rootBundle.load('${Assets.images.logos.logoColored512.path}');
    return data.buffer.asUint8List();
  }

  static Widget buildInvoiceInfo(OrderDetailsEntity info, context) {
    final titles = <String>[
      '${AppLocalizations.of(context)!.invoice_Number}',
      '${AppLocalizations.of(context)!.invoice_Date}',
      '${AppLocalizations.of(context)!.status}',
    ];
    final data = <String>[
      info.orderId.toString(),
      '${DateFormat("yyyy/MM/dd : HH:m:s").format(DateTime.parse(info.createdAt!))}',
      info.status!.toUpperCase(),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];
        return buildText(title: title, value: value, width: 250);
      }),
    );
  }

  static Widget buildTitle(OrderDetailsEntity invoice, context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppLocalizations.of(context)!.iNVOICE}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.4 * PdfPageFormat.cm),

        ],
      );

  static Widget buildInvoice(OrderDetailsEntity invoice, context) {
    final headers = [
      '${AppLocalizations.of(context)!.product_Name}',
      '${AppLocalizations.of(context)!.barcode}',
      '${AppLocalizations.of(context)!.vat}',
      '${AppLocalizations.of(context)!.unit_Name}',
      '${AppLocalizations.of(context)!.desc}',
      '${AppLocalizations.of(context)!.quantity}',
      '${AppLocalizations.of(context)!.unit_Price}',
    ];

    final data = <List<dynamic>>[];

    invoice.productsOrderDetailsList!.forEach((product) {
      product.productUnitsOrderDetailsList!.forEach((unit) {
        var s = unit.desc;
        String desc = s!.substring(1);
        dynamic priceOneUnit = (unit.unitDetailsOrderModel!.totalPrice / unit.unitDetailsOrderModel!.amount);
        dynamic taxPrice = priceOneUnit * product.tax! / 100;
        data.add([
          product.productName,
          product.barCode,
          product.tax == 0 ? 'No Tax' : '${product.tax}%',
          unit.unitOrderModel!.unitName,
          s,
          '${unit.unitDetailsOrderModel!.amount}',
          '\€${(priceOneUnit).toStringAsFixed(2)}',
        ]);
      });
    });

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
      cellStyle: TextStyle(fontSize: 7),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
        5: Alignment.center,
        6: Alignment.center,
      },
    );
  }

  static Widget buildTotal(OrderDetailsEntity invoice, context) {
    // final vatPercent = 100 - (invoice.totalPrice * 100) / invoice.totalPriceAfterTax;
    // final vat = "${(invoice.totalPriceAfterTax - invoice.totalPrice).toStringAsFixed(2)} \€";
    final total = "${invoice.totalPrice.toStringAsFixed(2)} \€";
    final totalAfterPrice =
        "${invoice.totalPriceAfterTax.toStringAsFixed(2)} \€";

    Map<double, double> taxSumMap = calculateTaxSum(invoice);
    List<TaxSummary> taxSummaries = taxSumMap.entries
        .map((entry) => TaxSummary(entry.key, entry.value))
        .toList();

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: '${AppLocalizations.of(context)!.net_total}:',
                  value: total,
                  unite: true,
                ),

                // code

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: taxSummaries.map((summary) {
                    return buildText(
                      title: '${summary.percentage.toString()}%',
                      value: '${summary.sum.toStringAsFixed(2)} \€',
                      unite: true,
                    );
                  }).toList(),
                ),

                Divider(),
                buildText(
                  title: '${AppLocalizations.of(context)!.total_amount_with_vat}: ',
                  titleStyle:
                    TextStyle(fontWeight: FontWeight.bold,),
                  value: totalAfterPrice,
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle;
    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}

class TaxSummary {
  final double percentage;
  final double sum;

  TaxSummary(this.percentage, this.sum);
}

Map<double, double> calculateTaxSum(OrderDetailsEntity invoice) {
  Map<double, double> taxSumMap = {};

    invoice.productsOrderDetailsList!.forEach((product) {
      double taxPercentage = product.tax!.toDouble();
      product.productUnitsOrderDetailsList!.forEach((unit) {

        // if (taxSumMap.containsKey(taxPercentage)) {
        //   taxSumMap.update(taxPercentage, (value) => value + unit.unitDetailsOrderModel!.totalPrice,
        //       ifAbsent: () => unit.unitDetailsOrderModel!.totalPrice);
        // } else {
        //   taxSumMap[taxPercentage] = unit.unitDetailsOrderModel!.totalPrice;
        // }

        double taxPrice = ((taxPercentage * unit.unitDetailsOrderModel!.totalPrice) / 100);
        taxSumMap.update(taxPercentage, (value) => value + taxPrice,
            ifAbsent: () => taxPrice);
      });
    });


  return taxSumMap;
}
