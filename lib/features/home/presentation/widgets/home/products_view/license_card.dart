import 'package:albus_la_mobile/configs/extensions/extensions.dart';
import 'package:albus_la_mobile/configs/routes/routes.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/license/license.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../pages/home/views/products_view.dart';

class LicenseCard extends StatelessWidget {
  const LicenseCard({super.key, required this.license});

  // TODO:
  final License license;

  static const Color _amber = Color(0xFFFFB303);
  static const Color _orange = Color(0xFFFF7247);

  static final List<Shadow> _textShadow = [
    Shadow(
      color: Colors.black54,
      blurRadius: 2.0.r,
      offset: Offset(3.0.r, 3.0.r),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push(Routes.addUpdateLicensePage, extra: license),
      child: Container(
        width: 250.0.w,
        margin: EdgeInsets.symmetric(horizontal: K.ps),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(K.rm),
          color: colorScheme.secondaryContainer,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.secondary.withValues(alpha: 0.1),
              colorScheme.secondaryContainer,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: (license.isActive ?? false)
                  ? colorScheme.shadow
                  : colorScheme.errorContainer,
              blurRadius: 5.0.r,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              height: 100.0.h,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(360.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.secondary,
                    colorScheme.secondaryContainer,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 30.0.r,
                    blurStyle: BlurStyle.outer,
                    color: colorScheme.primary,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5.0.h,
                      horizontal: 20.0.w,
                    ),
                    child: Image.asset(
                      Assets.images.numTree.path,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 25.0.h),
                    child: Text(
                      '${license.amount}X',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 50.0.sp,
                        color: _amber,
                        shadows: _textShadow,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 30.0.h,
                    child: ListView.builder(
                      // TODO: icons
                      itemCount: QrCodeIcons.icons.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext _, int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                          child: Icon(
                            QrCodeIcons.icons[index].icon,
                            size: 30.0.r,
                            color: index % 2 == 0
                                ? _orange.withValues(alpha: 0.7)
                                : _amber.withValues(alpha: 0.7),
                          ),
                        );
                      },
                    ),
                  ),
                  K.pvsx.verticalSpace,
                  Text(
                    license.name ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  K.pvsx.verticalSpace,
                  Text(
                    '${license.price?.toStringPriceEuro()}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 35.0.sp,
                      color: _orange,
                      shadows: _textShadow,
                    ),
                  ),
                  K.pvm.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
