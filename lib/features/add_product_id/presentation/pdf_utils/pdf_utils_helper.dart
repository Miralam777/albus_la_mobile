import 'dart:io';

import 'package:albus_la_mobile/constants/app_locales/models/pdf/card_pdf_locale_model.dart';
import 'package:albus_la_mobile/constants/app_locales/models/pdf/keychain_pdf_locale_model.dart';
import 'package:albus_la_mobile/core/utils/helpers/helpers.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/pdf_utils/models/product_pdf_type_enum.dart';
import 'package:albus_la_mobile/constants/app_locales/app_locale_services.dart';
import 'package:albus_la_mobile/constants/app_locales/models/pdf/car_label_pdf_locale_model.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/widgets/products_pdf_btm_nav_sheet/products_pdf_btm_sheet_routes.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/gen_qrcode/gen_product.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

// TODO: remove or
// TODO: clean
class PdfUtilsHelper {
  // TODO: remove this
  static Future<Uint8List> generateTestPdfs({
    required PdfPageFormat format,
    required ProductPdfType? pdfType,
  }) async {
    final locale = ProductsPdfBtmSheetRoutes.locale;
    final group = ProductsPdfBtmSheetRoutes.group;
    // ! max 920
    final genProducts = ProductsPdfBtmSheetRoutes.genProducts;

    final cardLocaleModel = AppLocaleServices.getLocaleByLangCode(
      locale,
    ).pdfLocaleModel.card;

    final version = AppLocaleServices.getLocaleByLangCode(
      cardLocaleModel.locale,
    ).languageModel.de;
    final groupNr = '${group?.groupNr}';

    print('locale: $locale');
    print('group: $group');
    print('genProducts: ${genProducts.length}');

    final pdf = Document(version: PdfVersion.pdf_1_5, compress: true);

    final font = await PdfGoogleFonts.jetBrainsMonoBold();

    // Load images once to avoid memory issues
    final playStoreImage = MemoryImage(
      (await rootBundle.load(
        Assets.images.playStoreDark.path,
      )).buffer.asUint8List(),
    );

    final appStoreImage = MemoryImage(
      (await rootBundle.load(
        Assets.images.appStoreDark.path,
      )).buffer.asUint8List(),
    );

    final launchIcon = MemoryImage(
      (await rootBundle.load(
        Assets.icons.app.pdfLaunchIconNew.path,
      )).buffer.asUint8List(),
    );

    final backgroundImage = MemoryImage(
      (await rootBundle.load(
        Assets.images.cardBgImage.path,
      )).buffer.asUint8List(),
    );

    const format = PdfPageFormat.cm;

    // Labels per page (e.g. 3x3 = 9)
    const labelsPerRow = 3;
    const rowsPerPage = 3;
    const labelsPerPage = labelsPerRow * rowsPerPage;

    // TODO: move it in car label pdf utils
    //! add first page
    addFirstPage(
      pdf,
      productType: 'Portemonnaie',
      version: version,
      producktLenght: genProducts.length.toString(),
      groupNr: groupNr,
      launchIcon: launchIcon,
      // ! card
      /*       child: _firstPageExampleChild(
        font: font,
        format: format,
        qrId: 'testQrId77',
        cardLocaleModel: cardLocaleModel,
        launchIcon: launchIcon,
        appStoreImage: appStoreImage,
        playStoreImage: playStoreImage,
        backgroundImage: backgroundImage,
      ), */
      // ! car label
      child: _carLabelV3(
        // index: index,
        carLabelPdfLocale: CarLabelPdfLocaleModel(
          locale: 'de',
          contactTitle: 'KFZ-HALTER',
          contactTitleFontSize: 16.2,
          contactSubtitle: 'KONTAKTIEREN',
          contactSubtitleFontSize: 13.5,
        ),
        font: font,
        format: format,
        qrId: 'testQrId77',
        launchIcon: launchIcon,
        appStoreImage: appStoreImage,
        playStoreImage: playStoreImage,
      ),
    );

    // Split into pages to prevent memory overflow
    for (
      var pageStart = 0;
      pageStart < genProducts.length;
      pageStart += labelsPerPage
    ) {
      final pageEnd = (pageStart + labelsPerPage > genProducts.length)
          ? genProducts.length
          : pageStart + labelsPerPage;

      final pageProducts = genProducts.sublist(pageStart, pageEnd);

      // ! card page
      /*       pdf.addPage(
        Page(
          pageFormat: PdfPageFormat.a4,
          // margin: const EdgeInsets.all(10),
          margin: EdgeInsets.zero,
          build: (context) {
            // TODO: last time memory out of problem
            // return Wrap(
            // spacing: 10,
            // runSpacing: 10,
            // alignment: WrapAlignment.center,
            // crossAxisAlignment: WrapCrossAlignment.center,
            // runAlignment: WrapAlignment.center,
            // verticalDirection: VerticalDirection.up,
            // !
/*             return GridView(
              crossAxisCount: 3, // 3 Spalten
              childAspectRatio: 1.37, // Quadratisch
              children: pageProducts.asMap().entries.map((entry) {
                final index = pageStart + entry.key;
                final product = entry.value;

                return _walletCardFront(
                  font: font,
                  qrId: product.id,
                  cardLocaleModel: cardLocaleModel,
                  launchIcon: launchIcon,
                  appStoreImage: appStoreImage,
                  playStoreImage: playStoreImage,
                );
              }).toList(),
            ); */

            return Center(
              child: Wrap(
                spacing: 0.5 * PdfPageFormat.cm,
                runSpacing: 0.5 * PdfPageFormat.cm,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: pageProducts.asMap().entries.map((entry) {
                  final index = pageStart + entry.key;
                  final product = entry.value;
                  return _walletCardBack(
                    index: index,
                    font: font,
                    format: format,
                    qrId: product.id,
                    cardLocaleModel: cardLocaleModel,
                    launchIcon: launchIcon,
                    appStoreImage: appStoreImage,
                    playStoreImage: playStoreImage,
                  );
                }).toList(),
              ),
            );
          },
        ),
      ); */

      // ! car labe page
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
                          index: i,
                          carLabelPdfLocale: CarLabelPdfLocaleModel(
                            locale: 'de',
                            contactTitle: 'KFZ-HALTER',
                            // contactTitleFontSize: 16.2,
                            contactTitleFontSize: 20.0,
                            contactSubtitle: 'KONTAKTIEREN',
                            // contactSubtitleFontSize: 13.5,
                            contactSubtitleFontSize: 16.6,
                          ),
                          font: font,
                          format: format,
                          // qrId: product.id,
                          qrId: pageProducts[i].id,
                          launchIcon: launchIcon,
                          appStoreImage: appStoreImage,
                          playStoreImage: playStoreImage,
                        );
                        /*                         return _carLabel(
                          // index: globalStartIndex + i,
                          index: pageProducts[i].index,
                          carLabelPdfLocale: carLabelPdfLocale,
                          font: font,
                          format: format,
                          qrId: pageProducts[i].id,
                          launchIcon: launchIcon,
                          appStoreImage: appStoreImage,
                          playStoreImage: playStoreImage,
                        ); */
                      }),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 20,
                  ),
                  child: PdfUtilsHelper.footerRow('1 / 1'),
                ),
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
  }

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
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    lineSpacing: -4.0,
                    // lineSpacing: -6.0,
                    font: font,
                    color: PdfColors.white,
                  ),
                  children: [
                    /*    TextSpan(
                      text: '${carLabelPdfLocale.contactTitle}\n',
                      style: TextStyle(
                        fontSize: carLabelPdfLocale.contactTitleFontSize,
                        letterSpacing:
                            carLabelPdfLocale.contactTitleLetterSpacing,
                      ),
                    ), */
                    /* TextSpan(
                      text: carLabelPdfLocale.contactSubtitle,
                      style: TextStyle(
                        fontSize: carLabelPdfLocale.contactSubtitleFontSize,
                        letterSpacing:
                            carLabelPdfLocale.contactSubtitleLetterSpacing,
                      ),
                    ), */
                    TextSpan(
                      // text: '${carLabelPdfLocale.contactTitle}\n',
                      // text: '${carLabelPdfLocale.contactTitle}\n',
                      text: 'FAHRZEUGHALTER\n',
                      style: TextStyle(
                        // fontSize: carLabelPdfLocale.contactTitleFontSize,
                        fontSize: 13.0,
                        letterSpacing: 0,
                      ),
                    ),
                    TextSpan(
                      text: 'ANONYM & SICHER\n',
                      style: TextStyle(fontSize: 13.0, letterSpacing: 0),
                    ),
                    TextSpan(
                      text: carLabelPdfLocale.contactSubtitle,
                      style: TextStyle(fontSize: 13.0, letterSpacing: 0),
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

  /*   static Column _carLabelV3({
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
              // Image(launchIcon, width: 1.7 * format),
              Image(launchIcon, height: 1.7 * format),
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
              // SizedBox(height: paddging * 0.5),
              SizedBox(height: 0.3 * format),
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
  } */

  // TODO: remove at end
  // TODO: remove at end
  // TODO: remove at end
  // TODO: move to catd
  static _firstPageExampleChild({
    required Font font,
    required double format,
    required String? qrId,
    required CardPdfLocaleModel cardLocaleModel,
    required MemoryImage launchIcon,
    required MemoryImage appStoreImage,
    required MemoryImage playStoreImage,
    required MemoryImage backgroundImage,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _walletCardFront(
          font: font,
          qrId: qrId,
          cardLocaleModel: cardLocaleModel,
          launchIcon: launchIcon,
          appStoreImage: appStoreImage,
          playStoreImage: playStoreImage,
          backgroundImage: backgroundImage,
        ),
        SizedBox(width: 30),
        _walletCardBack(
          font: font,
          format: format,
          qrId: qrId,
          cardLocaleModel: cardLocaleModel,
          launchIcon: launchIcon,
          appStoreImage: appStoreImage,
          playStoreImage: playStoreImage,
        ),
      ],
    );
  }

  static Container _walletCardFront({
    required Font font,
    required String? qrId,
    required CardPdfLocaleModel cardLocaleModel,
    required MemoryImage launchIcon,
    required MemoryImage appStoreImage,
    required MemoryImage playStoreImage,
    required MemoryImage backgroundImage,
  }) {
    const radius = 3 * PdfPageFormat.mm;

    return Container(
      height: 5.4 * PdfPageFormat.cm,
      width: 8.56 * PdfPageFormat.cm,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
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
        horizontalRadius: radius,
        verticalRadius: radius,
        child: Stack(
          children: [
            //! ************** background image
            Positioned.fill(
              child: Opacity(
                opacity: 0.5,
                child: Image(backgroundImage, fit: BoxFit.cover),
              ),
            ),
            Align(
              child: Column(
                children: [
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
            ),
          ],
        ),
      ),
    );
  }

  static Column _walletCardBack({
    int? index,
    required Font font,
    required double format,
    required String? qrId,
    required CardPdfLocaleModel cardLocaleModel,
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
          height: 5.4 * PdfPageFormat.cm,
          width: 8.56 * PdfPageFormat.cm,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3 * PdfPageFormat.mm),
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
              //! ************** Contact owner text
              SizedBox(height: 10),
              Text(
                'Contact Owner',
                style: TextStyle(
                  // TODO: fontSize
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: PdfColors.white,
                  letterSpacing: 0,
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

  // TODO: remove at end
  // TODO: remove at end
  // TODO: remove at end

  // TODO: remove at end
  static Column _carLabelV1({
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
              // fontSize: 5.0,
              font: font,
              color: PdfColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        SizedBox(height: 2),
        Container(
          width: 5.5 * format,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(K.rl),
            border: Border.all(color: PdfColors.blue400, width: 2),
          ),
          child: ClipRRect(
            verticalRadius: K.rl,
            horizontalRadius: K.rl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //! ************** look app logo and name and appstors icons
                SizedBox(height: paddging * 1.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      horizontalRadius: K.rs,
                      verticalRadius: K.rs,
                      child: Image(launchIcon, width: 1 * format),
                    ),
                    SizedBox(width: 0.2 * format),
                    Column(
                      children: [
                        Text(
                          'LookApp',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 0.05 * format),
                        SizedBox(
                          height: 0.37 * format,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(appStoreImage),
                              SizedBox(width: 0.1 * format),
                              Image(playStoreImage),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                //! ************** qrcode container
                SizedBox(height: paddging * 1.0),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(K.rm),
                    border: Border.all(color: PdfColors.grey600),
                  ),
                  child: BarcodeWidget(
                    height: 2.8 * format,
                    width: 2.8 * format,
                    padding: EdgeInsets.zero,
                    data: '${K.lookAppMsgBaseUrl}$qrId',
                    barcode: Barcode.qrCode(),
                  ),
                ),
                SizedBox(height: paddging * 1.0),
                Text(
                  'ID: $qrId',
                  style: TextStyle(
                    fontSize: 8.0,
                    font: font,
                    fontWeight: FontWeight.normal,
                  ),
                ),

                //! ************** contact texts container
                SizedBox(height: paddging * 0.5),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [PdfColors.blue400, PdfColor.fromInt(0xFF004BA6)],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carLabelPdfLocale.contactTitle,
                        style: TextStyle(
                          height: 0.0,
                          font: font,
                          fontSize: carLabelPdfLocale.contactTitleFontSize,
                          color: PdfColors.white,
                        ),
                      ),
                      Text(
                        carLabelPdfLocale.contactSubtitle,
                        style: TextStyle(
                          height: 0.0,
                          font: font,
                          fontSize: carLabelPdfLocale.contactSubtitleFontSize,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //! ******************* gen products list
  static Future<File> genProductList(
    Document pdf, {
    required String productType,
    required String fileName,
    required List<GenProduct> genProducts,
    required String version,
    required Uint8List launchIconBytes,
    required Widget child,
  }) async {
    // add first page
    PdfUtilsHelper.addFirstPage(
      pdf,
      productType: productType,
      version: version,
      // groupNr: ,
      producktLenght: '${genProducts.length}',
      launchIcon: MemoryImage(launchIconBytes),
      child: child,
    );

    // Use MultiPage for automatic page breaks
    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 5),
        maxPages: 1000,
        footer: (context) {
          return PdfUtilsHelper.footerRow(
            '${context.pageNumber} / ${context.pagesCount}',
          );
        },
        build: (context) {
          return [
            Table(
              border: TableBorder.all(color: PdfColors.grey400),
              columnWidths: {
                0: const FixedColumnWidth(40), // Nr.
                1: const FixedColumnWidth(110), // id
                2: const FlexColumnWidth(), // Qrcode
                3: const FixedColumnWidth(60), // staus
              },
              children: [
                // Header row
                _buildHeaderRow(),
                // Data rows
                ...List.generate(genProducts.length, (index) {
                  final product = genProducts[index];
                  return _buildDataRow(
                    nr: '${product.index ?? '-'}',
                    id: product.id ?? '-',
                    qrcode: Helpers.makeProductUrlWithId(product.id) ?? '-',
                  );
                }),
              ],
            ),
          ];
        },
      ),
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
    );

    final fileSize = await finalFile.length();
    print('Final PDF: ${finalFile.path}');
    print('Size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB');

    return finalFile;
  }

  //! ******************* helpers
  /// Move file to Downloads directory
  static Future<File> moveToDownloads(File sourceFile, String fileName) async {
    final String downloadsPath;

    if (Platform.isAndroid) {
      downloadsPath = '/storage/emulated/0/Download';
    } else if (Platform.isIOS) {
      final docsDir = await getApplicationDocumentsDirectory();
      downloadsPath = docsDir.path;
    } else {
      final downloadsDir = await getDownloadsDirectory();
      downloadsPath = downloadsDir?.path ?? '.';
    }

    final dateforFileName = Helpers.formatDateForFileName();
    final name = '$fileName$dateforFileName.pdf';
    final destPath = '$downloadsPath/$name';

    // Copy and delete original
    final destFile = await sourceFile.copy(destPath);
    await sourceFile.delete();

    return destFile;
  }

  static void addFirstPage(
    Document pdf, {
    required String productType,
    required String version,
    required String producktLenght,
    String? groupNr,
    required MemoryImage launchIcon,
    required Widget child,
  }) {
    final nr = groupNr ?? (ProductsPdfBtmSheetRoutes.group?.groupNr ?? '-');

    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat.a4,
        margin: EdgeInsets.zero,
        build: (context) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //! ************** look app logo and name and appstors icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //  TODO: firma logo
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
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
                      child: Image(launchIcon, width: 40),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      // TODO: firma name
                      'Albus7',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: PdfColors.black,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.0),
                child,
                SizedBox(height: 50.0),
                // TODO: text
                Text(
                  'Bitte dieses Blatt Papier immer mitliefern.',
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  width: 400.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TODO: text
                      _firstPagetextTitleRow(
                        title: 'Internes Bestelldatum: ',
                        text: Helpers.formatDate(),
                      ),
                      _firstPagetextTitleRow(
                        title: 'Interne Bestellnummer: ',
                        text: nr.toString(),
                      ),
                      _firstPagetextTitleRow(
                        title: 'Produktart: ',
                        text: productType,
                      ),
                      _firstPagetextTitleRow(
                        title: 'Anzahl: ',
                        text: producktLenght,
                      ),
                      _firstPagetextTitleRow(title: 'Version: ', text: version),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //! ******************* widgets
  static Column _firstPagetextTitleRow({
    required String title,
    required String text,
  }) {
    return Column(
      children: [
        SizedBox(height: 10.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 15.0)),
            ),
            Text(
              text,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  static Row footerRow(String pageCounter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'LookApp © ${DateTime.now().year}',
          style: const TextStyle(color: PdfColors.grey700),
        ),
        Text(pageCounter, style: const TextStyle(color: PdfColors.grey700)),
      ],
    );
  }

  /// Header row
  static TableRow _buildHeaderRow() {
    return TableRow(
      decoration: const BoxDecoration(color: PdfColors.grey200),
      children: [
        _tableCell('Nr.', isHeader: true),
        _tableCell('ID', isHeader: true),
        _tableCell('Qr-Code', isHeader: true, alignment: Alignment.center),
        _tableCell('Status', isHeader: true, alignment: Alignment.center),
      ],
    );
  }

  /// Data row
  static TableRow _buildDataRow({
    required String nr,
    required String id,
    required String qrcode,
  }) {
    return TableRow(
      children: [
        _tableCell(nr),
        _tableCell(id),
        _tableCell(qrcode),
        _checkboxCell(),
      ],
    );
  }

  /// Standard text cell
  static Widget _tableCell(
    String text, {
    bool isHeader = false,
    Alignment alignment = Alignment.centerLeft,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: alignment,
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 11 : 10,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  /// Checkbox cell
  static Widget _checkboxCell() {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          border: Border.all(color: PdfColors.grey600, width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// TODO: orginal
/* import 'package:albus_la_mobile//constants/consts.dart';
import 'package:albus_la_mobile//gen/assets.gen.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class PdfUtils {
  static Future<Uint8List> generatePdf({
    required PdfPageFormat format,
    required String? qrId,
    String? topText,
  }) async {
    final pdf = Document(
      version: PdfVersion.pdf_1_5,
      compress: true,
    );
    final font = await PdfGoogleFonts.nunitoExtraLight();

    //! play and app store images
    final ByteData playStore =
        await rootBundle.load(Assets.images.playStore.path);
    final Uint8List playSotrebytes = playStore.buffer.asUint8List();
    final playStoreImage = MemoryImage(playSotrebytes);

    final ByteData appStore =
        await rootBundle.load(Assets.images.appStore.path);
    final Uint8List appStorebytes = appStore.buffer.asUint8List();
    final appStoreImage = MemoryImage(appStorebytes);

// TODO: this icon
    final ByteData launch =
        await rootBundle.load(Assets.icons.app.pdfLaunchIcon.path);
    final Uint8List launchIconBytes = launch.buffer.asUint8List();
    final launchIcon = MemoryImage(launchIconBytes);

    const format = PdfPageFormat.cm;
// TODO: pdf sized like vingite
/*     pdf.addPage(
      MultiPage(
        build: (context) {
          return [
            _labe1(
              topText: topText,
              font: font,
              format: format,
              qrId: qrId,
              launchIcon: launchIcon,
              appStoreImage: appStoreImage,
              playStoreImage: playStoreImage,
            ),
          ];
        },
      ),
    ); */
    pdf.addPage(
      MultiPage(
        // margin: EdgeInsets.zero,
        margin: const EdgeInsets.only(top: 1 * format),
        build: (context) {
          final paddgingVertical = SizedBox(height: 1.5 * format);

          return [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _labe1(
                  topText: topText,
                  font: font,
                  format: format,
                  qrId: qrId,
                  launchIcon: launchIcon,
                  appStoreImage: appStoreImage,
                  playStoreImage: playStoreImage,
                ),
                _labeCircular1(
                  topText: topText,
                  font: font,
                  format: format,
                  qrId: qrId,
                  launchIcon: launchIcon,
                  appStoreImage: appStoreImage,
                  playStoreImage: playStoreImage,
                ),
              ],
            ),
            paddgingVertical,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _labe2(
                  topText: topText,
                  font: font,
                  format: format,
                  qrId: qrId,
                  launchIcon: launchIcon,
                  appStoreImage: appStoreImage,
                  playStoreImage: playStoreImage,
                ),
                _labeCircular2(
                  topText: topText,
                  font: font,
                  format: format,
                  qrId: qrId,
                  launchIcon: launchIcon,
                  appStoreImage: appStoreImage,
                  playStoreImage: playStoreImage,
                ),
              ],
            ),
            paddgingVertical,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _labe3(
                  topText: topText,
                  font: font,
                  format: format,
                  qrId: qrId,
                  launchIcon: launchIcon,
                  appStoreImage: appStoreImage,
                  playStoreImage: playStoreImage,
                ),
                _labeCircular3(
                  topText: topText,
                  font: font,
                  format: format,
                  qrId: qrId,
                  launchIcon: launchIcon,
                  appStoreImage: appStoreImage,
                  playStoreImage: playStoreImage,
                ),
              ],
            ),
          ];
        },
      ),
    );

    pdf.addPage(Page(
      build: (context) {
        return _labe1(
          topText: topText,
          font: font,
          format: format,
          qrId: qrId,
          launchIcon: launchIcon,
          appStoreImage: appStoreImage,
          playStoreImage: playStoreImage,
        );
      },
    ));

    pdf.addPage(Page(
      build: (context) {
        return _labe2(
          topText: topText,
          font: font,
          format: format,
          qrId: qrId,
          launchIcon: launchIcon,
          appStoreImage: appStoreImage,
          playStoreImage: playStoreImage,
        );
      },
    ));

    pdf.addPage(Page(
      build: (context) {
        return _labe3(
          topText: topText,
          font: font,
          format: format,
          qrId: qrId,
          launchIcon: launchIcon,
          appStoreImage: appStoreImage,
          playStoreImage: playStoreImage,
        );
      },
    ));

    pdf.addPage(Page(
      build: (context) {
        return _labeCircular1(
          topText: topText,
          font: font,
          format: format,
          qrId: qrId,
          launchIcon: launchIcon,
          appStoreImage: appStoreImage,
          playStoreImage: playStoreImage,
        );
      },
    ));

    pdf.addPage(Page(
      build: (context) {
        return _labeCircular2(
          topText: topText,
          font: font,
          format: format,
          qrId: qrId,
          launchIcon: launchIcon,
          appStoreImage: appStoreImage,
          playStoreImage: playStoreImage,
        );
      },
    ));

    pdf.addPage(Page(
      build: (context) {
        return _labeCircular3(
          topText: topText,
          font: font,
          format: format,
          qrId: qrId,
          launchIcon: launchIcon,
          appStoreImage: appStoreImage,
          playStoreImage: playStoreImage,
        );
      },
    ));

    return pdf.save();
  }

  static Column _labe1({
    required String? topText,
    required Font font,
    required double format,
    required String? qrId,
    required MemoryImage launchIcon,
    required MemoryImage appStoreImage,
    required MemoryImage playStoreImage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
/*         Text(
          topText ?? '',
          style: TextStyle(
            font: font,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6 * format), */
        Center(
          child: Container(
            width: 7 * format,
            padding: EdgeInsets.only(
              top: 0.4 * format,
              bottom: 0.2 * format,
              left: 1 * format,
              right: 1 * format,
            ),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(K.rl),
              border: Border.all(
                color: PdfColors.grey500,
                width: 0.1 * format,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(qrId ?? ''),
                SizedBox(height: 0.5 * format),
                BarcodeWidget(
                  height: 5 * format,
                  width: 6 * format,
                  data: '${K.lookAppMsgBaseUrl}$qrId',
                  padding: EdgeInsets.zero,
                  barcode: Barcode.qrCode(),
                ),
                SizedBox(height: 0.5 * format),
                Row(children: [
                  Padding(
                    padding: EdgeInsets.only(right: 0.1 * format),
                    child: ClipRRect(
                      horizontalRadius: K.rs,
                      verticalRadius: K.rs,
                      child: Image(
                        launchIcon,
                        width: 1 * format,
                      ),
                    ),
                  ),
                  SizedBox(width: 0.3 * format),
                  Text(
                    'LookApp',
                    style: TextStyle(
                      // font: ttf,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
                SizedBox(
                  height: 1.1 * format,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        appStoreImage,
                        width: 2.5 * format,
                      ),
                      SizedBox(width: 0.1 * format),
                      Image(
                        playStoreImage,
                        width: 2.5 * format,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Column _labe2({
    required String? topText,
    required Font font,
    required double format,
    required String? qrId,
    required MemoryImage launchIcon,
    required MemoryImage appStoreImage,
    required MemoryImage playStoreImage,
  }) {
    final paddging = 0.3 * format;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 5.5 * format,
            padding: EdgeInsets.all(paddging),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(K.rl),
              border: Border.all(
                color: PdfColors.grey500,
                width: 0.1 * format,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Contact Owner'),
                SizedBox(height: paddging),
                BarcodeWidget(
                  height: 2.5 * format,
                  width: 2.5 * format,
                  data: '${K.lookAppMsgBaseUrl}$qrId',
                  padding: EdgeInsets.zero,
                  barcode: Barcode.qrCode(),
                ),
                SizedBox(height: paddging),
                Text(qrId ?? ''),
                SizedBox(height: paddging),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      horizontalRadius: K.rs,
                      verticalRadius: K.rs,
                      child: Image(
                        launchIcon,
                        width: 1 * format,
                      ),
                    ),
                    SizedBox(width: 0.2 * format),
                    Text(
                      'LookApp',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: paddging * 0.5),
                SizedBox(
                  height: 0.6 * format,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image(appStoreImage),
                      ),
                      SizedBox(width: 0.1 * format),
                      Expanded(
                        child: Image(playStoreImage),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Column _labe3({
    required String? topText,
    required Font font,
    required double format,
    required String? qrId,
    required MemoryImage launchIcon,
    required MemoryImage appStoreImage,
    required MemoryImage playStoreImage,
  }) {
    final paddging = 0.2 * format;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 4 * format,
            padding: EdgeInsets.all(paddging),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(K.rm),
              border: Border.all(
                color: PdfColors.grey500,
                width: 0.1 * format,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Contact Owner',
                  style: const TextStyle(fontSize: 10.0),
                ),
                SizedBox(height: paddging),
                BarcodeWidget(
                  height: 2 * format,
                  width: 2 * format,
                  data: '${K.lookAppMsgBaseUrl}$qrId',
                  padding: EdgeInsets.zero,
                  barcode: Barcode.qrCode(),
                ),
                SizedBox(height: paddging),
                Text(
                  qrId ?? '',
                  style: const TextStyle(fontSize: 10.0),
                ),
                SizedBox(height: paddging),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      horizontalRadius: K.rs,
                      verticalRadius: K.rs,
                      child: Image(
                        launchIcon,
                        width: 0.75 * format,
                      ),
                    ),
                    SizedBox(width: 0.2 * format),
                    Text(
                      'LookApp',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: paddging * 0.5),
                SizedBox(
                  height: 0.5 * format,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image(appStoreImage),
                      ),
                      SizedBox(width: 0.1 * format),
                      Expanded(
                        child: Image(playStoreImage),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Center _labeCircular1({
    required String? topText,
    required Font font,
    required double format,
    required String? qrId,
    required MemoryImage launchIcon,
    required MemoryImage appStoreImage,
    required MemoryImage playStoreImage,
  }) {
    final paddging = 0.4 * format;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 7 * format,
              width: 7 * format,
              padding: EdgeInsets.all(paddging),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: PdfColors.grey500,
                  width: 0.1 * format,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Contact Owner'),
                  SizedBox(height: paddging * 0.5),
                  BarcodeWidget(
                    height: 2 * format,
                    width: 2 * format,
                    data: '${K.lookAppMsgBaseUrl}$qrId',
                    padding: EdgeInsets.zero,
                    barcode: Barcode.qrCode(),
                  ),
                  SizedBox(height: paddging * 0.5),
                  Text(
                    qrId ?? '',
                    style: const TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: paddging * 0.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        horizontalRadius: K.rs,
                        verticalRadius: K.rs,
                        child: Image(
                          launchIcon,
                          width: 1 * format,
                        ),
                      ),
                      SizedBox(width: 0.2 * format),
                      Text(
                        'LookApp',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: paddging * 0.5),
                  SizedBox(
                    height: 1.1 * format,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.9 * format),
                      child: Row(
                        children: [
                          Expanded(
                            child: Image(appStoreImage),
                          ),
                          SizedBox(width: 0.1 * format),
                          Expanded(
                            child: Image(playStoreImage),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    '2025',
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Center _labeCircular2({
    required String? topText,
    required Font font,
    required double format,
    required String? qrId,
    required MemoryImage launchIcon,
    required MemoryImage appStoreImage,
    required MemoryImage playStoreImage,
  }) {
    final paddging = 0.3 * format;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 5.5 * format,
              width: 5.5 * format,
              padding: EdgeInsets.all(paddging),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: PdfColors.grey500,
                  width: 0.1 * format,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Contact Owner',
                    style: const TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: paddging * 0.5),
                  BarcodeWidget(
                    height: 1.7 * format,
                    width: 1.7 * format,
                    data: '${K.lookAppMsgBaseUrl}$qrId',
                    padding: EdgeInsets.zero,
                    barcode: Barcode.qrCode(),
                  ),
                  SizedBox(height: paddging * 0.5),
                  Text(
                    qrId ?? '',
                    style: const TextStyle(fontSize: 9),
                  ),
                  SizedBox(height: paddging * 0.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        horizontalRadius: K.rs,
                        verticalRadius: K.rs,
                        child: Image(
                          launchIcon,
                          width: 0.7 * format,
                        ),
                      ),
                      SizedBox(width: 0.17 * format),
                      Text(
                        'LookApp',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: paddging * 0.1),
                  SizedBox(
                    height: 1 * format,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.7 * format),
                      child: Row(
                        children: [
                          Expanded(
                            child: Image(appStoreImage),
                          ),
                          SizedBox(width: 0.1 * format),
                          Expanded(
                            child: Image(playStoreImage),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    '2025',
                    style: TextStyle(
                      fontSize: 5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Center _labeCircular3({
    required String? topText,
    required Font font,
    required double format,
    required String? qrId,
    required MemoryImage launchIcon,
    required MemoryImage appStoreImage,
    required MemoryImage playStoreImage,
  }) {
    final paddging = 0.21 * format;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 4.2 * format,
              width: 4.2 * format,
              padding: EdgeInsets.all(paddging),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: PdfColors.grey500,
                  width: 0.1 * format,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Contact Owner',
                    style: const TextStyle(fontSize: 8),
                  ),
                  SizedBox(height: paddging * 0.5),
                  BarcodeWidget(
                    height: 1.4 * format,
                    width: 1.4 * format,
                    data: '${K.lookAppMsgBaseUrl}$qrId',
                    padding: EdgeInsets.zero,
                    barcode: Barcode.qrCode(),
                  ),
                  SizedBox(height: paddging * 0.5),
                  Text(
                    qrId ?? '',
                    style: const TextStyle(fontSize: 8),
                  ),
                  SizedBox(height: paddging * 0.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        horizontalRadius: K.rs,
                        verticalRadius: K.rs,
                        child: Image(
                          launchIcon,
                          width: 0.6 * format,
                        ),
                      ),
                      SizedBox(width: 0.15 * format),
                      Text(
                        'LookApp',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: paddging * 0.2),
                  SizedBox(
                    height: 0.5 * format,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.7 * format),
                      child: Row(
                        children: [
                          Expanded(
                            child: Image(appStoreImage),
                          ),
                          SizedBox(width: 0.1 * format),
                          Expanded(
                            child: Image(playStoreImage),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: paddging * 0.2),
                  Text(
                    '2025',
                    style: TextStyle(
                      fontSize: 5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 */
