import 'package:albus_la_mobile/core/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/consts.dart';
import '../../widgets/svg_un_draw_image.dart';

class DialogsUtils {
  DialogsUtils._();

  //! ok or cancel dialog
  static Future<void> showOkCancelDialog({
    required BuildContext context,
    IconData? icon,
    String? title,
    String? message,
    bool showLoadingIndacator = false,
    String? okLabel,
    required VoidCallback onOk,
    String? cancelLabel,
    VoidCallback? onCancel,
  }) async {
    await showAdaptiveDialog<String>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: !showLoadingIndacator,
      builder: (context) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog.adaptive(
            title: title != null
                ? Text(
                    title,
                    // TODO: theme
                    textAlign: TextAlign.center,
                  )
                : null,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) Icon(icon, size: 32.0.r),
                SizedBox(height: K.pvmH),
                if (message != null)
                  Text(
                    message,
                    // TODO: theme
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                  ),
                if (showLoadingIndacator && isLoading) const LoadingIndicator(),
              ],
            ),
            actions: <Widget>[
              _adaptiveAction(
                context: context,
                // TODO: text
                child: Text(cancelLabel ?? 'Nein'),
                onPressed: () {
                  if (onCancel != null) {
                    onCancel();
                  }
                  context.pop();
                },
              ),
              _adaptiveAction(
                // TODO: text
                context: context,
                child: Text(okLabel ?? 'Ja'),
                onPressed: () async {
                  // if (onOk != null) onOk();
                  if (showLoadingIndacator) {
                    setState(() => isLoading = true);
                    await Future.delayed(const Duration(milliseconds: 777));
                  }
                  onOk();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showDoneDialog(
    BuildContext context, {
    String? title,
    String? content,
    required String svgUnDrawImagePath,
    // TODO: remove color
    Color? color,
    Widget? action,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(K.rl),
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: 40.0.r,
            vertical: 24.0.r,
          ),
          titlePadding: EdgeInsets.only(
            top: 24.0.r,
            left: 24.0.r,
            right: 24.0.r,
          ),
          buttonPadding: EdgeInsets.only(left: 8.0.r),
          contentPadding: EdgeInsets.only(
            top: 20.0.r,
            left: 24.0.r,
            right: 24.0.r,
            bottom: 15.0.r,
          ),
          actionsAlignment: MainAxisAlignment.center,
          title: title != null
              ? Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                )
              : null,
          content: SizedBox(
            width: 300.0.w,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SvgUnDrawImage(path: svgUnDrawImagePath, color: color),
                  if (content != null)
                    Text(
                      content,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.clip,
                    ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              // TODO: text
              child: Text('Schließen'),
              onPressed: () => context.pop(),
            ),
            if (action != null) action,
          ],
        );
      },
    );
  }

  //! cupertino modal pop up
  static void cupertinoModalPopup(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required String yes,
    required String no,
    required String cancel,
    required Function() yesFcn,
    required Function() noFcn,
    required Function() cancelFcn,
  }) {
    // TODO: for android
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => _CupertinoActionSheetWidget(
        title: title,
        message: message,
        icon: icon,
        yes: yes,
        no: no,
        cancel: cancel,
        yesFcn: yesFcn,
        noFcn: noFcn,
        cancelFcn: cancelFcn,
      ),
    );
  }
}

Widget _adaptiveAction({
  required BuildContext context,
  required VoidCallback onPressed,
  required Widget child,
}) {
  final ThemeData theme = Theme.of(context);
  switch (theme.platform) {
    case TargetPlatform.iOS:
      return CupertinoDialogAction(onPressed: onPressed, child: child);
    default:
      return TextButton(onPressed: onPressed, child: child);
  }
}

// TODO: extract widget
class _CupertinoActionSheetWidget extends StatelessWidget {
  const _CupertinoActionSheetWidget({
    required this.title,
    required this.message,
    required this.icon,
    required this.yes,
    required this.no,
    required this.cancel,
    required this.yesFcn,
    required this.noFcn,
    required this.cancelFcn,
  });

  final String title;
  final String message;
  final IconData icon;
  final String yes;
  final String no;
  final String cancel;
  final Function() yesFcn;
  final Function() noFcn;
  final Function() cancelFcn;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final actionSheetTextStyle = textTheme.bodyLarge!.copyWith(
      color: Theme.of(context).colorScheme.secondary,
      fontSize: 18.sp,
    );

    return CupertinoActionSheet(
      title: Text(
        title,
        style: textTheme.titleLarge,
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
      ),
      message: Column(
        children: [
          // TODO: icon
          Icon(icon, size: 40.0.r, color: Colors.red),
          SizedBox(height: 10.h),
          Text(
            message,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: yesFcn,
          child: Text(yes, style: actionSheetTextStyle),
        ),
        CupertinoActionSheetAction(
          onPressed: noFcn,
          child: Text(no, style: actionSheetTextStyle),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () => Navigator.pop(context),
        child: Text(
          cancel,
          style: actionSheetTextStyle.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}
