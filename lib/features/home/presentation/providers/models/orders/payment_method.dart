import 'dart:convert';

class PaymentMethod {
  final String? method;
  final String? cardNumber;
  final String? expiryDate;

  const PaymentMethod({this.method, this.cardNumber, this.expiryDate});

  factory PaymentMethod.fromMap(Map<String, dynamic> data) => PaymentMethod(
        method: data['method'] as String?,
        cardNumber: data['cardNumber'] as String?,
        expiryDate: data['expiryDate'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'method': method,
        'cardNumber': cardNumber,
        'expiryDate': expiryDate,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PaymentMethod].
  factory PaymentMethod.fromJson(String data) {
    return PaymentMethod.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PaymentMethod] to a JSON string.
  String toJson() => json.encode(toMap());

  PaymentMethod copyWith({
    String? method,
    String? cardNumber,
    String? expiryDate,
  }) {
    return PaymentMethod(
      method: method ?? this.method,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}
