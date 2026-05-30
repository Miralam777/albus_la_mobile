import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/consts.dart';
import 'clipper.dart';

class ConcentricPageView extends StatefulWidget {
  final Function(int index) itemBuilder;
  final Function(int page)? onChange;
  final Function? onFinish;
  final int? itemCount;
  final PageController? pageController;
  final bool pageSnapping;
  final bool reverse;
  final List<Color> colors;
  final ValueNotifier? notifier;
  final double scaleFactor;
  final double opacityFactor;
  final double radius;
  final double verticalPosition;
  final Axis direction;
  final ScrollPhysics? physics;
  final Duration duration;
  final Curve curve;
  final Key? pageViewKey;
  final String firstWidgetTitle;

  /// Useful for adding a next icon to the page view button
  final WidgetBuilder? nextButtonBuilder;

  const ConcentricPageView({
    super.key,
    required this.itemBuilder,
    required this.colors,
    this.pageViewKey,
    this.onChange,
    this.onFinish,
    this.itemCount,
    this.pageController,
    this.pageSnapping = true,
    this.reverse = false,
    this.notifier,
    this.scaleFactor = 0.3,
    this.opacityFactor = 0.0,
    this.radius = 40.0,
    this.verticalPosition = 0.75,
    this.direction = Axis.horizontal,
    this.physics = const ClampingScrollPhysics(),
    this.duration = const Duration(milliseconds: 1500),
    this.curve = Curves.easeInOutSine, // const Cubic(0.7, 0.5, 0.5, 0.1),
    this.nextButtonBuilder,
    required this.firstWidgetTitle,
  }) : assert(colors.length >= 2);

  @override
  State<ConcentricPageView> createState() => _ConcentricPageViewState();
}

class _ConcentricPageViewState extends State<ConcentricPageView> {
  late PageController _pageController;
  double _progress = 0;
  int _prevPage = 0;
  Color? _prevColor;
  Color? _nextColor;

