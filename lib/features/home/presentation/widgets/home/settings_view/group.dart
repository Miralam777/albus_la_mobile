import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/utils/helpers/platform_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingGroup extends StatelessWidget {
  const SettingGroup({super.key, this.title, required this.listTiles});

  final String? title;
  final List<Widget> listTiles;

  @override
  Widget build(BuildContext context) {
    final isIos = PlatformHelper.isIos();
    return Padding(
      padding: EdgeInsets.only(
        bottom: K.pm,
        left: isIos ? K.pm : 0.0,
        right: isIos ? K.pm : 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: isIos ? EdgeInsets.zero : EdgeInsets.only(left: K.pm),
              child: Text(
                title!,
                maxLines: 2,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 19.0.sp),
              ),
            ),
          ...listTiles,
        ],
      ),
    );
  }
}
