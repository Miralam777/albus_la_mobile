import 'package:albus_la_mobile/configs/extensions/extensions.dart';
import 'package:albus_la_mobile/configs/routes/routes.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/platform_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/dialogs_utils.dart';
import 'package:albus_la_mobile/core/widgets/barcode_widget.dart';
import 'package:albus_la_mobile/core/widgets/firebase_image_widget.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/product/product.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isNotAvailable = (product.stock ?? 0) == 0;
    final isActive = product.isActive ?? false;
    final isIos = PlatformHelper.isIos();
    // final isIos = true;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: K.pvsH),
      child: _buildSlide(
        context: context,
        // TODO: isSlideActive
        // isSlideActive: false,
        isIos: isIos,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: isIos ? K.pm : 0.0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: isIos ? BorderRadius.circular(K.rm) : null,
            boxShadow: [
              BoxShadow(color: colorScheme.shadow, blurRadius: 7.0.r),
            ],
          ),
          child: Material(
            color: Color.lerp(
              colorScheme.tertiaryContainer,
              !isActive
                  ? Colors.red
                  : isNotAvailable
                  ? Colors.orange
                  : null,
              (!isActive || isNotAvailable) ? 0.15 : 0,
            ),
            borderRadius: isIos ? BorderRadius.circular(K.rm) : null,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () =>
                  context.push(Routes.productDetailsPage, extra: product),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isIos ? K.ps : K.pm,
                  vertical: K.pvmH,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isActive)
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          // TODO: text
                          'Deaktiviert',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: colorScheme.error),
                        ),
                      ),
                    if (isNotAvailable)
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          // TODO: text
                          'Nicht verfügbar',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: colorScheme.error),
                        ),
                      ),
                    if (isNotAvailable) K.pvs.verticalSpace,
                    Row(
                      children: [
                        Container(
                          height: 90.0.h,
                          width: 90.0.h,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(K.rm),
                            color: colorScheme.secondaryContainer,
                          ),
                          child: FirebaseImageWidget(
                            image: product.thumbnail,
                            showLoadingIndicator: false,
                            fit: BoxFit.cover,
                          ),
                        ),
                        K.ps.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.name ?? '',
                                // 'dhf sdhf sjhdfj sdhg skajdhg sdh jsdkahf kjsadfhs  hdjsh sdhsdjfhsdhsdfjksd dhf sdhf sjhdfj sdhg skajdhg sdh jsdkahf kjsadfhs  hdjsh sdhsdjfhsdhsdfjksd',
                                maxLines: 3,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              K.pvs.verticalSpace,
                              Text(
                                '${product.price?.toStringPriceEuro()}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    K.pvm.verticalSpace,
                    // K.pvs.verticalSpace,
                    /*          Text(
                      '${product.price?.toStringPriceEuro()}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ), */
                    _titleAndText(
                      context: context,
                      // TODO: text
                      title: 'Lagerbestand: ',
                      text: '${product.stock}',
                    ),
                    _titleAndText(
                      context: context,
                      // TODO: text
                      title: 'Produktnummer: ',
                      text: '${product.productId}',
                    ),
                    // TODO: uncomment
                    K.pvs.verticalSpace,
                    BarcodeWidget(
                      barcodeData: product.productId.toString(),
                      width: 200.0,
                      height: 70.0,
                      // barcodeColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(K.pl, K.pm, K.pl, K.ps),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlide({
    required BuildContext context,
    required Widget child,
    bool isSlideActive = true,
    required bool isIos,
  }) {
    return isSlideActive
        ? Slidable(
            key: const ValueKey(0),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              // dismissible: DismissiblePane(onDismissed: () {}),
              children: [
                SlidableAction(
                  // TODO: text
                  label: 'Löschen',
                  icon: I.delete,
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  foregroundColor: Theme.of(context).iconTheme.color,
                  borderRadius: isIos
                      ? const BorderRadius.only(
                          bottomRight: Radius.circular(K.rm),
                          topRight: Radius.circular(K.rm),
                        )
                      : BorderRadius.zero,
                  onPressed: (_) async {
                    await DialogsUtils.showOkCancelDialog(
                      context: context,
                      // TODO: text
                      title: 'Löschen?',
                      showLoadingIndacator: true,
                      onOk: () async {
                        await Provider.of<ProductProvider>(
                          context,
                          listen: false,
                        ).delete(product);
                        if (context.mounted) context.pop();
                      },
                    );
                  },
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  // TODO: text
                  label: 'Bearbeiten',
                  icon: I.edit,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.5),
                  foregroundColor: Theme.of(context).iconTheme.color,
                  borderRadius: isIos
                      ? const BorderRadius.only(
                          bottomLeft: Radius.circular(K.rm),
                          topLeft: Radius.circular(K.rm),
                        )
                      : BorderRadius.zero,
                  onPressed: (_) =>
                      context.push(Routes.addUpdateProductPage, extra: product),
                ),
              ],
            ),
            child: child,
          )
        : child;
  }

  Row _titleAndText({
    required BuildContext context,
    required String title,
    required String? text,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        Expanded(
          child: Text(text ?? '', style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
