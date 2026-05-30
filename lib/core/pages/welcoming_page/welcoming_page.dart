// TODO:
/* import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'page_view.dart';

// TODO: icons
List<PageData> _pages = [
  PageData(
    icon: Icons.language,
    lBgc: const Color(0xffD7D7D7).withValue(alpha:0.5),
    dBgc: const Color(0xff111010),
  ),
  PageData(
    icon: Icons.menu_book,
    image: Assets.images.welcomingPage.scannQrCode.path,
    lBgc: const Color(0xffFFFFFF),
    // dBgc: Color.fromARGB(255, 38, 36, 36),
    dBgc: Colors.red,
  ),
  PageData(
    icon: Icons.headphones,
    image: Assets.images.welcomingPage.chat.path,
    lBgc: const Color(0xffEBEBEB),
    dBgc: Color.fromARGB(255, 49, 47, 47),
  ),
  PageData(
    icon: Icons.search,
    image: Assets.images.welcomingPage.manageQrCode.path,
    lBgc: const Color(0xffF5F5F5),
    dBgc: Color.fromARGB(255, 58, 55, 55),
  ),
  PageData(
    icon: Icons.list_alt,
    image: Assets.images.welcomingPage.products.path,
    lBgc: const Color(0xffFFFFFF),
    dBgc: Color.fromARGB(255, 68, 64, 64),
  ),
];

class WelcomingPage extends StatelessWidget {
  const WelcomingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: text
    /* final localList =
        S.of(context).welcomingPagePageViewListT.split(',').toList(); */
    final localList = ['de', 'en', 'sp', 'sp', 'sp'];
    List<PageData> pages = [];
    for (int i = 0; i < localList.length; i++) {
      pages.add(_pages[i].copyWith(title: localList[i]));
    }
    _pages = pages;
    final screenWidth = 350.0.w;

    final isBrightnessDark = MediaHelper.isBrightnessDark(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: ConcentricPageView(
          firstWidgetTitle: _pages[0].title ?? '',
          // colors:_pages.map((p) => isBrightnessDark ? p.dBgc : p.lBgc).toList(),
          colors: _pages.map((p) => p.dBgc).toList(),
          itemCount: _pages.length,
          radius: screenWidth * 0.1,
          // radius: 70.0.r,
          // curve: Curves.ease,
          nextButtonBuilder: (context) => Padding(
            padding: const EdgeInsets.only(left: 3), // visual center
            child: Icon(
              I.arrowForwardIos,
              size: screenWidth * 0.08,
            ),
          ),
          onFinish: () {
            // TODO:
/*             final settings = BlocEventsHelper.getSettings(context);
            BlocEventsHelper.setSetting(
                context, settings.copyWith(isWelcompageSeen: true)); */
            // context.go(Routes.homePage);
            context.pop();
          },
          itemBuilder: (index) {
            final page = _pages[index % _pages.length];
            return SafeArea(
              child: _Page(page: page, isFirstPage: index == 0),
            );
          },
        ),
      ),
    );
  }
}

class PageData {
  final String? title;
  final IconData? icon;
  final String? image;
  final Color lBgc;
  final Color dBgc;

  const PageData({
    this.title,
    this.icon,
    this.image,
    this.lBgc = Colors.white,
    this.dBgc = const Color(0xff111010),
  });

  PageData copyWith({
    String? title,
    int? index,
    IconData? icon,
    String? image,
    Color? bgColor,
  }) {
    return PageData(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      lBgc: bgColor ?? this.lBgc,
    );
  }
}

class _Page extends StatelessWidget {
  final PageData page;
  final bool isFirstPage;

  const _Page({Key? key, required this.page, required this.isFirstPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    space(double p) => SizedBox(height: screenHeight * p / 100);
    return Column(
      children: [
        space(10),
        _Image(page: page),
        space(isFirstPage ? 2 : 8),
        Visibility(
          visible: !isFirstPage,
          child: _Text(
            title: page.title!,
          ),
        ),
      ],
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({Key? key, required this.title}) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? '',
      style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(fontSize: 35.sp, color: Colors.black),
      textAlign: TextAlign.center,
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({Key? key, required this.page}) : super(key: key);

  final PageData page;

  @override
  Widget build(BuildContext context) {
    // TODO: old
/*     return Container(
      width: 150.w,
      height: 150.w,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        color: Theme.of(context).primaryColor,
      ),
      child: FittedBox(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: -10.0,
              left: -10.0,
              child: Icon(
                page.icon,
                size: 150.r,
                color: Colors.white30,
              ),
            ),
            Icon(
              page.icon,
              size: 150.r,
              color: Colors.white,
            ),
          ],
        ),
      ),
    ); */
    return Container(
      width: 250.w,
      height: 250.w,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(K.rl)),
        color: Theme.of(context).primaryColor,
      ),
      child: Image.asset(
        page.image ?? '',
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}
 */
