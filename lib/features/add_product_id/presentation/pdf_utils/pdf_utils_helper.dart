import 'dart:io';

import 'package:albus_la_mobile/constants/app_locales/models/pdf/card_pdf_locale_model.dart';
import 'package:albus_la_mobile/constants/app_locales/models/pdf/keychain_pdf_locale_model.dart';
import 'package:albus_la_mobile/core/utils/helpers/helpers.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/pdf_utils/car_label_pdf_csv_utils.dart';
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
    final idFont = await PdfGoogleFonts.jetBrainsMonoBold();

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

    final callWaveIcon = MemoryImage(
      (await rootBundle.load(
        Assets.icons.app.callWave.path,
      )).buffer.asUint8List(),
    );

    const format = PdfPageFormat.cm;

    print('format: $format cm');

    // Labels per page (e.g. 3x3 = 9)
    /* const labelsPerRow = 3;
    const rowsPerPage = 3;
    const labelsPerPage = labelsPerRow * rowsPerPage; */

    // Labels per page (e.g. 3x3 = 9)
    const labelsPerRow = 2;
    const rowsPerPage = 2;
    const labelsPerPage = labelsPerRow * rowsPerPage;

    final testCarLabelPdfVerion = CarLabelPdfCsvType.v2;
    print('=============testCarLabelPdfVerion: $testCarLabelPdfVerion');

    print('=========> PdfColors.green800');
    print(PdfColors.green800);
    //! de
    final testCarLabelPdfLocalModel = CarLabelPdfLocaleModel(
      locale: 'de',
      contactTitle: 'KFZ-HALTER',
      contactTitleFontSize: 19.0,
      contactSubtitle: 'DIREKT KONTAKTIEREN',
      contactSubtitleFontSize: 12.6,
      activationCodeTitle: 'Aktivierungscode',
      contactTitleV2: 'FAHRER',
      contactTitleFontSizeV2: 30.0,
      contactTitleLetterSpacingV2: 1.0,
      contactSubtitleV2: 'DIREKT KONTAKTIEREN',
      contactSubtitleFontSizeV2: 20.25,
    );

    //! en
    /*     final testCarLabelPdfLocalModel = CarLabelPdfLocaleModel(
      locale: 'en',
      contactTitle: 'CONTACT THE',
      contactTitleFontSize: 17.0,
      contactSubtitle: 'CAR OWNER DIRECTLY',
      contactSubtitleFontSize: 13.4,
      activationCodeTitle: 'Activation code',
      contactTitleV2: 'DRIVER',
      contactTitleFontSizeV2: 19.0,
    ); */

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
      child: testCarLabelPdfVerion == CarLabelPdfCsvType.v1
          ? _carLabelV1(
              index: null,
              carLabelPdfLocale: testCarLabelPdfLocalModel,
              font: font,
              idFont: idFont,
              format: format,
              qrId: 'testQrId77',
              pin: '12345678',
              launchIcon: launchIcon,
              appStoreImage: appStoreImage,
              playStoreImage: playStoreImage,
              callWaveIcon: callWaveIcon,
            )
          : _carLabelV2(
              index: null,
              carLabelPdfLocale: testCarLabelPdfLocalModel,
              font: font,
              idFont: idFont,
              format: format,
              qrId: 'testQrId77',
              pin: '12345678',
              launchIcon: launchIcon,
              appStoreImage: appStoreImage,
              playStoreImage: playStoreImage,
              callWaveIcon: callWaveIcon,
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
      /*       pdf.addPage(
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
                      // childAspectRatio: 1.9,
                      children: List.generate(pageProducts.length, (i) {
                        return testCarLabelPdfVerion == CarLabelPdfCsvType.v1
                            ? _carLabelV1(
                                index: i,
                                carLabelPdfLocale: testCarLabelPdfLocalModel,
                                font: font,
                                idFont: idFont,
                                format: format,
                                qrId: pageProducts[i].id,
                                pin: '12345678',
                                launchIcon: launchIcon,
                                appStoreImage: appStoreImage,
                                playStoreImage: playStoreImage,
                                callWaveIcon: callWaveIcon,
                              )
                            : _carLabelV2(
                                index: i,
                                carLabelPdfLocale: testCarLabelPdfLocalModel,
                                font: font,
                                idFont: idFont,
                                format: format,
                                qrId: pageProducts[i].id,
                                pin: '12345678',
                                launchIcon: launchIcon,
                                appStoreImage: appStoreImage,
                                playStoreImage: playStoreImage,
                                callWaveIcon: callWaveIcon,
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
      ); */
      // ! car labe page Fahrer
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
                      // childAspectRatio: ,
                      // childAspectRatio: 1.37,
                      // childAspectRatio: 4 / 3,
                      // childAspectRatio: 1.9,
                      children: List.generate(pageProducts.length, (i) {
                        return _carLabelV2(
                          index: i,
                          carLabelPdfLocale: testCarLabelPdfLocalModel,
                          font: font,
                          idFont: idFont,
                          format: format,
                          qrId: pageProducts[i].id,
                          pin: pageProducts[i].pin,
                          launchIcon: launchIcon,
                          appStoreImage: appStoreImage,
                          playStoreImage: playStoreImage,
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

  static Container _carLabelV1({
    int? index,
    required CarLabelPdfLocaleModel carLabelPdfLocale,
    required Font font,
    required Font idFont,
    required double format,
    required String? pin,
    required String? qrId,
    required MemoryImage launchIcon,
    required MemoryImage appStoreImage,
    required MemoryImage playStoreImage,
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

                  //! ************** id and  qrcode container
                  SizedBox(height: paddging * 0.5),
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

                  //! ************** look app logo and name and appstors icons
                  SizedBox(height: paddging * 0.7),
                  Image(launchIcon, width: 1.2 * format),
                  Text(
                    'LookApp',
                    style: TextStyle(
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
    required MemoryImage appStoreImage,
    required MemoryImage playStoreImage,
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

                  //! ************** look app logo and name and appstors icons
                  SizedBox(height: paddging * 1.7),

                  Image(launchIcon, width: 2.4 * format),

                  Text(
                    'LookApp',
                    style: TextStyle(
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
  //! ******************* gen products list
  static Future<File> genProductList(
    Document pdf, {
    required String productType,
    required String fileName,
    required int? groupNr,
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
      subfolder: 'lookApp/${groupNr ?? 'unknown'}',
    );

    final fileSize = await finalFile.length();
    print('Final PDF: ${finalFile.path}');
    print('Size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB');

    return finalFile;
  }

  //! ******************* helpers
  /// Move file to Downloads directory
  static Future<File> moveToDownloads(
    File sourceFile,
    String fileName, {
    String? subfolder,
    String extension = 'pdf',
  }) async {
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

    final targetDir = subfolder == null
        ? downloadsPath
        : '$downloadsPath/$subfolder';
    await Directory(targetDir).create(recursive: true);

    // final dateforFileName = Helpers.formatDateForFileName();
    // final name = '$fileName$dateforFileName.$extension';
    // final destPath = '$targetDir/$name';

    final destPath = '$targetDir/$fileName.$extension';

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
