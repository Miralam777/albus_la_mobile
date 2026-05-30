import 'dart:convert';
import 'package:albus_la_mobile/features/home/domain/entities/home_qr_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeQrCodeModel extends HomeQrCode {
  const HomeQrCodeModel({
    required super.createdAt,
    required super.isActive,
    required super.name,
    required super.type,
    required super.description,
    required super.scanMessage,
    required super.iconId,
    required super.uId,
    required super.qrId,
  });

  factory HomeQrCodeModel.fromMap(Map<String, dynamic> data) {
    return HomeQrCodeModel(
      // TODO: type time stamp
      createdAt: data['createdAt'],
      isActive: data['isActive'] as bool?,
      name: data['name'] as String?,
      type: data['type'] as String?,
      description: data['description'] as String?,
      scanMessage: data['scanMessage'] as String?,
      iconId: data['iconId'] as int?,
      uId: data['uId'] as String?,
      qrId: data['qrId'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'createdAt': createdAt,
    'isActive': isActive,
    'name': name,
    'type': type,
    'description': description,
    'scanMessage': scanMessage,
    'iconId': iconId,
    'uId': uId,
    'qrId': qrId,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [HomeQrCodeModel].
  factory HomeQrCodeModel.fromJson(String data) {
    return HomeQrCodeModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [HomeQrCodeModel] to a JSON string.
  String toJson() => json.encode(toMap());

  HomeQrCodeModel copyWith({
    Timestamp? createdAt,
    bool? isActive,
    String? name,
    String? type,
    String? description,
    String? scanMessage,
    int? iconId,
    String? uId,
    String? qrId,
  }) {
    return HomeQrCodeModel(
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      scanMessage: scanMessage ?? this.scanMessage,
      iconId: iconId ?? this.iconId,
      uId: uId ?? this.uId,
      qrId: qrId ?? this.qrId,
    );
  }
}
