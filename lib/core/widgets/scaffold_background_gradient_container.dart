import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:flutter/material.dart';

class ScaffoldBackgroungGradientContainer extends StatelessWidget {
  const ScaffoldBackgroungGradientContainer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaHelper.h(context),
      width: MediaHelper.w(context),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.2),
            Colors.transparent,
          ],
        ),
      ),
      child: child,
    );
  }
}
