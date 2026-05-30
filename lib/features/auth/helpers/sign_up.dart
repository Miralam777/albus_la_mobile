import 'dart:convert';

import 'package:equatable/equatable.dart';

class SignUp extends Equatable {
  final String? apiKey;
  final String email;
  final String password;
  final String uName;
  final String fcm;

  const SignUp({
    this.apiKey,
    required this.email,
    required this.password,
    required this.uName,
    required this.fcm,
  });

  factory SignUp.fromMap(Map<String, dynamic> data) => SignUp(
        apiKey: data['apiKey'] as String?,
        email: data['email'],
        password: data['password'],
        uName: data['uName'],
        fcm: data['fcm'],
      );

  Map<String, dynamic> toMap() => {
        'apiKey': apiKey,
        'email': email,
        'password': password,
        'uName': uName,
        'fcm': fcm,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SignUp].
  factory SignUp.fromJson(String data) {
    return SignUp.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SignUp] to a JSON string.
  String toJson() => json.encode(toMap());

  SignUp copyWith({
    String? apiKey,
    String? email,
    String? password,
    String? uName,
    String? fcm,
  }) {
    return SignUp(
      apiKey: apiKey ?? this.apiKey,
      email: email ?? this.email,
      password: password ?? this.password,
      uName: uName ?? this.uName,
      fcm: fcm ?? this.fcm,
    );
  }

  @override
  List<Object?> get props {
    return [apiKey, email, password, uName, fcm];
  }
}
