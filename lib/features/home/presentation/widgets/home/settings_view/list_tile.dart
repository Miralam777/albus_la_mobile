import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/platform_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingListTile extends StatelessWidget {
  const SettingListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.isFirst = false,
    this.isLast = false,
    this.withDivider = true,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isFirst;
  final bool isLast;
  final bool withDivider;
  final Widget? trailing;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final isIos = PlatformHelper.isIos();

    return Column(
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: isIos && isFirst ? const Radius.circular(K.rm) : Radius.zero,
              bottom: isIos && isLast
                  ? const Radius.circular(K.rm)
                  : Radius.zero,
            ),
          ),
          leading: Container(
            padding: EdgeInsets.all(10.0.r),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(K.rs),
            ),
            child: FittedBox(child: Icon(icon)),
          ),
          title: Text(title, overflow: TextOverflow.clip),
          subtitle: subtitle != null
              ? Text(subtitle!, overflow: TextOverflow.clip)
              : null,
          trailing: trailing ?? Icon(I.arrowForwardIos),
          onTap: onTap,
        ),
        if (withDivider) const Divider(),
      ],
    );
  }
}
