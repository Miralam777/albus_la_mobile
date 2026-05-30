import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/widgets/firebase_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarHero extends StatelessWidget {
  const AvatarHero({
    super.key,
    required this.heroTag,
    required this.height,
    required this.avatar,
    this.redShadow = false,
  });

  final String heroTag;
  final String? avatar;
  final double height;
  final bool redShadow;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Hero(
      tag: heroTag,
      child: Container(
        height: height,
        width: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Color.lerp(
            colorScheme.tertiaryContainer,
            colorScheme.primary,
            0.5,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: 10.0.r,
              color: redShadow
                  ? colorScheme.errorContainer
                  : colorScheme.shadow,
            ),
          ],
        ),
        child: FirebaseImageWidget(
          image: avatar,
          showLoadingIndicator: false,
          fit: BoxFit.cover,
          errorWidget: Icon(I.person, size: K.ibs),
        ),
      ),
    );
  }
}
