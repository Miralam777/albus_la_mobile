import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'billing_address.dart';
import 'consent.dart';
import 'customer.dart';
import 'order_details.dart';
import 'payment_method.dart';
import 'shipping_address.dart';

class Orders {
  final String? apiKey;
  final String? dId;
  final String? uId;
  final int? orderId;
  final bool? inWork;
  final bool? isDone;
  final Timestamp? doneDate;
  final String? doneUId;
  final Timestamp? created;
  final Customer? customer;
  final ShippingAddress? shippingAddress;
  final BillingAddress? billingAddress;
  final PaymentMethod? paymentMethod;
  final OrderDetails? orderDetails;
  final Consent? consent;
  final Map<dynamic, dynamic>? payParms;

  const Orders({
    this.apiKey,
    this.dId,
    this.uId,
    this.orderId,
    this.inWork,
    this.isDone,
    this.created,
    this.doneDate,
    this.doneUId,
    this.customer,
    this.shippingAddress,
    this.billingAddress,
    this.paymentMethod,
    this.orderDetails,
    this.consent,
    this.payParms,
  });

  factory Orders.fromMap(Map<String, dynamic> data) => Orders(
        apiKey: data['apiKey'] as String?,
        dId: data['dId'] as String?,
        uId: data['uId'] as String?,
        orderId: (data['orderId'] as num).toInt() as int?,
        inWork: data['inWork'] as bool?,
        isDone: data['isDone'] as bool?,
        doneDate: data['doneDate'] as Timestamp?,
        doneUId: data['doneUId'] as String?,
        created: data['created'] as Timestamp?,
        customer: data['customer'] == null
            ? null
            : Customer.fromMap(data['customer'] as Map<String, dynamic>),
        shippingAddress: data['shippingAddress'] == null
            ? null
            : ShippingAddress.fromMap(
                data['shippingAddress'] as Map<String, dynamic>),
        billingAddress: data['billingAddress'] == null
            ? null
            : BillingAddress.fromMap(
                data['billingAddress'] as Map<String, dynamic>),
        paymentMethod: data['paymentMethod'] == null
            ? null
            : PaymentMethod.fromMap(
                data['paymentMethod'] as Map<String, dynamic>),
        orderDetails: data['orderDetails'] == null
            ? null
            : OrderDetails.fromMap(
                data['orderDetails'] as Map<String, dynamic>),
        consent: data['consent'] == null
            ? null
            : Consent.fromMap(data['consent'] as Map<String, dynamic>),
        payParms: data['payParms'] as Map<dynamic, dynamic>?,
      );

  Map<String, dynamic> toMap() => {
        'apiKey': apiKey,
        'dId': dId,
        'uId': uId,
        'orderId': orderId,
        'inWork': inWork,
        'isDone': isDone,
        'doneDate': doneDate,
        'doneUId': doneUId,
        'created': created,
        'customer': customer?.toMap(),
        'shippingAddress': shippingAddress?.toMap(),
        'billingAddress': billingAddress?.toMap(),
        'paymentMethod': paymentMethod?.toMap(),
        'orderDetails': orderDetails?.toMap(),
        'consent': consent?.toMap(),
        'payParms': payParms,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Orders].
  factory Orders.fromJson(String data) {
    return Orders.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Orders] to a JSON string.
  String toJson() => json.encode(toMap());

  Orders copyWith({
    String? apiKey,
    String? dId,
    String? uId,
    int? orderId,
    bool? inWork,
    bool? isDone,
    Timestamp? doneDate,
    String? doneUId,
    Timestamp? created,
    Customer? customer,
    ShippingAddress? shippingAddress,
    BillingAddress? billingAddress,
    PaymentMethod? paymentMethod,
    OrderDetails? orderDetails,
    Consent? consent,
    Map<dynamic, dynamic>? payParms,
  }) {
    return Orders(
      apiKey: apiKey ?? this.apiKey,
      dId: dId ?? this.dId,
      uId: uId ?? this.uId,
      orderId: orderId ?? this.orderId,
      inWork: inWork ?? this.inWork,
      isDone: isDone ?? this.isDone,
      doneDate: doneDate ?? this.doneDate,
      doneUId: doneUId ?? this.doneUId,
      created: created ?? this.created,
      customer: customer ?? this.customer,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderDetails: orderDetails ?? this.orderDetails,
      consent: consent ?? this.consent,
      payParms: payParms ?? this.payParms,
    );
  }
}
