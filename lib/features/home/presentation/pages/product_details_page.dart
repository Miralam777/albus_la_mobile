import 'dart:ui';

import 'package:albus_la_mobile/configs/extensions/extensions.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/firebase_image_widget.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/product/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.product});
  final Product? product;

  static final _horizontalPaddingPm = EdgeInsets.symmetric(horizontal: K.pm);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // TODO: text
      appBar: const PrimaryAppBar(title: 'Produkt'),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaHelper.statusAndAppBarH(context) + K.pvmH,
          bottom: MediaHelper.androidBtmNavBarH(context) + K.pvl2xH,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ! ************************* thumbnail
            Padding(
              padding: _horizontalPaddingPm,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(K.rm),
                    border: Border.all(color: colorScheme.outline, width: K.bm),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(K.rm),
                    child: Stack(
                      children: [
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: FirebaseImageWidget(
                              image: product?.thumbnail,
                              fit: BoxFit.cover,
                              showLoadingIndicator: false,
                              errorWidget: const SizedBox.shrink(),
                            ),
                          ),
                        ),
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: MediaHelper.isBrightnessDark(context)
                              ? Colors.black.withValues(alpha: 0.6)
                              : Colors.white.withValues(alpha: 0.6),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: K.pvl,
                              horizontal: K.pl,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(K.rs),
                              child: FirebaseImageWidget(
                                image: product?.thumbnail,
                                fit: BoxFit.contain,
                                showLoadingIndicator: false,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            K.pvm.verticalSpace,

            // ! ************************* product images
            SizedBox(
              height: 90.0.h,
              child: product != null
                  ? Center(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: _horizontalPaddingPm,
                        itemCount: (product?.images ?? []).length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 90.0.h,
                            width: 90.0.h,
                            margin: EdgeInsets.symmetric(
                              horizontal: K.pm * 0.4,
                            ),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(K.rm),
                              color: colorScheme.secondaryContainer,
                            ),
                            child: FirebaseImageWidget(
                              image: product?.images?[index],
                              showLoadingIndicator: false,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    )
                  : Align(
                      child: Text(
                        // TODO: text
                        'Keine Bilder',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
            ),
            K.pvm.verticalSpace,

            // ! ************************* info text
            _buildTitleAndText(
              context: context,
              // TODO: text
              title: 'Status: ',
              text: (product?.isActive ?? false) ? 'Aktiv' : 'Dektiv',
            ),
            _buildTitleAndText(
              context: context,
              // TODO: text
              title: 'Produktnummer: ',
              text: product?.productId.toString(),
            ),
            _buildTitleAndText(
              context: context,
              // TODO: text
              title: 'Produktname: ',
              text: product?.name,
            ),
            _buildTitleAndText(
              context: context,
              // TODO: text
              title: 'Produktbeschreibung: ',
              text: product?.description,
            ),
            _buildTitleAndText(
              context: context,
              // TODO: text
              title: 'Bezeichnungsname: ',
              text: product?.labelName,
            ),
            _buildTitleAndText(
              context: context,
              // TODO: text
              title: 'Preis: ',
              text: product?.price.toStringPriceComa(),
            ),
            _buildTitleAndText(
              context: context,
              // TODO: text
              title: 'Mehrwertsteuersatz: ',
              text: product?.avt.toString(),
            ),
            _buildTitleAndText(
              context: context,
              // TODO: text
              title: 'Währung: ',
              text: product?.currency,
            ),
            _buildTitleAndText(
              context: context,
              // TODO: text
              title: 'Lagerbestand: ',
              text: product?.stock.toString(),
            ),
            _buildTitleAndText(
              context: context,
              // TODO: text
              title: 'Kategorien: ',
              text: product?.category,
            ),
            _buildTitleAndText(
              context: context,
              // TODO: text
              title: 'Produktfarbe: ',
              text: product?.attributes?.color,
            ),
            _buildTitleAndText(
              context: context,
              // TODO: text
              title: 'Größe: ',
              text: product?.attributes?.size,
            ),
            _buildTitleAndText(
              context: context,
              // TODO: text
              title: 'Maße: ',
              text: product?.attributes?.dimensions,
            ),
            _buildTitleAndText(
              context: context,
              // TODO: text
              title: 'Gewicht: ',
              text: product?.attributes?.weight,
            ),
            _buildTitleAndText(
              context: context,
              // TODO: text
              title: 'Lieferanten: ',
              text: product?.supplier?.name,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndText({
    required BuildContext context,
    required String title,
    required String? text,
    bool isLast = false,
  }) {
    return Padding(
      padding: _horizontalPaddingPm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: K.pvmH),
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
              Text(
                text ?? '',
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          if (isLast) Divider(height: K.pvmH),
        ],
      ),
    );
  }
}
