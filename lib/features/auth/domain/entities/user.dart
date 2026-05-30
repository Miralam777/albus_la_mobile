import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uId;
  final String uName;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final String email;
  final bool emailVerified;

  const User({
    required this.uId,
    required this.uName,
    required this.createdAt,
    required this.lastLoginAt,
    required this.email,
    required this.emailVerified,
  });

  @override
  List<Object?> get props {
    return [
      uId,
      uName,
      createdAt,
      lastLoginAt,
      email,
      emailVerified,
    ];
  }
}
