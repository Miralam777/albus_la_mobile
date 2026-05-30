import 'dart:convert';

class BillingAddress {
  final String? street;
  final String? houseNr;
  final String? additional;
  final String? postalCode;
  final String? city;
  final String? country;
  final String? company;

  const BillingAddress({
    this.street,
    this.houseNr,
    this.additional,
    this.postalCode,
    this.city,
    this.country,
    this.company,
  });

  factory BillingAddress.fromMap(Map<String, dynamic> data) {
    return BillingAddress(
      street: data['street'] as String?,
      houseNr: data['houseNr'] as String?,
      additional: data['additional'] as String?,
      postalCode: data['postalCode'] as String?,
      city: data['city'] as String?,
      country: data['country'] as String?,
      company: data['company'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'street': street,
        'houseNr': houseNr,
        'additional': additional,
        'postalCode': postalCode,
        'city': city,
        'country': country,
        'company': company,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [BillingAddress].
  factory BillingAddress.fromJson(String data) {
    return BillingAddress.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [BillingAddress] to a JSON string.
  String toJson() => json.encode(toMap());

  BillingAddress copyWith({
    String? street,
    String? houseNr,
    String? additional,
    String? postalCode,
    String? city,
    String? country,
    String? company,
  }) {
    return BillingAddress(
      street: street ?? this.street,
      houseNr: houseNr ?? this.houseNr,
      additional: additional ?? this.additional,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      country: country ?? this.country,
      company: company ?? this.company,
    );
  }
}
