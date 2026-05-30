import 'dart:io' show Platform;

import 'package:albus_la_mobile/configs/services/vibration_service.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/helpers.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

Future<bool?> showTestProductQrcodeBtmNavSheet({
  required BuildContext context,
  required String? qrId,
}) async {
  return await showModalBottomSheet<bool?>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    useRootNavigator: true,
    builder: (_) => _TestProductQrcodeBtmNavSheet(qrId: qrId),
  );
}

class _TestProductQrcodeBtmNavSheet extends StatefulWidget {
  const _TestProductQrcodeBtmNavSheet({required this.qrId});
  final String? qrId;

  @override
  State<_TestProductQrcodeBtmNavSheet> createState() =>
      _TestProductQrcodeBtmNavSheetState();
}

class _TestProductQrcodeBtmNavSheetState
    extends State<_TestProductQrcodeBtmNavSheet> {
  QRViewController? _qRController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    print('=========> widget.qrId');
    print(widget.qrId);
    super.initState();
  }

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
          children: <Widget>[
            _buildQrView(),
            _buildQrControl(),

            // TODO: remove
            IconButton(
              onPressed: () async {
                await VibrationService.successVibration();
                if (!context.mounted) return;
                Navigator.of(context, rootNavigator: true).pop(true);
              },
              icon: Icon(I.check),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView() {
    return QRView(
      key: qrKey,
      formatsAllowed: const <BarcodeFormat>[
        BarcodeFormat.qrcode,
        BarcodeFormat.aztec,
      ],
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).primaryColor,
        overlayColor: const Color(0xFF000000).withValues(alpha: 0.7),
        cutOutBottomOffset: 60.0.h,
        borderRadius: K.rl,
        borderLength: 40.0.r,
        borderWidth: 10.0.r,
        cutOutSize: 250.0.r,
      ),
      onQRViewCreated: _onQRViewCreated,
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  Align _buildQrControl() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: K.pvl.h),
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

  bool _isInIf = true;

  void _onQRViewCreated(QRViewController controller) {
    print('_onQRViewCreated()');
    setState(() => _qRController = controller);
    controller.scannedDataStream.listen((scanData) async {
      print('scanData.code: ${scanData.code}');
      print('widget.qrId: ${widget.qrId}');
      // TODO: link
      final scanedQrId = Helpers.getProductIdFromUrl(scanData.code);
      print('scanedQrId: $scanedQrId');
      // TODO: maybe for type
      // if (scanData.code == widget.qrId) {
      if (scanedQrId == widget.qrId) {
        if (_isInIf) {
          _isInIf = false;
          await VibrationService.successVibration();
          if (!mounted) return;
          Navigator.of(context, rootNavigator: true).pop(true);
        }
      } else {
        VibrationService.mismatchVibration();
        ToastUtils.show(
          // TODO: text
          msg: 'Die QR-Codes stimmen nicht überein.',
          bgRed: true,
        );
        _qRController?.pauseCamera();
      }
    });
  }

  void _onPermissionSet(
    BuildContext context,
    QRViewController ctrl,
    bool p,
  ) async {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        // TODO: text
        const SnackBar(content: Text('keine Kamera-Erlaubnis')),
      );
    }
  }
}
