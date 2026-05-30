import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/empty_list_widget.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/license_provider.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/product_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../widgets/home/products_view/widgets.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).getProducts;
    final licenses = Provider.of<LicenseProvider>(context).getLicenses;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PrimaryAppBar(
        // TODO: text
        title: 'Produkte',
        actions: [AddProductPopupMenu()],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              top: K.pvmH + MediaHelper.statusAndAppBarH(context),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: K.pm, bottom: K.pvsxH),
            sliver: SliverToBoxAdapter(
              child: Text(
                // TODO: text
                'Lizenzen:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: licenses.isEmpty
                ? Text(
                    // TODO text
                    'Lizenz-Liste ist leer.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                : SizedBox(
                    height: 265.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.all(K.ps),
                      itemCount: licenses.length,
                      itemBuilder: (BuildContext context, int index) =>
                          LicenseCard(license: licenses[index]),
                    ),
                  ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: K.pm, top: K.pvlH),
            sliver: SliverToBoxAdapter(
              child: Text(
                // TODO: text
                'Produkte:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          // TODO:
          SliverToBoxAdapter(
            child: products.isEmpty
                ? const EmptyListWidget()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductCard(product: products[index]);
                    },
                  ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              top: K.pvmH + MediaHelper.androidBtmNavBarH(context),
            ),
          ),
        ],
      ),
    );
  }
}
/* 
// TODO: Check that you only use it on the buy limit page and export it there
/* class LicenseProduct {
  final String id;
  final String name;
  final int limit;
  final double price;

  LicenseProduct({
    required this.id,
    required this.name,
    required this.limit,
    required this.price,
  });
} */

List<License> licenseProducts = [
  License(
    licenseId: 1,
    name: '1 Qr-Code-Lizenz nur für:',
    amount: 1,
    price: 100,
  ),
  License(
    licenseId: 3,
    name: '3 Qr-Code-Lizenz nur für:',
    amount: 3,
    price: 300,
  ),
  License(
    licenseId: 5,
    name: '5 Qr-Code-Lizenz nur für:',
    amount: 5,
    price: 500,
  ),
/* 
  License(
    id: 'L10X',
    name: 'Call My Car 10X Lizenz',
    limit: 10,
    price: 10.00,
  ),
  License(
    id: 'L30X',
    name: 'Call My Car 30X Lizenz',
    limit: 30,
    price: 30.00,
  ),
  License(
    id: 'L50X',
    name: 'Call My Car 50X Lizenz',
    limit: 50,
    price: 50.00,
  ),
  License(
    id: 'L100X',
    name: 'Call My Car 100X Lizenz',
    limit: 100,
    price: 100.00,
  ), */
]; */

// TODO:
class QrCodeIcons {
  /*   List<IconData> iconsDataList = [
    Icons.local_shipping_outlined,
    Icons.two_wheeler_outlined,
    CupertinoIcons.car_detailed,
    Icons.pedal_bike_outlined,
    Icons.electric_scooter,
    //! TODO: deactive this
    Icons.markunread_mailbox_outlined,
    Icons.luggage_outlined,
    Icons.key_rounded,
    Icons.pets_rounded,
    //
    // CupertinoIcons.lugge,
    // CupertinoIcons.add,
  ]; */
  // TODO: icons
  static final List<QrCodeIcon> icons = [
    QrCodeIcon(
      name: 'LKW',
      icon: Icons.local_shipping_outlined,
      id: 0,
      msgIcons: [],
    ),
    QrCodeIcon(
      name: 'Motorad',
      icon: Icons.two_wheeler_outlined,
      id: 1,
      msgIcons: [],
    ),
    QrCodeIcon(
      name: 'PKW',
      icon: CupertinoIcons.car_detailed,
      id: 2,
      msgIcons: [],
    ),
    QrCodeIcon(
      name: 'Fahrrad',
      icon: Icons.pedal_bike_outlined,
      id: 3,
      msgIcons: [],
    ),
    QrCodeIcon(
      name: 'Roller',
      icon: Icons.electric_scooter,
      id: 4,
      msgIcons: [],
    ),
    //! TODO: deactive this
    QrCodeIcon(
      name: 'Briefkasten',
      icon: Icons.markunread_mailbox_outlined,
      id: 5,
      msgIcons: [],
    ),
    QrCodeIcon(
      name: 'Koffer',
      icon: Icons.luggage_outlined,
      id: 6,
      msgIcons: [],
    ),
    QrCodeIcon(
      name: 'Schlüsselbund',
      icon: Icons.key_rounded,
      id: 7,
      msgIcons: [],
    ),
    QrCodeIcon(name: 'Haustier', icon: Icons.pets_rounded, id: 8, msgIcons: []),
  ];

  static QrCodeIcon getQrCodeIconById(int id) {
    for (int i = 0; i < icons.length; i++) {
      if (icons[i].id == id) return icons[i];
    }
    return QrCodeIcon(
      name: 'Anderes',
      icon: Icons.error_outline_rounded,
      id: id,
      // TODO:
      msgIcons: [],
    );
  }
}

class QrCodeIcon {
  final String name;
  final IconData icon;
  final int id;
  final List<int> msgIcons;

  QrCodeIcon({
    required this.name,
    required this.icon,
    required this.id,
    required this.msgIcons,
  });
}
