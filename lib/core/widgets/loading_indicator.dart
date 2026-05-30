import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    // this.dimension,
    this.color,
    // TODO: ckeck everywhere
    // this.withBackgound = true,
    this.withBackgound = false,
  });

  /// by default is **'90.0.h'**
  // final double? dimension;
  final Color? color;
  final bool withBackgound;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // height: dimension ?? 90.0.h,
        // width: dimension ?? 90.0.h,
        height: 90.0.h,
        width: 90.0.h,
        decoration: BoxDecoration(
          color: withBackgound
              ? Theme.of(context)
                  .colorScheme
                  .tertiaryContainer
                  .withValues(alpha: 0.5)
              : null,
          shape: BoxShape.circle,
        ),
        child: SpinKitSpinningLines(
          color: color ?? Theme.of(context).colorScheme.secondary,
          itemCount: 7,
          lineWidth: 4.0.r,
        ),
      ),
    );
  }
}
