import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:albus_la_mobile/features/add_product_id/domain/entities/added_id.dart';

class AddedIdModel extends AddedId {
  const AddedIdModel({
    super.createdAt,
    super.creator,
    super.imageUrl,
    super.id,
    super.manufactured,
    super.name,
    super.pin,
    super.productId,
    super.type,
    super.uId,
  });

  factory AddedIdModel.fromMap(Map<String, dynamic> data) => AddedIdModel(
    createdAt: Timestamp(
      data['createdAt']['_seconds'] ?? 0,
      data['createdAt']['_nanoseconds'] ?? 0,
    ),
    // createdAt: data['createdAt'] as Timestamp?,
    creator: data['creator'] as String?,
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
    'createdAt': createdAt,
    'creator': creator,
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
  /// Parses the string and returns the resulting Json object as [AddedIdModel].
  factory AddedIdModel.fromJson(String data) {
    return AddedIdModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AddedIdModel] to a JSON string.
  String toJson() => json.encode(toMap());

  AddedIdModel copyWith({
    Timestamp? createdAt,
    String? creator,
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
    return AddedIdModel(
      createdAt: createdAt ?? this.createdAt,
      creator: creator ?? this.creator,
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
}
