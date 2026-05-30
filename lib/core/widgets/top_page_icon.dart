import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopPageIconWidget extends StatelessWidget {
  const TopPageIconWidget({super.key, required this.icon});
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0.h,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 25.0.h),
          padding: EdgeInsets.all(20.0.r),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -4.r),
                blurRadius: 4.0.r,
                blurStyle: BlurStyle.normal,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
          child: icon,
        ),
      ),
    );
  }
}
