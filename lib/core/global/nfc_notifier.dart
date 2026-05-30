import 'dart:io' show Platform;
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:nfc_manager/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';

//! add to pubspec.yaml
// nfc_manager
// nfc_manager_ndef

//! ANDROID:
// 1. minSdkVersion = 19 or higher
// 2. add nfc permissions to manifes.xml
/*
  <uses-permission android:name="android.permission.NFC" />
  <uses-feature android:name="android.hardware.nfc" android:required="false" />

  ! 2. optinal in </activity>
  !-- ! nfc_manager -->
  <!-- Nfc-Intent Filter, damit du NFC-Tags empfangen kannst -->
  <!-- with receive_intent package -->
  <intent-filter>
      <action android:name="android.nfc.action.NDEF_DISCOVERED"/>
      <category android:name="android.intent.category.DEFAULT"/>
      <data android:scheme="http"/>
      <data android:scheme="https"/>
  </intent-filter>
*/

//! IOS:
// 1. iOS Deployment Target is set = 13.0 or higher.
// 2. add nfc permissions to info.plist
/*
 <key>NFCReaderUsageDescription</key>
 <string>Diese App verwendet NFC, um Tags zu lesen und zu schreiben.</string>
 <key>com.apple.developer.nfc.readersession.felica.systemcodes</key>
    <array>
        <string>8005</string>
        <string>8008</string>
        <string>0003</string>
        <string>fe00</string>
        <string>90b7</string>
        <string>927a</string>
        <string>86a7</string>
        <string>04D1</string>
        <string>80DE</string>
        <string>865E</string>
        <string>8592</string>
        <string>8B5D</string>
        <string>8FC1</string>
        <string>FE00</string>
    </array>
    <key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
    <array>
        <string>A0000002471001</string>
        <string>A000000003101001</string>
        <string>A000000003101002</string>
        <string>A0000000041010</string>
        <string>A0000000042010</string>
        <string>A0000000044010</string>
        <string>44464D46412E44466172653234313031</string>
        <string>D2760000850100</string>
        <string>D2760000850101</string>
        <string>00000000000000</string>
    </array>
*/

// 3. TARGETS > Runner > Signing & Capabilities > +capabilities => "Near Field Communication Tag Reading"
// 📁 Datei: ios/Runner/Runner.entitlements
/*
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.nfc.readersession.formats</key>
    <array>
        <string>NDEF</string>
    </array>
</dict>
</plist>

// ! l10n de

    "gwNfcOverlayTitle": "{state, select, notAvailable{NFC ist ausgeschaltet} loading{Bereit zum Scannen} successWrite{Erfolgreich geschrieben!} successRead{Erfolgreich gescannt!} error{NFC-Tag nicht kompatibel} other{}}",
    "@gwNfcOverlayTitle": {
        "placeholders": {"state": {"type": "String"}}
    },
    "gwNfcOverlaySubtitle": "{state, select, loading{Nähere dich dem NFC-Tag} error{Bitte versuche es erneut} other{}}",
    "@gwNfcOverlaySubtitle": {
        "placeholders": {"state": {"type": "String"}}
    },
    "gwNfcOverlayTryAgainBtnTitle": "Erneut versuchen",
    "gwNfcOverlayCancelBtnTitle": "Abbrechen",
*/

enum NfcOperation { read, write }

enum NdefMsgType { url, text, mime }

// TODO: clean
@injectable
class NfcNotifier with ChangeNotifier {
  static const _nfcPollingOptions = {
    NfcPollingOption.iso14443, // z. B. NTAGs, MIFARE
    NfcPollingOption.iso15693, // z. B. ICODE
    NfcPollingOption.iso18092, // z. B. Felica (Japan)
  };

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;
  void _setProcessing(bool isProcessing) {
    _isProcessing = isProcessing;
    notifyListeners();
  }

