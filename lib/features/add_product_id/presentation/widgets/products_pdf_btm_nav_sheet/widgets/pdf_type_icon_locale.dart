import 'package:albus_la_mobile/constants/app_locales/app_locale_services.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/pdf_utils/models/product_pdf_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/widgets/products_pdf_btm_nav_sheet/products_pdf_btm_sheet_routes.dart';

class PdfTypeIconLocaleWidget extends StatelessWidget {
  const PdfTypeIconLocaleWidget({super.key, this.withLocale = false});

  final bool withLocale;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: K.pvmH, bottom: K.pvsH),
            padding: EdgeInsets.all(K.pm),
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(K.rm),
            ),
            child: Icon(getIcon, size: K.ibs),
          ),
          if (withLocale)
            Padding(
              padding: EdgeInsets.symmetric(vertical: K.pvsxH),
              child: Text(
                AppLocaleServices.getLocaleByLangCode(
                  ProductsPdfBtmSheetRoutes.locale,
                ).languageModel.de,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }

  IconData get getIcon {
    final pdfType = ProductsPdfBtmSheetRoutes.pdfType;
    return switch (pdfType) {
      ProductPdfType.car => I.car,
      ProductPdfType.keychain => I.key,
      ProductPdfType.card => I.creditcard,
      // TODO: oder product icon
      ProductPdfType.error => I.error,
      _ => I.error,
    };
  }
}
