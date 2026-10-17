import 'dart:io';

import 'package:csv/csv.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/pdf_utils/pdf_utils_helper.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/gen_qrcode/gen_product.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:albus_la_mobile/constants/app_locales/app_locale_services.dart';
import 'package:albus_la_mobile/constants/app_locales/models/pdf/car_label_pdf_locale_model.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/widgets/products_pdf_btm_nav_sheet/products_pdf_btm_sheet_routes.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf_combiner/models/merge_input.dart';
import 'package:pdf_combiner/pdf_combiner.dart';
import 'package:printing/printing.dart';

enum CarLabelPdfCsvType {
  v1,
  v2,
  list,
  firstPage,
  csv;

  static CarLabelPdfCsvType fromName(String name) =>
      values.firstWhere((e) => e.name == name);
}

class CarLabelPdfCsvUtils {
  //! ******************* gen label pdf v1 *******************
  /// Generate large PDF without memory issues
  static Future<File> genLabelPdfV1({
    void Function(String status, int current, int total)? onProgress,
  }) async {
    final locale = ProductsPdfBtmSheetRoutes.locale;
    final groupNr = ProductsPdfBtmSheetRoutes.group?.groupNr != null
        ? (ProductsPdfBtmSheetRoutes.group?.groupNr).toString()
        : null;
    print('========> groupNr: $groupNr');
    final genProducts = ProductsPdfBtmSheetRoutes.genProducts;
    final carLabelPdfLocale = AppLocaleServices.getLocaleByLangCode(
      locale,
    ).pdfLocaleModel.carLabel;

    print('Total products: ${genProducts.length}');

    // Load images once
    final launchIconBytes = (await rootBundle.load(
      Assets.icons.app.pdfLaunchIconNew.path,
    )).buffer.asUint8List();
    final callWaveIconBytes = (await rootBundle.load(
      Assets.icons.app.callWave.path,
    )).buffer.asUint8List();
    final englishFlag = (await rootBundle.load(
      Assets.images.flagOfTheUnitedKingdom.path,
    )).buffer.asUint8List();

    // Configuration
    const labelsPerPage = 9;
    const productsPerChunk = 198; // Small chunks to avoid memory issues

    // Calculate total pages BEFORE generating
    final totalPages =
        (genProducts.length / labelsPerPage).ceil() + 1; // +1 for first page

    final totalChunks = (genProducts.length / productsPerChunk).ceil();
    final tempDir = await getTemporaryDirectory();
    final chunkPaths = <String>[];

    print('Generating $totalChunks chunks, $totalPages total pages...');

    int currentGlobalPage = 0; // Track global page number

    // Generate PDF chunks
    for (var chunkIndex = 0; chunkIndex < totalChunks; chunkIndex++) {
      final chunkStart = chunkIndex * productsPerChunk;
      final chunkEnd = (chunkStart + productsPerChunk > genProducts.length)
          ? genProducts.length
          : chunkStart + productsPerChunk;

      final chunkProducts = genProducts.sublist(chunkStart, chunkEnd);

      onProgress?.call('Generating', chunkIndex + 1, totalChunks);
      print(
        'Chunk ${chunkIndex + 1}/$totalChunks: ${chunkProducts.length} products',
      );

      // Generate chunk in isolate to avoid blocking UI
      final chunkBytes = await compute(_generateChunkV1, {
        'products': chunkProducts.map((p) => p.toJsonGenPdf()).toList(),
        'launchIconBytes': launchIconBytes,
        'callWaveIconBytes': callWaveIconBytes,
        'englishFlag': englishFlag,
        'carLabelPdfLocale': carLabelPdfLocale.toJson(),
        'labelsPerPage': labelsPerPage,
        'isFirstChunk': chunkIndex == 0,
        'productlength': '${genProducts.length}',
        'startPageNumber': currentGlobalPage,
        'totalPages': totalPages,
        'groupNr': groupNr,
      });

      // Calculate pages in this chunk for next iteration
      final pagesInThisChunk = (chunkProducts.length / labelsPerPage).ceil();
      if (chunkIndex == 0) {
        currentGlobalPage += pagesInThisChunk + 1; // +1 for first page
      } else {
        currentGlobalPage += pagesInThisChunk;
      }

      // Save chunk to file immediately to free memory
      final chunkPath = '${tempDir.path}/pdf_chunk_$chunkIndex.pdf';
      await File(chunkPath).writeAsBytes(chunkBytes);
      chunkPaths.add(chunkPath);

      print(
        'Chunk ${chunkIndex + 1} saved: ${(chunkBytes.length / 1024).toStringAsFixed(0)} KB',
      );
    }

    // Merge all chunks
    onProgress?.call('Merging', 0, 1);
    print('Merging ${chunkPaths.length} chunks...');

    final outputPath =
        '${tempDir.path}/merged_${DateTime.now().millisecondsSinceEpoch}.pdf';

    if (chunkPaths.length == 1) {
      // Only one chunk, just rename it
      await File(chunkPaths.first).rename(outputPath);
    } else {
      // Merge multiple chunks
      await PdfCombiner.mergeMultiplePDFs(
        inputs: chunkPaths.map(MergeInput.path).toList(),
        outputPath: outputPath,
      );

      // Clean up chunk files
      for (final path in chunkPaths) {
        try {
          await File(path).delete();
        } catch (_) {}
      }
    }

    // Move to Downloads
    final finalFile = await PdfUtilsHelper.moveToDownloads(
      File(outputPath),
      'car_labels_v1',
      subfolder: 'lookApp/${groupNr ?? 'unknown'}',
    );

    final fileSize = await finalFile.length();
    print('Final PDF: ${finalFile.path}');
    print('Size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB');

    return finalFile;
  }

