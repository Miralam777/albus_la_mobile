import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductGroupModel {
  final String? dId;
  final int? pId;
  final int? pType;
  final String? pName;
  final String? name;
  final int? groupNr;
  final int? quantity;
  final int? validityYears;
  final String? description;
  final Timestamp? created;
  final String? creator;
  final bool? deletable;

  const ProductGroupModel({
    this.dId,
    this.pId,
    this.pType,
    this.pName,
    this.name,
    this.groupNr,
    this.quantity,
    this.validityYears,
    this.description,
    this.created,
    this.creator,
    this.deletable,
  });

  factory ProductGroupModel.fromMap(Map<String, dynamic> data) =>
      ProductGroupModel(
        dId: data['dId'] as String?,
        pId: data['pId'] as int?,
        pType: data['pType'] as int?,
        pName: data['pName'] as String?,
        name: data['name'] as String?,
        groupNr: data['groupNr'] as int?,
        quantity: data['quantity'] as int?,
        validityYears: data['validityYears'] as int?,
        description: data['description'] as String?,
        created: data['created'] as Timestamp?,
        creator: data['creator'] as String?,
        deletable: data['deletable'] as bool?,
      );

  Map<String, dynamic> toMap() => {
    'dId': dId,
    'pId': pId,
    'pType': pType,
    'pName': pName,
    'name': name,
    'groupNr': groupNr,
    'quantity': quantity,
    'validityYears': validityYears,
    'description': description,
    'created': created,
    'creator': creator,
    'deletable': deletable,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProductGroupModel].
  factory ProductGroupModel.fromJson(String data) {
    return ProductGroupModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProductGroupModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ProductGroupModel copyWith({
    String? dId,
    int? pId,
    int? pType,
    String? pName,
    String? name,
    int? groupNr,
    int? quantity,
    int? validityYears,
    String? description,
    Timestamp? created,
    String? creator,
    bool? deletable,
  }) {
    return ProductGroupModel(
      dId: dId ?? this.dId,
      pId: pId ?? this.pId,
      pType: pType ?? this.pType,
      pName: pName ?? this.pName,
      name: name ?? this.name,
      groupNr: groupNr ?? this.groupNr,
      quantity: quantity ?? this.quantity,
      validityYears: validityYears ?? this.validityYears,
      description: description ?? this.description,
      created: created ?? this.created,
      creator: creator ?? this.creator,
      deletable: deletable ?? this.deletable,
    );
  }
}
