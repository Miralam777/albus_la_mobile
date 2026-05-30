import 'package:albus_la_mobile/configs/routes/routes.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/global/user_provider.dart';
import 'package:albus_la_mobile/core/utils/helpers/bloc_events_helper.dart';
import 'package:albus_la_mobile/core/utils/helpers/helpers.dart';
import 'package:albus_la_mobile/core/utils/helpers/platform_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/toast_utils.dart';
import 'package:albus_la_mobile/core/widgets/firebase_image_widget.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/orders/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.orders,
    this.isFromDonePage = false,
  });
  final bool isFromDonePage;
  final Orders orders;

  // TODO: clean
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isIos = PlatformHelper.isIos();
    final inWork = orders.inWork ?? false;

    final admin = Provider.of<UserProvider>(
      context,
      listen: false,
    ).getAdminByUId(orders.doneUId);

    return GestureDetector(
      onTap: () {
        final userId = BlocEventsHelper.getUser(context)?.uId ?? '';
        if (!(orders.inWork ?? false) || userId == orders.doneUId) {
          context.push(
            Routes.ordersDetailsPage,
            extra: {'isFromDonePage': isFromDonePage, 'orders': orders},
          );
        } else {
          // TODO: text
          ToastUtils.error('Diese Bestellung is in Vorbereitung.');
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: K.pvsH,
          horizontal: isIos ? K.pm : 0.0,
        ),
        padding: EdgeInsets.symmetric(vertical: K.pvmH),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: isIos ? BorderRadius.circular(K.rm) : null,
          color: Color.lerp(
            colorScheme.tertiaryContainer,
            Colors.orange,
            inWork ? 0.15 : 0,
          ),
          boxShadow: [BoxShadow(color: colorScheme.shadow, blurRadius: 7.0.r)],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 125.0.h,
              child: (orders.orderDetails?.products ?? []).isEmpty
                  ? Text(
                      // TODO: text
                      'Keine Produktdaten',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                        horizontal: isIos ? K.ps : K.pm,
                      ),
                      itemCount: orders.orderDetails?.products?.length,
                      itemBuilder: (context, index) {
                        final product = orders.orderDetails?.products?[index];
                        return Column(
                          children: [
                            Container(
                              height: 90.0.h,
                              width: 90.0.h,
                              margin: EdgeInsets.symmetric(
                                horizontal: K.ps * 0.5,
                              ),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(K.rs),
                                color: colorScheme.secondaryContainer,
                              ),
                              child: FirebaseImageWidget(
                                image: product?.thumbnail,
                                showLoadingIndicator: false,
                                fit: BoxFit.cover,
                              ),
                            ),
                            K.pvsx.verticalSpace,
                            Text(
                              '${product?.amount.toString()} X',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        );
                      },
                    ),
            ),
            K.pvs.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isIos ? K.ps : K.pm),
              child: Column(
                children: [
                  Divider(height: K.pvsH),
                  _titleAndText(
                    context: context,
                    // TODO: text
                    title: 'Bestellnummer: ',
                    // TODO: orderNr
                    text: '${orders.orderId}',
                  ),
                  Divider(height: K.pvsH),
                  _titleAndText(
                    context: context,
                    // TODO: text
                    title: 'Bestelldatum: ',
                    text: Helpers.getTimeAndHourFromTimestamp(orders.created),
                  ),
                  Divider(height: K.pvsH),
                ],
              ),
            ),
            if (inWork)
              Column(
                children: [
                  K.pvm.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: colorScheme.secondaryContainer,
                        maxRadius: 20.0.r,
                        child: Icon(I.person),
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        '${admin?.firstname} ${admin?.surname}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Row _titleAndText({
    required BuildContext context,
    required String title,
    required String? text,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            text ?? '',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
