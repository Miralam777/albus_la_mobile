import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// TODO: change name and place
class GenProduct {
  final int? index;
  final Timestamp? createdAt;
  final String? creator;
  final int? groupNr;
  final int? imageUrl;
  final String? id;
  final bool? manufactured;
  final String? name;
  final String? pin;
  final int? productId;
  final int? type;
  final String? uId;

  const GenProduct({
    this.index,
    this.createdAt,
    this.creator,
    this.groupNr,
    required this.imageUrl,
    this.id,
    this.manufactured,
    this.name,
    this.pin,
    this.productId,
    this.type,
    this.uId,
  });

  factory GenProduct.fromMap(Map<String, dynamic> data) => GenProduct(
        index: data['index'] as int?,
        createdAt: data['createdAt'] as Timestamp?,
        creator: data['creator'] as String?,
        groupNr: data['groupNr'] as int?,
        imageUrl: data['imageUrl'] as int?,
        id: data['id'] as String?,
        manufactured: data['manufactured'] as bool?,
        name: data['name'] as String?,
        pin: data['pin'] as String?,
        productId: data['productId'] as int?,
        type: data['type'] as int?,
        uId: data['uId'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'index': index,
        'createdAt': createdAt,
        'creator': creator,
        'groupNr': groupNr,
        'imageUrl': imageUrl,
        'id': id,
        'manufactured': manufactured,
        'name': name,
        'pin': pin,
        'productId': productId,
        'type': type,
        'uId': uId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GenProduct].
  factory GenProduct.fromJson(String data) {
    return GenProduct.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GenProduct] to a JSON string.
  String toJson() => json.encode(toMap());

  GenProduct copyWith({
    int? index,
    Timestamp? createdAt,
    String? creator,
    int? groupNr,
    String? dId,
    int? imageUrl,
    String? id,
    bool? manufactured,
    String? name,
    String? pin,
    int? productId,
    int? type,
    String? uId,
  }) {
    return GenProduct(
      index: index ?? this.index,
      createdAt: createdAt ?? this.createdAt,
      creator: creator ?? this.creator,
      groupNr: groupNr ?? this.groupNr,
      imageUrl: imageUrl ?? this.imageUrl,
      id: id ?? this.id,
      manufactured: manufactured ?? this.manufactured,
      name: name ?? this.name,
      pin: pin ?? this.pin,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      uId: uId ?? this.uId,
    );
  }

  ///! only of generat PDF
  factory GenProduct.fromMapGenPdf(Map<String, dynamic> data) => GenProduct(
        // createdAt: data['createdAt'] as Timestamp?,
        index: data['index'] as int?,
        creator: data['creator'] as String?,
        groupNr: data['groupNr'] as int?,
        imageUrl: data['imageUrl'] as int?,
        id: data['id'] as String?,
        manufactured: data['manufactured'] as bool?,
        name: data['name'] as String?,
        pin: data['pin'] as String?,
        productId: data['productId'] as int?,
        type: data['type'] as int?,
        uId: data['uId'] as String?,
      );

  Map<String, dynamic> toMapGenPdf() => {
        // 'createdAt': createdAt,
        'index': index,
        'creator': creator,
        'groupNr': groupNr,
        'imageUrl': imageUrl,
        'id': id,
        'manufactured': manufactured,
        'name': name,
        'pin': pin,
        'productId': productId,
        'type': type,
        'uId': uId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GenProduct].
  factory GenProduct.fromJsonGenPdf(String data) {
    return GenProduct.fromMapGenPdf(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GenProduct] to a JSON string.
  String toJsonGenPdf() => json.encode(toMapGenPdf());
}
