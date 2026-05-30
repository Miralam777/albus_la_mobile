import 'dart:io' show Platform;

import 'package:albus_la_mobile/configs/network/network_info.dart';
import 'package:albus_la_mobile/configs/services/firebase/firestore_service.dart';
import 'package:albus_la_mobile/configs/services/vibration_service.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/toast_utils.dart';
import 'package:albus_la_mobile/core/widgets/loading_indicator.dart';
import 'package:albus_la_mobile/core/widgets/svg_un_draw_image.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import 'order_add_qrcode_model.dart';

// TODO: clean

Future<OrderAddQrcodeModel?> showOrderAddQrcodeBtmNavSheet({
  required BuildContext context,
  required int? productId,
  required int? amount,
}) async {
  return await showModalBottomSheet<OrderAddQrcodeModel?>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    useRootNavigator: true,
    builder: (_) =>
        _OrderAddQrcodeBtmNavSheet(productId: productId, amount: amount),
  );
}

class _OrderAddQrcodeBtmNavSheet extends StatefulWidget {
  const _OrderAddQrcodeBtmNavSheet({
    required this.productId,
    required this.amount,
  });
  final int? productId;
  final int? amount;

  @override
  State<_OrderAddQrcodeBtmNavSheet> createState() =>
      _OrderAddQrcodeBtmNavSheetState();
}

