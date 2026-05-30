import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/pdf_utils/models/product_pdf_type_enum.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/widgets/products_pdf_btm_nav_sheet/products_pdf_btm_sheet_routes.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class ProductsPdfLocaleView extends StatelessWidget {
  const ProductsPdfLocaleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PrimaryAppBar(
        // TODO: text
        title: 'Produktsprache auswählen',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaHelper.appBarH,
          left: K.pm,
          right: K.pm,
          bottom: K.pvmH,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PdfTypeIconLocaleWidget(),

            ProuductsPdfListTile(
              icon: I.language,
              // TODO: text
              title: 'Deutsch',
              onTap: () => _onSetLocaleAndPushToVerstionView(context, 'de'),
            ),
            // TODO:
            ProuductsPdfListTile(
              icon: I.language,
              // TODO: text
              title: 'Englisch',
              onTap: () => _onSetLocaleAndPushToVerstionView(context, 'en'),
            ),
          ],
        ),
      ),
    );
  }

  void _onSetLocaleAndPushToVerstionView(BuildContext context, String locale) {
    ProductsPdfBtmSheetRoutes.setLocale(locale);

    final pdfType = ProductsPdfBtmSheetRoutes.pdfType;

    print('pdfType: $pdfType');

    if (pdfType == ProductPdfType.car) {
      Navigator.of(
        context,
      ).pushNamed(ProductsPdfBtmSheetRoutes.carLabelVersion);
    } else if (pdfType == ProductPdfType.keychain) {
      Navigator.of(
        context,
      ).pushNamed(ProductsPdfBtmSheetRoutes.keychainVersion);
    } else if (pdfType == ProductPdfType.card) {
      Navigator.of(context).pushNamed(ProductsPdfBtmSheetRoutes.cardVersion);
    }
  }
}
