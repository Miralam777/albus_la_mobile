import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class License {
  final String? dId;
  final int? licenseId;
  final bool? isActive;
  final String? name;
  final String? description;
  final int? amount;
  final int? price;
  final int? avt;
  final String? currency;
  final Timestamp? created;

  const License({
    this.dId,
    this.licenseId,
    this.isActive,
    this.name,
    this.description,
    this.amount,
    this.price,
    this.avt,
    this.currency,
    this.created,
  });

  factory License.fromMap(Map<String, dynamic> data) => License(
        dId: data['dId'] as String?,
        licenseId: data['licenseId'] as int?,
        isActive: data['isActive'] as bool?,
        name: data['name'] as String?,
        description: data['description'] as String?,
        amount: data['amount'] as int?,
        price: data['price'] as int?,
        avt: data['avt'] as int?,
        currency: data['currency'] as String?,
        created: data['created'].runtimeType == String
            ? Timestamp.fromDate(DateTime.parse(data['created']))
            : data['created'] as Timestamp?,
      );

  Map<String, dynamic> toMap() => {
        'dId': dId,
        'licenseId': licenseId,
        'isActive': isActive,
        'name': name,
        'description': description,
        'amount': amount,
        'price': price,
        'avt': avt,
        'currency': currency,
        'created': created,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [License].
  factory License.fromJson(String data) {
    return License.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [License] to a JSON string.
  String toJson() => json.encode(toMap());

  License copyWith({
    String? dId,
    int? licenseId,
    bool? isActive,
    String? name,
    String? description,
    int? amount,
    int? price,
    int? avt,
    String? currency,
    Timestamp? created,
  }) {
    return License(
      dId: dId ?? this.dId,
      licenseId: licenseId ?? this.licenseId,
      isActive: isActive ?? this.isActive,
      name: name ?? this.name,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      avt: avt ?? this.avt,
      currency: currency ?? this.currency,
      created: created ?? this.created,
    );
  }
}