  /// Generate a single chunk of PDF pages
  static Future<Uint8List> _generateChunkV1(Map<String, dynamic> data) async {
    final products = (data['products'] as List)
        .map((p) => GenProduct.fromJsonGenPdf(p))
        .toList();
    final labelsPerPage = data['labelsPerPage'] as int;
    final launchIcon = MemoryImage(data['launchIconBytes'] as Uint8List);
    final callWaveIcon = MemoryImage(data['callWaveIconBytes'] as Uint8List);
    final englishFlag = MemoryImage(data['englishFlag'] as Uint8List);
    final carLabelPdfLocale = CarLabelPdfLocaleModel.fromJson(
      data['carLabelPdfLocale'],
    );
    final isFirstChunk = data['isFirstChunk'] as bool;
    final productlength = data['productlength'] as String;
    final startPageNumber = data['startPageNumber'] as int;
    final totalPages = data['totalPages'] as int;
    final groupNr = data['groupNr'] as String?;

    final pdf = Document(version: PdfVersion.pdf_1_5, compress: true);

    final font = await PdfGoogleFonts.jetBrainsMonoBold();
    final idFont = await PdfGoogleFonts.jetBrainsMonoBold();
    const format = PdfPageFormat.cm;

    final totalPagesInChunk = (products.length / labelsPerPage).ceil();

    int currentPage = startPageNumber;

    //! add first page
    if (isFirstChunk) {
      final version = AppLocaleServices.getLocaleByLangCode(
        carLabelPdfLocale.locale,
      ).languageModel.de;

      PdfUtilsHelper.addFirstPage(
        pdf,
        productType: 'Autolabel V1',
        version: version,
        producktLenght: productlength,
        groupNr: groupNr,
        launchIcon: launchIcon,
        child: _carLabelV1(
          index: null,
          carLabelPdfLocale: carLabelPdfLocale,
          font: font,
          idFont: idFont,
          format: format,
          qrId: 'testQrId77',
          pin: '12345678',
          launchIcon: launchIcon,
          callWaveIcon: callWaveIcon,
          englishFlag: englishFlag,
        ),
      );
    }

    for (var pageIndex = 0; pageIndex < totalPagesInChunk; pageIndex++) {
      final pageStart = pageIndex * labelsPerPage;
      final pageEnd = (pageStart + labelsPerPage > products.length)
          ? products.length
          : pageStart + labelsPerPage;

      // Create new list to avoid closure issues
      final pageProducts = List<GenProduct>.from(
        products.sublist(pageStart, pageEnd),
      );

      currentPage++;
      final thisPageNumber = currentPage;

      // final globalStartIndex = startIndex + pageStart;
      pdf.addPage(
        Page(
          pageFormat: PdfPageFormat.a4,
          margin: EdgeInsets.zero,
          build: (context) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: GridView(
                      crossAxisCount: 3,
                      childAspectRatio: 1.37,
                      children: List.generate(pageProducts.length, (i) {
                        return _carLabelV1(
                          index: pageProducts[i].index,
                          carLabelPdfLocale: carLabelPdfLocale,
                          font: font,
                          idFont: idFont,
                          format: format,
                          qrId: pageProducts[i].id,
                          pin: pageProducts[i].pin,
                          launchIcon: launchIcon,
                          callWaveIcon: callWaveIcon,
                          englishFlag: englishFlag,
                        );
                      }),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 20,
                  ),
                  child: PdfUtilsHelper.footerRow(
                    '$thisPageNumber / $totalPages',
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
    return pdf.save();
  }

  /*   static Container _carLabelV1({
    int? index,
    required CarLabelPdfLocaleModel carLabelPdfLocale,
    required Font font,
    required Font idFont,
    required double format,
    required String? pin,
    required String? qrId,
    required MemoryImage launchIcon,
    required MemoryImage callWaveIcon,
  }) {
    final paddging = 0.3 * format;

    return Container(
      margin: EdgeInsets.all(5.0),
      padding: index == null
          ? EdgeInsets.symmetric(vertical: 5.0, horizontal: 7.0)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(K.rm),
        border: Border.all(color: PdfColors.grey600),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: .center,
        children: [
          //! Ativation code text
          Container(
            width: 6.0 * format,
            padding: EdgeInsets.only(bottom: 4.0),
            alignment: Alignment.center,
            child: Text(
              '${carLabelPdfLocale.activationCodeTitle}: $pin',
              style: TextStyle(
                height: 0.0,
                letterSpacing: 0.0,
                font: font,
                fontWeight: FontWeight.bold,
                fontSize: 9.0,
              ),
            ),
          ),

          SizedBox(height: 5.0),

          //! label gradient container
          Container(
            width: 6.0 * format,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(K.rl + 1.7),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  PdfColor.fromInt(0xFF00274F),
                  PdfColor.fromInt(0xFF0D4280),
                ],
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(K.rl),
                border: Border.all(color: PdfColors.white, width: 1.7),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: paddging * 1.5),

                  Row(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .end,
                    children: [
                      Expanded(
                        child: Text(
                          carLabelPdfLocale.contactTitle,
                          style: TextStyle(
                            height: 0.0,
                            letterSpacing: 0.0,
                            color: PdfColors.white,
                            font: font,
                            fontWeight: FontWeight.bold,
                            fontSize: carLabelPdfLocale.contactTitleFontSize,
                          ),
                        ),
                      ),

                      SizedBox(width: 5.0),

                      Container(
                        height: 27.0,
                        width: 27.0,
                        decoration: BoxDecoration(
                          color: PdfColors.green800,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: PdfColors.white,
                            width: 0.7,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Image(callWaveIcon),
                        ),
                      ),
                    ],
                  ),

                  //! ************** contact texts container
                  Text(
                    carLabelPdfLocale.contactSubtitle,
                    style: TextStyle(
                      height: 0.0,
                      letterSpacing: 0.0,
                      color: PdfColors.white,
                      font: font,
                      fontWeight: FontWeight.bold,
                      fontSize: carLabelPdfLocale.contactSubtitleFontSize,
                    ),
                  ),

                  SizedBox(height: paddging * 0.5),

                  //! ************** id and  qrcode container
                  Text(
                    'ID: $qrId',
                    style: TextStyle(
                      fontSize: 8.0,
                      font: idFont,
                      color: PdfColors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  SizedBox(height: paddging * 0.5),

                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: BorderRadius.circular(K.rm),
                    ),
                    child: BarcodeWidget(
                      height: 2.5 * format,
                      width: 2.5 * format,
                      padding: EdgeInsets.zero,
                      data: '${K.lookAppMsgBaseUrl}$qrId',
                      barcode: Barcode.qrCode(),
                    ),
                  ),

                  SizedBox(height: paddging * 0.7),

                  //! ************** look app logo and name and appstors icons
                  Image(launchIcon, width: 1.2 * format),

                  Text(
                    'LookApp',
                    style: TextStyle(
                      font: font,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.white,
                      letterSpacing: 0,
                    ),
                  ),

                  SizedBox(height: paddging * 1.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  } */

  static Container _carLabelV1({
    int? index,
    required CarLabelPdfLocaleModel carLabelPdfLocale,
    required Font font,
    required Font idFont,
    required double format,
    required String? pin,
    required String? qrId,
    required MemoryImage launchIcon,
    required MemoryImage callWaveIcon,
    required MemoryImage englishFlag,
  }) {
    final paddging = 0.3 * format;

    return Container(
      margin: EdgeInsets.all(5.0),
      padding: index == null
          ? EdgeInsets.symmetric(vertical: 5.0, horizontal: 7.0)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: PdfColors.grey600),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: .center,
        children: [
          //! Ativation code text
          Container(
            width: 6.0 * format,
            padding: EdgeInsets.only(bottom: 4.0),
            alignment: Alignment.center,
            child: Text(
              '${carLabelPdfLocale.activationCodeTitle}: $pin',
              style: TextStyle(
                height: 0.0,
                letterSpacing: 0.0,
                font: font,
                fontWeight: FontWeight.bold,
                fontSize: 9.0,
              ),
            ),
          ),

          SizedBox(height: 5.0),

          //! label gradient container
          Container(
            width: 6.0 * format,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.0 + 1.7),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  PdfColor.fromInt(0xFF00274F),
                  PdfColor.fromInt(0xFF0D4280),
                ],
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.0),
                border: Border.all(color: PdfColors.white, width: 1.7),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: paddging * 1.5),

                  Row(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .end,
                    children: [
                      Expanded(
                        child: Text(
                          carLabelPdfLocale.contactTitle,
                          style: TextStyle(
                            height: 0.0,
                            letterSpacing: 0.0,
                            color: PdfColors.white,
                            font: font,
                            fontWeight: FontWeight.bold,
                            fontSize: carLabelPdfLocale.contactTitleFontSize,
                          ),
                        ),
                      ),

                      SizedBox(width: 5.0),

                      Container(
                        height: 27.0,
                        width: 27.0,
                        decoration: BoxDecoration(
                          color: PdfColors.green800,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: PdfColors.white,
                            width: 0.7,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Image(callWaveIcon),
                        ),
                      ),
                    ],
                  ),

                  //! ************** contact texts
                  Text(
                    carLabelPdfLocale.contactSubtitle,
                    style: TextStyle(
                      height: 0.0,
                      letterSpacing: 0.0,
                      color: PdfColors.white,
                      font: font,
                      fontWeight: FontWeight.bold,
                      fontSize: carLabelPdfLocale.contactSubtitleFontSize,
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 2.0),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      gradient: RadialGradient(
                        radius: 12,
                        colors: [PdfColors.white, PdfColors.grey900],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(englishFlag, width: 0.4 * format),

                        SizedBox(width: 4.0),

                        Text(
                          // TODO: from model text and when if en don't show
                          'CONTACT VEHICLE OWNER',
                          style: TextStyle(font: font, fontSize: 8.0),
                        ),
                      ],
                    ),
                  ),

                  //! ************** id and  qrcode container
                  SizedBox(height: paddging * 0.5),

                  Text(
                    'ID: $qrId',
                    style: TextStyle(
                      fontSize: 6.0,
                      font: idFont,
                      color: PdfColors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  SizedBox(height: paddging * 0.5),

                  Container(
                    padding: const EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: BarcodeWidget(
                      height: 2.4 * format,
                      width: 2.4 * format,
                      padding: EdgeInsets.zero,
                      data: '${K.lookAppMsgBaseUrl}$qrId',
                      barcode: Barcode.qrCode(),
                    ),
                  ),

                  //! ************** look app logo and name and appstors icons
                  SizedBox(height: paddging * 0.6),

                  Image(launchIcon, width: 1.2 * format),

                  Text(
                    'LookApp',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.white,
                      letterSpacing: 0,
                    ),
                  ),

                  SizedBox(height: paddging * 1.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //! ******************* gen label pdf v2 *******************
  /// Generate large PDF without memory issues
  static Future<File> genLabelPdfV2({
    void Function(String status, int current, int total)? onProgress,
  }) async {
    final locale = ProductsPdfBtmSheetRoutes.locale;
    final groupNr = ProductsPdfBtmSheetRoutes.group?.groupNr != null
        ? (ProductsPdfBtmSheetRoutes.group?.groupNr).toString()
        : null;
    print('========> groupNr: $groupNr');
    final genProducts = ProductsPdfBtmSheetRoutes.genProducts;
    final carLabelPdfLocale = AppLocaleServices.getLocaleByLangCode(
      locale,
    ).pdfLocaleModel.carLabel;

    print('Total products: ${genProducts.length}');

    // Load images once
    final launchIconBytes = (await rootBundle.load(
      Assets.icons.app.pdfLaunchIconNew.path,
    )).buffer.asUint8List();
    final callWaveIconBytes = (await rootBundle.load(
      Assets.icons.app.callWave.path,
    )).buffer.asUint8List();

    // Configuration
    const labelsPerPage = 4;
    const productsPerChunk = 88; // 4 * 22 Small chunks to avoid memory issues

    // Calculate total pages BEFORE generating
    final totalPages =
        (genProducts.length / labelsPerPage).ceil() + 1; // +1 for first page

    final totalChunks = (genProducts.length / productsPerChunk).ceil();
    final tempDir = await getTemporaryDirectory();
    final chunkPaths = <String>[];

    print('Generating $totalChunks chunks, $totalPages total pages...');

    int currentGlobalPage = 0; // Track global page number

    // Generate PDF chunks
    for (var chunkIndex = 0; chunkIndex < totalChunks; chunkIndex++) {
      final chunkStart = chunkIndex * productsPerChunk;
      final chunkEnd = (chunkStart + productsPerChunk > genProducts.length)
          ? genProducts.length
          : chunkStart + productsPerChunk;

      final chunkProducts = genProducts.sublist(chunkStart, chunkEnd);

      onProgress?.call('Generating', chunkIndex + 1, totalChunks);
      print(
        'Chunk ${chunkIndex + 1}/$totalChunks: ${chunkProducts.length} products',
      );

      // Generate chunk in isolate to avoid blocking UI
      final chunkBytes = await compute(_generateChunkV2, {
        'products': chunkProducts.map((p) => p.toJsonGenPdf()).toList(),
        'launchIconBytes': launchIconBytes,
        'callWaveIconBytes': callWaveIconBytes,
        'carLabelPdfLocale': carLabelPdfLocale.toJson(),
        'labelsPerPage': labelsPerPage,
        'isFirstChunk': chunkIndex == 0,
        'productlength': '${genProducts.length}',
        'startPageNumber': currentGlobalPage,
        'totalPages': totalPages,
        'groupNr': groupNr,
      });

      // Calculate pages in this chunk for next iteration
      final pagesInThisChunk = (chunkProducts.length / labelsPerPage).ceil();
      if (chunkIndex == 0) {
        currentGlobalPage += pagesInThisChunk + 1; // +1 for first page
      } else {
        currentGlobalPage += pagesInThisChunk;
      }

      // Save chunk to file immediately to free memory
      final chunkPath = '${tempDir.path}/pdf_chunk_$chunkIndex.pdf';
      await File(chunkPath).writeAsBytes(chunkBytes);
      chunkPaths.add(chunkPath);

      print(
        'Chunk ${chunkIndex + 1} saved: ${(chunkBytes.length / 1024).toStringAsFixed(0)} KB',
      );
    }

    // Merge all chunks
    onProgress?.call('Merging', 0, 1);
    print('Merging ${chunkPaths.length} chunks...');

    final outputPath =
        '${tempDir.path}/merged_${DateTime.now().millisecondsSinceEpoch}.pdf';

    if (chunkPaths.length == 1) {
      // Only one chunk, just rename it
      await File(chunkPaths.first).rename(outputPath);
    } else {
      // Merge multiple chunks
      await PdfCombiner.mergeMultiplePDFs(
        inputs: chunkPaths.map(MergeInput.path).toList(),
        outputPath: outputPath,
      );

      // Clean up chunk files
      for (final path in chunkPaths) {
        try {
          await File(path).delete();
        } catch (_) {}
      }
    }

    // Move to Downloads
    final finalFile = await PdfUtilsHelper.moveToDownloads(
      File(outputPath),
      'car_labels_v2',
      subfolder: 'lookApp/${groupNr ?? 'unknown'}',
    );

    final fileSize = await finalFile.length();
    print('Final PDF: ${finalFile.path}');
    print('Size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB');

    return finalFile;
  }

  /// Generate a single chunk of PDF pages
  static Future<Uint8List> _generateChunkV2(Map<String, dynamic> data) async {
    final products = (data['products'] as List)
        .map((p) => GenProduct.fromJsonGenPdf(p))
        .toList();
    final labelsPerPage = data['labelsPerPage'] as int;
    final launchIcon = MemoryImage(data['launchIconBytes'] as Uint8List);
    final callWaveIcon = MemoryImage(data['callWaveIconBytes'] as Uint8List);
    final carLabelPdfLocale = CarLabelPdfLocaleModel.fromJson(
      data['carLabelPdfLocale'],
    );
    final isFirstChunk = data['isFirstChunk'] as bool;
    final productlength = data['productlength'] as String;
    final startPageNumber = data['startPageNumber'] as int;
    final totalPages = data['totalPages'] as int;
    final groupNr = data['groupNr'] as String?;

    final pdf = Document(version: PdfVersion.pdf_1_5, compress: true);

    final font = await PdfGoogleFonts.jetBrainsMonoBold();
    final idFont = await PdfGoogleFonts.jetBrainsMonoBold();
    const format = PdfPageFormat.cm;

    final totalPagesInChunk = (products.length / labelsPerPage).ceil();

    int currentPage = startPageNumber;

    //! add first page
    if (isFirstChunk) {
      final version = AppLocaleServices.getLocaleByLangCode(
        carLabelPdfLocale.locale,
      ).languageModel.de;

      PdfUtilsHelper.addFirstPage(
        pdf,
        productType: 'Autolabel V2',
        version: version,
        producktLenght: productlength,
        groupNr: groupNr,
        launchIcon: launchIcon,
        child: _carLabelV2(
          index: null,
          carLabelPdfLocale: carLabelPdfLocale,
          font: font,
          idFont: idFont,
          format: format,
          qrId: 'testQrId77',
          pin: '12345678',
          launchIcon: launchIcon,
          callWaveIcon: callWaveIcon,
        ),
      );
    }

    for (var pageIndex = 0; pageIndex < totalPagesInChunk; pageIndex++) {
      final pageStart = pageIndex * labelsPerPage;
      final pageEnd = (pageStart + labelsPerPage > products.length)
          ? products.length
          : pageStart + labelsPerPage;

      // Create new list to avoid closure issues
      final pageProducts = List<GenProduct>.from(
        products.sublist(pageStart, pageEnd),
      );

      currentPage++;
      final thisPageNumber = currentPage;

      // final globalStartIndex = startIndex + pageStart;
      pdf.addPage(
        Page(
          pageFormat: PdfPageFormat.a4,
          margin: EdgeInsets.zero,
          build: (context) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: GridView(
                      crossAxisCount: 2,
                      // childAspectRatio: 1.37,
                      children: List.generate(pageProducts.length, (i) {
                        return _carLabelV2(
                          index: pageProducts[i].index,
                          carLabelPdfLocale: carLabelPdfLocale,
                          font: font,
                          idFont: idFont,
                          format: format,
                          qrId: pageProducts[i].id,
                          pin: pageProducts[i].pin,
                          launchIcon: launchIcon,
                          callWaveIcon: callWaveIcon,
                        );
                      }),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 20,
                  ),
                  child: PdfUtilsHelper.footerRow(
                    '$thisPageNumber / $totalPages',
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
    return pdf.save();
  }

  static Container _carLabelV2({
    int? index,
    required CarLabelPdfLocaleModel carLabelPdfLocale,
    required Font font,
    required Font idFont,
    required double format,
    required String? pin,
    required String? qrId,
    required MemoryImage launchIcon,
    required MemoryImage callWaveIcon,
  }) {
    final paddging = 0.3 * format;

    return Container(
      width: 10.0 * format,
      margin: EdgeInsets.all(5.0),
      padding: index == null
          ? EdgeInsets.symmetric(vertical: 5.0 + 2.5, horizontal: 5.0)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(K.rm),
        border: Border.all(color: PdfColors.grey600),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: .center,
        children: [
          //! Ativation code text
          Container(
            // width: 9.5 * format,
            padding: EdgeInsets.only(bottom: 4.0),
            alignment: Alignment.center,
            child: Text(
              '${carLabelPdfLocale.activationCodeTitle}: $pin',
              style: TextStyle(
                height: 0.0,
                letterSpacing: 0.0,
                font: font,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
          ),

          SizedBox(height: 2.5),

          //! label gradient container
          Container(
            height: 13.0 * format, // TODO: remove
            width: 9.5 * format,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(K.rl + 2.0),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  PdfColor.fromInt(0xFF00274F),
                  PdfColor.fromInt(0xFF0D4280),
                ],
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(3.0),
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(K.rl),
                border: Border.all(color: PdfColors.white, width: 2.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: paddging * 2.5),

                  Row(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .end,
                    children: [
                      Expanded(
                        child: Text(
                          carLabelPdfLocale.contactTitleV2,
                          style: TextStyle(
                            height: 0.0,
                            letterSpacing:
                                carLabelPdfLocale.contactTitleLetterSpacingV2,
                            color: PdfColors.white,
                            font: font,
                            fontWeight: FontWeight.bold,
                            fontSize: carLabelPdfLocale.contactTitleFontSizeV2,
                          ),
                        ),
                      ),

                      SizedBox(width: 7.0),

                      Container(
                        height: 35.0,
                        width: 35.0,
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: PdfColors.green800,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: PdfColors.white,
                            width: 0.9,
                          ),
                        ),
                        child: Image(callWaveIcon),
                      ),
                    ],
                  ),

                  //! ************** contact texts container
                  Text(
                    carLabelPdfLocale.contactSubtitleV2,
                    style: TextStyle(
                      height: 0.0,
                      letterSpacing: 0.0,
                      color: PdfColors.white,
                      font: font,
                      fontWeight: FontWeight.bold,
                      fontSize: carLabelPdfLocale.contactSubtitleFontSizeV2,
                    ),
                  ),

                  //! ************** id and  qrcode container
                  SizedBox(height: paddging * 1.5),

                  Text(
                    'ID: $qrId',
                    style: TextStyle(
                      fontSize: 12.0,
                      font: idFont,
                      color: PdfColors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  SizedBox(height: paddging * 1.0),

                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: BorderRadius.circular(K.rm),
                    ),
                    child: BarcodeWidget(
                      height: 4.0 * format,
                      width: 4.0 * format,
                      padding: EdgeInsets.zero,
                      data: '${K.lookAppMsgBaseUrl}$qrId',
                      barcode: Barcode.qrCode(),
                    ),
                  ),

                  SizedBox(height: paddging * 1.7),

                  //! ************** look app logo and name and appstors icons
                  Image(launchIcon, width: 2.4 * format),

                  Text(
                    'LookApp',
                    style: TextStyle(
                      font: font,
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.white,
                      letterSpacing: 0,
                    ),
                  ),

                  SizedBox(height: paddging * 1.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //! ******************* gen list pdf *******************
  /// Generate large PDF without memory issues
  static Future<File> genListPdf() async {
    final locale = ProductsPdfBtmSheetRoutes.locale;
    final genProducts = ProductsPdfBtmSheetRoutes.genProducts;
    final group = ProductsPdfBtmSheetRoutes.group;
    final localeModel = AppLocaleServices.getLocaleByLangCode(locale);

    // Load images once
    final launchIconBytes = (await rootBundle.load(
      Assets.icons.app.pdfLaunchIconNew.path,
    )).buffer.asUint8List();
    final callWaveIcon = (await rootBundle.load(
      Assets.icons.app.callWave.path,
    )).buffer.asUint8List();
    final englishFlag = (await rootBundle.load(
      Assets.images.flagOfTheUnitedKingdom.path,
    )).buffer.asUint8List();

    final font = await PdfGoogleFonts.jetBrainsMonoBold();
    final idFont = await PdfGoogleFonts.jetBrainsMonoBold();
    const format = PdfPageFormat.cm;

    final pdf = Document(version: PdfVersion.pdf_1_5, compress: true);

    final finalFile = await PdfUtilsHelper.genProductList(
      pdf,
      productType: 'Autolabel',
      fileName: 'car_labels_list_',
      groupNr: group?.groupNr,
      genProducts: genProducts,
      version: localeModel.languageModel.de,
      launchIconBytes: launchIconBytes,
      child: _carLabelV1(
        carLabelPdfLocale: localeModel.pdfLocaleModel.carLabel,
        font: font,
        idFont: idFont,
        format: format,
        qrId: 'testQrId77',
        pin: '12345678',
        launchIcon: MemoryImage(launchIconBytes),
        callWaveIcon: MemoryImage(callWaveIcon),
        englishFlag: MemoryImage(englishFlag),
      ),
    );

    return finalFile;
  }

  //! ******************* gen first page pdf *******************
  /// Generate large PDF without memory issues
  static Future<File> genFirsPagePdf(String version) async {
    final locale = ProductsPdfBtmSheetRoutes.locale;
    final genProducts = ProductsPdfBtmSheetRoutes.genProducts;
    final group = ProductsPdfBtmSheetRoutes.group;
    final localeModel = AppLocaleServices.getLocaleByLangCode(locale);

    // Load images once
    final launchIconBytes = (await rootBundle.load(
      Assets.icons.app.pdfLaunchIconNew.path,
    )).buffer.asUint8List();

    final callWaveIcon = (await rootBundle.load(
      Assets.icons.app.callWave.path,
    )).buffer.asUint8List();

    final englishFlag = (await rootBundle.load(
      Assets.images.flagOfTheUnitedKingdom.path,
    )).buffer.asUint8List();

    final svgImage = await rootBundle.loadString(
      Assets.productImages.carLabelV1V2,
    );

    final monoRegular = Font.ttf(
      await rootBundle.load('assets/fonts/JetBrainsMono-Regular.ttf'),
    );
    final monoBold = Font.ttf(
      await rootBundle.load('assets/fonts/JetBrainsMono-Bold.ttf'),
    );

    final childSvgImage = SvgImage(
      svg: svgImage,
      customFontLookup: (family, style, weight) => family.contains('JetBrains')
          ? (weight == 'bold' ? monoBold : monoRegular)
          : null,
    );

    /* 
    final childSvgImage = MemoryImage(
      (await rootBundle.load(
        Assets.productImages.carLabelV1V2,
      )).buffer.asUint8List(),
    ); */

    final font = await PdfGoogleFonts.jetBrainsMonoBold();
    final idFont = await PdfGoogleFonts.jetBrainsMonoBold();
    const format = PdfPageFormat.cm;

    final pdf = Document(version: PdfVersion.pdf_1_5, compress: true);

    final fileName = 'car_labels_first_page_$version';

    PdfUtilsHelper.addFirstPage(
      pdf,
      productType: 'Autolabel',
      version: localeModel.languageModel.de,
      producktLenght: genProducts.length.toString(),
      groupNr: group?.groupNr.toString(),
      launchIcon: MemoryImage(launchIconBytes),
      childSvgImage: childSvgImage,
      child: switch (version) {
        'v1' => _carLabelV1(
          carLabelPdfLocale: localeModel.pdfLocaleModel.carLabel,
          font: font,
          idFont: idFont,
          format: format,
          qrId: 'testQrId77',
          pin: '12345678',
          launchIcon: MemoryImage(launchIconBytes),
          callWaveIcon: MemoryImage(callWaveIcon),
          englishFlag: MemoryImage(englishFlag),
        ),
        'v2' => _carLabelV2(
          carLabelPdfLocale: localeModel.pdfLocaleModel.carLabel,
          font: font,
          idFont: idFont,
          format: format,
          qrId: 'testQrId77',
          pin: '12345678',
          launchIcon: MemoryImage(launchIconBytes),
          callWaveIcon: MemoryImage(callWaveIcon),
        ),
        _ => SizedBox.shrink(),
      },
    );

    // Save PDF
    final tempDir = await getTemporaryDirectory();
    final outputPath =
        '${tempDir.path}/$fileName${DateTime.now().millisecondsSinceEpoch}.pdf';

    final pdfBytes = await pdf.save();
    await File(outputPath).writeAsBytes(pdfBytes);

    // Move to Downloads
    final finalFile = await PdfUtilsHelper.moveToDownloads(
      File(outputPath),
      fileName,
      subfolder: 'lookApp/${group?.groupNr ?? 'unknown'}',
    );

    final fileSize = await finalFile.length();
    print('Final PDF: ${finalFile.path}');
    print('Size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB');

    return finalFile;
  }

  //! ******************* gen csv *******************
  /// Generate CSV with index, activationCode, id, qrcode, title and secondaryTitle for all products
  static Future<File> genCsv() async {
    // final locale = ProductsPdfBtmSheetRoutes.locale;
    final groupNr = ProductsPdfBtmSheetRoutes.group?.groupNr != null
        ? (ProductsPdfBtmSheetRoutes.group?.groupNr).toString()
        : null;
    final genProducts = ProductsPdfBtmSheetRoutes.genProducts;
    /*     final carLabelPdfLocale = AppLocaleServices.getLocaleByLangCode(
      locale,
    ).pdfLocaleModel.carLabel;
 */
    /*     final rows = [
      ['Index', 'Activation Code', 'ID', 'QR Code', 'Title', 'Secondary Title'],
      for (final product in genProducts)
        [
          product.index,
          product.pin,
          product.id,
          '${K.lookAppMsgBaseUrl}${product.id}',
          carLabelPdfLocale.contactTitle,
          carLabelPdfLocale.contactSubtitle,
        ],
    ]; */

    // TODO: should be in model
    final rows = [
      ['index', 'activation_code', 'id', 'qr_code'],
      for (final product in genProducts)
        [
          product.index,
          'Aktivierungscode: ${product.pin}',
          'ID: ${product.id}',
          '${K.lookAppMsgBaseUrl}${product.id}',
        ],
    ];
    final csvData =
        '${const ListToCsvConverter(fieldDelimiter: ';', eol: '\n').convert(rows)}\n';

    final tempDir = await getTemporaryDirectory();
    final tempPath =
        '${tempDir.path}/car_labels_${DateTime.now().millisecondsSinceEpoch}.csv';
    final tempFile = await File(tempPath).writeAsString(csvData);

    final finalFile = await PdfUtilsHelper.moveToDownloads(
      tempFile,
      'car_labels_csv',
      subfolder: 'lookApp/${groupNr ?? 'unknown'}',
      extension: 'csv',
    );

    return finalFile;
  }

  //! ******************* widgets *******************
}
