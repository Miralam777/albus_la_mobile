import 'package:albus_la_mobile/core/global/nfc_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/widgets.dart';

OverlayEntry? _overlayEntry;

Future<void> showNfcAndroidReadOverlay({
  required BuildContext context,
  required Function(String? data) onRead,
}) async {
  if (_overlayEntry != null) return; // Prevent multiple sheets

  _overlayEntry = OverlayEntry(
    builder: (context) => _NfcReadBtmSheet(
      onRead: onRead,
      onClose: () {
        _overlayEntry?.remove();
        _overlayEntry = null;
      },
    ),
  );

  Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
}

class _NfcReadBtmSheet extends StatefulWidget {
  const _NfcReadBtmSheet({required this.onRead, required this.onClose});

  final void Function(String? data) onRead;
  final void Function() onClose;

  @override
  State<_NfcReadBtmSheet> createState() => _NfcReadBtmSheetState();
}

class _NfcReadBtmSheetState extends State<_NfcReadBtmSheet> {
  NfcSheetState _state = NfcSheetState.loading;
  bool? _isAvailable;

  @override
  void initState() {
    super.initState();
    _read();
  }

  void _read() {
    context.read<NfcNotifier>().read(
      onRead: (data) {
        setState(() => _state = NfcSheetState.success);
        widget.onRead(data);
      },
      onError: (error, {bool? isAvailable}) {
        if (!mounted) return;
        setState(() {
          _state = NfcSheetState.error;
          _isAvailable = isAvailable;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NfcOverlayBody(
      isWrite: false,
      state: _state,
      isAvailable: _isAvailable,
      onTryAgain: () {
        setState(() {
          _state = NfcSheetState.loading;
          _isAvailable = null;
        });
        _read();
      },
      onCloseAnimationDone: () => widget.onClose(),
    );
  }
}
