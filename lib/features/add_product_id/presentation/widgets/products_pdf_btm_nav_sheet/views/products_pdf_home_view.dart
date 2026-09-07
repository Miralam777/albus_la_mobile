import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/pdf_utils/models/product_pdf_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../products_pdf_btm_sheet_routes.dart';
import '../widgets/widgets.dart';

class ProductsPdfHomeView extends StatelessWidget {
  const ProductsPdfHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PrimaryAppBar(
        // TODO: text
        title: 'PDF auswählen',
        leading: CloseButton(onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaHelper.appBarH + K.pvsH,
          left: K.pm,
          right: K.pm,
          bottom: K.pvmH,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProuductsPdfListTile(
              icon: I.car,
              // TODO: text
              title: 'Autos',
              onTap: () => _onTap(context, ProductPdfType.car),
            ),
            ProuductsPdfListTile(
              icon: I.key,
              // TODO: text
              title: 'Schlüsselanhänger',
              onTap: () => _onTap(context, ProductPdfType.keychain),
            ),
            ProuductsPdfListTile(
              icon: I.creditcard,
              // TODO: text
              title: 'Karte',
              onTap: () => _onTap(context, ProductPdfType.card),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, ProductPdfType pdfType) {
    ProductsPdfBtmSheetRoutes.setPdfType(pdfType);
    Navigator.of(context).pushNamed(ProductsPdfBtmSheetRoutes.locales);
  }
}
