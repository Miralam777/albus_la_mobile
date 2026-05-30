import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/empty_list_widget.dart';
import 'package:albus_la_mobile/core/widgets/loading_indicator.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/orders/orders.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/order_provider.dart';
import 'package:albus_la_mobile/features/home/presentation/widgets/home/orders_view/order_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoneOrdersPage extends StatefulWidget {
  const DoneOrdersPage({super.key});

  @override
  State<DoneOrdersPage> createState() => _DoneOrdersPageState();
}

class _DoneOrdersPageState extends State<DoneOrdersPage> {
  List<Orders> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _orders = await Provider.of<OrderProvider>(
        context,
        listen: false,
      ).getLast100DoneOrders();
      _isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // TODO: text
      appBar: const PrimaryAppBar(title: 'Gelieferte Bestellungen'),
      body: _isLoading
          ? const LoadingIndicator()
          : _orders.isEmpty
          ? const EmptyListWidget()
          : ListView.builder(
              padding: EdgeInsets.only(
                top: MediaHelper.statusAndAppBarH(context) + K.pvmH,
                bottom: MediaHelper.androidBtmNavBarH(context) + K.pvl2xH,
              ),
              itemCount: _orders.length,
              itemBuilder: (context, index) =>
                  OrderCard(isFromDonePage: true, orders: _orders[index]),
            ),
    );
  }
}
