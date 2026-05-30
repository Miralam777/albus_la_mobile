import 'dart:io' show Platform;

import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/global/nfc_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'btm_overlay/nfc_android_write_overlay.dart';

class NfcWriteIconBtn extends StatelessWidget {
  const NfcWriteIconBtn({
    super.key,
    required this.type,
    required this.data,
    this.writeLock = false,
    this.onDone,
    this.onError,
  });
  final NdefMsgType type;
  final String data;
  final bool writeLock;
  final void Function()? onDone;
  final void Function(String error, {bool? isAvailable})? onError;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(I.nfc),
      onPressed: () async {
        if (Platform.isIOS) {
          print('======> writing');
          await context.read<NfcNotifier>().write(
            // TODO: texts
            // alertMessageIos: S.of(context).gwNfcOverlaySubtitle(NfcSheetState.loading.name),
            // alertMessageScannSuccessIos:S.of(context).gwNfcOverlayTitle('successWrite'),
            // errorMessageIos: S.of(context).gwNfcOverlaySubtitle(NfcSheetState.error.name),
            alertMessageIos: 'Nähere dich dem NFC-Tag',
            alertMessageWriteSuccessIos: 'Erfolgreich geschrieben!',
            errorMessageIos: 'Bitte versuche es erneut',
            data: data,
            type: type,
            writeLock: writeLock,
            onDone: onDone,
            onError: onError,
          );
        } else {
          await showNfcAndroidWriteOverlay(
            context: context,
            data: data,
            type: type,
            writeLock: writeLock,
            onDone: onDone,
            onError: onError,
          );
        }
      },
    );
  }
}
