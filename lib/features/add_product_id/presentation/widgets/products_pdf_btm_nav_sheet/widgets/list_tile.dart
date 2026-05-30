import 'package:albus_la_mobile/constants/consts.dart';
import 'package:flutter/material.dart';

class ProuductsPdfListTile extends StatelessWidget {
  const ProuductsPdfListTile({
    super.key,
    this.icon,
    this.leading,
    required this.title,
    required this.onTap,
  });

  final IconData? icon;
  final Widget? leading;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(top: K.pvsH),
      child: ListTile(
        leading: leading ?? Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
