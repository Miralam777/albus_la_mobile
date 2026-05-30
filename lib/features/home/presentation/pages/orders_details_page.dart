import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:albus_la_mobile/configs/network/network_info.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/bloc_events_helper.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/dialogs_utils.dart';
import 'package:albus_la_mobile/core/utils/utility/toast_utils.dart';
import 'package:albus_la_mobile/core/widgets/firebase_image_widget.dart';
import 'package:albus_la_mobile/core/widgets/loading_indicator.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/printer_status_icon.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/orders/orders.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/product/product.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/order_provider.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/shipping_label_printer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../widgets/order_details_page/weidget.dart';

// TODO: clean

class OrdersDetailsPage extends StatefulWidget {
  const OrdersDetailsPage({
    super.key,
    required this.isFromDonePage,
    required this.orders,
  });
  final bool isFromDonePage;
  final Orders? orders;

  @override
  State<OrdersDetailsPage> createState() => _OrdersDetailsPageState();
}

class _OrdersDetailsPageState extends State<OrdersDetailsPage> {
  bool get _isFromDonePage => widget.isFromDonePage;
  Orders? get _orders => widget.orders;

  List<_PrepareProduct> _prepareProducts = [];

  @override
  void initState() {
    for (var product in (_orders?.orderDetails?.products ?? <Product>[])) {
      _prepareProducts.add(
        _PrepareProduct(productId: product.productId, orderAddQrcodeModels: []),
      );
    }
    print('_prepareProduct.length');
    print(_prepareProducts.length);

    final userId = BlocEventsHelper.getUser(context)?.uId ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('_isFromDonePage: $_isFromDonePage');
      if (_isFromDonePage) return;

      if (!await NetworkInfo().isConnected) {
        if (!mounted) return;
        context.pop();
        // TODO: text
        ToastUtils.error('Keine Internetverbindung.');
      }

      if (!mounted) return;
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final dId = _orders?.dId ?? '';

      // print('dId: $dId');
      // print('=========> await orderProvider.isInWork(dId: dId)');
      // print(await orderProvider.isInWork(dId: dId));

      // await Future.delayed(const Duration(seconds: 2));

      if (await orderProvider.isInWork(dId: dId)) {
        // print('========> in if ');
        // print('userId: $userId');
        // print('_orders?.doneUId: ${_orders?.doneUId}');
        // print(userId == _orders?.doneUId);
        if (userId == _orders?.doneUId) return;
        if (!mounted) return;
        context.pop();
        // TODO: text
        ToastUtils.error('Diese Bestellung is in Vorbereitung.');
      } else {
        if (!mounted) return;
        await orderProvider.setInWork(dId: dId, doneUId: userId, inWork: true);
      }
    });

    // ! **************
    /* 
    FirebaseFirestore.instance
            .collection('orders')
            .doc(dId)
            .get();
     */
    FirebaseFirestore.instance
        .collection('orders')
        .doc(_orders?.dId)
        .snapshots()
        .listen((snapshot) {
          print('==========> e');
          print(e);
          final doneUId = snapshot.data()?['doneUId'];
          print('doneUId');
          print(doneUId);
          print('doneUId != null');
          print(doneUId != null);
          if (doneUId != null) {
            print('doneUId != userId');
            print(doneUId != userId);
            if (doneUId != userId) {
              context.pop();
            }
          }
        });
    // ! **************

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PrimaryAppBar(
        // TODO: text
        title: 'Bestellung vorbereiten',
        actions: _isFromDonePage
            ? null
            : [
                IconButton(
                  icon: Icon(I.cancelOutlined, color: Colors.red),
                  onPressed: () async {
                    await DialogsUtils.showOkCancelDialog(
                      context: context,
                      // TODO: text
                      title: 'Bestellung später erledigen?',
                      onOk: () async {
                        if (!await NetworkInfo().isConnected) {
                          // TODO: text
                          ToastUtils.error('Keine Internetverbindung.');
                          return;
                        }
                        if (!context.mounted) return;
                        final isdone =
                            await Provider.of<OrderProvider>(
                              context,
                              listen: false,
                            ).setInWork(
                              dId: _orders?.dId ?? '',
                              doneUId: null,
                              inWork: false,
                            );
                        if (isdone) {
                          if (!context.mounted) return;
                          context.pop();
                          if (!context.mounted) return;
                          context.pop();
                        }
                      },
                    );
                  },
                ),
              ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaHelper.statusAndAppBarH(context) + K.pvmH,
          bottom: MediaHelper.androidBtmNavBarH(context) + K.pvl2xH,
        ),
        child: Column(
          children: [
            // TODO: remove
            Text('_orders?.doneUId.toString()'),
            Text(_orders?.doneUId ?? 'null'),
            //! ****************** prudocts list
            SizedBox(
              height: 280.0.h,
              child: (_orders?.orderDetails?.products ?? []).isEmpty
                  ? Text(
                      // TODO: text
                      'Error keine Produktdaten',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                        vertical: K.pvmH,
                        horizontal: K.pm,
                      ),
                      itemCount: _orders?.orderDetails?.products?.length,
                      itemBuilder: (context, index) {
                        final product = _orders?.orderDetails?.products?[index];
                        final isAllQrcodeAdded = _checkAllQrcodesAdded(
                          productId: product?.productId,
                          amount: product?.amount,
                        );
                        print('=====> isAllQrcodeAdded: $isAllQrcodeAdded');

                        return Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaHelper.w(context) * 0.8,
                          ),
                          margin: EdgeInsets.symmetric(horizontal: K.ps * 0.5),
                          // padding: EdgeInsets.symmetric(horizontal: K.ps),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(K.rm),
                            /* color: isAllQrcodeAdded
                                ? Colors.green
                                : Theme.of(context).cardColor, */
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.shadow,
                                blurRadius: 7.0.r,
                              ),
                            ],
                          ),
                          child: Material(
                            color: isAllQrcodeAdded
                                ? Colors.green
                                : Theme.of(context).cardColor,
                            child: InkWell(
                              onTap: isAllQrcodeAdded
                                  ? null
                                  : () async {
                                      // TODO:
                                      final orderAddQrcodeModel =
                                          await showOrderAddQrcodeBtmNavSheet(
                                            context: context,
                                            productId: product?.productId,
                                            amount: product?.amount,
                                          );

                                      if (orderAddQrcodeModel != null) {
                                        final isQrcodeDoubled =
                                            _isQrcodeDoubled(
                                              orderAddQrcodeModel.qrId,
                                            );
                                        print(
                                          'isQrcodeDoubled: ${isQrcodeDoubled}',
                                        );
                                        if (isQrcodeDoubled) {
                                          // TODO: text
                                          ToastUtils.error(
                                            'Dieser QR-Code wurde bereits eingescannt.',
                                          );
                                          return;
                                        }

                                        _addQrcodeToPrepareList(
                                          productId: product?.productId,
                                          orderAddQrcodeModel:
                                              orderAddQrcodeModel,
                                        );
                                      }

                                      setState(() {});
                                    },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: K.ps),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 90.0.h,
                                      width: 90.0.h,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: K.ps * 0.5,
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          K.rs,
                                        ),
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
                                      // '${product?.amount.toString()} X',
                                      '${product?.amount} X ${_getAddesProductsLength(product?.productId)}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    K.pvsx.verticalSpace,
                                    Text(
                                      '${product?.name.toString()}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    K.pvsx.verticalSpace,
                                    Text(
                                      '${product?.productId.toString()}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    K.pvsx.verticalSpace,
                                    Transform.scale(
                                      scale: 1.2.r,
                                      child: Checkbox(
                                        // value: false,
                                        value: isAllQrcodeAdded,
                                        activeColor: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        side: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            360,
                                          ),
                                        ),
                                        // onChanged: isActive ? onChanged : null,
                                        onChanged: (val) {},
                                        // onChanged: null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            //! ****************** order infos
            OrderInfosWidget(orders: _orders),
            K.pvl.verticalSpace,
            _buildPrintShippingLabelBtn(),
            K.pvl.verticalSpace,
            // TODO: remove
            Text('_isAllProductAdded()'),
            Text(_isAllProductAdded().toString()),
            _buildOrderDoneBtn(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrintShippingLabelBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: K.pm),
      child: SizedBox(
        width: double.infinity,
        child: Consumer<ShippingLabelPrinterProvider>(
          builder: (_, provider, __) {
            return ElevatedButton.icon(
              // TODO: text
              label: const Text('Versandetikett ausdrucken'),
              icon: provider.isStatusChecking
                  ? SizedBox.square(
                      dimension: 25.0.r,
                      child: const LoadingIndicator(color: Colors.white),
                    )
                  : PrinterStatusIcon(isConnected: provider.isConnected),
              onPressed: () async {
                print('================> provider.isConnected');
                print(provider.isConnected);
                await provider.checkStatus();

                if (provider.isConnected) {
                  print('in if');
                  if (!mounted) return;
                  final companyModel = BlocEventsHelper.getSettings(
                    context,
                  ).companyModel;

                  print('companyModel');
                  print(companyModel.toMap());
                  // TODO:
                  final islabelPrinted = await provider.printLabel(
                    company: companyModel,
                    customerFullName:
                        '${_orders?.customer?.firstName} ${_orders?.customer?.lastName}',
                    shippingAddress: _orders?.shippingAddress,
                    orderNr: _orders?.orderId,
                  );

                  if (!islabelPrinted) {
                    // TODO: text
                    ToastUtils.error('Etikett konnte nicht gedruckt werden');
                  }
                } else {
                  print('in else');
                  // TODO: text
                  ToastUtils.error(
                    'Keine Verbindung zum Drucker (${provider.ipAddress}).',
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderDoneBtn() {
    return Opacity(
      opacity: _isFromDonePage ? 0.5 : 1.0,
      child: AbsorbPointer(
        absorbing: _isFromDonePage,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: K.pm),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              // TODO: text
              label: const Text('Bestellung erledigt'),
              icon: Icon(I.done),
              onPressed: () async {
                final userId = BlocEventsHelper.getUser(context)?.uId;
                final dId = _orders?.dId;

                if (userId != null && dId != null) {
                  final isDone = await Provider.of<OrderProvider>(
                    context,
                    listen: false,
                  ).orderDone(dId: dId, doneUId: userId);
                  if (!isDone) {
                    // TODO: text
                    ToastUtils.error('Keine Internetverbindung.');
                  } else {
                    if (!mounted) return;
                    context.pop();
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _addQrcodeToPrepareList({
    required int? productId,
    required OrderAddQrcodeModel orderAddQrcodeModel,
  }) {
    print('========> _addQrcodeToPrepareList()');
    print('_prepareProducts.length');
    print(_prepareProducts.length);
    for (int i = 0; i < _prepareProducts.length; i++) {
      print('============> in for');
      print('i: $i');
      final prepareProduct = _prepareProducts[i];
      print('prepareProduct.productId == productId');
      print(prepareProduct.productId == productId);
      if (prepareProduct.productId == productId) {
        List<OrderAddQrcodeModel> orderAddQrcodeModels =
            prepareProduct.orderAddQrcodeModels;
        print('length Before: ${orderAddQrcodeModels.length}');
        orderAddQrcodeModels.add(orderAddQrcodeModel);
        print('length After: ${orderAddQrcodeModels.length}');

        _prepareProducts[i] = _PrepareProduct(
          productId: prepareProduct.productId,
          orderAddQrcodeModels: orderAddQrcodeModels,
        );
        break;
      }
    }
  }

  bool _checkAllQrcodesAdded({required int? productId, required int? amount}) {
    // print('=================> _isAllQrcodeAdded()');
    for (int i = 0; i < _prepareProducts.length; i++) {
      final prepareProduct = _prepareProducts[i];
      // print('productId: ${productId}');
      // print('prepareProduct.productId: ${prepareProduct.productId}');
      // print('length: ${prepareProduct.orderAddQrcodeModels.length}');
      // print('amount: ${amount}');
      // print(prepareProduct.productId == productId);
      // if (prepareProduct.orderAddQrcodeModels.isEmpty) return false;
      if (prepareProduct.productId == productId &&
          prepareProduct.orderAddQrcodeModels.length == amount) {
        return true;
      }
    }
    return false;
  }

  bool _isQrcodeDoubled(String? qrcode) {
    print('=================> _isQrcodeDoubled()');
    if ((qrcode ?? '').isEmpty) return true;
    for (int i = 0; i < _prepareProducts.length; i++) {
      for (var addQrcodeModels in _prepareProducts[i].orderAddQrcodeModels) {
        if (addQrcodeModels.qrId == qrcode) {
          return true;
        }
      }
    }
    return false;
  }

  // TODO: last time
  bool _isAllProductAdded() {
    print('=================> _isQrcodeDoubled()');
    final orderedProducts = _orders?.orderDetails?.products ?? [];

    if (orderedProducts.isEmpty) return false;

    for (int i = 0; i < orderedProducts.length; i++) {
      // final
    }

    if (_prepareProducts.length ==
        widget.orders?.orderDetails?.products?.length) {
      // print(object);
      return true;
    }
    for (int i = 0; i < _prepareProducts.length; i++) {
      /*       for (var addQrcodeModels in _prepareProducts[i].orderAddQrcodeModels) {
         if (addQrcodeModels.qrId == qrcode) {
          return true;
        } 
      } */
    }
    return false;
  }

  int _getAddesProductsLength(int? productId) {
    // print('=================> _getProductsLength()');
    for (int i = 0; i < _prepareProducts.length; i++) {
      // print('productId: ${productId}');
      if (_prepareProducts[i].productId == productId) {
        return _prepareProducts[i].orderAddQrcodeModels.length;
      }
    }
    return 0;
  }
}

class _PrepareProduct {
  final int? productId;
  final List<OrderAddQrcodeModel> orderAddQrcodeModels;
  _PrepareProduct({
    required this.productId,
    required this.orderAddQrcodeModels,
  });
}
