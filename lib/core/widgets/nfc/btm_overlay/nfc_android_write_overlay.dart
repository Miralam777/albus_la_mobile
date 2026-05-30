import 'package:albus_la_mobile/core/global/nfc_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/widgets.dart';

OverlayEntry? _overlayEntry;

Future<void> showNfcAndroidWriteOverlay({
  required BuildContext context,
  required String data,
  required NdefMsgType type,
  bool writeLock = false,
  void Function()? onDone,
  void Function(String error, {bool? isAvailable})? onError,
}) async {
  if (_overlayEntry != null) return;

  _overlayEntry = OverlayEntry(
    builder: (context) => _NfcWriteBtmSheet(
      data: data,
      type: type,
      writeLock: writeLock,
      onDone: onDone,
      onError: onError,
      onClose: () {
        _overlayEntry?.remove();
        _overlayEntry = null;
      },
    ),
  );

  Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
}

class _NfcWriteBtmSheet extends StatefulWidget {
  const _NfcWriteBtmSheet({
    required this.data,
    required this.type,
    this.writeLock = false,
    this.onDone,
    this.onError,
    required this.onClose,
  });

  final String data;
  final NdefMsgType type;
  final bool writeLock;
  final void Function()? onDone;
  final void Function(String error, {bool? isAvailable})? onError;
  final void Function() onClose;

  @override
  State<_NfcWriteBtmSheet> createState() => _NfcWriteBtmSheetState();
}

class _NfcWriteBtmSheetState extends State<_NfcWriteBtmSheet> {
  NfcSheetState _state = NfcSheetState.loading;
  bool? _isAvailable;

  @override
  void initState() {
    super.initState();
    _write();
  }

  void _write() {
    context.read<NfcNotifier>().write(
      data: widget.data,
      type: widget.type,
      writeLock: widget.writeLock,
      onDone: () {
        setState(() {
          _state = NfcSheetState.success;
        });
        widget.onDone?.call();
      },
      onError: (error, {bool? isAvailable}) {
        setState(() {
          _state = NfcSheetState.error;
          _isAvailable = isAvailable;
        });
        widget.onError?.call(error, isAvailable: isAvailable);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NfcOverlayBody(
      isWrite: true,
      state: _state,
      isAvailable: _isAvailable,
      onTryAgain: () {
        setState(() {
          _state = NfcSheetState.loading;
          _isAvailable = null;
        });
        _write();
      },
      onCloseAnimationDone: () => widget.onClose(),
    );
  }
}
