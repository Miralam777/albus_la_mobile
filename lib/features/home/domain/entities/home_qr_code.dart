import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class HomeQrCode extends Equatable {
  final Timestamp? createdAt;
  final bool? isActive;
  final String? name;
  final String? type;
  final String? description;
  final String? scanMessage;
  final int? iconId;
  final String? qrId;
  final String? uId;

  const HomeQrCode({
    this.createdAt,
    this.name,
    this.type,
    this.description,
    this.scanMessage,
    this.isActive,
    this.iconId,
    this.uId,
    this.qrId,
  });

  @override
  List<Object?> get props => [
        createdAt,
        isActive,
        name,
        type,
        description,
        scanMessage,
        iconId,
        uId,
        qrId,
      ];
}
