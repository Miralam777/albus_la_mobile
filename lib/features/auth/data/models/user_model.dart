import 'dart:convert';

import 'package:albus_la_mobile/features/auth/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends User {
  const UserModel({
    required super.uId,
    required super.uName,
    required super.createdAt,
    required super.lastLoginAt,
    required super.email,
    required super.emailVerified,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    // TODO: clean
    print('data[createdAt]');
    /* print(
      Timestamp.fromMillisecondsSinceEpoch(
        data['createdAt'].millisecondsSinceEpoch,
      ),
    ); */
    /* final time = Timestamp.fromMicrosecondsSinceEpoch(
      data['createdAt']['_seconds'] * 1000000 +
          data['createdAt']['_nanoseconds'] ~/ 1000,
    ); */
    // TODO:
    /*   final time = Timestamp(
      data['createdAt']['_seconds'] as int ?? 0,
      data['createdAt']['_nanoseconds'] as int ?? 0,
    ); 
    print(time);
    print(time.toDate());
    */
    return UserModel(
      uId: data['uId'],
      uName: data['uName'],
      /* createdAt: Timestamp(
        data['createdAt']['_seconds'] as int ?? 0,
        data['createdAt']['_nanoseconds'] as int ?? 0,
      ),
      lastLoginAt: Timestamp(
        data['lastLoginAt']['_seconds'] as int ?? 0,
        data['lastLoginAt']['_nanoseconds'] as int ?? 0,
      ), */
      // TODO:
      createdAt: null,
      lastLoginAt: null,
      email: data['email'],
      emailVerified: data['emailVerified'],
    );
  }

  Map<String, dynamic> toMap() => {
    'uId': uId,
    'uName': uName,
    // TODO: toString is false
    'createdAt': createdAt.toString(),
    'lastLoginAt': lastLoginAt.toString(),
    'email': email,
    'emailVerified': emailVerified,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserModel].
  factory UserModel.fromJson(String data) {
    return UserModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserModel] to a JSON string.
  String toJson() => json.encode(toMap());

  UserModel copyWith({
    String? uId,
    String? uName,
    String? lastName,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? email,
    bool? emailVerified,
    List<String>? chats,
  }) {
    return UserModel(
      uId: uId ?? this.uId,
      email: email ?? this.email,
      uName: uName ?? this.uName,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }
}
