import 'dart:convert';

import 'package:equatable/equatable.dart';

class SignIn extends Equatable {
  final String? apiKey;
  final String email;
  final String password;
  final String fcm;

  const SignIn({
    this.apiKey,
    required this.email,
    required this.password,
    required this.fcm,
  });

  factory SignIn.fromMap(Map<String, dynamic> data) => SignIn(
        apiKey: data['apiKey'] as String?,
        email: data['email'],
        password: data['password'],
        fcm: data['fcm'],
      );

  Map<String, dynamic> toMap() => {
        'apiKey': apiKey,
        'email': email,
        'password': password,
        'fcm': fcm,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SignIn].
  factory SignIn.fromJson(String data) {
    return SignIn.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SignIn] to a JSON string.
  String toJson() => json.encode(toMap());

  SignIn copyWith({
    String? apiKey,
    String? email,
    String? password,
    String? fcm,
  }) {
    return SignIn(
      apiKey: apiKey ?? this.apiKey,
      email: email ?? this.email,
      password: password ?? this.password,
      fcm: fcm ?? this.fcm,
    );
  }

  @override
  List<Object?> get props {
    return [apiKey, email, password, fcm];
  }
}
