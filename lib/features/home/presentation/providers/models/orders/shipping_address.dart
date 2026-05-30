import 'dart:convert';

class ShippingAddress {
  final String? street;
  final String? houseNr;
  final String? additional;
  final String? postalCode;
  final String? city;
  final String? country;

  const ShippingAddress({
    this.street,
    this.houseNr,
    this.additional,
    this.postalCode,
    this.city,
    this.country,
  });

  factory ShippingAddress.fromMap(Map<String, dynamic> data) {
    return ShippingAddress(
      street: data['street'] as String?,
      houseNr: data['houseNr'] as String?,
      additional: data['additional'] as String?,
      postalCode: data['postalCode'] as String?,
      city: data['city'] as String?,
      country: data['country'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'street': street,
        'houseNr': houseNr,
        'additional': additional,
        'postalCode': postalCode,
        'city': city,
        'country': country,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ShippingAddress].
  factory ShippingAddress.fromJson(String data) {
    return ShippingAddress.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ShippingAddress] to a JSON string.
  String toJson() => json.encode(toMap());

  ShippingAddress copyWith({
    String? street,
    String? houseNr,
    String? additional,
    String? postalCode,
    String? city,
    String? country,
  }) {
    return ShippingAddress(
      street: street ?? this.street,
      houseNr: houseNr ?? this.houseNr,
      additional: additional ?? this.additional,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }
}
