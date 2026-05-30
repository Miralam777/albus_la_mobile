import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AddedId extends Equatable {
  final Timestamp? createdAt;
  final String? creator;
  // final String? dId;
  final int? imageUrl;
  final String? id;
  final bool? manufactured;
  final String? name;
  final String? pin;
  final int? productId;
  final int? type;
  final String? uId;

  const AddedId({
    this.createdAt,
    this.creator,
    // this.dId,
    this.imageUrl,
    this.id,
    this.manufactured,
    this.name,
    this.pin,
    this.productId,
    this.type,
    this.uId,
  });

  @override
  List<Object?> get props => [
        createdAt,
        creator,
        // dId,
        imageUrl,
        id,
        manufactured,
        name,
        pin,
        productId,
        type,
        uId,
      ];
}
