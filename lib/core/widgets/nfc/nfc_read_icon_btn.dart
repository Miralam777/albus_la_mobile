import 'dart:io' show Platform;

import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/global/nfc_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'btm_overlay/nfc_android_read_overlay.dart';

class NfcReadIconBtn extends StatelessWidget {
  const NfcReadIconBtn({super.key, required this.onRead, this.onError});
  final void Function(String?) onRead;
  final void Function(String, {bool? isAvailable})? onError;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(I.contactless),
      onPressed: () async {
        if (Platform.isIOS) {
          print('======> reading');
          await context.read<NfcNotifier>().read(
            // TODO: texts
            // alertMessageIos: S.of(context).gwNfcOverlaySubtitle(NfcSheetState.loading.name),
            // alertMessageScannSuccessIos:S.of(context).gwNfcOverlayTitle('successRead'),
            // errorMessageIos: S.of(context).gwNfcOverlaySubtitle(NfcSheetState.error.name),
            alertMessageIos: 'Nähere dich dem NFC-Tag',
            alertMessageScannSuccessIos: 'Erfolgreich gescannt!',
            errorMessageIos: 'Bitte versuche es erneut',
            onRead: onRead,
            onError: onError,
          );
        } else {
          await showNfcAndroidReadOverlay(context: context, onRead: onRead);

          if (!context.mounted) return;
          context.read<NfcNotifier>().stopSession();
        }
      },
    );
  }
}
