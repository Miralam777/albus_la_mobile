import 'dart:ui';

import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/page_main_container.dart';
import 'package:albus_la_mobile/core/widgets/scaffold_background_gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthMainAnimWidget extends StatelessWidget {
  const AuthMainAnimWidget({
    super.key,
    this.forResetPassword = false,
    required this.icon,
    required this.animEnded,
    required this.accIconHeightAndWidth,
    required this.accIconTopPadding,
    this.onEnd,
    required this.children,
  });
  final bool forResetPassword;
  final IconData icon;
  final bool animEnded;
  final double accIconHeightAndWidth;
  final double accIconTopPadding;
  final VoidCallback? onEnd;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ScaffoldBackgroungGradientContainer(
      child: Stack(
        children: [
          Positioned(
            top: K.pvsH + accIconHeightAndWidth * 0.5,
            right: 0.0,
            left: 0.0,
            bottom: 0.0,
            child: PageMainContainerWidget(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: K.pm),
                child: Column(
                  children: [
                    SizedBox(
                      height: forResetPassword
                          ? accIconHeightAndWidth * 0.5
                          : accIconHeightAndWidth,
                    ),
                    ...children,
                    SizedBox(height: MediaHelper.getBottomInsets(context)),
                    SizedBox(height: MediaHelper.viewListBtmPadding),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: animEnded,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Theme.of(
                    context,
                  ).colorScheme.tertiaryContainer.withValues(alpha: 0.5),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            top: accIconTopPadding,
            left: MediaHelper.w(context) * 0.5 - accIconHeightAndWidth * 0.5,
            onEnd: onEnd,
            child: Container(
              height: accIconHeightAndWidth,
              width: accIconHeightAndWidth,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                shape: BoxShape.circle,
                boxShadow: animEnded
                    ? [
                        BoxShadow(
                          blurRadius: 100.r,
                          blurStyle: BlurStyle.outer,
                          color: Theme.of(context).primaryColor,
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    // TODO: icon
                    icon,
                    size: K.ibs,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  Visibility(
                    visible: animEnded,
                    child: SizedBox.square(
                      dimension: accIconHeightAndWidth,
                      child: CircularProgressIndicator(strokeWidth: 5.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
