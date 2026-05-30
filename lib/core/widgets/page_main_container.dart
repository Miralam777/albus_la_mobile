import 'package:albus_la_mobile/constants/consts.dart';
import 'package:flutter/material.dart';

class PageMainContainerWidget extends StatelessWidget {
  const PageMainContainerWidget({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(horizontal: K.pm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(K.rl)),
      ),
      child: child,
    );
  }
}
