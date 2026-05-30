import 'package:albus_la_mobile/configs/extensions/extensions.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/utils/helpers/helpers.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/orders/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderInfosWidget extends StatelessWidget {
  const OrderInfosWidget({super.key, required this.orders});

  final Orders? orders;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: K.pm),
      child: Column(
        children: [
          K.pvl.verticalSpace,
          _buildInfoCard(
            context: context,
            // TODO: text
            title: 'Bestellinformationen: ',
            children: [
              _titleAndText(
                context: context,
                // TODO: text
                title: 'Bestellnummer: ',
                text: orders?.orderId.toString(),
              ),
              Divider(height: K.pvsH),
              _titleAndText(
                context: context,
                // TODO: text
                title: 'Datum: ',
                text: Helpers.getTimeAndHourFromTimestamp(orders?.created),
              ),
              Divider(height: K.pvsH),
              _titleAndText(
                context: context,
                // TODO: text
                title: 'Gesamtpreis: ',
                text: orders?.orderDetails?.totalPrice?.toStringPriceEuro(),
              ),
              Divider(height: K.pvsH),
              _titleAndText(
                context: context,
                // TODO: text
                title: 'Zahlungsart: ',
                text: orders?.paymentMethod?.method,
              ),
              Divider(height: K.pvsH),
              _titleAndText(
                context: context,
                // TODO: text
                title: 'Zahlungs-ID: ',
                text: orders?.payParms?['data']['id'],
              ),
            ],
          ),
          K.pvl.verticalSpace,
          _buildInfoCard(
            context: context,
            // TODO: text
            title: 'Lieferadresse: ',
            children: [
              Text(
                '${_genderToText(orders?.customer?.title)} ${orders?.customer?.firstName} ${orders?.customer?.lastName}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              3.0.verticalSpace,
              Text(
                '${orders?.shippingAddress?.street} ${orders?.shippingAddress?.houseNr}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${orders?.shippingAddress?.postalCode} ${orders?.shippingAddress?.city}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Visibility(
                visible: (orders?.shippingAddress?.additional ?? '').isNotEmpty,
                child: Text(
                  orders?.shippingAddress?.additional ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                '${orders?.shippingAddress?.country}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),

          /*           
          K.pvl.verticalSpace,
_buildInfoCard(
            context: context,
            // TODO: text
            title: 'Rechnungsadresse:',
            children: [
              Visibility(
                visible: (orders?.billingAddress?.company ?? '').isNotEmpty,
                child: Text(
                  '${orders?.billingAddress?.company}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                '${_genderToText(orders?.customer?.title)} ${orders?.customer?.firstName} ${orders?.customer?.lastName}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              3.0.verticalSpace,
              Text(
                '${orders?.billingAddress?.street} ${orders?.billingAddress?.houseNr}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Visibility(
                visible: (orders?.billingAddress?.additional ?? '').isNotEmpty,
                child: Text(
                  orders?.billingAddress?.additional ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                '${orders?.billingAddress?.postalCode} ${orders?.billingAddress?.city}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${orders?.billingAddress?.country}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ), */
        ],
      ),
    );
  }

  Column _buildInfoCard({
    required BuildContext context,
    String? title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(title, style: Theme.of(context).textTheme.titleLarge),
        K.pvs.verticalSpace,
        SizedBox(
          width: double.infinity,
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: K.pvsH, horizontal: K.ps),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [...children],
              ),
            ),
          ),
        ),
      ],
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
          flex: 2,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            text ?? '',
            textAlign: TextAlign.right,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  String _genderToText(String? gender) {
    if (gender == 'male') {
      // TODO: text
      return 'Herrn';
    } else if (gender == 'female') {
      // TODO: text
      return 'Frau';
    } else {
      // TODO: text
      return 'Unknow';
    }
  }
}
