import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/page_main_container.dart';
import 'package:albus_la_mobile/core/widgets/scaffold_background_gradient_container.dart';
import 'package:albus_la_mobile/core/widgets/svg_un_draw_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScaffoldWidget extends StatelessWidget {
  const MainScaffoldWidget({
    super.key,
    this.isForBuyLimit = false,
    this.rechtlichesTitleWidge,
    this.appBarTitle = '',
    required this.svgImage,
    this.svgImageHeight,
    required this.childern,
    this.appBarTrailingIcon,
  });

  final bool isForBuyLimit;
  final Widget? rechtlichesTitleWidge;
  final String svgImage;
  final double? svgImageHeight;
  final String appBarTitle;
  final List<Widget> childern;
  final IconData? appBarTrailingIcon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PrimaryAppBar2(
        title: appBarTitle,
        titleWidget: rechtlichesTitleWidge,
        actions: appBarTrailingIcon != null
            ? [
                CircleAvatar(
                  backgroundColor: colorScheme.tertiaryContainer,
                  child: Icon(
                    appBarTrailingIcon,
                    color: colorScheme.secondary,
                    size: kToolbarHeight / 2,
                  ),
                ),
                SizedBox(width: K.pm),
              ]
            : null,
      ),
      body: ScaffoldBackgroungGradientContainer(
        child: Stack(
          children: [
            Container(
              height: 200.0.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [colorScheme.primary, Colors.transparent],
                ),
              ),
            ),
            PageMainContainerWidget(
              child: ListView(
                padding: isForBuyLimit
                    ? EdgeInsets.only(top: K.pm)
                    : EdgeInsets.symmetric(horizontal: K.pm),
                children: [
                  SvgUnDrawImage(
                    path: svgImage,
                    height: svgImageHeight ?? 250.0.h,
                  ),
                  ...childern,
                  SizedBox(
                    height: MediaHelper.getBottomInsets(context) + 45.0.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
