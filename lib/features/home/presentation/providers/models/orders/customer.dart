import 'dart:convert';

class Customer {
  final String? uId;
  final String? title;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;

  const Customer({
    this.uId,
    this.title,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  factory Customer.fromMap(Map<String, dynamic> data) => Customer(
        uId: data['uId'] as String?,
        title: data['title'] as String?,
        firstName: data['firstName'] as String?,
        lastName: data['lastName'] as String?,
        email: data['email'] as String?,
        phone: data['phone'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'uId': uId,
        'title': title,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Customer].
  factory Customer.fromJson(String data) {
    return Customer.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Customer] to a JSON string.
  String toJson() => json.encode(toMap());

  Customer copyWith({
    String? uId,
    String? title,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) {
    return Customer(
      uId: uId ?? this.uId,
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
