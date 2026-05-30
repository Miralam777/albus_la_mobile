import 'package:albus_la_mobile/core/global/settings_cubit.dart';
import 'package:albus_la_mobile/core/utils/helpers/bloc_events_helper.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/orders/shipping_address.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
// import 'package:a_zebra_utils/zsdk.dart' as zebra;
import 'package:zsdk/zsdk.dart' as zebra;

@injectable
class ShippingLabelPrinterProvider extends ChangeNotifier {
  final _zsdk = zebra.ZSDK();

  String ipAddress = '';
  int defaultPort = 9100;

  bool isConnected = true;
  bool isStatusChecking = false;

  /// if context not null should get ip address from settings
  Future<void> checkStatus({BuildContext? context}) async {
    if (context != null) _getIpAddress(context);

    isStatusChecking = true;
    notifyListeners();

    _zsdk
        .checkPrinterStatusOverTCPIP(address: ipAddress, port: defaultPort)
        .then(
          (value) {
            if (value != null) isConnected = true;
            isStatusChecking = false;
            notifyListeners();
          },
          onError: (_) {
            isStatusChecking = false;
            isConnected = false;
            notifyListeners();
          },
        );
  }

  Future<void> _getIpAddress(BuildContext context) async {
    ipAddress = BlocEventsHelper.getSettings(context).shippingLabelPrinterIp;
  }

  Future<bool> printLabel({
    required CompanyModel company,
    required String customerFullName,
    required ShippingAddress? shippingAddress,
    required int? orderNr,
  }) async {
    final labelZplData = getLabelZplData(
      companyName: company.name,
      senderStreetAndNr: '${company.street} ${company.houseNr}',
      senderPostalCodeAndCity: '${company.postalCode} ${company.city}',
      senderCountery: company.countery,
      receiverFullName: customerFullName,
      receiverStreetAndNr:
          '${shippingAddress?.street} ${shippingAddress?.houseNr}',
      receiverPostalCodeAndCity:
          '${shippingAddress?.postalCode} ${shippingAddress?.city}',
      receiverCountery: shippingAddress?.country ?? '',
      orderNr: orderNr.toString(),
    );

    return _zsdk
        .printZplDataOverTCPIP(
          data: labelZplData,
          address: ipAddress,
          port: defaultPort,
        )
        .then(
          (value) {
            return true;
          },
          onError: (_) {
            return false;
          },
        );
  }

  String getLabelZplData({
    required String companyName,
    required String senderStreetAndNr,
    required String senderPostalCodeAndCity,
    required String senderCountery,
    required String receiverFullName,
    required String receiverStreetAndNr,
    required String receiverPostalCodeAndCity,
    required String receiverCountery,
    required String orderNr,
  }) {
    return ''''
    ^XA

    ^FX Top section with logo, name and address.
    ^CF0,60
    ^FO50,50^GB100,100,100^FS
    ^FO75,75^FR^GB100,100,100^FS
    ^FO93,93^GB40,40,40^FS
    ^FO220,50^FD$companyName^FS
    ^CF0,30
    ^FO220,115^FD$senderStreetAndNr^FS
    ^FO220,155^FD$senderPostalCodeAndCity^FS
    ^FO220,195^FD$senderCountery^FS
    ^FO50,250^GB700,3,3^FS

    ^FX Second section with recipient address and permit information.
    ^CFA,30
    ^FO50,300^FD$receiverFullName^FS
    ^FO50,340^FD$receiverStreetAndNr^FS
    ^FO50,380^FD$receiverPostalCodeAndCity^FS
    ^FO50,420^FD$receiverCountery^FS
    ^CFA,15
    ^FO600,300^GB150,150,3^FS
    ^FO638,340^FDPermit^FS
    ^FO638,390^FD123456^FS
    ^FO50,500^GB700,3,3^FS

    ^FX Third section with bar code.
    ^BY5,2,270
    ^FO100,550^BC^FD$orderNr^FS

    ^FX Fourth section (the two boxes on the bottom).
    ^FO50,900^GB700,250,3^FS
    ^FO400,900^GB3,250,3^FS
    ^CF0,40
    ^FO100,960^FDCtr. X34B-1^FS
    ^FO100,1010^FDREF1 F00B47^FS
    ^FO100,1060^FDREF2 BL4H8^FS
    ^CF0,190
    ^FO470,955^FDCA^FS

    ^XZ
  ''';
  }
}
