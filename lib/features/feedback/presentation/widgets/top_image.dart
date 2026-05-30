import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/widgets/svg_un_draw_image.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopImageWidget extends StatelessWidget {
  const TopImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      height: 200.h,
      margin: EdgeInsets.symmetric(vertical: 15.0.w),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(K.rl),
      ),
      child: SvgUnDrawImage(path: Assets.undraws.thingsToSay),
    );
  }
}
