import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/models/product_group_model.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/gen_qrcode/gen_product.dart';
import 'package:flutter/material.dart';

import 'products_pdf_btm_sheet_routes.dart';
import 'views/views.dart';

// TODO: clean
void showProductsPdfBtmNavSheet(
  BuildContext context, {
  required ProductGroupModel group,
  required List<GenProduct> genProducts,
}) {
  ProductsPdfBtmSheetRoutes.setGroupAndGenProducts(
    group: group,
    genProducts: genProducts,
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    builder: (context) => _ProductsPdfBtmNavSheet(group),
  );
}

class _ProductsPdfBtmNavSheet extends StatefulWidget {
  const _ProductsPdfBtmNavSheet(this.group);
  final ProductGroupModel group;

  @override
  State<_ProductsPdfBtmNavSheet> createState() =>
      _ProductsPdfBtmNavSheetState();
}

class _ProductsPdfBtmNavSheetState extends State<_ProductsPdfBtmNavSheet> {
  @override
  void dispose() {
    ProductsPdfBtmSheetRoutes.cleanArgs();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaHelper.h(context) * 0.7,
      child: Navigator(
        initialRoute: ProductsPdfBtmSheetRoutes.init,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case ProductsPdfBtmSheetRoutes.locales:
              return MaterialPageRoute(
                builder: (_) => const ProductsPdfLocaleView(),
              );
            case ProductsPdfBtmSheetRoutes.carLabelVersion:
              return MaterialPageRoute(
                builder: (_) => const CarLabelVersionView(),
              );
            case ProductsPdfBtmSheetRoutes.keychainVersion:
              return MaterialPageRoute(
                builder: (_) => const KeychainVersionView(),
              );
            case ProductsPdfBtmSheetRoutes.cardVersion:
              return MaterialPageRoute(builder: (_) => const CardVersionView());
            default:
              return MaterialPageRoute(
                builder: (_) => const ProductsPdfHomeView(),
              );
          }
        },
      ),
    );
  }
}