  @override
  void initState() {
    _prevColor = widget.colors[_prevPage];
    _nextColor = widget.colors[_prevPage + 1];
    _pageController = (widget.pageController ?? PageController(initialPage: 0))
      ..addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_onScroll);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // TODO
/*         Assets.images.backgrounds.failureBackground.image(
          height: MediaHelper.getHeight(context),
          width: MediaHelper.getWidth(context),
          fit: BoxFit.cover,
        ), */
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
            ),
          ),
        ),
        _buildClipper(),
        _buildPageView(),
        Positioned(
          top: MediaQuery.of(context).size.height * widget.verticalPosition,
          child: _Button(
            pageController: _pageController,
            widget: widget,
          ),
        ),
      ],
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      key: widget.pageViewKey,
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
        overscroll: false,
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      clipBehavior: Clip.none,
      scrollDirection: widget.direction,
      controller: _pageController,
      reverse: widget.reverse,
      physics: widget.physics,
      itemCount: widget.itemCount,
      pageSnapping: widget.pageSnapping,
      onPageChanged: (int page) {
        if (widget.onChange != null) {
          widget.onChange!(page);
        }
      },
      itemBuilder: (context, index) {
        final child = widget.itemBuilder(index);
        if (index == 0) {
          return SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                child!,
                Text(
                  widget.firstWidgetTitle,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 35.sp, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5.h),
                // TODO: widget
/*                 SizedBox(
                  height: 250.h,
                  width: 600,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 350.0,
                      mainAxisExtent: 85.0,
                      mainAxisSpacing: 20.0,
                    ),
                    itemCount: LocaleLangCodes.localeModels.length,
                    itemBuilder: (context, index) {
                      final settings = BlocEventsHelper.getSettings(context);

                      final localeLangModel =
                          LocaleLangCodes.localeModels[index];
                      final appLocalCode = settings.appLocalCode;

                      final isSelected =
                          LocaleLangCodes.localeModels[index].langCode ==
                              appLocalCode;

                      return _listTile(
                        context: context,
                        leadingImgePath: localeLangModel.flag,
                        title: LocaleLangCodes.getCorrectAppLocaleTranslation(
                            localeLangModel, appLocalCode),
                        subtitle: localeLangModel.langOrginal,
                        onTap: isSelected
                            ? null
                            : () {
                                final languageTranslationsMode =
                                    LanguageTranslations
                                        .getLanguageTranslationsModel(
                                            settings.translationLangCode);

                                final translationLang = LanguageTranslations
                                    .getCorrectLangTranslation(
                                  languageTranslationsMode,
                                  localeLangModel.langCode,
                                );

                                BlocEventsHelper.setSetting(
                                  context,
                                  settings.copyWith(
                                    appLocalCode: localeLangModel.langCode,
                                    appLocalLang: localeLangModel.langOrginal,
                                    appLocalFlag: localeLangModel.flag,
                                    translationLang: translationLang,
                                  ),
                                );
                              },
                      );
                    },
                  ),
                ), */
              ],
            ),
          );
        }
        if (!_pageController.position.hasContentDimensions) {
          return child;
        }
        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            final progress = _pageController.page! - index;
            if (widget.opacityFactor != 0) {
              child = Opacity(
                opacity: (1 - (progress.abs() * widget.opacityFactor))
                    .clamp(0.0, 1.0),
                child: child,
              );
            }
            if (widget.scaleFactor != 0) {
              child = Transform.scale(
                scale:
                    (1 - (progress.abs() * widget.scaleFactor)).clamp(0.0, 1.0),
                child: child,
              );
            }
            return child!;
          },
          child: child,
        );
      },
    );
  }

  Widget _buildClipper() {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (ctx, _) {
        return ColoredBox(
          color: _prevColor!,
          child: ClipPath(
            clipper: ConcentricClipper(
              progress: _progress,
              reverse: widget.reverse,
              radius: widget.radius,
              verticalPosition: widget.verticalPosition,
            ),
            child: ColoredBox(
              color: _nextColor!,
              child: const SizedBox.expand(),
            ),
          ),
        );
      },
    );
  }

  void _onScroll() {
    final direction = _pageController.position.userScrollDirection;
    double page = _pageController.page ?? 0;

    if (direction == ScrollDirection.forward) {
      _prevPage = page.toInt();
      _progress = page - _prevPage;
    } else {
      _prevPage = page.toInt();
      _progress = page - _prevPage;
    }

    final total = widget.colors.length;
    final prevIndex = _prevPage % total;
    int nextIndex = prevIndex + 1;

    if (prevIndex == total - 1) {
      nextIndex = 0;
    }

    _prevColor = widget.colors[prevIndex];
    _nextColor = widget.colors[nextIndex];

    widget.notifier?.value = page - _prevPage;
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key? key,
    required this.pageController,
    required this.widget,
  }) : super(key: key);

  final PageController pageController;
  final ConcentricPageView widget;

  @override
  Widget build(BuildContext context) {
    final size = widget.radius * 2;

    Widget? child = widget.nextButtonBuilder != null
        ? widget.nextButtonBuilder!(context)
        : null;

    child = GestureDetector(
      excludeFromSemantics: true,
      onTap: () {
        final isFinal = pageController.page == widget.colors.length - 1;
        if (isFinal && widget.onFinish != null) {
          widget.onFinish!();
          return;
        }
        pageController.nextPage(
          duration: widget.duration,
          curve: widget.curve,
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 2.0.r,
          ),
        ),
        child: SizedBox.fromSize(
          size: Size.square(size),
          child: child,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        final currentPage = pageController.page?.floor() ?? 0;
        final progress = (pageController.page ?? 0) - currentPage;
        return AnimatedOpacity(
          opacity: progress > 0.01 ? 0.0 : 1.0,
          curve: Curves.ease,
          duration: const Duration(milliseconds: 150),
          child: IconTheme(
            data: IconThemeData(
              color: Theme.of(context).primaryColor,
            ),
            child: child!,
          ),
        );
      },
      child: child,
    );
  }
}

Widget _listTile({
  required BuildContext context,
  required String leadingImgePath,
  required String title,
  required String? subtitle,
  required Function()? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        // TODO:
        // vertical: kDefaultPadding * 0.5,
        // horizontal: kDefaultPadding * 2,
        ),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: onTap == null ? Colors.white30 : Colors.white10,
        borderRadius: BorderRadius.circular(K.rm),
      ),
      child: ListTile(
        selected: onTap == null,
        // TODO: widget
        // leading: LeadingImageWidget(image: leadingImgePath),
        title: Text(
          title,
          maxLines: 2,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.0.sp),
              )
            : null,
        onTap: onTap,
      ),
    ),
  );
}
