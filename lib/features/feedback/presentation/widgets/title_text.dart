import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key, required this.text, this.toPadding = 25.0});
  final String text;
  final double toPadding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      // TODO: left padding
      padding: EdgeInsets.only(left: 10, top: toPadding.h),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
