import 'package:albus_la_mobile/core/utils/helpers/bloc_events_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
// import 'package:a_zebra_utils/zsdk.dart' as zebra;
import 'package:zsdk/zsdk.dart' as zebra;

@injectable
class ProductLabelPrinterProvider extends ChangeNotifier {
  final _zsdk = zebra.ZSDK();

  String ipAddress = '';
  int defaultPort = 9100;

  bool isConnected = true;
  bool isStatusChecking = false;

  /// if context not null should get ip address from settings
  Future<void> checkStatus({int? port, BuildContext? context}) async {
    if (context != null) _getIpAddress(context);

    isStatusChecking = true;
    notifyListeners();

    _zsdk
        .checkPrinterStatusOverTCPIP(
          address: ipAddress,
          port: port ?? defaultPort,
        )
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
    ipAddress = BlocEventsHelper.getSettings(context).productLabelPrinterIp;
  }

  Future<bool> printLabel({
    required String title,
    required String qrcode,
    required String barcode,
  }) async {
    final labelZplData = getLabelZplData(
      title: title,
      qrcode: qrcode,
      barcode: barcode,
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
    required String title,
    required String qrcode,
    required String barcode,
  }) {
    return '''
      ^XA
      ^PW319
      ^LL319
      ^LS0

      ^FT0,45^A0N,28,28^FB319,1,7,C^FH\^CI28^FD$title^FS^CI27

      ^FT108,193^BQN,2,5
      ^FH\^FDLA,$qrcode^FS
      ^FT132,196^A0N,14,15^FH\^CI28^FD$qrcode^FS^CI27

      ^BY4,3,58^FT24,277^BCN,,Y,N
      ^FH\^FD>;$barcode^FS

      ^PQ1,0,1,Y
      ^XZ
    ''';
  }
}
