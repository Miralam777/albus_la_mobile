import 'dart:io';

import 'package:albus_la_mobile/core/utils/helpers/platform_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnWillPopDialog extends StatelessWidget {
  const OnWillPopDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return CupertinoAlertDialog(
      title: Column(
        children: [
          Text(
            // TODO: text
            // 'S.of(context).homePageOnWillPopDialog('title')',
            'S.of(context).homePageOnWillPopDialog(title)',
            style: textTheme.titleLarge,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
          ),
          SizedBox(height: 5.0.h),
        ],
      ),
      content: Text(
        // TODO: text
        // S.of(context).homePageOnWillPopDialog('content'),
        'S.of(context).homePageOnWillPopDialog(content)',
        style: textTheme.bodyMedium,
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: () {
            if (PlatformHelper.isIos()) {
              exit(0);
            } else {
              SystemNavigator.pop();
            }
          },
          textStyle: textTheme.bodyLarge!.copyWith(color: secondaryColor),
          child: Text(
            // TODO: text
            // 'S.of(context).homePageOnWillPopDialog('yes')',
            'S.of(context).homePageOnWillPopDialog(yes)',
          ),
        ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          textStyle: textTheme.bodyLarge!.copyWith(color: secondaryColor),
          child: Text(
            // TODO: text
            // S.of(context).homePageOnWillPopDialog('no'),
            'S.of(context).homePageOnWillPopDialog(no)',
          ),
        ),
      ],
    );
  }
}
