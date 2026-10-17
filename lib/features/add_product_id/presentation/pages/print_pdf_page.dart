import 'package:albus_la_mobile/features/add_product_id/presentation/pdf_utils/pdf_utils_helper.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/widgets/products_pdf_btm_nav_sheet/products_pdf_btm_sheet_routes.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/loading_indicator.dart';

import '../pdf_utils/models/product_pdf_type_enum.dart';

class PrintPdfPage extends StatefulWidget {
  const PrintPdfPage({super.key});

  @override
  State<PrintPdfPage> createState() => _PrintPdfPageState();
}

class _PrintPdfPageState extends State<PrintPdfPage> {
  late ProductPdfType? _pdfType;

  @override
  void initState() {
    _pdfType = ProductsPdfBtmSheetRoutes.pdfType;
    // _locale = ProductsPdfBtmSheetRoutes.loacle;
    // _group = ProductsPdfBtmSheetRoutes.group;
    // _genProducts = ProductsPdfBtmSheetRoutes.genProducts;

    print('=======>  initState print pdf page');
    print('_pdfType: ${_pdfType}');
    /* print('_locale: ${_locale}');
    print('_group: ${_group}');
    print('_genProducts: ${_genProducts.length}'); */

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        // TODO: text
        // title: S.of(context).roductPrintQrCodePageAppBarTitle,
        title: 'Qr-Codes ausdrucken',
      ),
      body: SafeArea(
        child: PdfPreview(
          // TODO: orginal
          // pdfFileName: "qr_code_id_${qrId ?? ''}.pdf",
          pdfFileName: "qr_code_id_maSV9Gwc.pdf",
          // pdfFileName: "qr_code_id_miralam7.pdf",
          actionBarTheme: PdfActionBarTheme(
            height: MediaHelper.appBarH,
            elevation: 0.0,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            iconColor: MediaHelper.isBrightnessDark(context)
                ? Colors.white
                : Colors.black,
          ),
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          loadingWidget: const LoadingIndicator(withBackgound: false),
          onError: (context, error) => Center(child: Text('Error')),
          build: (format) {
            // final pdfQrcodeLocaleModel = AppLocaleServices.getLocaleByLangCode(BlocEventsHelper.getSettings(context).appLocalCode).pdfQrcodeLocaleModel;

            return PdfUtilsHelper.generateTestPdfs(
              format: format,
              pdfType: _pdfType,
            );

            // return PdfUtilsHelper.firsPagePdfKeychain();
            // TODO
            /*             if (_pdfType == ProductPdfType.car) {
              return PdfUtils.generateCarPdfs(
                format: format,
                pdfType: _pdfType,
              );
            } else if (_pdfType == ProductPdfType.keychain) {
              // TODO:
              return PdfUtils.generateCarPdfs(
                format: format,
                pdfType: _pdfType,
              );
            } else {
              // TODO:
              return PdfUtils.generateCarPdfs(
                format: format,
                pdfType: _pdfType,
              );
            } */
          },
        ),
      ),
    );
  }
}
