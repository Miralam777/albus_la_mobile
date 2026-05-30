import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/widgets/loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showCreatingDialog(
  BuildContext context,
  ValueListenable<String> progressNotifier,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: AlertDialog(
        // TODO: text
        title: const Text('PDF wird generiert...'),
        content: ValueListenableBuilder<String>(
          valueListenable: progressNotifier,
          builder: (_, value, __) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LoadingIndicator(),
              K.pvm.verticalSpace,
              Text(value),
            ],
          ),
        ),
      ),
    ),
  );
}
