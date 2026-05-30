import 'dart:io';

import 'package:albus_la_mobile/constants/app_locales/models/pdf/keychain_pdf_locale_model.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/gen_qrcode/gen_product.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:albus_la_mobile/constants/app_locales/app_locale_services.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/widgets/products_pdf_btm_nav_sheet/products_pdf_btm_sheet_routes.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf_combiner/models/merge_input.dart';
import 'package:pdf_combiner/pdf_combiner.dart';
import 'package:printing/printing.dart';

import 'pdf_utils_helper.dart';

enum KeychainPdfType { metalSliver, list }

class KeychainPdfUtils {
  //! ******************* gen orginal pdf
  /// Generate large PDF without memory issues
  static Future<File> genMetalSilverPdf({
    void Function(String status, int current, int total)? onProgress,
  }) async {
    final locale = ProductsPdfBtmSheetRoutes.locale;
    final groupNr = ProductsPdfBtmSheetRoutes.group?.groupNr != null
        ? (ProductsPdfBtmSheetRoutes.group?.groupNr).toString()
        : null;
    print('========> groupNr: $groupNr');
    final genProducts = ProductsPdfBtmSheetRoutes.genProducts;
    final keychainPdfLocale = AppLocaleServices.getLocaleByLangCode(
      locale,
    ).pdfLocaleModel.keychain;

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
        'keychainPdfLocale': keychainPdfLocale.toJson(),
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
      'keychain_',
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
    final keychainPdfLocale = KeychainPdfLocaleModel.fromJson(
      data['keychainPdfLocale'],
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

    // TODO:
    //! add first page
    if (isFirstChunk) {
      final version = AppLocaleServices.getLocaleByLangCode(
        keychainPdfLocale.locale,
      ).languageModel.de;

      PdfUtilsHelper.addFirstPage(
        pdf,
        productType: 'Schlüsselanhänger',
        version: version,
        producktLenght: productlength,
        groupNr: groupNr,
        launchIcon: launchIcon,
        child: _firstPageExampleChild(
          font: font,
          format: format,
          qrId: 'testQrId77',
          keychainPdfLocale: keychainPdfLocale,
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
                        return _metalSilverBack(
                          // index: globalStartIndex + i,
                          index: pageProducts[i].index,
                          keychainPdfLocale: keychainPdfLocale,
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
      productType: 'Schlüsselanhänger',
      fileName: 'keychain_lists_',
      genProducts: genProducts,
      version: localeModel.languageModel.de,
      launchIconBytes: launchIconBytes,
      child: _firstPageExampleChild(
        font: font,
        format: format,
        qrId: 'testQrId77',
        keychainPdfLocale: localeModel.pdfLocaleModel.keychain,
        launchIcon: MemoryImage(launchIconBytes),
        appStoreImage: MemoryImage(appStoreBytes),
        playStoreImage: MemoryImage(playStoreBytes),
      ),
    );

    return finalFile;
  }

  //! ******************* widget
  static _firstPageExampleChild({
    required Font font,
    required double format,
    required String? qrId,
    required KeychainPdfLocaleModel keychainPdfLocale,
    required MemoryImage launchIcon,
    required MemoryImage appStoreImage,
    required MemoryImage playStoreImage,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _metalSilverFront(
          font: font,
          format: format,
          qrId: qrId,
          keychainPdfLocale: keychainPdfLocale,
          launchIcon: launchIcon,
          appStoreImage: appStoreImage,
          playStoreImage: playStoreImage,
        ),
        SizedBox(width: 30),
        _metalSilverBack(
          font: font,
          format: format,
          qrId: qrId,
          keychainPdfLocale: keychainPdfLocale,
          launchIcon: launchIcon,
          appStoreImage: appStoreImage,
          playStoreImage: playStoreImage,
        ),
      ],
    );
  }

  static Container _metalSilverFront({
    required Font font,
    required double format,
    required String? qrId,
    required KeychainPdfLocaleModel keychainPdfLocale,
    required MemoryImage launchIcon,
    required MemoryImage appStoreImage,
    required MemoryImage playStoreImage,
  }) {
    return Container(
      height: 7.0 * format,
      width: 4.0 * format,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(55.0),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //! ************** Keyring hole
          SizedBox(height: 10.0),
          Container(
            height: 12.0,
            width: 12.0,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: PdfColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: PdfColors.black, width: 1.5),
            ),
          ),
          //! ************** look app logo and name and appstors icons
          SizedBox(height: 22.0),
          Image(launchIcon, width: 75.0),
          SizedBox(height: 10.0),
          Text(
            'LookApp',
            style: TextStyle(
              fontSize: 18.5,
              fontWeight: FontWeight.bold,
              color: PdfColors.white,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }

  static Column _metalSilverBack({
    int? index,
    required Font font,
    required double format,
    required String? qrId,
    required KeychainPdfLocaleModel keychainPdfLocale,
    required MemoryImage launchIcon,
    required MemoryImage appStoreImage,
    required MemoryImage playStoreImage,
  }) {
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
          height: 7.0 * format,
          width: 4.0 * format,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(55.0),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //! ************** Keyring hole
              SizedBox(height: 10.0),
              Container(
                height: 12.0,
                width: 12.0,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: PdfColors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: PdfColors.black, width: 1.5),
                ),
              ),

              //! ************** Contact owner text
              SizedBox(height: 10),
              Text(
                keychainPdfLocale.contactTitle,
                style: TextStyle(
                  fontSize: keychainPdfLocale.contactTitleFontSize,
                  fontWeight: FontWeight.bold,
                  color: PdfColors.white,
                  letterSpacing: keychainPdfLocale.contactTitleLetterSpacing,
                ),
              ),

              //! ************** qrcode container
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
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
              Text(
                'ID: $qrId',
                style: TextStyle(
                  fontSize: 8.0,
                  font: font,
                  color: PdfColors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),

              //! ************** Year text
              SizedBox(height: 13.0),
              Text(
                DateTime.now().year.toString(),
                style: const TextStyle(fontSize: 9.0, color: PdfColors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
