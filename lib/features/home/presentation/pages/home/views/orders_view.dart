import 'package:albus_la_mobile/configs/routes/routes.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/empty_list_widget.dart';
import 'package:albus_la_mobile/core/widgets/printer_status_icon.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/order_provider.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/shipping_label_printer_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../widgets/home/orders_view/widgets.dart';

// TODO: make it state less
class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context).getOrders;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PrimaryAppBar(
        // TODO: text
        title: 'Bestellungen',
        leading: Consumer<ShippingLabelPrinterProvider>(
          builder: (_, provider, __) {
            return PrinterStatusIcon(isConnected: provider.isConnected);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(I.cubeBox),
            onPressed: () => context.push(Routes.doneOrdersPage),
          ),
        ],
      ),
      body: orders.isEmpty
          ? const EmptyListWidget()
          : ListView.builder(
              padding: EdgeInsets.only(
                top: MediaHelper.statusAndAppBarH(context) + K.pvmH,
                bottom: MediaHelper.androidBtmNavBarH(context) + K.pvl2xH,
              ),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return OrderCard(orders: orders[index]);
              },
            ),
    );
  }
}