  Future<void> stopSession({
    bool immediately = false,
    String? alertMessageSuccessIos,
    String? errorMessageIos,
  }) async {
    _setProcessing(false);
    if (Platform.isAndroid) {
      if (!immediately) {
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    await NfcManager.instance.stopSession(
      alertMessageIos: alertMessageSuccessIos,
      errorMessageIos: errorMessageIos,
    );
  }

  Future<bool> _isAvailable() async =>
      await NfcManager.instance.checkAvailability() == NfcAvailability.enabled;

  Future<void> read({
    String? alertMessageIos,
    String? alertMessageScannSuccessIos,
    String? errorMessageIos,
    required void Function(String? data) onRead,
    void Function(String error, {bool? isAvailable})? onError,
  }) async {
    print('===============> _readTag()');

    final available = await _isAvailable();
    if (!available) {
      onError?.call(isAvailable: false, 'Error: NFC is not available');
      return;
    }

    _setProcessing(true);

    // ! tests
    /*     await Future.delayed(Duration(seconds: 3)).then((_) async {
      onError?.call(true, 'This tag is not compatible with an NDEF.');
      // onRead('Read test was successful.');
      await _instance.stopSession();
      _setProcessing(false);
    }); */
    // ! tests

    print('===============> avalable');
    await NfcManager.instance
        .startSession(
      alertMessageIos: alertMessageIos,
      pollingOptions: _nfcPollingOptions,
      onSessionErrorIos: (e) async {
        onError?.call(e.message);
        await stopSession(
          alertMessageSuccessIos: alertMessageScannSuccessIos,
          errorMessageIos: errorMessageIos,
        );
      },
      onDiscovered: (NfcTag tag) async {
        try {
          print('[NFC] Tag discovered: $tag');
          // ! test
          /*      final tagData = tag.data; // vom Typ TagPigeon
            print('Tag Type: ${tagData.runtimeType}');
            print('Tag Type: ${tagData.hashCode}'); */

          // print('Tag Type: ${tagData.type}');
          // print('Standard: ${tagData.standard}');
          // print('ID: ${tagData.id}');

          // 1. Raw Map anzeigen (wenn möglich)
          // print('Raw tag data: ${tagData}');

          // 2. UID auslesen (wenn in Map enthalten)
          /*             if (tagData.containsKey('id')) {
              print('Tag UID: ${tagData['id']}');
            } */
          /*         final tagMap = tag.data as Map;
            // 1. Raw Map anzeigen (wenn möglich)
            print('Raw tag data: ${tagMap}');

            // 2. UID auslesen (wenn in Map enthalten)
            if (tagMap.containsKey('id')) {
              print('Tag UID: ${tagMap['id']}');
            } */
          // ! test

          final ndef = Ndef.from(tag);

          // print(ndef?.additionalData);
          // final cm = ndef?.cachedMessage;
          // final record = cm?.records[0];
          // final text = String.fromCharCodes(record.payload.sublist(3));
          // print(record?.typeNameFormat);
          // print(String.fromCharCodes(record?.identifier ?? []));
          // print(String.fromCharCodes(record?.payload ?? []));
          // print(String.fromCharCodes(record?.type ?? []));
          print('ndef?.isWritable: ${ndef?.isWritable}');
          print('ndef is null: ${ndef == null}');

          if (ndef == null) {
            onError?.call('This tag is not compatible with an NDEF.');
            await stopSession(
              alertMessageSuccessIos: alertMessageScannSuccessIos,
              errorMessageIos: errorMessageIos,
            );
            return;
          }

          final cachedMessage = ndef.cachedMessage;
          if (cachedMessage == null || cachedMessage.records.isEmpty) {
            onRead(null);
            await stopSession(
              alertMessageSuccessIos: alertMessageScannSuccessIos,
              errorMessageIos: errorMessageIos,
            );
            return;
          }

          bool dataFound = false;

          for (final record in cachedMessage.records) {
            print('[NFC] Processing record...');
            if (record.typeNameFormat == TypeNameFormat.wellKnown &&
                record.payload.isNotEmpty) {
              final text = _payloadToText(record.payload);
              print('[NFC] Extracted text: $text');
              onRead(text);
              dataFound = true;
              break; // read only first useful record
            }
          }

          if (!dataFound) {
            onRead(null);
            await stopSession(
              alertMessageSuccessIos: alertMessageScannSuccessIos,
              errorMessageIos: errorMessageIos,
            );
          }
        } catch (error) {
          print('=========> catch: $error');
          onError?.call(error.toString());
        }

        await stopSession(
          alertMessageSuccessIos: alertMessageScannSuccessIos,
        );
      },
    )
        .onError((error, _) async {
      onError?.call(error.toString());
      await stopSession(
        alertMessageSuccessIos: alertMessageScannSuccessIos,
        errorMessageIos: errorMessageIos,
      );
    });
  }

  Future<void> write({
    String? alertMessageIos,
    String? alertMessageWriteSuccessIos,
    String? errorMessageIos,
    required NdefMsgType type,
    required String data,
    bool writeLock = false,
    void Function()? onDone,
    void Function(String error, {bool? isAvailable})? onError,
  }) async {
    print('==============> _writeToTag');
    print('writeLock: $writeLock');
    print('data: $data');

    final available = await _isAvailable();
    if (!available) {
      onError?.call('Error: NFC is not available', isAvailable: false);
      return;
    }

    _setProcessing(true);

    // ! tests
    /*     await Future.delayed(Duration(seconds: 3)).then((_) async {
      onError?.call('This tag is not compatible with an NDEF.');
      // onRead('Read test was successful.');
      await _instance.stopSession();
      _setProcessing(false);
    }); */
    // ! tests

    await NfcManager.instance
        .startSession(
      alertMessageIos: alertMessageIos,
      pollingOptions: _nfcPollingOptions,
      onSessionErrorIos: (e) async {
        onError?.call(e.message);
        await stopSession(
          alertMessageSuccessIos: alertMessageWriteSuccessIos,
          errorMessageIos: errorMessageIos,
        );
      },
      onDiscovered: (NfcTag tag) async {
        try {
          print('======> write');
          final ndef = Ndef.from(tag);

          print('isWritable: ${ndef?.isWritable}');
          print('additionalData: ${ndef?.additionalData}');
          print('cachedMessage: ${ndef?.cachedMessage}');

          if (ndef == null || !ndef.isWritable) {
            onError?.call(
              ndef == null
                  ? 'This tag is not compatible.'
                  : 'This tag is not writable.',
            );
            await stopSession(
              alertMessageSuccessIos: alertMessageWriteSuccessIos,
              errorMessageIos: errorMessageIos,
            );
            return;
          }

          final msg = _createNdefMessage(type: type, data: data);

          await ndef.write(message: msg);

          if (writeLock) await ndef.writeLock();

          onDone?.call();
        } catch (error) {
          print('=========> catch: $error');
          onError?.call(error.toString());
        }

        await stopSession(
          alertMessageSuccessIos: alertMessageWriteSuccessIos,
        );
      },
    )
        .onError((error, _) async {
      onError?.call(error.toString());
      await stopSession(
        alertMessageSuccessIos: alertMessageWriteSuccessIos,
        errorMessageIos: errorMessageIos,
      );
    });
  }

  NdefMessage _createNdefMessage({
    required NdefMsgType type,
    required String data,
  }) =>
      switch (type) {
        NdefMsgType.url => NdefMessage(
            records: [
              NdefRecord(
                typeNameFormat: TypeNameFormat.wellKnown,
                type: Uint8List.fromList('U'.codeUnits),
                identifier: Uint8List.fromList(Uint8List(0)),
                // 0x01='http://www.' 0x02='https://www.' 0x03='http://' 0x04='https://'
                payload: Uint8List.fromList([0x04] + data.codeUnits),
              ),
            ],
          ),
        NdefMsgType.mime => NdefMessage(
            records: [
              NdefRecord(
                typeNameFormat: TypeNameFormat.media,
                // json=aplication/json data='{name: 'Anna', 'url':'myurl.com'}'
                type: Uint8List.fromList('text/vcard'.codeUnits),
                identifier: Uint8List.fromList(Uint8List(0)),
                payload: Uint8List.fromList(data.codeUnits),
              ),
            ],
          ),
        NdefMsgType.text || _ => NdefMessage(
            records: [
              NdefRecord(
                typeNameFormat: TypeNameFormat.wellKnown,
                // "T" Text, "U" Url, "text/plain" MIME-Typ
                type: Uint8List.fromList('T'.codeUnits),
                identifier: Uint8List.fromList('0'.codeUnits),
                payload: Uint8List.fromList(data.codeUnits),
              ),
            ],
          ),
      };

  String _payloadToText(List<int> codeUnits) {
    final rawText = utf8.decode(codeUnits);
    final controlCharRegex = RegExp(r'[\x00-\x1F\x7F]');
    return rawText.replaceAll(controlCharRegex, '');
  }
}
