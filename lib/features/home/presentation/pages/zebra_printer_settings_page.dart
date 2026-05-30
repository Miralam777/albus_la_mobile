import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/bloc_events_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/toast_utils.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/product_label_printer_provider.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/shipping_label_printer_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../widgets/zebra_printer_settings_page/widgets.dart';

class ZebraPinterSettingsPage extends StatefulWidget {
  const ZebraPinterSettingsPage({super.key});

  @override
  State createState() => _ZebraPinterSettingsPageState();
}

class _ZebraPinterSettingsPageState extends State<ZebraPinterSettingsPage> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shippingPrinterProvider = Provider.of<ShippingLabelPrinterProvider>(
      context,
    );
    final productPrinterProvider = Provider.of<ProductLabelPrinterProvider>(
      context,
    );

    final settings = BlocEventsHelper.getSettings(context);

    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
          filled: true,
          fillColor: colorScheme.secondaryContainer,
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // TODO: text
        appBar: const PrimaryAppBar(title: 'Zebra-Druckereinstellungen'),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            ZebraSettingsWidgets(
              // TODO: text
              printerTitle: 'Versandetikettendrucker',
              ipAddress: shippingPrinterProvider.ipAddress,
              testZplData: shippingPrinterProvider.getLabelZplData(
                companyName: settings.companyModel.name,
                senderStreetAndNr:
                    '${settings.companyModel.street} ${settings.companyModel.houseNr}',
                senderPostalCodeAndCity:
                    '${settings.companyModel.postalCode} ${settings.companyModel.city}',
                senderCountery: settings.companyModel.countery,
                receiverFullName: 'Max Musterman',
                receiverStreetAndNr: 'Teststraße 70',
                receiverPostalCodeAndCity: '12345 Berlin',
                receiverCountery: 'Deutschland',
                orderNr: '1234567891234567',
              ),
              onIpSave: (ipAddress) {
                print('deactivated ipAddress:');
                print(ipAddress);
                if (ipAddress.isNotEmpty) {
                  BlocEventsHelper.setSetting(
                    context,
                    settings.copyWith(shippingLabelPrinterIp: ipAddress),
                  );
                  shippingPrinterProvider.checkStatus(context: context);
                  // TODO: text
                  ToastUtils.show(msg: 'IP-Adresse erfolgreich gespeichert.');
                }
              },
            ),
            ZebraSettingsWidgets(
              // TODO: text
              printerTitle: 'Produktetikettendrucker',
              ipAddress: productPrinterProvider.ipAddress,
              testZplData: productPrinterProvider.getLabelZplData(
                title: 'Keychain Red',
                qrcode: 'aM1I2E7',
                barcode: '123456',
              ),
              onIpSave: (ipAddress) {
                print('deactivated ipAddress:');
                print(ipAddress);
                if (ipAddress.isNotEmpty) {
                  BlocEventsHelper.setSetting(
                    context,
                    settings.copyWith(productLabelPrinterIp: ipAddress),
                  );
                  productPrinterProvider.checkStatus(context: context);
                  // TODO: text
                  ToastUtils.show(msg: 'IP-Adresse erfolgreich gespeichert.');
                }
              },
            ),
          ],
        ),

        extendBody: true,
        bottomNavigationBar: BottomAppBar(
          height: kToolbarHeight.h,
          clipBehavior: Clip.antiAlias,
          color: Theme.of(context).appBarTheme.backgroundColor,
          notchMargin: 0.0,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Divider(height: 0.7.r),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBottomAppBarItem(
                      index: 0,
                      // TODO: text
                      title: 'Versandetiketten',
                    ),
                    _buildBottomAppBarItem(
                      index: 1,
                      // TODO: text
                      title: 'Produktetiketten',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAppBarItem({required int index, required String title}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0.h),
      child: Material(
        clipBehavior: Clip.antiAlias,
        color: _selectedIndex == index
            ? Color.lerp(
                colorScheme.tertiaryContainer,
                colorScheme.primary,
                0.2,
              )
            : colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(K.rm),
        child: InkWell(
          onTap: () => _onTabSelected(index),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0.h, horizontal: 10.0.w),
            child: FittedBox(
              child: Column(
                children: [
                  Icon(I.printer),
                  Text(title, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
