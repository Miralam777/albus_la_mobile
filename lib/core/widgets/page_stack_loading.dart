import 'dart:ui';

import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/loading_indicator.dart';
import 'package:albus_la_mobile/core/widgets/svg_un_draw_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageStackLoading extends StatelessWidget {
  const PageStackLoading({
    super.key,
    required this.scaffold,
    required this.visible,
    this.undrawPath,
    this.title,
    this.children,
  });

  final Widget scaffold;
  final bool visible;
  final String? undrawPath;
  final String? title;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        scaffold,
        Visibility(
          visible: visible,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                padding: EdgeInsetsGeometry.symmetric(horizontal: K.pm),
                height: MediaHelper.h(context),
                width: MediaHelper.w(context),
                color: Colors.black.withValues(alpha: 0.1),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (undrawPath != null)
                        SvgUnDrawImage(path: undrawPath ?? ''),
                      const LoadingIndicator(),
                      if ((children ?? []).isNotEmpty) ...[
                        K.pvm.verticalSpace,
                        ...(children ?? []),
                      ],
                      K.pvm.verticalSpace,
                      if (title != null)
                        Text(
                          title ?? '',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
