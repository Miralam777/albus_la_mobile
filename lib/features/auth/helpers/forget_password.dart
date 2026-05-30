import 'dart:convert';

import 'package:equatable/equatable.dart';

class ForgetPassword extends Equatable {
  final String? apiKey;
  final String email;

  const ForgetPassword({this.apiKey, required this.email});

  factory ForgetPassword.fromMap(Map<String, dynamic> data) => ForgetPassword(
        apiKey: data['apiKey'] as String?,
        email: data['email'],
      );

  Map<String, dynamic> toMap() => {
        'apiKey': apiKey,
        'email': email,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ForgetPassword].
  factory ForgetPassword.fromJson(String data) {
    return ForgetPassword.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ForgetPassword] to a JSON string.
  String toJson() => json.encode(toMap());

  ForgetPassword copyWith({
    String? apiKey,
    String? email,
  }) {
    return ForgetPassword(
      apiKey: apiKey ?? this.apiKey,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props {
    return [apiKey, email];
  }
}
