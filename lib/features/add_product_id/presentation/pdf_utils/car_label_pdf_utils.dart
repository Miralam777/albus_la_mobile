import 'dart:io';

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

enum CarLabelPdfType { orginal, list }

class CarLabelPdfUtils {
  //! ******************* gen car label pdf
  /// Generate large PDF without memory issues
  static Future<File> genLabelPdf({
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
    final playStoreBytes = (await rootBundle.load(
      Assets.images.playStoreDark.path,
    )).buffer.asUint8List();
    final appStoreBytes = (await rootBundle.load(
      Assets.images.appStoreDark.path,
    )).buffer.asUint8List();
    final launchIconBytes = (await rootBundle.load(
      Assets.icons.app.pdfLaunchIconNew.path,
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
      final chunkBytes = await compute(_generateChunk, {
        'products': chunkProducts.map((p) => p.toJsonGenPdf()).toList(),
        'playStoreBytes': playStoreBytes,
        'appStoreBytes': appStoreBytes,
        'launchIconBytes': launchIconBytes,
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
      'car_labels_',
    );

    final fileSize = await finalFile.length();
    print('Final PDF: ${finalFile.path}');
    print('Size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB');

    return finalFile;
  }

  /// Generate a single chunk of PDF pages
  static Future<Uint8List> _generateChunk(Map<String, dynamic> data) async {
    final products = (data['products'] as List)
        .map((p) => GenProduct.fromJsonGenPdf(p))
        .toList();
    final labelsPerPage = data['labelsPerPage'] as int;
    final playStoreImage = MemoryImage(data['playStoreBytes'] as Uint8List);
    final appStoreImage = MemoryImage(data['appStoreBytes'] as Uint8List);
    final launchIcon = MemoryImage(data['launchIconBytes'] as Uint8List);
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
        productType: 'Autolabel',
        version: version,
        producktLenght: productlength,
        groupNr: groupNr,
        launchIcon: launchIcon,
        // child: _carLabel(
        child: _carLabelV3(
          carLabelPdfLocale: carLabelPdfLocale,
          font: font,
          format: format,
          qrId: 'testQrId77',
          launchIcon: launchIcon,
          appStoreImage: appStoreImage,
          playStoreImage: playStoreImage,
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
                        return _carLabelV3(
                          // index: globalStartIndex + i,
                          index: pageProducts[i].index,
                          carLabelPdfLocale: carLabelPdfLocale,
                          font: font,
                          format: format,
                          qrId: pageProducts[i].id,
                          // qrId: 'KFZ1HALTER',
                          launchIcon: launchIcon,
                          appStoreImage: appStoreImage,
                          playStoreImage: playStoreImage,
                        );
                        return _carLabel(
                          // index: globalStartIndex + i,
                          index: pageProducts[i].index,
                          carLabelPdfLocale: carLabelPdfLocale,
                          font: font,
                          format: format,
                          qrId: pageProducts[i].id,
                          launchIcon: launchIcon,
                          appStoreImage: appStoreImage,
                          playStoreImage: playStoreImage,
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

  //! ******************* gen list pdf
  /// Generate large PDF without memory issues
  static Future<File> genListPdf() async {
    final locale = ProductsPdfBtmSheetRoutes.locale;
    final genProducts = ProductsPdfBtmSheetRoutes.genProducts;
    final localeModel = AppLocaleServices.getLocaleByLangCode(locale);

    // Load images once
    final playStoreBytes = (await rootBundle.load(
      Assets.images.playStoreDark.path,
    )).buffer.asUint8List();
    final appStoreBytes = (await rootBundle.load(
      Assets.images.appStoreDark.path,
    )).buffer.asUint8List();
    final launchIconBytes = (await rootBundle.load(
      Assets.icons.app.pdfLaunchIconNew.path,
    )).buffer.asUint8List();

    final font = await PdfGoogleFonts.jetBrainsMonoBold();
    const format = PdfPageFormat.cm;

    final pdf = Document(version: PdfVersion.pdf_1_5, compress: true);

    final finalFile = await PdfUtilsHelper.genProductList(
      pdf,
      productType: 'Autolabel',
      fileName: 'car_labels_list_',
      genProducts: genProducts,
      version: localeModel.languageModel.de,
      launchIconBytes: launchIconBytes,
      // child: _carLabel(
      child: _carLabelV3(
        carLabelPdfLocale: localeModel.pdfLocaleModel.carLabel,
        font: font,
        format: format,
        qrId: 'testQrId77',
        launchIcon: MemoryImage(launchIconBytes),
        appStoreImage: MemoryImage(appStoreBytes),
        playStoreImage: MemoryImage(playStoreBytes),
      ),
    );

    return finalFile;
  }

  //! ******************* widget
  static Column _carLabelV3({
    int? index,
    required CarLabelPdfLocaleModel carLabelPdfLocale,
    required Font font,
    required double format,
    required String? qrId,
    required MemoryImage launchIcon,
    required MemoryImage appStoreImage,
    required MemoryImage playStoreImage,
  }) {
    final paddging = 0.3 * format;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // index != null ? ...[] : ...[],
        if (index != null) SizedBox(height: 10),
        if (index != null)
          Text(
            '$index',
            style: TextStyle(
              fontSize: 15.0,
              font: font,
              color: PdfColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        SizedBox(height: 2),
        Container(
          height: 8.2 * format,
          // width: 5.5 * format,
          width: 6.0 * format,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(K.rl),
            /*             gradient: const LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              stops: [0.5, 0.7, 0.9],
              colors: [
                PdfColor.fromInt(0xFF013069),
                PdfColor.fromInt(0xFF0e4c96),
                PdfColor.fromInt(0xFF1161bf),
              ],
            ), */
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.4, 0.6, 0.9],
              colors: [
                PdfColor.fromInt(0xFF013069),
                PdfColor.fromInt(0xFF0e4c96),
                // PdfColor.fromInt(0xFF1161bf),
                // PdfColor.fromInt(0xFF4097FF),
                PdfColor.fromInt(0xFF3686E3),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //! ************** look app logo and name and appstors icons
              // SizedBox(height: paddging * 0.5),
              SizedBox(height: 0.15 * format),
              // Image(launchIcon, width: 1.5 * format),
              // Image(launchIcon, width: 1.6 * format),
              Image(launchIcon, height: 1.7 * format),
              Text(
                'LookApp',
                style: TextStyle(
                  // fontSize: 18.5,
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                  color: PdfColors.white,
                  letterSpacing: 0,
                ),
              ),

              //! ************** qrcode container
              // SizedBox(height: paddging * 0.5),
              // SizedBox(height: 0.3 * format),
              SizedBox(height: 0.15 * format),
              Container(
                // padding: const EdgeInsets.all(8.0),
                padding: EdgeInsets.all(0.3 * format),
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
              // SizedBox(height: paddging * 0.5),
              SizedBox(height: 0.15 * format),
              Text(
                'ID: $qrId',
                style: TextStyle(
                  fontSize: 8.0,
                  font: font,
                  color: PdfColors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              //! ************** contact texts container
              // SizedBox(height: paddging * 0.15),
              // SizedBox(height: 0.2 * format),
              SizedBox(height: 0.1 * format),
              // SizedBox(height: 3.5),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    lineSpacing: -6.0,
                    font: font,
                    color: PdfColors.white,
                  ),
                  children: [
                    TextSpan(
                      text: '${carLabelPdfLocale.contactTitle}\n',
                      style: TextStyle(
                        fontSize: carLabelPdfLocale.contactTitleFontSize,
                        letterSpacing:
                            carLabelPdfLocale.contactTitleLetterSpacing,
                      ),
                    ),
                    TextSpan(
                      text: carLabelPdfLocale.contactSubtitle,
                      style: TextStyle(
                        fontSize: carLabelPdfLocale.contactSubtitleFontSize,
                        letterSpacing:
                            carLabelPdfLocale.contactSubtitleLetterSpacing,
                      ),
                    ),
                  ],
                ),
              ),
              /*                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          lineSpacing: -6.0,
                          font: font,
                          color: PdfColors.white,
                        ),
                        children: [
                          TextSpan(
                            text: '${carLabelPdfLocale.contactTitle}\n',
                            style: TextStyle(
                              fontSize: carLabelPdfLocale.contactTitleFontSize,
                              letterSpacing:
                                  carLabelPdfLocale.contactTitleLetterSpacing,
                            ),
                          ),
                          TextSpan(
                            text: carLabelPdfLocale.contactSubtitle,
                            style: TextStyle(
                              fontSize:
                                  carLabelPdfLocale.contactSubtitleFontSize,
                              letterSpacing: carLabelPdfLocale
                                  .contactSubtitleLetterSpacing,
                            ),
                          ),
                        ],
                      ),
                    ),
/*                     SizedBox(
                      height: 0.5 * format,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 0.15,
                              horizontal: 0.12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border:
                                  Border.all(color: PdfColors.white, width: 1),
                            ),
                            child: Image(appStoreImage),
                          ),
                          SizedBox(width: 0.1 * format),
                           Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 0.15,
                              horizontal: 0.12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border:
                                  Border.all(color: PdfColors.white, width: 1),
                            ),
                            child: Image(playStoreImage),
                          ),
                        ],
                      ),
                    ), */
                  ],
                ), */
              SizedBox(height: paddging * 0.5),
            ],
          ),
        ),
      ],
    );
  }

  static Column _carLabel({
    int? index,
    required CarLabelPdfLocaleModel carLabelPdfLocale,
    required Font font,
    required double format,
    required String? qrId,
    required MemoryImage launchIcon,
    required MemoryImage appStoreImage,
    required MemoryImage playStoreImage,
  }) {
    final paddging = 0.3 * format;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (index != null) SizedBox(height: 10),
        if (index != null)
          Text(
            '$index',
            style: TextStyle(
              fontSize: 15.0,
              font: font,
              color: PdfColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        SizedBox(height: 2),
        Container(
          height: 8.2 * format,
          width: 5.5 * format,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(K.rl),
            gradient: const LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              stops: [0.5, 0.7, 0.9],
              colors: [
                PdfColor.fromInt(0xFF013069),
                PdfColor.fromInt(0xFF0e4c96),
                PdfColor.fromInt(0xFF1161bf),
              ],
            ),
          ),
          child: ClipRRect(
            verticalRadius: K.rl,
            horizontalRadius: K.rl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //! ************** look app logo and name and appstors icons
                SizedBox(height: paddging * 0.5),
                Image(launchIcon, width: 1.5 * format),
                Text(
                  'LookApp',
                  style: TextStyle(
                    fontSize: 18.5,
                    fontWeight: FontWeight.bold,
                    color: PdfColors.white,
                    letterSpacing: 0,
                  ),
                ),

                //! ************** qrcode container
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
                SizedBox(height: paddging * 0.5),
                Text(
                  'ID: $qrId',
                  style: TextStyle(
                    fontSize: 8.0,
                    font: font,
                    color: PdfColors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                //! ************** contact texts container
                SizedBox(height: paddging * 0.15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          lineSpacing: -6.0,
                          font: font,
                          color: PdfColors.white,
                        ),
                        children: [
                          TextSpan(
                            text: '${carLabelPdfLocale.contactTitle}\n',
                            style: TextStyle(
                              fontSize: carLabelPdfLocale.contactTitleFontSize,
                              letterSpacing:
                                  carLabelPdfLocale.contactTitleLetterSpacing,
                            ),
                          ),
                          TextSpan(
                            text: carLabelPdfLocale.contactSubtitle,
                            style: TextStyle(
                              fontSize:
                                  carLabelPdfLocale.contactSubtitleFontSize,
                              letterSpacing: carLabelPdfLocale
                                  .contactSubtitleLetterSpacing,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.5 * format,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 0.15,
                              horizontal: 0.12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                color: PdfColors.white,
                                width: 1,
                              ),
                            ),
                            child: Image(appStoreImage),
                          ),
                          SizedBox(width: 0.1 * format),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 0.15,
                              horizontal: 0.12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                color: PdfColors.white,
                                width: 1,
                              ),
                            ),
                            child: Image(playStoreImage),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: paddging * 0.5),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
