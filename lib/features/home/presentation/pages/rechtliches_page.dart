import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/scaffold_background_gradient_container.dart';
import 'package:albus_la_mobile/features/home/presentation/widgets/rechtliches/widgets.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _PageCards {
  List<PageCard> cards = [];

  _PageCards() {
    cards = [
      PageCard(
        svgImage: Assets.undraws.security,
        docId: 'datenschutz',
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(K.rl)),
        margin: EdgeInsets.only(left: K.pm),
      ),
      PageCard(svgImage: Assets.undraws.termSheet, docId: 'agb'),
      PageCard(
        svgImage: Assets.undraws.building,
        docId: 'impressum',
        borderRadius: const BorderRadius.only(topRight: Radius.circular(K.rl)),
        margin: EdgeInsets.only(right: K.pm),
      ),
    ];
  }
}

class RechtlichesPage extends StatefulWidget {
  const RechtlichesPage({super.key});

  @override
  State<RechtlichesPage> createState() => _RechtlichesPageState();
}

class _RechtlichesPageState extends State<RechtlichesPage> {
  late CarouselSliderController _carouselController;
  int _selectedSlidingSegmentIndex = 0;

  @override
  void initState() {
    _carouselController = CarouselSliderController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: PrimaryAppBar2(
          title: '',
          titleWidget: CupertinoSlidingSegmentedControl<int>(
            backgroundColor: colorScheme.tertiaryContainer,
            thumbColor: colorScheme.secondary,
            groupValue: _selectedSlidingSegmentIndex,
            onValueChanged: (value) {
              if (value != null) {
                _selectedSlidingSegmentIndex = value;
                _carouselController.animateToPage(_selectedSlidingSegmentIndex);
                setState(() {});
              }
            },
            children: <int, Widget>{
              0: _slidingSegmentWidget(
                index: 0,
                // TODO: text
                title: 'Datenschutz',
              ),
              1: _slidingSegmentWidget(
                index: 1,
                // TODO: text
                title: 'AGB',
              ),
              2: _slidingSegmentWidget(
                index: 2,
                // TODO: text
                title: 'Impressum',
              ),
            },
          ),
          actions: [
            CircleAvatar(
              backgroundColor: colorScheme.tertiaryContainer,
              child: Icon(
                I.paragraph,
                color: colorScheme.secondary,
                size: kToolbarHeight * 0.5,
              ),
            ),
            SizedBox(width: K.pm),
          ],
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
              CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: double.infinity,
                  viewportFraction: 1,
                  enlargeFactor: 0.0,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  onPageChanged: (int index, CarouselPageChangedReason cpcr) {
                    _selectedSlidingSegmentIndex = index;
                    setState(() {});
                  },
                ),
                items: _PageCards().cards.map((Widget item) => item).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _slidingSegmentWidget({required int index, required String title}) {
    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Text(
        title,
        // TODO: text style
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: _selectedSlidingSegmentIndex == index ? Colors.white : null,
          fontSize: 10.0.sp,
        ),
      ),
    );
  }
}
