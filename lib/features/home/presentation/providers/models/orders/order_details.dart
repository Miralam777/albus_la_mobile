import 'dart:convert';

import 'package:albus_la_mobile/features/home/presentation/providers/models/product/product.dart';

class OrderDetails {
  final List<Product>? products;
  final int? totalPrice;
  final int? shippingCost;
  final int? tax;

  const OrderDetails({
    this.products,
    this.totalPrice,
    this.shippingCost,
    this.tax,
  });

  factory OrderDetails.fromMap(Map<String, dynamic> data) => OrderDetails(
    products: (data['products'] as List<dynamic>?)
        ?.map((e) => Product.fromMap(e as Map<String, dynamic>))
        .toList(),
    totalPrice: (data['totalPrice'] as num?)?.toInt(),
    shippingCost: data['shippingCost'] as int?,
    tax: (data['tax'] as num?)?.toInt(),
  );

  Map<String, dynamic> toMap() => {
    'products': products?.map((e) => e.toMap()).toList(),
    'totalPrice': totalPrice,
    'shippingCost': shippingCost,
    'tax': tax,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderDetails].
  factory OrderDetails.fromJson(String data) {
    return OrderDetails.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OrderDetails] to a JSON string.
  String toJson() => json.encode(toMap());

  OrderDetails copyWith({
    List<Product>? products,
    int? subtotal,
    int? totalPrice,
    int? shippingCost,
    int? tax,
  }) {
    return OrderDetails(
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      shippingCost: shippingCost ?? this.shippingCost,
      tax: tax ?? this.tax,
    );
  }
}
