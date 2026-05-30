import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// TODO: shuld be like cmc qrcode modle
class OrderAddQrcodeModel {
  final String? dId;
  final Timestamp? createdAt;
  final bool? isActive;
  final String? name;
  final String? type;
  final String? description;
  final String? scanMessage;
  final int? iconId;
  final String? qrId;
  final String? uId;

  const OrderAddQrcodeModel({
    this.dId,
    this.createdAt,
    this.isActive,
    this.name,
    this.type,
    this.description,
    this.scanMessage,
    this.iconId,
    this.uId,
    this.qrId,
  });

  factory OrderAddQrcodeModel.fromMap(Map<String, dynamic> data) =>
      OrderAddQrcodeModel(
        dId: data['dId'] as String?,
        createdAt: data['createdAt'] as Timestamp?,
        isActive: data['isActive'] as bool?,
        name: data['name'] as String?,
        type: data['type'] as String?,
        description: data['description'] as String?,
        scanMessage: data['scanMessage'] as String?,
        iconId: data['iconId'] as int?,
        qrId: data['qrId'] as String?,
        uId: data['uId'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'dId': dId,
        'createdAt': createdAt,
        'isActive': isActive,
        'name': name,
        'type': type,
        'description': description,
        'scanMessage': scanMessage,
        'iconId': iconId,
        'qrId': qrId,
        'uId': uId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderAddQrcodeModel].
  factory OrderAddQrcodeModel.fromJson(String data) {
    return OrderAddQrcodeModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OrderAddQrcodeModel] to a JSON string.
  String toJson() => json.encode(toMap());

  OrderAddQrcodeModel copyWith({
    String? dId,
    Timestamp? createdAt,
    bool? isActive,
    String? name,
    String? type,
    String? description,
    String? scanMessage,
    int? iconId,
    String? qrId,
    String? uId,
  }) {
    return OrderAddQrcodeModel(
      dId: dId ?? this.dId,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      scanMessage: scanMessage ?? this.scanMessage,
      iconId: iconId ?? this.iconId,
      qrId: qrId ?? this.qrId,
      uId: uId ?? this.uId,
    );
  }
}

// TODO: clean
/* class OrderAddQrcodeModel extends AddedQrcode {
  const OrderAddQrcodeModel({
    super.dId,
    super.createdAt,
    super.isActive,
    super.manufactured,
    super.name,
    super.type,
    super.description,
    super.scanMessage,
    super.iconId,
    super.qrId,
    super.uId,
    super.creator,
  });

  factory OrderAddQrcodeModel.fromMap(Map<String, dynamic> data) =>
      OrderAddQrcodeModel(
        dId: data['dId'] as String?,
/*         createdAt: Timestamp(
          data['createdAt']['_seconds'] ?? 0,
          data['createdAt']['_nanoseconds'] ?? 0,
        ), */
        createdAt: data['createdAt'] as Timestamp?,
        isActive: data['isActive'] as bool?,
        manufactured: data['manufactured'] as bool?,
        name: data['name'] as String?,
        type: data['type'] as String?,
        description: data['description'] as String?,
        scanMessage: data['scanMessage'] as String?,
        iconId: data['iconId'] as int?,
        qrId: data['qrId'] as String?,
        uId: data['uId'] as String?,
        creator: data['creator'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'dId': dId,
        'createdAt': createdAt,
        'isActive': isActive,
        'manufactured': manufactured,
        'name': name,
        'type': type,
        'description': description,
        'scanMessage': scanMessage,
        'iconId': iconId,
        'qrId': qrId,
        'uId': uId,
        'creator': creator,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderAddQrcodeModel].
  factory OrderAddQrcodeModel.fromJson(String data) {
    return OrderAddQrcodeModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OrderAddQrcodeModel] to a JSON string.
  String toJson() => json.encode(toMap());

  OrderAddQrcodeModel copyWith({
    String? dId,
    Timestamp? createdAt,
    bool? isActive,
    bool? manufactured,
    String? name,
    String? type,
    String? description,
    String? scanMessage,
    int? iconId,
    String? qrId,
    String? uId,
    String? creator,
  }) {
    return OrderAddQrcodeModel(
      dId: dId ?? this.dId,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      manufactured: manufactured ?? this.manufactured,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      scanMessage: scanMessage ?? this.scanMessage,
      iconId: iconId ?? this.iconId,
      qrId: qrId ?? this.qrId,
      uId: uId ?? this.uId,
      creator: creator ?? this.creator,
    );
  }
}

 */
