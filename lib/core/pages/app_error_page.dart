import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/consts.dart';
import '../../constants/icons.dart';

class AppErrorPage extends StatelessWidget {
  const AppErrorPage({super.key, this.isAppCrached = false});
  final bool isAppCrached;

  static const String appCrach = 'appCrach';
  static const String siteNotFund = 'siteNotFund';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          // TODO
          isAppCrached
              ? 'S.of(context).appErrorPageAppBarTilte(appCrach)'
              : 'S.of(context).appErrorPageAppBarTilte(siteNotFund)',
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              isAppCrached
                  ? Theme.of(context).colorScheme.error.withValues(alpha: 0.7)
                  : Theme.of(context).primaryColor.withValues(alpha: 0.3),
              BlendMode.color,
            ),
            // TODO
            /* child: Assets.images.backgrounds.failureBackground.image(
              height: double.infinity,
              fit: BoxFit.cover,
            ), */
          ),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: const SizedBox.expand(),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30.0.h, horizontal: 8.0.r),
            margin: EdgeInsets.all(20.0.w),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(K.rl),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  I.error,
                  size: 50.r,
                  color: Theme.of(context).colorScheme.error,
                ),
                SizedBox(height: 20.0.h),
                Text(
                  'TODO',
                  // TODO
                  /* isAppCrached
                      ? S.of(context).appErrorPageBody(appCrach)
                      : S.of(context).appErrorPageBody(siteNotFund), */
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 20.0.h),
                ElevatedButton(
                  child: Text(
                    'TODO',
                    // TODO
/*                     isAppCrached
                        ? S.of(context).appErrorPageBtn(appCrach)
                        : S.of(context).appErrorPageBtn(siteNotFund), */
                  ),
                  onPressed: () {
                    if (isAppCrached) {
                      exit(0);
                    } else {
                      // TODO
                      // context.go(Routes.homePage);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
