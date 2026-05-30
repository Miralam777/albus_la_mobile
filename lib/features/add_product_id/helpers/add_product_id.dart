import 'dart:convert';

import 'package:equatable/equatable.dart';

class AddProductId extends Equatable {
  final String? uId;
  final int? type;
  final int? productId;
  final String? name;
  final int? iconId;

  const AddProductId({
    required this.uId,
    required this.type,
    required this.productId,
    required this.name,
    required this.iconId,
  });

  factory AddProductId.fromMap(Map<String, dynamic> data) => AddProductId(
        uId: data['uId'],
        type: data['type'],
        productId: data['productId'],
        name: data['name'],
        iconId: data['iconId'],
      );

  Map<String, dynamic> toMap() => {
        'uId': uId,
        'type': type,
        'productId': productId,
        'name': name,
        'iconId': iconId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AddProductId].
  factory AddProductId.fromJson(String data) {
    return AddProductId.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AddProductId] to a JSON string.
  String toJson() => json.encode(toMap());

  AddProductId copyWith({
    String? uId,
    int? type,
    int? productId,
    String? name,
    int? iconId,
  }) {
    return AddProductId(
      uId: uId ?? this.uId,
      type: type ?? this.type,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      iconId: iconId ?? this.iconId,
    );
  }

  @override
  List<Object?> get props => [uId, type, productId, name, iconId];
}