class _OrderAddQrcodeBtmNavSheetState
    extends State<_OrderAddQrcodeBtmNavSheet> {
  QRViewController? _qRController;
  final GlobalKey _qrcodeKey = GlobalKey(debugLabel: 'QRCODE');
  final GlobalKey _barcodeKey = GlobalKey(debugLabel: 'BARCODE');

  final PageController _pageController = PageController(initialPage: 0);
  bool _isGettingQrcodeFromServer = false;

  // List<OrderAddQrcodeModel>? _addQrcodeModels = [];
  OrderAddQrcodeModel? _addQrcodeModel;

  // TODO: remove
  String? _scannedBarcode;

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      _qRController?.pauseCamera();
    }
    _qRController?.resumeCamera();
    super.reassemble();
  }

  @override
  void dispose() {
    _qRController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaHelper.h(context) * 0.7,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(K.rl)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildQrView(
                  key: _barcodeKey,
                  // TODO: text
                  title: 'Produkt-Barcode scannen.',
                  isBarCode: true,
                ),
                _buildQrView(
                  key: _qrcodeKey,
                  // TODO: text
                  title: 'Produkt-Qr-Code scannen.',
                  isBarCode: false,
                ),
                // _buildServerView(),
              ],
            ),
            _buildQrControl(),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView({
    required Key key,
    required String title,
    required bool isBarCode,
  }) {
    return Stack(
      children: [
        QRView(
          key: key,
          formatsAllowed: isBarCode
              ? <BarcodeFormat>[
                  BarcodeFormat.itf,
                  BarcodeFormat.codabar,
                  BarcodeFormat.code93,
                  BarcodeFormat.code39,
                  BarcodeFormat.code128,
                  BarcodeFormat.ean8,
                  BarcodeFormat.ean13,
                  BarcodeFormat.upcA,
                  BarcodeFormat.upcE,
                ]
              : <BarcodeFormat>[BarcodeFormat.qrcode, BarcodeFormat.aztec],
          overlay: QrScannerOverlayShape(
            borderColor: Theme.of(context).primaryColor,
            overlayColor: const Color(0xFF000000).withValues(alpha: 0.7),
            cutOutBottomOffset: 60.0.h,
            borderRadius: K.rl,
            borderLength: isBarCode ? 25.0.r : 40.0.r,
            borderWidth: 10.0.r,
            cutOutSize: isBarCode ? null : 250.0.r,
            cutOutWidth: isBarCode ? MediaHelper.w(context) - 30.0.w : null,
            cutOutHeight: isBarCode ? 120.0.h : null,
          ),
          onQRViewCreated: isBarCode ? _onBarcodeScan : _onQrcodeScan,
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 50.0.h),
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ),
        ),
        // TODO: remove
        Visibility(
          visible: isBarCode,
          child: Align(
            alignment: const Alignment(0, 0.45),
            child: Text(
              // TODO: last time
              'Barcode: $_scannedBarcode',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        // TODO: remove
        IconButton(
          onPressed: () async {
            if (isBarCode) {
              _goToView(1);
            } else {
              // _goToView(2);
              context.pop();
            }
          },
          icon: const Text('NEXT'),
        ),
        // TODO: remove
        /*         Align(
          alignment: Alignment.topCenter,
          child: ElevatedButton(
            child: const Text('Get Qrcode'),
            onPressed: () async {
              _getQrcodeFromServer();
            },
          ),
        ), */
      ],
    );
  }

  Widget _buildQrControl() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: K.pvl2xH),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _backgoundContainer(
                child: IconButton(
                  icon: FutureBuilder(
                    future: _qRController?.getFlashStatus(),
                    builder: (context, snapshot) {
                      return Padding(
                        padding: EdgeInsets.all(2.0.r),
                        child: snapshot.data != null
                            ? Icon(
                                snapshot.data! ? I.flashOn : I.flashOff,
                                size: 30.0.r,
                                color: Colors.white,
                              )
                            : Icon(
                                I.flashOff,
                                size: 30.0.r,
                                color: Colors.white30,
                              ),
                      );
                    },
                  ),
                  onPressed: () async {
                    await _qRController?.toggleFlash();
                    setState(() {});
                  },
                ),
              ),
              _backgoundContainer(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0.w),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2.0.r,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: Padding(
                          padding: EdgeInsets.all(5.0.r),
                          child: Icon(
                            I.qrCodeScanner,
                            size: 40.0.r,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          await _qRController?.resumeCamera();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              _backgoundContainer(
                child: IconButton(
                  icon: FutureBuilder(
                    future: _qRController?.getCameraInfo(),
                    builder: (context, snapshot) {
                      return Padding(
                        padding: EdgeInsets.all(2.0.r),
                        child: Icon(
                          snapshot.data == CameraFacing.back
                              ? I.cameraRear
                              : I.cameraFront,
                          size: 30.0.r,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  onPressed: () async {
                    await _qRController?.flipCamera();
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _backgoundContainer({required Widget child}) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
    ),
    child: child,
  );

  /*   Widget _buildServerView() {
    return Column(
      children: [
        50.0.verticalSpace,
        SvgUnDrawImage(path: Assets.undraws.serverCluster),
        K.pvm.verticalSpace,
        Text(
          // TODO: text
          'Bitte warten Sie auf die Serverantwort.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        K.pvm.verticalSpace,
        const LoadingIndicator(),
      ],
    );
  } */

  // bool _isBarcodeScaned = true;
  void _onBarcodeScan(QRViewController controller) {
    setState(() => _qRController = controller);
    controller.scannedDataStream.listen((scanData) async {
      print('==========> barcode');
      print('scanData.code: ${scanData.code}');
      print('productId: ${widget.productId.toString()}');
      setState(() {
        _scannedBarcode = scanData.code;
      });
      // if (_isBarcodeScaned) {
      // _isBarcodeScaned = false;
      if (scanData.code == widget.productId.toString()) {
        _qRController?.stopCamera();
        VibrationService.successVibration();
        // setState(() => _isBarCode = false);
        // _isBarCode = false;
        _goToView(1);
      } else {
        VibrationService.mismatchVibration();
        // TODO: text
        ToastUtils.error('Die QR-Codes stimmen nicht überein.');
        _qRController?.pauseCamera();
      }
      // }
    });
  }

  // bool _isInIf = true;
  void _onQrcodeScan(QRViewController controller) {
    setState(() => _qRController = controller);
    controller.scannedDataStream.listen((scanData) async {
      print('==========> qrcode');
      print('scanData.code: ${scanData.code}');

      _qRController?.stopCamera();
      _getQrcodeFromServer(scanData.code);
      /*       if (scanData.code == 'Hello :)') {
        _qRController?.stopCamera();
        // await VibrationService.successVibration();
        // _goToView(2);
        _getQrcodeFromServer();
      } else {
        _errorToastAndVibration();
      } */
    });
  }

  Future<void> _getQrcodeFromServer(String? scannedQrcode) async {
    print('===========> _getQrcodeFromServer()');
    setState(() => _isGettingQrcodeFromServer = true);
    // TODO:
    // await Future.delayed(const Duration(seconds: 3));

    if (!(await NetworkInfo().isConnected)) {
      ToastUtils.error('Keine Internetverbindung.');
      return;
    }

    final orderAddQrcodeModel = await FirestoreService.getOrderAddQrcodeModel(
      scannedQrcode,
    );
    // print('====> qrcode)');
    // print(qrcode?.toMap());
    print('qrcode != null');
    print(orderAddQrcodeModel != null);
    if (orderAddQrcodeModel != null) {
      VibrationService.successVibration();
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(orderAddQrcodeModel);
    } else {
      print('qrcode is null');
      // TODO: error
      VibrationService.mismatchVibration();
      // TODO: text
      ToastUtils.error('Ungültiger QR-Code');
      setState(() => _isGettingQrcodeFromServer = false);
    }
  }

  void _onPermissionSet(
    BuildContext context,
    QRViewController ctrl,
    bool p,
  ) async {
    if (!p) {
      // TODO: text
      ToastUtils.error('Keine Kamera-Erlaubnis');
    }
  }

  void _goToView(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
